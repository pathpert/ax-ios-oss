import UIKit

/// Catalog of UIKit storyboard identifiers used to instantiate legacy view controllers.
/// - Negative Constraint: Do not add new SwiftUI features here; prefer programmatic initialization.
public enum Storyboard: String {
  case Activity
  case Backing
  case BackerDashboard
  case CommentsDialog
  case DebugPushNotifications
  case Discovery
  case DiscoveryPage
  case EmptyStates
  case Friends
  case Help
  case LaunchScreen
  case Login
  case Main
  case Messages
  case PaymentMethods
  case Profile
  case ProjectActivity
  case ProjectPamphlet
  case Search
  case SearchLegacy
  case Settings
  case SettingsNewsletters
  case SettingsNotifications
  case SettingsPrivacy
  case Thanks
  case Update
  case UpdateDraft
  case Video

  /// Instantiates a strongly typed view controller whose storyboard ID matches its class name.
  /// - Parameters:
  ///   - _: View controller class type to instantiate.
  ///   - bundle: Bundle containing the storyboard resource (defaults to `.framework`).
  /// - Returns: Instantiated view controller cast to `VC`.
  public func instantiate<VC: UIViewController>(_: VC.Type, inBundle bundle: Bundle = .framework) -> VC {
    guard
      let vc = UIStoryboard(name: self.rawValue, bundle: bundle)
      .instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
    else { fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }

    return vc
  }
}
