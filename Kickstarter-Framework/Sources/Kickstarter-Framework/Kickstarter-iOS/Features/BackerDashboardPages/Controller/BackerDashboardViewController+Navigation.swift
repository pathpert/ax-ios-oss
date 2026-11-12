import KDS
import KsApi
import Library
import Prelude
import UIKit

/// `BackerDashboardViewController` extensions declared in `BackerDashboardViewController+Navigation.swift`.
extension BackerDashboardViewController {
  func configurePagesDataSource(tab: BackerDashboardTab) {
    self.pagesDataSource = BackerDashboardPagesDataSource(delegate: self)

    self.pageViewController?.dataSource = self.pagesDataSource
    self.pageViewController?.ksr_setViewControllers(
      [self.pagesDataSource.controllerFor(tab: tab)].compact(),
      direction: .forward,
      animated: false,
      completion: nil
    )
  }

  func setAttributedTitles(for button: UIButton, with string: String) {
    let font = self.traitCollection.isRegularRegular
      ? UIFont.ksr_headline(size: 16.0)
      : UIFont.ksr_headline(size: 13.0)

    let normalTitleString = NSAttributedString(string: string, attributes: [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_400.uiColor()
    ])

    let selectedTitleString = NSAttributedString(string: string, attributes: [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_700.uiColor()
    ])

    _ = button
      |> UIButton.lens.attributedTitle(for: .normal) %~ { _ in normalTitleString }
      |> UIButton.lens.attributedTitle(for: .selected) %~ { _ in selectedTitleString }
      |> (UIButton.lens.titleLabel .. UILabel.lens.lineBreakMode) .~ .byWordWrapping
  }

  func selectButton(atTab tab: BackerDashboardTab) {
    guard let index = self.pagesDataSource.indexFor(tab: tab) else { return }

    for (idx, button) in self.menuButtonsStackView.arrangedSubviews.enumerated() {
      _ = (button as? UIButton)
        ?|> UIButton.lens.isSelected .~ (idx == index)
    }
  }

  func pinSelectedIndicator(to tab: BackerDashboardTab, animated: Bool) {
    guard let index = self.pagesDataSource.indexFor(tab: tab) else { return }
    guard let button = self.menuButtonsStackView.arrangedSubviews[index] as? UIButton else { return }

    let leadingConstant = button.frame.origin.x + Styles.grid(1)
    let widthConstant = button.titleLabel?.frame.size.width ?? button.frame.size.width

    UIView.animate(
      withDuration: animated ? 0.2 : 0.0,
      delay: 0.0,
      options: .curveEaseOut,
      animations: {
        self.headerView.setNeedsLayout()
        self.selectedButtonIndicatorLeadingConstraint.constant = leadingConstant
        self.selectedButtonIndicatorWidthConstraint.constant = widthConstant
        self.headerView.layoutIfNeeded()
      },
      completion: nil
    )
  }

  func goToSettings() {
    let vc = SettingsViewController.instantiate()
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .formSheet

    self.present(nav, animated: true, completion: nil)
  }

  @objc func handlePan(gesture: UIPanGestureRecognizer) {
    let selectedTab = self.viewModel.outputs.currentSelectedTab
    guard let controller = self.pagesDataSource.controllerFor(tab: selectedTab) as?
      BackerDashboardProjectsViewController else { return }

    let minHeaderHeight = self.topBackgroundView.frame.size.height
      - self.menuButtonsStackView.frame.size.height - Styles.grid(3)

    switch gesture.state {
    case .began:
      self.viewModel.inputs.beganPanGestureWith(
        headerTopConstant: self.headerViewTopConstraint.constant,
        scrollViewYOffset: controller.tableView.contentOffset.y
      )
    case .changed:
      let translation = gesture.translation(in: self.view)
      let newConstant = min(0.0, self.viewModel.outputs.initialTopConstant + translation.y)

      if newConstant >= -minHeaderHeight {
        self.headerViewTopConstraint.constant = newConstant
      }

    case .ended:
      let shouldCollapse = self.headerViewTopConstraint.constant < (-minHeaderHeight / 2.0)

      UIView.animate(
        withDuration: 0.3,
        delay: 0.0,
        options: .curveEaseOut,
        animations: {
          self.headerViewTopConstraint.constant = shouldCollapse ? -minHeaderHeight : 0.0
          self.view.layoutIfNeeded()
        },
        completion: nil
      )
    default: ()
    }
  }
}

extension BackerDashboardViewController: UIPageViewControllerDelegate {
  internal func pageViewController(
    _: UIPageViewController,
    didFinishAnimating _: Bool,
    previousViewControllers _: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    self.viewModel.inputs.pageTransition(completed: completed)
  }

  internal func pageViewController(
    _: UIPageViewController,
    willTransitionTo pendingViewControllers: [UIViewController]
  ) {
    guard let idx = pendingViewControllers.first.flatMap(self.pagesDataSource.indexFor(controller:)) else {
      return
    }

    self.viewModel.inputs.willTransition(toPage: idx)
  }
}

extension BackerDashboardViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }

    let translation = gestureRecognizer.translation(in: self.view)
    return translation.x == 0
  }

  func gestureRecognizer(
    _: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}

extension BackerDashboardViewController: TabBarControllerScrollable {
  func scrollToTop() {
    if let scrollView = self.pageViewController?.viewControllers?.first?.view as? UIScrollView {
      scrollView.scrollToTop()
    }
  }
}

