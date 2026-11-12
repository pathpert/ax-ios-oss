import Experimentation
import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Table view controller displaying a paginated discovery feed for a single sort order and filter set.
internal final class DiscoveryPageViewController: UITableViewController,
  MessageBannerViewControllerPresenting,
  VideoFeedBannerPresenting {
  let viewModel: DiscoveryPageViewModelType = DiscoveryPageViewModel()
  let shareViewModel: ShareViewModelType = ShareViewModel()

  // MARK: - Properties

  var observers: [Any] = []
  let dataSource = DiscoveryProjectsDataSource()
  /// Delegate notified on scroll, navigation, or filter events in the discovery page feed.
  public weak var delegate: DiscoveryPageViewControllerDelegate?
  var emptyStatesController: EmptyStatesViewController?
  lazy var headerLabel = { UILabel(frame: .zero) }()
  internal var messageBannerViewController: MessageBannerViewController?
  var videoFeedVC: VideoFeedViewController?

  /// Instantiates a `DiscoveryPageViewController` configured for the given sort option.
  internal static func configuredWith(sort: DiscoveryParams.Sort) -> DiscoveryPageViewController {
    let vc = Storyboard.DiscoveryPage.instantiate(DiscoveryPageViewController.self)
    vc.viewModel.inputs.configureWith(sort: sort)
    return vc
  }

  internal override func viewDidLoad() {
    super.viewDidLoad()

    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)

    self.tableView.register(nib: Nib.DiscoveryPostcardCell)
    self.tableView.registerCellClass(PersonalizationCell.self)
    self.tableView.registerCellClass(DiscoveryProjectCardCell.self)
    self.tableView.registerCellClass(VideoFeedBannerCell.self)
    self.tableView.dataSource = self.dataSource

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.pulledToRefresh), for: .valueChanged)
    self.refreshControl = refreshControl

    self.subscribe(toNotification: .ksr_onboardingCompleted) { [weak self] _ in
      self?.viewModel.inputs.onboardingCompleted()
    }
    self.subscribe(toNotification: .ksr_sessionStarted) { [weak self] _ in
      self?.viewModel.inputs.userSessionStarted()
    }
    self.subscribe(toNotification: .ksr_sessionEnded) { [weak self] _ in
      self?.viewModel.inputs.userSessionEnded()
    }
    self.subscribe(toNotification: .ksr_environmentChanged) { [weak self] _ in
      self?.viewModel.inputs.currentEnvironmentChanged(
        environment: AppEnvironment.current.apiService.serverConfig.environment
      )
    }
    self.subscribe(toNotification: StatsigLoadedNotification) { [weak self] _ in
      self?.viewModel.inputs.configUpdated()
    }
    self.subscribe(toNotification: .ksr_blockedUser) { [weak self] _ in
      self?.viewModel.inputs.blockedUser()
    }

    self.configureEmptyStatesController()
  }

  deinit {
    self.observers.forEach { NotificationCenter.default.removeObserver($0) }
  }

  internal override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.inputs.viewWillAppear()
  }

  internal override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.viewModel.inputs.viewDidAppear()
  }

  internal override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.viewModel.inputs.viewDidDisappear(animated: animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tableView.ksr_sizeHeaderFooterViewsToFit()
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.projectsAreLoadingAnimated
      .observeForUI()
      .observeValues { [weak self] isLoading, animated in
        DispatchQueue.main.async {
          if isLoading {
            UIView.performDiscoveryTransition(animated: true) { self?.refreshControl?.beginRefreshing() }
          } else {
            UIView.performDiscoveryTransition(animated: animated) { self?.refreshControl?.endRefreshing() }
          }
        }
      }

    self.viewModel.outputs.activitiesForSample
      .observeForUI()
      .observeValues { [weak self] activities in
        self?.dataSource.load(activities: activities)
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.asyncReloadData
      .observeForUI()
      .observeValues { [weak self] in
        DispatchQueue.main.async { self?.tableView.reloadData() }
      }

    self.viewModel.outputs.goToActivityProject
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goTo(project: $0, refTag: $1) }

    self.viewModel.outputs.goToProjectPlaylist
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goTo(project: $0, initialPlaylist: $1, refTag: $2) }

    self.viewModel.outputs.goToProjectUpdate
      .observeForControllerAction()
      .observeValues { [weak self] project, update in self?.goTo(project: project, update: update) }

    self.viewModel.outputs.projectsLoaded
      .observeForUI()
      .observeValues { [weak self] projects, params in
        self?.dataSource.load(projects: projects, params: params)
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.showOnboarding
      .observeForUI()
      .observeValues { [weak self] in
        self?.dataSource.show(onboarding: $0)
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.showPersonalization
      .observeForUI()
      .observeValues { [weak self] shouldShow in
        self?.dataSource.showPersonalization(shouldShow)
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.showVideoFeedBanner
      .observeForUI()
      .observeValues { [weak self] shouldShow in
        self?.dataSource.showVideoFeedBanner(shouldShow)
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.dismissPersonalizationCell
      .observeForUI()
      .observeValues { [weak self] _ in
        self?.dataSource.showPersonalization(false)
        let section = DiscoveryProjectsDataSource.Section.personalization.rawValue
        self?.tableView.beginUpdates()
        self?.tableView.deleteRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        self?.tableView.endUpdates()
      }

    self.viewModel.outputs.goToCuratedProjects
      .observeForUI()
      .observeValues { [weak self] categories in
        let curatedProjectsVC = CuratedProjectsViewController.instantiate()
        curatedProjectsVC.configure(with: categories, context: .discovery)
        let isIpad = AppEnvironment.current.device.userInterfaceIdiom == .pad
        let navController = NavigationController(rootViewController: curatedProjectsVC)
          |> \.modalPresentationStyle .~ (isIpad ? .formSheet : .fullScreen)
        self?.present(navController, animated: true)
      }

    self.viewModel.outputs.setScrollsToTop
      .observeForUI()
      .observeValues { [weak self] in _ = self?.tableView ?|> UIScrollView.lens.scrollsToTop .~ $0 }

    self.shareViewModel.outputs.showShareSheet
      .observeForControllerAction()
      .observeValues { [weak self] in self?.showShareSheet($0, shareContextView: $1) }

    self.viewModel.outputs.showEmptyState
      .observeForUI()
      .observeValues { [weak self] emptyState in self?.showEmptyState(emptyState) }

    self.viewModel.outputs.hideEmptyState
      .observeForUI()
      .observeValues { [weak self] in
        self?.emptyStatesController?.view.alpha = 0
        self?.emptyStatesController?.view.isHidden = true
        if let discovery = self?.parent?.parent as? DiscoveryViewController {
          discovery.setSortsEnabled(true)
        }
      }

    self.viewModel.outputs.notifyDelegateContentOffsetChanged
      .observeForUI()
      .observeValues { [weak self] offset in
        guard let self = self else { return }
        self.delegate?.discoverPageViewController(self, contentOffsetDidChangeTo: offset)
      }

    self.viewModel.outputs.goToLoginSignup
      .observeForControllerAction()
      .observeValues { [weak self] intent in
        let loginTout = LoginToutViewController.configuredWith(loginIntent: intent)
        let isIpad = AppEnvironment.current.device.userInterfaceIdiom == .pad
        let nav = UINavigationController(rootViewController: loginTout)
          |> \.modalPresentationStyle .~ (isIpad ? .formSheet : .fullScreen)
        self?.present(nav, animated: true, completion: nil)
      }

    self.viewModel.outputs.contentInset
      .observeForUI()
      .observeValues { [weak self] inset in
        guard let self = self else { return }
        _ = self.tableView |> \.contentInset .~ inset
      }
  }

  // MARK: - Accessors & Actions

  /// Updates the active discovery filter parameters on the view model.
  internal func change(filter: DiscoveryParams) {
    self.viewModel.inputs.selectedFilter(filter)
  }

  @objc private func pulledToRefresh() {
    self.viewModel.inputs.pulledToRefresh()
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.viewModel.inputs.scrollViewDidScroll(toContentOffset: scrollView.contentOffset)
  }
}
