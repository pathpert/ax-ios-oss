import KDS
import UIKit

// See `Kickstarter-iOS/SharedViews/ViewModifiers/ButtonModifiers.swift` for the SwiftUI version of
// these styles. These files should be kept in sync.

// MARK: - Apple Pay

/// Configures legacy rounded corners and accessibility on Apple Pay `PKPaymentButton` instances.
@available(
  *,
  deprecated,
  message: "This is a button style from our legacy design system. Instead, use KSRButtonStyle."
)
public let applePayButtonStyle: ButtonStyle = { button in
  let cornerRadius: CGFloat = Dimension.CornerRadius.small

  _ = roundedStyle(cornerRadius: cornerRadius)(button)
  button.isAccessibilityElement = true

  return button
}

// MARK: - Facebook

/// Applies the `KSRButtonStyle.facebook` configuration and responsive padding to Facebook login buttons.
@available(
  *,
  deprecated,
  message: "This is a button style from our legacy design system. Instead, use KSRButtonStyle."
)
public let facebookButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonStyle.facebook)

  button.configuration?.imagePadding = 9.0

  button.configuration?.contentInsets = button.traitCollection.verticalSizeClass == .compact ?
    NSDirectionalEdgeInsets(top: 10.0, leading: 12.0, bottom: 10.0, trailing: 12.0) :
    NSDirectionalEdgeInsets(top: 12.0, leading: 16.0, bottom: 12.0, trailing: 16.0)

  button.configuration?.image = image(named: "fb-logo-white")?.withRenderingMode(.alwaysTemplate)

  return button
}

// MARK: - Save

/// Applies heart watch/save icons and accessibility label to project save buttons.
@available(
  *,
  deprecated,
  message: "This is a button style from our legacy design system. Instead, use KSRButtonStyle."
)
public func styleSaveButton(_ button: UIButton) {
  button.setTitle(nil, for: .normal)
  button.tintColor = LegacyColors.ksr_support_700.uiColor()
  button.setImage(image(named: "icon--heart-outline"), for: .normal)
  button.setImage(image(named: "icon--heart"), for: .selected)
  button.accessibilityLabel = Strings.Save_this_project()
}

// MARK: - Share

/// Applies share icon and accessibility label to project share buttons.
@available(
  *,
  deprecated,
  message: "This is a button style from our legacy design system. Instead, use KSRButtonStyle."
)
public func styleShareButton(_ button: UIButton) {
  button.setTitle(nil, for: .normal)
  button.setImage(Library.image(named: "icon--share"), for: .normal)
  button.tintColor = LegacyColors.ksr_support_700.uiColor()
  button.accessibilityLabel = Strings.dashboard_accessibility_label_share_project()
}
