#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

  extension MockService {
    /// Simulates logging an attribution event via the mock Apollo client in `DEBUG` test builds.
    /// - Negative Constraint: Never available in Release builds.
    public func createAttributionEvent(input: GraphAPI.CreateAttributionEventInput) ->
      SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI.CreateAttributionEventMutation(input: input)

      return client.performWithResult(mutation: mutation, result: self.createAttributionEventResult)
    }

    internal func triggerThirdPartyEventInput(input: TriggerThirdPartyEventInput) -> ReactiveSwift
      .SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .TriggerThirdPartyEventMutation(input: GraphAPI.TriggerThirdPartyEventInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.triggerThirdPartyEventResult)
    }

    internal func fetchConfig() -> SignalProducer<Config, ErrorEnvelope> {
      guard let config = self.fetchConfigResponse else { return .empty }
      return SignalProducer(value: config)
    }

    internal func fetchGraphCategories()
      -> SignalProducer<RootCategoriesEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchGraphCategoriesQuery = GraphAPI.FetchRootCategoriesQuery()

      return client.fetchWithResult(query: fetchGraphCategoriesQuery, result: self.fetchGraphCategoriesResult)
    }

    internal func fetchGraphCategory(id: String)
      -> SignalProducer<CategoryEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchGraphCategoryQuery = GraphAPI.FetchCategoryQuery(id: id)

      return client.fetchWithResult(query: fetchGraphCategoryQuery, result: self.fetchGraphCategoryResult)
    }

    internal func fetchDiscovery(paginationUrl: String)
      -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
      if let error = fetchDiscoveryError {
        return SignalProducer(error: error)
      }

      let project: (Int) -> Project = {
        .template |> Project.lens.id .~ ($0 + paginationUrl.hashValue)
      }
      let envelope = self.fetchDiscoveryResponse ?? (
        .template
          |> DiscoveryEnvelope.lens.projects .~ (1...4).map(project)
          |> DiscoveryEnvelope.lens.urls.api.moreProjects .~ (paginationUrl + "+1")
      )

      return SignalProducer(value: envelope)
    }

    internal func fetchDiscovery(params: DiscoveryParams)
      -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
      if let error = fetchDiscoveryError {
        return SignalProducer(error: error)
      }

      let project: (Int) -> Project = {
        .template |> Project.lens.id %~ const($0 + params.hashValue)
      }
      let envelope = self.fetchDiscoveryResponse ?? (
        .template
          |> DiscoveryEnvelope.lens.projects .~ (1...4).map(project)
      )

      return SignalProducer(value: envelope)
    }

    func fetchDiscovery_combine(params _: DiscoveryParams) -> AnyPublisher<DiscoveryEnvelope, ErrorEnvelope> {
      return Empty(completeImmediately: false).eraseToAnyPublisher()
    }

    func fetchDiscovery_combine(paginationUrl _: String) -> AnyPublisher<DiscoveryEnvelope, ErrorEnvelope> {
      Empty(completeImmediately: false).eraseToAnyPublisher()
    }
  }
#endif

