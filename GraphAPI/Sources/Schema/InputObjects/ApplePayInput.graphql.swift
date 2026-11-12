// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Necessary fields for Apple Pay
public struct ApplePayInput: InputObject {
  /// Backing Apollo GraphQL input dictionary.
  public private(set) var __data: InputDict

  /// Initializes input directly from a raw `InputDict`.
  public init(_ data: InputDict) {
    __data = data
  }

  /// Creates an `ApplePayInput` carrying Stripe token and PassKit payment metadata.
  public init(
    token: String,
    paymentInstrumentName: String,
    paymentNetwork: String,
    transactionIdentifier: String
  ) {
    __data = InputDict([
      "token": token,
      "paymentInstrumentName": paymentInstrumentName,
      "paymentNetwork": paymentNetwork,
      "transactionIdentifier": transactionIdentifier
    ])
  }

  /// Stripe token
  public var token: String {
    get { __data["token"] }
    set { __data["token"] = newValue }
  }

  /// PassKit display label describing the customer's Apple Pay card instrument.
  public var paymentInstrumentName: String {
    get { __data["paymentInstrumentName"] }
    set { __data["paymentInstrumentName"] = newValue }
  }

  /// PassKit card network identifier string (e.g., `"Visa"`, `"MasterCard"`).
  public var paymentNetwork: String {
    get { __data["paymentNetwork"] }
    set { __data["paymentNetwork"] = newValue }
  }

  /// PassKit transaction identifier from `PKPaymentToken`.
  public var transactionIdentifier: String {
    get { __data["transactionIdentifier"] }
    set { __data["transactionIdentifier"] = newValue }
  }
}
