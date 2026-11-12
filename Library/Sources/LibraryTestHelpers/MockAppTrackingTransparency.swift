import AppTrackingTransparency
import Library
import ReactiveSwift

/// Controller/component implementing `MockAppTrackingTransparency`.
class MockAppTrackingTransparency: AppTrackingTransparencyType {
  /// Simulated IDFA string exposed in tests while tracking is requested.
  public private(set) var advertisingIdentifier: String?
  /// Controls whether requesting ATT populates a non-nil mock `advertisingIdentifier`.
  public var requestAndSetAuthorizationStatusFlag = false

  /// Convenience flag mapping `.notDetermined` tracking authorization state in tests.
  public var shouldRequestAuthStatus: Bool {
    get {
      self.authorizationStatusProperty.value == .notDetermined
    }
    set {
      self.authorizationStatusProperty.value = (newValue ? .notDetermined : .authorized)
    }
  }

  /// Gets or overrides the simulated `AppTrackingAuthorization` status in tests.
  public var authorizationStatusValue: AppTrackingAuthorization {
    get {
      self.authorizationStatusProperty.value
    }
    set {
      self.authorizationStatusProperty.value = newValue
    }
  }

  func updateAdvertisingIdentifier() {
    self.advertisingIdentifier = self.shouldRequestAuthStatus ? "advertisingIdentifer" : nil
  }

  func requestAndSetAuthorizationStatus(
    _ completion: ((ATTrackingManager.AuthorizationStatus) -> Void)? =
      nil
  ) {
    self.authorizationStatusProperty.value = .authorized
    self.advertisingIdentifier = self.requestAndSetAuthorizationStatusFlag ? "advertisingIdentifier" : nil
    completion?(.authorized)
  }

  func shouldRequestAuthorizationStatus() -> Bool {
    self.shouldRequestAuthStatus
  }

  private var authorizationStatusProperty = MutableProperty<AppTrackingAuthorization>(.notDetermined)
  var authorizationStatus: SignalProducer<AppTrackingAuthorization, Never> {
    self.authorizationStatusProperty.producer
      .replayLazily(upTo: 1)
      .skipRepeats()
  }
}
