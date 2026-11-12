import KDS
import Library
import Prelude
import SwiftUI
import UIKit

/// Layout and spacing constants for `PostCampaignCheckoutViewController`.
enum PostCampaignCheckoutLayout {
  enum Style {
    static let cornerRadius: CGFloat = Styles.grid(2)
  }

  enum Margin {
    static let topBottom: CGFloat = Styles.grid(3)
    static let leftRight: CGFloat = CheckoutConstants.PledgeView.Inset.leftRight
  }
}

// MARK: - Layout & Styles

extension PostCampaignCheckoutViewController {
  /// Builds the scroll view, inset sections, rewards summary, and sticky CTA container hierarchy.
  func configureChildViewControllers() {
    self.view.addSubview(self.rootScrollView)
    self.view.addSubview(self.pledgeCTAContainerView)

    _ = (self.rootStackView, self.rootScrollView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    self.rootStackView.addArrangedSubview(self.rootInsetStackView)

    let arrangedInsetSubviews = [
      self.titleLabel,
      self.paymentMethodsViewController.view,
      self.pledgeDisclaimerView
    ]
    .compactMap { $0 }
    .compact()

    arrangedInsetSubviews.forEach { view in
      self.rootInsetStackView.addArrangedSubview(view)
    }

    self.rootStackView.addArrangedSubview(self.pledgeRewardsSummaryViewController.view)
    self.rootStackView.addArrangedSubview(self.estimatedShippingStackView)

    self.addChild(self.paymentMethodsViewController)
    self.paymentMethodsViewController.didMove(toParent: self)

    self.addChild(self.pledgeRewardsSummaryViewController)
    self.pledgeRewardsSummaryViewController.didMove(toParent: self)
  }

  /// Activates Auto Layout constraints pinning scroll view and CTA footer.
  func setupConstraints() {
    NSLayoutConstraint.activate([
      self.rootScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.rootScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.rootScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.rootScrollView.bottomAnchor.constraint(equalTo: self.pledgeCTAContainerView.topAnchor),
      self.pledgeCTAContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.pledgeCTAContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.pledgeCTAContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.rootStackView.widthAnchor.constraint(equalTo: self.rootScrollView.widthAnchor)
    ])
  }

  /// Configures fonts, colors, spacing, and rounded card corners for post-campaign checkout views.
  override func bindStyles() {
    super.bindStyles()

    _ = self.view |> checkoutBackgroundStyle

    self.titleLabel.text = Strings.Checkout()
    self.titleLabel.numberOfLines = 1
    self.titleLabel.textColor = LegacyColors.ksr_support_700.uiColor()
    self.titleLabel.font = UIFont.ksr_title2().bolded
    self.titleLabel.layoutMargins = UIEdgeInsets(
      topBottom: PostCampaignCheckoutLayout.Margin.topBottom,
      leftRight: Styles.grid(3)
    )

    self.rootScrollView.showsVerticalScrollIndicator = false
    self.rootScrollView.alwaysBounceVertical = true

    self.rootStackView.axis = NSLayoutConstraint.Axis.vertical
    self.rootStackView.spacing = Styles.grid(1)
    self.rootStackView.isLayoutMarginsRelativeArrangement = true
    self.rootStackView.layoutMargins = UIEdgeInsets(
      topBottom: PostCampaignCheckoutLayout.Margin.topBottom,
      leftRight: 0
    )

    rootInsetStackViewStyle(self.rootInsetStackView)
    rootInsetStackViewStyle(self.estimatedShippingStackView)

    roundedStyle(self.paymentMethodsViewController.view, cornerRadius: PostCampaignCheckoutLayout.Style.cornerRadius)
    roundedStyle(self.pledgeDisclaimerView, cornerRadius: PostCampaignCheckoutLayout.Style.cornerRadius)
  }

  /// Configures the SwiftUI estimated shipping view with formatted cost and conversion notes.
  func configureEstimatedShippingView(_ estimatedCost: String, _ aboutConversion: String?) {
    let estimatedShippingView = EstimatedShippingCheckoutView(
      estimatedCost: estimatedCost,
      aboutConversion: aboutConversion ?? ""
    )

    self.estimatedShippingViewContainer.rootView = estimatedShippingView
    self.estimatedShippingViewContainer.view.translatesAutoresizingMaskIntoConstraints = false
    self.estimatedShippingViewContainer.view.clipsToBounds = true
    self.estimatedShippingViewContainer.view.layer.masksToBounds = true
    self.estimatedShippingViewContainer.view.layer.cornerRadius = PostCampaignCheckoutLayout.Style.cornerRadius

    self.estimatedShippingStackView.addArrangedSubview(self.estimatedShippingViewContainer.view)
    self.estimatedShippingViewContainer.didMove(toParent: self)
    self.estimatedShippingStackView.layoutIfNeeded()
  }
}

private func rootInsetStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = NSLayoutConstraint.Axis.vertical
  stackView.spacing = Styles.grid(4)
  stackView.isLayoutMarginsRelativeArrangement = true
  stackView.layoutMargins = UIEdgeInsets(
    topBottom: PostCampaignCheckoutLayout.Margin.topBottom,
    leftRight: PostCampaignCheckoutLayout.Margin.leftRight
  )
}

/// Applies overflow clipping and rounded corners to the given `UIView`.
public func roundedStyle(_ view: UIView, cornerRadius: CGFloat = Dimension.CornerRadius.small) {
  view.clipsToBounds = true
  view.layer.masksToBounds = true
  view.layer.cornerRadius = cornerRadius
}

