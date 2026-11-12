import Combine
import Foundation

/// Coordinates cursor-based pagination for SwiftUI/Combine views, exposing loaded `values`, `isLoading`, `error`, and `results`.
/// - Parameters:
///   - valuesFromEnvelope: Extracts page items of `Value` from a decoded `Envelope`.
///   - cursorFromEnvelope: Extracts the next-page `Cursor` from a decoded `Envelope`, or `nil` when no further page exists.
///   - requestFromParams: Produces a Combine publisher for the initial request given `RequestParams`.
///   - requestFromCursor: Produces a Combine publisher for a subsequent page request given `Cursor`.
public class Paginator<Envelope, Value: Equatable, Cursor: Equatable, SomeError: Error, RequestParams> {
  /// Published current state of the paginated results stream.
  @Published public var results: Results

  private var valuesFromEnvelope: (Envelope) -> [Value]
  private var cursorFromEnvelope: (Envelope) -> Cursor?
  private var totalFromEnvelope: (Envelope) -> Int?
  private var requestFromParams: (RequestParams) -> AnyPublisher<Envelope, SomeError>
  private var requestFromCursor: (Cursor) -> AnyPublisher<Envelope, SomeError>
  private var cancellables = Set<AnyCancellable>()

  private var lastCursor: Cursor?

  /// Creates a new `Paginator` configured with response extractors and page request closures.
  public init(
    valuesFromEnvelope: @escaping ((Envelope) -> [Value]),
    cursorFromEnvelope: @escaping ((Envelope) -> Cursor?),
    totalFromEnvelope: @escaping ((Envelope) -> Int?),
    requestFromParams: @escaping ((RequestParams) -> AnyPublisher<Envelope, SomeError>),
    requestFromCursor: @escaping ((Cursor) -> AnyPublisher<Envelope, SomeError>)
  ) {
    self.results = .unloaded

    self.valuesFromEnvelope = valuesFromEnvelope
    self.cursorFromEnvelope = cursorFromEnvelope
    self.totalFromEnvelope = totalFromEnvelope
    self.requestFromParams = requestFromParams
    self.requestFromCursor = requestFromCursor
  }

  func handleRequest(_ request: AnyPublisher<Envelope, SomeError>, shouldClear: Bool) {
    request
      .combineLatest(self.$results.first().setFailureType(to: SomeError.self))
      .map { [weak self] envelope, previousResults -> Results in
        guard let self else {
          fatalError()
        }

        let newValues = self.valuesFromEnvelope(envelope)
        let nextCursor = self.cursorFromEnvelope(envelope)
        var allValues = shouldClear ? [] : previousResults.values
        allValues.append(contentsOf: newValues)

        let newPage: Int? = switch (previousResults.page, shouldClear, newValues.isEmpty) {
        // resetting to first page, with results should go to page 1
        case (_, true, false):
          1

        // resetting to first page, with no results, should appear empty
        case (_, true, true):
          nil

        // loading the subsequent page, with results, should increment the page
        case let (.some(page), false, false):
          page + 1

        // loading a next page when there's somehow no existing page should set the page to 1
        case (.none, false, false):
          1

        // loading a next page with no results should keep the page the same
        case let (page, false, true):
          page
        }

        let results: Results
        if allValues.count == 0 {
          results = .empty
        } else if let nextCursor, !newValues.isEmpty {
          // Warning: This total count may be incorrect. It should represent the total number of
          // cards that a user has, but because of the way the fetch works on the backend, that
          // number is currently unknown. The backend returns the number of cards in the fetch
          // itself instead.
          let total = self.totalFromEnvelope(envelope)
          results = .someLoaded(values: allValues, cursor: nextCursor, total: total, page: newPage)
        } else {
          results = .allLoaded(values: allValues, page: newPage)
        }
        return results
      }
      .catch { error -> AnyPublisher<Results, Never> in
        Just(.error(error)).eraseToAnyPublisher()
      }
      .prepend(.loading(previous: self.results))
      .sink(receiveValue: { results in
        self.results = results
      })
      .store(in: &self.cancellables)
  }

  /// Cancels any active pagination request and requests the initial page for `params`.
  public func requestFirstPage(withParams params: RequestParams) {
    self.cancel()

    let request = self.requestFromParams(params)
    self.handleRequest(request, shouldClear: true)
  }

  /// Requests the next page if not already loading and a next-page cursor exists.
  public func requestNextPage() {
    guard !self.results.isLoading, let cursor = self.results.cursor else {
      return
    }

    let request = self.requestFromCursor(cursor)
    self.handleRequest(request, shouldClear: false)
  }

  /// Awaits and returns the next non-loading `Results` state.
  public func nextResult() async -> Results {
    let publisher = AsyncPublisher(self.$results).dropFirst()
      .filter { !$0.isLoading }
    var iterator = publisher.makeAsyncIterator()
    let result = await iterator.next() ?? self.results
    return result
  }

  /// Cancels in-flight requests and reverts `.loading` back to the prior result state.
  public func cancel() {
    if case let .loading(previous) = self.results {
      self.results = previous
    }

    self.cancellables.forEach { cancellable in
      cancellable.cancel()
    }
  }
}

extension Paginator where RequestParams == Void {
  /// Convenience overload requesting the first page when `RequestParams` is `Void`.
  public func requestFirstPage() {
    self.requestFirstPage(withParams: ())
  }
}
