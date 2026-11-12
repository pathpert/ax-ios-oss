import Foundation
import GraphAPI

/// `GraphAPI.PaymentSourceDeleteInput` extensions declared in `GraphAPI.DeletePaymentSourceInput+DeletePaymentSourceInput.swift`.
extension GraphAPI.PaymentSourceDeleteInput {
  static func from(_ input: PaymentSourceDeleteInput) -> GraphAPI.PaymentSourceDeleteInput {
    return GraphAPI.PaymentSourceDeleteInput(paymentSourceId: input.paymentSourceId)
  }
}
