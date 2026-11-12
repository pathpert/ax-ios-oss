/// `ChangePaymentMethodEnvelope` extensions declared in `ChangePaymentMethodEnvelopeTemplates.swift`.
extension ChangePaymentMethodEnvelope {
  internal static let template = ChangePaymentMethodEnvelope(
    newCheckoutUrl: "checkouts/1/payments/new",
    status: 200
  )
}
