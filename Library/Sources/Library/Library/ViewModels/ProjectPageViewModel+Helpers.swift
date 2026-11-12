import Experimentation
import Foundation
import GraphAPI
import KsApi
import Prelude
import ReactiveSwift
import ServerDrivenUI

internal func fetchProjectPage(
  projectOrParam: Either<Project, any ProjectPageParam>,
  afterAddingSecretRewardToken token: String?
) -> SignalProducer<Project, ErrorEnvelope> {
  // TODO: We're posting this mutation more frequently than we need to.
  // Instead of on every fetch, this should be moved out to only happen on `viewDidLoad`
  // and session login.
  RewardsUseCase.addUserToSecretRewardGroupIfNeeded(
    project: projectOrParam.param,
    secretRewardToken: token
  )
  .then(fetchProjectPage(projectOrParam: projectOrParam))
}

internal func fetchProjectPage(
  projectOrParam: Either<Project, any ProjectPageParam>
) -> SignalProducer<Project, ErrorEnvelope> {
  let param = projectOrParam.param
  let fetcher = ProjectPageFetcher(withService: AppEnvironment.current.apiService)

  let experiment = InstantPledgeButtonExperiment()
  if experiment.boolValue(forKey: .instant_pledge_enabled) == true {
    return fetcher.fastFetchProjectPage(
      projectParam: param.param,
      includeStoryRichText: featureProjectStoryRichTextEnabled()
    )
    .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
  }

  return fetcher.fetchProjectPage(
    projectParam: param.param,
    includeStoryRichText: featureProjectStoryRichTextEnabled()
  )
  .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
}

internal func shouldGoToManagePledge(with ctaType: PledgeStateCTAType) -> Bool {
  switch ctaType {
  case .fix, .viewBacking, .manage:
    return true
  default:
    return false
  }
}

internal extension Either where A == Project, B == ProjectPageParam {
  var param: Param {
    switch self {
    case let .left(project):
      return Param.id(project.id)
    case let .right(projectParam):
      return projectParam.param
    }
  }
}

internal extension Either where A == Project, B == any ProjectPageParam {
  /// Whether the view model can emit stale preview data while waiting for the full project reload.
  var canDisplayProjectPreview: Bool {
    if let right = self.right, right.initialProject != nil {
      return true
    }
    if self.left != nil {
      return true
    }
    return false
  }
}

internal func makeProjectPageTabData(
  navSection: NavigationSection,
  project: Project,
  refTag: RefTag?
) -> (NavigationSection, Project, RefTag?, [Bool], [URL], ProjectPageContentView) {
  let initialIsExpandedArray = Array(
    repeating: false,
    count: project.extendedProjectProperties?.faqs.count ?? 0
  )

  var urls: [URL] = []
  var contentView: ProjectPageContentView = .tableView

  if navSection == .campaign {
    if featureProjectStoryRichTextEnabled(),
       let richText = project.extendedProjectProperties?.story.richText?.asRichTextElements() {
      contentView = .richTextView(richText)
    }

    let imageViewElements = project.extendedProjectProperties?.story.htmlViewElements
      .compactMap { $0 as? ImageViewElement } ?? []

    if !imageViewElements.isEmpty {
      urls = imageViewElements.compactMap { URL(string: $0.src) }
    }
  }

  return (navSection, project, refTag, initialIsExpandedArray, urls, contentView)
}

internal func bindProjectPageTracking(
  configDataSignal: Signal<(Either<Project, any ProjectPageParam>, RefInfo?, String?), Never>,
  freshProject: Signal<Project, Never>,
  freshProjectAndRefTag: Signal<(Project, RefTag?), Never>,
  viewDidAppearAnimatedSignal: Signal<Bool, Never>,
  blockUserSignal: Signal<Int, Never>,
  blockUserSuccessSignal: Signal<Void, Never>
) {
  let cookieRefTag: Signal<RefTag?, Never> = freshProjectAndRefTag
    .map { cookieRefTagFor(project: $0.0) ?? $0.1 }
    .take(first: 1)

  let trackFreshProjectAndRefTagViewed = Signal.zip(
    freshProjectAndRefTag,
    viewDidAppearAnimatedSignal.ignoreValues()
  )
  .map(unpack)
  .map { project, refTag, _ in (project: project, refTag: refTag) }

  trackFreshProjectAndRefTagViewed
    .observeValues { project, refTag in
      AppEnvironment.current.ksrAnalytics.trackProjectViewed(
        project,
        refTag: refTag,
        sectionContext: .overview
      )
    }

  trackFreshProjectAndRefTagViewed
    .observeValues { project, _ in
      AppEnvironment.current.appTrackingTransparency.updateAdvertisingIdentifier()
      guard let externalId = AppEnvironment.current.appTrackingTransparency.advertisingIdentifier
      else { return }

      let userId = AppEnvironment.current.currentUser.map { "\($0.id)" } ?? ""
      var extInfo = Array(repeating: "", count: 16)
      extInfo[0] = "i2"
      extInfo[4] = AppEnvironment.current.mainBundle.platformVersion

      _ = AppEnvironment.current.apiService.triggerThirdPartyEventInput(
        input: .init(
          deviceId: externalId,
          eventName: ThirdPartyEventInputName.ProjectPageViewed.rawValue,
          projectId: "\(project.id)",
          pledgeAmount: nil,
          shipping: nil,
          transactionId: nil,
          userId: userId,
          appData: .init(advertiserTrackingEnabled: true, applicationTrackingEnabled: true, extinfo: extInfo),
          clientMutationId: ""
        )
      )
    }

  configDataSignal
    .combineLatest(with: freshProjectAndRefTag)
    .map { ($1.0.graphID, $0.1) }
    .take(first: 1)
    .flatMap { graphId, refInfo in
      let input = GraphAPI.CreateAttributionEventInput(
        eventName: AttributionTracking.AttributionEvent.projectPageViewed.rawValue,
        eventProperties: GraphQLNullable.someOrNil(AttributionTracking.eventParametersString(refInfo: refInfo)),
        projectId: GraphQLNullable.someOrNil(graphId)
      )
      return AppEnvironment.current.apiService.createAttributionEvent(input: input)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }
    .observeCompleted {}

  Signal.combineLatest(cookieRefTag.skipNil(), freshProjectAndRefTag.map(first))
    .take(first: 1)
    .map(cookieFrom(refTag:project:))
    .skipNil()
    .observeValues { AppEnvironment.current.cookieStorage.setCookie($0) }

  blockUserSignal
    .combineLatest(with: freshProject)
    .observeValues { blockedUserId, project in
      AppEnvironment.current.ksrAnalytics.trackBlockedUser(
        project,
        page: .project,
        sectionContext: .overview,
        locationContext: .creatorDetailsMenu,
        typeContext: .initiate,
        targetUserId: "\(blockedUserId)"
      )
    }

  blockUserSignal
    .combineLatest(with: freshProject)
    .takeWhen(blockUserSuccessSignal)
    .observeValues { blockedUserId, project in
      AppEnvironment.current.ksrAnalytics.trackBlockedUser(
        project,
        page: .project,
        sectionContext: .overview,
        locationContext: .creatorDetailsMenu,
        typeContext: .confirm,
        targetUserId: "\(blockedUserId)"
      )
    }
}

