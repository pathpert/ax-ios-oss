// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `CheckoutFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct CheckoutFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment CheckoutFragment on Checkout { __typename backing { __typename clientSecret requiresAction } id state }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Checkout }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("backing", Backing.self),
    .field("id", GraphAPI.ID.self),
    .field("state", GraphQLEnum<GraphAPI.CheckoutState>.self),
  ] }

  /// The backing that the checkout is modifying.
  public var backing: Backing { __data["backing"] }
  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// The current state of the checkout
  public var state: GraphQLEnum<GraphAPI.CheckoutState> { __data["state"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    backing: Backing,
    id: GraphAPI.ID,
    state: GraphQLEnum<GraphAPI.CheckoutState>
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Checkout.typename,
        "backing": backing._fieldData,
        "id": id,
        "state": state,
      ],
      fulfilledFragments: [
        ObjectIdentifier(CheckoutFragment.self)
      ]
    ))
  }

  /// Backing
  ///
  /// Parent Type: `Backing`
  public struct Backing: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Backing }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("clientSecret", String?.self),
      .field("requiresAction", Bool?.self),
    ] }

    /// If `requires_action` is true, `client_secret` should be used to initiate additional client-side authentication steps
    public var clientSecret: String? { __data["clientSecret"] }
    /// Whether this checkout requires additional client-side authentication steps (e.g. 3DS2) to complete the on-session pledge flow
    public var requiresAction: Bool? { __data["requiresAction"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      clientSecret: String? = nil,
      requiresAction: Bool? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Backing.typename,
          "clientSecret": clientSecret,
          "requiresAction": requiresAction,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CheckoutFragment.Backing.self)
        ]
      ))
    }
  }
}
