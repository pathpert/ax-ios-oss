import UIKit

/// `UIButton` subclass expanding the tappable hit region outward by `hitMargin` points on each edge.
public final class EasyButton: UIButton {
  /// Outward expansion padding (in points) added around `bounds` for hit testing (default `5`).
  public var hitMargin = CGFloat(5)

  /// Evaluates touch hit-testing against `bounds` inset by `-hitMargin`.
  public override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
    let area = self.bounds.insetBy(dx: -self.hitMargin, dy: -self.hitMargin)
    return area.contains(point)
  }
}
