import Foundation
import KsApi
import PassKit
import ReactiveSwift

/// Input data required to configure a pledge or backing update flow.
public struct PledgeViewData: Equatable {
  /// The project being pledged to or updated.
  public let project: Project
  /// Selected base reward followed by any add-on rewards.
  public let rewards: [Reward]
  /// Optional bonus pledge amount in addition to reward costs.
  public let bonusSupport: Double?
  /// Selected shipping rule when shipping applies.
  public let selectedShippingRule: ShippingRule?
  /// Quantity selected for each reward keyed by reward ID.
  public let selectedQuantities: SelectedRewardQuantities
  /// Identifier of the selected shipping location, if any.
  public let selectedLocationId: Int?
  /// Attribution referral tag associated with the session.
  public let refTag: RefTag?
  /// Context describing whether creating, updating, or fixing a pledge.
  public let context: PledgeViewContext
}

/// Input events accepted by `PledgeViewModel`.
public protocol PledgeViewModelInputs {
  /// Call when the user taps the Apple Pay button.
  func applePayButtonTapped()
  /// Call to configure the view model with pledge view data.
  func configure(with data: PledgeViewData)
  /// Call when the user selects a saved card or payment source.
  func creditCardSelected(with paymentSourceData: PaymentSourceSelected)
  /// Call when the user taps the login or signup prompt.
  func goToLoginSignupTapped()
  /// Call when the active user session changes.
  func userSessionDidChange()
  /// Call when Apple Pay authorizes a payment with token metadata.
  func paymentAuthorizationDidAuthorizePayment(
    paymentData: (displayName: String?, network: String?, transactionIdentifier: String)
  )
  /// Call when the Apple Pay authorization controller dismisses.
  func paymentAuthorizationViewControllerDidFinish()
  /// Call when the user selects a Pledge Over Time payment plan.
  func paymentPlanSelected(_ paymentPlan: PledgePaymentPlansType)
  /// Call when the user taps "Learn more" on the pledge disclaimer.
  func pledgeDisclaimerViewDidTapLearnMore()
  /// Call when a Stripe SCA challenge finishes with a status and optional error.
  func scaFlowCompleted(with result: StripePaymentHandlerActionStatusType, error: Error?)
  /// Call when Stripe creates an Apple Pay token, returning authorization status.
  func stripeTokenCreated(token: String?, error: Error?) -> PKPaymentAuthorizationStatus
  /// Call when the user taps the submit pledge button.
  func submitButtonTapped()
  /// Call when the user taps a terms-of-use or help link.
  func termsOfUseTapped(with: HelpType)
  /// Call when the view loads.
  func viewDidLoad()
}

/// Output signals emitted by `PledgeViewModel`.
public protocol PledgeViewModelOutputs {
  /// Emits the PaymentIntent client secret when 3DS/SCA confirmation is required.
  var beginSCAFlowWithClientSecret: Signal<String, Never> { get }
  /// Emits primary and converted estimated shipping strings.
  var configureEstimatedShippingView: Signal<(String?, String?), Never> { get }
  /// Emits display data for the local pickup location view.
  var configureLocalPickupViewWithData: Signal<PledgeLocalPickupViewData, Never> { get }
  /// Emits configuration values for the payment methods controller.
  var configurePaymentMethodsViewControllerWithValue: Signal<PledgePaymentMethodsValue, Never> { get }
  /// Emits summary data for configuring the pledge amount summary view controller.
  var configurePledgeAmountSummaryViewControllerWithData: Signal<PledgeAmountSummaryViewData, Never> { get }
  /// Emits rewards summary, bonus support, and pledge summary data.
  var configurePledgeRewardsSummaryViewWithData: Signal<
    (PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData),
    Never
  > { get }
  /// Emits configuration for the pledge CTA container view.
  var configurePledgeViewCTAContainerView: Signal<PledgeViewCTAContainerViewData, Never> { get }
  /// Emits Stripe merchant and publishable key configuration data.
  var configureStripeIntegration: Signal<StripeConfigurationData, Never> { get }
  /// Emits whether the description separator should be hidden.
  var descriptionSectionSeparatorHidden: Signal<Bool, Never> { get }
  /// Emits whether the estimated shipping view should be hidden.
  var estimatedShippingViewHidden: Signal<Bool, Never> { get }
  /// Emits payload data to present Apple Pay authorization.
  var goToApplePayPaymentAuthorization: Signal<PaymentAuthorizationData, Never> { get }
  /// Emits thanks page data after creating a backing succeeds.
  var goToThanks: Signal<ThanksPageData, Never> { get }
  /// Emits a login intent when authentication is required.
  var goToLoginSignup: Signal<LoginIntent, Never> { get }
  /// Emits whether the local pickup view should be hidden.
  var localPickupViewHidden: Signal<Bool, Never> { get }
  /// Emits a confirmation banner message after updating a pledge succeeds.
  var notifyDelegateUpdatePledgeDidSucceedWithMessage: Signal<String, Never> { get }
  /// Emits whether the payment methods section should be hidden.
  var paymentMethodsViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the pledge amount summary section should be hidden.
  var pledgeAmountSummaryViewHidden: Signal<Bool, Never> { get }
  /// Emits when navigation should pop back to the root view controller.
  var popToRootViewController: Signal<(), Never> { get }
  /// Emits whether the processing overlay should be hidden.
  var processingViewIsHidden: Signal<Bool, Never> { get }
  /// Emits a localized error message to display in the error banner.
  var showErrorBannerWithMessage: Signal<String, Never> { get }
  /// Emits the help topic to present in a web view.
  var showWebHelp: Signal<HelpType, Never> { get }
  /// Emits the localized navigation bar title for the pledge screen.
  var title: Signal<String, Never> { get }
  /// Emits whether Pledge Over Time UI should be displayed.
  var showPledgeOverTimeUI: Signal<Bool, Never> { get }
  /// Emits Pledge Over Time payment plan configuration and current selection.
  var pledgeOverTimeConfigData: Signal<PledgePaymentPlansAndSelectionData?, Never> { get }
}

/// Protocol exposing inputs and outputs for `PledgeViewModel`.
public protocol PledgeViewModelType {
  /// Input handler for pledge UI events.
  var inputs: PledgeViewModelInputs { get }
  /// Output signal provider for pledge UI updates.
  var outputs: PledgeViewModelOutputs { get }
}

