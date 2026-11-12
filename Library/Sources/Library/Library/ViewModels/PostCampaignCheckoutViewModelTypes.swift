import Foundation
import KsApi
import ReactiveSwift

/// Data required to configure or represent a post-campaign checkout session.
public struct PostCampaignCheckoutData: Equatable {
  /// The project being pledged to.
  public let project: Project
  /// The primary reward selected by the backer.
  public let baseReward: Reward
  /// All rewards included in the pledge, including add-ons.
  public let rewards: [Reward]
  /// Selected quantity keyed by reward ID.
  public let selectedQuantities: SelectedRewardQuantities
  /// Optional bonus pledge amount in addition to reward costs.
  public let bonusAmount: Double?
  /// Total pledge amount including rewards, shipping, and bonus support.
  public let total: Double
  /// Summary data describing the selected shipping destination and cost.
  public let shipping: PledgeShippingSummaryViewData?
  /// Attribution referral tag associated with the checkout session.
  public let refTag: RefTag?
  /// Presentation context for the pledge flow.
  public let context: PledgeViewContext
  /// Identifier of the backend checkout session.
  public let checkoutId: String
  /// Identifier of the backing created for the checkout.
  public let backingId: String
  /// Shipping rule selected for the backer's destination, if applicable.
  public let selectedShippingRule: ShippingRule?
}

/// Result of validating a checkout payment source with a Stripe PaymentIntent.
public struct PaymentSourceValidation {
  /// Stripe PaymentIntent client secret used to confirm payment.
  public let paymentIntentClientSecret: String
  /// Stripe payment method identifier for the selected card, if available.
  public let selectedCardStripeCardId: String?
  /// Whether additional on-session confirmation is required.
  public let requiresConfirmation: Bool
}

/// Payment breakdown and configuration needed to present Apple Pay authorization.
public struct PostCampaignPaymentAuthorizationData: Equatable {
  /// The project receiving the pledge.
  public let project: Project
  /// Whether the pledge has no physical or digital reward.
  public let hasNoReward: Bool
  /// Subtotal of selected rewards before shipping and bonus support.
  public let subtotal: Double
  /// Bonus pledge amount above the reward cost.
  public let bonus: Double
  /// Shipping cost for the selected rewards and destination.
  public let shipping: Double
  /// Total amount to authorize.
  public let total: Double
  /// Apple Pay merchant identifier configured for the app.
  public let merchantIdentifier: String
  /// Stripe PaymentIntent client secret for the transaction.
  public let paymentIntent: String
}

/// Input events handled by `PostCampaignCheckoutViewModel`.
public protocol PostCampaignCheckoutViewModelInputs {
  /// Call when the checkout flow is dismissed or cancelled by the user.
  func checkoutTerminated()
  /// Call to configure the view model with initial pledge view data.
  func configure(with data: PledgeViewData)
  /// Call after Stripe payment confirmation succeeds with the PaymentIntent client secret.
  func confirmPaymentSuccessful(clientSecret: String)
  /// Call when the user selects a saved credit card or payment source.
  func creditCardSelected(source: PaymentSourceSelected)
  /// Call when the user taps the login or signup prompt.
  func goToLoginSignupTapped()
  /// Call when the active user session changes.
  func userSessionDidChange()
  /// Call when the user taps "Learn more" on the pledge disclaimer.
  func pledgeDisclaimerViewDidTapLearnMore()
  /// Call when the user taps the primary submit button.
  func submitButtonTapped()
  /// Call when a terms-of-use or help link is tapped.
  func termsOfUseTapped(with: HelpType)
  /// Call when the view loads.
  func viewDidLoad()
  /// Call when the user taps the Apple Pay button.
  func applePayButtonTapped()
  /// Call when Apple Pay creates a Stripe payment method identifier.
  func applePayContextDidCreatePayment(with paymentMethodId: String)
  /// Call when Apple Pay authorization finishes completing.
  func applePayContextDidComplete()
}

/// Output signals exposed by `PostCampaignCheckoutViewModel`.
public protocol PostCampaignCheckoutViewModelOutputs {
  /// Emits primary and converted estimated shipping strings for display.
  var configureEstimatedShippingView: Signal<(String?, String?), Never> { get }
  /// Emits configuration values for the embedded payment methods controller.
  var configurePaymentMethodsViewControllerWithValue: Signal<PledgePaymentMethodsValue, Never> { get }
  /// Emits rewards summary, bonus amount, and pledge summary view data.
  var configurePledgeRewardsSummaryViewWithData: Signal<
    (PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData),
    Never
  > { get }
  /// Emits view data for configuring the pledge call-to-action container.
  var configurePledgeViewCTAContainerView: Signal<PledgeViewCTAContainerViewData, Never> { get }
  /// Emits Stripe merchant and publishable key configuration data.
  var configureStripeIntegration: Signal<StripeConfigurationData, Never> { get }
  /// Emits whether the estimated shipping view should be hidden.
  var estimatedShippingViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the payment methods section should be hidden.
  var paymentMethodsViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the processing overlay should be hidden.
  var processingViewIsHidden: Signal<Bool, Never> { get }
  /// Emits a login intent when authentication is required.
  var goToLoginSignup: Signal<LoginIntent, Never> { get }
  /// Emits a localized error message to present in an error banner.
  var showErrorBannerWithMessage: Signal<String, Never> { get }
  /// Emits the help topic to open in a web view.
  var showWebHelp: Signal<HelpType, Never> { get }
  /// Emits validated payment source details ready for Stripe confirmation.
  var validateCheckoutSuccess: Signal<PaymentSourceValidation, Never> { get }
  /// Emits payload data to start the Apple Pay authorization sheet.
  var goToApplePayPaymentAuthorization: Signal<PostCampaignPaymentAuthorizationData, Never> { get }
  /// Emits thanks page data once checkout finishes successfully.
  var checkoutComplete: Signal<ThanksPageData, Never> { get }
  /// Emits an error envelope when completing checkout fails.
  var checkoutError: Signal<ErrorEnvelope, Never> { get }
}

/// Protocol unifying inputs and outputs for `PostCampaignCheckoutViewModel`.
public protocol PostCampaignCheckoutViewModelType {
  /// Input receiver for checkout UI events.
  var inputs: PostCampaignCheckoutViewModelInputs { get }
  /// Output signal provider for checkout UI updates.
  var outputs: PostCampaignCheckoutViewModelOutputs { get }
}

