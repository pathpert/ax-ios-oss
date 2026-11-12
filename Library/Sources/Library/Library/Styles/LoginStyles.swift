import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Primary green sign-up button style for authentication screens.
public let createNewAccountButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonStyle.green)
  button.setTitle(Strings.Sign_up(), for: .normal)
  return button
}

/// Legal disclaimer link button style shown beneath login and sign-up forms.
public let disclaimerButtonStyle = UIButton.lens.titleColor(for: .normal) .~ LegacyColors.ksr_support_400
  .uiColor()
  <> UIButton.lens.titleColor(for: .highlighted) %~ { _ in
    LegacyColors.ksr_support_400.uiColor(opacity: 0.5)
  }

  <> UIButton.lens.titleLabel.font %~~ { _, label in
    label.traitCollection.isRegularRegular ? .ksr_footnote(size: 14.0) : .ksr_footnote(size: 11.0)
  }

  <> UIButton.lens.titleLabel.textAlignment .~ .center
  <> UIButton.lens.title(for: .normal) %~ { _ in
    Strings.By_signing_up_you_agree_to_our_Terms_of_Use_Privacy_Policy_and_Cookie_Policy()
  }

  <> UIButton.lens.accessibilityValue %~ { _ in Strings.general_navigation_buttons_help() }
  <> UIButton.lens.accessibilityLabel %~ { _ in
    Strings.By_signing_up_you_agree_to_our_Terms_of_Use_Privacy_Policy_and_Cookie_Policy()
  }

  <> UIButton.lens.accessibilityHint %~ { _ in Strings.Opens_help_sheet() }

/// Password visibility toggle button style for secure text entry fields.
public let showHidePasswordButtonStyle = UIButton.lens.title(for: .normal) .~ ""
  <> UIButton.lens.tintColor .~ LegacyColors.ksr_support_300.uiColor()
  <> UIButton.lens.accessibilityLabel %~ { _ in
    Strings.Password_visibility()
  }

/// Email input text field style configuring keyboard type and placeholder.
public let emailFieldStyle = formFieldStyle
  <> UITextField.lens.placeholder %~ { _ in Strings.login_placeholder_email() }
  <> UITextField.lens.keyboardType .~ .emailAddress

/// Configures an email text field with `.username` AutoFill content type.
public func emailFieldAutoFillStyle(_ textField: UITextField) -> UITextField {
  return textField
    |> emailFieldStyle
    |> \.textContentType .~ .username
}

/// Facebook sign-in button style for login tout views.
public let fbLoginButtonStyle = facebookButtonStyle
  <> UIButton.lens.title(for: .normal) %~ { _ in
    Strings.login_tout_buttons_log_in_with_facebook()
  }

/// Body copy label style used on Facebook account confirmation screens.
public let fbConfirmationMessageLabelStyle = UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
  <> UILabel.lens.font .~ .ksr_body()
  <> UILabel.lens
  .text %~ { _ in Strings.By_signing_up_youll_log_in_to_Kickstarter_using_your_Facebook_account() }

/// Email heading label style displayed during Facebook sign-up confirmation.
public let fbConfirmEmailLabelStyle = UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
  <> UILabel.lens.font .~ .ksr_headline()
  <> UILabel.lens.textAlignment .~ .left
  <> UILabel.lens.adjustsFontSizeToFitWidth .~ true

/// Muted caption label style displayed when logging in with an unlinked Facebook account.
public let fbWrongAccountLabelStyle = UILabel.lens.font .~ .ksr_caption1()
  <> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
  <> UILabel.lens.text %~ { _ in Strings.facebook_confirmation_wrong_account_title() }

/// Subtle text button style for triggering password recovery.
public let forgotPasswordButtonStyle =
  UIButton.lens.titleLabel.font .~ .ksr_subhead()
    <> UIButton.lens.titleColor(for: .normal) .~ LegacyColors.ksr_support_400.uiColor()
    <> UIButton.lens.titleColor(for: .highlighted) .~ LegacyColors.ksr_support_700.uiColor()
    <> UIButton.lens.title(for: .normal) %~ { _ in Strings.login_buttons_forgot_password() }

/// View controller title style for the login screen.
public let loginControllerStyle = UIViewController.lens.title %~ { _ in Strings.login_navbar_title() }

/// Secondary grey log-in button style.
public let loginWithEmailButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonLegacyStyle.grey)
  button.setTitle(Strings.login_buttons_log_in(), for: .normal)
  return button
}

/// Newsletter opt-in switch style with Kickstarter green tint.
public let newsletterSwitchStyle = UISwitch.lens.onTintColor .~ LegacyColors.ksr_create_700.uiColor()

/// Secure password field style configuring masked input and placeholder text.
public let passwordFieldStyle = formFieldStyle
  <> UITextField.lens.placeholder %~ { _ in Strings.login_placeholder_password() }
  <> UITextField.lens.secureTextEntry .~ true

/// Configures a password text field with `.password` AutoFill content type.
public func passwordFieldAutoFillStyle(_ textField: UITextField) -> UITextField {
  return textField
    |> passwordFieldStyle
    |> \.textContentType .~ .password
}

/// Configures a password text field for account creation with `.newPassword` AutoFill.
public func newPasswordFieldAutoFillStyle(_ textField: UITextField) -> UITextField {
  let style = passwordFieldAutoFillStyle(textField)

  return style
    |> \.textContentType .~ .newPassword
}

/// Primary green button style for submitting a password reset request.
public let resetPasswordButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonStyle.green)
  button.setTitle(Strings.forgot_password_buttons_reset_my_password(), for: .normal)
  return button
}

/// View controller title style for the reset-password screen.
public let resetPasswordControllerStyle = UIViewController.lens.title %~ { _ in
  Strings.forgot_password_title()
}

/// Applies responsive margins to the login container stack view based on regular/compact layout.
public func applyLoginRootStackViewStyle(_ stackView: UIStackView, useLargerMargins: Bool) {
  stackView.isLayoutMarginsRelativeArrangement = true
  stackView.layoutMargins = useLargerMargins ?
    .init(topBottom: Styles.grid(5), leftRight: Styles.grid(20)) :
    .init(topBottom: Styles.grid(2), leftRight: Styles.grid(4))
}

/// Primary green sign-up CTA button style on the login tout view.
public let signupButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonStyle.green)
  button.setTitle(Strings.login_tout_default_intent_traditional_signup_button(), for: .normal)
  return button
}

/// Newsletter opt-in help button style displaying weekly digest copy.
public let newsletterButtonStyle = UIButton.lens.titleColor(for: .normal) .~ LegacyColors.ksr_support_400
  .uiColor()
  <> UIButton.lens.titleColor(for: .highlighted) %~ { _ in
    LegacyColors.ksr_support_400.uiColor(opacity: 0.5)
  }

  <> UIButton.lens.titleLabel.font .~ .ksr_footnote()
  <> UIButton.lens.titleLabel.textAlignment .~ .left
  <> UIButton.lens.title(for: .normal) %~ { _ in
    Strings.Receive_a_weekly_mix_of_handpicked_projects_plus_occasional_Kickstarter_news()
  }

  <> UIButton.lens.accessibilityValue %~ { _ in Strings.general_navigation_buttons_help() }
  <> UIButton.lens.accessibilityLabel %~ { _ in
    Strings.Receive_a_weekly_mix_of_handpicked_projects_plus_occasional_Kickstarter_news()
  }

  <> UIButton.lens.accessibilityHint %~ { _ in Strings.Opens_help_sheet() }

/// Primary green button style for submitting email registration.
public let signupWithEmailButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonStyle.green)
  button.setTitle(Strings.Sign_up(), for: .normal)
  return button
}

/// Footnote label style for weekly newsletter subscription descriptions.
public let newsletterLabelStyle = UILabel.lens.font .~ .ksr_footnote()
  <> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
  <> UILabel.lens.lineBreakMode .~ .byWordWrapping
  <> UILabel.lens.numberOfLines .~ 0
  <> UILabel.lens.text %~ { _ in
    Strings.Receive_a_weekly_mix_of_handpicked_projects_plus_occasional_Kickstarter_news()
  }

/// Parses an HTML legal disclaimer `string` into an attributed string sized for the trait environment.
public func disclaimerAttributedString(
  with string: String,
  useLargerText: Bool
) -> NSAttributedString? {
  guard let attributedString = try? NSMutableAttributedString(
    data: Data(string.utf8),
    options: [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ],
    documentAttributes: nil
  ) else { return nil }

  let attributes: String.Attributes = [
    .font: useLargerText ? UIFont.ksr_footnote(size: 14.0) : .ksr_footnote(size: 11.0),
    .foregroundColor: LegacyColors.ksr_support_400.uiColor(),
    .underlineStyle: 0
  ]

  let fullRange = (attributedString.string as NSString).range(of: attributedString.string)

  attributedString.addAttributes(attributes, range: fullRange)

  return attributedString
}

/// Numeric code input field style for two-factor authentication.
public let tfaCodeFieldStyle = formFieldStyle
  <> UITextField.lens.textAlignment .~ .center
  <> UITextField.lens.font .~ .ksr_title1()
  <> UITextField.lens.keyboardType .~ .numberPad
  <> UITextField.lens.placeholder %~ { _ in Strings.two_factor_code_placeholder() }

/// Configures a 2FA code field with `.oneTimeCode` AutoFill support.
public func tfaCodeFieldAutoFillStyle(_ textField: UITextField) -> UITextField {
  let style = textField
    |> tfaCodeFieldStyle

  return style
    |> \.textContentType .~ .oneTimeCode
}

/// View controller title style for the two-factor authentication screen.
public let twoFactorControllerStyle = UIViewController.lens.title %~ { _ in Strings.two_factor_title() }

/// Configures a read-only disclaimer `UITextView` with legal policy links and accessibility traits.
public func applyDisclaimerTextViewStyle(_ textView: UITextView, useLargerText: Bool) {
  _ = textView
    |> tappableLinksViewStyle
  textView.attributedText =
    attributedDisclaimerText(textView: textView, useLargerText: useLargerText)
  textView.accessibilityTraits = [.staticText]
  textView.textAlignment = .center
}

/// Builds the localized legal terms and privacy policy attributed text for account creation.
public func attributedDisclaimerText(textView _: UITextView, useLargerText: Bool) -> NSAttributedString? {
  let baseUrl = AppEnvironment.current.apiService.serverConfig.webBaseUrl

  guard let termsOfUseLink = HelpType.terms.url(withBaseUrl: baseUrl)?.absoluteString,
        let privacyPolicyLink = HelpType.privacy.url(withBaseUrl: baseUrl)?.absoluteString else { return nil }

  let string = Strings
    .By_creating_an_account_you_agree_to_Kickstarters_Terms_of_Use_and_Privacy_Policy(
      terms_of_use_link: termsOfUseLink,
      privacy_policy_link: privacyPolicyLink
    )
  return disclaimerAttributedString(with: string, useLargerText: useLargerText)
}
