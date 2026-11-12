import Foundation
import KsApi
import Prelude
import ReactiveSwift
import StripePaymentSheet

/// View model managing stored credit cards, card deletion, and Stripe PaymentSheet SetupIntents.
public final class PaymentMethodSettingsViewModel: PaymentMethodsViewModelType,
  PaymentMethodSettingsViewModelInputs, PaymentMethodSettingsViewModelOutputs {
  let stripeIntentService: StripeIntentServiceType

  /// Creates a new `PaymentMethodSettingsViewModel` using `stripeIntentService`.
  public init(stripeIntentService: StripeIntentServiceType) {
    self.stripeIntentService = stripeIntentService

    self.reloadData = self.viewDidLoadProperty.signal

    let paymentMethodsEvent = Signal.merge(
      self.viewDidLoadProperty.signal,
      self.addNewCardSucceededProperty.signal.ignoreValues(),
      self.failedToAddNewCardProperty.signal
    )
    .switchMap { _ in
      AppEnvironment.current.apiService.fetchGraphUser(withStoredCards: true)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

    let paymentSheetEnabled: Bool = true

    let deletePaymentMethodEvents = self.didDeleteCreditCardSignal
      .map(first)
      .switchMap { creditCard in
        AppEnvironment.current.apiService.deletePaymentMethod(input: .init(paymentSourceId: creditCard.id))
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let deletePaymentMethodEventsErrors = deletePaymentMethodEvents.errors()

    self.showAlert = deletePaymentMethodEventsErrors
      .ignoreValues()
      .map {
        Strings.Something_went_wrong_and_we_were_unable_to_remove_your_payment_method_please_try_again()
      }

    let initialPaymentMethodsValues = paymentMethodsEvent
      .values().map { $0.me.storedCards.storedCards }

    let deletePaymentMethodValues = deletePaymentMethodEvents.values()
      .map { $0.storedCards }

    let latestPaymentMethods = Signal.merge(
      initialPaymentMethodsValues,
      deletePaymentMethodValues
    )

    let newSetupIntentCards = self.newSetupIntentCreditCardProperty.signal.skipNil()
      .map { setupIntent in
        CreatePaymentSourceSetupIntentInput.init(intentClientSecret: setupIntent, reuseable: true)
      }
      .switchMap { inputValue in
        AppEnvironment.current.apiService.addPaymentSheetPaymentSource(input: inputValue)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .map { (envelope: CreatePaymentSourceEnvelope) in envelope.createPaymentSource }
          .materialize()
      }

    self.addNewCardSucceededProperty <~ newSetupIntentCards.values()
      .map { _ in Strings.Got_it_your_changes_have_been_saved() }

    self.paymentMethods = Signal.merge(
      initialPaymentMethodsValues,
      deletePaymentMethodEventsErrors
        .withLatest(from: latestPaymentMethods)
        .map(second)
    )

    let hasAtLeastOneCard = Signal.merge(
      self.paymentMethods
        .map { !$0.isEmpty },
      deletePaymentMethodValues
        .map { !$0.isEmpty },
      self.didDeleteCreditCardSignal.map(second)
        .map { $0 > 0 }
    )

    self.editButtonIsEnabled = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst(false),
      hasAtLeastOneCard
    )
    .skipRepeats()

    self.presentBanner = self.addNewCardSucceededProperty.signal.skipNil()

    self.tableViewIsEditing = self.tableViewIsEditingProperty.signal

    self.editButtonTitle = self.tableViewIsEditing
      .map { $0 ? Strings.Done() : Strings.discovery_favorite_categories_buttons_edit() }

    let createSetupIntentEvent = self.didTapAddCardButtonProperty.signal
      .switchMap { SignalProducer(value: paymentSheetEnabled) }
      .filter(isTrue)
      .switchMap { (_: Bool) -> SignalProducer<Signal<PaymentSheetSetupData, ErrorEnvelope>.Event, Never> in
        stripeIntentService.createSetupIntent(for: nil, context: .profileSettings)
          .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .switchMap { envelope -> SignalProducer<PaymentSheetSetupData, ErrorEnvelope> in
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = Strings.general_accessibility_kickstarter()
            configuration.allowsDelayedPaymentMethods = true

            // Log in to Stripe Link
            configuration.defaultBillingDetails.email = AppEnvironment.current.currentUserEmail

            let data = PaymentSheetSetupData(
              clientSecret: envelope.clientSecret,
              configuration: configuration
            )
            return SignalProducer(value: data)
          }
          .materialize()
      }

    self.cancelAddNewCardLoadingState = self.shouldCancelPaymentSheetAppearance.signal.filter(isTrue)
      .ignoreValues()

    self.goToPaymentSheet = createSetupIntentEvent.values()
      .withLatestFrom(self.shouldCancelPaymentSheetAppearance.signal)
      .map { data, shouldCancel -> PaymentSheetSetupData? in
        shouldCancel ? nil : data
      }
      .skipNil()

    let stopEditing = Signal.merge(
      self.editButtonIsEnabled.filter(isFalse),
      self.goToPaymentSheet.signal.ignoreValues().mapConst(false)
    )

    self.tableViewIsEditingProperty <~ Signal.merge(
      stopEditing,
      self.editButtonTappedSignal
        .withLatest(from: self.tableViewIsEditingProperty.signal)
        .map(second)
        .negate()
    )

    self.errorLoadingPaymentMethodsOrSetupIntent = Signal.merge(
      paymentMethodsEvent.errors(),
      createSetupIntentEvent.errors(),
      newSetupIntentCards.errors()
    )
    .map { $0.localizedDescription }

    self.shouldCancelPaymentSheetAppearance <~ Signal
      .merge(
        self.didTapAddCardButtonProperty.signal
          .ignoreValues()
          .mapConst(false),
        self.addNewCardSucceededProperty.signal
          .ignoreValues()
          .mapConst(true),
        self.errorLoadingPaymentMethodsOrSetupIntent.signal
          .ignoreValues()
          .mapConst(true)
      )

    self.setStripePublishableKey = self.viewDidLoadProperty.signal
      .map { _ in AppEnvironment.current.environmentType.stripePublishableKey }
  }

  // Stores the table view's editing state as it is affected by multiple signals
  private let tableViewIsEditingProperty = MutableProperty<Bool>(false)

  fileprivate let (didDeleteCreditCardSignal, didDeleteCreditCardObserver) =
    Signal<
      (UserCreditCards.CreditCard, Int),
      Never
    >.pipe()
  /// Deletes `creditCard` and updates button enabled state using `visibleCellCount`.
  public func didDelete(_ creditCard: UserCreditCards.CreditCard, visibleCellCount: Int) {
    self.didDeleteCreditCardObserver.send(value: (creditCard, visibleCellCount))
  }

  fileprivate let (editButtonTappedSignal, editButtonTappedObserver) = Signal<(), Never>.pipe()
  /// Toggles editing mode for saved cards.
  public func editButtonTapped() {
    self.editButtonTappedObserver.send(value: ())
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the payment methods screen loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let failedToAddNewCardProperty = MutableProperty(())
  /// Reloads stored cards after a failed or aborted card addition attempt.
  public func failedToAddNewCard() {
    self.failedToAddNewCardProperty.value = ()
  }

  fileprivate let didTapAddCardButtonProperty = MutableProperty(())
  /// Starts Stripe SetupIntent creation to present PaymentSheet.
  public func paymentMethodsFooterViewDidTapAddNewCardButton() {
    self.didTapAddCardButtonProperty.value = ()
  }

  fileprivate let addNewCardSucceededProperty = MutableProperty<String?>(nil)
  /// Presents a confirmation banner with `message` after saving a new card.
  public func addNewCardSucceeded(with message: String) {
    self.addNewCardSucceededProperty.value = message
  }

  private let newSetupIntentCreditCardProperty =
    MutableProperty<String?>(nil)
  /// Attaches the Stripe `setupIntent` payment source to the user's account.
  public func paymentSheetDidAdd(
    setupIntent: String
  ) {
    self.newSetupIntentCreditCardProperty.value = setupIntent
  }

  private let shouldCancelPaymentSheetAppearance = MutableProperty<Bool>(false)
  /// Updates whether pending PaymentSheet presentation should cancel.
  public func shouldCancelPaymentSheetAppearance(state: Bool) {
    self.shouldCancelPaymentSheetAppearance.value = state
  }

  /// Emits when add-card loading state should stop due to cancellation.
  public let cancelAddNewCardLoadingState: Signal<Void, Never>
  /// Emits whether the Edit navigation bar button is enabled.
  public let editButtonIsEnabled: Signal<Bool, Never>
  /// Emits localized title (`"Edit"` vs `"Done"`) for the bar button item.
  public let editButtonTitle: Signal<String, Never>
  /// Emits localized error banner copy when loading cards or SetupIntents fails.
  public let errorLoadingPaymentMethodsOrSetupIntent: Signal<String, Never>
  /// Emits `PaymentSheetSetupData` to launch Stripe PaymentSheet.
  public let goToPaymentSheet: Signal<PaymentSheetSetupData, Never>
  /// Emits the current array of stored user credit cards.
  public let paymentMethods: Signal<[UserCreditCards.CreditCard], Never>
  /// Emits localized confirmation banner copy after saving a new card.
  public let presentBanner: Signal<String, Never>
  /// Emits when initial data load begins.
  public let reloadData: Signal<Void, Never>
  /// Emits the active Stripe publishable key for client SDK configuration.
  public let setStripePublishableKey: Signal<String, Never>
  /// Emits localized alert copy when deleting a payment method fails.
  public let showAlert: Signal<String, Never>
  /// Emits whether the cards table view is in editing mode.
  public let tableViewIsEditing: Signal<Bool, Never>

  /// Inputs receiver (`self`).
  public var inputs: PaymentMethodSettingsViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: PaymentMethodSettingsViewModelOutputs { return self }
}
