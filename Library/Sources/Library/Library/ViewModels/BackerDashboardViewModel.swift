import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model driving the user profile Backer Dashboard tabs, stats header, and navigation actions.
public final class BackerDashboardViewModel: BackerDashboardViewModelType, BackerDashboardViewModelInputs,
  BackerDashboardViewModelOutputs {
  /// Creates a new `BackerDashboardViewModel`.
  public init() {
    self.configurePagesDataSource = self.viewDidLoadProperty.signal
      .map { .backed }

    let fetchedUserEvent = Signal.merge(
      self.projectSavedProperty.signal.ignoreValues()
        .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler),
      self.viewWillAppearProperty.signal.ignoreValues()
    )
    .switchMap { _ in
      AppEnvironment.current.apiService.fetchUserSelf()
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .prefix(SignalProducer([AppEnvironment.current.currentUser].compact()))
        .materialize()
    }

    let graphUserEvent = Signal.merge(
      self.projectSavedProperty.signal.ignoreValues()
        .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler),
      self.viewWillAppearProperty.signal.ignoreValues()
    )
    .switchMap { _ in
      AppEnvironment.current
        .apiService.fetchGraphUserSelf()
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

    let user = fetchedUserEvent.values()

    let updatedUserWithSavedProjectsCount = graphUserEvent.values()
      .map { $0.me }

    self.updateCurrentUserInEnvironment = user.skip(first: 1)
      .takePairWhen(updatedUserWithSavedProjectsCount)
      .map { user, graphEventUser in
        var updatedUserWithStarredProjectsCount = user

        updatedUserWithStarredProjectsCount.stats.starredProjectsCount = graphEventUser.stats
          .starredProjectsCount

        return updatedUserWithStarredProjectsCount
      }

    self.postNotification = self.currentUserUpdatedInEnvironmentProperty.signal
      .mapConst(Notification(name: .ksr_userUpdated, object: nil))

    self.avatarURL = user.map { URL(string: $0.avatar.large ?? $0.avatar.medium) }

    self.backedButtonTitleText = user.map { user in
      Strings.projects_count_newline_backed(projects_count: user.stats.backedProjectsCount ?? 0)
    }

    self.backerNameText = user.map { $0.name }

    self.savedButtonTitleText = updatedUserWithSavedProjectsCount.map { user in
      Strings.projects_count_newline_saved(projects_count: user.stats.starredProjectsCount ?? 0)
    }

    let swipedToTab = self.willTransitionToPageProperty.signal
      .takeWhen(self.pageTransitionCompletedProperty.signal.filter(isTrue))
      .map { BackerDashboardTab.allTabs[$0] }

    self.navigateToTab = Signal.merge(
      swipedToTab,
      self.backedProjectsButtonTappedProperty.signal.mapConst(.backed),
      self.savedProjectsButtonTappedProperty.signal.mapConst(.saved)
    )

    self.currentSelectedTabProperty <~ self.navigateToTab

    self.setSelectedButton = Signal.merge(
      self.backedButtonTitleText.skip(first: 1).mapConst(.backed).take(first: 1),
      self.navigateToTab
    )

    self.pinSelectedIndicatorToTab = Signal.merge(
      self.backedButtonTitleText.skip(first: 1).mapConst((.backed, false)).take(first: 1),
      self.navigateToTab.map { ($0, true) }.skipRepeats(==)
    )

    self.goToMessages = self.messagesButtonTappedProperty.signal

    self.goToSettings = self.settingsButtonTappedProperty.signal

    self.initialTopConstantProperty <~ self.beganPanGestureProperty.signal
      .skipNil()
      // NB: This min value accounts for when the header is collapsed by panning the header view
      // instead of the tableView.
      .map { headerTopConstant, scrollViewYOffset in
        min(headerTopConstant, -scrollViewYOffset)
      }

    self.currentSelectedTabProperty
      .signal
      .filter { $0 == .saved }
      .observeValues { _ in
        let params = DiscoveryParams.defaults |> DiscoveryParams.lens.starred .~ true
        AppEnvironment.current.ksrAnalytics.trackProfilePageFilterSelected(
          params: params
        )
      }
  }

  private let backedProjectsButtonTappedProperty = MutableProperty(())
  /// Selects the backed projects tab.
  public func backedProjectsButtonTapped() {
    self.backedProjectsButtonTappedProperty.value = ()
  }

  private let beganPanGestureProperty = MutableProperty<(CGFloat, CGFloat)?>(nil)
  /// Captures header constraint offset and scroll offset when header panning starts.
  public func beganPanGestureWith(headerTopConstant: CGFloat, scrollViewYOffset: CGFloat) {
    self.beganPanGestureProperty.value = (headerTopConstant, scrollViewYOffset)
  }

  private let currentSelectedTabProperty = MutableProperty<BackerDashboardTab>(.backed)
  /// Currently active dashboard tab.
  public var currentSelectedTab: BackerDashboardTab {
    return self.currentSelectedTabProperty.value
  }

  private let currentUserUpdatedInEnvironmentProperty = MutableProperty(())
  /// Refreshes displayed profile details after `AppEnvironment.current.currentUser` updates.
  public func currentUserUpdatedInEnvironment() {
    self.currentUserUpdatedInEnvironmentProperty.value = ()
  }

  private let initialTopConstantProperty = MutableProperty<CGFloat>(0.0)
  /// Starting top header constraint constant used during scroll panning.
  public var initialTopConstant: CGFloat {
    return self.initialTopConstantProperty.value
  }

  private let messagesButtonTappedProperty = MutableProperty(())
  /// Navigates to the user's messages inbox.
  public func messagesButtonTapped() {
    self.messagesButtonTappedProperty.value = ()
  }

  private let pageTransitionCompletedProperty = MutableProperty(false)
  /// Records completion of the dashboard page view controller swipe transition.
  public func pageTransition(completed: Bool) {
    self.pageTransitionCompletedProperty.value = completed
  }

  private let projectSavedProperty = MutableProperty(())
  /// Triggers user stats refresh after saving or unsaving a project.
  public func projectSaved() {
    self.projectSavedProperty.value = ()
  }

  private let savedProjectsButtonTappedProperty = MutableProperty(())
  /// Selects the saved projects tab.
  public func savedProjectsButtonTapped() {
    self.savedProjectsButtonTappedProperty.value = ()
  }

  private let settingsButtonTappedProperty = MutableProperty(())
  /// Navigates to Settings.
  public func settingsButtonTapped() {
    self.settingsButtonTappedProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Notifies that the dashboard view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let viewWillAppearProperty = MutableProperty(false)
  /// Notifies that the dashboard view will appear.
  public func viewWillAppear(_ animated: Bool) {
    self.viewWillAppearProperty.value = animated
  }

  private let willTransitionToPageProperty = MutableProperty<Int>(0)
  /// Tracks upcoming page transition index.
  public func willTransition(toPage nextPage: Int) {
    self.willTransitionToPageProperty.value = nextPage
  }

  /// Emits the user's avatar image URL.
  public let avatarURL: Signal<URL?, Never>
  /// Emits the formatted title for the Backed Projects tab button.
  public let backedButtonTitleText: Signal<String, Never>
  /// Emits the user's display name.
  public let backerNameText: Signal<String, Never>
  /// Emits the initial tab to configure the embedded page view controller.
  public let configurePagesDataSource: Signal<BackerDashboardTab, Never>
  /// Emits when navigating to the messages inbox.
  public let goToMessages: Signal<(), Never>
  /// Emits when navigating to settings.
  public let goToSettings: Signal<(), Never>
  /// Emits the destination tab for programmatic page changes.
  public let navigateToTab: Signal<BackerDashboardTab, Never>
  /// Emits tab selection updates and animation flags for the indicator bar.
  public let pinSelectedIndicatorToTab: Signal<(BackerDashboardTab, Bool), Never>
  /// Emits notification-related `Notification`s to post.
  public let postNotification: Signal<Notification, Never>
  /// Emits the formatted title for the Saved Projects tab button.
  public let savedButtonTitleText: Signal<String, Never>
  /// Emits the tab whose button should render as selected.
  public let setSelectedButton: Signal<BackerDashboardTab, Never>
  /// Emits fetched fresh `User` records to persist into `AppEnvironment`.
  public let updateCurrentUserInEnvironment: Signal<User, Never>

  /// Input receiver (`self`).
  public var inputs: BackerDashboardViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: BackerDashboardViewModelOutputs { return self }
}
