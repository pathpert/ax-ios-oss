import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Shared base tint style for `UIBarButtonItem`.
public let baseBarButtonItemStyle =
  UIBarButtonItem.lens.tintColor .~ LegacyColors.ksr_support_400.uiColor()

/// Plain text `UIBarButtonItem` style with subhead typography.
public let plainBarButtonItemStyle = baseBarButtonItemStyle
  <> UIBarButtonItem.lens.style .~ .plain
  <> UIBarButtonItem.lens.titleTextAttributes(for: .normal) .~ [
    NSAttributedString.Key.font: UIFont.ksr_subhead(size: 15)
  ]

/// "Done" confirmation `UIBarButtonItem` style with localized title and headline typography.
public let doneBarButtonItemStyle = baseBarButtonItemStyle
  <> UIBarButtonItem.lens.style .~ .done
  <> UIBarButtonItem.lens.title %~ { _ in Strings.Done() }
  <> UIBarButtonItem.lens.titleTextAttributes(for: .normal) .~ [
    NSAttributedString.Key.font: UIFont.ksr_headline(size: 15)
  ]

/// Icon-only `UIBarButtonItem` style clearing any text title.
public let iconBarButtonItemStyle = baseBarButtonItemStyle
  <> UIBarButtonItem.lens.title .~ nil

/// Close (`X`) icon `UIBarButtonItem` style.
public let closeBarButtonItemStyle = iconBarButtonItemStyle
  <> UIBarButtonItem.lens.image .~ image(named: "icon--cross")

/// Accessible share icon `UIBarButtonItem` style.
public let shareBarButtonItemStyle = iconBarButtonItemStyle
  <> UIBarButtonItem.lens.image .~ image(named: "icon--share")
  <> UIBarButtonItem.lens.accessibilityLabel %~ { _ in Strings.dashboard_accessibility_label_share_project() }
