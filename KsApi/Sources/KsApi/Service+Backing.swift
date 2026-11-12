import Combine
import Foundation
import GraphAPI
import ReactiveSwift

extension Service {
  /// Grants the authenticated viewer access to a secret reward tier using an invitation `token`.
  public func addUserToSecretRewardGroup(token: String, forProject param: Param)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    let input = GraphAPI.AddUserToSecretRewardGroupInput.from(token: token, forProject: param)
    return self.performEmptyMutation(GraphAPI.AddUserToSecretRewardGroupMutation(input: input))
  }

  /// Cancels an active backing via GraphQL; pass an explicit `IdempotencyKey` via `ServiceType` wrapper in agent code.
  public func cancelBacking(input: CancelBackingInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.CancelBackingMutation(input: GraphAPI.CancelBackingInput(id: input.backingId))
    )
  }

  /// Creates a new backing via GraphQL; prefer `createBacking(input:idempotencyKey:)` or `BackingController` for idempotency enforcement.
  public func createBacking(input: CreateBackingInput) ->
    SignalProducer<CreateBackingEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: GraphAPI.CreateBackingMutation(input: GraphAPI.CreateBackingInput.from(input)))
      .flatMap(CreateBackingEnvelope.producer(from:))
  }

  // FIXME: Should be able to convert this to Apollo as it uses /v1 but check its' use cases first.
  /// Fetches a user's `Backing` for a project via the v1 REST endpoint.
  public func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope> {
    return request(.backing(projectId: project.id, backerId: user.id))
  }

  /// Fetches both `Project` and `Backing` details for a numeric backing `id` via GraphQL.
  public func fetchBacking(id: Int)
    -> SignalProducer<ProjectAndBackingEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(
        query: GraphAPI.FetchBackingQuery(id: "\(id)")
      )
      .flatMap(ProjectAndBackingEnvelope.envelopeProducer(from:))
  }

  /// Fetches backing details including `refundedAmount` in the `paymentIncrements`.
  ///
  /// Use this method exclusively in flows that require displaying refund information,
  /// such as the `ManagePledge` flow where the "Payment Scheduled" component
  /// needs to reflect refunded increments.
  ///
  /// Fetching `refundedAmount` adds significant load to the backend.
  /// Per the Payments team recommendation, this field should only be queried
  /// when absolutely necessary.
  ///
  /// - Parameters:
  ///   - id: The backing ID.
  public func fetchBackingForManagePledge(id: Int)
    -> SignalProducer<Backing, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(
        query: GraphAPI.FetchBackingWithIncrementsRefundedQuery(id: "\(id)")
      )
      .flatMap(Backing.producer(from:))
  }

  /// Fetches a paginated page of projects backed by the authenticated user.
  public func fetchBackedProjects(
    cursor: String? = nil,
    limit: Int? = nil
  ) -> SignalProducer<FetchMyBackedProjectsQuery.Data, ErrorEnvelope> {
    let query = GraphAPI.FetchMyBackedProjectsQuery(
      first: GraphQLNullable.someOrNil(limit),
      after: GraphQLNullable.someOrNil(cursor)
    )

    return GraphQL.shared.client.fetch(query: query)
  }

  /// Fetches a paginated page of projects saved/watched by the authenticated user.
  public func fetchSavedProjects(
    cursor: String? = nil,
    limit: Int? = nil
  ) -> SignalProducer<FetchMySavedProjectsQuery.Data, ErrorEnvelope> {
    let query = GraphAPI.FetchMySavedProjectsQuery(
      first: GraphQLNullable.someOrNil(limit),
      after: GraphQLNullable.someOrNil(cursor)
    )

    return GraphQL.shared.client.fetch(query: query)
  }

  /// Marks whether the backer has received fulfillment rewards via the legacy v1 endpoint.
  public func backingUpdate(forProject project: Project, forUser user: User, received: Bool) ->
    SignalProducer<Backing, ErrorEnvelope> {
    return request(.backingUpdate(projectId: project.id, backerId: user.id, received: received))
  }

  /// Marks reward fulfillment received status via GraphQL mutation and returns the updated state.
  public func updateRewardReceived(
    backingId: String,
    rewardReceived: Bool
  ) -> AnyPublisher<Bool, ErrorEnvelope> {
    let input = GraphAPI.UpdateBackerCompletedInput(backerCompleted: rewardReceived, id: backingId)
    let mutation = GraphAPI.UpdateBackerCompletedMutation(input: input)
    return GraphQL.shared.client
      .perform(mutation: mutation)
      .map { data -> Bool in
        // Verify success by confirming response value is equal to input.
        data.updateBackerCompleted?.backing?.backerCompleted == rewardReceived
      }
      .eraseToAnyPublisher()
  }

  /// Updates an existing backing amount, rewards, or payment method via GraphQL.
  public func updateBacking(input: UpdateBackingInput)
    -> SignalProducer<UpdateBackingEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: GraphAPI.UpdateBackingMutation(input: GraphAPI.UpdateBackingInput.from(input)))
      .flatMap(UpdateBackingEnvelope.producer(from:))
  }

  /// Confirms the shipping address linked to a backing via GraphQL mutation.
  public func confirmBackingAddress(
    backingId: String,
    addressId: String
  ) -> AnyPublisher<Bool, ErrorEnvelope> {
    let input = GraphAPI.CreateOrUpdateBackingAddressInput(addressId: addressId, backingId: backingId)
    let mutation = GraphAPI.CreateOrUpdateBackingAddressMutation(input: input)
    return GraphQL.shared.client
      .perform(mutation: mutation)
      .map { data in
        data.createOrUpdateBackingAddress?.success ?? false
      }
      .eraseToAnyPublisher()
  }

  /// Fetches Pledged Projects Overview entries filtered by `tierTypes` via GraphQL Combine publisher.
  public func fetchPledgedProjects(
    tierTypes: [PledgeProjectsOverviewSort],
    cursor: String? = nil,
    limit: Int? = nil
  ) -> AnyPublisher<GraphAPI.FetchPledgedProjectsQuery.Data, ErrorEnvelope> {
    GraphQL.shared.client
      .fetch(query: GraphAPI.FetchPledgedProjectsQuery(
        first: GraphQLNullable.someOrNil(limit),
        after: GraphQLNullable.someOrNil(cursor),
        tierTypes: GraphQLNullable.some(tierTypes.map { GraphQLEnum($0) })
      ))
      .eraseToAnyPublisher()
  }
}

