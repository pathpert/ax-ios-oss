import Foundation
@testable import Library
import ReactiveSwift
import UserNotifications

/// Immutable value type representing `MockPushRegistration`.
public struct MockPushRegistration: PushRegistrationType {
  static var registerProducer: SignalProducer<Bool, Never> = .empty
  static var hasAuthorizedNotificationsProducer: SignalProducer<Bool, Never> = .empty

  /// Emits the test-stubbed `registerProducer` authorization result.
  public static func register(for _: UNAuthorizationOptions) -> SignalProducer<Bool, Never> {
    return self.registerProducer
  }

  /// Emits the test-stubbed `hasAuthorizedNotificationsProducer` authorization state.
  public static func hasAuthorizedNotifications() -> SignalProducer<Bool, Never> {
    return self.hasAuthorizedNotificationsProducer
  }
}
