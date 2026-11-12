import Combine
import Foundation
import GraphAPI
import ReactiveSwift

extension Service {
  /// Sends legacy third-party attribution event data (Meta/GA) for the current user.
  ///
  /// - Negative constraint: `@deprecated` Use `createAttributionEvent(input:)` for new attribution tracking.
  public func triggerThirdPartyEventInput(input: TriggerThirdPartyEventInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.TriggerThirdPartyEventMutation(input: GraphAPI.TriggerThirdPartyEventInput.from(input))
    )
  }

  /// Records a server-side attribution event via GraphQL mutation.
  public func createAttributionEvent(input: GraphAPI.CreateAttributionEventInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(GraphAPI.CreateAttributionEventMutation(input: input))
  }

  /// Fetches the remote client configuration (`Config`) containing feature flags and localized pricing rules.
  public func fetchConfig() -> SignalProducer<Config, ErrorEnvelope> {
    return request(.config)
  }

  /// Fetches the next page of discovery projects from a server-provided pagination URL.
  ///
  /// - Negative constraint: Only pass `urls.api.moreProjects` from a prior `DiscoveryEnvelope`.
  public func fetchDiscovery(paginationUrl: String)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(paginationUrl)
  }

  /// Fetches paginated project discovery results filtered and sorted by `params`.
  ///
  /// - Negative constraint: Only pass `DiscoveryParams` valid for API v1 (`params.validForAPIV1() == true`).
  public func fetchDiscovery(params: DiscoveryParams)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    if !params.validForAPIV1() {
      assert(
        false,
        "Using a field which was added for GraphQL support in API V1. This param may have unexpected effects on an API V1 call."
      )
    }
    return request(.discover(params))
  }

  /// Fetches a paginated discovery response via Combine from `paginationUrl`.
  public func fetchDiscovery_combine(paginationUrl: String)
    -> AnyPublisher<DiscoveryEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(paginationUrl)
  }

  /// Fetches project discovery results matching `params` via Combine.
  public func fetchDiscovery_combine(params: DiscoveryParams)
    -> AnyPublisher<DiscoveryEnvelope, ErrorEnvelope> {
    return request(.discover(params))
  }

  /// Fetches all top-level and child Kickstarter categories via GraphQL.
  public func fetchGraphCategories()
    -> SignalProducer<RootCategoriesEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchRootCategoriesQuery())
      .flatMap(RootCategoriesEnvelope.envelopeProducer(from:))
  }

  /// Fetches a single category and its subcategories by Base64 GraphQL `id`.
  ///
  /// - Negative constraint: Pass a GraphQL Category ID string, not a raw integer ID.
  public func fetchGraphCategory(id: String)
    -> SignalProducer<CategoryEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchCategoryQuery(id: id))
      .flatMap(CategoryEnvelope.envelopeProducer(from:))
  }
}

