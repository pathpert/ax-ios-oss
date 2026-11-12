import Prelude
import UIKit

/// Root `UINavigationController` subclass delegating status bar style and orientation support to its top controller.
/// - Negative Constraint: Do not hardcode status bar style globally here; configure `preferredStatusBarStyle` per child view controller.
public final class NavigationController: UINavigationController {
  /// Forwards status bar style preference from `topViewController`, defaulting to `.default`.
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    self.topViewController?.preferredStatusBarStyle
      ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?
      .statusBarManager?
      .statusBarStyle ?? .default
  }

  /// Forwards supported interface orientations from `topViewController`, defaulting to `.all`.
  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return self.topViewController?.supportedInterfaceOrientations ?? .all
  }
}

extension UINavigationController {
  /// Configures the navigation bar with a transparent background and empty shadow image.
  public func configureTransparentNavigationBar() {
    _ = self.navigationBar
      |> transparentNavigationBarStyle

    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
}

private let transparentNavigationBarStyle: NavigationBarStyle = { navBar in
  navBar
    ?|> \.backgroundColor .~ .clear
    ?|> \.shadowImage .~ UIImage()
    ?|> \.isTranslucent .~ true
}
