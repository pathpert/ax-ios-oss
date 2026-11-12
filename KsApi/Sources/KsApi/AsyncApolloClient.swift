@preconcurrency import Apollo
import Foundation
import GraphAPI

/// An async/await wrapper around `ApolloClientProtocol`.
/// Bridges Apollo's callback APIs onto `callbackQueue` (default `.global(qos: .userInitiated)`) for Swift Concurrency.
/// Marked `@unchecked Sendable`; queue hopping is controlled by `callbackQueue`.
/// - Negative Constraint: Do not mutate shared Apollo cache stores off `callbackQueue`.
public final class AsyncApolloClient: @unchecked Sendable {
  private let client: ApolloClientProtocol
  private let callbackQueue: DispatchQueue

  /// `callbackQueue` defaults to a background queue..
  public init(
    client: ApolloClientProtocol,
    /// using `.userInitiated` for scheduling the work the user is waiting on  more efficiently.. `.background` can sometimes get deprioritized.
    callbackQueue: DispatchQueue = .global(qos: .userInitiated)
  ) {
    self.client = client
    self.callbackQueue = callbackQueue
  }

  // MARK: - Queries

/// Executes an Apollo GraphQL query asynchronously using Swift Concurrency.
  ///
  /// Negative Constraint: Default cache policy `.fetchIgnoringCacheCompletely` bypasses Apollo's local cache; override only when stale cache reads are intended.
  public func fetch<Query: GraphQLQuery>(
    _ query: Query,
    cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely,
    contextIdentifier: UUID? = nil
  ) async throws -> GraphQLResult<Query.Data> {
    try await withCheckedThrowingContinuation { cont in
      _ = self.client.fetch(
        query: query,
        cachePolicy: cachePolicy,
        contextIdentifier: contextIdentifier,
        context: nil,
        queue: self.callbackQueue
      ) { result in
        switch result {
        case let .success(value): cont.resume(returning: value)
        case let .failure(error): cont.resume(throwing: error)
        }
      }
    }
  }

  // MARK: - Mutations

  /// Executes an Apollo GraphQL mutation asynchronously using Swift Concurrency.
  ///
  /// Negative Constraint: Non-idempotent; callers must guard against duplicate user taps.
  public func perform<Mutation: GraphQLMutation>(
    _ mutation: Mutation,
    publishResultToStore: Bool = true
  ) async throws -> GraphQLResult<Mutation.Data> {
    try await withCheckedThrowingContinuation { cont in
      _ = self.client.perform(
        mutation: mutation,
        publishResultToStore: publishResultToStore,
        context: nil,
        queue: self.callbackQueue
      ) { result in
        switch result {
        case let .success(value): cont.resume(returning: value)
        case let .failure(error): cont.resume(throwing: error)
        }
      }
    }
  }
}
