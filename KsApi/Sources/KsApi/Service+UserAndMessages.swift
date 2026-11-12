import Combine
import Foundation
import GraphAPI
import ReactiveSwift

extension Service {
  /// Updates the signed-in user's account email address.
  ///
  /// - Negative constraint: Requires current password verification; do not omit `currentPassword`.
  public func changeEmail(input: ChangeEmailInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.UpdateUserAccountMutation(input: GraphAPI.UpdateUserAccountInput.from(input))
    )
  }

  /// Changes the signed-in user's account password.
  ///
  /// - Negative constraint: Do not reuse the existing password or bypass confirmation matching.
  public func changePassword(input: ChangePasswordInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.UpdateUserAccountMutation(input: GraphAPI.UpdateUserAccountInput.from(input))
    )
  }

  /// Creates an initial password for an account that signed up via third-party OAuth.
  public func createPassword(input: CreatePasswordInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.UpdateUserAccountMutation(input: GraphAPI.UpdateUserAccountInput.from(input))
    )
  }

  /// Resets the signed-in user's unseen activity badge counter via GraphQL mutation.
  public func clearUserUnseenActivity(input _: EmptyInput)
    -> SignalProducer<ClearUserUnseenActivityEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .ClearUserUnseenActivityMutation(input: GraphAPI.ClearUserUnseenActivityInput())
      )
      .flatMap(ClearUserUnseenActivityEnvelope.producer(from:))
  }

  /// Updates the signed-in user's preferred display currency.
  ///
  /// - Negative constraint: Use supported ISO 4217 uppercase currency codes, not currency symbols.
  public func changeCurrency(input: ChangeCurrencyInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.UpdateUserProfileMutation(input: GraphAPI.UpdateUserProfileInput.from(input))
    )
  }

  /// Fetches recent user activity feed entries across all supported `Activity.Category` cases.
  public func fetchActivities(count: Int?) -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    let categories: [Activity.Category] = [
      .backing, .cancellation, .failure, .follow, .launch, .shipped, .success, .update
    ]
    return request(.activities(categories: categories, count: count))
  }

  /// Fetches a paginated slice of the activity feed using a server-provided pagination URL.
  public func fetchActivities(paginationUrl: String)
    -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(paginationUrl)
  }

  /// Fetches the first page of Kickstarter friends for the authenticated user.
  public func fetchFriends() -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
    return request(.friends)
  }

  /// Fetches subsequent pages of friends using a server-provided pagination URL.
  public func fetchFriends(paginationUrl: String)
    -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(paginationUrl)
  }

  /// Fetches aggregate friend counts and discovery stats for the authenticated user.
  public func fetchFriendStats() -> SignalProducer<FriendStatsEnvelope, ErrorEnvelope> {
    return request(.friendStats)
  }

  /// Fetches the authenticated user's GraphQL profile, optionally including saved payment cards.
  public func fetchGraphUser(withStoredCards: Bool)
    -> SignalProducer<UserEnvelope<GraphUser>, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUserQuery(withStoredCards: withStoredCards))
      .flatMap(UserEnvelope<GraphUser>.envelopeProducer(from:))
  }

  /// Fetches the authenticated user's email address via GraphQL (`SignalProducer`).
  public func fetchGraphUserEmail()
    -> SignalProducer<UserEnvelope<GraphUserEmail>, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUserEmailQuery())
      .flatMap(UserEnvelope<GraphUserEmail>.envelopeProducer(from:))
  }

  /// Fetches the authenticated user's email address via GraphQL (`AnyPublisher`).
  public func fetchGraphUserEmailCombine()
    -> AnyPublisher<UserEnvelope<GraphUserEmail>, ErrorEnvelope> {
    GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUserEmailQuery())
      .mapFetchResults { (data: GraphAPI.FetchUserEmailQuery.Data) -> UserEnvelope<GraphUserEmail>? in
        UserEnvelope<GraphUserEmail>.userEnvelope(from: data)
      }
  }

  /// Fetches the user's account setup requirements (e.g., email/password completeness) via GraphQL.
  public func fetchGraphUserSetup()
    -> SignalProducer<UserEnvelope<GraphUserSetup>, ErrorEnvelope> {
    GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUserSetupQuery())
      .flatMap(UserEnvelope<GraphUserSetup>.envelopeProducer(from:))
  }

  /// Fetches account setup completeness flags via GraphQL (`AnyPublisher`).
  public func fetchGraphUserSetupCombine()
    -> AnyPublisher<UserEnvelope<GraphUserSetup>, ErrorEnvelope> {
    GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUserSetupQuery())
      .mapFetchResults { (data: GraphAPI.FetchUserSetupQuery.Data) -> UserEnvelope<GraphUserSetup>? in
        UserEnvelope<GraphUserSetup>.userEnvelope(from: data)
      }
  }

  /// Fetches the full REST-compatible `User` model for the current user via GraphQL.
  public func fetchGraphUserSelf()
    -> SignalProducer<UserEnvelope<User>, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUserQuery(withStoredCards: false))
      .flatMap(UserEnvelope<User>.envelopeProducer(from:))
  }

  /// Fetches per-project notification preferences for the authenticated user.
  public func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope> {
    return request(.projectNotifications)
  }

  /// Fetches a single backer survey response by numeric `surveyResponseId`.
  public func fetchSurveyResponse(surveyResponseId id: Int) -> SignalProducer<SurveyResponse, ErrorEnvelope> {
    return request(.surveyResponse(surveyResponseId: id))
  }

  /// Fetches the authenticated user's REST profile.
  public func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    return request(.userSelf)
  }

  /// Fetches the authenticated user's REST profile using an explicit OAuth token (`AnyPublisher`).
  ///
  /// - Negative constraint: Do not pass empty OAuth tokens; intended for pre-login token verification.
  public func fetchUserSelf_combine(withOAuthToken token: String) -> AnyPublisher<User, ErrorEnvelope> {
    return requestWithAuthentication(.userSelf, oauthToken: token)
  }

  /// Fetches a public user profile by numeric `userId`.
  public func fetchUser(userId: Int) -> SignalProducer<User, ErrorEnvelope> {
    return request(.user(userId: userId))
  }

  /// Fetches the latest profile data for `user`.
  public func fetchUser(_ user: User) -> SignalProducer<User, ErrorEnvelope> {
    return self.fetchUser(userId: user.id)
  }

  /// Fetches all pending unanswered backer surveys for the authenticated user.
  public func fetchUnansweredSurveyResponses() -> SignalProducer<[SurveyResponse], ErrorEnvelope> {
    return request(.unansweredSurveyResponses)
  }

  /// Follows all suggested Facebook friends on Kickstarter.
  public func followAllFriends() -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return request(.followAllFriends)
  }

  /// Follows a Kickstarter user by numeric `userId`.
  ///
  /// - Negative constraint: Do not pass `0`, negative IDs, or the signed-in user's own ID.
  public func followFriend(userId id: Int) -> SignalProducer<User, ErrorEnvelope> {
    return request(.followFriend(userId: id))
  }

  /// Registers a hex-encoded APNs push notification device token for the current user.
  ///
  /// - Negative constraint: Strip angle brackets and whitespace from raw `Data` descriptions before calling.
  public func register(pushToken: String) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return request(.registerPushToken(pushToken))
  }

  /// Unfollows a Kickstarter user by numeric `userId`.
  public func unfollowFriend(userId id: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return request(.unfollowFriend(userId: id))
  }

  /// Persists updated email and push notification toggles for a backed project.
  public func updateProjectNotification(_ notification: ProjectNotification)
    -> SignalProducer<ProjectNotification, ErrorEnvelope> {
    return request(.updateProjectNotification(notification: notification))
  }

  /// Updates mutable profile and preference fields on the authenticated user.
  public func updateUserSelf(_ user: User) -> SignalProducer<User, ErrorEnvelope> {
    return request(.updateUserSelf(user))
  }

  /// Blocks another Kickstarter user via GraphQL mutation.
  ///
  /// - Negative constraint: Pass a valid Base64 `User-<id>` target in `input`; requires authentication.
  public func blockUser(input: BlockUserInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.BlockUserMutation(input: GraphAPI.BlockUserInput.from(input))
    )
  }
}
