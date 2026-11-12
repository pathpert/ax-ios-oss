#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

/// `MockService` extensions declared in `MockService+Init.swift`.
  extension MockService {
    internal init(
      appId: String = "com.kickstarter.kickstarter.mock",
      serverConfig: ServerConfigType,
      oauthToken: OauthTokenAuthType?,
      language: String,
      currency: String,
      buildVersion: String = "1",
      deviceIdentifier: String = "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
      apolloClient: ApolloClientType? = nil
    ) {
      self.init(
        appId: appId,
        serverConfig: serverConfig,
        oauthToken: oauthToken,
        language: language,
        currency: currency,
        buildVersion: buildVersion,
        deviceIdentifier: deviceIdentifier,
        addNewCreditCardResult: nil,
        apolloClient: apolloClient
      )
    }

    internal init(
      appId: String = "com.kickstarter.kickstarter.mock",
      serverConfig: ServerConfigType = ServerConfig.production,
      oauthToken: OauthTokenAuthType? = nil,
      language: String = "en",
      currency: String = "USD",
      buildVersion: String = "1",
      deviceIdentifier: String = "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
      addNewCreditCardResult: Result<CreatePaymentSourceEnvelope, ErrorEnvelope>? = nil,
      addPaymentSheetPaymentSourceResult: Result<CreatePaymentSourceEnvelope, ErrorEnvelope>? = nil,
      addUserToSecretRewardGroup: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      apolloClient: ApolloClientType? = nil,
      blockUserResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      buildPaymentPlanResult: Result<GraphAPI.BuildPaymentPlanQuery.Data, ErrorEnvelope>? = nil,
      cancelBackingResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      changeEmailResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      changePasswordResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      createAttributionEventResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      createBackingResult: Result<CreateBackingEnvelope, ErrorEnvelope>? = nil,
      completeOnSessionCheckoutResult: Result<GraphAPI.CompleteOnSessionCheckoutMutation.Data, ErrorEnvelope>? = nil,
      createCheckoutResult: Result<CreateCheckoutEnvelope, ErrorEnvelope>? = nil,
      createFlaggingResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      fetchFlaggingOptionsResult: Result<GraphAPI.FlaggingOptionsQuery.Data, ErrorEnvelope>? = nil,
      createPaymentIntentResult: Result<PaymentIntentEnvelope, ErrorEnvelope>? = nil,
      createPasswordResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      createStripeSetupIntentResult: Result<ClientSecretEnvelope, ErrorEnvelope>? = nil,
      changeCurrencyResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      changePaymentMethodResult: Result<ChangePaymentMethodEnvelope, ErrorEnvelope>? = nil,
      confirmBackingAddressResult: Result<Bool, ErrorEnvelope>? = nil,
      deletePaymentMethodResult: Result<DeletePaymentMethodEnvelope, ErrorEnvelope>? = nil,
      triggerThirdPartyEventResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      clearUserUnseenActivityResult: Result<ClearUserUnseenActivityEnvelope, ErrorEnvelope>? = nil,
      facebookConnectResponse: User? = nil,
      facebookConnectError: ErrorEnvelope? = nil,
      fetchGraphQLResponses: [(any GraphQLQuery.Type, any GraphAPI.SelectionSet)]? = nil,
      fetchActivitiesResponse: [Activity]? = nil,
      fetchActivitiesError: ErrorEnvelope? = nil,
      fetchBackingResponse: Backing = .template,
      backingUpdate: Backing = .template,
      fetchBackerSavedProjectsResponse: GraphAPI.FetchMySavedProjectsQuery.Data? = nil,
      fetchBackerBackedProjectsResponse: GraphAPI.FetchMyBackedProjectsQuery.Data? = nil,
      fetchGraphCategoryResult: Result<CategoryEnvelope, ErrorEnvelope>? = nil,
      fetchGraphCategoriesResult: Result<RootCategoriesEnvelope, ErrorEnvelope>? = nil,
      fetchCommentsResponse _: [ActivityComment]? = nil,
      fetchCommentsError _: ErrorEnvelope? = nil,
      fetchProjectCommentsEnvelopeResult: Result<CommentsEnvelope, ErrorEnvelope>? = nil,
      fetchUpdateCommentsEnvelopeResult: Result<CommentsEnvelope, ErrorEnvelope>? = nil,
      fetchCommentRepliesEnvelopeResult: Result<CommentRepliesEnvelope, ErrorEnvelope>? = nil,
      fetchConfigResponse: Config? = nil,
      fetchDiscoveryResponse: DiscoveryEnvelope? = nil,
      fetchDiscoveryError: ErrorEnvelope? = nil,
      fetchFriendsResponse: FindFriendsEnvelope? = nil,
      fetchFriendsError: ErrorEnvelope? = nil,
      fetchFriendStatsResponse: FriendStatsEnvelope? = nil,
      fetchFriendStatsError: ErrorEnvelope? = nil,
      fetchDraftResponse: UpdateDraft? = nil,
      fetchDraftError: ErrorEnvelope? = nil,
      fetchGraphUserResult: Result<UserEnvelope<GraphUser>, ErrorEnvelope>? = nil,
      fetchGraphUserSelfResult: Result<UserEnvelope<User>, ErrorEnvelope>? = nil,
      fetchGraphUserEmailResult: Result<UserEnvelope<GraphUserEmail>, ErrorEnvelope>? = nil,
      fetchGraphUserSetupResult: Result<UserEnvelope<GraphUserSetup>, ErrorEnvelope>? = nil,
      addAttachmentResponse: UpdateDraft.Image? = nil,
      addAttachmentError: ErrorEnvelope? = nil,
      removeAttachmentResponse: UpdateDraft.Image? = nil,
      removeAttachmentError: ErrorEnvelope? = nil,
      publishUpdateError: ErrorEnvelope? = nil,
      fetchManagePledgeViewBackingResult: Result<Backing, ErrorEnvelope>? = nil,
      fetchProjectAndBackingResult: Result<ProjectAndBackingEnvelope, ErrorEnvelope>? = nil,
      fetchMessageThreadResult: Result<MessageThread?, ErrorEnvelope>? = nil,
      fetchMessageThreadsResponse: [MessageThread]? = nil,
      fetchPledgedProjectsResult: Result<GraphAPI.FetchPledgedProjectsQuery.Data, ErrorEnvelope>? = nil,
      fetchProjectResult: Result<Project, ErrorEnvelope>? = nil,
      fastFetchProjectPage: (Result<Project, ErrorEnvelope>, Result<ProjectPageExtraProperties, ErrorEnvelope>)? = nil,
      fetchProjectPamphletResult: Result<Project.ProjectPamphletData, ErrorEnvelope>? = nil,
      fetchProjectFriendsResult: Result<[User], ErrorEnvelope>? = nil,
      fetchProjectRewardsAndPledgeOverTimeDataResult: Result<RewardsAndPledgeOverTimeEnvelope, ErrorEnvelope>? = nil,
      fetchProjectRewardsResult: Result<[Reward], ErrorEnvelope>? = nil,
      fetchProjectActivitiesResponse: [Activity]? = nil,
      fetchProjectActivitiesError: ErrorEnvelope? = nil,
      fetchProjectNotificationsResponse: [ProjectNotification]? = nil,
      fetchProjectsResponse: [Project]? = nil,
      fetchProjectsError: ErrorEnvelope? = nil,
      fetchProjectStatsResponse: ProjectStatsEnvelope? = nil,
      fetchProjectStatsError: ErrorEnvelope? = nil,
      fetchShippingRulesResult: Result<[ShippingRule], ErrorEnvelope>? = nil,
      fetchUserProjectsBackedError _: ErrorEnvelope? = nil,
      fetchUserResult: Result<User, ErrorEnvelope>? = nil,
      fetchUserSelfResponse: User? = nil,
      followFriendError: ErrorEnvelope? = nil,
      incrementVideoCompletionError: ErrorEnvelope? = nil,
      incrementVideoStartError: ErrorEnvelope? = nil,
      fetchRewardAddOnsSelectionViewRewardsResult: Result<Project, ErrorEnvelope>? = nil,
      fetchSurveyResponseResponse: SurveyResponse? = nil,
      fetchSurveyResponseError: ErrorEnvelope? = nil,
      fetchUnansweredSurveyResponsesResponse: [SurveyResponse] = [],
      fetchUpdateResponse: Update = .template,
      fetchUserSelfError: ErrorEnvelope? = nil,
      postCommentResult: Result<Comment, ErrorEnvelope>? = nil,
      loginResponse: AccessTokenEnvelope? = nil,
      loginError: ErrorEnvelope? = nil,
      tokenExchangeResponse: OAuthTokenExchangeResponse? = nil,
      resendCodeResponse: ErrorEnvelope? = nil,
      resendCodeError: ErrorEnvelope? = nil,
      resetPasswordResponse: User? = nil,
      resetPasswordError: ErrorEnvelope? = nil,
      sendEmailVerificationResult: Result<EmptyResponseEnvelope, ErrorEnvelope>? = nil,
      signInWithAppleResult: Result<SignInWithAppleEnvelope, ErrorEnvelope>? = nil,
      signupResponse: AccessTokenEnvelope? = nil,
      signupError: ErrorEnvelope? = nil,
      unfollowFriendError: ErrorEnvelope? = nil,
      updateRewardReceivedResult: Result<Bool, ErrorEnvelope>? = nil,
      updateBackingResult: Result<UpdateBackingEnvelope, ErrorEnvelope>? = nil,
      updateDraftError: ErrorEnvelope? = nil,
      updatePledgeResult: Result<UpdatePledgeEnvelope, ErrorEnvelope>? = nil,
      updateProjectNotificationResponse: ProjectNotification? = nil,
      updateProjectNotificationError: ErrorEnvelope? = nil,
      updateUserSelfError: ErrorEnvelope? = nil,
      unwatchProjectMutationResult: Result<WatchProjectResponseEnvelope, ErrorEnvelope>? = nil,
      validateCheckoutResult: Result<ValidateCheckoutEnvelope, ErrorEnvelope>? = nil,
      verifyEmailResult: Result<EmailVerificationResponseEnvelope, ErrorEnvelope>? = nil,
      watchProjectMutationResult: Result<WatchProjectResponseEnvelope, ErrorEnvelope>? = nil
    ) {
      self.appId = appId
      self.serverConfig = serverConfig
      self.oauthToken = oauthToken
      self.language = language
      self.currency = currency
      self.buildVersion = buildVersion
      self.deviceIdentifier = deviceIdentifier
      self.addNewCreditCardResult = addNewCreditCardResult
      self.addPaymentSheetPaymentSourceResult = addPaymentSheetPaymentSourceResult
      self.addUserToSecretRewardGroup = addUserToSecretRewardGroup
      self.apolloClient = apolloClient ?? MockGraphQLClient.shared.client
      self.blockUserResult = blockUserResult
      self.buildPaymentPlanResult = buildPaymentPlanResult
      self.cancelBackingResult = cancelBackingResult
      self.changeEmailResult = changeEmailResult
      self.changeCurrencyResult = changeCurrencyResult
      self.changePasswordResult = changePasswordResult
      self.clearUserUnseenActivityResult = clearUserUnseenActivityResult
      self.createAttributionEventResult = createAttributionEventResult
      self.createBackingResult = createBackingResult
      self.completeOnSessionCheckoutResult = completeOnSessionCheckoutResult
      self.createCheckoutResult = createCheckoutResult
      self.createFlaggingResult = createFlaggingResult
      self.fetchFlaggingOptionsResult = fetchFlaggingOptionsResult
      self.createPaymentIntentResult = createPaymentIntentResult
      self.createPasswordResult = createPasswordResult
      self.createStripeSetupIntentResult = createStripeSetupIntentResult
      self.changePaymentMethodResult = changePaymentMethodResult
      self.confirmBackingAddressResult = confirmBackingAddressResult
      self.deletePaymentMethodResult = deletePaymentMethodResult
      self.triggerThirdPartyEventResult = triggerThirdPartyEventResult
      self.facebookConnectResponse = facebookConnectResponse
      self.facebookConnectError = facebookConnectError
      self.fetchGraphQLResponses = fetchGraphQLResponses
      self.fetchActivitiesResponse = fetchActivitiesResponse ?? [
        .template,
        .template |> Activity.lens.category .~ .backing,
        .template |> Activity.lens.category .~ .success
      ]
      self.fetchActivitiesError = fetchActivitiesError
      self.fetchBackingResponse = fetchBackingResponse
      self.fetchBackerSavedProjectsResponse = fetchBackerSavedProjectsResponse
      self.fetchBackerBackedProjectsResponse = fetchBackerBackedProjectsResponse
      self.backingUpdate = backingUpdate
      self.fetchGraphCategoryResult = fetchGraphCategoryResult
      self.fetchGraphCategoriesResult = fetchGraphCategoriesResult
      self.fetchGraphUserResult = fetchGraphUserResult
      self.fetchGraphUserSelfResult = fetchGraphUserSelfResult
      self.fetchGraphUserEmailResult = fetchGraphUserEmailResult
      self.fetchGraphUserSetupResult = fetchGraphUserSetupResult
      self.fetchPledgedProjectsResult = fetchPledgedProjectsResult
      self.fetchProjectCommentsEnvelopeResult = fetchProjectCommentsEnvelopeResult
      self.fetchUpdateCommentsEnvelopeResult = fetchUpdateCommentsEnvelopeResult
      self.fetchCommentRepliesEnvelopeResult = fetchCommentRepliesEnvelopeResult
      self.fetchConfigResponse = fetchConfigResponse ?? .template
      self.fetchDiscoveryResponse = fetchDiscoveryResponse
      self.fetchDiscoveryError = fetchDiscoveryError
      self.fetchFriendsResponse = fetchFriendsResponse
      self.fetchFriendsError = fetchFriendsError
      self.fetchFriendStatsResponse = fetchFriendStatsResponse
      self.fetchFriendStatsError = fetchFriendStatsError
      self.fetchDraftResponse = fetchDraftResponse
      self.fetchDraftError = fetchDraftError
      self.addAttachmentResponse = addAttachmentResponse
      self.addAttachmentError = addAttachmentError
      self.removeAttachmentResponse = removeAttachmentResponse
      self.removeAttachmentError = removeAttachmentError
      self.publishUpdateError = publishUpdateError
      self.fetchManagePledgeViewBackingResult = fetchManagePledgeViewBackingResult
      self.fetchProjectAndBackingResult = fetchProjectAndBackingResult
      self.fetchRewardAddOnsSelectionViewRewardsResult = fetchRewardAddOnsSelectionViewRewardsResult
      self.fetchMessageThreadResult = fetchMessageThreadResult
      self.fetchMessageThreadsResponse = fetchMessageThreadsResponse ?? [
        .template |> MessageThread.lens.id .~ 1,
        .template |> MessageThread.lens.id .~ 2,
        .template |> MessageThread.lens.id .~ 3
      ]
      self.fetchProjectActivitiesResponse = fetchProjectActivitiesResponse ?? [
        .template,
        .template |> Activity.lens.category .~ .backing,
        .template |> Activity.lens.category .~ .commentProject
      ]
      .enumerated()
      .map(Activity.lens.id.set)
      self.fetchProjectActivitiesError = fetchProjectActivitiesError
      self.fetchProjectNotificationsResponse = fetchProjectNotificationsResponse ?? [
        .template |> ProjectNotification.lens.id .~ 1,
        .template |> ProjectNotification.lens.id .~ 2,
        .template |> ProjectNotification.lens.id .~ 3
      ]
      self.fetchProjectsResponse = fetchProjectsResponse ?? []
      self.fetchProjectsError = fetchProjectsError
      self.fetchProjectEnvelopeResult = fetchProjectResult
      self.fastFetchProjectPageResult = fastFetchProjectPage
      self.fetchProjectPamphletEnvelopeResult = fetchProjectPamphletResult
      self.fetchProjectFriendsEnvelopeResult = fetchProjectFriendsResult
      self.fetchProjectRewardsAndPledgeOverTimeDataResult = fetchProjectRewardsAndPledgeOverTimeDataResult
      self.fetchProjectRewardsEnvelopeResult = fetchProjectRewardsResult
      self.fetchProjectStatsResponse = fetchProjectStatsResponse
      self.fetchProjectStatsError = fetchProjectStatsError
      self.fetchShippingRulesResult = fetchShippingRulesResult
      self.fetchSurveyResponseResponse = fetchSurveyResponseResponse
      self.fetchSurveyResponseError = fetchSurveyResponseError
      self.fetchUnansweredSurveyResponsesResponse = fetchUnansweredSurveyResponsesResponse
      self.fetchUpdateResponse = fetchUpdateResponse
      self.fetchUserResult = fetchUserResult
      self.fetchUserSelfResponse = fetchUserSelfResponse ?? .template
      self.fetchUserSelfError = fetchUserSelfError
      self.followFriendError = followFriendError
      self.incrementVideoCompletionError = incrementVideoCompletionError
      self.incrementVideoStartError = incrementVideoStartError
      self.postCommentResult = postCommentResult
      self.loginResponse = loginResponse
      self.loginError = loginError
      self.resendCodeResponse = resendCodeResponse
      self.resendCodeError = resendCodeError
      self.resetPasswordResponse = resetPasswordResponse
      self.resetPasswordError = resetPasswordError
      self.sendEmailVerificationResult = sendEmailVerificationResult
      self.signInWithAppleResult = signInWithAppleResult
      self.signupResponse = signupResponse
      self.signupError = signupError
      self.unfollowFriendError = unfollowFriendError
      self.updateRewardReceivedResult = updateRewardReceivedResult
      self.updateBackingResult = updateBackingResult
      self.updateDraftError = updateDraftError
      self.updatePledgeResult = updatePledgeResult
      self.updateProjectNotificationResponse = updateProjectNotificationResponse
      self.updateProjectNotificationError = updateProjectNotificationError
      self.updateUserSelfError = updateUserSelfError
      self.unwatchProjectMutationResult = unwatchProjectMutationResult
      self.validateCheckoutResult = validateCheckoutResult
      self.verifyEmailResult = verifyEmailResult
      self.watchProjectMutationResult = watchProjectMutationResult
      self.tokenExchangeResponse = tokenExchangeResponse
    }
  }
#endif

