import Foundation
import UIKit

/// Contract defining `Instantiable` capabilities and boundaries.
public protocol Instantiable: AnyObject {
  static func instantiate() -> Self
}

extension Instantiable where Self: UIViewController {
  /// Instantiates the view controller with `nibName: nil` and `bundle: nil`.
  public static func instantiate() -> Self {
    return Self(nibName: nil, bundle: nil)
  }
}

extension UIViewController: Instantiable {}
