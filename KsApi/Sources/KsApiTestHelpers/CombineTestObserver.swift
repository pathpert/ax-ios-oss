import Combine
import Foundation
import XCTest

/// A wrapper around a subscription that saves all events to a public array so that assertions can be made on a publisher's behavior.
/// - Negative Constraint: Test-only observer; do not use in production targets.
public final class CombineTestObserver<Value, Error: Swift.Error> {
  /// Represents the state of an event in the publisher's timeline
  public enum Event {
    /// Emitted output value from the publisher.
    case value(Value)
    /// Failure completion emitted by the publisher.
    case error(Error)
    /// Normal completion emitted by the publisher.
    case finished
  }

  /// Recorded timeline of publisher events in arrival order.
  public private(set) var events: [Event] = []

  private var subscriptions = Set<AnyCancellable>()

  /// Subscribes to `publisher` and appends emitted values and completion events to `events`.
  public func observe(_ publisher: any Publisher<Value, Error>) {
    publisher.sink { [weak self] completion in

      switch completion {
      case let .failure(error):
        self?.events.append(.error(error))
      case .finished:
        self?.events.append(.finished)
      }

    } receiveValue: { [weak self] value in
      self?.events.append(.value(value))
    }
    .store(in: &self.subscriptions)
  }

  /// Get all of the next values emitted by the signal.
  public var values: [Value] {
    var values: [Value] = []
    for event in self.events {
      switch event {
      case let .value(v):
        values.append(v)
      default: break
        // do nothing
      }
    }

    return values
  }

  /// Get the last value emitted by the signal.
  public var lastValue: Value? {
    return self.values.last
  }

  /// `true` if at least one `.Next` value has been emitted.
  public var didEmitValue: Bool {
    return self.values.count > 0
  }

  /// The failed error if the signal has failed.
  public var failedError: Error? {
    var errors: [Error] = []
    for event in self.events {
      switch event {
      case let .error(e):
        errors.append(e)
      default: break
        // do nothing
      }
    }

    assert(
      errors.count <= 1,
      "I'm pretty sure a Combine publisher can only ever emit one error. If this fails, I've learned something new today."
    )

    return errors.last
  }

  /// `true` if a `.Failed` event has been emitted.
  public var didFail: Bool {
    return self.failedError != nil
  }

  /// `true` if a `.Finished` event has been emitted or a `.Failed` event has been ommitted
  public var didComplete: Bool {
    return self.events.contains { event in
      switch event {
      case .finished:
        return true
      case .error:
        return true

      default: break
      }
      return false
    }
  }

  /// Asserts that the observed publisher emitted at least one completion or error event.
  public func assertDidComplete(
    _ message: String = "Should have completed.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(self.didComplete, message, file: file, line: line)
  }

  /// Asserts that the observed publisher emitted an error completion.
  public func assertDidFail(
    _ message: String = "Should have failed.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(self.didFail, message, file: file, line: line)
  }

  /// Asserts that the observed publisher has not emitted an error completion.
  public func assertDidNotFail(
    _ message: String = "Should not have failed.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertFalse(self.didFail, message, file: file, line: line)
  }

  /// Asserts that the observed publisher has not completed or failed.
  public func assertDidNotComplete(
    _ message: String = "Should not have completed",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertFalse(self.didComplete, message, file: file, line: line)
  }

  /// Asserts that the observed publisher emitted at least one value.
  public func assertDidEmitValue(
    _ message: String = "Should have emitted at least one value.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssert(self.values.count > 0, message, file: file, line: line)
  }

  /// Asserts that the observed publisher emitted zero values.
  public func assertDidNotEmitValue(
    _ message: String = "Should not have emitted any values.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(0, self.values.count, message, file: file, line: line)
  }

  /// Asserts that the observed publisher terminated via completion or failure.
  public func assertDidTerminate(
    _ message: String = "Should have terminated, i.e. completed/failed/interrupted.",
    file: StaticString = #file, line: UInt = #line
  ) {
    XCTAssertTrue(self.didFail || self.didComplete, message, file: file, line: line)
  }

  /// Asserts that the observed publisher has not yet terminated.
  public func assertDidNotTerminate(
    _ message: String = "Should not have terminated, i.e. completed/failed/interrupted.",
    file: StaticString = #file, line: UInt = #line
  ) {
    XCTAssertTrue(!self.didFail && !self.didComplete, message, file: file, line: line)
  }

  /// Asserts the exact number of emitted values recorded in `values`.
  public func assertValueCount(
    _ count: Int,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      count,
      self.values.count,
      message ?? "Should have emitted \(count) values",
      file: file,
      line: line
    )
  }
}

extension CombineTestObserver where Value: Equatable {
  /// Asserts that the observed publisher emitted exactly one value equal to `value`.
  public func assertValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(1, self.values.count, "A single item should have been emitted.", file: file, line: line)
    XCTAssertEqual(
      value,
      self.lastValue,
      message ?? "A single value of \(value) should have been emitted",
      file: file,
      line: line
    )
  }

  /// Asserts that the last emitted value equals `value`.
  public func assertLastValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      value,
      self.lastValue,
      message ?? "Last emitted value is equal to \(value).",
      file: file,
      line: line
    )
  }

  /// Asserts that all emitted values equal `values` in order.
  public func assertValues(
    _ values: [Value],
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(values, self.values, message, file: file, line: line)
  }
}

extension CombineTestObserver where Error: Equatable {
  /// Asserts that the recorded failure error equals `expectedError`.
  public func assertFailed(
    _ expectedError: Error,
    message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(expectedError, self.failedError, message, file: file, line: line)
  }
}
