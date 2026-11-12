import Combine
import Foundation
import GraphAPI
import KsApi
import Library
import UIKit

/// Helper definitions for `PPOViewModelPaginator` in `PPOViewModel.swift`.
typealias PPOViewModelPaginator = Paginator<
  GraphAPI.FetchPledgedProjectsQuery.Data,
  PPOProjectCardViewModel,
  String,
  ErrorEnvelope,
  Void
>

protocol PPOViewModelInputs {
  func viewDidAppear()
  func refresh() async
  func loadMore() async
  func handleCardEvent(_: PPOCardEvent, from: PPOProjectCardModel)
}

protocol PPOViewModelOutputs {
  var results: PPOViewModelPaginator.Results { get }
  var preparedEvents: AnyPublisher<PPOPreparedEvent, Never> { get }
}

final class PPOViewModel: ObservableObject, PPOViewModelInputs, PPOViewModelOutputs {
  init() {
    let paginator: PPOViewModelPaginator = Paginator(
      valuesFromEnvelope: { data -> [PPOProjectCardViewModel] in
        data.pledgeProjectsOverview?.pledges?.edges?
          .compactMap { edge in edge?.node }
          .compactMap { node in PPOProjectCardModel(node: node) }
          .compactMap { model in PPOProjectCardViewModel(card: model) } ?? []
      },
      cursorFromEnvelope: { data in data.pledgeProjectsOverview?.pledges?.pageInfo.endCursor },
      totalFromEnvelope: { data in data.pledgeProjectsOverview?.pledges?.totalCount },
      requestFromParams: { () in
        AppEnvironment.current.apiService.fetchPledgedProjects(
          tierTypes: Self.tierTypes(),
          cursor: nil,
          limit: Constants.pageSize
        )
      },
      requestFromCursor: { cursor in
        AppEnvironment.current.apiService.fetchPledgedProjects(
          tierTypes: Self.tierTypes(),
          cursor: cursor,
          limit: Constants.pageSize
        )
      }
    )
    self.paginator = paginator

    paginator.$results
      .drop(while: { results in
        if case .unloaded = results {
          return true
        } else {
          return false
        }
      })
      // SwiftUI List jumps around if reloading frequently. This code path prevents
      // unnecessary reloads if the data has loaded. If the values are the same and
      // both states have been loaded, then we can drop this change.
      .removeDuplicates(by: { left, right in
        left.hasLoaded && right.hasLoaded && left.values == right.values
      })
      .receive(on: RunLoop.main)
      .sink(receiveValue: { results in self.results = results })
      .store(in: &self.cancellables)

    Publishers.Merge(self.viewDidAppearSubject.withEmptyValues(), self.pullToRefreshSubject)
      .sink { () in paginator.requestFirstPage() }
      .store(in: &self.cancellables)

    self.loadMoreSubject
      .sink { () in paginator.requestNextPage() }
      .store(in: &self.cancellables)

    self.handleCardEventSubject
      .map { event, card in self.preparedEvent(for: event, cardModel: card) }
      .eraseToAnyPublisher()
      .subscribe(self.preparedEventSubject)
      .store(in: &self.cancellables)

    let latestLoadedResults = self.paginator.$results
      .compactMap { results in
        results.hasLoaded ? results.values.ppoAnalyticsProperties(page: results.page) : nil
      }

    self.viewDidAppearSubject
      .withFirst(from: latestLoadedResults)
      .sink { _, properties in
        AppEnvironment.current.ksrAnalytics.trackPPODashboardOpens(properties: properties)
      }
      .store(in: &self.cancellables)

    self.handleCardEventSubject
      .withFirst(from: latestLoadedResults)
      .map { eventAndCardModel, overallProperties in
        (eventAndCardModel.0, eventAndCardModel.1, overallProperties)
      }
      .sink { event, card, overallProperties in
        self.trackCardEvent(event, cardModel: card, overallProperties: overallProperties)
      }
      .store(in: &self.cancellables)

    self.confirmAddressProgressSubject
      .filter { $0.1 == .confirmed }
      .map { $0.0 }
      .withFirst(from: latestLoadedResults)
      .sink { card, overallProperties in
        AppEnvironment.current.ksrAnalytics.trackPPOSubmitAddressConfirmation(
          project: card.projectAnalytics,
          properties: overallProperties
        )
      }
      .store(in: &self.cancellables)
  }

  static func tierTypes() -> [PledgeProjectsOverviewSort] {
    if featurePledgedProjectsOverviewV4Enabled() {
      return PPOTierType.allGraphQLTypes()
    }
    if featurePledgedProjectsOverviewV2Enabled() {
      return PPOTierType.fundedProjectGraphQLTypes()
    }
    return PPOTierType.projectAlertGraphQLTypes()
  }

  func viewDidAppear() { self.viewDidAppearSubject.send() }

  func loadMore() async {
    self.loadMoreSubject.send(())
    _ = await self.paginator.nextResult()
  }

  func refresh() async {
    self.pullToRefreshSubject.send(())
    _ = await self.paginator.nextResult()
  }

  func handleCardEvent(_ cardAction: PPOCardEvent, from cardModel: PPOProjectCardModel) {
    self.handleCardEventSubject.send((cardAction, cardModel))
  }

  @Published var results = PPOViewModelPaginator.Results.unloaded

  var preparedEvents: AnyPublisher<PPOPreparedEvent, Never> {
    self.preparedEventSubject.eraseToAnyPublisher()
  }

  private let paginator: PPOViewModelPaginator
  private let viewDidAppearSubject = PassthroughSubject<Void, Never>()
  private let loadMoreSubject = PassthroughSubject<Void, Never>()
  private let pullToRefreshSubject = PassthroughSubject<Void, Never>()
  let confirmAddressProgressSubject = PassthroughSubject<(PPOProjectCardModel, PPOActionState), Never>()
  private let handleCardEventSubject = PassthroughSubject<(PPOCardEvent, PPOProjectCardModel), Never>()
  private var preparedEventSubject = PassthroughSubject<PPOPreparedEvent, Never>()
  private var cancellables: Set<AnyCancellable> = []

  private enum Constants {
    static let pageSize = 10
  }
}
