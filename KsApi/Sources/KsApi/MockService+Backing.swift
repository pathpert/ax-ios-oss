#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

  extension MockService {
    /// Mock GraphQL call returning `self.addUserToSecretRewardGroup` result.
    ///
    /// Negative Constraint: DEBUG test double only; never compiled into release builds.
    public func addUserToSecretRewardGroup(token: String, forProject param: Param)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let input = GraphAPI.AddUserToSecretRewardGroupInput.from(token: token, forProject: param)

      let mutation = GraphAPI.AddUserToSecretRewardGroupMutation(input: input)
      return client.performWithResult(mutation: mutation, result: self.addUserToSecretRewardGroup)
    }

    /// Mock GraphQL mutation returning `self.cancelBackingResult`.
    ///
    /// Negative Constraint: DEBUG test double only; does not mutate server backing state.
    public func cancelBacking(input: CancelBackingInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .CancelBackingMutation(input: GraphAPI.CancelBackingInput(id: input.backingId))

      return client.performWithResult(mutation: mutation, result: self.cancelBackingResult)
    }

    internal func createBacking(input: CreateBackingInput)
      -> SignalProducer<CreateBackingEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI.CreateBackingMutation(input: GraphAPI.CreateBackingInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.createBackingResult)
    }

    func fetchBacking(forProject project: Project, forUser user: User)
      -> SignalProducer<Backing, ErrorEnvelope> {
      return SignalProducer(
        value: self.fetchBackingResponse
          |> Backing.lens.backer .~ user
          |> Backing.lens.backerId .~ user.id
          |> Backing.lens.projectId .~ project.id
      )
    }

    func backingUpdate(forProject project: Project, forUser user: User, received: Bool)
      -> SignalProducer<Backing, ErrorEnvelope> {
      return SignalProducer(
        value: self.fetchBackingResponse
          |> Backing.lens.backer .~ user
          |> Backing.lens.backerId .~ user.id
          |> Backing.lens.projectId .~ project.id
          |> Backing.lens.backerCompleted .~ received
      )
    }

    func updateRewardReceived(
      backingId _: String,
      rewardReceived _: Bool
    ) -> AnyPublisher<Bool, ErrorEnvelope> {
      guard let updateRewardReceivedResponse = self.updateRewardReceivedResult else {
        return Fail(outputType: Bool.self, failure: ErrorEnvelope.couldNotParseErrorEnvelopeJSON)
          .eraseToAnyPublisher()
      }

      switch updateRewardReceivedResponse {
      case let .success(rewardReceivedValue):
        return Just(rewardReceivedValue).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()

      case let .failure(envelope):
        return Fail(outputType: Bool.self, failure: envelope).eraseToAnyPublisher()
      }
    }

    func fetchBacking(id _: Int)
      -> SignalProducer<ProjectAndBackingEnvelope, ErrorEnvelope> {
      return producer(for: self.fetchProjectAndBackingResult)
    }

    func fetchBackingForManagePledge(id _: Int)
      -> SignalProducer<Backing, ErrorEnvelope> {
      return producer(for: self.fetchManagePledgeViewBackingResult)
    }

    /// Mock query returning `self.fetchBackerSavedProjectsResponse` if stubbed, or `.empty`.
    public func fetchSavedProjects(
      cursor _: String? = nil,
      limit _: Int? = nil
    ) -> SignalProducer<GraphAPI.FetchMySavedProjectsQuery.Data, ErrorEnvelope> {
      guard let result = self.fetchBackerSavedProjectsResponse else {
        return .empty
      }
      return SignalProducer(value: result)
    }

    /// Mock query returning `self.fetchBackerBackedProjectsResponse` if stubbed, or `.empty`.
    public func fetchBackedProjects(
      cursor _: String? = nil,
      limit _: Int? = nil
    ) -> SignalProducer<
      GraphAPI.FetchMyBackedProjectsQuery.Data,
      ErrorEnvelope
    > {
      guard let result = self.fetchBackerBackedProjectsResponse else {
        return .empty
      }
      return SignalProducer(value: result)
    }

    internal func updateBacking(input: UpdateBackingInput)
      -> SignalProducer<UpdateBackingEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutationUpdateBacking = GraphAPI
        .UpdateBackingMutation(input: GraphAPI.UpdateBackingInput.from(input))

      return client
        .performWithResult(mutation: mutationUpdateBacking, result: self.updateBackingResult)
    }

    func confirmBackingAddress(
      backingId _: String,
      addressId _: String
    ) -> AnyPublisher<Bool, ErrorEnvelope> {
      guard let confirmResponse = self.confirmBackingAddressResult else {
        return Fail(outputType: Bool.self, failure: ErrorEnvelope.couldNotParseErrorEnvelopeJSON)
          .eraseToAnyPublisher()
      }

      switch confirmResponse {
      case let .success(didMutationSucceed):
        return Just(didMutationSucceed).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()

      case let .failure(envelope):
        return Fail(outputType: Bool.self, failure: envelope).eraseToAnyPublisher()
      }
    }

    func fetchPledgedProjects(
      tierTypes _: [PledgeProjectsOverviewSort],
      cursor _: String?,
      limit _: Int?
    ) -> AnyPublisher<GraphAPI.FetchPledgedProjectsQuery.Data, ErrorEnvelope> {
      guard let response = self.fetchPledgedProjectsResult else {
        return Fail(
          outputType: GraphAPI.FetchPledgedProjectsQuery.Data.self,
          failure: ErrorEnvelope.couldNotParseErrorEnvelopeJSON
        )
        .eraseToAnyPublisher()
      }

      switch response {
      case let .success(pledgedProjectsData):
        return Just(pledgedProjectsData).setFailureType(to: ErrorEnvelope.self).delay(
          for: 0.01,
          scheduler: DispatchQueue.main
        ).eraseToAnyPublisher()

      case let .failure(envelope):
        return Fail(outputType: GraphAPI.FetchPledgedProjectsQuery.Data.self, failure: envelope)
          .eraseToAnyPublisher()
      }
    }
  }
#endif

