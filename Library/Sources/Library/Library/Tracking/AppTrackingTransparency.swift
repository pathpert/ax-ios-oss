import AdSupport
import AppTrackingTransparency
import Foundation
import ReactiveSwift

/// Alias for `ATTrackingManager.AuthorizationStatus`.
public typealias AppTrackingAuthorization = ATTrackingManager.AuthorizationStatus

/// Abstraction wrapping `ATTrackingManager` authorization prompts and IDFA lookup.
///
/// Negative Constraint: Do not cache or expose `advertisingIdentifier` when authorization status is anything other than `.authorized`.
public protocol AppTrackingTransparencyType {
  /// Advertising identifier (IDFA) UUID string, or `nil` when not authorized.
  var advertisingIdentifier: String? { get }
  /// Stream of current and updated ATT authorization statuses.
  var authorizationStatus: SignalProducer<AppTrackingAuthorization, Never> { get }
  /// Refreshes `advertisingIdentifier` and `authorizationStatus` from `ATTrackingManager`.
  func updateAdvertisingIdentifier()
  /// Prompts the user for ATT permission when `.notDetermined` and invokes `completion`.
  func requestAndSetAuthorizationStatus(_ completion: ((ATTrackingManager.AuthorizationStatus) -> Void)?)
  /// Returns `true` only when the current status is `.notDetermined`.
  func shouldRequestAuthorizationStatus() -> Bool
}

/// Live `AppTrackingTransparencyType` implementation backed by `ATTrackingManager` and `ASIdentifierManager`.
public class AppTrackingTransparency: AppTrackingTransparencyType {
  /// Current IDFA string when authorized, or `nil` otherwise.
  public private(set) var advertisingIdentifier: String?

  /// Creates an instance and immediately synchronizes the current authorization status.
  public init() {
    self.updateAdvertisingIdentifier()
  }

  /// Requests tracking authorization from `ATTrackingManager` and updates `advertisingIdentifier`.
  public func requestAndSetAuthorizationStatus(
    _ completion: ((ATTrackingManager.AuthorizationStatus) -> Void)? = nil
  ) {
    ATTrackingManager.requestTrackingAuthorization { [weak self] authStatus in
      self?.authorizationStatusProperty.value = authStatus

      switch authStatus {
      case .authorized:
        self?.advertisingIdentifier = ASIdentifierManager.shared().advertisingIdentifier.uuidString
      default:
        self?.advertisingIdentifier = nil
      }

      completion?(authStatus)
    }
  }

  /// Returns `true` if `ATTrackingManager.trackingAuthorizationStatus == .notDetermined`.
  public func shouldRequestAuthorizationStatus() -> Bool {
    ATTrackingManager.trackingAuthorizationStatus == .notDetermined
  }

  /// Synchronizes `authorizationStatus` and `advertisingIdentifier` without prompting the user.
  public func updateAdvertisingIdentifier() {
    let status = ATTrackingManager.trackingAuthorizationStatus
    self.authorizationStatusProperty.value = status

    switch status {
    case .authorized:
      self.advertisingIdentifier = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    default:
      self.advertisingIdentifier = nil
    }
  }

  /// Replays the latest `AppTrackingAuthorization` status and suppresses duplicate emissions.
  public var authorizationStatus: SignalProducer<AppTrackingAuthorization, Never> {
    self.authorizationStatusProperty.producer
      .replayLazily(upTo: 1)
      .skipRepeats()
  }

  // MARK: Subjects

  private let authorizationStatusProperty = MutableProperty<AppTrackingAuthorization>(.notDetermined)
}
