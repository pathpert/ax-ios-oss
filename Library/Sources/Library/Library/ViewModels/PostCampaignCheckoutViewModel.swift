import Foundation
import GraphAPI
import KsApi
import PassKit
import Prelude
import ReactiveSwift
import Stripe

/// Coordinates checkout creation, Stripe PaymentIntent validation, Apple Pay authorization, and completion for post-campaign late pledges.
public class PostCampaignCheckoutViewModel: PostCampaignCheckoutViewModelType,
  PostCampaignCheckoutViewModelInputs,
  PostCampaignCheckoutViewModelOutputs {
  let stripeIntentService: StripeIntentServiceType

  /// Creates a post-campaign checkout view model backed by the given Stripe intent service.
  public init(stripeIntentService: StripeIntentServiceType) {
    self.stripeIntentService = stripeIntentService

    let initialData = Signal.combineLatest(
      self.configureWithDataProperty.signal,
      self.viewDidLoadProperty.signal
    )
    .map(first)
    .skipNil()

    let context = initialData.map(\.context)
    let rewards = initialData.map(\.rewards)
    let baseReward = initialData.map(\.rewards).map(\.first).skipNil()
    let project = initialData.map(\.project)
    let selectedShippingRule = initialData.map(\.selectedShippingRule)
    let selectedQuantities = initialData.map(\.selectedQuantities)
    let refTag = initialData.map(\.refTag)
    let bonusAmount = initialData.map { $0.bonusSupport ?? 0.0 }
    let backing = project.map(\.personalization.backing).skipNil()

    self.loginSignupUseCase = LoginSignupUseCase(
      withLoginIntent: .backProject,
      initialData: initialData.ignoreValues()
    )
    self.paymentMethodsUseCase = PaymentMethodsUseCase(
      initialData: initialData,
      isLoggedIn: self.loginSignupUseCase.dataOutputs.isLoggedIn
    )

    // MARK: Calculate totals

    let calculatedShippingTotal = Signal.combineLatest(
      selectedShippingRule.skipNil(),
      rewards,
      selectedQuantities
    ).map(calculateShippingTotal)

    let allRewardsShippingTotal = Signal.merge(
      selectedShippingRule.filter(isNil).mapConst(0.0),
      calculatedShippingTotal
    )
    let allRewardsTotal = Signal.combineLatest(rewards, selectedQuantities)
      .map(calculateAllRewardsTotal)
    let calculatedPledgeTotal = Signal.combineLatest(
      bonusAmount,
      allRewardsShippingTotal,
      allRewardsTotal
    ).map(calculatePledgeTotal)
    let pledgeTotal = Signal.merge(backing.map(\.amount), calculatedPledgeTotal)

    // MARK: Create checkout

    let createCheckoutEvents = Signal.combineLatest(
      self.loginSignupUseCase.dataOutputs.isLoggedIn,
      Signal.combineLatest(
        project,
        rewards,
        selectedQuantities,
        selectedShippingRule,
        pledgeTotal,
        refTag
      )
    )
    .filter { isLoggedIn, _ in isLoggedIn }
    .map { _, data in
      makePostCampaignCreateCheckoutInput(
        project: data.0,
        rewards: data.1,
        selectedQuantities: data.2,
        selectedShippingRule: data.3,
        pledgeTotal: data.4,
        refTag: data.5
      )
    }
    .switchMap { input in
      AppEnvironment.current.apiService
        .createCheckout(input: input)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

    let checkoutId = createCheckoutEvents.values().map { decodePostCampaignCheckoutId($0.checkout.id) }
    let backingId = createCheckoutEvents.values().map(\.checkout.backingId)
    let createCheckoutErrors = createCheckoutEvents.errors()

    // MARK: Configure views

    self.showWebHelp = Signal.merge(
      self.termsOfUseTappedSignal,
      self.pledgeDisclaimerViewDidTapLearnMoreSignal.mapConst(.trust)
    )
    self.configurePledgeRewardsSummaryViewWithData = Signal.combineLatest(
      initialData,
      allRewardsShippingTotal,
      pledgeTotal
    ).compactMap(makePostCampaignSummaryPayload)

    self.configureStripeIntegration = Signal.combineLatest(initialData, context)
      .filter { !$1.paymentMethodsViewHidden }
      .ignoreValues()
      .map { _ in
        StripeConfigurationData(
          merchantIdentifier: Secrets.ApplePay.merchantIdentifier,
          publishableKey: AppEnvironment.current.environmentType.stripePublishableKey
        )
      }

    self.configureEstimatedShippingView = Signal.combineLatest(
      project,
      rewards,
      selectedShippingRule,
      selectedQuantities
    ).map { project, rewards, shippingRule, selectedQuantities in
      makePostCampaignEstimatedShipping(
        project: project,
        rewards: rewards,
        shippingRule: shippingRule,
        selectedQuantities: selectedQuantities
      )
    }

    self.estimatedShippingViewHidden = Signal.combineLatest(self.configureEstimatedShippingView, baseReward)
      .map { estimatedShippingStrings, reward in
        reward.shipping.enabled == false || estimatedShippingStrings.0 == nil
      }

    // MARK: Create Payment Intent, Validate & Complete Checkout

    let flowOutputs = makePostCampaignCheckoutFlowSignals(
      project: project,
      baseReward: baseReward,
      allRewardsTotal: allRewardsTotal,
      bonusAmount: bonusAmount,
      allRewardsShippingTotal: allRewardsShippingTotal,
      pledgeTotal: pledgeTotal,
      checkoutId: checkoutId,
      backingId: backingId,
      createCheckoutErrors: createCheckoutErrors,
      selectedCard: self.paymentMethodsUseCase.dataOutputs.selectedPaymentSource.skipNil(),
      stripeIntentService: stripeIntentService,
      viewDidLoadSignal: self.viewDidLoadProperty.signal,
      submitButtonTappedSignal: self.submitButtonTappedProperty.signal,
      applePayButtonTappedSignal: self.applePayButtonTappedSignal,
      applePayPaymentMethodIdSignal: self.applePayPaymentMethodIdSignal.signal,
      applePayContextDidCompleteSignal: self.applePayContextDidCompleteSignal,
      confirmPaymentSuccessfulSignal: self.confirmPaymentSuccessfulProperty.signal.skipNil(),
      checkoutTerminatedSignal: self.checkoutTerminatedProperty.signal
    )

    self.validateCheckoutSuccess = flowOutputs.validateCheckoutSuccess
    self.goToApplePayPaymentAuthorization = flowOutputs.goToApplePayPaymentAuthorization
    self.checkoutComplete = flowOutputs.checkoutComplete
    self.checkoutError = flowOutputs.checkoutError
    self.showErrorBannerWithMessage = flowOutputs.showErrorBannerWithMessage
    self.processingViewIsHidden = flowOutputs.processingViewIsHidden

    self.configurePledgeViewCTAContainerView = Signal.combineLatest(
      project,
      pledgeTotal,
      flowOutputs.pledgeButtonEnabled,
      context,
      self.loginSignupUseCase.dataOutputs.isLoggedIn
    ).map { project, pledgeTotal, isEnabled, context, isLoggedIn in
      PledgeViewCTAContainerViewData(
        project: project,
        total: pledgeTotal,
        isLoggedIn: isLoggedIn,
        isEnabled: isEnabled,
        context: context,
        willRetryPaymentMethod: false
      )
    }

    let checkoutIdOrNil = Signal.merge(checkoutId.wrapInOptional(), createCheckoutErrors.mapConst(nil).take(first: 1))
    bindPostCampaignCheckoutTracking(
      checkoutData: Signal.combineLatest(initialData, baseReward, pledgeTotal, allRewardsShippingTotal, checkoutIdOrNil),
      submitTapped: self.submitButtonTappedProperty.signal,
      applePayTapped: self.applePayButtonTappedSignal
    )
  }

  // MARK: - Inputs

  private let checkoutTerminatedProperty = MutableProperty(())
  /// Call when checkout is dismissed or cancelled.
  public func checkoutTerminated() { self.checkoutTerminatedProperty.value = () }
  private let configureWithDataProperty = MutableProperty<PledgeViewData?>(nil)
  /// Configures the view model with pledge view data.
  public func configure(with data: PledgeViewData) { self.configureWithDataProperty.value = data }
  private let confirmPaymentSuccessfulProperty = MutableProperty<String?>(nil)
  /// Notifies the view model that Stripe confirmation succeeded.
  public func confirmPaymentSuccessful(clientSecret: String) { self.confirmPaymentSuccessfulProperty.value = clientSecret }
  /// Selects a payment source for checkout.
  public func creditCardSelected(source: PaymentSourceSelected) { self.paymentMethodsUseCase.creditCardSelected(with: source) }
  /// Handles tapping the login or signup prompt.
  public func goToLoginSignupTapped() { self.loginSignupUseCase.uiInputs.goToLoginSignupTapped() }
  private let (pledgeDisclaimerViewDidTapLearnMoreSignal, pledgeDisclaimerViewDidTapLearnMoreObserver) = Signal<Void, Never>.pipe()
  /// Handles tapping "Learn more" on the pledge disclaimer.
  public func pledgeDisclaimerViewDidTapLearnMore() { self.pledgeDisclaimerViewDidTapLearnMoreObserver.send(value: ()) }
  private let submitButtonTappedProperty = MutableProperty(())
  /// Handles tapping the primary pledge submit button.
  public func submitButtonTapped() { self.submitButtonTappedProperty.value = () }
  private let (termsOfUseTappedSignal, termsOfUseTappedObserver) = Signal<HelpType, Never>.pipe()
  /// Handles tapping a terms-of-use or help link.
  public func termsOfUseTapped(with helpType: HelpType) { self.termsOfUseTappedObserver.send(value: helpType) }
  /// Refreshes state when the user session changes.
  public func userSessionDidChange() { self.loginSignupUseCase.uiInputs.userSessionDidChange() }
  private let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the view loaded.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }
  private let (applePayButtonTappedSignal, applePayButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Handles tapping the Apple Pay button.
  public func applePayButtonTapped() { self.applePayButtonTappedObserver.send(value: ()) }
  private let (applePayPaymentMethodIdSignal, applePayPaymentMethodIdObserver) = Signal<String, Never>.pipe()
  /// Records the payment method ID created by Apple Pay.
  public func applePayContextDidCreatePayment(with paymentMethodId: String) { self.applePayPaymentMethodIdObserver.send(value: paymentMethodId) }
  private let (applePayContextDidCompleteSignal, applePayContextDidCompleteObserver) = Signal<Void, Never>.pipe()
  /// Notifies the view model that Apple Pay authorization completed.
  public func applePayContextDidComplete() { self.applePayContextDidCompleteObserver.send(value: ()) }

  // MARK: - Outputs

  /// Estimated shipping display strings.
  public let configureEstimatedShippingView: Signal<(String?, String?), Never>
  /// Configuration for payment methods controller.
  public var configurePaymentMethodsViewControllerWithValue: Signal<PledgePaymentMethodsValue, Never> { self.paymentMethodsUseCase.configurePaymentMethodsViewControllerWithValue }
  /// Rewards and pledge summary data.
  public let configurePledgeRewardsSummaryViewWithData: Signal<(PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData), Never>
  /// Call-to-action container configuration.
  public let configurePledgeViewCTAContainerView: Signal<PledgeViewCTAContainerViewData, Never>
  /// Stripe configuration payload.
  public let configureStripeIntegration: Signal<StripeConfigurationData, Never>
  /// Whether estimated shipping is hidden.
  public let estimatedShippingViewHidden: Signal<Bool, Never>
  /// Login flow trigger.
  public var goToLoginSignup: Signal<LoginIntent, Never> { self.loginSignupUseCase.uiOutputs.goToLoginSignup }
  /// Whether the processing overlay is hidden.
  public let processingViewIsHidden: Signal<Bool, Never>
  /// Error banner message.
  public let showErrorBannerWithMessage: Signal<String, Never>
  /// Help topic to present.
  public let showWebHelp: Signal<HelpType, Never>
  /// Whether payment methods are hidden.
  public var paymentMethodsViewHidden: Signal<Bool, Never> { self.paymentMethodsUseCase.paymentMethodsViewHidden }
  /// Validated payment source payload.
  public let validateCheckoutSuccess: Signal<PaymentSourceValidation, Never>
  /// Apple Pay authorization data.
  public let goToApplePayPaymentAuthorization: Signal<PostCampaignPaymentAuthorizationData, Never>
  /// Thanks page payload after checkout completes.
  public let checkoutComplete: Signal<ThanksPageData, Never>
  /// Error emitted if checkout fails.
  public let checkoutError: Signal<ErrorEnvelope, Never>
  /// Input interface.
  public var inputs: PostCampaignCheckoutViewModelInputs { return self }
  /// Output interface.
  public var outputs: PostCampaignCheckoutViewModelOutputs { return self }
  private let loginSignupUseCase: LoginSignupUseCase
  private let paymentMethodsUseCase: PaymentMethodsUseCase
}
