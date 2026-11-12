import Foundation

extension Paginator {
  /// Represents the current pagination state and loaded items of a `Paginator`.
  public enum Results: Equatable {
    /// Compares two pagination result states for equality.
    public static func == (
      lhs: Paginator<Envelope, Value, Cursor, SomeError, RequestParams>.Results,
      rhs: Paginator<Envelope, Value, Cursor, SomeError, RequestParams>.Results
    ) -> Bool {
      switch (lhs, rhs) {
      case (.unloaded, .unloaded):
        return true
      case let (
        .someLoaded(lhsValues, lhsCursor, lhsTotal, lhsPage),
        .someLoaded(rhsValues, rhsCursor, rhsTotal, rhsPage)
      ):
        return lhsValues == rhsValues && lhsCursor == rhsCursor && lhsTotal == rhsTotal && lhsPage == rhsPage
      case let (.allLoaded(lhsValues, lhsPage), .allLoaded(rhsValues, rhsPage)):
        return lhsValues == rhsValues && lhsPage == rhsPage
      case (.empty, .empty):
        return true
      case let (.error(lhsError), .error(rhsError)):
        return lhsError.localizedDescription == rhsError.localizedDescription
      case let (.loading(lhsPrevious), .loading(rhsPrevious)):
        return lhsPrevious == rhsPrevious
      case (.unloaded, _),
           (.someLoaded, _),
           (.allLoaded, _),
           (.empty, _),
           (.error, _),
           (.loading, _):
        return false
      }
    }

    /// No request has started yet.
    case unloaded
    /// At least one page is loaded and a cursor is available for loading more items.
    case someLoaded(values: [Value], cursor: Cursor, total: Int?, page: Int?)
    /// All available pages have been loaded.
    case allLoaded(values: [Value], page: Int?)
    /// Request completed with zero items.
    case empty
    /// Request failed with an error.
    case error(SomeError)
    /// A request is currently in flight while preserving the previous result state.
    indirect case loading(previous: Results)

    /// Currently loaded values across pages, or an empty array if none.
    public var values: [Value] {
      switch self {
      case let .loading(previous):
        previous.values
      case let .someLoaded(values, _, _, _):
        values
      case let .allLoaded(values, _):
        values
      case .unloaded, .empty, .error:
        []
      }
    }

    /// Next-page cursor if more items remain, otherwise `nil`.
    public var cursor: Cursor? {
      guard case let .someLoaded(_, cursor, _, _) = self else {
        return nil
      }
      return cursor
    }

    /// Whether a pagination request is currently in flight.
    public var isLoading: Bool {
      guard case .loading = self else { return false }
      return true
    }

    /// Error encountered by the most recent request, if any.
    public var error: SomeError? {
      guard case let .error(error) = self else { return nil }
      return error
    }

    /// Whether another page can be requested using an existing cursor.
    public var canLoadMore: Bool {
      switch self {
      case .someLoaded, .loading(previous: .someLoaded):
        true
      default:
        false
      }
    }

    /// Whether at least one terminal response (loaded or empty) has been received.
    public var hasLoaded: Bool {
      switch self {
      case .someLoaded, .allLoaded, .empty:
        true
      case .unloaded, .loading, .error:
        false
      }
    }

    /// Known total count of items across pages, if available.
    public var total: Int? {
      switch self {
      case let .allLoaded(values, _):
        values.count
      case let .loading(previous):
        previous.total
      case let .someLoaded(_, _, total, _):
        total
      case .empty:
        0
      case .unloaded, .error:
        nil
      }
    }

    /// One-based page index currently loaded, if available.
    public var page: Int? {
      switch self {
      case let .allLoaded(_, page):
        page
      case let .loading(previous):
        previous.page
      case let .someLoaded(_, _, _, page):
        page
      case .empty, .unloaded, .error:
        nil
      }
    }

    /// Transforms the values array within the current `Results` state while preserving the case and other properties.
    /// - Parameter transform: A closure that takes an array of `Value` items and returns a transformed array.
    /// - Returns: A new `Results` instance with the transformed values if present.
    public func mapValues(_ transform: ([Value]) -> [Value]) -> Results {
      switch self {
      case .unloaded:
        return .unloaded
      case let .someLoaded(values, cursor, total, page):
        return .someLoaded(values: transform(values), cursor: cursor, total: total, page: page)
      case let .allLoaded(values, page):
        return .allLoaded(values: transform(values), page: page)
      case .empty:
        return .empty
      case let .error(error):
        return .error(error)
      case let .loading(previous):
        return .loading(previous: previous.mapValues(transform))
      }
    }
  }
}

