import UIKit

/// Functional styling closure applied to configure `PaddingLabel` appearance.
public typealias PaddingLabelStyle = (PaddingLabel) -> PaddingLabel

/// `UILabel` subclass supporting configurable internal edge insets around rendered text.
/// - Negative Constraint: Do not rely on `sizeToFit()` alone without updating `insets` first.
public class PaddingLabel: UILabel {
  var insets: UIEdgeInsets = UIEdgeInsets(all: Styles.grid(1))

  /// Draws label text inset by `insets`.
  public override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: self.insets))
  }

  /// Returns intrinsic size expanded by `insets`.
  public override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + self.insets.left + self.insets.right,
      height: size.height + self.insets.top + self.insets.bottom
    )
  }

  // MARK: Initializers

  /// Creates a `PaddingLabel` initialized with custom `edgeInsets`.
  public convenience init(frame: CGRect, edgeInsets: UIEdgeInsets) {
    self.init(frame: frame)

    self.insets = edgeInsets
  }
}
