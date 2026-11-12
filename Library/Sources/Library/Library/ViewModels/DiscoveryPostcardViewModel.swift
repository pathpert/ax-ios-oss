import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model formatting discovery project metadata, funding state, and social context for postcard cells.
public final class DiscoveryPostcardViewModel: DiscoveryPostcardViewModelType,
  DiscoveryPostcardViewModelInputs, DiscoveryPostcardViewModelOutputs {
  /// Initializes the discovery postcard view model.
  public init() {
    let configuredProject = self.configureWithValueProperty.signal.skipNil().map(first)
    let configuredCategory = self.configureWithValueProperty.signal.skipNil().map(second)

    let backersTitleAndSubtitleText = configuredProject.map { project -> (String?, String?) in
      let string = Strings.Backers_count_separator_backers(backers_count: project.stats.backersCount)
      let parts = string.split(separator: "\n").map(String.init)
      return (parts.first, parts.last)
    }

    self.backersTitleLabelText = backersTitleAndSubtitleText.map { title, _ in title ?? "" }
    self.backersSubtitleLabelText = backersTitleAndSubtitleText.map { _, subtitle in subtitle ?? "" }

    let deadlineTitleAndSubtitle = configuredProject
      .map { project -> (String, String) in
        guard let datesDeadline = project.dates.deadline else { return ("", "") }

        return project.state == .live
          ? Format.duration(secondsInUTC: datesDeadline, useToGo: true)
          : ("", "")
      }

    self.deadlineTitleLabelText = deadlineTitleAndSubtitle.map(first)
    self.deadlineSubtitleLabelText = deadlineTitleAndSubtitle.map(second)

    let possibleMetadataData = configuredProject.map(postcardMetadata(forProject:))
    self.metadataViewHidden = possibleMetadataData.map { $0 == nil }

    let metadataData = possibleMetadataData.skipNil()
    self.metadataIcon = metadataData.map { $0.iconImage }
    self.metadataLabelText = metadataData.map { $0.labelText }
    self.metadataTextColor = metadataData.map { $0.iconAndTextColor }
    self.metadataIconImageViewTintColor = metadataData.map { $0.iconAndTextColor }

    self.percentFundedTitleLabelText = configuredProject
      .map { $0.state == .live ? Format.percentage($0.stats.percentFunded) : "" }

    self.progressPercentage = configuredProject
      .map(Project.lens.stats.fundingProgress.view)
      .map(clamp(0, 1))

    self.projectImageURL = configuredProject.map { $0.photo.full }.map(URL.init(string:))
    self.projectNameAndBlurbLabelText = configuredProject.map(projectAttributedNameAndBlurb)
    self.projectStateIconHidden = configuredProject.map { $0.state != .successful }
    self.projectStateStackViewHidden = configuredProject.map { $0.state == .live }.skipRepeats()
    self.projectStateSubtitleLabelText = configuredProject.map {
      $0.state != .live
        ? Format.date(secondsInUTC: $0.dates.stateChangedAt, dateStyle: .medium, timeStyle: .none)
        : ""
    }
    self.projectStateTitleLabelColor = configuredProject
      .map {
        $0.state == .successful ? LegacyColors.ksr_create_700.uiColor() : LegacyColors.ksr_support_700
          .uiColor()
      }
      .skipRepeats()
    self.projectStateTitleLabelText = configuredProject.map(postcardFundingStatusText(forProject:))
    self.projectCategoryName = configuredProject.map { $0.category?.name ?? "" }

    self.projectCategoryViewHidden = Signal.combineLatest(configuredProject, configuredCategory)
      .map { project, category in
        guard let category = category else { return false }
        if let projectCategory = project.category, !category.isRoot {
          return Int(projectCategory.id) == category.intID
        }
        return false
      }

    self.projectIsStaffPickLabelHidden = configuredProject.map { $0.staffPick }.negate()

    let projectCategoryViewsHidden = Signal.combineLatest(
      self.projectCategoryViewHidden.signal,
      self.projectIsStaffPickLabelHidden.signal
    )
    self.projectCategoryStackViewHidden = projectCategoryViewsHidden.map { $0.0 && $0.1 }
    self.projectStatsStackViewHidden = self.projectStateStackViewHidden.map(negate)

    self.socialImageURL = configuredProject
      .map { $0.personalization.friends?.first.flatMap { URL(string: $0.avatar.medium) } }
    self.socialLabelText = configuredProject
      .map { $0.personalization.friends.flatMap(postcardSocialText(forFriends:)) ?? "" }
    self.socialStackViewHidden = configuredProject
      .map { $0.personalization.friends == nil || $0.personalization.friends?.count ?? 0 == 0 }
      .skipRepeats()

    self.fundingProgressContainerViewHidden = configuredProject
      .map { $0.state == .canceled || $0.state == .suspended }
    self.fundingProgressBarViewHidden = configuredProject.map { $0.state == .failed }

    self.cellAccessibilityLabel = configuredProject.map(Project.lens.name.view)
    self.cellAccessibilityValue = Signal.zip(configuredProject, self.projectStateTitleLabelText)
      .map { project, projectState in "\(project.blurb). \(projectState)" }

    let params = self.configureWithValueProperty.signal.skipNil().map(third)
    self.locationStackViewHidden = params.map { $0 != nil }
    self.locationLabelText = configuredProject.map { $0.location?.name ?? "" }
  }

  fileprivate let configureWithValueProperty = MutableProperty<DiscoveryProjectCellRowValue?>(nil)
  /// Configures the view model with a discovery project row tuple.
  public func configure(with value: DiscoveryProjectCellRowValue) {
    self.configureWithValueProperty.value = value
  }

  /// Emits formatted backer count value text.
  public let backersTitleLabelText: Signal<String, Never>
  /// Emits localized backers subtitle text.
  public let backersSubtitleLabelText: Signal<String, Never>
  /// Emits the cell accessibility label.
  public let cellAccessibilityLabel: Signal<String, Never>
  /// Emits the cell accessibility value.
  public let cellAccessibilityValue: Signal<String, Never>
  /// Emits the deadline unit subtitle text.
  public let deadlineSubtitleLabelText: Signal<String, Never>
  /// Emits the deadline duration value text.
  public let deadlineTitleLabelText: Signal<String, Never>
  /// Emits whether the funding progress bar is hidden.
  public let fundingProgressBarViewHidden: Signal<Bool, Never>
  /// Emits whether the funding progress container is hidden.
  public let fundingProgressContainerViewHidden: Signal<Bool, Never>
  /// Emits the project's location display string.
  public let locationLabelText: Signal<String, Never>
  /// Emits whether the location stack view is hidden.
  public let locationStackViewHidden: Signal<Bool, Never>
  /// Emits metadata badge text.
  public let metadataLabelText: Signal<String, Never>
  /// Emits metadata badge icon.
  public let metadataIcon: Signal<UIImage?, Never>
  /// Emits metadata icon tint color.
  public let metadataIconImageViewTintColor: Signal<UIColor, Never>
  /// Emits metadata text color.
  public let metadataTextColor: Signal<UIColor, Never>
  /// Emits whether the metadata badge view is hidden.
  public let metadataViewHidden: Signal<Bool, Never>
  /// Emits the percent funded title text.
  public let percentFundedTitleLabelText: Signal<String, Never>
  /// Emits the clamped funding progress ratio.
  public let progressPercentage: Signal<Float, Never>
  /// Emits the project hero image URL.
  public let projectImageURL: Signal<URL?, Never>
  /// Emits the attributed project name and blurb string.
  public let projectNameAndBlurbLabelText: Signal<NSAttributedString, Never>
  /// Emits whether the project state icon is hidden.
  public let projectStateIconHidden: Signal<Bool, Never>
  /// Emits whether the project state banner is hidden.
  public let projectStateStackViewHidden: Signal<Bool, Never>
  /// Emits whether project stats stack view is hidden.
  public let projectStatsStackViewHidden: Signal<Bool, Never>
  /// Emits the project state date subtitle text.
  public let projectStateSubtitleLabelText: Signal<String, Never>
  /// Emits the project state headline text.
  public let projectStateTitleLabelText: Signal<String, Never>
  /// Emits the project category badge name.
  public var projectCategoryName: Signal<String, Never>
  /// Emits whether the Projects We Love badge is hidden.
  public let projectIsStaffPickLabelHidden: Signal<Bool, Never>
  /// Emits whether the category badge view is hidden.
  public var projectCategoryViewHidden: Signal<Bool, Never>
  /// Emits whether the category container stack is hidden.
  public var projectCategoryStackViewHidden: Signal<Bool, Never>
  /// Emits the text color for the project state headline.
  public let projectStateTitleLabelColor: Signal<UIColor, Never>
  /// Emits the backing friend's avatar image URL.
  public let socialImageURL: Signal<URL?, Never>
  /// Emits the social proof text for backing friends.
  public let socialLabelText: Signal<String, Never>
  /// Emits whether the social proof stack view is hidden.
  public let socialStackViewHidden: Signal<Bool, Never>

  /// Input interface for this view model.
  public var inputs: DiscoveryPostcardViewModelInputs { return self }
  /// Output interface for this view model.
  public var outputs: DiscoveryPostcardViewModelOutputs { return self }
}
