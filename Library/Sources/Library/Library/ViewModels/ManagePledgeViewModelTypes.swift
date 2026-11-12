import Foundation
import KsApi
import ReactiveSwift

/// Typed parameters configuring `ManagePledgeViewController` and `ManagePledgeViewModel`.
/// - Note: Both fields identify remote resources by ID or slug; `backingParam` may be `nil` when only the project parameter is known upfront and must be resolved after fetching the project.
public struct ManagePledgeViewParamConfigData: Equatable {
  /// Parameter identifying the backed project.
  public let projectParam: Param
  /// Optional parameter identifying the backing, if already known.
  public let backingParam: Param?

  /// Creates configuration parameters for managing an existing pledge.
  public init(projectParam: Param, backingParam: Param?) {
    self.projectParam = projectParam
    self.backingParam = backingParam
  }
}

/// Action sheet menu options available when managing an existing pledge or viewing creator pledge details.
public enum ManagePledgeAlertAction: CaseIterable {
  case editPledgeOverTimePledge
  case changePaymentMethod
  case chooseAnotherReward
  case contactCreator
  case cancelPledge
  case viewRewards
}

/// Inputs accepted by `ManagePledgeViewModel`.
public protocol ManagePledgeViewModelInputs {
  /// Triggers reloading backing details via pull-to-refresh or pledge update completion.
  func beginRefresh()
  /// Supplies project and optional backing route parameters to load.
  func configureWith(_ params: ManagePledgeViewParamConfigData)
  /// Notifies that the cancel-pledge flow completed with confirmation `message`.
  func cancelPledgeDidFinish(with message: String)
  /// Handles tap on the Fix Payment Method button for an errored backing.
  func fixButtonTapped()
  /// Opens the contextual pledge management action sheet.
  func menuButtonTapped()
  /// Handles user selection of a specific `ManagePledgeAlertAction`.
  func menuOptionSelected(with action: ManagePledgeAlertAction)
  /// Handles completion of a reward or payment update with a success banner `message`.
  func pledgeViewControllerDidUpdatePledgeWithMessage(_ message: String)
  /// Notifies the view model that the Manage Pledge screen finished loading.
  func viewDidLoad()
  /// Handles user tap on the Pledge Over Time terms-of-use link.
  func termsOfUseTapped(with helpType: HelpType)
}

/// Reactive outputs emitted by `ManagePledgeViewModel`.
public protocol ManagePledgeViewModelOutputs {
  /// Emits payment method card summary data for the current backing.
  var configurePaymentMethodView: Signal<ManagePledgePaymentMethodViewData, Never> { get }
  /// Emits itemized pledge summary data for `ManagePledgeSummaryViewController`.
  var configurePledgeSummaryView: Signal<ManagePledgeSummaryViewData, Never> { get }
  /// Emits when the pull-to-refresh control should finish animating.
  var endRefreshing: Signal<Void, Never> { get }
  /// Emits configuration to push `CancelPledgeViewController`.
  var goToCancelPledge: Signal<CancelPledgeViewData, Never> { get }
  /// Emits pledge configuration to update the backing's payment method.
  var goToChangePaymentMethod: Signal<PledgeViewData, Never> { get }
  /// Emits creator message recipient subject and analytics context.
  var goToContactCreator: Signal<(MessageSubject, KSRAnalytics.MessageDialogContext), Never> { get }
  /// Emits pledge configuration to fix a failed payment method.
  var goToFixPaymentMethod: Signal<PledgeViewData, Never> { get }
  /// Emits project when viewing or switching rewards.
  var goToRewards: Signal<Project, Never> { get }
  /// Emits project when editing a Pledge Over Time backing.
  var goToEditPledgeOverTime: Signal<Project, Never> { get }
  /// Emits the project and distinct list of backed reward + add-on items for display.
  var loadProjectAndRewardsIntoDataSource: Signal<(Project, [Reward]), Never> { get }
  /// Emits when an initial load failure requires showing a pull-to-refresh recovery header.
  var loadPullToRefreshHeaderView: Signal<(), Never> { get }
  /// Emits an optional completion message when Manage Pledge should dismiss back to caller.
  var notifyDelegateManagePledgeViewControllerFinishedWithMessage: Signal<String?, Never> { get }
  /// Emits whether the payment method card section is hidden.
  var paymentMethodViewHidden: Signal<Bool, Never> { get }
  /// Emits localized section header (`"Pledge details"` vs `"Your pledge details"`).
  var pledgeDetailsSectionLabelText: Signal<String, Never> { get }
  /// Emits whether the navigation bar actions menu button is hidden.
  var rightBarButtonItemHidden: Signal<Bool, Never> { get }
  /// Emits available menu actions when the user taps the management menu button.
  var showActionSheetMenuWithOptions: Signal<[ManagePledgeAlertAction], Never> { get }
  /// Emits localized error banner copy when loading or restricted cancellation fails.
  var showErrorBannerWithMessage: Signal<String, Never> { get }
  /// Emits localized success banner copy after pledge updates.
  var showSuccessBannerWithMessage: Signal<String, Never> { get }
  /// Emits `HelpType` for opening help documentation in a web view.
  var showWebHelp: Signal<HelpType, Never> { get }
  /// Emits when the pull-to-refresh indicator should begin animating.
  var startRefreshing: Signal<(), Never> { get }
  /// Emits the localized navigation bar title.
  var title: Signal<String, Never> { get }
  /// Emits Plot installment increments when displaying a Pledge Over Time schedule.
  var configurePlotPaymentScheduleView: Signal<[PledgePaymentIncrement], Never> { get }
  /// Emits whether the Pledge Over Time schedule section is hidden.
  var plotPaymentScheduleViewHidden: Signal<Bool, Never> { get }
}

/// Combined inputs/outputs contract for managing an existing backing.
public protocol ManagePledgeViewModelType {
  /// Input receiver.
  var inputs: ManagePledgeViewModelInputs { get }
  /// Output signal provider.
  var outputs: ManagePledgeViewModelOutputs { get }
}

