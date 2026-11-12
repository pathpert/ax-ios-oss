import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Root profile view controller managing the backer header and paged lists of backed and saved projects.
internal final class BackerDashboardViewController: UIViewController {
  @IBOutlet private var avatarImageView: CircleAvatarImageView!
  @IBOutlet private var backedMenuButton: UIButton!
  @IBOutlet private var backerNameLabel: UILabel!
  @IBOutlet private var dividerView: UIView!
  @IBOutlet private var headerTopContainerView: UIView!
  @IBOutlet private var headerStackView: UIStackView!
  @IBOutlet var headerView: UIView!
  @IBOutlet var headerViewTopConstraint: NSLayoutConstraint!
  @IBOutlet var menuButtonsStackView: UIStackView!
  @IBOutlet private var messagesButtonItem: UIBarButtonItem!
  @IBOutlet private var savedMenuButton: UIButton!
  @IBOutlet var selectedButtonIndicatorLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private var selectedButtonIndicatorView: UIView!
  @IBOutlet var selectedButtonIndicatorWidthConstraint: NSLayoutConstraint!
  @IBOutlet private var settingsButtonItem: UIBarButtonItem!
  @IBOutlet var topBackgroundView: UIView!
  @IBOutlet private var containerBottomToSafeArea: NSLayoutConstraint!

  /// Bottom constraint when using the floating tab bar (full-height)
  private var containerBottomToSuperview: NSLayoutConstraint?

  weak var pageViewController: UIPageViewController?
  let viewModel: BackerDashboardViewModelType = BackerDashboardViewModel()
  var pagesDataSource: BackerDashboardPagesDataSource!

  private var panGesture = UIPanGestureRecognizer()
  private var projectSavedObserver: Any?

  internal static func instantiate() -> BackerDashboardViewController {
    return Storyboard.BackerDashboard.instantiate(BackerDashboardViewController.self)
  }

  internal override func viewDidLoad() {
    super.viewDidLoad()

    self.pageViewController = self.children
      .compactMap { $0 as? UIPageViewController }.first
    self.pageViewController?.ksr_setViewControllers(
      [.init()],
      direction: .forward,
      animated: false,
      completion: nil
    )
    self.pageViewController?.delegate = self

    _ = self.backedMenuButton
      |> UIButton.lens.targets .~ [(self, action: #selector(self.backedButtonTapped), .touchUpInside)]

    _ = self.savedMenuButton
      |> UIButton.lens.targets .~ [(self, action: #selector(self.savedButtonTapped), .touchUpInside)]

    _ = self.messagesButtonItem
      |> UIBarButtonItem.lens.targetAction .~ (self, #selector(self.messagesButtonTapped))

    _ = self.settingsButtonItem
      |> UIBarButtonItem.lens.targetAction .~ (self, #selector(self.settingsButtonTapped))

    self.panGesture.addTarget(self, action: #selector(self.handlePan))
    self.panGesture.delegate = self
    self.view.addGestureRecognizer(self.panGesture)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureNotifier))
    tapRecognizer.cancelsTouchesInView = false
    self.pageViewController?.view.addGestureRecognizer(tapRecognizer)

    self.projectSavedObserver = NotificationCenter
      .default
      .addObserver(forName: Notification.Name.ksr_projectSaved, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.projectSaved()
      }

    self.viewModel.inputs.viewDidLoad()
  }

  internal override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if self.containerBottomToSuperview == nil {
      self.setupBottomConstraints()
    }
  }

  private func setupBottomConstraints() {
    guard let containerView = self.pageViewController?.view.superview else { return }

    // Deactivate the safe area constraint defined in storyboard (explicit reference via IBOutlet)
    self.containerBottomToSafeArea.isActive = false

    // Create and activate the superview constraint to extend past safe area
    let superviewConstraint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    self.containerBottomToSuperview = superviewConstraint
    superviewConstraint.isActive = true
  }

  deinit {
    self.projectSavedObserver.doIfSome(NotificationCenter.default.removeObserver)
  }

  internal override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.inputs.viewWillAppear(animated)
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.avatarImageView.rac.ksr_imageUrl = self.viewModel.outputs.avatarURL
    self.backerNameLabel.rac.text = self.viewModel.outputs.backerNameText

    self.viewModel.outputs.backedButtonTitleText
      .observeForUI()
      .observeValues { [weak self] string in
        guard let _self = self else { return }
        _self.setAttributedTitles(for: _self.backedMenuButton, with: string)
      }

    self.viewModel.outputs.configurePagesDataSource
      .observeForControllerAction()
      .observeValues { [weak self] tab in
        self?.configurePagesDataSource(tab: tab)
      }

    self.viewModel.outputs.savedButtonTitleText
      .observeForUI()
      .observeValues { [weak self] string in
        guard let _self = self else { return }
        _self.setAttributedTitles(for: _self.savedMenuButton, with: string)
      }

    self.viewModel.outputs.goToMessages
      .observeForControllerAction()
      .observeValues { [weak self] _ in
        guard let _self = self else { return }
        let vc = MessageThreadsViewController.configuredWith(project: nil, refTag: .profile)
        _self.navigationController?.pushViewController(vc, animated: true)
      }

    self.viewModel.outputs.goToSettings
      .observeForControllerAction()
      .observeValues { [weak self] _ in self?.goToSettings() }

    self.viewModel.outputs.navigateToTab
      .observeForControllerAction()
      .observeValues { [weak self] tab in
        guard let _self = self, let controller = self?.pagesDataSource.controllerFor(tab: tab) else {
          fatalError("Controller not found for tab \(tab)")
        }
        _self.pageViewController?.ksr_setViewControllers(
          [controller],
          direction: .forward,
          animated: false,
          completion: nil
        )
      }

    self.viewModel.outputs.pinSelectedIndicatorToTab
      .observeForUI()
      .observeValues { [weak self] tab, animated in
        self?.pinSelectedIndicator(to: tab, animated: animated)
      }

    self.viewModel.outputs.postNotification
      .observeForUI()
      .observeValues(NotificationCenter.default.post)

    self.viewModel.outputs.setSelectedButton
      .observeForUI()
      .observeValues { [weak self] in self?.selectButton(atTab: $0) }

    self.viewModel.outputs.updateCurrentUserInEnvironment
      .observeForUI()
      .observeValues { [weak self] user in
        AppEnvironment.updateCurrentUser(user)
        self?.viewModel.inputs.currentUserUpdatedInEnvironment()
      }
  }

  internal override func bindStyles() {
    super.bindStyles()

    _ = self |> baseControllerStyle()
    _ = self.avatarImageView |> ignoresInvertColorsImageViewStyle
    _ = self.navigationItem |> UINavigationItem.lens.title %~ { _ in Strings.tabbar_profile() }

    self.messagesButtonItem.image = image(named: "inbox-icon")
    self.messagesButtonItem.accessibilityLabel = Strings.profile_buttons_messages()
    self.settingsButtonItem.image = image(named: "settings-icon")
    self.settingsButtonItem.accessibilityLabel = Strings.profile_settings_navbar_title()

    // If OS is too old for liquid glass theming, set color to gray.
    if #unavailable(iOS 26.0) {
      self.messagesButtonItem.tintColor = Colors.Icon.subtle.uiColor()
      self.settingsButtonItem.tintColor = Colors.Icon.subtle.uiColor()
    }

    _ = self.dividerView |> UIView.lens.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
    self.selectedButtonIndicatorView.backgroundColor = Colors.Text.primary.uiColor()

    _ = self.headerStackView
      |> UIView.lens.layoutMargins %~~ { _, view in
        view.traitCollection.isRegularRegular
          ? .init(topBottom: Styles.grid(2), leftRight: Styles.grid(20))
          : .init(top: Styles.grid(5), left: Styles.grid(2), bottom: 0.0, right: Styles.grid(2))
      }

    _ = self.backerNameLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
      |> UILabel.lens.font .~ .ksr_headline(size: 18)
  }

  @objc private func tapGestureNotifier() {
    NotificationCenter.default.post(name: Notification.Name.ksr_savedProjectEmptyStateTapped, object: nil)
  }

  @objc private func messagesButtonTapped() { self.viewModel.inputs.messagesButtonTapped() }
  @objc private func settingsButtonTapped() { self.viewModel.inputs.settingsButtonTapped() }
  @objc private func backedButtonTapped() { self.viewModel.inputs.backedProjectsButtonTapped() }
  @objc private func savedButtonTapped() { self.viewModel.inputs.savedProjectsButtonTapped() }
}
