import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model formatting project metadata, funding progress, stats, and video state for `ProjectPamphletMainCell`.
public final class ProjectPamphletMainCellViewModel: ProjectPamphletMainCellViewModelType,
  ProjectPamphletMainCellViewModelInputs, ProjectPamphletMainCellViewModelOutputs {
  /// Initializes the main cell view model and binds project pamphlet outputs.
  public init() {
    let data = Signal.combineLatest(self.dataProperty.signal.skipNil(), self.awakeFromNibProperty.signal)
      .map(first)

    let project = data.map(first)
    let properties = project.map { $0.projectPamphletMainCellProperties }

    self.projectNameLabelText = properties.map { $0.name }
    self.projectBlurbLabelText = properties.map { $0.blurb }
    self.creatorLabelText = properties.map { Strings.project_creator_by_creator(creator_name: $0.creatorName) }
    self.creatorImageUrl = properties.map { URL(string: $0.creatorAvatarURL) }
    self.stateLabelHidden = properties.map { $0.state == .live }
    self.projectStateLabelText = properties.filter { $0.state != .live }.map(fundingStatus(forProperties:))
    self.projectStateLabelTextColor = properties
      .filter { $0.state != .live }
      .map { $0.state == .successful ? LegacyColors.ksr_create_700.uiColor() : LegacyColors.ksr_support_400.uiColor() }
    self.fundingProgressBarViewBackgroundColor = properties.map(progressColor(forProperties:))
    self.projectUnsuccessfulLabelTextColor = properties.map { _ in LegacyColors.ksr_support_400.uiColor() }
    self.pledgedTitleLabelTextColor = properties.map {
      $0.state == .successful || $0.state == .live
        ? LegacyColors.ksr_create_700.uiColor()
        : LegacyColors.ksr_support_400.uiColor()
    }
    self.prelaunchProjectBackingText = properties.map {
      $0.displayPrelaunch == .some(true) ? Strings.Coming_soon() : Strings.Youre_a_backer()
    }
    self.projectImageUrl = properties.map { URL(string: $0.photo) }
    self.projectNoticeBannerHidden = properties.map { ($0.projectNotice ?? "") == "" }

    let videoIsPlaying = Signal.merge(
      project.take(first: 1).mapConst(false),
      self.videoDidStartProperty.signal.mapConst(true),
      self.videoDidFinishProperty.signal.mapConst(false)
    )

    self.backingLabelHidden = Signal.combineLatest(properties, videoIsPlaying)
      .map { properties, videoIsPlaying in
        guard let displayPrelaunch = properties.displayPrelaunch else { return true }
        guard !displayPrelaunch else { return false }
        return properties.isBacking != true || videoIsPlaying
      }
      .skipRepeats()

    let backersTitleAndSubtitleText = properties.map { properties -> (String?, String?) in
      let parts = Strings.Backers_count_separator_backers(backers_count: properties.backersCount)
        .split(separator: "\n").map(String.init)
      return (parts.first, parts.last)
    }
    self.backersTitleLabelText = backersTitleAndSubtitleText.map { title, _ in title ?? "" }
    self.backersSubtitleLabelText = backersTitleAndSubtitleText.map { _, subtitle in subtitle ?? "" }
    self.categoryNameLabelText = properties.map { $0.categoryName ?? "" }

    let deadlineTitleAndSubtitle = properties.map { properties -> (String, String) in
      guard let deadline = properties.deadline else { return ("", "") }
      return Format.duration(secondsInUTC: deadline, useToGo: true)
    }
    self.deadlineTitleLabelText = deadlineTitleAndSubtitle.map(first)
    self.deadlineSubtitleLabelText = deadlineTitleAndSubtitle.map(second)

    let propertiesAndNeedsConversion = properties.map { ($0, $0.needsConversion) }
    self.conversionLabelHidden = propertiesAndNeedsConversion.map(second).map(negate)
    self.locationNameLabelText = properties.map { $0.locationName }
    self.locationStackViewHidden = properties.map { $0.locationName.isEmpty }
    self.pledgedTitleLabelText = propertiesAndNeedsConversion.map { pledgedText(for: $0.0, $0.1) }
    self.pledgedSubtitleLabelText = propertiesAndNeedsConversion.map { goalText(for: $0.0, $0.1) }
    self.conversionLabelText = propertiesAndNeedsConversion.filter(second).map(first).map(conversionText(for:))
    self.statsStackViewAccessibilityLabel = propertiesAndNeedsConversion
      .map(statsStackViewAccessibilityLabelForProperties(_:needsConversion:))
    self.isPrelaunchProject = properties.map { $0.displayPrelaunch }.skipNil()
    self.progressPercentage = properties.map { $0.fundingProgress }.map(clamp(0, 1))
    self.notifyDelegateToGoToCreator = project.takeWhen(self.creatorButtonTappedProperty.signal)
    self.notifyDelegateToGoToProjectNotice = self.projectNoticeLearnMoreTappedProperty.signal
    self.configureVideoPlayerController = Signal.combineLatest(project, self.delegateDidSetProperty.signal)
      .map(first)
      .take(first: 1)
    self.opacityForViews = Signal.merge(
      self.dataProperty.signal.skipNil().mapConst(1.0),
      self.awakeFromNibProperty.signal.mapConst(0.0)
    )

    self.notifyDelegateToGoToCreator.observeValues { project in
      AppEnvironment.current.ksrAnalytics.trackGotoCreatorDetailsClicked(project: project)
    }
  }

  private let awakeFromNibProperty = MutableProperty(())
  /// Signals that the cell awoke from its nib.
  public func awakeFromNib() { self.awakeFromNibProperty.value = () }

  fileprivate let dataProperty = MutableProperty<ProjectPamphletMainCellData?>(nil)
  /// Configures the view model with project configuration and referral tag data.
  public func configureWith(value: ProjectPamphletMainCellData) { self.dataProperty.value = value }

  fileprivate let creatorButtonTappedProperty = MutableProperty(())
  /// Signals that the creator attribution button was tapped.
  public func creatorButtonTapped() { self.creatorButtonTappedProperty.value = () }

  fileprivate let delegateDidSetProperty = MutableProperty(())
  /// Signals that the cell delegate was assigned.
  public func delegateDidSet() { self.delegateDidSetProperty.value = () }

  fileprivate let projectNoticeLearnMoreTappedProperty = MutableProperty(())
  /// Signals that the project notice learn-more CTA was tapped.
  public func projectNoticeLearnMoreTapped() { self.projectNoticeLearnMoreTappedProperty.value = () }

  fileprivate let videoDidFinishProperty = MutableProperty(())
  /// Signals that video playback finished.
  public func videoDidFinish() { self.videoDidFinishProperty.value = () }

  fileprivate let videoDidStartProperty = MutableProperty(())
  /// Signals that video playback started.
  public func videoDidStart() { self.videoDidStartProperty.value = () }

  /// Emits formatted subtitle text for the backers stat label.
  public let backersSubtitleLabelText: Signal<String, Never>
  /// Emits formatted count text for the backers title label.
  public let backersTitleLabelText: Signal<String, Never>
  /// Emits the project's category display name.
  public let categoryNameLabelText: Signal<String, Never>
  /// Emits project configuration when the embedded video player should be prepared.
  public let configureVideoPlayerController: Signal<any ProjectPamphletMainCellConfiguration, Never>
  /// Emits whether currency conversion labels should remain hidden.
  public let conversionLabelHidden: Signal<Bool, Never>
  /// Emits original-currency pledge and goal conversion text.
  public let conversionLabelText: Signal<String, Never>
  /// Emits the creator avatar image URL.
  public let creatorImageUrl: Signal<URL?, Never>
  /// Emits the formatted creator attribution label string.
  public let creatorLabelText: Signal<String, Never>
  /// Emits the unit suffix for the deadline countdown label.
  public let deadlineSubtitleLabelText: Signal<String, Never>
  /// Emits the numeric value for the deadline countdown label.
  public let deadlineTitleLabelText: Signal<String, Never>
  /// Emits whether the project is currently in prelaunch state.
  public let isPrelaunchProject: Signal<Bool, Never>
  /// Emits the fill color for the funding progress bar.
  public let fundingProgressBarViewBackgroundColor: Signal<UIColor, Never>
  /// Emits the project's location display string.
  public let locationNameLabelText: Signal<String, Never>
  /// Emits whether the location stack view should be hidden.
  public let locationStackViewHidden: Signal<Bool, Never>
  /// Emits the project configuration when navigating to creator details.
  public let notifyDelegateToGoToCreator: Signal<any ProjectPamphletMainCellConfiguration, Never>
  /// Emits when the cell delegate should open the project notice sheet.
  public let notifyDelegateToGoToProjectNotice: Signal<(), Never>
  /// Emits the fade-in alpha value for main cell content views.
  public let opacityForViews: Signal<CGFloat, Never>
  /// Emits formatted funding goal subtitle text.
  public let pledgedSubtitleLabelText: Signal<String, Never>
  /// Emits formatted pledged amount text.
  public let pledgedTitleLabelText: Signal<String, Never>
  /// Emits the text color for the pledged amount label.
  public let pledgedTitleLabelTextColor: Signal<UIColor, Never>
  /// Emits localized prelaunch or existing-backer badge text.
  public let prelaunchProjectBackingText: Signal<String, Never>
  /// Emits clamped funding completion ratio in `[0, 1]`.
  public let progressPercentage: Signal<Float, Never>
  /// Emits the project summary blurb.
  public let projectBlurbLabelText: Signal<String, Never>
  /// Emits the project hero image URL.
  public let projectImageUrl: Signal<URL?, Never>
  /// Emits the project title.
  public let projectNameLabelText: Signal<String, Never>
  /// Emits the formatted funding status banner string for ended campaigns.
  public let projectStateLabelText: Signal<String, Never>
  /// Emits the text color for the funding status label.
  public let projectStateLabelTextColor: Signal<UIColor, Never>
  /// Emits the muted text color used for unsuccessful stats labels.
  public let projectUnsuccessfulLabelTextColor: Signal<UIColor, Never>
  /// Emits whether the project status banner label is hidden.
  public let stateLabelHidden: Signal<Bool, Never>
  /// Emits combined VoiceOver accessibility text for project funding stats.
  public let statsStackViewAccessibilityLabel: Signal<String, Never>
  /// Emits whether the backing status badge label is hidden.
  public let backingLabelHidden: Signal<Bool, Never>
  /// Emits whether the project notice banner is hidden.
  public let projectNoticeBannerHidden: Signal<Bool, Never>

  /// View model inputs.
  public var inputs: ProjectPamphletMainCellViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ProjectPamphletMainCellViewModelOutputs { return self }
}
