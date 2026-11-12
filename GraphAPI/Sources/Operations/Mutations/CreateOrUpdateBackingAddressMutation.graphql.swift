// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreateOrUpdateBackingAddressMutation`.
public class CreateOrUpdateBackingAddressMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "CreateOrUpdateBackingAddress"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateOrUpdateBackingAddress($input: CreateOrUpdateBackingAddressInput!) { createOrUpdateBackingAddress(input: $input) { __typename success } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CreateOrUpdateBackingAddressInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreateOrUpdateBackingAddressInput) {
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
      .field("createOrUpdateBackingAddress", CreateOrUpdateBackingAddress?.self, arguments: ["input": .variable("input")]),
    ] }

    /// GraphQL variable or field `createOrUpdateBackingAddress`.
    public var createOrUpdateBackingAddress: CreateOrUpdateBackingAddress? { __data["createOrUpdateBackingAddress"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createOrUpdateBackingAddress: CreateOrUpdateBackingAddress? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createOrUpdateBackingAddress": createOrUpdateBackingAddress._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateOrUpdateBackingAddressMutation.Data.self)
        ]
      ))
    }

    /// CreateOrUpdateBackingAddress
    ///
    /// Parent Type: `CreateOrUpdateBackingAddressPayload`
    public struct CreateOrUpdateBackingAddress: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreateOrUpdateBackingAddressPayload }
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
            "__typename": GraphAPI.Objects.CreateOrUpdateBackingAddressPayload.typename,
            "success": success,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateOrUpdateBackingAddressMutation.Data.CreateOrUpdateBackingAddress.self)
          ]
        ))
      }
    }
  }
}
