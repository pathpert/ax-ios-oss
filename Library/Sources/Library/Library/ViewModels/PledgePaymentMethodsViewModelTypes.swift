import KsApi
import PassKit
import ReactiveSwift
import StripePaymentSheet
import UIKit

/// Sections displayed in the pledge payment methods table view.
public enum PaymentMethodsTableViewSection: Int {
  /// Saved or newly added payment methods available for selection.
  case paymentMethods
  /// Action row to add a new payment card via Stripe PaymentSheet.
  case addNewCard
  /// Loading indicator row displayed while fetching payment methods.
  case loading
}

/// Configuration tuple passed to `PledgePaymentMethodsViewModel.configure(with:)`.
public typealias PledgePaymentMethodsValue = (
  user: User,
  project: Project,
  checkoutId: String,
  reward: Reward,
  context: PledgeViewContext,
  refTag: RefTag?
)

/// Stripe PaymentSheet initialization payload returned after creating a SetupIntent.
///
/// Negative Constraint: Present `PaymentSheet` only once per `clientSecret`; request a fresh SetupIntent if dismissed or if pledge context changes.
public struct PaymentSheetSetupData {
  /// Stripe SetupIntent client secret returned by `createStripeSetupIntent`.
  public let clientSecret: String
  /// Preconfigured Stripe `PaymentSheet.Configuration` (merchant name, user email, delayed payment settings).
  public let configuration: PaymentSheet.Configuration

  /// Creates a `PaymentSheetSetupData` payload.
  public init(clientSecret: String, configuration: PaymentSheet.Configuration) {
    self.clientSecret = clientSecret
    self.configuration = configuration
  }
}

/// Input events handled by `PledgePaymentMethodsViewModel`.
public protocol PledgePaymentMethodsViewModelInputs {
  /// Updates whether Stripe PaymentSheet presentation should be cancelled if selection changes.
  func shouldCancelPaymentSheetAppearance(state: Bool)
  /// Notifies the view model that the Stripe PaymentSheet appeared.
  func stripePaymentSheetDidAppear()
  /// Configures the view model with user, project, checkout, and context values.
  func configure(with value: PledgePaymentMethodsValue)
  /// Handles user row selection in the payment methods table view.
  func didSelectRowAtIndexPath(_ indexPath: IndexPath)
  /// Handles completion of adding a new card via Stripe PaymentSheet.
  func paymentSheetDidAdd(
    clientSecret: String,
    paymentMethod: String?
  )
  /// Notifies the view model that the view loaded.
  func viewDidLoad()
  /// Evaluates whether a row at `indexPath` may be selected.
  func willSelectRowAtIndexPath(_ indexPath: IndexPath) -> IndexPath?
}

/// Output signals emitted by `PledgePaymentMethodsViewModel`.
public protocol PledgePaymentMethodsViewModelOutputs {
  /// Emits setup data to present Stripe PaymentSheet for adding a card.
  var goToAddCardViaStripeScreen: Signal<PaymentSheetSetupData, Never> { get }
  /// Emits the currently selected credit card payment source.
  var notifyDelegateCreditCardSelected: Signal<PaymentSourceSelected, Never> { get }
  /// Emits a localized error message if fetching cards or creating a SetupIntent fails.
  var notifyDelegateLoadPaymentMethodsError: Signal<String, Never> { get }
  /// Emits updated payment method list data and loading state.
  var reloadPaymentMethods: Signal<PledgePaymentMethodsAndSelectionData, Never> { get }
  /// Emits loading state updates for the add-new-card row.
  var updateAddNewCardLoading: Signal<Bool, Never> { get }
}

/// Protocol unifying inputs and outputs for `PledgePaymentMethodsViewModel`.
public protocol PledgePaymentMethodsViewModelType {
  /// Input receiver for payment methods UI events.
  var inputs: PledgePaymentMethodsViewModelInputs { get }
  /// Output signal provider for payment methods UI updates.
  var outputs: PledgePaymentMethodsViewModelOutputs { get }
}

