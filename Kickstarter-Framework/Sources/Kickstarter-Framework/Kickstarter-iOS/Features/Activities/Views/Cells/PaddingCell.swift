import Library
import UIKit

/// Controller/component implementing `PaddingCell`.
internal final class PaddingCell: StaticTableViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
    self.accessibilityElementsHidden = true
  }
}
