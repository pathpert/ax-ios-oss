import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Presents horizontal selectable project reward cards alongside shipping location and footer summary UI.
final class RewardsCollectionViewController: UICollectionViewController {
  var collectionViewBottomConstraintSuperview: NSLayoutConstraint?
  var collectionViewBottomConstraintFooterView: NSLayoutConstraint?

  let dataSource = RewardsCollectionViewDataSource()

  var flowLayout: UICollectionViewFlowLayout? {
    return self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
  }

  lazy var headerView: RewardsCollectionViewHeaderView = {
    RewardsCollectionViewHeaderView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  /// The bottom-up modal for selecting a new shipping location
  lazy var pledgeShippingLocationViewController = {
    PledgeShippingLocationViewController.instantiate()
      |> \.delegate .~ self
      |> \.view.layoutMargins .~ .init(all: Styles.grid(3))
  }()

  let layout: UICollectionViewFlowLayout = {
    UICollectionViewFlowLayout()
      |> \.minimumLineSpacing .~ Styles.grid(3)
      |> \.minimumInteritemSpacing .~ 0
      |> \.sectionInset .~ .init(leftRight: Styles.grid(6))
      |> \.scrollDirection .~ .horizontal
  }()

  lazy var navigationBarShadowImage: UIImage? = {
    UIImage(in: CGRect(x: 0, y: 0, width: 1, height: 0.5), with: LegacyColors.ksr_support_400.uiColor())
  }()

  /// Delegate forwarded to presented pledge and add-on flow controllers.
  public weak var pledgeViewDelegate: PledgeViewControllerDelegate?

  lazy var rewardsCollectionFooterView: RewardsCollectionViewFooter = {
    RewardsCollectionViewFooter(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  let viewModel: RewardsCollectionViewModelType = RewardsCollectionViewModel()

  static func instantiate(
    with project: Project,
    refTag: RefTag?,
    context: RewardsCollectionViewContext,
    secretRewardToken: String? = nil
  ) -> RewardsCollectionViewController {
    let rewardsCollectionVC = RewardsCollectionViewController()
    rewardsCollectionVC.viewModel.inputs.configure(
      with: project,
      refTag: refTag,
      context: context,
      secretRewardToken: secretRewardToken
    )

    let shippingData = PledgeShippingLocationViewData(withProject: project)
    rewardsCollectionVC.pledgeShippingLocationViewController.configureWith(value: shippingData)

    return rewardsCollectionVC
  }

  init() {
    super.init(collectionViewLayout: self.layout)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configureNavigationBarForPledgeFlow()

    _ = self
      |> \.extendedLayoutIncludesOpaqueBars .~ true

    _ = self.collectionView
      |> \.dataSource .~ self.dataSource

    _ = (self.headerView, self.view)
      |> ksr_addSubviewToParent()

    /// Adding this to the CollectionView Header's rootStackView from here so that we can handle the shipping view's delegates from this view controller.
    _ = ([self.pledgeShippingLocationViewController.view], self.headerView.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    self.addChild(self.pledgeShippingLocationViewController)
    self.pledgeShippingLocationViewController.didMove(toParent: self)

    _ = (self.rewardsCollectionFooterView, self.view)
      |> ksr_addSubviewToParent()

    self.collectionView.register(RewardCell.self)
    self.collectionView.register(RewardCardLoadingCell.self)

    self.collectionView.register(
      RewardsCollectionViewHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: RewardsCollectionViewHeaderView.defaultReusableId
    )

    self.setupConstraints()
    self.viewModel.inputs.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.viewModel.inputs.viewDidAppear()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    guard let layout = self.flowLayout else { return }

    self.headerView.layoutIfNeeded()

    let itemSize = self.calculateItemSize(from: layout, using: self.collectionView)

    if itemSize != layout.itemSize {
      layout.itemSize = itemSize
      layout.invalidateLayout()
    } else {
      self.viewModel.inputs.viewDidLayoutSubviews()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.inputs.viewWillAppear()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.viewModel.inputs.traitCollectionDidChange(self.traitCollection)
  }

  override func bindStyles() {
    super.bindStyles()

    _ = self.view |> checkoutBackgroundStyle
    _ = self.headerView
      |> \.backgroundColor .~ LegacyColors.ksr_alert.uiColor()
      |> \.layoutMargins .~ .init(all: Styles.grid(3))
    _ = self.collectionView
      |> collectionViewStyle
      |> checkoutBackgroundStyle
  }

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.title
      .observeForUI()
      .observeValues { [weak self] title in _ = self ?|> \.title .~ title }

    self.viewModel.outputs.reloadDataWithValues
      .observeForUI()
      .observeValues { [weak self] values in
        self?.dataSource.load(values)
        self?.collectionView.reloadData()
      }

    self.viewModel.outputs.scrollToRewardIndexPath
      .observeForUI()
      .observeValues { [weak self] indexPath in self?.scrollToReward(atIndexPath: indexPath) }

    self.viewModel.outputs.goToAddOnSelection
      .observeForControllerAction()
      .observeValues { [weak self] data in self?.goToAddOnSelection(data: data) }

    self.viewModel.outputs.goToCustomizeYourReward
      .observeForControllerAction()
      .observeValues { [weak self] data in
        guard let self else { return }
        /// Goes to screen that only has the pledge amount or bonus amount selectors
        self.goToAddOnSelection(data: data)
      }

    self.viewModel.outputs.showPlaceholderRewardCards
      .observeForUI()
      .observeValues { [weak self] rewardsCount in
        guard let self else { return }
        self.dataSource.isLoading(rewardsCount: rewardsCount)
        self.collectionView.reloadData()
      }

    self.viewModel.outputs.rewardsCollectionViewFooterIsHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        self?.updateRewardCollectionViewFooterConstraints(isHidden)
      }

    self.viewModel.outputs.configureRewardsCollectionViewFooterWithCount
      .observeForUI()
      .observeValues { [weak self] count in
        self?.configureRewardsCollectionViewFooter(with: count)
      }

    self.viewModel.outputs.flashScrollIndicators
      .observeForUI()
      .observeValues { [weak self] in self?.collectionView.flashScrollIndicators() }

    self.rewardsCollectionFooterView.rac.hidden = self.viewModel.outputs.rewardsCollectionViewFooterIsHidden

    self.viewModel.outputs.navigationBarShadowImageHidden
      .observeForUI()
      .observeValues { [weak self] hidden in
        guard let self = self else { return }
        self.navigationController?.navigationBar.shadowImage = hidden
          ? UIImage()
          : self.navigationBarShadowImage
      }

    self.viewModel.outputs.showEditRewardConfirmationPrompt
      .observeForControllerAction()
      .observeValues { [weak self] title, message in
        self?.showEditRewardConfirmationPrompt(title: title, message: message)
      }
  }

  @objc func closeButtonTapped() {
    self.navigationController?.dismiss(animated: true)
  }
}

private var collectionViewStyle: CollectionViewStyle = { collectionView -> UICollectionView in
  collectionView
    |> \.allowsSelection .~ true
    |> \.showsHorizontalScrollIndicator .~ true
}
