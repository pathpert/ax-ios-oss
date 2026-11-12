import class Foundation.NSCoder
import UIKit

/// Controller/component implementing `CircleAvatarImageView`.
public final class CircleAvatarImageView: UIImageView {
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.masksToBounds = true
    self.layer.cornerRadius = self.bounds.width / 2.0
  }
}
