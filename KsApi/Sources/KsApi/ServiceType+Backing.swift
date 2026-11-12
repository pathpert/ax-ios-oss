import Combine
import Foundation
import GraphAPI
import ReactiveSwift

/// Domain-scoped protocol for creating, updating, canceling, and fetching project backings and pledged projects.
public protocol ServiceBackingType {
  /// Adds a user to a secret reward user group.
  /// - Returns: `SignalProducer` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func addUserToSecretRewardGroup(token: String, forProject param: Param) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Cancels a backing.
  /// - Note: `@deprecated` Use `CheckoutController.handleCancelBacking(payload:headers:)` in `KsApi/modules/checkout` instead.
  /// - Returns: `SignalProducer` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func cancelBacking(input: CancelBackingInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Creates a backing for a project.
  /// - Note: `@deprecated` Prefer `BackingController` in `KsApi/modules/backing` for validated, idempotent backing creation.
  /// - Returns: `SignalProducer` emitting `CreateBackingEnvelope` (containing checkout/backing status) or an `ErrorEnvelope`.
  func createBacking(input: CreateBackingInput) ->
    SignalProducer<CreateBackingEnvelope, ErrorEnvelope>

  /// Fetches the current user's backing for the project, if it exists.
  /// - Returns: `SignalProducer` emitting `Backing` or an `ErrorEnvelope`.
  func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope>

  /// Fetch `Backing` data, and the backing's `Project`, using a `Backing` ID.
  /// - Parameters:
  ///    - id: backing ID
  /// - Returns: `SignalProducer` emitting `ProjectAndBackingEnvelope` or an `ErrorEnvelope`.
  func fetchBacking(id: Int)
    -> SignalProducer<ProjectAndBackingEnvelope, ErrorEnvelope>

  /// Explicitly fetches a `Backing`, with suitable information for loading the Manage Pledge page.
  /// `refundedAmount` is included in the `paymentIncrements`.
  /// - Parameters:
  ///    - id: backing ID
  /// - Returns: `SignalProducer` emitting `Backing` or an `ErrorEnvelope`.
  func fetchBackingForManagePledge(id: Int)
    -> SignalProducer<Backing, ErrorEnvelope>

  /// Mark reward received.
  /// - Returns: `SignalProducer` emitting the updated `Backing` or an `ErrorEnvelope`.
  func backingUpdate(forProject project: Project, forUser user: User, received: Bool)
    -> SignalProducer<Backing, ErrorEnvelope>

  /// Mark reward as received or unreceived. Return Bool is true if success.
  /// - Returns: `AnyPublisher` emitting `true` on success or an `ErrorEnvelope`.
  func updateRewardReceived(backingId: String, rewardReceived: Bool)
    -> AnyPublisher<Bool, ErrorEnvelope>

  /// Updates an existing backing.
  /// - Returns: `SignalProducer` emitting `UpdateBackingEnvelope` or an `ErrorEnvelope`.
  func updateBacking(input: UpdateBackingInput) -> SignalProducer<UpdateBackingEnvelope, ErrorEnvelope>

  /// Fetches saved/watched projects for the current backer.
  /// - Returns: `SignalProducer` emitting `GraphAPI.FetchMySavedProjectsQuery.Data` or an `ErrorEnvelope`.
  func fetchSavedProjects(cursor: String?, limit: Int?)
    -> SignalProducer<GraphAPI.FetchMySavedProjectsQuery.Data, ErrorEnvelope>

  /// Fetches backed projects for the current backer.
  /// - Returns: `SignalProducer` emitting `GraphAPI.FetchMyBackedProjectsQuery.Data` or an `ErrorEnvelope`.
  func fetchBackedProjects(cursor: String?, limit: Int?)
    -> SignalProducer<GraphAPI.FetchMyBackedProjectsQuery.Data, ErrorEnvelope>

  /// Confirms a backer's address for a given backing. Returns a success boolean.
  /// - Returns: `AnyPublisher` emitting `Bool` indicating confirmation status or an `ErrorEnvelope`.
  func confirmBackingAddress(backingId: String, addressId: String) -> AnyPublisher<Bool, ErrorEnvelope>

  /// Fetch data for the pledged projects overview.
  /// - Returns: `AnyPublisher` emitting `GraphAPI.FetchPledgedProjectsQuery.Data` or an `ErrorEnvelope`.
  func fetchPledgedProjects(
    tierTypes: [PledgeProjectsOverviewSort],
    cursor: String?,
    limit: Int?
  ) -> AnyPublisher<GraphAPI.FetchPledgedProjectsQuery.Data, ErrorEnvelope>
}

