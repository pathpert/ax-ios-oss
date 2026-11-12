import Foundation

extension CreatePaymentSourceEnvelope {
  internal static let paymentSourceSuccessTemplate = CreatePaymentSourceEnvelope(
    createPaymentSource: .init(isSuccessful: true, paymentSource: UserCreditCards.amex)
  )
  internal static let paymentSourceFailureTemplate = CreatePaymentSourceEnvelope(
    createPaymentSource: .init(isSuccessful: false, paymentSource: UserCreditCards.amex)
  )
  /// Builds a successful `CreatePaymentSourceEnvelope` fixture with default mock Stripe payment method ID.
  public static func paymentSourceSuccessTemplateWithId(_ id: String) -> CreatePaymentSourceEnvelope {
    return self.paymentSourceSuccessTemplateWithId(id, stripeCardId: "pm_fake_\(id)")
  }

  /// Builds a successful `CreatePaymentSourceEnvelope` fixture with custom `id` and optional `stripeCardId`.
  public static func paymentSourceSuccessTemplateWithId(
    _ id: String,
    stripeCardId: String?
  ) -> CreatePaymentSourceEnvelope {
    let card = UserCreditCards.CreditCard(
      expirationDate: "2024-01-12",
      id: id,
      lastFour: "8882",
      type: .visa,
      stripeCardId: stripeCardId
    )

    return CreatePaymentSourceEnvelope(
      createPaymentSource: .init(isSuccessful: true, paymentSource: card)
    )
  }
}
