import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `DiscoveryProjectCardViewModel`.
public protocol DiscoveryProjectCardViewModelInputs {
  /// Configures the card view model with a discovery project row tuple.
  func configure(with value: DiscoveryProjectCellRowValue)
}

/// Reactive outputs emitted by `DiscoveryProjectCardViewModel`.
public protocol DiscoveryProjectCardViewModelOutputs {
  /// Emits bolded label data for total backer count.
  var backerCountLabelData: Signal<BoldedAttributedLabelData, Never> { get }
  /// Emits friend facepile avatar URLs and summary string.
  var facepileViewData: Signal<FacepileViewData, Never> { get }
  /// Emits whether the social friend facepile row is hidden.
  var facepileViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the funded checkmark badge icon is hidden.
  var goalMetIconHidden: Signal<Bool, Never> { get }
  /// Emits tag pills (Projects We Love, category) to display on the card.
  var loadProjectTags: Signal<[DiscoveryPillData], Never> { get }
  /// Emits bolded percentage-funded or goal-met label data.
  var percentFundedLabelData: Signal<BoldedAttributedLabelData, Never> { get }
  /// Emits the project short blurb text.
  var projectBlurbLabelText: Signal<String, Never> { get }
  /// Emits the full hero photo URL for the project card.
  var projectImageURL: Signal<URL, Never> { get }
  /// Emits the project title string.
  var projectNameLabelText: Signal<String, Never> { get }
  /// Emits icon asset name representing campaign status.
  var projectStatusIconImageName: Signal<String, Never> { get }
  /// Emits bolded status / time-left label data.
  var projectStatusLabelData: Signal<BoldedAttributedLabelData, Never> { get }
  /// Emits whether the tag pills collection view is hidden.
  var tagsCollectionViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the "You're a backer" badge is hidden.
  var youreABackerViewHidden: Signal<Bool, Never> { get }
}

/// Combined inputs/outputs contract for a discovery project card cell.
public protocol DiscoveryProjectCardViewModelType {
  /// Input receiver.
  var inputs: DiscoveryProjectCardViewModelInputs { get }
  /// Output signal provider.
  var outputs: DiscoveryProjectCardViewModelOutputs { get }
}

/// View model formatting discovery card metadata, pills, friend facepile, and campaign countdown.
public final class DiscoveryProjectCardViewModel: DiscoveryProjectCardViewModelType,
  DiscoveryProjectCardViewModelInputs, DiscoveryProjectCardViewModelOutputs {
  /// Creates a new `DiscoveryProjectCardViewModel`.
  public init() {
    let project = self.configureWithValueProperty.signal.skipNil().map(first)

    self.projectNameLabelText = project.map(\.name)
    self.projectBlurbLabelText = project.map(\.blurb)
    self.backerCountLabelData = project.map(\.stats.backersCount).map { count in
      BoldedAttributedLabelData(
        boldedString: Format.wholeNumber(count),
        inString: Strings.general_backer_count_backers(backer_count: count)
      )
    }

    self.percentFundedLabelData = project.map { project in
      if project.stats.goalMet {
        return BoldedAttributedLabelData(
          boldedString: Strings.Goal_met(),
          inString: Strings.Goal_met()
        )
      }

      let percentage = "\(project.stats.percentFunded)%"

      return BoldedAttributedLabelData(
        boldedString: percentage,
        inString: Strings.percentage_funded(percentage: percentage)
      )
    }

    self.goalMetIconHidden = project.map(\.stats.goalMet).negate()
    self.projectImageURL = project.map(\.photo.full).map(URL.init(string:)).skipNil()
    self.facepileViewHidden = project.map(\.personalization.friends).map { friends in
      guard let friends = friends else {
        return true
      }

      return friends.isEmpty
    }
    self.facepileViewData = project.compactMap(\.personalization.friends).compactMap(facepileData(for:))

    self.tagsCollectionViewHidden = self.configureWithValueProperty.signal.skipNil()
      .map { ($0.project, $0.category) }
      .map(projectTagsViewShouldHide(project:category:))

    self.loadProjectTags = self.configureWithValueProperty.signal.skipNil()
      .map { ($0.project, $0.category) }
      .map(projectTags(project:category:))
      .filter { !$0.isEmpty }

    self.projectStatusIconImageName = project.compactMap { project in
      switch project.state {
      case .canceled, .failed: return "icon--prohibit"
      case .successful: return "icon--check"
      case .live: return "icon--clock"
      case .started, .submitted, .suspended, .purged: return nil // there should be no projects in this state
      }
    }

    self.projectStatusLabelData = project.compactMap { project in
      switch project.state {
      case .canceled:
        return BoldedAttributedLabelData(boldedString: "", inString: Strings.profile_projects_status_canceled())
      case .failed:
        return BoldedAttributedLabelData(boldedString: "", inString: Strings.profile_projects_status_unsuccessful())
      case .successful:
        return BoldedAttributedLabelData(boldedString: "", inString: Strings.profile_projects_status_successful())
      case .live:
        guard let projectDeadline = project.dates.deadline else {
          return BoldedAttributedLabelData(boldedString: "", inString: "")
        }

        let (duration, unit) = Format.duration(
          secondsInUTC: projectDeadline,
          abbreviate: false,
          useToGo: true,
          env: AppEnvironment.current
        )

        return BoldedAttributedLabelData(boldedString: duration, inString: "\(duration) \(unit)")
      case .started, .submitted, .suspended, .purged: return nil // there should be no projects in this state
      }
    }

    self.youreABackerViewHidden = project.map(userIsBackingProject).negate()
  }

  private let configureWithValueProperty = MutableProperty<DiscoveryProjectCellRowValue?>(nil)
  /// Configures the card with a discovery row value.
  public func configure(with value: DiscoveryProjectCellRowValue) {
    self.configureWithValueProperty.value = value
  }

  /// Emits bolded label data for total backer count.
  public let backerCountLabelData: Signal<BoldedAttributedLabelData, Never>
  /// Emits whether the social friend facepile row is hidden.
  public let facepileViewHidden: Signal<Bool, Never>
  /// Emits friend facepile avatar URLs and summary string.
  public let facepileViewData: Signal<FacepileViewData, Never>
  /// Emits whether the funded checkmark badge icon is hidden.
  public let goalMetIconHidden: Signal<Bool, Never>
  /// Emits tag pills to display on the card.
  public let loadProjectTags: Signal<[DiscoveryPillData], Never>
  /// Emits bolded percentage-funded or goal-met label data.
  public let percentFundedLabelData: Signal<BoldedAttributedLabelData, Never>
  /// Emits the project short blurb text.
  public let projectBlurbLabelText: Signal<String, Never>
  /// Emits the full hero photo URL for the project card.
  public let projectImageURL: Signal<URL, Never>
  /// Emits the project title string.
  public let projectNameLabelText: Signal<String, Never>
  /// Emits icon asset name representing campaign status.
  public let projectStatusIconImageName: Signal<String, Never>
  /// Emits bolded status / time-left label data.
  public let projectStatusLabelData: Signal<BoldedAttributedLabelData, Never>
  /// Emits whether the tag pills collection view is hidden.
  public let tagsCollectionViewHidden: Signal<Bool, Never>
  /// Emits whether the "You're a backer" badge is hidden.
  public let youreABackerViewHidden: Signal<Bool, Never>

  /// Inputs receiver (`self`).
  public var inputs: DiscoveryProjectCardViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: DiscoveryProjectCardViewModelOutputs { return self }
}

private func projectTagsViewShouldHide(project: Project, category: KsApi.Category?) -> Bool {
  let categoryTagShouldHide = projectCategoryTagShouldHide(for: project, in: category)
  let pwlTagShouldHide = projectPWLTagShouldHide(project: project)

  return categoryTagShouldHide && pwlTagShouldHide
}

private func projectCategoryTagShouldHide(for project: Project, in category: KsApi.Category?) -> Bool {
  guard let category = category, !category.isRoot else {
    // Always show category when filter category is nil, or we're in a root category
    return false
  }

  return project.category?.id == category.intID
}

private func projectPWLTagShouldHide(project: Project) -> Bool {
  return !project.staffPick
}

private func projectTags(project: Project, category: KsApi.Category?) -> [DiscoveryPillData] {
  let shouldShowCategoryTag = !projectCategoryTagShouldHide(for: project, in: category)
  let shouldShowPWLTag = !projectPWLTagShouldHide(project: project)

  var tags: [DiscoveryPillData] = []

  if shouldShowPWLTag {
    let pwlTag = DiscoveryPillData(
      imageName: "icon--small-k",
      text: Strings.Projects_We_Love(),
      type: .green
    )

    tags.append(pwlTag)
  }

  if shouldShowCategoryTag, let category = project.category {
    let categoryTag = DiscoveryPillData(
      imageName: "icon--compass",
      text: category.name,
      type: .grey
    )

    tags.append(categoryTag)
  }

  return tags
}

private func facepileData(for friendsList: [User]) -> FacepileViewData? {
  guard !friendsList.isEmpty else { return nil }

  let avatars = friendsList.prefix(3).map(\.avatar.small).compactMap(URL.init(string:))

  let remainingCount = friendsList.count - 1
  let description = Strings.Social_friend_is_backer(
    friend_name: friendsList[0].name,
    remaining_count: remainingCount
  )

  return FacepileViewData(avatars: avatars, description: description)
}
