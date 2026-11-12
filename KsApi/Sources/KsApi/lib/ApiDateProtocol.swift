import Foundation

/// Clock abstraction wrapping `Date` so API request signing and tests can inject deterministic timestamps.
///
/// Negative Constraint: Do not use `Date()` directly in API time-window calculations; inject `ApiDateProtocol.Type`.
public protocol ApiDateProtocol {
  /// Underlying `Foundation.Date` value.
  var date: Date { get }
  /// Returns a copy shifted by `TimeInterval` seconds.
  func addingTimeInterval(_: TimeInterval) -> Self
  /// Initializes at the current (or mocked) timestamp.
  init()
  /// Initializes from seconds since Unix epoch (`1970-01-01T00:00:00Z`).
  init(timeIntervalSince1970: TimeInterval)
  /// Initializes from seconds relative to now.
  init(timeIntervalSinceNow: TimeInterval)
  /// Epoch timestamp in seconds (`TimeInterval`).
  var timeIntervalSince1970: TimeInterval { get }
}

extension Date: ApiDateProtocol {
  /// Returns `self` as a `Foundation.Date`.
  public var date: Date {
    return self
  }
}

internal struct ApiMockDate: ApiDateProtocol {
  private let time: TimeInterval

  internal init() {
    self.time = 1_475_361_315
  }

  internal init(timeIntervalSince1970 time: TimeInterval) {
    self.time = time
  }

  internal init(timeIntervalSinceNow time: TimeInterval) {
    self.time = time
  }

  internal var timeIntervalSince1970: TimeInterval {
    return self.time
  }

  internal var date: Date {
    return Date(timeIntervalSince1970: self.time)
  }

  internal func addingTimeInterval(_ interval: TimeInterval) -> ApiMockDate {
    return ApiMockDate(timeIntervalSince1970: self.time + interval)
  }
}
