import Foundation
import ReactiveSwift
import UIKit
import UserNotifications

/// Push notification permission registration wrapper conforming to `PushRegistrationType`.
public struct PushRegistration: PushRegistrationType {
  /// Requests user authorization for `options` and registers with APNs on the main thread when granted.
  /// - Parameter options: The notification options (`UNAuthorizationOptions`) to request.
  /// - Returns: A `SignalProducer` emitting `true` if authorization was granted, then completing.
  public static func register(for options: UNAuthorizationOptions) -> SignalProducer<Bool, Never> {
    return SignalProducer { observer, _ in
      UNUserNotificationCenter.current()
        .requestAuthorization(options: options, completionHandler: { isGranted, _ in
          if isGranted {
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }

          observer.send(value: isGranted)
          observer.sendCompleted()
        })
    }
  }

  /// Emits whether the user has previously authorized push notifications, then completes.
  /// - Negative Constraint: Emits on a background thread; do not assume main-thread delivery without observing on UI scheduler.
  public static func hasAuthorizedNotifications() -> SignalProducer<Bool, Never> {
    return SignalProducer { observer, _ in
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        observer.send(value: settings.authorizationStatus == .authorized)
        observer.sendCompleted()
      }
    }
  }
}
