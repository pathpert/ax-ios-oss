import Library
import Prelude
import UIKit

/// Delegate notified when `ManagePledgeViewController` completes or is dismissed.
protocol ManagePledgeViewControllerDelegate: AnyObject {
  /// Called after a pledge action finishes with an optional confirmation banner message.
  func managePledgeViewController(
    _ viewController: ManagePledgeViewController,
    managePledgeViewControllerFinishedWithMessage message: String?
  )

  /// Called when the manage pledge screen is dismissed by the user.
  func managePledgeViewControllerDidDismiss(_ viewController: ManagePledgeViewController)
}

// MARK: - Styles & Layout

extension ManagePledgeViewController {
  /// Styles table view, bar buttons, section labels, separators, and stack containers.
  override func bindStyles() {
    super.bindStyles()

    _ = self.tableView |> checkoutBackgroundStyle
    self.closeButton.accessibilityLabel = Strings.Dismiss()
    _ = self.menuButton |> \.accessibilityLabel %~ { _ in Strings.Menu() }
    _ = self.rootStackView |> checkoutRootStackViewStyle
    _ = self.pledgeDetailsSectionLabel |> pledgeDetailsSectionLabelStyle
    _ = self.sectionSeparatorViews ||> separatorStyleDark
    applyPlotPaymentScheduleStackViewStyle(self.plotPaymentScheduleStackView)
  }

  /// Embeds the table view, attaches refresh control, and populates the payment schedule stack.
  func configureViews() {
    _ = (self.tableView, self.view)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = self.tableView |> \.refreshControl .~ self.refreshControl

    self.plotPaymentScheduleStackView.addArrangedSubviews(
      self.plotPaymentScheduleViewController.view,
      self.plotPaymentScheduleSectionSeparator
    )
  }

  /// Lazily builds and assigns the table header containing pledge summary, payment, and schedule sections.
  func configureHeaderView() {
    guard self.tableView.tableHeaderView != self.headerView else { return }

    _ = (self.rootStackView, self.headerView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    let childViews: [UIView] = [
      self.pledgeSummarySectionViews,
      self.paymentMethodViews,
      [self.plotPaymentScheduleStackView],
      self.pledgeDetailsSectionViews
    ]
    .flatMap { $0 }
    .compact()

    _ = (childViews, self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    [self.pledgeSummaryViewController, self.plotPaymentScheduleViewController]
      .forEach { viewController in
        self.addChild(viewController)
        viewController.didMove(toParent: self)
      }

    self.sectionSeparatorViews.forEach { view in
      _ = view.heightAnchor.constraint(equalToConstant: 1) |> \.isActive .~ true
      view.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    self.tableView.tableHeaderView = self.headerView
    self.headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
  }

  /// Replaces the table header with an error pull-to-refresh prompt.
  func configurePullToRefreshHeaderView() {
    guard self.tableView.tableHeaderView != self.pullToRefreshHeaderView else { return }

    _ = (self.pullToRefreshStackView, self.pullToRefreshHeaderView)
      |> ksr_addSubviewToParent()

    _ = ([self.pullToRefreshImageView, self.pullToRefreshLabel], self.pullToRefreshStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = self.pullToRefreshLabel
      |> \.text %~ { _ in Strings.Something_went_wrong_pull_to_refresh() }

    _ = self.pullToRefreshStackView
      |> \.axis .~ .vertical
      |> \.spacing .~ Styles.grid(2)
      |> \.alignment .~ .center

    self.tableView.tableHeaderView = self.pullToRefreshHeaderView

    NSLayoutConstraint.activate([
      self.pullToRefreshStackView.leftAnchor.constraint(equalTo: self.pullToRefreshHeaderView.leftAnchor),
      self.pullToRefreshStackView.rightAnchor.constraint(equalTo: self.pullToRefreshHeaderView.rightAnchor),
      self.pullToRefreshStackView.centerXAnchor
        .constraint(equalTo: self.pullToRefreshHeaderView.centerXAnchor),
      self.pullToRefreshStackView.centerYAnchor
        .constraint(equalTo: self.pullToRefreshHeaderView.centerYAnchor, constant: -Styles.grid(8)),
      self.pullToRefreshHeaderView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      self.pullToRefreshHeaderView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
    ])
  }

  /// Instantiates a navigation-wrapped `ManagePledgeViewController` configured with routing parameters.
  public static func controller(
    with params: ManagePledgeViewParamConfigData,
    delegate: ManagePledgeViewControllerDelegate? = nil
  ) -> UINavigationController {
    let managePledgeViewController = ManagePledgeViewController.instantiate()
    managePledgeViewController.configureWith(params: params)
    managePledgeViewController.delegate = delegate

    let closeButton = UIBarButtonItem(
      image: image(named: "icon--cross"),
      style: .plain,
      target: managePledgeViewController,
      action: #selector(ManagePledgeViewController.closeButtonTapped)
    )
    closeButton.accessibilityLabel = Strings.Dismiss()

    managePledgeViewController.navigationItem.setLeftBarButton(closeButton, animated: false)

    let navigationController = RewardPledgeNavigationController(rootViewController: managePledgeViewController)
    if AppEnvironment.current.device.userInterfaceIdiom == .pad {
      _ = navigationController |> \.modalPresentationStyle .~ .pageSheet
    }

    return navigationController
  }
}

private let pledgeDetailsSectionLabelStyle: LabelStyle = { label in
  label |> checkoutTitleLabelStyle
}

private func applyPlotPaymentScheduleStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = Styles.grid(4)
}

