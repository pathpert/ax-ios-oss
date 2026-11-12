import KsApi
import Library
import Prelude
import SwiftUI
import UIKit

extension RootTabBarViewController {
  /// Switches to the activities tab.
  public func switchToActivities() {
    self.viewModel.inputs.switchToActivities()
  }

  /// Switches to the discovery tab and optionally applies discovery filter parameters.
  public func switchToDiscovery(params: DiscoveryParams?) {
    self.viewModel.inputs.switchToDiscovery(params: params)
  }

  /// Switches to the login tab or sign-in flow.
  public func switchToLogin() {
    self.viewModel.inputs.switchToLogin()
  }

  /// Switches to the user profile or backed projects tab.
  public func switchToProfile() {
    self.viewModel.inputs.switchToProfile()
  }

  /// Switches to the project search tab.
  public func switchToSearch() {
    self.viewModel.inputs.switchToSearch()
  }

  func viewControllerAndParam<T, P>(with index: RootViewControllerIndex, param: P) -> (T, P)? {
    guard
      let vcs = self.viewControllers,
      let nav = vcs[clamp(0, vcs.count - 1)(index)] as? UINavigationController,
      let vc = nav.children.first as? T
    else { return nil }

    return (vc, param)
  }

  /// Switches to the profile tab and pushes the message thread detail screen onto its navigation stack.
  public func switchToMessageThread(_ messageThread: MessageThread) {
    self.switchToProfile()

    guard
      let profileNav = self.selectedViewController as? UINavigationController,
      let profileVC = profileNav.viewControllers.first
    else { return }

    let threadsVC = MessageThreadsViewController.configuredWith(project: nil, refTag: nil)
    let messageThreadVC = MessagesViewController.configuredWith(messageThread: messageThread)

    self.presentedViewController?.dismiss(animated: false, completion: nil)

    profileNav.setViewControllers([profileVC, threadsVC, messageThreadVC], animated: true)
  }

  /// Presents the login/signup flow with the specified intent, dismissing onboarding if active.
  public func goToLoginWithIntent(_ intent: LoginIntent) {
    /// Dismiss OnboardingView if present so that we can correctly present the LoginToutViewController.
    if let onboardingView = self
      .presentedViewController as? UIHostingController<OnboardingView> {
      onboardingView.dismiss(animated: true)
      AppEnvironment.current.userDefaults.set(true, forKey: AppKeys.hasSeenOnboarding.rawValue)
    }

    let vc = LoginToutViewController.configuredWith(loginIntent: intent)
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .formSheet

    self.present(nav, animated: true, completion: nil)
  }

  static func viewController(from data: RootViewControllerData) -> UIViewController? {
    switch data {
    case .discovery:
      return DiscoveryViewController.instantiate()
    case .activities:
      return ActivitiesViewController.instantiate()
    case .pledgedProjectsAndActivities:
      return PPOContainerViewController.instantiate()
    case .search:
      return SearchViewController.instantiate()
    case let .profile(isLoggedIn):
      return isLoggedIn
        ? BackerDashboardViewController.instantiate()
        : LoginToutViewController.configuredWith(loginIntent: .loginTab)
    }
  }

  /// Forwards updated badge counts from push/activity polling into the root view model.
  public func didReceiveBadgeValue(_ value: Int?) {
    self.viewModel.inputs.didReceiveBadgeValue(value)
  }
}

extension RootTabBarViewController: UITabBarControllerDelegate {
  /// Notifies the view model before selecting a tab bar view controller.
  public func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    let index = tabBarController.viewControllers?.firstIndex(of: viewController)
    self.viewModel.inputs.shouldSelect(index: index)
    return true
  }

  /// Notifies the view model after a tab bar item was selected.
  public func tabBarController(
    _ tabBarController: UITabBarController,
    didSelect _: UIViewController
  ) {
    self.viewModel.inputs.didSelect(index: tabBarController.selectedIndex)
  }

  /// Returns a cross-dissolve animator when switching root tabs.
  public func tabBarController(
    _: UITabBarController,
    animationControllerForTransitionFrom _: UIViewController,
    to _: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return CrossDissolveTransitionAnimator()
  }
}

func scrollTabRootToTop(_ viewController: UIViewController) {
  if let scrollable = viewController as? TabBarControllerScrollable {
    scrollable.scrollToTop()
  }
}

func extractRootTabViewController(_ viewController: UIViewController) -> UIViewController {
  guard
    let navigationController = viewController as? UINavigationController,
    navigationController.viewControllers.count == 1,
    let nestedViewController = navigationController.viewControllers.first else {
    return viewController
  }

  return nestedViewController
}

