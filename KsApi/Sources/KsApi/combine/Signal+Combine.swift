import Combine
import Foundation
import ReactiveSwift

extension Signal where Error == Never {
  var combinePublisher: AnyPublisher<Value, Never> {
    let subject = PassthroughSubject<Value, Never>()
    self.observeValues { value in
      subject.send(value)
    }

    return subject.eraseToAnyPublisher()
  }

  /// Bridges a non-failing ReactiveSwift `Signal` directly into a SwiftUI/Combine `@Published` publisher.
  /// - Negative Constraint: Do not call from failing signals (`Error != Never`); catch or map errors before bridging.
  public func assign(toCombine published: inout Published<Value>.Publisher) {
    self.combinePublisher.assign(to: &published)
  }
}
