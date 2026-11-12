import Foundation
import GraphAPI
import KsApi
import ReactiveSwift

/// Protocol creating Stripe PaymentIntents and SetupIntents via GraphQL mutations.
/// - Negative Constraint: Do not invoke Stripe SDK confirmation sheets directly without first obtaining a client secret through `StripeIntentServiceType`.
public protocol StripeIntentServiceType {
  /// Creates a Stripe PaymentIntent for completing post-campaign checkout.
  func createPaymentIntent(
    for projectId: String,
    backingId: String,
    checkoutId: String,
    pledgeTotal: Double
  ) -> SignalProducer<PaymentIntentEnvelope, ErrorEnvelope>
  /// Creates a Stripe SetupIntent for collecting or attaching a reusable payment method.
  func createSetupIntent(
    for projectId: String?,
    context: GraphAPI.StripeIntentContextTypes
  ) -> SignalProducer<ClientSecretEnvelope, ErrorEnvelope>
}

/// Concrete service creating Stripe PaymentIntents and SetupIntents via `AppEnvironment.current.apiService`.
public class StripeIntentService: StripeIntentServiceType {
  /// Initializes the default Stripe intent service.
  public init() {}

  /// Returns a signal producer emitting a `PaymentIntentEnvelope` or `ErrorEnvelope`.
  /// - parameter projectId: GraphQL global ID of the backed project.
  /// - parameter backingId: Backing identifier used by the backend to rescue checkouts.
  /// - parameter checkoutId: GraphQL checkout identifier from `CreateCheckout`.
  /// - parameter pledgeTotal: Final pledge total formatted in major currency units.
  public func createPaymentIntent(
    for projectId: String,
    backingId: String,
    checkoutId: String,
    pledgeTotal: Double
  ) -> SignalProducer<PaymentIntentEnvelope, ErrorEnvelope> {
    AppEnvironment.current.apiService
      .createPaymentIntentInput(input: CreatePaymentIntentInput(
        projectId: projectId,
        backingId: backingId,
        amountDollars: String(format: "%.2f", pledgeTotal),
        checkoutId: encodeToBase64("Checkout-\(checkoutId)"),
        digitalMarketingAttributed: nil
      ))
  }

  /// Returns a signal producer emitting a `ClientSecretEnvelope` or `ErrorEnvelope` for a Stripe SetupIntent.
  /// - parameter projectId: Optional GraphQL global ID of the associated project.
  /// - parameter context: GraphQL context indicating where the setup intent is initiated.
  public func createSetupIntent(
    for projectId: String?,
    context: GraphAPI.StripeIntentContextTypes
  ) -> SignalProducer<ClientSecretEnvelope, ErrorEnvelope> {
    AppEnvironment.current.apiService
      .createStripeSetupIntent(
        input: CreateSetupIntentInput(projectId: projectId, context: context)
      )
  }
}
