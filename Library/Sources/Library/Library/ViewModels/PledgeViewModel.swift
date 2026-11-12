import Foundation
import KsApi
import PassKit
import Prelude
import ReactiveSwift

/// Coordinates pledge calculations, payment method selection, Apple Pay, SCA flows, and backing mutations.
public class PledgeViewModel: PledgeViewModelType, PledgeViewModelInputs, PledgeViewModelOutputs {
  /// Creates a pledge view model with its internal use cases and reactive bindings.
  public init() {
    let initialData = Signal.combineLatest(
      self.configureWithDataProperty.signal,
      self.viewDidLoadProperty.signal
    )
    .map(first)
    .skipNil()

    let project = initialData.map(\.project)
    let baseReward = initialData.map(\.rewards).map(\.first).skipNil()
    let rewards = initialData.map(\.rewards)
    let selectedQuantities = initialData.map(\.selectedQuantities)
    let selectedShippingRule = initialData.map(\.selectedShippingRule)
    let refTag = initialData.map(\.refTag)
    let context = initialData.map(\.context)
    let backing = project.map { $0.personalization.backing }.skipNil()

    self.pledgeAmountSummaryViewHidden = context.map { $0.pledgeAmountSummaryViewHidden }
    self.loginSignupUseCase = LoginSignupUseCase(
      withLoginIntent: .backProject,
      initialData: initialData.ignoreValues()
    )
    self.paymentMethodsUseCase = PaymentMethodsUseCase(
      initialData: initialData,
      isLoggedIn: self.loginSignupUseCase.dataOutputs.isLoggedIn
    )

    let summary = makePledgeSummarySetupSignals(
      initialData: initialData,
      project: project,
      baseReward: baseReward,
      rewards: rewards,
      selectedQuantities: selectedQuantities,
      selectedShippingRule: selectedShippingRule,
      context: context,
      backing: backing
    )
    self.descriptionSectionSeparatorHidden = summary.descriptionSectionSeparatorHidden
    self.localPickupViewHidden = summary.localPickupViewHidden
    self.configureLocalPickupViewWithData = summary.configureLocalPickupViewWithData
    self.configurePledgeRewardsSummaryViewWithData = summary.configurePledgeRewardsSummaryViewWithData
    self.configurePledgeAmountSummaryViewControllerWithData = summary.configurePledgeAmountSummaryViewControllerWithData
    self.configureStripeIntegration = summary.configureStripeIntegration
    self.configureEstimatedShippingView = summary.configureEstimatedShippingView
    self.estimatedShippingViewHidden = summary.estimatedShippingViewHidden
    self.showWebHelp = Signal.merge(
      self.termsOfUseTappedSignal,
      self.pledgeDisclaimerViewDidTapLearnMoreSignal.mapConst(.trust)
    )

    self.pledgeOverTimeUseCase = PledgeOverTimeUseCase(
      project: project,
      pledgeTotal: summary.pledgeTotal,
      context: context
    )

    let flowOutputs = makePledgeBackingFlowSignals(
      initialData: initialData,
      project: project,
      baseReward: baseReward,
      rewards: rewards,
      selectedQuantities: selectedQuantities,
      selectedShippingRule: selectedShippingRule,
      refTag: refTag,
      context: context,
      backing: backing,
      summary: summary,
      loginSignupUseCase: self.loginSignupUseCase,
      paymentMethodsUseCase: self.paymentMethodsUseCase,
      pledgeOverTimeUseCase: self.pledgeOverTimeUseCase,
      viewDidLoadSignal: self.viewDidLoadProperty.signal,
      submitButtonTappedSignal: self.submitButtonTappedSignal,
      applePayButtonTappedSignal: self.applePayButtonTappedSignal,
      pkPaymentSignal: self.pkPaymentSignal,
      stripeTokenSignal: self.stripeTokenSignal,
      stripeErrorSignal: self.stripeErrorSignal,
      scaFlowCompletedSignal: self.scaFlowCompletedWithResultSignal,
      paymentAuthorizationDidFinishSignal: self.paymentAuthorizationDidFinishSignal
    )

    self.goToApplePayPaymentAuthorization = flowOutputs.goToApplePayPaymentAuthorization
    self.createApplePayBackingStatusProperty <~ flowOutputs.createApplePayBackingStatus
    self.processingViewIsHidden = flowOutputs.processingViewIsHidden
    self.beginSCAFlowWithClientSecret = flowOutputs.beginSCAFlowWithClientSecret
    self.goToThanks = flowOutputs.goToThanks
    self.notifyDelegateUpdatePledgeDidSucceedWithMessage = flowOutputs.notifyDelegateUpdatePledgeDidSucceedWithMessage
    self.showErrorBannerWithMessage = flowOutputs.showErrorBannerWithMessage
    self.configurePledgeViewCTAContainerView = flowOutputs.configurePledgeViewCTAContainerView
    self.popToRootViewController = self.notifyDelegateUpdatePledgeDidSucceedWithMessage.ignoreValues()
    self.title = context.map { $0.title }

    bindPledgeTracking(
      project: project,
      baseReward: baseReward,
      rewards: rewards,
      selectedQuantities: selectedQuantities,
      refTag: refTag,
      additionalPledgeAmount: summary.additionalPledgeAmount,
      pledgeTotal: summary.pledgeTotal,
      context: context,
      createBackingData: flowOutputs.createBackingData,
      submitTapped: self.submitButtonTappedSignal,
      applePayTapped: self.applePayButtonTappedSignal
    )
  }

  // MARK: - Inputs

  private let (applePayButtonTappedSignal, applePayButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Handles tapping the Apple Pay button.
  public func applePayButtonTapped() { self.applePayButtonTappedObserver.send(value: ()) }
  private let configureWithDataProperty = MutableProperty<PledgeViewData?>(nil)
  /// Configures the view model with pledge view data.
  public func configure(with data: PledgeViewData) { self.configureWithDataProperty.value = data }
  /// Updates the selected credit card payment source.
  public func creditCardSelected(with paymentSourceData: PaymentSourceSelected) {
    self.paymentMethodsUseCase.creditCardSelected(with: paymentSourceData)
  }

  private let (pkPaymentSignal, pkPaymentObserver) = Signal<(
    displayName: String?,
    network: String?,
    transactionIdentifier: String
  ), Never>.pipe()
  /// Records authorized Apple Pay payment metadata.
  public func paymentAuthorizationDidAuthorizePayment(paymentData: (
    displayName: String?,
    network: String?,
    transactionIdentifier: String
  )) {
    self.pkPaymentObserver.send(value: paymentData)
  }

  private let (paymentAuthorizationDidFinishSignal, paymentAuthorizationDidFinishObserver) = Signal<Void, Never>.pipe()
  /// Notifies the view model that the Apple Pay authorization controller finished.
  public func paymentAuthorizationViewControllerDidFinish() { self.paymentAuthorizationDidFinishObserver.send(value: ()) }
  /// Updates the selected Pledge Over Time payment plan.
  public func paymentPlanSelected(_ paymentPlan: PledgePaymentPlansType) {
    self.pledgeOverTimeUseCase.inputs.paymentPlanSelected(paymentPlan)
  }
  /// Handles tapping the login or signup prompt.
  public func goToLoginSignupTapped() { self.loginSignupUseCase.uiInputs.goToLoginSignupTapped() }
  private let (pledgeDisclaimerViewDidTapLearnMoreSignal, pledgeDisclaimerViewDidTapLearnMoreObserver) = Signal<Void, Never>.pipe()
  /// Handles tapping "Learn more" on the pledge disclaimer.
  public func pledgeDisclaimerViewDidTapLearnMore() { self.pledgeDisclaimerViewDidTapLearnMoreObserver.send(value: ()) }
  private let (scaFlowCompletedWithResultSignal, scaFlowCompletedWithResultObserver) = Signal<(StripePaymentHandlerActionStatusType, Error?), Never>.pipe()
  /// Records the result of a Stripe SCA confirmation flow.
  public func scaFlowCompleted(with result: StripePaymentHandlerActionStatusType, error: Error?) {
    self.scaFlowCompletedWithResultObserver.send(value: (result, error))
  }
  private let (stripeTokenSignal, stripeTokenObserver) = Signal<String?, Never>.pipe()
  private let (stripeErrorSignal, stripeErrorObserver) = Signal<Error?, Never>.pipe()
  private let (submitButtonTappedSignal, submitButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Handles tapping the primary pledge submit button.
  public func submitButtonTapped() { self.submitButtonTappedObserver.send(value: ()) }
  private let createApplePayBackingStatusProperty = MutableProperty<PKPaymentAuthorizationStatus>(.failure)
  /// Sends the generated Apple Pay Stripe token and returns authorization status.
  public func stripeTokenCreated(token: String?, error: Error?) -> PKPaymentAuthorizationStatus {
    self.stripeTokenObserver.send(value: token)
    self.stripeErrorObserver.send(value: error)
    return self.createApplePayBackingStatusProperty.value
  }
  private let (termsOfUseTappedSignal, termsOfUseTappedObserver) = Signal<HelpType, Never>.pipe()
  /// Handles tapping a terms-of-use or help link.
  public func termsOfUseTapped(with helpType: HelpType) { self.termsOfUseTappedObserver.send(value: helpType) }
  private let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the view loaded.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }
  /// Refreshes state when the user session changes.
  public func userSessionDidChange() { self.loginSignupUseCase.uiInputs.userSessionDidChange() }

  // MARK: - Outputs

  /// Client secret signal for SCA confirmation.
  public let beginSCAFlowWithClientSecret: Signal<String, Never>
  /// Estimated shipping display strings.
  public let configureEstimatedShippingView: Signal<(String?, String?), Never>
  /// Local pickup location view data.
  public let configureLocalPickupViewWithData: Signal<PledgeLocalPickupViewData, Never>
  /// Payment methods controller configuration.
  public var configurePaymentMethodsViewControllerWithValue: Signal<PledgePaymentMethodsValue, Never> {
    self.paymentMethodsUseCase.configurePaymentMethodsViewControllerWithValue
  }
  /// Pledge amount summary controller data.
  public let configurePledgeAmountSummaryViewControllerWithData: Signal<PledgeAmountSummaryViewData, Never>
  /// Rewards and pledge summary data.
  public let configurePledgeRewardsSummaryViewWithData: Signal<(PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData), Never>
  /// CTA container view configuration.
  public let configurePledgeViewCTAContainerView: Signal<PledgeViewCTAContainerViewData, Never>
  /// Stripe SDK configuration payload.
  public let configureStripeIntegration: Signal<StripeConfigurationData, Never>
  /// Whether the description section separator is hidden.
  public let descriptionSectionSeparatorHidden: Signal<Bool, Never>
  /// Whether estimated shipping is hidden.
  public let estimatedShippingViewHidden: Signal<Bool, Never>
  /// Apple Pay authorization payload.
  public let goToApplePayPaymentAuthorization: Signal<PaymentAuthorizationData, Never>
  /// Thanks page payload after backing succeeds.
  public let goToThanks: Signal<ThanksPageData, Never>
  /// Login flow trigger.
  public var goToLoginSignup: Signal<LoginIntent, Never> { self.loginSignupUseCase.uiOutputs.goToLoginSignup }
  /// Whether the local pickup view is hidden.
  public let localPickupViewHidden: Signal<Bool, Never>
  /// Confirmation message when a pledge update succeeds.
  public let notifyDelegateUpdatePledgeDidSucceedWithMessage: Signal<String, Never>
  /// Whether payment methods are hidden.
  public var paymentMethodsViewHidden: Signal<Bool, Never> { self.paymentMethodsUseCase.paymentMethodsViewHidden }
  /// Whether the pledge amount summary view is hidden.
  public let pledgeAmountSummaryViewHidden: Signal<Bool, Never>
  /// Pops back to the root view controller after update success.
  public let popToRootViewController: Signal<(), Never>
  /// Whether the processing overlay is hidden.
  public let processingViewIsHidden: Signal<Bool, Never>
  /// Error banner message.
  public let showErrorBannerWithMessage: Signal<String, Never>
  /// Help topic to present.
  public let showWebHelp: Signal<HelpType, Never>
  /// Navigation title for the pledge screen.
  public let title: Signal<String, Never>
  /// Whether Pledge Over Time UI is displayed.
  public var showPledgeOverTimeUI: Signal<Bool, Never> { self.pledgeOverTimeUseCase.outputs.showPledgeOverTimeUI }
  /// Pledge Over Time configuration and selection.
  public var pledgeOverTimeConfigData: Signal<PledgePaymentPlansAndSelectionData?, Never> { self.pledgeOverTimeUseCase.outputs.pledgeOverTimeConfigData }
  /// Input interface.
  public var inputs: PledgeViewModelInputs { return self }
  /// Output interface.
  public var outputs: PledgeViewModelOutputs { return self }

  private let pledgeOverTimeUseCase: PledgeOverTimeUseCase
  private let loginSignupUseCase: LoginSignupUseCase
  private let paymentMethodsUseCase: PaymentMethodsUseCase
}
