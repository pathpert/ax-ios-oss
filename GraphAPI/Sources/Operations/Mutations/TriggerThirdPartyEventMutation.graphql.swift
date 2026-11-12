// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `TriggerThirdPartyEventMutation`.
public class TriggerThirdPartyEventMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "triggerThirdPartyEvent"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation triggerThirdPartyEvent($input: TriggerThirdPartyEventInput!) { triggerThirdPartyEvent(input: $input) { __typename success } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: TriggerThirdPartyEventInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: TriggerThirdPartyEventInput) {
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
      .field("triggerThirdPartyEvent", TriggerThirdPartyEvent?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Triggers third party event
    public var triggerThirdPartyEvent: TriggerThirdPartyEvent? { __data["triggerThirdPartyEvent"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      triggerThirdPartyEvent: TriggerThirdPartyEvent? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "triggerThirdPartyEvent": triggerThirdPartyEvent._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(TriggerThirdPartyEventMutation.Data.self)
        ]
      ))
    }

    /// TriggerThirdPartyEvent
    ///
    /// Parent Type: `TriggerThirdPartyEventPayload`
    public struct TriggerThirdPartyEvent: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.TriggerThirdPartyEventPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
      ] }

      /// GraphQL variable or field `success`.
      public var success: Bool { __data["success"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        success: Bool
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.TriggerThirdPartyEventPayload.typename,
            "success": success,
          ],
          fulfilledFragments: [
            ObjectIdentifier(TriggerThirdPartyEventMutation.Data.TriggerThirdPartyEvent.self)
          ]
        ))
      }
    }
  }
}
