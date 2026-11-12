import Foundation
import UIKit

/// Custom `UIActivityType` identifier for opening Kickstarter URLs in Safari.
public let SafariActivityType = UIActivity.ActivityType("com.kickstarter.kickstarter.safari")

/// Wrapper box passed in `UIActivityViewController` items for opening a URL in Safari.
public struct SafariURL {
  /// Target URL to open externally.
  public let url: URL
}

/// Share-sheet `UIActivity` action that opens a `SafariURL` item in the system Safari browser.
///
/// Negative Constraint: Expects a `SafariURL` item in `activityItems`; plain `URL` or `String` items are ignored.
public final class SafariActivity: UIActivity {
  fileprivate var url: URL?

  /// Creates a `SafariActivity` preconfigured with a destination `SafariURL`.
  public convenience init(url: SafariURL) {
    self.init()

    self.url = url.url
  }

  /// Custom activity identifier (`SafariActivityType`).
  public override var activityType: UIActivity.ActivityType? {
    return SafariActivityType
  }

  /// Localized title shown below the Safari icon in the share sheet.
  public override var activityTitle: String? {
    return "Safari"
  }

  /// Icon image rendered in the system share sheet.
  public override var activityImage: UIImage? {
    return image(named: "safari-icon-full")
  }

  /// Returns `true` when `activityItems` includes at least one `SafariURL`.
  public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
    let urls = activityItems.filter { $0 is SafariURL }
    return !urls.isEmpty
  }

  /// Opens the configured URL via `UIApplication.shared.open(_:)` and marks the activity complete.
  public override func perform() {
    guard let url = self.url else { return }

    UIApplication.shared.open(url)
    self.activityDidFinish(true)
  }
}
