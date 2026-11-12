import KsApi
import Library
import Prelude
import UIKit

extension RewardsCollectionViewController {
  func scrollToReward(atIndexPath indexPath: IndexPath) {
    let rewardCount = self.collectionView.numberOfItems(inSection: indexPath.section)

    guard indexPath.row < rewardCount else {
      assert(false, "scrollToReward(atIndexPath:) tried to scroll out-of-bounds.")
      return
    }

    self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
  }

  func setupConstraints() {
    _ = self.collectionView
      |> \.translatesAutoresizingMaskIntoConstraints .~ false

    NSLayoutConstraint.activate([
      self.headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.rewardsCollectionFooterView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.rewardsCollectionFooterView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.rewardsCollectionFooterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor)
    ])

    self.collectionViewBottomConstraintFooterView = self.collectionView.bottomAnchor
      .constraint(equalTo: self.rewardsCollectionFooterView.topAnchor)
    self.collectionViewBottomConstraintSuperview = self.collectionView.bottomAnchor
      .constraint(equalTo: self.view.bottomAnchor)
  }

  func calculateItemSize(
    from layout: UICollectionViewFlowLayout,
    using collectionView: UICollectionView
  ) -> CGSize {
    let sectionInsets = layout.sectionInset
    let adjustedContentInset = collectionView.adjustedContentInset

    let topBottomSectionInsets = sectionInsets.top + sectionInsets.bottom
    let leftRightSectionInsets = sectionInsets.left + sectionInsets.right
    let topBottomContentInsets = adjustedContentInset.top + adjustedContentInset.bottom

    let itemHeight = collectionView.frame.height - topBottomSectionInsets - topBottomContentInsets
    let widthByBounds = collectionView.bounds.width - leftRightSectionInsets
    let itemWidth = min(CheckoutConstants.RewardCard.Layout.width, widthByBounds)

    return CGSize(width: itemWidth, height: itemHeight)
  }

  func configureRewardsCollectionViewFooter(with count: Int) {
    self.rewardsCollectionFooterView.configure(with: count)
  }

  func updateRewardCollectionViewFooterConstraints(_ isHidden: Bool) {
    _ = self.collectionViewBottomConstraintSuperview
      ?|> \.isActive .~ isHidden

    _ = self.collectionViewBottomConstraintFooterView
      ?|> \.isActive .~ !isHidden
  }

  func goToAddOnSelection(data: PledgeViewData) {
    let vc = RewardAddOnSelectionViewController.instantiate()
    vc.pledgeViewDelegate = self.pledgeViewDelegate
    vc.configure(with: data)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func showEditRewardConfirmationPrompt(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let continueAction = UIAlertAction(title: Strings.Yes_continue(), style: .default) { [weak self] _ in
      self?.viewModel.inputs.confirmedEditReward()
    }

    alert.addAction(continueAction)
    alert.addAction(UIAlertAction(title: Strings.No_go_back(), style: .cancel))
    alert.preferredAction = continueAction

    self.present(alert, animated: true)
  }
}

// MARK: - UICollectionViewDelegate

extension RewardsCollectionViewController {
  override func collectionView(
    _: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt _: IndexPath
  ) {
    if let rewardCell = cell as? RewardCell {
      rewardCell.delegate = self
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RewardsCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt _: IndexPath
  ) -> CGSize {
    guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
      return .zero
    }

    layout.itemSize = self.calculateItemSize(from: layout, using: collectionView)

    return layout.itemSize
  }
}

// MARK: - RewardCellDelegate

extension RewardsCollectionViewController: RewardCellDelegate {
  func rewardCellDidTapPledgeButton(_: RewardCell, rewardId: Int) {
    self.viewModel.inputs.rewardSelected(with: rewardId)
  }

  func rewardCell(_: RewardCell, shouldShowDividerLine show: Bool) {
    self.viewModel.inputs.rewardCellShouldShowDividerLine(show)
  }
}

// MARK: - PledgeShippingLocationViewControllerDelegate

extension RewardsCollectionViewController: PledgeShippingLocationViewControllerDelegate {
  func pledgeShippingLocationViewController(
    _: PledgeShippingLocationViewController,
    didSelect location: Location?
  ) {
    self.viewModel.inputs.shippingLocationSelected(location)
  }

  func pledgeShippingLocationViewControllerFailedToLoad(_: PledgeShippingLocationViewController) {
    self.viewModel.inputs.shippingLocationViewDidFailToLoad()
  }
}

extension RewardsCollectionViewController {
  /// Instantiates a rewards collection controller for creating a new pledge.
  public static func rewardsController(
    with project: Project,
    refTag: RefTag?,
    secretRewardToken: String?
  ) -> UIViewController {
    return RewardsCollectionViewController
      .instantiate(
        with: project,
        refTag: refTag,
        context: .createPledge,
        secretRewardToken: secretRewardToken
      )
  }

  /// Instantiates a modal navigation controller wrapping `RewardsCollectionViewController` with a dismiss button.
  public static func navigationController(
    with project: Project,
    refTag: RefTag?,
    secretRewardToken: String?
  ) -> UINavigationController {
    let rewardsCollectionViewController = RewardsCollectionViewController
      .instantiate(
        with: project,
        refTag: refTag,
        context: .createPledge,
        secretRewardToken: secretRewardToken
      )

    let closeButton = UIBarButtonItem(
      image: image(named: "icon--cross"),
      style: .plain,
      target: rewardsCollectionViewController,
      action: #selector(RewardsCollectionViewController.closeButtonTapped)
    )

    closeButton.accessibilityLabel = Strings.Dismiss()

    rewardsCollectionViewController.navigationItem.setLeftBarButton(closeButton, animated: false)

    let navigationController = RewardPledgeNavigationController(
      rootViewController: rewardsCollectionViewController
    )

    if AppEnvironment.current.device.userInterfaceIdiom == .pad {
      navigationController.modalPresentationStyle = .pageSheet
    }

    return navigationController
  }
}

