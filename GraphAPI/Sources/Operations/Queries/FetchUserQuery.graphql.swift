// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchUserQuery`.
public class FetchUserQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchUser"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchUser($withStoredCards: Boolean!) { me { __typename ...UserFragment } }"#,
      fragments: [LocationFragment.self, UserFragment.self, UserStoredCardsFragment.self]
    ))

  /// GraphQL variable or field `withStoredCards`.
  public var withStoredCards: Bool

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(withStoredCards: Bool) {
    self.withStoredCards = withStoredCards
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["withStoredCards": withStoredCards] }

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
      .field("me", Me?.self),
    ] }

    /// You.
    public var me: Me? { __data["me"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      me: Me? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "me": me._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchUserQuery.Data.self)
        ]
      ))
    }

    /// Me
    ///
    /// Parent Type: `User`
    public struct Me: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(UserFragment.self),
      ] }

      /// A user's backings.
      public var backings: Backings? { __data["backings"] }
      /// Number of backings for this user.
      public var backingsCount: Int { __data["backingsCount"] }
      /// The user's chosen currency
      public var chosenCurrency: String? { __data["chosenCurrency"] }
      /// Projects a user has created.
      public var createdProjects: CreatedProjects? { __data["createdProjects"] }
      /// A user's email address.
      public var email: String? { __data["email"] }
      /// Whether or not the user has a password.
      public var hasPassword: Bool? { __data["hasPassword"] }
      /// Whether or not a user has unread messages.
      public var hasUnreadMessages: Bool? { __data["hasUnreadMessages"] }
      /// Whether or not a user has unseen activity.
      public var hasUnseenActivity: Bool? { __data["hasUnseenActivity"] }
      /// Unique GraphQL node identifier.
      public var id: GraphAPI.ID { __data["id"] }
      /// The user's avatar.
      public var imageUrl: String { __data["imageUrl"] }
      /// Whether or not the user has authenticated with Apple.
      public var isAppleConnected: Bool? { __data["isAppleConnected"] }
      /// Is user blocked by current user
      public var isBlocked: Bool? { __data["isBlocked"] }
      /// Whether a user is a creator of any project
      public var isCreator: Bool? { __data["isCreator"] }
      /// Whether a user's email address is deliverable
      public var isDeliverable: Bool? { __data["isDeliverable"] }
      /// Whether or not the user's email is verified.
      public var isEmailVerified: Bool? { __data["isEmailVerified"] }
      /// Whether or not the user is connected to Facebook.
      public var isFacebookConnected: Bool? { __data["isFacebookConnected"] }
      /// Whether or not you are a KSR admin.
      public var isKsrAdmin: Bool? { __data["isKsrAdmin"] }
      /// Whether or not you are following the user.
      public var isFollowing: Bool { __data["isFollowing"] }
      /// Whether or not the user is either Facebook connected or has follows/followings.
      public var isSocializing: Bool? { __data["isSocializing"] }
      /// Where the user is based.
      public var location: Location? { __data["location"] }
      /// The user's provided name.
      public var name: String { __data["name"] }
      /// Does the user to refresh their facebook token?
      public var needsFreshFacebookToken: Bool? { __data["needsFreshFacebookToken"] }
      /// Which newsleters are the users subscribed to
      public var newsletterSubscriptions: NewsletterSubscriptions? { __data["newsletterSubscriptions"] }
      /// All of a user's notifications
      public var notifications: [Notification]? { __data["notifications"] }
      /// Is the user opted out from receiving recommendations
      public var optedOutOfRecommendations: Bool? { __data["optedOutOfRecommendations"] }
      /// Is the user's profile public
      public var showPublicProfile: Bool? { __data["showPublicProfile"] }
      /// Projects a user has saved.
      public var savedProjects: SavedProjects? { __data["savedProjects"] }
      /// Stored Cards
      public var storedCards: StoredCards? { __data["storedCards"] }
      /// This user's survey responses
      public var surveyResponses: SurveyResponses? { __data["surveyResponses"] }
      /// A user's uid
      public var uid: String { __data["uid"] }

      /// Container of reusable GraphQL fragment views for this selection set.
      public struct Fragments: FragmentContainer {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL variable or field `userFragment`.
        public var userFragment: UserFragment { _toFragment() }
      }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        backings: Backings? = nil,
        backingsCount: Int,
        chosenCurrency: String? = nil,
        createdProjects: CreatedProjects? = nil,
        email: String? = nil,
        hasPassword: Bool? = nil,
        hasUnreadMessages: Bool? = nil,
        hasUnseenActivity: Bool? = nil,
        id: GraphAPI.ID,
        imageUrl: String,
        isAppleConnected: Bool? = nil,
        isBlocked: Bool? = nil,
        isCreator: Bool? = nil,
        isDeliverable: Bool? = nil,
        isEmailVerified: Bool? = nil,
        isFacebookConnected: Bool? = nil,
        isKsrAdmin: Bool? = nil,
        isFollowing: Bool,
        isSocializing: Bool? = nil,
        location: Location? = nil,
        name: String,
        needsFreshFacebookToken: Bool? = nil,
        newsletterSubscriptions: NewsletterSubscriptions? = nil,
        notifications: [Notification]? = nil,
        optedOutOfRecommendations: Bool? = nil,
        showPublicProfile: Bool? = nil,
        savedProjects: SavedProjects? = nil,
        storedCards: StoredCards? = nil,
        surveyResponses: SurveyResponses? = nil,
        uid: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.User.typename,
            "backings": backings._fieldData,
            "backingsCount": backingsCount,
            "chosenCurrency": chosenCurrency,
            "createdProjects": createdProjects._fieldData,
            "email": email,
            "hasPassword": hasPassword,
            "hasUnreadMessages": hasUnreadMessages,
            "hasUnseenActivity": hasUnseenActivity,
            "id": id,
            "imageUrl": imageUrl,
            "isAppleConnected": isAppleConnected,
            "isBlocked": isBlocked,
            "isCreator": isCreator,
            "isDeliverable": isDeliverable,
            "isEmailVerified": isEmailVerified,
            "isFacebookConnected": isFacebookConnected,
            "isKsrAdmin": isKsrAdmin,
            "isFollowing": isFollowing,
            "isSocializing": isSocializing,
            "location": location._fieldData,
            "name": name,
            "needsFreshFacebookToken": needsFreshFacebookToken,
            "newsletterSubscriptions": newsletterSubscriptions._fieldData,
            "notifications": notifications._fieldData,
            "optedOutOfRecommendations": optedOutOfRecommendations,
            "showPublicProfile": showPublicProfile,
            "savedProjects": savedProjects._fieldData,
            "storedCards": storedCards._fieldData,
            "surveyResponses": surveyResponses._fieldData,
            "uid": uid,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchUserQuery.Data.Me.self),
            ObjectIdentifier(UserFragment.self)
          ]
        ))
      }

      /// Type alias for `Backings` nested GraphQL selection set.
      public typealias Backings = UserFragment.Backings

      /// Type alias for `CreatedProjects` nested GraphQL selection set.
      public typealias CreatedProjects = UserFragment.CreatedProjects

      /// Me.Location
      ///
      /// Parent Type: `Location`
      public struct Location: GraphAPI.SelectionSet {
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
              ObjectIdentifier(FetchUserQuery.Data.Me.Location.self),
              ObjectIdentifier(UserFragment.Location.self),
              ObjectIdentifier(LocationFragment.self)
            ]
          ))
        }
      }

      /// Type alias for `NewsletterSubscriptions` nested GraphQL selection set.
      public typealias NewsletterSubscriptions = UserFragment.NewsletterSubscriptions

      /// Type alias for `Notification` nested GraphQL selection set.
      public typealias Notification = UserFragment.Notification

      /// Type alias for `SavedProjects` nested GraphQL selection set.
      public typealias SavedProjects = UserFragment.SavedProjects

      /// Me.StoredCards
      ///
      /// Parent Type: `UserCreditCardTypeConnection`
      public struct StoredCards: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UserCreditCardTypeConnection }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }
        /// GraphQL variable or field `totalCount`.
        public var totalCount: Int { __data["totalCount"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `userStoredCardsFragment`.
          public var userStoredCardsFragment: UserStoredCardsFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          nodes: [Node?]? = nil,
          totalCount: Int
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.UserCreditCardTypeConnection.typename,
              "nodes": nodes._fieldData,
              "totalCount": totalCount,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FetchUserQuery.Data.Me.StoredCards.self),
              ObjectIdentifier(UserFragment.StoredCards.self),
              ObjectIdentifier(UserStoredCardsFragment.self)
            ]
          ))
        }

        /// Type alias for `Node` nested GraphQL selection set.
        public typealias Node = UserStoredCardsFragment.Node
      }

      /// Type alias for `SurveyResponses` nested GraphQL selection set.
      public typealias SurveyResponses = UserFragment.SurveyResponses
    }
  }
}
