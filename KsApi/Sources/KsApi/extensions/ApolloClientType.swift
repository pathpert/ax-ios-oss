import ApolloAPI
import ReactiveSwift

/// Legacy ReactiveSwift abstraction over Apollo GraphQL `fetch` and `perform` operations.
/// - Negative Constraint: Prefer `AsyncApolloClient` or `ServiceType` async APIs for new call sites.
public protocol ApolloClientType {
  /// Executes a GraphQL query and emits the decoded `Query.Data` payload.
  func fetch<Query: GraphQLQuery>(query: Query) -> SignalProducer<Query.Data, ErrorEnvelope>
  /// Executes a GraphQL mutation and emits the decoded `Mutation.Data` payload.
  func perform<Mutation: GraphQLMutation>(mutation: Mutation) -> SignalProducer<Mutation.Data, ErrorEnvelope>
}
