import Foundation

/**
 @deprecated Legacy change-currency input primitive accepting unvalidated currency strings.
 Prefer `ChangeCurrencyRequestSchema` and `AccountController.handleChangeCurrency(payload:headers:)`
 in `KsApi/modules/account`.
 */
/// GraphQL mutation input for changing the user's preferred currency.
///
/// - Negative constraint: Do not pass currency symbols (`$`, `€`); use uppercase ISO 4217 codes (e.g. `USD`).
public struct ChangeCurrencyInput: GraphMutationInput, Encodable {
  let chosenCurrency: String

  /// Creates a currency change mutation payload.
  public init(chosenCurrency: String) {
    self.chosenCurrency = chosenCurrency
  }
}
