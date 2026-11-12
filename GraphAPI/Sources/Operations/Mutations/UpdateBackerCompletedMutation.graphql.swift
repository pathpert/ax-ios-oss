// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `UpdateBackerCompletedMutation`.
public class UpdateBackerCompletedMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "UpdateBackerCompleted"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateBackerCompleted($input: UpdateBackerCompletedInput!) { updateBackerCompleted(input: $input) { __typename backing { __typename backerCompleted } } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: UpdateBackerCompletedInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: UpdateBackerCompletedInput) {
    self.input = input
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["input": input] }

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Mutation }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateBackerCompleted", UpdateBackerCompleted?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Update the backing completed at field with a backing_completed toggle
    public var updateBackerCompleted: UpdateBackerCompleted? { __data["updateBackerCompleted"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      updateBackerCompleted: UpdateBackerCompleted? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "updateBackerCompleted": updateBackerCompleted._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UpdateBackerCompletedMutation.Data.self)
        ]
      ))
    }

    /// UpdateBackerCompleted
    ///
    /// Parent Type: `UpdateBackerCompletedPayload`
    public struct UpdateBackerCompleted: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UpdateBackerCompletedPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("backing", Backing?.self),
      ] }

      /// GraphQL variable or field `backing`.
      public var backing: Backing? { __data["backing"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        backing: Backing? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.UpdateBackerCompletedPayload.typename,
            "backing": backing._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(UpdateBackerCompletedMutation.Data.UpdateBackerCompleted.self)
          ]
        ))
      }

      /// UpdateBackerCompleted.Backing
      ///
      /// Parent Type: `Backing`
      public struct Backing: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Backing }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("backerCompleted", Bool.self),
        ] }

        /// If the backer_completed_at is set or not
        public var backerCompleted: Bool { __data["backerCompleted"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          backerCompleted: Bool
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Backing.typename,
              "backerCompleted": backerCompleted,
            ],
            fulfilledFragments: [
              ObjectIdentifier(UpdateBackerCompletedMutation.Data.UpdateBackerCompleted.Backing.self)
            ]
          ))
        }
      }
    }
  }
}
