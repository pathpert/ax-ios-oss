import Foundation
import GraphAPI
import KsApi
import Prelude
import ReactiveSwift

/// Immutable value type representing `PostCampaignCheckoutCompletionOutputs`.
internal struct PostCampaignCheckoutCompletionOutputs {
  let validateCheckoutSuccess: Signal<PaymentSourceValidation, Never>
  let goToApplePayPaymentAuthorization: Signal<PostCampaignPaymentAuthorizationData, Never>
  let checkoutComplete: Signal<ThanksPageData, Never>
  let checkoutError: Signal<ErrorEnvelope, Never>
  let showErrorBannerWithMessage: Signal<String, Never>
  let processingViewIsHidden: Signal<Bool, Never>
  let pledgeButtonEnabled: Signal<Bool, Never>
}

internal func makePostCampaignCheckoutFlowSignals(
  project: Signal<Project, Never>,
  baseReward: Signal<Reward, Never>,
  allRewardsTotal: Signal<Double, Never>,
  bonusAmount: Signal<Double, Never>,
  allRewardsShippingTotal: Signal<Double, Never>,
  pledgeTotal: Signal<Double, Never>,
  checkoutId: Signal<String, Never>,
  backingId: Signal<String, Never>,
  createCheckoutErrors: Signal<ErrorEnvelope, Never>,
  selectedCard: Signal<PaymentSourceSelected, Never>,
  stripeIntentService: StripeIntentServiceType,
  viewDidLoadSignal: Signal<Void, Never>,
  submitButtonTappedSignal: Signal<Void, Never>,
  applePayButtonTappedSignal: Signal<Void, Never>,
  applePayPaymentMethodIdSignal: Signal<String, Never>,
  applePayContextDidCompleteSignal: Signal<Void, Never>,
  confirmPaymentSuccessfulSignal: Signal<String, Never>,
  checkoutTerminatedSignal: Signal<Void, Never>
) -> PostCampaignCheckoutCompletionOutputs {
  let paymentIntentEvent = Signal.combineLatest(project, pledgeTotal, checkoutId, backingId)
    .switchMap { project, pledgeTotal, checkoutId, backingId in
      stripeIntentService.createPaymentIntent(
        for: project.graphID,
        backingId: backingId,
        checkoutId: checkoutId,
        pledgeTotal: pledgeTotal
      ).materialize()
    }

  let paymentIntentClientSecret = paymentIntentEvent.values().map { $0.clientSecret }
  let paymentIntentErrors = paymentIntentEvent.errors()
  let paymentIntentClientSecretForExistingCards = paymentIntentClientSecret.takeWhen(selectedCard)
  let validateCheckoutExistingCardInput = Signal.combineLatest(
    checkoutId,
    selectedCard,
    paymentIntentClientSecretForExistingCards
  )

  let validateCheckoutExistingCard = validateCheckoutExistingCardInput
    .takeWhen(submitButtonTappedSignal)
    .switchMap { checkoutId, selectedCard, paymentIntentClientSecret in
      assert(
        selectedCard.stripePaymentMethodId.isSome && selectedCard.stripePaymentMethodId != "",
        "Payment method ID should not be missing in a late pledge context."
      )
      return AppEnvironment.current.apiService.validateCheckout(
        checkoutId: checkoutId,
        paymentSourceId: selectedCard.stripePaymentMethodId ?? "",
        paymentIntentClientSecret: paymentIntentClientSecret
      )
      .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      .materialize()
    }

  let validateCheckoutSuccess = Signal
    .combineLatest(paymentIntentClientSecretForExistingCards, selectedCard)
    .takeWhen(validateCheckoutExistingCard.values())
    .map { clientSecret, card in
      PaymentSourceValidation(
        paymentIntentClientSecret: clientSecret,
        selectedCardStripeCardId: card.stripePaymentMethodId,
        requiresConfirmation: true
      )
    }

  let startApplePayFlow = Signal.combineLatest(project, pledgeTotal, checkoutId, backingId)
    .takeWhen(applePayButtonTappedSignal)
  let paymentIntentClientSecretForApplePay = paymentIntentClientSecret.takeWhen(startApplePayFlow)

  let goToApplePayPaymentAuthorization = Signal.combineLatest(
    project,
    baseReward,
    allRewardsTotal,
    bonusAmount,
    allRewardsShippingTotal,
    pledgeTotal,
    paymentIntentClientSecretForApplePay
  ).map(makePostCampaignApplePayAuthorizationData)

  let validateCheckoutWithApplePay = Signal.combineLatest(
    paymentIntentClientSecretForApplePay,
    checkoutId,
    applePayPaymentMethodIdSignal
  )
  .takeWhen(applePayContextDidCompleteSignal)
  .switchMap { clientSecret, checkoutId, paymentMethodId in
    AppEnvironment.current.apiService.validateCheckout(
      checkoutId: checkoutId,
      paymentSourceId: paymentMethodId,
      paymentIntentClientSecret: clientSecret
    )
    .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    .materialize()
  }

  let validateCheckoutError = Signal.merge(
    validateCheckoutExistingCard.errors(),
    validateCheckoutWithApplePay.errors()
  )

  let completeCheckoutWithCreditCardInput = Signal
    .combineLatest(confirmPaymentSuccessfulSignal, checkoutId, selectedCard)
    .takeWhen(confirmPaymentSuccessfulSignal)
    .map { args -> GraphAPI.CompleteOnSessionCheckoutInput in
      makeCompleteOnSessionCheckoutInput(
        checkoutId: args.1,
        clientSecret: args.0,
        paymentSourceId: args.2.savedCreditCardId,
        reusable: true
      )
    }

  let completeCheckoutWithApplePayInput = Signal
    .combineLatest(paymentIntentClientSecretForApplePay, checkoutId)
    .takeWhen(validateCheckoutWithApplePay.values())
    .map { args -> GraphAPI.CompleteOnSessionCheckoutInput in
      makeCompleteOnSessionCheckoutInput(
        checkoutId: args.1,
        clientSecret: args.0,
        paymentSourceId: nil,
        reusable: false
      )
    }

  let checkoutCompleteSignal = Signal
    .merge(completeCheckoutWithCreditCardInput, completeCheckoutWithApplePayInput)
    .switchMap { AppEnvironment.current.apiService.completeOnSessionCheckout(input: $0).materialize() }

  let checkoutComplete = Signal.combineLatest(project, baseReward, pledgeTotal)
    .map { args -> ThanksPageData in
      ThanksPageData(project: args.0, reward: args.1, checkoutData: nil, pledgeTotal: args.2)
    }
    .takeWhen(checkoutCompleteSignal.signal.values())

  let processingViewIsHidden = Signal.merge(
    submitButtonTappedSignal.mapConst(false),
    startApplePayFlow.mapConst(false),
    paymentIntentErrors.mapConst(true),
    validateCheckoutError.mapConst(true),
    checkoutTerminatedSignal.mapConst(true),
    checkoutCompleteSignal.signal.mapConst(true)
  )

  let pledgeButtonEnabled = Signal.merge(
    viewDidLoadSignal.mapConst(false),
    validateCheckoutExistingCardInput.mapConst(true)
  ).skipRepeats()

  return PostCampaignCheckoutCompletionOutputs(
    validateCheckoutSuccess: validateCheckoutSuccess,
    goToApplePayPaymentAuthorization: goToApplePayPaymentAuthorization,
    checkoutComplete: checkoutComplete,
    checkoutError: checkoutCompleteSignal.signal.errors(),
    showErrorBannerWithMessage: Signal.merge(createCheckoutErrors, validateCheckoutError)
      .map(mapPostCampaignCheckoutError),
    processingViewIsHidden: processingViewIsHidden,
    pledgeButtonEnabled: pledgeButtonEnabled
  )
}
