import KsApi
import Library
import Prelude
import UIKit

/// View controller displaying an existing pledge's summary, payment method, payment schedule, and management actions.
final class ManagePledgeViewController: UIViewController, MessageBannerViewControllerPresenting {
  weak var delegate: ManagePledgeViewControllerDelegate?
  let viewModel: ManagePledgeViewModelType = ManagePledgeViewModel()

  // MARK: - Properties

  internal lazy var tableView: UITableView = {
    UITableView(frame: .zero)
      |> \.alwaysBounceVertical .~ true
      |> \.dataSource .~ self.dataSource
      |> \.rowHeight .~ UITableView.automaticDimension
      |> \.tableFooterView .~ UIView(frame: .zero)
  }()

  private let dataSource = ManagePledgeDataSource()

  lazy var closeButton: UIBarButtonItem = {
    UIBarButtonItem(
      image: image(named: "icon--cross"),
      style: .plain,
      target: self,
      action: #selector(ManagePledgeViewController.closeButtonTapped)
    )
  }()

  lazy var headerView: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var menuButton: UIBarButtonItem = {
    UIBarButtonItem(
      image: image(named: "icon--more-menu"),
      style: .plain,
      target: self,
      action: #selector(ManagePledgeViewController.menuButtonTapped)
    )
  }()

  internal var messageBannerViewController: MessageBannerViewController?

  lazy var paymentMethodSectionSeparator: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var paymentMethodView: ManagePledgePaymentMethodView = {
    ManagePledgePaymentMethodView(frame: .zero)
      |> \.delegate .~ self
  }()

  lazy var paymentMethodViews = { [self.paymentMethodView, self.paymentMethodSectionSeparator] }()

  lazy var plotPaymentScheduleViewController: PledgeOverTimePaymentScheduleViewController = {
    let controller = PledgeOverTimePaymentScheduleViewController.instantiate()
    controller.delegate = self
    return controller
  }()

  lazy var plotPaymentScheduleSectionSeparator: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var plotPaymentScheduleStackView = { UIStackView(frame: .zero) }()
  lazy var pledgeDetailsSectionLabel: UILabel = { UILabel(frame: .zero) }()
  lazy var pledgeDetailsSectionViews = { [self.pledgeDetailsSectionLabel] }()

  lazy var pledgeSummaryViewController: ManagePledgeSummaryViewController = {
    ManagePledgeSummaryViewController.instantiate()
  }()

  lazy var pledgeSummarySectionViews = {
    [self.pledgeSummaryViewController.view, self.pledgeSummarySectionSeparator]
  }()

  lazy var pledgeSummarySectionSeparator: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var pullToRefreshImageView: UIImageView = {
    UIImageView(image: image(named: "icon--refresh-small"))
  }()

  lazy var pullToRefreshLabel: UILabel = { UILabel(frame: .zero) }()

  lazy var pullToRefreshHeaderView: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var pullToRefreshStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var refreshControl: UIRefreshControl = { UIRefreshControl() }()

  lazy var rootStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var sectionSeparatorViews = {
    [
      self.pledgeSummarySectionSeparator,
      self.paymentMethodSectionSeparator,
      self.plotPaymentScheduleSectionSeparator
    ]
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    _ = self.navigationItem
      ?|> \.leftBarButtonItem .~ self.closeButton
      ?|> \.rightBarButtonItem .~ self.menuButton

    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)
    self.tableView.registerCellClass(RewardTableViewCell.self)
    self.refreshControl.addTarget(
      self,
      action: #selector(ManagePledgeViewController.beginRefresh),
      for: .valueChanged
    )

    self.configureViews()
    self.viewModel.inputs.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tableView.ksr_sizeHeaderFooterViewsToFit()
  }

  // MARK: - View model

  override func bindViewModel() {
    super.bindViewModel()

    self.pledgeDetailsSectionLabel.rac.text = self.viewModel.outputs.pledgeDetailsSectionLabelText

    self.viewModel.outputs.paymentMethodViewHidden
      .observeForUI()
      .observeValues { [weak self] hidden in self?.paymentMethodViews.forEach { $0.isHidden = hidden } }

    self.viewModel.outputs.rightBarButtonItemHidden
      .observeForUI()
      .observeValues { [weak self] hidden in
        self?.navigationItem.rightBarButtonItem = hidden ? nil : self?.menuButton
      }

    self.viewModel.outputs.title
      .observeForUI()
      .observeValues { [weak self] title in
        guard let self = self else { return }
        _ = self |> \.title .~ title
      }

    self.viewModel.outputs.configurePaymentMethodView
      .observeForUI()
      .observeValues { [weak self] backing in self?.paymentMethodView.configure(with: backing) }

    self.viewModel.outputs.configurePledgeSummaryView
      .observeForUI()
      .observeValues { [weak self] data in self?.pledgeSummaryViewController.configureWith(data) }

    self.viewModel.outputs.loadProjectAndRewardsIntoDataSource
      .observeForUI()
      .observeValues { [weak self] project, rewards in
        self?.dataSource.load(project: project, rewards: rewards)
        self?.configureHeaderView()
        self?.tableView.reloadData()
        self?.tableView.setNeedsLayout()
      }

    self.viewModel.outputs.loadPullToRefreshHeaderView
      .observeForUI()
      .observeValues { [weak self] in
        self?.dataSource.clearValues()
        self?.configurePullToRefreshHeaderView()
      }

    self.viewModel.outputs.startRefreshing
      .observeForUI()
      .observeValues { [weak self] in self?.refreshControl.ksr_beginRefreshing() }

    self.viewModel.outputs.endRefreshing
      .observeForUI()
      .observeValues { [weak self] in self?.refreshControl.endRefreshing() }

    self.viewModel.outputs.showActionSheetMenuWithOptions
      .observeForControllerAction()
      .observeValues { [weak self] options in self?.showActionSheetMenuWithOptions(options) }

    self.viewModel.outputs.goToRewards
      .observeForControllerAction()
      .observeValues { [weak self] project in self?.goToRewards(project) }

    self.viewModel.outputs.goToEditPledgeOverTime
      .observeForControllerAction()
      .observeValues { [weak self] project in self?.goToRewards(project) }

    self.viewModel.outputs.goToChangePaymentMethod
      .observeForControllerAction()
      .observeValues { [weak self] data in self?.goToChangePaymentMethod(data: data) }

    self.viewModel.outputs.goToFixPaymentMethod
      .observeForControllerAction()
      .observeValues { [weak self] data in self?.goToFixPaymentMethod(data: data) }

    self.viewModel.outputs.goToContactCreator
      .observeForControllerAction()
      .observeValues { [weak self] messageSubject, context in
        self?.goToContactCreator(messageSubject: messageSubject, context: context)
      }

    self.viewModel.outputs.goToCancelPledge
      .observeForControllerAction()
      .observeValues { [weak self] data in self?.goToCancelPledge(with: data) }

    self.viewModel.outputs.notifyDelegateManagePledgeViewControllerFinishedWithMessage
      .observeForUI()
      .observeValues { [weak self] message in
        guard let self = self else { return }
        self.delegate?.managePledgeViewController(self, managePledgeViewControllerFinishedWithMessage: message)
      }

    self.viewModel.outputs.showSuccessBannerWithMessage
      .observeForControllerAction()
      .observeValues { [weak self] message in
        self?.messageBannerViewController?.showBanner(with: .success, message: message)
      }

    self.viewModel.outputs.showErrorBannerWithMessage
      .observeForControllerAction()
      .observeValues { [weak self] errorMessage in
        self?.messageBannerViewController?.showBanner(with: .error, message: errorMessage)
      }

    self.plotPaymentScheduleStackView.rac.hidden = self.viewModel.outputs.plotPaymentScheduleViewHidden

    self.viewModel.outputs.configurePlotPaymentScheduleView
      .observeForUI()
      .observeValues { [weak self] increments in self?.plotPaymentScheduleViewController.configure(with: increments) }

    self.viewModel.outputs.showWebHelp
      .observeForControllerAction()
      .observeValues { [weak self] helpType in
        self?.presentHelpWebViewController(with: helpType, presentationStyle: .formSheet)
      }
  }

  // MARK: - Configuration

  /// Configures the manage pledge view model with project and backing identifiers.
  func configureWith(params: ManagePledgeViewParamConfigData) {
    self.viewModel.inputs.configureWith(params)
  }

  /// Toggles the collapsed state of the `PledgeOverTimePaymentScheduleViewController` via its `collapseToggle` function.
  /// This is used specifically in UI tests to simulate user interaction and verify correct behavior
  /// during transitions between collapsed and expanded states.
  ///
  /// This method directly interacts with the `PledgeOverTimePaymentScheduleViewController` to test collapse functionality.
  public func plotPaymentScheduleToggle() {
    self.plotPaymentScheduleViewController.collapseToggle()
  }

  // MARK: Actions

  @objc private func menuButtonTapped() { self.viewModel.inputs.menuButtonTapped() }
  @objc private func beginRefresh() { self.viewModel.inputs.beginRefresh() }

  @objc func closeButtonTapped() {
    self.dismiss(animated: true)
    self.delegate?.managePledgeViewControllerDidDismiss(self)
  }
}
