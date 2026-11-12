import Foundation
import KsApi
import ReactiveSwift

/// Inputs accepted by `PaymentMethodSettingsViewModel`.
public protocol PaymentMethodSettingsViewModelInputs {
  /// Signals that adding a new card via Stripe PaymentSheet failed or was canceled.
  func failedToAddNewCard()
  /// Requests deletion of `creditCard` given the remaining `visibleCellCount`.
  func didDelete(_ creditCard: UserCreditCards.CreditCard, visibleCellCount: Int)
  /// Toggles table editing mode.
  func editButtonTapped()
  /// Requests creating a SetupIntent to present the add-card Stripe PaymentSheet.
  func paymentMethodsFooterViewDidTapAddNewCardButton()
  /// Submits the Stripe `setupIntent` client secret returned by PaymentSheet.
  func paymentSheetDidAdd(
    setupIntent: String
  )
  /// Controls whether an in-flight PaymentSheet presentation should cancel cleanly.
  func shouldCancelPaymentSheetAppearance(state: Bool)
  /// Notifies the view model that the settings screen loaded.
  func viewDidLoad()
}

/// Reactive outputs emitted by `PaymentMethodSettingsViewModel`.
public protocol PaymentMethodSettingsViewModelOutputs {
  /// Emits when add-card loading state should stop due to cancellation.
  var cancelAddNewCardLoadingState: Signal<Void, Never> { get }
  /// Emits whether the Edit navigation bar button is enabled.
  var editButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits localized title (`"Edit"` vs `"Done"`) for the bar button item.
  var editButtonTitle: Signal<String, Never> { get }
  /// Emits localized error banner copy when loading cards or SetupIntents fails.
  var errorLoadingPaymentMethodsOrSetupIntent: Signal<String, Never> { get }
  /// Emits `PaymentSheetSetupData` to launch Stripe PaymentSheet.
  var goToPaymentSheet: Signal<PaymentSheetSetupData, Never> { get }
  /// Emits the current array of stored user credit cards.
  var paymentMethods: Signal<[UserCreditCards.CreditCard], Never> { get }
  /// Emits localized confirmation banner copy after saving a new card.
  var presentBanner: Signal<String, Never> { get }
  /// Emits when initial data load begins.
  var reloadData: Signal<Void, Never> { get }
  /// Emits the active Stripe publishable key for client SDK configuration.
  var setStripePublishableKey: Signal<String, Never> { get }
  /// Emits localized alert copy when deleting a payment method fails.
  var showAlert: Signal<String, Never> { get }
  /// Emits whether the cards table view is in editing mode.
  var tableViewIsEditing: Signal<Bool, Never> { get }
}

/// Combined inputs/outputs contract for managing saved payment methods.
public protocol PaymentMethodsViewModelType {
  /// Input receiver.
  var inputs: PaymentMethodSettingsViewModelInputs { get }
  /// Output signal provider.
  var outputs: PaymentMethodSettingsViewModelOutputs { get }
}

