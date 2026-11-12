#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

  extension MockService {
    /// Simulates blocking a user via the mock Apollo client in `DEBUG` test builds.
    /// - Negative Constraint: Never available in Release builds.
    public func blockUser(input: BlockUserInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .BlockUserMutation(input: GraphAPI.BlockUserInput(blockUserId: input.blockUserId))

      return client.performWithResult(mutation: mutation, result: self.blockUserResult)
    }

    internal func changeEmail(input: ChangeEmailInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .UpdateUserAccountMutation(input: GraphAPI.UpdateUserAccountInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.changeEmailResult)
    }

    internal func changePassword(input: ChangePasswordInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .UpdateUserAccountMutation(input: GraphAPI.UpdateUserAccountInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.changePasswordResult)
    }

    internal func createPassword(input: CreatePasswordInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .UpdateUserAccountMutation(input: GraphAPI.UpdateUserAccountInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.createPasswordResult)
    }

    internal func changeCurrency(input: ChangeCurrencyInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .UpdateUserProfileMutation(input: GraphAPI.UpdateUserProfileInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.changeCurrencyResult)
    }

    internal func clearUserUnseenActivity(input _: EmptyInput)
      -> SignalProducer<ClearUserUnseenActivityEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .ClearUserUnseenActivityMutation(input: GraphAPI.ClearUserUnseenActivityInput())

      return client.performWithResult(mutation: mutation, result: self.clearUserUnseenActivityResult)
    }

    internal func fetchFriends() -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
      if let response = fetchFriendsResponse {
        return SignalProducer(value: response)
      } else if let error = fetchFriendsError {
        return SignalProducer(error: error)
      }

      return SignalProducer(value: .template)
    }

    internal func fetchFriends(paginationUrl _: String)
      -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
      return self.fetchFriends()
    }

    internal func fetchFriendStats() -> SignalProducer<FriendStatsEnvelope, ErrorEnvelope> {
      if let response = fetchFriendStatsResponse {
        return SignalProducer(value: response)
      } else if let error = fetchFriendStatsError {
        return SignalProducer(error: error)
      }
      return SignalProducer(value: .template)
    }

    internal func followAllFriends() -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
      return SignalProducer(value: VoidEnvelope())
    }

    internal func followFriend(userId id: Int) -> SignalProducer<User, ErrorEnvelope> {
      if let error = followFriendError {
        return SignalProducer(error: error)
      }

      return SignalProducer(
        value:
        User.template
          |> \.id .~ id
          |> \.isFriend .~ true
      )
    }

    internal func unfollowFriend(userId _: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
      if let error = unfollowFriendError {
        return SignalProducer(error: error)
      }

      return SignalProducer(value: VoidEnvelope())
    }

    internal func fetchGraphUserSelf()
      -> SignalProducer<UserEnvelope<User>, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchGraphUserQuery = GraphAPI.FetchUserQuery(withStoredCards: false)

      return client.fetchWithResult(query: fetchGraphUserQuery, result: self.fetchGraphUserSelfResult)
    }

    internal func fetchGraphUser(withStoredCards: Bool)
      -> SignalProducer<UserEnvelope<GraphUser>, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchGraphUserQuery = GraphAPI.FetchUserQuery(withStoredCards: withStoredCards)

      return client.fetchWithResult(query: fetchGraphUserQuery, result: self.fetchGraphUserResult)
    }

    internal func fetchGraphUserEmail() -> SignalProducer<UserEnvelope<GraphUserEmail>, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchGraphUserEmailQuery = GraphAPI.FetchUserEmailQuery()

      return client.fetchWithResult(query: fetchGraphUserEmailQuery, result: self.fetchGraphUserEmailResult)
    }

    func fetchGraphUserEmailCombine() -> AnyPublisher<UserEnvelope<GraphUserEmail>, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
      }

      let fetchGraphUserEmailQuery = GraphAPI.FetchUserEmailQuery()
      return client.fetchWithResult(query: fetchGraphUserEmailQuery, result: self.fetchGraphUserEmailResult)
    }

    internal func fetchGraphUserSetup() -> SignalProducer<UserEnvelope<GraphUserSetup>, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchGraphUserSetupQuery = GraphAPI.FetchUserSetupQuery()

      return client.fetchWithResult(query: fetchGraphUserSetupQuery, result: self.fetchGraphUserSetupResult)
    }

    func fetchGraphUserSetupCombine() -> AnyPublisher<UserEnvelope<GraphUserSetup>, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
      }

      let fetchGraphUserSetupQuery = GraphAPI.FetchUserSetupQuery()
      return client.fetchWithResult(query: fetchGraphUserSetupQuery, result: self.fetchGraphUserSetupResult)
    }

    internal func fetchActivities(count _: Int?) -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
      if let error = fetchActivitiesError {
        return SignalProducer(error: error)
      } else if let activities = fetchActivitiesResponse {
        return SignalProducer(
          value: ActivityEnvelope(
            activities: activities,
            urls: ActivityEnvelope.UrlsEnvelope(
              api: ActivityEnvelope.UrlsEnvelope.ApiEnvelope(
                moreActivities: "http://\(Secrets.Api.Endpoint.production)/gimme/more"
              )
            )
          )
        )
      }
      return .empty
    }

    internal func fetchActivities(paginationUrl _: String)
      -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
      return self.fetchActivities(count: nil)
    }

    internal func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope> {
      return SignalProducer(value: self.fetchProjectNotificationsResponse)
    }

    internal func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
      if let error = fetchUserSelfError {
        return SignalProducer(error: error)
      }

      return SignalProducer(value: self.fetchUserSelfResponse ?? .template)
    }

    func fetchUserSelf_combine(withOAuthToken _: String) -> AnyPublisher<User, ErrorEnvelope> {
      if let error = fetchUserSelfError {
        return Fail(outputType: User.self, failure: error).eraseToAnyPublisher()
      }

      return Just(self.fetchUserSelfResponse ?? .template).setFailureType(to: ErrorEnvelope.self)
        .eraseToAnyPublisher()
    }

    internal func fetchSurveyResponse(surveyResponseId id: Int)
      -> SignalProducer<SurveyResponse, ErrorEnvelope> {
      if let response = fetchSurveyResponseResponse {
        return SignalProducer(value: response)
      } else if let error = fetchSurveyResponseError {
        return SignalProducer(error: error)
      }
      return SignalProducer(value: .template |> SurveyResponse.lens.id .~ id)
    }

    internal func fetchUnansweredSurveyResponses() -> SignalProducer<[SurveyResponse], ErrorEnvelope> {
      return SignalProducer(value: self.fetchUnansweredSurveyResponsesResponse)
    }

    internal func fetchUser(userId _: Int) -> SignalProducer<User, ErrorEnvelope> {
      return producer(for: self.fetchUserResult)
    }

    internal func fetchUser(_: User) -> SignalProducer<User, ErrorEnvelope> {
      return producer(for: self.fetchUserResult)
    }

    func register(pushToken _: String) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
      return SignalProducer(value: VoidEnvelope())
    }

    internal func updateProjectNotification(_ notification: ProjectNotification)
      -> SignalProducer<ProjectNotification, ErrorEnvelope> {
      if let error = updateProjectNotificationError {
        return SignalProducer(error: error)
      }
      return SignalProducer(value: notification)
    }

    internal func updateUserSelf(_ user: User) -> SignalProducer<User, ErrorEnvelope> {
      if let error = updateUserSelfError {
        return SignalProducer(error: error)
      }
      return SignalProducer(value: user)
    }
  }
#endif

