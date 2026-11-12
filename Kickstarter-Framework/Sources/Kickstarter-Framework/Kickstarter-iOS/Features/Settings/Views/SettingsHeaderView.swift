import Library
import Prelude
import UIKit

/// Controller/component implementing `SettingsHeaderView`.
final class SettingsHeaderView: UITableViewHeaderFooterView {
  @IBOutlet fileprivate var titleLabel: UILabel!

  func configure(title: String) {
    _ = self
      |> \.accessibilityLabel .~ title
      |> \.accessibilityTraits .~ .header
      |> \.isAccessibilityElement .~ true

    _ = self.titleLabel
      |> \.text .~ title
  }

  override func bindStyles() {
    super.bindStyles()

    _ = self.titleLabel
      |> settingsSectionLabelStyle
  }
}
