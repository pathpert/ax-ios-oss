import Apollo
import ApolloAPI
import Combine
import Foundation
import ReactiveSwift

class MockGraphQLClient: ApolloClientType {
  // MARK: - Base Properties

  var client: ApolloClient {
    let url = URL(string: "https://kickstarter.com")!

    return ApolloClient(url: url)
  }

  static let shared = MockGraphQLClient()

  // MARK: Public functions

  /// Placeholder implementation because protocol definition used in `Service`
  public func fetch<Query: GraphQLQuery>(query _: Query) -> SignalProducer<Query.Data, ErrorEnvelope> {
    return SignalProducer<Query.Data, ErrorEnvelope>.never
  }

  /// Placeholder implementation because protocol definition used in `Service`
  public func perform<Mutation: GraphQLMutation>(
    mutation _: Mutation
  ) -> SignalProducer<Mutation.Data, ErrorEnvelope> {
    return SignalProducer<Mutation.Data, ErrorEnvelope>.never
  }
}

/// Implementation of optional `fetch` and `perform` with `result` useful for mocking data.
extension ApolloClientType {
  /// Returns a ReactiveSwift `SignalProducer` emitting `result` for a mocked GraphQL query.
  public func fetchWithResult<Query: GraphQLQuery, Data: Decodable>(
    query _: Query,
    result: Result<Data, ErrorEnvelope>?
  ) -> SignalProducer<Data, ErrorEnvelope> {
    producer(for: result)
  }

  /// Returns a ReactiveSwift `SignalProducer` emitting `result` for a mocked GraphQL mutation.
  public func performWithResult<Mutation: GraphQLMutation, Data: Decodable>(
    mutation _: Mutation,
    result: Result<Data, ErrorEnvelope>?
  ) -> SignalProducer<Data, ErrorEnvelope> {
    producer(for: result)
  }

  /// Returns a Combine `AnyPublisher` emitting `result` for a mocked GraphQL query.
  public func fetchWithResult<Query: GraphQLQuery, Data: Decodable>(
    query _: Query,
    result: Result<Data, ErrorEnvelope>?
  ) -> AnyPublisher<Data, ErrorEnvelope> {
    return producer(for: result)
  }

  /// Returns a Combine `AnyPublisher` emitting `result` for a mocked GraphQL mutation.
  public func performWithResult<Mutation: GraphQLMutation, Data: Decodable>(
    mutation _: Mutation,
    result: Result<Data, ErrorEnvelope>?
  ) -> AnyPublisher<Data, ErrorEnvelope> {
    return producer(for: result)
  }

  /// Synchronously extracts the first `.success` value from a `SignalProducer`, or `nil` on failure/empty.
  ///
  /// Negative Constraint: Test helper only; never block main queues with `.first()` on real network producers.
  public func data<Data: Decodable>(from producer: SignalProducer<Data, ErrorEnvelope>) -> Data? {
    switch producer.first() {
    case let .success(data):
      return data
    default:
      return nil
    }
  }

  /// Synchronously extracts the first `.failure` `ErrorEnvelope` from a `SignalProducer`, or `nil` on success/empty.
  ///
  /// Negative Constraint: Test helper only; never call synchronously on production UI threads.
  public func error<Data: Decodable>(from producer: SignalProducer<Data, ErrorEnvelope>)
    -> ErrorEnvelope? {
    switch producer.first() {
    case let .failure(errorEnvelope):
      return errorEnvelope
    default:
      return nil
    }
  }
}

internal func producer<T, E>(for property: Result<T, E>?) -> SignalProducer<T, E> {
  guard let result = property else { return .empty }
  switch result {
  case let .success(value): return .init(value: value)
  case let .failure(error): return .init(error: error)
  }
}

private func producer<T, E>(for property: Result<T, E>?) -> AnyPublisher<T, E> {
  switch property {
  case let .success(data): return CurrentValueSubject(data).eraseToAnyPublisher()
  case let .failure(error): return Fail(error: error).eraseToAnyPublisher()
  case .none: return Empty(completeImmediately: false).eraseToAnyPublisher()
  }
}

internal extension Result {
  var value: Success? {
    switch self {
    case let .success(value): return value
    case .failure: return nil
    }
  }

  var error: Failure? {
    switch self {
    case .success: return nil
    case let .failure(error): return error
    }
  }
}
