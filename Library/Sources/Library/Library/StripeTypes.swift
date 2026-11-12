import Foundation
import KsApi

/// Contract for checkout payloads that may require a Stripe 3DS Strong Customer Authentication flow.
/// - Negative Constraint: Do not invoke Stripe confirmation if `requiresSCAFlow` is `false` or `clientSecret` is `nil`.
public protocol StripeSCARequiring {
  /// Stripe PaymentIntent or SetupIntent client secret needed for next-action authentication.
  var clientSecret: String? { get }
  /// `true` when Stripe requires additional buyer authentication before completing checkout.
  var requiresSCAFlow: Bool { get }
}

extension UpdateBackingEnvelope: StripeSCARequiring {
  /// `true` when the updated backing's checkout requires Stripe 3DS action.
  public var requiresSCAFlow: Bool {
    return self.updateBacking.checkout.backing.requiresAction
  }

  /// Client secret for the updated backing's Stripe payment/setup intent.
  public var clientSecret: String? {
    return self.updateBacking.checkout.backing.clientSecret
  }
}

extension CreateBackingEnvelope: StripeSCARequiring {
  /// `true` when the created backing's checkout requires Stripe 3DS action.
  public var requiresSCAFlow: Bool {
    return self.createBacking.checkout.backing.requiresAction
  }

  /// Client secret for the created backing's Stripe payment/setup intent.
  public var clientSecret: String? {
    return self.createBacking.checkout.backing.clientSecret
  }
}

/// Decoupled mirror of Stripe SDK `STPPaymentHandlerActionStatus` values for view-model testing.
public enum StripePaymentHandlerActionStatus {
  /// User cancelled the Stripe authentication sheet.
  case canceled
  /// Stripe authentication failed.
  case failed
  /// Stripe authentication completed successfully.
  case succeeded
}

/// Abstraction bridging Stripe action-status types into `Library` view models.
public protocol StripePaymentHandlerActionStatusType {
  /// Normalized Stripe action completion status.
  var status: StripePaymentHandlerActionStatus { get }
}
