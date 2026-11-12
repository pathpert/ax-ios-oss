import AuthenticationServices
import KDS
import Library
import Prelude
import UIKit

// MARK: - Styles & Layout

extension LoginToutViewController {
  /// Configures the visual styles and accessibility hierarchy for the login tout screen.
  public override func bindStyles() {
    super.bindStyles()

    let isPad = self.traitCollection.userInterfaceIdiom == .pad

    _ = self.backgroundImageView |> loginBackgroundImageViewStyle
    applyAppleLoginButtonStyle(self.appleLoginButton)

    _ = self.bringCreativeProjectsToLifeLabel
      |> loginBaseLabelStyle
      |> UILabel.lens.font .~ .ksr_title2()
      |> UILabel.lens.text %~ { _ in Strings.Bring_creative_projects_to_life() }

    _ = self.contextLabel
      |> loginBaseLabelStyle
      |> UILabel.lens.font %~ { _ in
        self.bringCreativeProjectsToLifeLabel.isHidden ? UIFont.ksr_title2() : UIFont.ksr_subhead()
      }

    _ = self.fbLoginButton
      |> facebookButtonStyle
      |> UIButton.lens.title(for: .normal) %~ { _ in Strings.Continue_with_Facebook() }

    _ = self.getNotifiedLabel
      |> loginBaseLabelStyle
      |> UILabel.lens.font %~~ { _, _ in isPad ? UIFont.ksr_subhead() : UIFont.ksr_caption2() }
      |> UILabel.lens.text %~ { _ in Strings.Get_notified_when_your_friends_back_and_launch_projects() }

    self.signupOrLoginWithOAuthButton.applyStyleConfiguration(KSRButtonStyle.green)
    self.signupOrLoginWithOAuthButton
      .setTitle(Strings.login_tout_generic_intent_traditional_signup_or_login_button(), for: .normal)

    _ = self.loginContextStackView
      |> UIStackView.lens.spacing .~ Styles.gridHalf(1)
      |> UIStackView.lens.layoutMargins %~~ { _, _ in
        isPad
          ? .init(topBottom: Styles.grid(2), leftRight: 0)
          : .init(top: Styles.grid(10), left: 0, bottom: Styles.grid(5), right: 0)
      }
      |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true

    _ = self.logoImageView |> loginLogoImageViewStyle

    _ = self.rootStackView
      |> loginBaseStackViewStyle
      |> UIStackView.lens.spacing .~ Styles.grid(5)
    applyLoginRootStackViewStyle(self.rootStackView, useLargerMargins: isPad)

    _ = self.separatorView |> loginSeparatorViewStyle
    _ = [self.loginContextStackView, self.fbLoginStackView, self.emailLoginStackView]
      ||> loginBaseStackViewStyle
  }

  /// Adds background, scroll container, and login stack views to the view hierarchy.
  func configureViews() {
    _ = (self.backgroundImageView, self.view)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = (self.scrollView, self.view)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = (self.rootStackView, self.scrollView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = ([
      self.loginContextStackView, self.fbLoginStackView, self.separatorView, self.emailLoginStackView
    ], self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    let spacer = UIView()
    _ = ([
      self.logoImageView, spacer, self.bringCreativeProjectsToLifeLabel, self.contextLabel
    ], self.loginContextStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.appleLoginButton, self.fbLoginButton, self.getNotifiedLabel], self.fbLoginStackView)
      |> ksr_addArrangedSubviewsToStackView()

    self.emailLoginStackView.addArrangedSubview(self.signupOrLoginWithOAuthButton)
  }

  /// Activates Auto Layout constraints for buttons, separator, and scroll width.
  func setupConstraints() {
    NSLayoutConstraint.activate([
      self.separatorView.heightAnchor.constraint(equalToConstant: 1),
      self.rootStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      self.fbLoginButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Styles.minTouchSize.height),
      self.appleLoginButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Styles.minTouchSize.height)
    ])
  }
}

private let loginBackgroundImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.contentMode .~ .scaleToFill
    |> \.image .~ image(named: "signup-background")
}

private let loginBaseStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.distribution .~ .fill
    |> \.alignment .~ .fill
    |> \.axis .~ .vertical
    |> \.spacing .~ Styles.grid(2)
}

private let loginBaseLabelStyle: LabelStyle = { label in
  label
    |> \.textAlignment .~ NSTextAlignment.center
    |> \.lineBreakMode .~ NSLineBreakMode.byWordWrapping
    |> \.numberOfLines .~ 0
}

private let loginLogoImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.image .~ image(named: "kickstarter-logo")?.withRenderingMode(.alwaysTemplate)
    |> \.tintColor .~ Colors.Brand.logo.uiColor()
    |> \.contentMode .~ .scaleAspectFit
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
    |> \.accessibilityLabel %~ { _ in Strings.general_accessibility_kickstarter() }
}

private let loginSeparatorViewStyle: ViewStyle = { view in
  view
    |> \.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
}

private func applyAppleLoginButtonStyle(_ button: AdaptiveAppleIDButton) {
  button.cornerRadius(Dimension.CornerRadius.small)
}

/// Wrapper view switching between light and dark `ASAuthorizationAppleIDButton` variants.
// There's no light/dark mode for `ASAuthorizationAppleIDButton`, so this is an elaborate workaround.
// See: http://www.openradar.appspot.com/7459440
final class AdaptiveAppleIDButton: UIView {
  let stackview = UIStackView()
  let lightModeButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
  let darkModeButton = ASAuthorizationAppleIDButton(type: .continue, style: .white)

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.stackview)
    self.stackview.constrainViewToEdges(in: self)
    self.stackview.addArrangedSubviews(self.lightModeButton, self.darkModeButton)

    self.updateVisibility()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Shows the appropriate contrast variant for the current interface style.
  func updateVisibility() {
    if self.traitCollection.userInterfaceStyle == .dark {
      self.lightModeButton.isHidden = true
      self.darkModeButton.isHidden = false
    } else {
      self.lightModeButton.isHidden = false
      self.darkModeButton.isHidden = true
    }
  }

  override func traitCollectionDidChange(_: UITraitCollection?) {
    self.updateVisibility()
  }

  /// Registers a target-action pair on both internal Apple ID button variants.
  func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
    self.lightModeButton.addTarget(target, action: action, for: controlEvents)
    self.darkModeButton.addTarget(target, action: action, for: controlEvents)
  }

  /// Sets the corner radius for both the light and dark mode Apple ID buttons.
  ///
  /// - Parameter cornerRadius: The radius to apply to the corners of the buttons. Defaults to `Dimension.CornerRadius.small`.
  func cornerRadius(_ cornerRadius: CGFloat = Dimension.CornerRadius.small) {
    self.lightModeButton.cornerRadius = cornerRadius
    self.darkModeButton.cornerRadius = cornerRadius
  }
}

