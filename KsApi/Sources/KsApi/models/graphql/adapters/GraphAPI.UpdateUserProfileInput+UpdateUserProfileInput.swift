import GraphAPI

/// `GraphAPI.UpdateUserProfileInput` extensions declared in `GraphAPI.UpdateUserProfileInput+UpdateUserProfileInput.swift`.
extension GraphAPI.UpdateUserProfileInput {
  /**
   Maps a `CreatePasswordInput` to a `GraphAPI.UpdateUserAccountInput`
   */
  static func from(_ input: ChangeCurrencyInput) -> GraphAPI.UpdateUserProfileInput {
    let currency = GraphAPI.CurrencyCode(rawValue: input.chosenCurrency)

    return GraphAPI.UpdateUserProfileInput(chosenCurrency: GraphQLEnum.caseOrNil(currency))
  }
}
