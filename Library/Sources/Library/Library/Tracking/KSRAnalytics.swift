import AppTrackingTransparency
import KsApi
import PassKit
import Prelude
import SegmentBrazeUI
import UIKit

/// Centralized Segment and first-party analytics tracker for Kickstarter iOS screens and user actions.
///
/// - Important: All events automatically wait for App Tracking Transparency authorization state and merge
///   session and authenticated-user properties before dispatching to `segmentClient`.
public final class KSRAnalytics {
  private let bundle: NSBundleType
  internal var config: Config?
  private let device: UIDeviceType
  internal var loggedInUser: User?
  internal var appTrackingTransparency: AppTrackingTransparencyType?
  /// Optional test and debug observer invoked immediately before forwarding an event to Segment.
  public var logEventCallback: ((String, AnalyticsPropertyBag) -> Void)?
  private let screen: UIScreenType
  private var segmentClient: (TrackingClientType & IdentifyingTrackingClient)?

  var anonymousId: String? {
    // This anonymous ID is used by Statsig for bucketing experiments.
    // If tracking has been disallowed via consent management, we won't return an anonymous ID.
    // This makes the iOS behavior consistent with Android.
    guard self.isTrackingEnabled() else {
      return nil
    }

    return self.segmentClient?.anonymousId
  }

  /// Returns `true` if the user has consented to tracking. Returns `false` if they have not, or if we can't determine their tracking state.
  internal func isTrackingEnabled() -> Bool {
    guard let appTrackingTransparency = self.appTrackingTransparency else { return false }

    self.appTrackingTransparency?.updateAdvertisingIdentifier()

    guard let _ = appTrackingTransparency.advertisingIdentifier else { return false }

    return true
  }

  /// Configures `KSRAnalytics` with a Segment tracking client. Call is idempotent and will only set once.
  public func configureSegmentClient(_ segmentClient: TrackingClientType & IdentifyingTrackingClient) {
    guard self.segmentClient == nil else { return }
    self.segmentClient = segmentClient
  }

  internal enum SegmentEvent: String, CaseIterable {
    case cardClicked = "Card Clicked"
    case ctaClicked = "CTA Clicked"
    case pageViewed = "Page Viewed"
    case videoPlaybackStarted = "Video Playback Started"
  }

  /// Creates an analytics coordinator bound to host configuration, device telemetry, and tracking clients.
  public init(
    bundle: NSBundleType = Bundle.main,
    config: Config? = nil,
    device: UIDeviceType = UIDevice.current,
    loggedInUser: User? = nil,
    screen: UIScreenType = UIScreen.main,
    segmentClient: (TrackingClientType & IdentifyingTrackingClient)? = nil,
    appTrackingTransparency: AppTrackingTransparencyType? = nil
  ) {
    self.bundle = bundle
    self.config = config
    self.device = device
    self.loggedInUser = loggedInUser
    self.screen = screen
    self.segmentClient = segmentClient
    self.appTrackingTransparency = appTrackingTransparency
  }

  /// Configure Tracking Client's supporting user identity.
  /// Instead of calling this directly from client code, you should call `AppEnvironment.current.identify`,
  /// which wraps multiple identify calls for different vendors in one place.
  func identify(newUser: User?) {
    guard let newUser = newUser else {
      self.segmentClient?.reset()
      return
    }

    let newData = KSRAnalyticsIdentityData(newUser)

    // Older versions of segment automatically included these ids in the traits.
    // To de-risk our migration, manually include these in the traits for now.
    // TODO(MBL-2742): Test if we need these fields as a follow-up.
    var traits = newData.allTraits
    traits["userId"] = "\(newData.userId)"
    if let segmentClient = self.segmentClient {
      traits["anonymousId"] = segmentClient.anonymousId
    }

    self.segmentClient?.identify(
      userId: "\(newData.userId)",
      traits: traits
    )
  }

  // MARK: - Core Dispatch & Session Properties

  internal func track(
    event: String,
    properties: AnalyticsPropertyBag = AnalyticsPropertyBag(),
    refTag: String? = nil
  ) {
    guard let appTrackingTransparency = self.appTrackingTransparency else { return }

    self.appTrackingTransparency?.updateAdvertisingIdentifier()

    guard let _ = appTrackingTransparency.advertisingIdentifier else { return }

    let props = self.sessionProperties(refTag: refTag)
      .withAllValuesFrom(userProperties(for: self.loggedInUser))
      .withAllValuesFrom(properties)

    self.logEventCallback?(event, props)

    self.segmentClient?.track(
      name: event,
      properties: props
    )
  }

  private func sessionProperties(
    refTag: String?,
    prefix: String = "session_"
  ) -> AnalyticsPropertyBag {
    var props = AnalyticsPropertyBag()

    props["apple_pay_capable"] = AppEnvironment.current.applePayCapabilities.applePayCapable()
    props["client"] = "native"
    props["country"] = self.config?.countryCode
    props["display_language"] = AppEnvironment.current.language.rawValue
    props["device_type"] = self.device.deviceType
    props["device_orientation"] = self.deviceOrientation

    if let appBuildNumber = self.bundle.infoString(forKey: "CFBundleVersion") {
      props["app_build_number"] = Int(appBuildNumber)
    }

    props["app_release_version"] = self.bundle.infoString(forKey: "CFBundleShortVersionString")
    props["is_voiceover_running"] = AppEnvironment.current.isVoiceOverRunning()
    props["os"] = "ios"
    props["platform"] = self.clientPlatform
    props["user_is_logged_in"] = self.loggedInUser != nil
    props["ref_tag"] = refTag

    return props.prefixedKeys(prefix)
  }

  private var deviceOrientation: String {
    switch self.device.orientation {
    case .faceDown: return "face_down"
    case .faceUp: return "face_up"
    case .landscapeLeft: return "landscape_left"
    case .landscapeRight: return "landscape_right"
    case .portrait: return "portrait"
    case .portraitUpsideDown: return "portrait_upside_down"
    case .unknown: return "unknown"
    @unknown default: fatalError()
    }
  }

  private var clientPlatform: String {
    switch self.device.userInterfaceIdiom {
    case .phone, .pad: return "native_ios"
    case .tv: return "tvos"
    default: return "unspecified"
    }
  }
}

extension KSRAnalytics {
  /// Functional lenses for updating mutable `KSRAnalytics` dependencies in `AppEnvironment`.
  public enum lens {
    /// Lens focusing on the currently authenticated `User`.
    public static let loggedInUser = Lens<KSRAnalytics, User?>(
      view: { $0.loggedInUser },
      set: { $1.loggedInUser = $0; return $1 }
    )

    /// Lens focusing on the active server `Config`.
    public static let config = Lens<KSRAnalytics, Config?>(
      view: { $0.config },
      set: { $1.config = $0; return $1 }
    )

    /// Lens focusing on the `AppTrackingTransparencyType` consent provider.
    public static let appTrackingTransparency = Lens<KSRAnalytics, AppTrackingTransparencyType?>(
      view: { $0.appTrackingTransparency },
      set: { $1.appTrackingTransparency = $0; return $1 }
    )
  }
}
