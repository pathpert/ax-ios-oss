// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchSortedProjectRewardsByIdQuery`.
public class FetchSortedProjectRewardsByIdQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchSortedProjectRewardsById"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchSortedProjectRewardsById($projectId: Int!, $location: CountryCode) { project(pid: $projectId) { __typename ...NoRewardRewardFragment rewards(location: $location, sort: ELIGIBILITY) { __typename nodes { __typename ...RewardFragment ...RewardImageFragment ...RewardItemsFragment ...RewardSimpleShippingRulesExpandedFragment } } } }"#,
      fragments: [LocationFragment.self, MoneyFragment.self, NoRewardRewardFragment.self, RewardFragment.self, RewardImageFragment.self, RewardItemsFragment.self, RewardSimpleShippingRulesExpandedFragment.self, SimpleShippingRuleFragment.self]
    ))

  /// GraphQL variable or field `projectId`.
  public var projectId: Int
  /// GraphQL variable or field `location`.
  public var location: GraphQLNullable<GraphQLEnum<CountryCode>>

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    projectId: Int,
    location: GraphQLNullable<GraphQLEnum<CountryCode>>
  ) {
    self.projectId = projectId
    self.location = location
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "projectId": projectId,
    "location": location
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
      .field("project", Project?.self, arguments: ["pid": .variable("projectId")]),
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
          ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.self)
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
        .field("rewards", Rewards?.self, arguments: [
          "location": .variable("location"),
          "sort": "ELIGIBILITY"
        ]),
        .fragment(NoRewardRewardFragment.self),
      ] }

      /// Project rewards.
      public var rewards: Rewards? { __data["rewards"] }
      /// The min pledge amount for a single reward tier.
      public var minPledge: Int { __data["minPledge"] }
      /// Exchange rate for the current user's currency
      public var fxRate: Double { __data["fxRate"] }

      /// Container of reusable GraphQL fragment views for this selection set.
      public struct Fragments: FragmentContainer {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL variable or field `noRewardRewardFragment`.
        public var noRewardRewardFragment: NoRewardRewardFragment { _toFragment() }
      }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        rewards: Rewards? = nil,
        minPledge: Int,
        fxRate: Double
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Project.typename,
            "rewards": rewards._fieldData,
            "minPledge": minPledge,
            "fxRate": fxRate,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.self),
            ObjectIdentifier(NoRewardRewardFragment.self)
          ]
        ))
      }

      /// Project.Rewards
      ///
      /// Parent Type: `ProjectRewardConnection`
      public struct Rewards: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ProjectRewardConnection }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          nodes: [Node?]? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.ProjectRewardConnection.typename,
              "nodes": nodes._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.self)
            ]
          ))
        }

        /// Project.Rewards.Node
        ///
        /// Parent Type: `Reward`
        public struct Node: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Reward }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(RewardFragment.self),
            .fragment(RewardImageFragment.self),
            .fragment(RewardItemsFragment.self),
            .fragment(RewardSimpleShippingRulesExpandedFragment.self),
          ] }

          /// Amount for claiming this reward.
          public var amount: Amount { __data["amount"] }
          /// count of backers for this reward
          public var backersCount: Int? { __data["backersCount"] }
          /// Amount for claiming this reward, in the current user's chosen currency
          public var convertedAmount: ConvertedAmount { __data["convertedAmount"] }
          /// Add-ons which can be combined with this reward.
          /// Uses creator preferences and shipping rules to determine allow-ability.
          /// Inclusion in this list does not necessarily indicate that the add-on is available for backing.
          ///
          public var allowedAddons: AllowedAddons { __data["allowedAddons"] }
          /// A reward description.
          public var description: String? { __data["description"] }
          /// A reward's title plus the amount, or a default title (the reward amount) if it doesn't have a title.
          public var displayName: String { __data["displayName"] }
          /// When the reward is scheduled to end in seconds
          public var endsAt: GraphAPI.DateTime? { __data["endsAt"] }
          /// Estimated delivery day.
          public var estimatedDeliveryOn: GraphAPI.Date? { __data["estimatedDeliveryOn"] }
          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }
          /// Does reward amount meet or exceed maximum pledge for the project
          public var isMaxPledge: Bool { __data["isMaxPledge"] }
          /// Whether or not the reward is available for new pledges
          public var available: Bool { __data["available"] }
          /// Whether or not the reward is featured
          public var featured: Bool { __data["featured"] }
          /// A reward limit.
          public var limit: Int? { __data["limit"] }
          /// Per backer reward limit.
          public var limitPerBacker: Int? { __data["limitPerBacker"] }
          /// Where the reward can be locally received if local receipt is selected as the shipping preference
          public var localReceiptLocation: LocalReceiptLocation? { __data["localReceiptLocation"] }
          /// A reward title.
          public var name: String? { __data["name"] }
          /// Amount for claiming this reward during the campaign.
          public var pledgeAmount: PledgeAmount { __data["pledgeAmount"] }
          /// Amount for claiming this reward after the campaign.
          public var latePledgeAmount: LatePledgeAmount { __data["latePledgeAmount"] }
          /// Is this reward available for post-campaign pledges?
          public var postCampaignPledgingEnabled: Bool { __data["postCampaignPledgingEnabled"] }
          /// Remaining reward quantity.
          public var remainingQuantity: Int? { __data["remainingQuantity"] }
          /// Shipping preference for this reward
          public var shippingPreference: GraphQLEnum<GraphAPI.ShippingPreference>? { __data["shippingPreference"] }
          /// A shipping summary
          public var shippingSummary: String? { __data["shippingSummary"] }
          /// When the reward is scheduled to start
          public var startsAt: GraphAPI.DateTime? { __data["startsAt"] }
          /// Data related to who can view/access this reward
          public var audienceData: AudienceData { __data["audienceData"] }
          /// The reward image.
          public var image: Image? { __data["image"] }
          /// The project
          public var project: Project? { __data["project"] }
          /// Items in the reward.
          public var items: Items? { __data["items"] }
          /// Simple shipping rules expanded as a faster alternative to shippingRulesExpanded since connection type is slow
          public var simpleShippingRulesExpanded: [SimpleShippingRulesExpanded?] { __data["simpleShippingRulesExpanded"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `rewardFragment`.
            public var rewardFragment: RewardFragment { _toFragment() }
            /// GraphQL variable or field `rewardImageFragment`.
            public var rewardImageFragment: RewardImageFragment { _toFragment() }
            /// GraphQL variable or field `rewardItemsFragment`.
            public var rewardItemsFragment: RewardItemsFragment { _toFragment() }
            /// GraphQL variable or field `rewardSimpleShippingRulesExpandedFragment`.
            public var rewardSimpleShippingRulesExpandedFragment: RewardSimpleShippingRulesExpandedFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            amount: Amount,
            backersCount: Int? = nil,
            convertedAmount: ConvertedAmount,
            allowedAddons: AllowedAddons,
            description: String? = nil,
            displayName: String,
            endsAt: GraphAPI.DateTime? = nil,
            estimatedDeliveryOn: GraphAPI.Date? = nil,
            id: GraphAPI.ID,
            isMaxPledge: Bool,
            available: Bool,
            featured: Bool,
            limit: Int? = nil,
            limitPerBacker: Int? = nil,
            localReceiptLocation: LocalReceiptLocation? = nil,
            name: String? = nil,
            pledgeAmount: PledgeAmount,
            latePledgeAmount: LatePledgeAmount,
            postCampaignPledgingEnabled: Bool,
            remainingQuantity: Int? = nil,
            shippingPreference: GraphQLEnum<GraphAPI.ShippingPreference>? = nil,
            shippingSummary: String? = nil,
            startsAt: GraphAPI.DateTime? = nil,
            audienceData: AudienceData,
            image: Image? = nil,
            project: Project? = nil,
            items: Items? = nil,
            simpleShippingRulesExpanded: [SimpleShippingRulesExpanded?]
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Reward.typename,
                "amount": amount._fieldData,
                "backersCount": backersCount,
                "convertedAmount": convertedAmount._fieldData,
                "allowedAddons": allowedAddons._fieldData,
                "description": description,
                "displayName": displayName,
                "endsAt": endsAt,
                "estimatedDeliveryOn": estimatedDeliveryOn,
                "id": id,
                "isMaxPledge": isMaxPledge,
                "available": available,
                "featured": featured,
                "limit": limit,
                "limitPerBacker": limitPerBacker,
                "localReceiptLocation": localReceiptLocation._fieldData,
                "name": name,
                "pledgeAmount": pledgeAmount._fieldData,
                "latePledgeAmount": latePledgeAmount._fieldData,
                "postCampaignPledgingEnabled": postCampaignPledgingEnabled,
                "remainingQuantity": remainingQuantity,
                "shippingPreference": shippingPreference,
                "shippingSummary": shippingSummary,
                "startsAt": startsAt,
                "audienceData": audienceData._fieldData,
                "image": image._fieldData,
                "project": project._fieldData,
                "items": items._fieldData,
                "simpleShippingRulesExpanded": simpleShippingRulesExpanded._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.self),
                ObjectIdentifier(RewardFragment.self),
                ObjectIdentifier(RewardImageFragment.self),
                ObjectIdentifier(RewardItemsFragment.self),
                ObjectIdentifier(RewardSimpleShippingRulesExpandedFragment.self)
              ]
            ))
          }

          /// Project.Rewards.Node.Amount
          ///
          /// Parent Type: `Money`
          public struct Amount: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

            /// Floating-point numeric value of monetary amount represented as a string
            public var amount: String? { __data["amount"] }
            /// Currency of the monetary amount
            public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
            /// Symbol of the currency in which the monetary amount appears
            public var symbol: String? { __data["symbol"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `moneyFragment`.
              public var moneyFragment: MoneyFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              amount: String? = nil,
              currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
              symbol: String? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Money.typename,
                  "amount": amount,
                  "currency": currency,
                  "symbol": symbol,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.Amount.self),
                  ObjectIdentifier(RewardFragment.Amount.self),
                  ObjectIdentifier(MoneyFragment.self)
                ]
              ))
            }
          }

          /// Project.Rewards.Node.ConvertedAmount
          ///
          /// Parent Type: `Money`
          public struct ConvertedAmount: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

            /// Floating-point numeric value of monetary amount represented as a string
            public var amount: String? { __data["amount"] }
            /// Currency of the monetary amount
            public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
            /// Symbol of the currency in which the monetary amount appears
            public var symbol: String? { __data["symbol"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `moneyFragment`.
              public var moneyFragment: MoneyFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              amount: String? = nil,
              currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
              symbol: String? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Money.typename,
                  "amount": amount,
                  "currency": currency,
                  "symbol": symbol,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.ConvertedAmount.self),
                  ObjectIdentifier(RewardFragment.ConvertedAmount.self),
                  ObjectIdentifier(MoneyFragment.self)
                ]
              ))
            }
          }

          /// Type alias for `AllowedAddons` nested GraphQL selection set.
          public typealias AllowedAddons = RewardFragment.AllowedAddons

          /// Project.Rewards.Node.LocalReceiptLocation
          ///
          /// Parent Type: `Location`
          public struct LocalReceiptLocation: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Location }

            /// The country code.
            public var country: String { __data["country"] }
            /// The localized country name.
            public var countryName: String? { __data["countryName"] }
            /// The displayable name. It includes the state code for US cities. ex: 'Seattle, WA'
            public var displayableName: String { __data["displayableName"] }
            /// Unique GraphQL node identifier.
            public var id: GraphAPI.ID { __data["id"] }
            /// The localized name
            public var name: String { __data["name"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `locationFragment`.
              public var locationFragment: LocationFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              country: String,
              countryName: String? = nil,
              displayableName: String,
              id: GraphAPI.ID,
              name: String
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Location.typename,
                  "country": country,
                  "countryName": countryName,
                  "displayableName": displayableName,
                  "id": id,
                  "name": name,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.LocalReceiptLocation.self),
                  ObjectIdentifier(RewardFragment.LocalReceiptLocation.self),
                  ObjectIdentifier(LocationFragment.self)
                ]
              ))
            }
          }

          /// Project.Rewards.Node.PledgeAmount
          ///
          /// Parent Type: `Money`
          public struct PledgeAmount: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

            /// Floating-point numeric value of monetary amount represented as a string
            public var amount: String? { __data["amount"] }
            /// Currency of the monetary amount
            public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
            /// Symbol of the currency in which the monetary amount appears
            public var symbol: String? { __data["symbol"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `moneyFragment`.
              public var moneyFragment: MoneyFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              amount: String? = nil,
              currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
              symbol: String? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Money.typename,
                  "amount": amount,
                  "currency": currency,
                  "symbol": symbol,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.PledgeAmount.self),
                  ObjectIdentifier(RewardFragment.PledgeAmount.self),
                  ObjectIdentifier(MoneyFragment.self)
                ]
              ))
            }
          }

          /// Project.Rewards.Node.LatePledgeAmount
          ///
          /// Parent Type: `Money`
          public struct LatePledgeAmount: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

            /// Floating-point numeric value of monetary amount represented as a string
            public var amount: String? { __data["amount"] }
            /// Currency of the monetary amount
            public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
            /// Symbol of the currency in which the monetary amount appears
            public var symbol: String? { __data["symbol"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `moneyFragment`.
              public var moneyFragment: MoneyFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              amount: String? = nil,
              currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
              symbol: String? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Money.typename,
                  "amount": amount,
                  "currency": currency,
                  "symbol": symbol,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.LatePledgeAmount.self),
                  ObjectIdentifier(RewardFragment.LatePledgeAmount.self),
                  ObjectIdentifier(MoneyFragment.self)
                ]
              ))
            }
          }

          /// Type alias for `AudienceData` nested GraphQL selection set.
          public typealias AudienceData = RewardFragment.AudienceData

          /// Type alias for `Image` nested GraphQL selection set.
          public typealias Image = RewardImageFragment.Image

          /// Type alias for `Project` nested GraphQL selection set.
          public typealias Project = RewardItemsFragment.Project

          /// Type alias for `Items` nested GraphQL selection set.
          public typealias Items = RewardItemsFragment.Items

          /// Project.Rewards.Node.SimpleShippingRulesExpanded
          ///
          /// Parent Type: `SimpleShippingRule`
          public struct SimpleShippingRulesExpanded: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.SimpleShippingRule }

            /// GraphQL variable or field `cost`.
            public var cost: String? { __data["cost"] }
            /// GraphQL variable or field `estimatedMin`.
            public var estimatedMin: String? { __data["estimatedMin"] }
            /// GraphQL variable or field `estimatedMax`.
            public var estimatedMax: String? { __data["estimatedMax"] }
            /// GraphQL variable or field `currency`.
            public var currency: String? { __data["currency"] }
            /// GraphQL variable or field `locationId`.
            public var locationId: GraphAPI.ID? { __data["locationId"] }
            /// GraphQL variable or field `locationName`.
            public var locationName: String? { __data["locationName"] }
            /// GraphQL variable or field `country`.
            public var country: String { __data["country"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `simpleShippingRuleFragment`.
              public var simpleShippingRuleFragment: SimpleShippingRuleFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              cost: String? = nil,
              estimatedMin: String? = nil,
              estimatedMax: String? = nil,
              currency: String? = nil,
              locationId: GraphAPI.ID? = nil,
              locationName: String? = nil,
              country: String
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.SimpleShippingRule.typename,
                  "cost": cost,
                  "estimatedMin": estimatedMin,
                  "estimatedMax": estimatedMax,
                  "currency": currency,
                  "locationId": locationId,
                  "locationName": locationName,
                  "country": country,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchSortedProjectRewardsByIdQuery.Data.Project.Rewards.Node.SimpleShippingRulesExpanded.self),
                  ObjectIdentifier(RewardSimpleShippingRulesExpandedFragment.SimpleShippingRulesExpanded.self),
                  ObjectIdentifier(SimpleShippingRuleFragment.self)
                ]
              ))
            }
          }
        }
      }
    }
  }
}
