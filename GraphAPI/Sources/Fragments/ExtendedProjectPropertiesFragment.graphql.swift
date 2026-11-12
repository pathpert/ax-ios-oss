// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `ExtendedProjectPropertiesFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct ExtendedProjectPropertiesFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment ExtendedProjectPropertiesFragment on Project { __typename aiDisclosure { __typename id fundingForAiAttribution fundingForAiConsent fundingForAiOption generatedByAiConsent generatedByAiDetails involvesAi involvesFunding involvesGeneration involvesOther otherAiDetails } environmentalCommitments { __typename commitmentCategory description id } faqs { __typename nodes { __typename question answer id createdAt } } minPledge projectNotice risks story isLaunched prelaunchStoryRichText { __typename ...RichTextComponentFragment } storyRichText { __typename ...RichTextComponentFragment } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("aiDisclosure", AiDisclosure?.self),
    .field("environmentalCommitments", [EnvironmentalCommitment?]?.self),
    .field("faqs", Faqs?.self),
    .field("minPledge", Int.self),
    .field("projectNotice", String?.self),
    .field("risks", String.self),
    .field("story", GraphAPI.HTML.self),
    .field("isLaunched", Bool.self),
    .field("prelaunchStoryRichText", PrelaunchStoryRichText.self),
    .field("storyRichText", StoryRichText.self),
  ] }

  /// Creator-submitted AI usage disclosure payload.
  public var aiDisclosure: AiDisclosure? { __data["aiDisclosure"] }
  /// The environmental commitments of the project.
  public var environmentalCommitments: [EnvironmentalCommitment?]? { __data["environmentalCommitments"] }
  /// List of FAQs of a project
  public var faqs: Faqs? { __data["faqs"] }
  /// The min pledge amount for a single reward tier.
  public var minPledge: Int { __data["minPledge"] }
  /// The text of the currently applied project notice, empty if there is no notice
  public var projectNotice: String? { __data["projectNotice"] }
  /// Potential hurdles to project completion.
  public var risks: String { __data["risks"] }
  /// The story behind the project, parsed for presentation.
  public var story: GraphAPI.HTML { __data["story"] }
  /// The project has launched
  public var isLaunched: Bool { __data["isLaunched"] }
  /// Return an itemized version of the prelaunch story. This feature is in BETA: types can change anytime!
  public var prelaunchStoryRichText: PrelaunchStoryRichText { __data["prelaunchStoryRichText"] }
  /// Return an itemized version of the story. This feature is in BETA: types can change anytime!
  public var storyRichText: StoryRichText { __data["storyRichText"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    aiDisclosure: AiDisclosure? = nil,
    environmentalCommitments: [EnvironmentalCommitment?]? = nil,
    faqs: Faqs? = nil,
    minPledge: Int,
    projectNotice: String? = nil,
    risks: String,
    story: GraphAPI.HTML,
    isLaunched: Bool,
    prelaunchStoryRichText: PrelaunchStoryRichText,
    storyRichText: StoryRichText
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Project.typename,
        "aiDisclosure": aiDisclosure._fieldData,
        "environmentalCommitments": environmentalCommitments._fieldData,
        "faqs": faqs._fieldData,
        "minPledge": minPledge,
        "projectNotice": projectNotice,
        "risks": risks,
        "story": story,
        "isLaunched": isLaunched,
        "prelaunchStoryRichText": prelaunchStoryRichText._fieldData,
        "storyRichText": storyRichText._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(ExtendedProjectPropertiesFragment.self)
      ]
    ))
  }

  /// AiDisclosure
  ///
  /// Parent Type: `AiDisclosure`
  public struct AiDisclosure: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.AiDisclosure }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", GraphAPI.ID.self),
      .field("fundingForAiAttribution", Bool?.self),
      .field("fundingForAiConsent", Bool?.self),
      .field("fundingForAiOption", Bool?.self),
      .field("generatedByAiConsent", String?.self),
      .field("generatedByAiDetails", String?.self),
      .field("involvesAi", Bool.self),
      .field("involvesFunding", Bool.self),
      .field("involvesGeneration", Bool.self),
      .field("involvesOther", Bool.self),
      .field("otherAiDetails", String?.self),
    ] }

    /// Relay global node identifier (`GraphAPI.ID`).
    public var id: GraphAPI.ID { __data["id"] }
    /// Disclosed attribution details for AI funding usage.
    public var fundingForAiAttribution: Bool? { __data["fundingForAiAttribution"] }
    /// Disclosed consent details for AI funding usage.
    public var fundingForAiConsent: Bool? { __data["fundingForAiConsent"] }
    /// Selected option describing AI funding involvement.
    public var fundingForAiOption: Bool? { __data["fundingForAiOption"] }
    /// Disclosed consent status for generative AI content.
    public var generatedByAiConsent: String? { __data["generatedByAiConsent"] }
    /// Free-form details describing generative AI usage.
    public var generatedByAiDetails: String? { __data["generatedByAiDetails"] }
    /// Whether AI tools were used in creating or producing the project.
    public var involvesAi: Bool { __data["involvesAi"] }
    /// Whether the project involves raising funds for AI systems or training.
    public var involvesFunding: Bool { __data["involvesFunding"] }
    /// Whether the project uses generative AI outputs.
    public var involvesGeneration: Bool { __data["involvesGeneration"] }
    /// Whether the project has other AI involvement disclosed.
    public var involvesOther: Bool { __data["involvesOther"] }
    /// Additional creator notes explaining non-standard AI involvement.
    public var otherAiDetails: String? { __data["otherAiDetails"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      id: GraphAPI.ID,
      fundingForAiAttribution: Bool? = nil,
      fundingForAiConsent: Bool? = nil,
      fundingForAiOption: Bool? = nil,
      generatedByAiConsent: String? = nil,
      generatedByAiDetails: String? = nil,
      involvesAi: Bool,
      involvesFunding: Bool,
      involvesGeneration: Bool,
      involvesOther: Bool,
      otherAiDetails: String? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.AiDisclosure.typename,
          "id": id,
          "fundingForAiAttribution": fundingForAiAttribution,
          "fundingForAiConsent": fundingForAiConsent,
          "fundingForAiOption": fundingForAiOption,
          "generatedByAiConsent": generatedByAiConsent,
          "generatedByAiDetails": generatedByAiDetails,
          "involvesAi": involvesAi,
          "involvesFunding": involvesFunding,
          "involvesGeneration": involvesGeneration,
          "involvesOther": involvesOther,
          "otherAiDetails": otherAiDetails,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ExtendedProjectPropertiesFragment.AiDisclosure.self)
        ]
      ))
    }
  }

  /// EnvironmentalCommitment
  ///
  /// Parent Type: `EnvironmentalCommitment`
  public struct EnvironmentalCommitment: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.EnvironmentalCommitment }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("commitmentCategory", GraphQLEnum<GraphAPI.EnvironmentalCommitmentCategory>.self),
      .field("description", String.self),
      .field("id", GraphAPI.ID.self),
    ] }

    /// The type of environmental commitment
    public var commitmentCategory: GraphQLEnum<GraphAPI.EnvironmentalCommitmentCategory> { __data["commitmentCategory"] }
    /// An environmental commitment description
    public var description: String { __data["description"] }
    /// Relay global node identifier (`GraphAPI.ID`).
    public var id: GraphAPI.ID { __data["id"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      commitmentCategory: GraphQLEnum<GraphAPI.EnvironmentalCommitmentCategory>,
      description: String,
      id: GraphAPI.ID
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.EnvironmentalCommitment.typename,
          "commitmentCategory": commitmentCategory,
          "description": description,
          "id": id,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ExtendedProjectPropertiesFragment.EnvironmentalCommitment.self)
        ]
      ))
    }
  }

  /// Faqs
  ///
  /// Parent Type: `ProjectFaqConnection`
  public struct Faqs: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ProjectFaqConnection }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("nodes", [Node?]?.self),
    ] }

    /// A list of nodes.
    public var nodes: [Node?]? { __data["nodes"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      nodes: [Node?]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.ProjectFaqConnection.typename,
          "nodes": nodes._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ExtendedProjectPropertiesFragment.Faqs.self)
        ]
      ))
    }

    /// Faqs.Node
    ///
    /// Parent Type: `ProjectFaq`
    public struct Node: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ProjectFaq }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("question", String.self),
        .field("answer", String.self),
        .field("id", GraphAPI.ID.self),
        .field("createdAt", GraphAPI.DateTime?.self),
      ] }

      /// Faq question
      public var question: String { __data["question"] }
      /// Faq answer
      public var answer: String { __data["answer"] }
      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }
      /// When faq was posted
      public var createdAt: GraphAPI.DateTime? { __data["createdAt"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        question: String,
        answer: String,
        id: GraphAPI.ID,
        createdAt: GraphAPI.DateTime? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.ProjectFaq.typename,
            "question": question,
            "answer": answer,
            "id": id,
            "createdAt": createdAt,
          ],
          fulfilledFragments: [
            ObjectIdentifier(ExtendedProjectPropertiesFragment.Faqs.Node.self)
          ]
        ))
      }
    }
  }

  /// PrelaunchStoryRichText
  ///
  /// Parent Type: `RichTextComponent`
  public struct PrelaunchStoryRichText: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextComponent }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(RichTextComponentFragment.self),
    ] }

    /// Collection of rich-text or connection items.
    public var items: [Item]? { __data["items"] }

    /// Typed container providing access to composed Apollo fragments on this selection set.
    public struct Fragments: FragmentContainer {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// Composed `RichTextComponentFragment` fragment decoded from this selection set.
      public var richTextComponentFragment: RichTextComponentFragment { _toFragment() }
    }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      items: [Item]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextComponent.typename,
          "items": items._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ExtendedProjectPropertiesFragment.PrelaunchStoryRichText.self),
          ObjectIdentifier(RichTextComponentFragment.self)
        ]
      ))
    }

    /// Shared GraphQL selection set alias mapping `Item` to `RichTextComponentFragment.Item`.
    public typealias Item = RichTextComponentFragment.Item
  }

  /// StoryRichText
  ///
  /// Parent Type: `RichTextComponent`
  public struct StoryRichText: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextComponent }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(RichTextComponentFragment.self),
    ] }

    /// Collection of rich-text or connection items.
    public var items: [Item]? { __data["items"] }

    /// Typed container providing access to composed Apollo fragments on this selection set.
    public struct Fragments: FragmentContainer {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// Composed `RichTextComponentFragment` fragment decoded from this selection set.
      public var richTextComponentFragment: RichTextComponentFragment { _toFragment() }
    }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      items: [Item]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextComponent.typename,
          "items": items._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ExtendedProjectPropertiesFragment.StoryRichText.self),
          ObjectIdentifier(RichTextComponentFragment.self)
        ]
      ))
    }

    /// Shared GraphQL selection set alias mapping `Item` to `RichTextComponentFragment.Item`.
    public typealias Item = RichTextComponentFragment.Item
  }
}
