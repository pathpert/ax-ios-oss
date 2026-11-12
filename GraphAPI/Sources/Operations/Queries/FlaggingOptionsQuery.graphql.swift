// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FlaggingOptionsQuery`.
public class FlaggingOptionsQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FlaggingOptions"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FlaggingOptions($contentType: FlaggingContent!) { flaggingOptions(contentType: $contentType) { __typename id parentId kind nodeType title subtitle placeholder } }"#
    ))

  /// GraphQL variable or field `contentType`.
  public var contentType: GraphQLEnum<FlaggingContent>

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(contentType: GraphQLEnum<FlaggingContent>) {
    self.contentType = contentType
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["contentType": contentType] }

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
      .field("flaggingOptions", [FlaggingOption].self, arguments: ["contentType": .variable("contentType")]),
    ] }

    /// Fetches flagging kinds given a content type
    public var flaggingOptions: [FlaggingOption] { __data["flaggingOptions"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      flaggingOptions: [FlaggingOption]
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "flaggingOptions": flaggingOptions._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FlaggingOptionsQuery.Data.self)
        ]
      ))
    }

    /// FlaggingOption
    ///
    /// Parent Type: `FlaggingNode`
    public struct FlaggingOption: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.FlaggingNode }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String.self),
        .field("parentId", String?.self),
        .field("kind", GraphQLEnum<GraphAPI.NonDeprecatedFlaggingKind>?.self),
        .field("nodeType", GraphQLEnum<GraphAPI.FlaggingNodeKind>.self),
        .field("title", String.self),
        .field("subtitle", String?.self),
        .field("placeholder", String?.self),
      ] }

      /// Unique GraphQL node identifier.
      public var id: String { __data["id"] }
      /// GraphQL variable or field `parentId`.
      public var parentId: String? { __data["parentId"] }
      /// GraphQL variable or field `kind`.
      public var kind: GraphQLEnum<GraphAPI.NonDeprecatedFlaggingKind>? { __data["kind"] }
      /// GraphQL variable or field `nodeType`.
      public var nodeType: GraphQLEnum<GraphAPI.FlaggingNodeKind> { __data["nodeType"] }
      /// GraphQL variable or field `title`.
      public var title: String { __data["title"] }
      /// GraphQL variable or field `subtitle`.
      public var subtitle: String? { __data["subtitle"] }
      /// GraphQL variable or field `placeholder`.
      public var placeholder: String? { __data["placeholder"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        id: String,
        parentId: String? = nil,
        kind: GraphQLEnum<GraphAPI.NonDeprecatedFlaggingKind>? = nil,
        nodeType: GraphQLEnum<GraphAPI.FlaggingNodeKind>,
        title: String,
        subtitle: String? = nil,
        placeholder: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.FlaggingNode.typename,
            "id": id,
            "parentId": parentId,
            "kind": kind,
            "nodeType": nodeType,
            "title": title,
            "subtitle": subtitle,
            "placeholder": placeholder,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FlaggingOptionsQuery.Data.FlaggingOption.self)
          ]
        ))
      }
    }
  }
}
