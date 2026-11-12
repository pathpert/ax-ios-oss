import KDS
import KsApi
import Library
import Prelude
import UIKit

/// `DesignSystemViewController` extensions declared in `DesignSystemViewController+Styles.swift`.
extension DesignSystemViewController {
  func configureSectionStacks() {
    _ = ([self.errorSnackbarIcon, self.errorSnackbarLabel], self.errorSnackbarStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = (
      [self.confirmationSnackbarIcon, self.confirmationSnackbarLabel],
      self.confirmationSnackbarStackView
    )
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.errorSnackbarStackView, self.confirmationSnackbarStackView], self.alertsStackView)
      |> ksr_addArrangedSubviewsToStackView()

    KSRButtonStyle.allCases.forEach { buttonStyle in
      let button = KSRButton(style: buttonStyle)
      button.setTitle("\(String(describing: buttonStyle))", for: .normal)
      self.buttonsStackView.addArrangedSubview(button)

      let buttonDisabled = KSRButton(style: buttonStyle)
      buttonDisabled.setTitle("\(String(describing: buttonStyle)) (disabled)", for: .normal)
      buttonDisabled.isEnabled = false
      self.buttonsStackView.addArrangedSubview(buttonDisabled)

      let twoButtonStack = UIStackView(arrangedSubviews: [button, buttonDisabled])
      twoButtonStack.spacing = 8.0
      self.buttonsStackView.addArrangedSubview(twoButtonStack)

      NSLayoutConstraint.activate([
        twoButtonStack.widthAnchor.constraint(equalTo: self.buttonsStackView.widthAnchor)
      ])
    }

    _ = ([self.arrowDownIcon, self.bookmarkIcon, self.heartIcon, self.logoIcon], self.iconsStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = (
      [self.switchControlEnabled, self.switchControlDisabled, self.stepper, self.dropdownButton],
      self.controlsStackView
    )
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.emailTextField, self.passwordTextField], self.inputsStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.loadingIndicator, self.pullToRefreshImageView, self.shimmerLoadingView], self.progressStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.demoCTAContainerView], self.footersStackView)
      |> ksr_addArrangedSubviewsToStackView()

    InterFont.allCases.forEach { style in
      let label = UILabel()
      label.text = String(describing: style).capitalized
      label.font = style.font()
      label.textColor = LegacyColors.ksr_black.uiColor()
      label.adjustsFontForContentSizeCategory = true
      self.typeStackView.addArrangedSubview(label)

      let labelBold = UILabel()
      labelBold.text = "\(String(describing: style)) Bold".capitalized
      labelBold.font = style.font().bolded
      labelBold.textColor = LegacyColors.ksr_black.uiColor()
      labelBold.adjustsFontForContentSizeCategory = true
      self.typeStackView.addArrangedSubview(labelBold)
    }
  }

  func configureLayoutConstraints() {
    NSLayoutConstraint.activate([
      self.rootStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -4),
      self.errorSnackbarStackView.heightAnchor.constraint(equalToConstant: 64),
      self.errorSnackbarStackView.widthAnchor.constraint(equalToConstant: 351),
      self.confirmationSnackbarStackView.heightAnchor.constraint(equalToConstant: 64),
      self.confirmationSnackbarStackView.widthAnchor.constraint(equalToConstant: 351),
      self.errorSnackbarIcon.widthAnchor.constraint(equalToConstant: 20),
      self.errorSnackbarIcon.heightAnchor.constraint(equalToConstant: 20),
      self.confirmationSnackbarIcon.widthAnchor.constraint(equalToConstant: 20),
      self.confirmationSnackbarIcon.heightAnchor.constraint(equalToConstant: 20),
      self.heartIcon.widthAnchor.constraint(equalToConstant: 20),
      self.heartIcon.heightAnchor.constraint(equalToConstant: 20),
      self.bookmarkIcon.widthAnchor.constraint(equalToConstant: 20),
      self.bookmarkIcon.heightAnchor.constraint(equalToConstant: 20),
      self.arrowDownIcon.widthAnchor.constraint(equalToConstant: 20),
      self.arrowDownIcon.heightAnchor.constraint(equalToConstant: 20),
      self.dropdownButton.widthAnchor.constraint(equalToConstant: 175),
      self.emailTextField.heightAnchor.constraint(equalToConstant: 48),
      self.emailTextField.widthAnchor.constraint(equalTo: self.inputsStackView.widthAnchor),
      self.passwordTextField.heightAnchor.constraint(equalToConstant: 48),
      self.passwordTextField.widthAnchor.constraint(equalTo: self.inputsStackView.widthAnchor),
      self.shimmerLoadingView.leftAnchor.constraint(equalTo: self.progressStackView.leftAnchor),
      self.shimmerLoadingView.rightAnchor.constraint(equalTo: self.progressStackView.rightAnchor),
      self.pullToRefreshImageView.widthAnchor.constraint(equalToConstant: 25),
      self.demoCTAContainerView.leftAnchor.constraint(equalTo: self.footersStackView.leftAnchor),
      self.demoCTAContainerView.rightAnchor.constraint(equalTo: self.footersStackView.rightAnchor),
      self.demoCTAContainerView.bottomAnchor.constraint(equalTo: self.footersStackView.bottomAnchor)
    ])
  }

  override func bindStyles() {
    super.bindStyles()

    _ = self.view
      |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.scrollView
      |> \.alwaysBounceVertical .~ true
      |> \.showsVerticalScrollIndicator .~ false

    _ = self.rootStackView
      |> verticalStackViewStyle
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> \.isLayoutMarginsRelativeArrangement .~ true
      |> \.layoutMargins .~ UIEdgeInsets(topBottom: Styles.grid(3), leftRight: Styles.grid(4))
      |> \.spacing .~ 20

    _ = self.errorSnackbarStackView
      |> alertStackViewStyle
      |> \.backgroundColor .~ LegacyColors.ksr_alert.uiColor()

    _ = self.confirmationSnackbarStackView
      |> alertStackViewStyle
      |> \.backgroundColor .~ LegacyColors.ksr_trust_500.uiColor()

    _ = self.alertsLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Alerts"

    _ = self.alertsStackView |> verticalComponentStackViewStyle

    _ = self.errorSnackbarIcon
      |> adaptiveIconImageViewStyle
      |> \.tintColor .~ LegacyColors.ksr_white.uiColor()
      |> UIImageView.lens.image .~ UIImage(named: "fix-icon")?.withRenderingMode(.alwaysTemplate)

    _ = self.errorSnackbarLabel
      |> \.font .~ .ksr_subhead()
      |> \.textColor .~ LegacyColors.ksr_white.uiColor()
      |> \.text .~ "Vestibulum id ligula porta felis euismod semper. Etiam porta sem malesuada."
      |> \.lineBreakMode .~ .byWordWrapping
      |> \.numberOfLines .~ 2

    _ = self.confirmationSnackbarIcon
      |> adaptiveIconImageViewStyle
      |> \.tintColor .~ LegacyColors.ksr_white.uiColor()
      |> UIImageView.lens.image .~ UIImage(named: "icon--confirmation")?.withRenderingMode(.alwaysTemplate)

    _ = self.confirmationSnackbarLabel
      |> \.font .~ .ksr_subhead()
      |> \.textColor .~ LegacyColors.ksr_white.uiColor()
      |> \.text .~ "Vestibulum id ligula porta felis euismod semper. Etiam porta sem malesuada."
      |> \.lineBreakMode .~ .byWordWrapping
      |> \.numberOfLines .~ 2

    _ = self.buttonsLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Buttons"

    _ = self.buttonsStackView |> verticalComponentStackViewStyle

    _ = self.iconsLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Icons"

    _ = self.iconsStackView |> verticalComponentStackViewStyle

    _ = self.logoIcon
      |> adaptiveIconImageViewStyle
      |> \.tintColor .~ LegacyColors.ksr_create_500.uiColor()
      |> UIImageView.lens.image .~ UIImage(named: "kickstarter-logo")?.withRenderingMode(.alwaysTemplate)

    _ = self.arrowDownIcon
      |> adaptiveIconImageViewStyle
      |> \.tintColor .~ LegacyColors.ksr_create_500.uiColor()
      |> UIImageView.lens.image .~ UIImage(named: "arrow-down-large")?.withRenderingMode(.alwaysTemplate)

    _ = self.heartIcon
      |> adaptiveIconImageViewStyle
      |> \.tintColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UIImageView.lens.image .~ UIImage(named: "heart-icon")?.withRenderingMode(.alwaysTemplate)

    _ = self.bookmarkIcon
      |> adaptiveIconImageViewStyle
      |> \.tintColor .~ LegacyColors.ksr_create_700.uiColor()
      |> UIImageView.lens.image .~ UIImage(named: "icon--bookmark")?.withRenderingMode(.alwaysTemplate)

    _ = self.controlsLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Controls"

    _ = self.controlsStackView
      |> verticalStackViewStyle
      |> \.alignment .~ .leading
      |> \.spacing .~ Styles.grid(1)
      |> verticalComponentStackViewStyle

    _ = self.switchControlEnabled |> adaptiveSwitchControlStyle |> \.isOn .~ true
    _ = self.switchControlDisabled |> adaptiveSwitchControlStyle |> \.isOn .~ false
    self.switchControlDisabled.isEnabled = false

    _ = self.stepper |> checkoutStepperStyle
    _ = self.dropdownButton |> adaptiveDropDownButtonStyle |> checkoutWhiteBackgroundStyle |> checkoutRoundedCornersStyle

    self.bindInputAndProgressStyles()
  }

  private func bindInputAndProgressStyles() {
    _ = self.inputsLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Inputs"

    _ = self.inputsStackView |> verticalComponentStackViewStyle

    _ = self.emailTextField
      |> adaptiveEmailFieldStyle
      |> \.layer.borderColor .~ LegacyColors.ksr_support_500.uiColor().cgColor
      |> \.layer.borderWidth .~ 1
      |> \.layer.cornerRadius .~ 6
      |> \.attributedPlaceholder %~ { _ in adaptiveAttributedPlaceholder(Strings.login_placeholder_email()) }
    _ = self.passwordTextField
      |> adaptiveEmailFieldStyle
      |> \.layer.borderColor .~ LegacyColors.ksr_support_500.uiColor().cgColor
      |> \.layer.borderWidth .~ 1
      |> \.layer.cornerRadius .~ 6
      |> UITextField.lens.secureTextEntry .~ true
      |> \.attributedPlaceholder %~ { _ in adaptiveAttributedPlaceholder(Strings.login_placeholder_password()) }

    _ = self.progressLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Progress Indicators"

    _ = self.progressStackView |> verticalComponentStackViewStyle

    _ = self.loadingIndicator
      |> adaptiveActivityIndicatorStyle
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> UIActivityIndicatorView.lens.animating .~ true

    _ = self.pullToRefreshImageView
      |> UIImageView.lens.contentMode .~ .scaleAspectFit
      |> \.translatesAutoresizingMaskIntoConstraints .~ false

    _ = self.footersLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Footers"

    _ = self.typesLabel
      |> \.font .~ .ksr_title1().bolded
      |> \.textColor .~ LegacyColors.ksr_black.uiColor()
      |> \.text .~ "Typography"

    _ = self.typeStackView |> verticalComponentStackViewStyle
  }
}

