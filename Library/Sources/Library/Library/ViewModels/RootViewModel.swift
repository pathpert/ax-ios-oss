import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model managing the root tab bar controller tabs, badge counts, deep-link tab switches, and analytics.
public final class RootViewModel: RootViewModelType, RootViewModelInputs, RootViewModelOutputs {
  /// Initializes the root view model and wires tab, badge, and analytics signals.
  public init() {
    let currentUser = Signal.merge(
      self.viewDidLoadProperty.signal,
      self.userSessionStartedProperty.signal,
      self.userSessionEndedProperty.signal,
      self.currentUserUpdatedProperty.signal
    )
    .map { _ in AppEnvironment.current.currentUser }

    let loginState: Signal<Bool, Never> = currentUser
      .map { $0 != nil }
      .skipRepeats(==)

    let lifecycleEvents = Signal.merge(
      self.viewDidLoadProperty.signal,
      self.applicationWillEnterForegroundSignal
    )

    let featuredFlagChanged = Signal.merge(
      self.viewDidLoadProperty.signal,
      self.applicationWillEnterForegroundSignal.signal
    )
    .map { _ in featureFloatingTabBarEnabled() }
    .skipRepeats()
    .skip(first: 1)

    let floatingTabBarEnabled = Signal.merge(
      self.viewDidLoadProperty.signal,
      featuredFlagChanged.ignoreValues()
    )
    .map { _ in featureFloatingTabBarEnabled() }
    .skipRepeats()

    self.floatingTabBarEnabled = floatingTabBarEnabled

    let standardViewControllers: Signal<[RootViewControllerData], Never> = Signal
      .combineLatest(loginState, floatingTabBarEnabled)
      .map { args -> [RootViewControllerData] in
        generateViewControllers(isLoggedIn: args.0, isFloatingTabBarEnabled: args.1)
      }

    self.setViewControllers = Signal.merge(
      standardViewControllers,
      Signal
        .combineLatest(loginState, floatingTabBarEnabled)
        .takeWhen(
          Signal.merge(
            self.userLocalePreferencesChangedProperty.signal,
            featuredFlagChanged.ignoreValues()
          )
        )
        .map { args -> [RootViewControllerData] in
          generateViewControllers(isLoggedIn: args.0, isFloatingTabBarEnabled: args.1)
        }
    )

    let vcCount = self.setViewControllers.map { $0.count }

    let switchToLogin = Signal.combineLatest(vcCount, loginState)
      .takeWhen(self.switchToLoginProperty.signal)
      .filter(second >>> isFalse)
      .map(first)

    let switchToProfile = Signal.combineLatest(vcCount, loginState)
      .takeWhen(self.switchToProfileProperty.signal)
      .filter { isTrue($1) }
      .map(first)

    let discoveryControllerIndex = self.setViewControllers
      .map { $0.firstIndex(of: .discovery) }
      .skipNil()

    self.filterDiscovery = discoveryControllerIndex
      .takePairWhen(self.switchToDiscoveryProperty.signal.skipNil())

    self.selectedIndex = Signal.combineLatest(
      .merge(
        self.viewDidLoadProperty.signal.mapConst(0),
        self.didSelectIndexProperty.signal,
        self.switchToActivitiesProperty.signal.mapConst(1),
        self.switchToDiscoveryProperty.signal.mapConst(0),
        self.switchToSearchProperty.signal.mapConst(2),
        switchToLogin,
        switchToProfile
      ),
      self.setViewControllers,
      self.viewDidLoadProperty.signal
    )
    .map { args in clamp(0, args.1.count - 1)(args.0) }

    let activityViewControllerIndex = self.setViewControllers
      .map { $0.firstIndex(where: \.isActivity) }
      .skipNil()
      .map { $0 as RootViewControllerIndex }

    let selectedIndexAndActivityViewControllerIndex = Signal.combineLatest(
      self.selectedIndex,
      activityViewControllerIndex
    )

    let badgeSignals = makeRootBadgeSignals(
      activityViewControllerIndex: activityViewControllerIndex,
      selectedIndexAndActivityViewControllerIndex: selectedIndexAndActivityViewControllerIndex,
      lifecycleEvents: lifecycleEvents,
      currentUserUpdated: self.currentUserUpdatedProperty.signal,
      didReceiveBadgeValue: self.didReceiveBadgeValueSignal,
      userSessionEnded: self.userSessionEndedProperty.signal
    )

    self.setBadgeValueAtIndex = Signal.merge(
      badgeSignals.integerBadgeValueAndIndex,
      badgeSignals.integerBadgeValueAndIndex.takeWhen(self.voiceOverStatusDidChangeProperty.signal)
    )
    .map { args in
      let hasPPOAction = AppEnvironment.current.currentUserPPOSettings?.hasAction ?? false
      return RootTabBarItemBadgeValueData(
        value: activitiesBadgeValue(with: args.0, hasPPOAction: hasPPOAction),
        index: args.1
      )
    }

    badgeSignals.currentBadgeValue <~ self.setBadgeValueAtIndex.map(\.value)

    self.updateUserInEnvironment = badgeSignals.clearBadgeValueOnActivitiesTabSelected
      .filter { _ in AppEnvironment.current.currentUser != nil }
      .switchMap { _ in
        updatedUserWithClearedActivityCountProducer()
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      }

    let shouldSelectIndex = self.shouldSelectIndexProperty.signal.skipNil()

    self.scrollToTop = self.selectedIndex
      .takePairWhen(shouldSelectIndex)
      .filter { prev, next in prev == next }
      .map { $1 }

    self.tabBarItemsData = Signal.combineLatest(
      currentUser,
      floatingTabBarEnabled,
      .merge(
        self.viewDidLoadProperty.signal,
        featuredFlagChanged.ignoreValues(),
        self.userLocalePreferencesChangedProperty.signal
      )
    )
    .map { args in tabData(forUser: args.0, isFloatingTabBarEnabled: args.1) }

    // MARK: Tracking

    let prevSelectedIndex = self.didSelectIndexProperty.signal.combinePrevious(0).map(first)

    let prevSelectedTabBarItem = Signal
      .combineLatest(prevSelectedIndex, self.tabBarItemsData)
      .map { args -> KSRAnalytics.TabBarItemLabel in
        let (index, data) = args
        guard index < data.items.count else { return tabBarItemLabel(for: data.items[0]) }
        return tabBarItemLabel(for: data.items[index])
      }

    let searchTabBarSelected = Signal
      .combineLatest(self.didSelectIndexProperty.signal, self.tabBarItemsData)
      .filter { index, data in index < data.items.count }
      .map { args in tabBarItemLabel(for: args.1.items[args.0]) }
      .filter { $0 == .search }

    prevSelectedTabBarItem
      .takeWhen(searchTabBarSelected)
      .skipRepeats(==)
      .observeValues { AppEnvironment.current.ksrAnalytics.trackSearchTabBarClicked(prevTabBarItemLabel: $0) }

    self.tabBarItemsData
      .combineLatest(with: prevSelectedTabBarItem.signal)
      .takePairWhen(self.didSelectIndexProperty.signal)
      .compactMap { dataAndPrevSelectedTabBarItem, index in
        let (data, prevSelectedTabBarItem) = dataAndPrevSelectedTabBarItem
        guard index < data.items.count else { return nil }
        return (tabBarItemLabel(for: data.items[index]), prevSelectedTabBarItem)
      }
      .observeValues { tabBarItemLabel, prevSelectedTabBarItemLabel in
        AppEnvironment.current.ksrAnalytics.trackTabBarClicked(
          tabBarItemLabel: tabBarItemLabel,
          previousTabBarItemLabel: prevSelectedTabBarItemLabel
        )
      }
  }

  private let (applicationWillEnterForegroundSignal, applicationWillEnterForegroundObserver)
    = Signal<(), Never>.pipe()
  /// Signals that the application will enter foreground.
  public func applicationWillEnterForeground() { self.applicationWillEnterForegroundObserver.send(value: ()) }

  private let currentUserUpdatedProperty = MutableProperty(())
  /// Signals that the current user was updated.
  public func currentUserUpdated() { self.currentUserUpdatedProperty.value = () }

  private let (didReceiveBadgeValueSignal, didReceiveBadgeValueObserver) = Signal<Int?, Never>.pipe()
  /// Updates the badge value received via push notification.
  public func didReceiveBadgeValue(_ value: Int?) { self.didReceiveBadgeValueObserver.send(value: value) }

  private let didSelectIndexProperty = MutableProperty(0)
  /// Notifies the view model that the tab index was selected.
  public func didSelect(index: Int) { self.didSelectIndexProperty.value = index }

  private let shouldSelectIndexProperty = MutableProperty<Int?>(nil)
  /// Notifies the view model before a tab index is selected.
  public func shouldSelect(index: Int?) { self.shouldSelectIndexProperty.value = index }

  private let switchToActivitiesProperty = MutableProperty(())
  /// Switches to the activities tab.
  public func switchToActivities() { self.switchToActivitiesProperty.value = () }

  private let switchToDiscoveryProperty = MutableProperty<DiscoveryParams?>(nil)
  /// Switches to the discovery tab and optionally applies filter parameters.
  public func switchToDiscovery(params: DiscoveryParams?) { self.switchToDiscoveryProperty.value = params }

  private let switchToLoginProperty = MutableProperty(())
  /// Switches to the login/profile tab when signed out.
  public func switchToLogin() { self.switchToLoginProperty.value = () }

  private let switchToProfileProperty = MutableProperty(())
  /// Switches to the profile tab when signed in.
  public func switchToProfile() { self.switchToProfileProperty.value = () }

  private let switchToSearchProperty = MutableProperty(())
  /// Switches to the search tab.
  public func switchToSearch() { self.switchToSearchProperty.value = () }

  private let userLocalePreferencesChangedProperty = MutableProperty(())
  /// Signals that user locale preferences changed and tabs should reload.
  public func userLocalePreferencesChanged() { self.userLocalePreferencesChangedProperty.value = () }

  private let userSessionStartedProperty = MutableProperty(())
  /// Signals that a user session started.
  public func userSessionStarted() { self.userSessionStartedProperty.value = () }

  private let userSessionEndedProperty = MutableProperty(())
  /// Signals that a user session ended.
  public func userSessionEnded() { self.userSessionEndedProperty.value = () }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the root view loaded.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  private let voiceOverStatusDidChangeProperty = MutableProperty(())
  /// Signals that VoiceOver enabled status changed.
  public func voiceOverStatusDidChange() { self.voiceOverStatusDidChangeProperty.value = () }

  /// Emits when the discovery VC should filter with specific params.
  public let filterDiscovery: Signal<(RootViewControllerIndex, DiscoveryParams), Never>
  /// Emits a controller index that should be scrolled to the top.
  public let scrollToTop: Signal<RootViewControllerIndex, Never>
  /// Emits an index that the tab bar should be switched to.
  public let selectedIndex: Signal<RootViewControllerIndex, Never>
  /// Emits the badge value to be set at a particular tab index.
  public let setBadgeValueAtIndex: Signal<RootTabBarItemBadgeValueData, Never>
  /// Emits the array of view controllers that should be set on the tab bar.
  public let setViewControllers: Signal<[RootViewControllerData], Never>
  /// Emits data for setting tab bar item styles.
  public let tabBarItemsData: Signal<TabBarItemsData, Never>
  /// Emits a User that can be used to replace the current user in the environment.
  public let updateUserInEnvironment: Signal<User, Never>
  /// Emits when the floating tab bar feature is enabled or disabled.
  public let floatingTabBarEnabled: Signal<Bool, Never>

  /// View model inputs.
  public var inputs: RootViewModelInputs { return self }
  /// View model outputs.
  public var outputs: RootViewModelOutputs { return self }
}
