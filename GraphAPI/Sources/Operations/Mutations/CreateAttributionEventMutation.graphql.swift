// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreateAttributionEventMutation`.
public class CreateAttributionEventMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "createAttributionEvent"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation createAttributionEvent($input: CreateAttributionEventInput!) { createAttributionEvent(input: $input) { __typename successful } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CreateAttributionEventInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreateAttributionEventInput) {
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
      .field("createAttributionEvent", CreateAttributionEvent?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Creates an attribution event. Specifying a project will pass the project properties for attribution events. Sending this request as a logged-in user passes that user's properties as well. Any passed-in property with the same name overwrites the generated properties.
    public var createAttributionEvent: CreateAttributionEvent? { __data["createAttributionEvent"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createAttributionEvent: CreateAttributionEvent? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createAttributionEvent": createAttributionEvent._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateAttributionEventMutation.Data.self)
        ]
      ))
    }

    /// CreateAttributionEvent
    ///
    /// Parent Type: `CreateAttributionEventPayload`
    public struct CreateAttributionEvent: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreateAttributionEventPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("successful", Bool.self),
      ] }

      /// GraphQL variable or field `successful`.
      public var successful: Bool { __data["successful"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        successful: Bool
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CreateAttributionEventPayload.typename,
            "successful": successful,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateAttributionEventMutation.Data.CreateAttributionEvent.self)
          ]
        ))
      }
    }
  }
}
