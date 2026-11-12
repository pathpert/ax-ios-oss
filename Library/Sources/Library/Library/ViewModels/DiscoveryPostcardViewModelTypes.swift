import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Row configuration tuple passed to `DiscoveryPostcardViewModel`.
public typealias DiscoveryProjectCellRowValue = (
  project: Project,
  category: KsApi.Category?,
  params: DiscoveryParams?
)

/// Styled badge metadata model displayed on discovery postcard cells.
public struct PostcardMetadataData {
  /// Optional badge icon image.
  public let iconImage: UIImage?
  /// Localized metadata badge label.
  public let labelText: String
  /// Tint and text color applied to the metadata badge.
  public let iconAndTextColor: UIColor
}

/// Input actions supported by `DiscoveryPostcardViewModel`.
public protocol DiscoveryPostcardViewModelInputs {
  /// Call with the data provided to the view controller.
  func configure(with value: DiscoveryProjectCellRowValue)
}

/// UI outputs emitted by `DiscoveryPostcardViewModel`.
public protocol DiscoveryPostcardViewModelOutputs {
  /// Emits a string to use for the backers title label.
  var backersTitleLabelText: Signal<String, Never> { get }
  /// Emits a string to use for the backers subtitle label.
  var backersSubtitleLabelText: Signal<String, Never> { get }
  /// Emits the cell label to be read aloud by VoiceOver.
  var cellAccessibilityLabel: Signal<String, Never> { get }
  /// Emits the cell value to be read aloud by VoiceOver.
  var cellAccessibilityValue: Signal<String, Never> { get }
  /// Emits the text for the deadline subtitle label.
  var deadlineSubtitleLabelText: Signal<String, Never> { get }
  /// Emits the text for the deadline title label.
  var deadlineTitleLabelText: Signal<String, Never> { get }
  /// Emits a boolean to determine whether or not to display the funding progress bar view.
  var fundingProgressBarViewHidden: Signal<Bool, Never> { get }
  /// Emits a boolean to determine whether or not to display funding progress container view.
  var fundingProgressContainerViewHidden: Signal<Bool, Never> { get }
  /// Emits a boolean to determine whether or not to display the location stack view.
  var locationStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the location label text.
  var locationLabelText: Signal<String, Never> { get }
  /// Emits metadata label text.
  var metadataLabelText: Signal<String, Never> { get }
  /// Emits metadata icon image.
  var metadataIcon: Signal<UIImage?, Never> { get }
  /// Emits icon image tint color.
  var metadataIconImageViewTintColor: Signal<UIColor, Never> { get }
  /// Emits metadata text color.
  var metadataTextColor: Signal<UIColor, Never> { get }
  /// Emits a boolean to determine whether or not the metadata view should be hidden.
  var metadataViewHidden: Signal<Bool, Never> { get }
  /// Emits the text for the pledged title label.
  var percentFundedTitleLabelText: Signal<String, Never> { get }
  /// Emits a percentage between 0.0 and 1.0 that can be used to render the funding progress bar.
  var progressPercentage: Signal<Float, Never> { get }
  /// Emits a URL to be loaded into the project's image view.
  var projectImageURL: Signal<URL?, Never> { get }
  /// Emits the text to be put into the project name and blurb label.
  var projectNameAndBlurbLabelText: Signal<NSAttributedString, Never> { get }
  /// Emits a boolean that determines if the project state icon should be hidden.
  var projectStateIconHidden: Signal<Bool, Never> { get }
  /// Emits a boolean that determines if the project state label should be hidden.
  var projectStateStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the text for the project state subtitle label.
  var projectStateSubtitleLabelText: Signal<String, Never> { get }
  /// Emits the color for the project state title label.
  var projectStateTitleLabelColor: Signal<UIColor, Never> { get }
  /// Emits the text for the project state title label.
  var projectStateTitleLabelText: Signal<String, Never> { get }
  /// Emits a string for the project category label.
  var projectCategoryName: Signal<String, Never> { get }
  /// Emits a boolean that determines if the "Projects We Love" label should be hidden.
  var projectIsStaffPickLabelHidden: Signal<Bool, Never> { get }
  /// Emits a boolean that determines if the project categories should be hidden.
  var projectCategoryViewHidden: Signal<Bool, Never> { get }
  /// Emits a boolean that determines if the category stack view should be hidden.
  var projectCategoryStackViewHidden: Signal<Bool, Never> { get }
  /// Emits a boolean that determines if the project stats should be hidden.
  var projectStatsStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the URL to be loaded into the social avatar's image view.
  var socialImageURL: Signal<URL?, Never> { get }
  /// Emits the text for the social label.
  var socialLabelText: Signal<String, Never> { get }
  /// Emits a boolean that determines if the social view should be hidden.
  var socialStackViewHidden: Signal<Bool, Never> { get }
}

/// View model interface for a discovery postcard project cell.
public protocol DiscoveryPostcardViewModelType {
  /// Input interface for the discovery postcard view model.
  var inputs: DiscoveryPostcardViewModelInputs { get }
  /// Output interface for the discovery postcard view model.
  var outputs: DiscoveryPostcardViewModelOutputs { get }
}

