import Experimentation
import KDS
import KsApi
import Library
import Prelude
import ServerDrivenUI
import SwiftUI
import UIKit

/// Styling and layout constants for `ProjectPageViewController`.
public enum ProjectPageViewControllerStyles {
  /// Layout measurements used across project page views and shadows.
  public enum Layout {
    /// Height of the navigation selector drop shadow line.
    public static let projectNavigationSelectorShadowViewHeight: CGFloat = 1
    /// Opacity of the navigation selector shadow.
    public static let projectNavigationSelectorShadowOpacity: Float = 0.35
    /// Vertical offset adjustment for the navigation selector shadow.
    public static let projectNavigationSelectorShadowVerticalOriginModifier: CGFloat = -1
    /// Navigation selector height when displayed in a form sheet.
    public static let projectNavigationSelectorHeightFormSheet: CGFloat = 60
    /// Navigation selector height when displayed fullscreen.
    public static let projectNavigationSelectorHeightFullscreen: CGFloat = 70
    /// Footer height spacer for the project page table view.
    public static let tableFooterViewHeight: CGFloat = 1
  }
}

protocol AudioVideoViewControllerPlaybackDelegate: AnyObject {
  func pauseAudioVideoPlayback()
}

/// Displays a project's overview, campaign story, FAQs, risks, and pledge CTA controls.
public final class ProjectPageViewController: UIViewController, MessageBannerViewControllerPresenting {
  // MARK: Properties

  internal let dataSource = ProjectPageViewControllerDataSource()
  internal let viewModel: ProjectPageViewModelType = ProjectPageViewModel()
  internal var navigation: ProjectPageNavigation = ProjectPageNavigation()

  internal let pledgeCTAContainerView: PledgeCTAContainerView = {
    PledgeCTAContainerView(frame: .zero) |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  internal let projectNavigationSelectorView: ProjectNavigationSelectorView = {
    ProjectNavigationSelectorView(frame: .zero) |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  internal let projectNavigationShadowView: UIView = {
    UIView(frame: .zero) |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  internal lazy var tableView: UITableView = {
    UITableView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  internal let storyRichTextHostingController = UIHostingController(rootView: ScrollView {
    RichTextView(element: [])
  })

  internal weak var playbackDelegate: AudioVideoViewControllerPlaybackDelegate?
  /// Banner view controller used to present transient status messages.
  public var messageBannerViewController: MessageBannerViewController?
  internal var pinchToZoomData: PinchToZoomData?
  internal var overlayView: OverlayView? = OverlayView(frame: .zero)
  internal var richTextViewConstraints: [NSLayoutConstraint] = []

  // We don't actually switch anything on these experiment values, since they're just A/A tests.
  // Saved to properties so the Swift compiler will not prune them as dead code.
  private var nullExperimentValue1: Bool?
  private var nullExperimentValue2: Bool?

  static var projectPageModalPresentationStyle: UIModalPresentationStyle {
    return .fullScreen
  }

  static func navigationController(withViewControllers viewControllers: [UIViewController])
    -> UINavigationController {
    let nav = NavigationController()
    nav.viewControllers = viewControllers

    let modalPresentationStyle = ProjectPageViewController.projectPageModalPresentationStyle
    nav.modalPresentationStyle = modalPresentationStyle

    if modalPresentationStyle == .fullScreen {
      nav.view.backgroundColor = Colors.Background.Surface.primary.uiColor()
    }

    return nav
  }

  /// Creates a navigation controller containing a configured `ProjectPageViewController`.
  public static func navigationController(
    withProjectOrParam projectOrParam: Either<Project, any ProjectPageParam>,
    refInfo: RefInfo?,
    secretRewardToken: String? = nil
  ) -> UINavigationController {
    let vc = ProjectPageViewController.configuredWith(
      projectOrParam: projectOrParam,
      refInfo: refInfo,
      secretRewardToken: secretRewardToken
    )

    return ProjectPageViewController.navigationController(withViewControllers: [vc])
  }

  /// Instantiates and configures a `ProjectPageViewController` for a project or lookup parameter.
  public static func configuredWith(
    projectOrParam: Either<Project, any ProjectPageParam>,
    refInfo: RefInfo?,
    secretRewardToken: String? = nil
  ) -> ProjectPageViewController {
    let vc = ProjectPageViewController.instantiate()

    vc.viewModel.inputs.configureWith(
      projectOrParam: projectOrParam,
      refInfo: refInfo,
      secretRewardToken: secretRewardToken
    )

    return vc
  }

  /// Configures subviews, table cells, notification observers, and notifies the view model.
  public override func viewDidLoad() {
    super.viewDidLoad()

    self.extendedLayoutIncludesOpaqueBars = true
    self.view.backgroundColor = Colors.Background.Surface.primary.uiColor()

    self.configureNavigation()
    self.configurePledgeCTAContainerView()
    self.configureTableView()
    self.configureNavigationShadowView()
    self.configureNavigationSelectorView()
    self.configureRichTextView()

    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)
    self.messageBannerViewController?.delegate = self
    self.registerTableViewCells()
    self.setupNotifications()
    self.viewModel.inputs.viewDidLoad()
    self.navigation.viewDidLoad()
  }

  /// Forwards view appearance and logs null experiment evaluations.
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.viewModel.inputs.viewDidAppear(animated: animated)
    self.logNullExperiments()
  }

  private func logNullExperiments() {
    let experiment1 = NullExperimentWithUserID()
    self.nullExperimentValue1 = experiment1.boolValue(forKey: .test_parameter)

    let experiment2 = NullExperimentWithAnonymousID()
    self.nullExperimentValue2 = experiment2.boolValue(forKey: .test_parameter)
  }

  /// Cancels active image fetches when the view disappears.
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    UIImageView.ksr_stopFetchingImages()
  }

  /// Activates Auto Layout constraints across project page subviews.
  public override func updateViewConstraints() {
    super.updateViewConstraints()
    self.updatePledgeCTAConstraints()
    self.updateNavigationSelectorViewConstraints()
    self.updateNavigationShadowViewConstraints()
    self.updateTableViewConstraints()
    self.updateRichTextViewConstraints()
  }

  /// Applies surface and shadow styling to project page views.
  public override func bindStyles() {
    super.bindStyles()
    self.applyProjectPageStyles()
  }

  /// Binds view model output signals to UI and navigation updates.
  public override func bindViewModel() {
    super.bindViewModel()
    self.bindProjectPageViewModel()
  }

  // MARK: - Selectors

  @objc internal func didBackProject() {
    self.viewModel.inputs.didBackProject()
  }

  @objc internal func pledgeRetryButtonTapped() {
    self.viewModel.inputs.pledgeRetryButtonTapped()
  }

  @objc internal func userSessionStarted() {
    self.viewModel.inputs.userSessionStarted()
  }

  @objc internal func appBackgrounded() {
    self.viewModel.inputs.applicationDidEnterBackground()
  }
}
