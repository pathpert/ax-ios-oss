import Combine
import Foundation
import KDS
import KsApi
import Library
import Prelude
import Stripe
import SwiftUI

/// Container controller paging between Pledged Projects Overview alerts and the activity feed.
public class PPOContainerViewController: PagedContainerViewController<PPOContainerViewController.Page>,
  MessageBannerViewControllerPresenting {
  internal let viewModel = PPOContainerViewModel()

  /// Initializes the paged child view controllers and binds PPO badge/banner streams.
  public override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = Colors.Background.Surface.primary.uiColor()
    self.title = Strings.tabbar_activity()

    let ppoView = PPOView(
      shouldRefresh: self.viewModel.shouldRefresh,
      onCountChange: { [weak self] count in
        self?.viewModel.projectAlertsCountChanged(count)
      },
      onHandleEvent: { [weak self] event in
        self?.viewModel.handle(preparedEvent: event)
      }
    )
    let ppoViewController = UIHostingController(rootView: ppoView)
    ppoViewController.title = Page.projectAlerts(.none).name

    let activitiesViewController = ActivitiesViewController.instantiate()
    activitiesViewController.title = Page.activityFeed(.none).name

    self.setPagedViewControllers([
      (.projectAlerts(.none), ppoViewController),
      (.activityFeed(.none), activitiesViewController)
    ])

    /// Select Activity Feed if the user has unseen activity.
    if (AppEnvironment.current.currentUser?.unseenActivityCount ?? 0) > 0 {
      self.selectPage(.activityFeed(.none))
    }

    // Update badges in the paging tab bar at the top of the view
    Publishers.CombineLatest(
      self.viewModel.projectAlertsBadge,
      self.viewModel.activityBadge
    )
    .map { projectAlerts, activity in
      let projectAlerts = Page.projectAlerts(projectAlerts)
      let activityFeed = Page.activityFeed(activity)
      return (projectAlerts, activityFeed)
    }
    .sink { [weak self, weak ppoViewController, weak activitiesViewController] projectAlerts, activityFeed in
      guard let self, let ppoViewController, let activitiesViewController else {
        return
      }
      ppoViewController.title = projectAlerts.name
      activitiesViewController.title = activityFeed.name
      self.setPagedViewControllers([
        (projectAlerts, ppoViewController),
        (activityFeed, activitiesViewController)
      ])
    }
    .store(in: &self.subscriptions)

    // On the first 3DS challenge, set up the Stripe SDK
    self.viewModel.stripeConfiguration
      .first()
      .sink { publishableKey, merchantIdentifier in
        STPAPIClient.shared.publishableKey = publishableKey
        STPAPIClient.shared.configuration.appleMerchantIdentifier = merchantIdentifier
      }
      .store(in: &self.subscriptions)

    self.viewModel.preparedEvents.sink { [weak self] event in
      self?.handleEvent(event)
    }.store(in: &self.subscriptions)

    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)

    self.viewModel.showBanner
      // This delay is due to a nuance about SwiftUI, where the List we use is backed by a
      // UITableView which is inserted into the UIView hierarchy at a different level than
      // the hosting view. If we run this notification immediately, the table view will
      // update right after, which will push the table view above the message banner in
      // the view hierarchy, causing the banner to be displayed below the table, leading
      // to clipping. This delay causes the banner to not show until after the table's
      // animation has already fired, preventing the reordering issue.
      .delay(for: 0.1, scheduler: RunLoop.main)
      .sink { [weak self] configuration in
        guard let self, let messageBannerViewController = self.messageBannerViewController else { return }
        messageBannerViewController.showBanner(with: configuration.type, message: configuration.message)

        // Determine feedback type based on banner type
        switch configuration.type {
        case .success, .info:
          generateNotificationSuccessFeedback()
        case .error:
          generateNotificationWarningFeedback()
        }
      }
      .store(in: &self.subscriptions)
  }

  /// Notifies the container view model when the overview appears to trigger conditional refreshes.
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.viewWillAppear()
  }

  /// Tab bar page identifiers hosted inside `PPOContainerViewController`.
  public enum Page: TabBarPage {
    case projectAlerts(TabBarBadge)
    case activityFeed(TabBarBadge)

    /// Localized title displayed in the segmented tab header.
    public var name: String {
      switch self {
      case .projectAlerts:
        Strings.Project_alerts()
      case .activityFeed:
        Strings.discovery_accessibility_toolbar_buttons_activity_label()
      }
    }

    /// Badge state displayed alongside the tab title.
    public var badge: TabBarBadge {
      switch self {
      case let .projectAlerts(badge):
        badge
      case let .activityFeed(badge):
        badge
      }
    }

    /// Stable identifier derived from the page name.
    public var id: String {
      self.name
    }
  }

  /// Hosted message banner view controller for surfaced alerts and confirmations.
  public var messageBannerViewController: MessageBannerViewController?

  private var subscriptions = Set<AnyCancellable>()
}
