import KDS
import KsApi
import ReactiveSwift
import UIKit

/// Input tuple pairing the project pamphlet configuration with an optional referral tag.
public typealias ProjectPamphletMainCellData = (
  project: any ProjectPamphletMainCellConfiguration,
  refTag: RefTag?
)

/// Input events handled by `ProjectPamphletMainCellViewModel`.
public protocol ProjectPamphletMainCellViewModelInputs {
  /// Call when cell awakeFromNib is called.
  func awakeFromNib()

  /// Call with the ProjectPamphletMainCellData provided to the view controller.
  func configureWith(value: ProjectPamphletMainCellData)

  /// Call when the creator button is tapped.
  func creatorButtonTapped()

  /// Call when the delegate has been set on the cell.
  func delegateDidSet()

  /// Call when the project notice learn more button is tapped.
  func projectNoticeLearnMoreTapped()

  /// Call when embedded video playback completes.
  func videoDidFinish()

  /// Call when embedded video playback starts.
  func videoDidStart()
}

/// Output signals emitted by `ProjectPamphletMainCellViewModel`.
public protocol ProjectPamphletMainCellViewModelOutputs {
  /// Emits a string to use for the backer subtitle label.
  var backersSubtitleLabelText: Signal<String, Never> { get }

  /// Emits a string to use for the backers title label.
  var backersTitleLabelText: Signal<String, Never> { get }

  /// Emits a string to use for the category name label.
  var categoryNameLabelText: Signal<String, Never> { get }

  /// Emits a project when the video player controller should be configured.
  var configureVideoPlayerController: Signal<any ProjectPamphletMainCellConfiguration, Never> { get }

  /// Emits a boolean that determines if the conversion labels should be hidden.
  var conversionLabelHidden: Signal<Bool, Never> { get }

  /// Emits a string for the conversion label.
  var conversionLabelText: Signal<String, Never> { get }

  /// Emits an image url to be loaded into the creator's image view.
  var creatorImageUrl: Signal<URL?, Never> { get }

  /// Emits text to be put into the creator label.
  var creatorLabelText: Signal<String, Never> { get }

  /// Emits the text for the deadline subtitle label.
  var deadlineSubtitleLabelText: Signal<String, Never> { get }

  /// Emits the text for the deadline title label.
  var deadlineTitleLabelText: Signal<String, Never> { get }

  /// Emits the background color of the funding progress bar view.
  var fundingProgressBarViewBackgroundColor: Signal<UIColor, Never> { get }

  /// Emits the prelaunch project state. Used to hide/show progress bar and stats view.
  var isPrelaunchProject: Signal<Bool, Never> { get }

  /// Emits a string to use for the location name label.
  var locationNameLabelText: Signal<String, Never> { get }

  /// Emits a bool for if the location stack view should be hidden.
  var locationStackViewHidden: Signal<Bool, Never> { get }

  /// Emits the project when we should go to the creator's view for the project.
  var notifyDelegateToGoToCreator: Signal<any ProjectPamphletMainCellConfiguration, Never> { get }

  /// Emits the project when project notice details should be displayed.
  var notifyDelegateToGoToProjectNotice: Signal<(), Never> { get }

  /// Emits an alpha value for views to create transition after full project loads.
  var opacityForViews: Signal<CGFloat, Never> { get }

  /// Emits the text for the pledged subtitle label.
  var pledgedSubtitleLabelText: Signal<String, Never> { get }

  /// Emits the text for the pledged title label.
  var pledgedTitleLabelText: Signal<String, Never> { get }

  /// Emits the text color of the pledged title label.
  var pledgedTitleLabelTextColor: Signal<UIColor, Never> { get }

  /// Emits a string for the backing label, which could be "you're a backer" or "coming soon".
  var prelaunchProjectBackingText: Signal<String, Never> { get }

  /// Emits a percentage between 0.0 and 1.0 that can be used to render the funding progress bar.
  var progressPercentage: Signal<Float, Never> { get }

  /// Emits text to be put into the project blurb label.
  var projectBlurbLabelText: Signal<String, Never> { get }

  /// Emits a URL to be loaded into the project's image view.
  var projectImageUrl: Signal<URL?, Never> { get }

  /// Emits text to be put into the project name label.
  var projectNameLabelText: Signal<String, Never> { get }

  /// Emits a string that should be put into the project state label.
  var projectStateLabelText: Signal<String, Never> { get }

  /// Emits the text color of the project state label.
  var projectStateLabelTextColor: Signal<UIColor, Never> { get }

  /// Emits the text color of the backer and deadline title label.
  var projectUnsuccessfulLabelTextColor: Signal<UIColor, Never> { get }

  /// Emits a boolean that determines if the project state label should be hidden.
  var stateLabelHidden: Signal<Bool, Never> { get }

  /// Emits a string to use for the stats stack view accessibility value.
  var statsStackViewAccessibilityLabel: Signal<String, Never> { get }

  /// Emits a boolean that determines if the "you're a backer" or "coming soon" label should be hidden.
  var backingLabelHidden: Signal<Bool, Never> { get }

  /// Emits false if the project notice banner should be shown.
  var projectNoticeBannerHidden: Signal<Bool, Never> { get }
}

/// View model interface for the main header cell of the project pamphlet screen.
public protocol ProjectPamphletMainCellViewModelType {
  /// Input receiver for cell lifecycle and tap actions.
  var inputs: ProjectPamphletMainCellViewModelInputs { get }
  /// Output signals bound by `ProjectPamphletMainCell`.
  var outputs: ProjectPamphletMainCellViewModelOutputs { get }
}

typealias ConvertedCurrrencyProjectData = (pledgedAmount: Int, goalAmount: Int, currency: String)

