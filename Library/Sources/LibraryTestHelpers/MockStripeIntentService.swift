import GraphAPI
@testable import KsApi
@testable import Library
import ReactiveSwift

/// Controller/component implementing `MockStripeIntentService`.
public class MockStripeIntentService: StripeIntentServiceType {
  /// Number of mocked Stripe SetupIntent requests recorded during the test.
  public private(set) var setupIntentRequests: Int = 0
  /// Number of mocked Stripe PaymentIntent requests recorded during the test.
  public private(set) var paymentIntentRequests: Int = 0

  /// Creates a mock Stripe intent service bound to `AppEnvironment.current.apiService` (`MockService`).
  public init() {}

  /// Records a payment intent request and forwards the payload to `MockService`.
  public func createPaymentIntent(
    for projectId: String,
    backingId: String,
    checkoutId: String,
    pledgeTotal: Double
  ) -> SignalProducer<PaymentIntentEnvelope, ErrorEnvelope> {
    assert(
      AppEnvironment.current.apiService is MockService,
      "AppEnvironment.current.apiService should be a MockService when used in test."
    )

    self.paymentIntentRequests += 1

    return AppEnvironment.current.apiService
      .createPaymentIntentInput(input: CreatePaymentIntentInput(
        projectId: projectId,
        backingId: backingId,
        amountDollars: String(format: "%.2f", pledgeTotal),
        checkoutId: checkoutId,
        digitalMarketingAttributed: nil
      ))
  }

  /// Records a setup intent request and forwards the payload to `MockService`.
  public func createSetupIntent(
    for projectId: String?,
    context: GraphAPI.StripeIntentContextTypes
  ) -> SignalProducer<ClientSecretEnvelope, ErrorEnvelope> {
    assert(
      AppEnvironment.current.apiService is MockService,
      "AppEnvironment.current.apiService should be a MockService when used in test."
    )

    self.setupIntentRequests += 1

    return AppEnvironment.current.apiService
      .createStripeSetupIntent(
        input: CreateSetupIntentInput(projectId: projectId, context: context)
      )
  }
}
