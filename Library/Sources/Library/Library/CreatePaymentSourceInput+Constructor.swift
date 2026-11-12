import Foundation
import KsApi

/// `CreatePaymentSourceInput` extensions declared in `CreatePaymentSourceInput+Constructor.swift`.
extension CreatePaymentSourceInput {
  internal static func input(
    fromToken token: String,
    stripeCardId: String,
    reusable: Bool
  ) -> CreatePaymentSourceInput {
    return CreatePaymentSourceInput(
      paymentType: PaymentType.creditCard,
      reusable: reusable,
      stripeToken: token,
      stripeCardId: stripeCardId
    )
  }
}
