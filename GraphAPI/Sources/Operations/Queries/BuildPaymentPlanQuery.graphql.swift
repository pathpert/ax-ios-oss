// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `BuildPaymentPlanQuery`.
public class BuildPaymentPlanQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "BuildPaymentPlan"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query BuildPaymentPlan($slug: String!, $amount: String!) { project(slug: $slug) { __typename paymentPlan(amount: $amount) { __typename amountIsPledgeOverTimeEligible paymentIncrements { __typename ...PaymentIncrementFragment } } } }"#,
      fragments: [PaymentIncrementFragment.self]
    ))

  /// GraphQL variable or field `slug`.
  public var slug: String
  /// GraphQL variable or field `amount`.
  public var amount: String

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    slug: String,
    amount: String
  ) {
    self.slug = slug
    self.amount = amount
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "slug": slug,
    "amount": amount
  ] }

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Query }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["slug": .variable("slug")]),
    ] }

    /// Fetches a project given its slug or pid.
    public var project: Project? { __data["project"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      project: Project? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "project": project._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(BuildPaymentPlanQuery.Data.self)
        ]
      ))
    }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("paymentPlan", PaymentPlan?.self, arguments: ["amount": .variable("amount")]),
      ] }

      /// Build a payment plan given a project id and amount
      public var paymentPlan: PaymentPlan? { __data["paymentPlan"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        paymentPlan: PaymentPlan? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Project.typename,
            "paymentPlan": paymentPlan._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(BuildPaymentPlanQuery.Data.Project.self)
          ]
        ))
      }

      /// Project.PaymentPlan
      ///
      /// Parent Type: `PaymentPlan`
      public struct PaymentPlan: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PaymentPlan }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("amountIsPledgeOverTimeEligible", Bool.self),
          .field("paymentIncrements", [PaymentIncrement]?.self),
        ] }

        /// Amount is enough to qualify for pledge over time, if project allows
        public var amountIsPledgeOverTimeEligible: Bool { __data["amountIsPledgeOverTimeEligible"] }
        /// GraphQL variable or field `paymentIncrements`.
        public var paymentIncrements: [PaymentIncrement]? { __data["paymentIncrements"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          amountIsPledgeOverTimeEligible: Bool,
          paymentIncrements: [PaymentIncrement]? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.PaymentPlan.typename,
              "amountIsPledgeOverTimeEligible": amountIsPledgeOverTimeEligible,
              "paymentIncrements": paymentIncrements._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(BuildPaymentPlanQuery.Data.Project.PaymentPlan.self)
            ]
          ))
        }

        /// Project.PaymentPlan.PaymentIncrement
        ///
        /// Parent Type: `PaymentIncrement`
        public struct PaymentIncrement: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PaymentIncrement }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PaymentIncrementFragment.self),
          ] }

          /// The payment increment amount represented in various formats
          public var amount: Amount { __data["amount"] }
          /// GraphQL variable or field `scheduledCollection`.
          public var scheduledCollection: GraphAPI.ISO8601DateTime { __data["scheduledCollection"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `paymentIncrementFragment`.
            public var paymentIncrementFragment: PaymentIncrementFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            amount: Amount,
            scheduledCollection: GraphAPI.ISO8601DateTime
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.PaymentIncrement.typename,
                "amount": amount._fieldData,
                "scheduledCollection": scheduledCollection,
              ],
              fulfilledFragments: [
                ObjectIdentifier(BuildPaymentPlanQuery.Data.Project.PaymentPlan.PaymentIncrement.self),
                ObjectIdentifier(PaymentIncrementFragment.self)
              ]
            ))
          }

          /// Type alias for `Amount` nested GraphQL selection set.
          public typealias Amount = PaymentIncrementFragment.Amount
        }
      }
    }
  }
}
