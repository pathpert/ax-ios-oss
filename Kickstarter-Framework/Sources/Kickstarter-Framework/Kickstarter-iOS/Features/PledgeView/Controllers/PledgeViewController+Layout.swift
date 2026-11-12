import KDS
import KsApi
import Library
import Prelude
import SwiftUI
import UIKit

extension PledgeViewController {
  /// Adds child controllers, scroll container, and initial arranged subviews.
  func configureChildViewControllers() {
    self.view.addSubview(self.rootScrollView)
    self.view.addSubview(self.pledgeCTAContainerView)

    _ = (self.rootStackView, self.rootScrollView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    let childViewControllers = [
      self.pledgeRewardsSummaryViewController,
      self.paymentMethodsViewController,
      self.paymentPlansViewController
    ]

    self.paymentPlansView.isHidden = true

    let arrangedInsetSubviews = [
      [self.titleLabel],
      [self.paymentPlansView],
      self.paymentMethodsSectionViews,
      self.confirmationSectionViews
    ]
    .flatMap { $0 }
    .compact()

    self.rootStackView.addArrangedSubview(self.rootInsetStackView)

    arrangedInsetSubviews.forEach { view in
      self.rootInsetStackView.addArrangedSubview(view)
    }

    childViewControllers.forEach { viewController in
      self.addChild(viewController)
      viewController.didMove(toParent: self)
    }

    self.rootStackView.addArrangedSubview(self.pledgeRewardsSummaryViewController.view)
    self.rootStackView.addArrangedSubview(self.estimatedShippingStackView)

    self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    self.titleLabel.setContentHuggingPriority(.required, for: .vertical)
  }

  /// Activates Auto Layout constraints pinning the scroll view and sticky CTA footer.
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

  /// Configures the legal disclaimer banner below payment methods.
  func configureDisclaimerView() {
    guard let attributedText = PledgeViewControllerHelpers.attributedLearnMoreText() else {
      return
    }
    self.pledgeDisclaimerView.configure(
      with: PledgeDisclaimerViewData(iconImageName: "icon-not-a-store", attributedText: attributedText)
    )
  }

  /// Renders the SwiftUI estimated shipping view with formatted cost and currency conversion copy.
  func configureEstimatedShippingView(_ estimatedCost: String, _ aboutConversion: String?) {
    let estimatedShippingView = EstimatedShippingCheckoutView(
      estimatedCost: estimatedCost,
      aboutConversion: aboutConversion ?? ""
    )

    self.estimatedShippingViewContainer.rootView = estimatedShippingView
    self.estimatedShippingViewContainer.view.translatesAutoresizingMaskIntoConstraints = false
    self.estimatedShippingViewContainer.view.clipsToBounds = true
    self.estimatedShippingViewContainer.view.layer.masksToBounds = true
    self.estimatedShippingViewContainer.view.layer.cornerRadius = PledgeViewLayout.Style.cornerRadius

    self.estimatedShippingStackView.addArrangedSubview(self.estimatedShippingViewContainer.view)
    self.estimatedShippingViewContainer.didMove(toParent: self)
    self.estimatedShippingStackView.layoutIfNeeded()
  }

  /// Reorganizes sections to show titled Collection Plan and Payment cards when Pledge Over Time is active.
  func configurePledgeOverTimeUI(_ isVisible: Bool) {
    guard isVisible else { return }

    let collectionPlanStackView = UIStackView(frame: .zero)
    applyPledgeSectionStackViewStyle(collectionPlanStackView)

    [self.collectionPlanSectionLabel, self.paymentPlansView].forEach {
      collectionPlanStackView.addArrangedSubview($0)
    }

    let paymentStackView = UIStackView(frame: .zero)
    applyPledgeSectionStackViewStyle(paymentStackView)

    [self.paymentSectionLabel, self.paymentMethodsViewController.view!].forEach {
      paymentStackView.addArrangedSubview($0)
    }

    let arrangedInsetSubviews: [UIView] = [
      [self.titleLabel as UIView],
      [collectionPlanStackView as UIView],
      [paymentStackView as UIView],
      self.confirmationSectionViews as [UIView]
    ]
    .flatMap { $0 }

    arrangedInsetSubviews.forEach { view in
      self.rootInsetStackView.addArrangedSubview(view)
    }
  }
}
