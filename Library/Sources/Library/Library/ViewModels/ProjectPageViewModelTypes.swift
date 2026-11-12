import Experimentation
import Foundation
import KsApi
import Prelude
import ReactiveSwift
import ServerDrivenUI

/// Content presentation mode for the active tab of the project page.
public enum ProjectPageContentView: Equatable {
  /// Standard table view rendering.
  case tableView
  /// Rich text view rendering parsed campaign story elements.
  case richTextView([RichTextElement])

  /// Compares two `ProjectPageContentView` values for equality.
  public static func == (lhs: ProjectPageContentView, rhs: ProjectPageContentView) -> Bool {
    switch (lhs, rhs) {
    case (.tableView, .tableView):
      return true
    case let (.richTextView(leftRichText), .richTextView(rightRichText)):
      return leftRichText == rightRichText
    default:
      return false
    }
  }
}

/// Abstracts project lookup parameters alongside an optional preloaded summary model.
public protocol ProjectPageParam {
  /// Parameter identifying the project by ID or slug.
  var param: Param { get }
  /// Optional lightweight project configuration used for preview rendering.
  var initialProject: (any ProjectPamphletMainCellConfiguration)? { get }
}

/// Concrete wrapper pairing a `Param` with an optional preloaded cell configuration.
public struct ProjectPageParamBox: ProjectPageParam {
  /// Parameter identifying the project by ID or slug.
  public let param: Param
  /// Optional lightweight project configuration used for preview rendering.
  public let initialProject: (any ProjectPamphletMainCellConfiguration)?

  /// Creates a boxed project parameter with an optional preview model.
  public init(param: Param, initialProject: (any ProjectPamphletMainCellConfiguration)?) {
    self.param = param
    self.initialProject = initialProject
  }
}

extension Param: ProjectPageParam {
  /// Returns the parameter itself.
  public var param: Param { self }
  /// Always `nil` for bare `Param` values without preloaded summary data.
  public var initialProject: (any ProjectPamphletMainCellConfiguration)? { nil }
}

/// Input events handled by `ProjectPageViewModel`.
public protocol ProjectPageViewModelInputs {
  /// Call when didSelectRowAt is called on a `ProjectFAQAskAQuestionCell`.
  func askAQuestionCellTapped()
  /// Call when `AppDelegate`'s `applicationDidEnterBackground` is triggered.
  func applicationDidEnterBackground()
  /// Call when block user is tapped.
  func blockUser(id: Int)
  /// Convenience overload for `configureWith` that defaults `secretRewardToken` to `nil`.
  func configureWith(projectOrParam: Either<Project, any ProjectPageParam>, refInfo: RefInfo?)
  /// Call with the project given to the view controller, including an optional `secretRewardToken`.
  func configureWith(
    projectOrParam: Either<Project, any ProjectPageParam>,
    refInfo: RefInfo?,
    secretRewardToken: String?
  )
  /// Call when the Thank you page is dismissed after finishing backing the project.
  func didBackProject()
  /// Call with the `Int` index of the FAQ cell selected and the existing `[Bool]` values in the data source.
  func didSelectFAQsRowAt(row: Int, values: [Bool])
  /// Call with the `URL` of the `ImageViewElement` cell selected in the Campaign section.
  func didSelectCampaignImageLink(url: URL)
  /// Call when `ManagePledgeViewController` finished updating or cancelling a pledge with an optional message.
  func managePledgeViewControllerFinished(with message: String?)
  /// Call when the pledge CTA button is tapped.
  func pledgeCTAButtonTapped(with state: PledgeStateCTAType)
  /// Call when `pledgeRetryButton` is tapped.
  func pledgeRetryButtonTapped()
  /// Call for image view elements missing inside `prefetchRowsAt` in `ProjectPageViewController`.
  func prepareImageAt(_ indexPath: IndexPath)
  /// Call for audio/video view elements missing a player inside `prefetchRowsAt`.
  func prepareAudioVideoAt(_ indexPath: IndexPath, with audioVideoViewElement: AudioVideoViewElement)
  /// Call when project notice details should be displayed.
  func projectNoticeDetailsRequested()
  /// Call when the delegate method for `ProjectTabDisclaimerCellDelegate` is called.
  func projectTabDisclaimerCellDidTapURL(_ URL: URL)
  /// Call when `ProjectNavigationSelectorViewDelegate` selects a tab index.
  func projectNavigationSelectorViewDidSelect(index: Int)
  /// Call when the delegate method for `ProjectRisksDisclaimerCellDelegate` is called.
  func projectRisksDisclaimerCellDidTapURL(_ url: URL)
  /// Call when didSelectRow is called on the comments cell.
  func tappedComments()
  /// Call when didSelectRow is called on the updates cell.
  func tappedUpdates()
  /// Call when didSelectRow is called on the report project cell.
  func tappedReportProject()
  /// Call when the user session starts and the data source should reload.
  func userSessionStarted()
  /// Call when the view did appear, passing `animated`.
  func viewDidAppear(animated: Bool)
  /// Call when the view loads.
  func viewDidLoad()
  /// Call right before an orientation change on the view.
  func viewWillTransition()
  /// Call when a similar project is tapped.
  func similarProjectTapped(project: ProjectCardProperties)
}

/// Output signals exposed by `ProjectPageViewModel`.
public protocol ProjectPageViewModelOutputs {
  /// Emits a tuple of `NavigationSection`, `Project` or `ProjectPageParam`, and `RefTag?` to configure the data source.
  var configureDataSource: Signal<
    (NavigationSection, Either<Project, any ProjectPageParam>, RefTag?),
    Never
  > { get }
  /// Emits a project and optional referral tag to configure child view controllers.
  var configureChildViewControllersWithProject: Signal<(Project, RefTag?), Never> { get }
  /// Emits `PledgeCTAContainerViewData` to configure `PledgeCTAContainerView`.
  var configurePledgeCTAView: Signal<PledgeCTAContainerViewData, Never> { get }
  /// Emits `(Project, RefTag?)` to configure `ProjectNavigationSelectorView`.
  var configureProjectNavigationSelectorView: Signal<(Project, RefTag?), Never> { get }
  /// Emits a message to show on `MessageBannerViewController`.
  var dismissManagePledgeAndShowMessageBannerWithMessage: Signal<String, Never> { get }
  /// Emits a `Project` when comments are to be rendered.
  var goToComments: Signal<Project, Never> { get }
  /// Emits `LoginIntent` to take the user to `LoginToutViewController`.
  var goToLoginWithIntent: Signal<LoginIntent, Never> { get }
  /// Emits `ManagePledgeViewParamConfigData` to open `ManagePledgeViewController`.
  var goToManagePledge: Signal<ManagePledgeViewParamConfigData, Never> { get }
  /// Emits a URL string to open `PledgeManagementDetailsWebViewController`.
  var goToPledgeManagementPledgeView: Signal<String, Never> { get }
  /// Emits the pledge manager web redemption URL string for the project.
  var goToPledgeManager: Signal<String, Never> { get }
  /// Emits a `Project` when updates are to be rendered.
  var goToUpdates: Signal<Project, Never> { get }
  /// Emits a string explaining why the creator is restricted.
  var goToRestrictedCreator: Signal<String, Never> { get }
  /// Emits whether the project is flagged, its GraphQL ID, and web URL when reporting the project.
  var goToReportProject: Signal<(Bool, String, String), Never> { get }
  /// Emits a project, referral tag, and optional secret reward token to open reward selection.
  var goToRewards: Signal<(Project, RefTag?, String?), Never> { get }
  /// Emits a URL to be opened in external Safari.
  var goToURL: Signal<URL, Never> { get }
  /// Emits when active playing media should pause.
  var pauseMedia: Signal<Void, Never> { get }
  /// Emits when navigation should return to the project page.
  var navigateBackToProjectPage: Signal<(), Never> { get }
  /// Emits `Project` when `MessageDialogViewController` should be presented.
  var presentMessageDialog: Signal<Project, Never> { get }
  /// Emits `AudioVideoViewElement` and `IndexPath` when campaign video data needs preparation.
  var precreateAudioVideoURLs: Signal<(AudioVideoViewElement, IndexPath), Never> { get }
  /// Emits `[AudioVideoViewElement]` to preload `AVPlayer` objects on initial load.
  var precreateAudioVideoURLsOnFirstLoad: Signal<[AudioVideoViewElement], Never> { get }
  /// Emits `[URL]` and `IndexPath` when campaign image data needs prefetching.
  var prefetchImageURLs: Signal<([URL], IndexPath), Never> { get }
  /// Emits `[ImageViewElement]` to prefetch image URLs on initial load.
  var prefetchImageURLsOnFirstLoad: Signal<[ImageViewElement], Never> { get }
  /// Emits whether the project has been flagged.
  var projectFlagged: Signal<Bool, Never> { get }
  /// Emits when an orientation change requires reloading campaign data.
  var reloadCampaignData: Signal<Void, Never> { get }
  /// Emits a `HelpType` to present in `HelpWebViewController`.
  var showHelpWebViewController: Signal<HelpType, Never> { get }
  /// Emits active tab section, project, refTag, FAQ expansion states, image URLs, similar projects, and content view.
  var showProjectPageTabWithData: Signal<
    (NavigationSection, Project, RefTag?, [Bool], [URL], SimilarProjectsState, ProjectPageContentView),
    Never
  > { get }
  /// Emits updated `(Project, RefTag?, [Bool])` FAQ expansion state for the data source.
  var updateFAQsInDataSource: Signal<(Project, RefTag?, [Bool]), Never> { get }
  /// Emits prelaunch watch state to update the navigation bar button.
  var updateWatchProjectWithPrelaunchProjectState: Signal<PledgeCTAPrelaunchState, Never> { get }
  /// Emits when blocking a user succeeds.
  var didBlockUser: Signal<(), Never> { get }
  /// Emits when blocking a user fails.
  var didBlockUserError: Signal<(), Never> { get }
  /// Current state of the similar projects carousel.
  var similarProjects: Property<SimilarProjectsState> { get }
  /// Emits when the user taps on a similar project card.
  var navigateToSimilarProject: Signal<ProjectCardProperties, Never> { get }
}

/// Protocol unifying inputs and outputs for `ProjectPageViewModel`.
public protocol ProjectPageViewModelType {
  /// Input receiver for project page UI events.
  var inputs: ProjectPageViewModelInputs { get }
  /// Output signal provider for project page UI updates.
  var outputs: ProjectPageViewModelOutputs { get }
}

