#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

  internal struct MockService: ServiceType {
    internal var apolloClient: ApolloClientType?
    internal var appId: String
    internal var serverConfig: ServerConfigType
    internal var oauthToken: OauthTokenAuthType?
    internal var language: String
    internal var currency: String
    internal var buildVersion: String
    internal var deviceIdentifier: String

    internal var addNewCreditCardResult: Result<CreatePaymentSourceEnvelope, ErrorEnvelope>?
    internal var addPaymentSheetPaymentSourceResult: Result<CreatePaymentSourceEnvelope, ErrorEnvelope>?
    internal var addUserToSecretRewardGroup: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var blockUserResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var buildPaymentPlanResult: Result<GraphAPI.BuildPaymentPlanQuery.Data, ErrorEnvelope>?
    internal var cancelBackingResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var changeCurrencyResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var changeEmailResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var changePasswordResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var createAttributionEventResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var createBackingResult: Result<CreateBackingEnvelope, ErrorEnvelope>?
    internal var completeOnSessionCheckoutResult: Result<
      GraphAPI.CompleteOnSessionCheckoutMutation.Data,
      ErrorEnvelope
    >?
    internal var createCheckoutResult: Result<CreateCheckoutEnvelope, ErrorEnvelope>?
    internal var createFlaggingResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var fetchFlaggingOptionsResult: Result<GraphAPI.FlaggingOptionsQuery.Data, ErrorEnvelope>?
    internal var createPaymentIntentResult: Result<PaymentIntentEnvelope, ErrorEnvelope>?
    internal var createPasswordResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var createStripeSetupIntentResult: Result<ClientSecretEnvelope, ErrorEnvelope>?
    internal var changePaymentMethodResult: Result<ChangePaymentMethodEnvelope, ErrorEnvelope>?
    internal var clearUserUnseenActivityResult: Result<ClearUserUnseenActivityEnvelope, ErrorEnvelope>?
    internal var confirmBackingAddressResult: Result<Bool, ErrorEnvelope>?
    internal var deletePaymentMethodResult: Result<DeletePaymentMethodEnvelope, ErrorEnvelope>?
    internal var triggerThirdPartyEventResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?

    internal var facebookConnectResponse: User?
    internal var facebookConnectError: ErrorEnvelope?
    internal var fetchGraphQLResponses: [(any GraphQLQuery.Type, any GraphAPI.SelectionSet)]?
    internal var fetchActivitiesResponse: [Activity]?
    internal var fetchActivitiesError: ErrorEnvelope?
    internal var fetchBackingResponse: Backing
    internal var backingUpdate: Backing
    internal var fetchGraphCategoryResult: Result<CategoryEnvelope, ErrorEnvelope>?
    internal var fetchGraphCategoriesResult: Result<RootCategoriesEnvelope, ErrorEnvelope>?
    internal var fetchProjectCommentsEnvelopeResult: Result<CommentsEnvelope, ErrorEnvelope>?
    internal var fetchUpdateCommentsEnvelopeResult: Result<CommentsEnvelope, ErrorEnvelope>?
    internal var fetchCommentRepliesEnvelopeResult: Result<CommentRepliesEnvelope, ErrorEnvelope>?
    internal var fetchConfigResponse: Config?
    internal var fetchDiscoveryResponse: DiscoveryEnvelope?
    internal var fetchDiscoveryError: ErrorEnvelope?
    internal var fetchFriendsResponse: FindFriendsEnvelope?
    internal var fetchFriendsError: ErrorEnvelope?
    internal var fetchFriendStatsResponse: FriendStatsEnvelope?
    internal var fetchFriendStatsError: ErrorEnvelope?
    internal var fetchDraftResponse: UpdateDraft?
    internal var fetchDraftError: ErrorEnvelope?

    internal var fetchGraphUserResult: Result<UserEnvelope<GraphUser>, ErrorEnvelope>?
    internal var fetchGraphUserSelfResult: Result<UserEnvelope<User>, ErrorEnvelope>?
    internal var fetchGraphUserEmailResult: Result<UserEnvelope<GraphUserEmail>, ErrorEnvelope>?
    internal var fetchGraphUserSetupResult: Result<UserEnvelope<GraphUserSetup>, ErrorEnvelope>?

    internal var addAttachmentResponse: UpdateDraft.Image?
    internal var addAttachmentError: ErrorEnvelope?
    internal var removeAttachmentResponse: UpdateDraft.Image?
    internal var removeAttachmentError: ErrorEnvelope?
    internal var publishUpdateError: ErrorEnvelope?

    internal var fetchBackerSavedProjectsResponse: GraphAPI.FetchMySavedProjectsQuery.Data?
    internal var fetchBackerBackedProjectsResponse: GraphAPI.FetchMyBackedProjectsQuery.Data?
    internal var fetchProjectAndBackingResult: Result<ProjectAndBackingEnvelope, ErrorEnvelope>?
    internal var fetchManagePledgeViewBackingResult: Result<Backing, ErrorEnvelope>?
    internal var fetchMessageThreadResult: Result<MessageThread?, ErrorEnvelope>?
    internal var fetchMessageThreadsResponse: [MessageThread]
    internal var fetchPledgedProjectsResult: Result<GraphAPI.FetchPledgedProjectsQuery.Data, ErrorEnvelope>?

    /**
     FIXME: Eventually combine `fetchProjectEnvelopeResult` and `fetchProjectPamphletEnvelopeResult` once all calls returning `Project` are using GQL. https://kickstarter.atlassian.net/browse/NTV-219
     */
    internal var fetchProjectEnvelopeResult: Result<Project, ErrorEnvelope>?
    internal var fastFetchProjectPageResult: (
      Result<Project, ErrorEnvelope>,
      Result<ProjectPageExtraProperties, ErrorEnvelope>
    )?
    internal var fetchProjectPamphletEnvelopeResult: Result<Project.ProjectPamphletData, ErrorEnvelope>?
    internal var fetchProjectFriendsEnvelopeResult: Result<[User], ErrorEnvelope>?
    internal var fetchProjectRewardsAndPledgeOverTimeDataResult: Result<
      RewardsAndPledgeOverTimeEnvelope,
      ErrorEnvelope
    >?
    internal var fetchProjectRewardsEnvelopeResult: Result<[Reward], ErrorEnvelope>?
    internal var fetchProjectsResponse: [Project]?
    internal var fetchProjectsError: ErrorEnvelope?
    internal var fetchProjectNotificationsResponse: [ProjectNotification]
    internal var fetchProjectStatsResponse: ProjectStatsEnvelope?
    internal var fetchProjectStatsError: ErrorEnvelope?
    internal var fetchRewardAddOnsSelectionViewRewardsResult: Result<Project, ErrorEnvelope>?
    internal var fetchShippingRulesResult: Result<[ShippingRule], ErrorEnvelope>?
    internal var fetchSurveyResponseResponse: SurveyResponse?
    internal var fetchSurveyResponseError: ErrorEnvelope?
    internal var fetchUnansweredSurveyResponsesResponse: [SurveyResponse]
    internal var fetchUpdateResponse: Update
    internal var fetchUserResult: Result<User, ErrorEnvelope>?
    internal var fetchUserSelfResponse: User?
    internal var fetchUserSelfError: ErrorEnvelope?
    internal var followFriendError: ErrorEnvelope?
    internal var incrementVideoCompletionError: ErrorEnvelope?
    internal var incrementVideoStartError: ErrorEnvelope?
    internal var postCommentResult: Result<Comment, ErrorEnvelope>?
    internal var fetchProjectActivitiesResponse: [Activity]?
    internal var fetchProjectActivitiesError: ErrorEnvelope?
    internal var loginResponse: AccessTokenEnvelope?
    internal var loginError: ErrorEnvelope?
    internal var resendCodeResponse: ErrorEnvelope?
    internal var resendCodeError: ErrorEnvelope?
    internal var resetPasswordResponse: User?
    internal var resetPasswordError: ErrorEnvelope?
    internal var sendEmailVerificationResult: Result<EmptyResponseEnvelope, ErrorEnvelope>?
    internal var signInWithAppleResult: Result<SignInWithAppleEnvelope, ErrorEnvelope>?
    internal var signupResponse: AccessTokenEnvelope?
    internal var signupError: ErrorEnvelope?
    internal var tokenExchangeResponse: OAuthTokenExchangeResponse?
    internal var unfollowFriendError: ErrorEnvelope?
    internal var updateRewardReceivedResult: Result<Bool, ErrorEnvelope>?
    internal var updateBackingResult: Result<UpdateBackingEnvelope, ErrorEnvelope>?
    internal var updateDraftError: ErrorEnvelope?
    internal var updatePledgeResult: Result<UpdatePledgeEnvelope, ErrorEnvelope>?
    internal var updateProjectNotificationResponse: ProjectNotification?
    internal var updateProjectNotificationError: ErrorEnvelope?
    internal var updateUserSelfError: ErrorEnvelope?
    internal var unwatchProjectMutationResult: Result<WatchProjectResponseEnvelope, ErrorEnvelope>?
    internal var validateCheckoutResult: Result<ValidateCheckoutEnvelope, ErrorEnvelope>?
    internal var verifyEmailResult: Result<EmailVerificationResponseEnvelope, ErrorEnvelope>?
    internal var watchProjectMutationResult: Result<WatchProjectResponseEnvelope, ErrorEnvelope>?
  }

  extension GraphAPI.CompleteOnSessionCheckoutMutation.Data: Decodable {
    /// Test-only `Decodable` stub; always traps because `MockService` uses prebuilt fixtures instead of JSON decoding.
    /// - Negative Constraint: Do not decode GraphQL mutation data from JSON in tests.
    public init(from _: Decoder) throws {
      fatalError("The test code should not actually be decoding this object.")
    }
  }

  extension GraphAPI.BuildPaymentPlanQuery.Data: Decodable {
    /// Test-only `Decodable` stub; always traps because `MockService` uses prebuilt fixtures instead of JSON decoding.
    public init(from _: Decoder) throws {
      fatalError("The test code should not actually be decoding this object.")
    }
  }
#endif
