import KsApi

/// `CreatePaymentSourceSetupIntentInput` extensions declared in `CreatePaymentSourceSetupIntentClientSecret+Constructor.swift`.
extension CreatePaymentSourceSetupIntentInput {
  internal static func input(
    fromIntentClientSecret token: String,
    reuseable: Bool
  ) -> CreatePaymentSourceSetupIntentInput {
    return CreatePaymentSourceSetupIntentInput(intentClientSecret: token, reuseable: reuseable)
  }
}
