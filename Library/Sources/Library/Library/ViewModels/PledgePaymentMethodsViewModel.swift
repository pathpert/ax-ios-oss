import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Manages saved credit cards, Stripe PaymentSheet card creation, and payment source selection during checkout.
public final class PledgePaymentMethodsViewModel: PledgePaymentMethodsViewModelType,
  PledgePaymentMethodsViewModelInputs, PledgePaymentMethodsViewModelOutputs {
  let stripeIntentService: StripeIntentServiceType

  /// Creates a payment methods view model backed by the given Stripe intent service.
  public init(stripeIntentService: StripeIntentServiceType) {
    self.stripeIntentService = stripeIntentService

    let configureWithValue = Signal.combineLatest(
      self.viewDidLoadProperty.signal,
      self.configureWithValueProperty.signal.skipNil()
    )
    .map(second)

    let setup = makePledgePaymentMethodsSignals(
      configureWithValue: configureWithValue,
      newStripeIntentCreditCardSignal: self.newStripeIntentCreditCardProperty.signal.skipNil(),
      didSelectRowAtIndexPathSignal: self.didSelectRowAtIndexPathProperty.signal.skipNil(),
      stripeIntentService: stripeIntentService
    )

    self.reloadPaymentMethods = setup.reloadPaymentMethods
    self.notifyDelegateCreditCardSelected = self.reloadPaymentMethods
      .map(\.selectedPaymentMethod)
      .skipNil()
      .skipRepeats()

    self.shouldCancelPaymentSheetAppearance <~ setup.showLoadingIndicator.mapConst(false)
    self.shouldCancelPaymentSheetAppearance <~ setup.updatedCards.signal.mapConst(true)

    let safeShouldCancelPaymentSheet = Signal.combineLatest(
      self.shouldCancelPaymentSheetAppearance.signal,
      configureWithValue
    )
    .map(first)

    self.goToAddCardViaStripeScreen = setup.createSetupIntentEvent.values()
      .withLatestFrom(safeShouldCancelPaymentSheet)
      .map { data, shouldCancel -> PaymentSheetSetupData? in shouldCancel ? nil : data }
      .skipNil()

    self.notifyDelegateLoadPaymentMethodsError = Signal
      .merge(setup.storedCardsErrors, setup.createSetupIntentEvent.errors(), setup.newlyAddedCardErrors)
      .map { $0.localizedDescription }

    self.updateAddNewCardLoading = Signal.merge(
      setup.createSetupIntentEvent.errors().mapConst(false),
      safeShouldCancelPaymentSheet.negate()
    )

    self.willSelectRowAtIndexPathReturnProperty <~ self.reloadPaymentMethods
      .map { ($0.existingPaymentMethods, $0.newPaymentMethods) }
      .takePairWhen(self.willSelectRowAtIndexPathProperty.signal.skipNil())
      .map(canSelectPaymentMethodRow)

    bindPaymentSheetAppearanceTracking(
      project: configureWithValue.map(\.project),
      viewDidLoadSignal: self.viewDidLoadProperty.signal,
      stripePaymentSheetDidAppearSignal: self.stripePaymentSheetDidAppearProperty.signal
    )
  }

  private let configureWithValueProperty = MutableProperty<PledgePaymentMethodsValue?>(nil)
  /// Configures the view model with user, project, checkout, and context values.
  public func configure(with value: PledgePaymentMethodsValue) {
    self.configureWithValueProperty.value = value
  }

  private let newStripeIntentCreditCardProperty = MutableProperty<(String, String?)?>(nil)
  /// Records a new payment card added via Stripe PaymentSheet.
  public func paymentSheetDidAdd(clientSecret: String, paymentMethod: String?) {
    self.newStripeIntentCreditCardProperty.value = (clientSecret, paymentMethod)
  }

  private let shouldCancelPaymentSheetAppearance = MutableProperty<Bool>(true)
  /// Sets whether Stripe PaymentSheet presentation should cancel.
  public func shouldCancelPaymentSheetAppearance(state: Bool) {
    self.shouldCancelPaymentSheetAppearance.value = state
  }

  private let stripePaymentSheetDidAppearProperty = MutableProperty(())
  /// Tracks that Stripe PaymentSheet appeared on screen.
  public func stripePaymentSheetDidAppear() {
    self.stripePaymentSheetDidAppearProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let didSelectRowAtIndexPathProperty = MutableProperty<IndexPath?>(nil)
  /// Handles selecting a payment method or add-card row.
  public func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
    self.didSelectRowAtIndexPathProperty.value = indexPath
  }

  private let willSelectRowAtIndexPathProperty = MutableProperty<IndexPath?>(nil)
  private let willSelectRowAtIndexPathReturnProperty = MutableProperty<IndexPath?>(nil)
  /// Returns the selectable `IndexPath` if the row at `indexPath` can be selected.
  public func willSelectRowAtIndexPath(_ indexPath: IndexPath) -> IndexPath? {
    self.willSelectRowAtIndexPathProperty.value = indexPath
    return self.willSelectRowAtIndexPathReturnProperty.value
  }

  /// Opens Stripe PaymentSheet to add a new payment method.
  public let goToAddCardViaStripeScreen: Signal<PaymentSheetSetupData, Never>
  /// Notifies delegate when the selected credit card changes.
  public let notifyDelegateCreditCardSelected: Signal<PaymentSourceSelected, Never>
  /// Emits localized error message if payment methods fail to load.
  public let notifyDelegateLoadPaymentMethodsError: Signal<String, Never>
  /// Reloads payment method cells and selection state.
  public let reloadPaymentMethods: Signal<PledgePaymentMethodsAndSelectionData, Never>
  /// Toggles loading indicator for the add-new-card row.
  public let updateAddNewCardLoading: Signal<Bool, Never>

  /// Input interface.
  public var inputs: PledgePaymentMethodsViewModelInputs { return self }
  /// Output interface.
  public var outputs: PledgePaymentMethodsViewModelOutputs { return self }
}
