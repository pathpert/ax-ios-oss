import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Helper definitions for `pledgeCTAStackViewStyle` in `PledgeViewCTAContainerView+Styles.swift`.
internal func pledgeCTAStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .horizontal
  stackView.distribution = .fillEqually
  stackView.spacing = Styles.grid(2)
  stackView.layoutMargins = UIEdgeInsets(topBottom: Styles.grid(2), leftRight: Styles.grid(0))
  stackView.isLayoutMarginsRelativeArrangement = true
}

internal func pledgeCTADisclaimerStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = Styles.grid(2)
  stackView.layoutMargins = UIEdgeInsets(
    top: Styles.grid(0),
    left: Styles.grid(5),
    bottom: Styles.grid(1),
    right: Styles.grid(5)
  )
  stackView.isLayoutMarginsRelativeArrangement = true
}

internal let pledgeCTALayerStyle: LayerStyle = { layer in
  layer
    |> checkoutLayerCardRoundedStyle
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor().cgColor
    |> \.shadowColor .~ LegacyColors.ksr_black.uiColor().cgColor
    |> \.shadowOpacity .~ 0.12
    |> \.shadowOffset .~ CGSize(width: 0, height: -1.0)
    |> \.shadowRadius .~ CGFloat(1.0)
    |> \.maskedCorners .~ [
      CACornerMask.layerMaxXMinYCorner,
      CACornerMask.layerMinXMinYCorner
    ]
}

internal func pledgeCTATermsTextViewStyle(_ textView: UITextView) {
  textView.isScrollEnabled = false
  textView.isEditable = false
  textView.isUserInteractionEnabled = true
  textView.adjustsFontForContentSizeCategory = true
  textView.textContainerInset = UIEdgeInsets.zero
  textView.textContainer.lineFragmentPadding = 0
  textView.linkTextAttributes = [
    .foregroundColor: LegacyColors.ksr_create_700.uiColor()
  ]
  textView.accessibilityTraits = [.staticText]
  textView.textAlignment = .center
}

internal func pledgeCTAAttributedTermsText() -> NSAttributedString? {
  let baseUrl = AppEnvironment.current.apiService.serverConfig.webBaseUrl

  guard
    let termsOfUseLink = HelpType.terms.url(withBaseUrl: baseUrl)?.absoluteString,
    let privacyPolicyLink = HelpType.privacy.url(withBaseUrl: baseUrl)?.absoluteString,
    let cookiePolicyLink = HelpType.cookie.url(withBaseUrl: baseUrl)?.absoluteString
  else { return nil }

  let string = Strings.By_pledging_you_agree_to_Kickstarters_Terms_of_Use_Privacy_Policy_and_Cookie_Policy(
    terms_of_use_link: termsOfUseLink,
    privacy_policy_link: privacyPolicyLink,
    cookie_policy_link: cookiePolicyLink
  )

  return checkoutAttributedLink(with: string)
}

internal func pledgeCTAPledgeImmediatelyText() -> NSAttributedString? {
  let rawText = Strings.Your_payment_method_will_be_charged()
  return rawText.simpleHtmlAttributedString(font: UIFont.ksr_caption2())
}

