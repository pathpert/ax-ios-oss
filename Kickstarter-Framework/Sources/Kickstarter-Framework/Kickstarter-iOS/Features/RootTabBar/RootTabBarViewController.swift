import KsApi
import Library
import Prelude
import UIKit

/// Protocol adopted by root tab child view controllers that support scrolling to top on tab re-tap.
internal protocol TabBarControllerScrollable {
  /// Scrolls the controller's primary scroll view to its top content offset.
  func scrollToTop()
}

extension TabBarControllerScrollable where Self: UIViewController {
  func scrollToTop() {
    if let scrollView = self.view as? UIScrollView {
      scrollView.scrollToTop()
    }
  }
}

/// Root tab bar controller managing primary app navigation, user session observers, and tab bar styling.
public final class RootTabBarViewController: UITabBarController, MessageBannerViewControllerPresenting {
  private var applicationWillEnterForegroundObserver: Any?
  /// Presenter-managed message banner displayed above the tab bar.
  public var messageBannerViewController: MessageBannerViewController?
  private var sessionEndedObserver: Any?
  private var sessionStartedObserver: Any?
  private var userUpdatedObserver: Any?
  private var userLocalePreferencesChangedObserver: Any?
  private var voiceOverStatusDidChangeObserver: Any?

  let viewModel: RootViewModelType = RootViewModel()

  /// Keep the applied tab bar mode in sync with the ViewModel (single source of truth)
  /// Accounts for remote config feature flag load issues.
  var isFloatingTabBarEnabled: Bool = false
  var lastTabBarItemsData: TabBarItemsData?
  var standardTabBar: UITabBar?

  /// Initializes notification observers, banner presentation, and the root view model on load.
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self

    /// Capture the standard (non-floating) tab bar so we can revert safely if we toggle the floating tab bar off later.
    self.standardTabBar = self.tabBar

    self.applicationWillEnterForegroundObserver = NotificationCenter
      .default
      .addObserver(
        forName: UIApplication.willEnterForegroundNotification,
        object: nil, queue: nil
      ) { [weak self] _ in
        self?.viewModel.inputs.applicationWillEnterForeground()
      }

    self.sessionStartedObserver = NotificationCenter
      .default
      .addObserver(forName: Notification.Name.ksr_sessionStarted, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionStarted()
      }

    self.sessionEndedObserver = NotificationCenter
      .default
      .addObserver(forName: Notification.Name.ksr_sessionEnded, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionEnded()
      }

    self.userUpdatedObserver = NotificationCenter
      .default
      .addObserver(forName: Notification.Name.ksr_userUpdated, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.currentUserUpdated()
      }

    self.voiceOverStatusDidChangeObserver = NotificationCenter
      .default
      .addObserver(
        forName: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil, queue: nil
      ) { [weak self] _ in
        self?.viewModel.inputs.voiceOverStatusDidChange()
      }

    self.viewModel.outputs.updateUserInEnvironment
      .observeValues { user in
        AppEnvironment.updateCurrentUser(user)
        NotificationCenter.default.post(.init(name: .ksr_userUpdated))
      }

    self.userLocalePreferencesChangedObserver = NotificationCenter
      .default
      .addObserver(
        forName: Notification.Name.ksr_userLocalePreferencesChanged,
        object: nil,
        queue: nil,
        using: { [weak self] _ in
          self?.viewModel.inputs.userLocalePreferencesChanged()
        }
      )

    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)

    self.viewModel.inputs.viewDidLoad()
  }

  /// Re-applies cached tab bar item styling after the root tab bar appears.
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let data = lastTabBarItemsData else { return }
    self.setTabBarItemStyles(withData: data)
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }

  deinit {
    [
      self.applicationWillEnterForegroundObserver,
      self.sessionStartedObserver,
      self.sessionEndedObserver,
      self.userUpdatedObserver,
      self.userLocalePreferencesChangedObserver,
      self.voiceOverStatusDidChangeObserver
    ]
    .compact()
    .forEach(NotificationCenter.default.removeObserver)
  }

  /// Applies standard tab bar tint styling.
  public override func bindStyles() {
    super.bindStyles()

    _ = self.tabBar
      |> UITabBar.lens.tintColor .~ tabBarSelectedColor
      |> UITabBar.lens.barTintColor .~ tabBarTintColor
  }

  /// Binds root view model outputs to tab controllers, selection, scrolling, badges, and filters.
  public override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.floatingTabBarEnabled
      .observeForUI()
      .observeValues { [weak self] enabled in
        self?.applyFloatingTabBar(enabled: enabled)
      }

    self.viewModel.outputs.setViewControllers
      .observeForUI()
      .map { $0.map { RootTabBarViewController.viewController(from: $0) }.compact() }
      .map { $0.map(UINavigationController.init(rootViewController:)) }
      .observeValues { [weak self] in
        self?.setViewControllers($0, animated: false)
      }

    self.viewModel.outputs.selectedIndex
      .observeForUI()
      .observeValues { [weak self] in self?.selectedIndex = $0 }

    self.viewModel.outputs.scrollToTop
      .observeForControllerAction()
      .map { [weak self] index -> UIViewController? in
        guard let vcs = self?.viewControllers else { return nil }

        return vcs[clamp(0, vcs.count - 1)(index)]
      }
      .skipNil()
      .map(extractRootTabViewController)
      .observeValues(scrollTabRootToTop)

    self.viewModel.outputs.tabBarItemsData
      .observeForUI()
      .observeValues { [weak self] in self?.setTabBarItemStyles(withData: $0) }

    self.viewModel.outputs.filterDiscovery
      .observeForControllerAction()
      .map { [weak self] index, param -> (DiscoveryViewController, DiscoveryParams)? in
        self?.viewControllerAndParam(with: index, param: param)
      }
      .skipNil()
      .observeValues { $0.filter(with: $1) }

    self.viewModel.outputs.setBadgeValueAtIndex
      .observeForUI()
      .observeValues { [weak self] data in
        self?.tabBarItem(atIndex: data.index)?.badgeValue = data.value
      }
  }
}
