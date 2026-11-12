import Combine
import Foundation
import GraphAPI
import ReactiveSwift

/// Domain-scoped protocol for checkout validation, Stripe payment intents, payment methods, shipping rules, and add-ons.
public protocol ServiceCheckoutType {
  /// Returns Pledge Over Time payment plan data.
  /// - Returns: `SignalProducer` emitting `GraphAPI.BuildPaymentPlanQuery.Data` or an `ErrorEnvelope`.
  func buildPaymentPlan(projectSlug: String, pledgeAmount: String)
    -> SignalProducer<GraphAPI.BuildPaymentPlanQuery.Data, ErrorEnvelope>

  /// Completes an on-session Stripe checkout mutation.
  /// - Returns: `SignalProducer` emitting `GraphAPI.CompleteOnSessionCheckoutMutation.Data` or an `ErrorEnvelope`.
  func completeOnSessionCheckout(input: GraphAPI.CompleteOnSessionCheckoutInput) ->
    SignalProducer<GraphAPI.CompleteOnSessionCheckoutMutation.Data, ErrorEnvelope>

  /// Create a checkout and returns it. Called before createBacking so that the backend can run some extra validations.
  /// - Note: `@deprecated` Use `CheckoutController.handleCreateCheckout(payload:headers:)` in `KsApi/modules/checkout` instead.
  /// - Returns: `SignalProducer` emitting `CreateCheckoutEnvelope` or an `ErrorEnvelope`.
  func createCheckout(input: CreateCheckoutInput) ->
    SignalProducer<CreateCheckoutEnvelope, ErrorEnvelope>

  /// Creates a Stripe payment intent for a project pledge.
  /// - Returns: `SignalProducer` emitting `PaymentIntentEnvelope` (containing `clientSecret`) or an `ErrorEnvelope`.
  func createPaymentIntentInput(input: CreatePaymentIntentInput)
    -> SignalProducer<PaymentIntentEnvelope, ErrorEnvelope>

  /// Create Stripe setup intent for use with Stripe payment sheet.
  /// - Returns: `SignalProducer` emitting `ClientSecretEnvelope` or an `ErrorEnvelope`.
  func createStripeSetupIntent(input: CreateSetupIntentInput) ->
    SignalProducer<ClientSecretEnvelope, ErrorEnvelope>

  /// Adds a new credit card to users' payment methods.
  /// - Returns: `SignalProducer` emitting `CreatePaymentSourceEnvelope` or an `ErrorEnvelope`.
  func addNewCreditCard(input: CreatePaymentSourceInput) ->
    SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope>

  /// Adds a new Stripe payment source to users' payment methods.
  /// - Returns: `SignalProducer` emitting `CreatePaymentSourceEnvelope` or an `ErrorEnvelope`.
  func addPaymentSheetPaymentSource(input: CreatePaymentSourceSetupIntentInput) ->
    SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope>

  /// Deletes a payment method.
  /// - Returns: `SignalProducer` emitting `DeletePaymentMethodEnvelope` or an `ErrorEnvelope`.
  func deletePaymentMethod(input: PaymentSourceDeleteInput) ->
    SignalProducer<DeletePaymentMethodEnvelope, ErrorEnvelope>

  /// Fetch the add-on rewards for the add-on selection view with a `Project` slug and optional `Location` ID.
  /// - Returns: `SignalProducer` emitting `Project` with add-on rewards or an `ErrorEnvelope`.
  func fetchRewardAddOnsSelectionViewRewards(slug: String, shippingEnabled: Bool, locationId: String?)
    -> SignalProducer<Project, ErrorEnvelope>

  /// Fetches add-on rewards for a base reward and shipping country code.
  /// - Returns: `SignalProducer` emitting `[Reward]` or an `ErrorEnvelope`.
  func fastFetchRewardAddOnsSelection(
    baseRewardId: Int,
    countryCode: String
  ) -> SignalProducer<[Reward], ErrorEnvelope>

  /// Fetches a reward's shipping rules for a project and reward id.
  /// - Returns: `SignalProducer` emitting `ShippingRulesEnvelope` or an `ErrorEnvelope`.
  func fetchRewardShippingRules(projectId: Int, rewardId: Int)
    -> SignalProducer<ShippingRulesEnvelope, ErrorEnvelope>

  /// Validates a Post Campaign Pledge checkout.
  /// - Returns: `SignalProducer` emitting `ValidateCheckoutEnvelope` or an `ErrorEnvelope` (`.ValidateCheckoutError`).
  func validateCheckout(
    checkoutId: String,
    paymentSourceId: String,
    paymentIntentClientSecret: String
  ) -> SignalProducer<ValidateCheckoutEnvelope, ErrorEnvelope>
}

