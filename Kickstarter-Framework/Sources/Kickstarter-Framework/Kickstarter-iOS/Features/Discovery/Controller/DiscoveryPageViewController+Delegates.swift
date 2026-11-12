import KDS
import KsApi
import Library
import Prelude
import UIKit

// MARK: - Table View & Navigation Helpers

extension DiscoveryPageViewController {
  override func tableView(
    _: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    if let cell = cell as? VideoFeedBannerCell {
      cell.delegate = self
      cell.addHostingControllerToParent(self)
      cell.horizontalInset = self.traitCollection.isRegularRegular ? Styles.grid(30) : Styles.grid(2)
    } else if let cell = cell as? DiscoveryPostcardCell {
      cell.delegate = self
    } else if let cell = cell as? ActivitySampleBackingCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? ActivitySampleFollowCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? ActivitySampleProjectCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? DiscoveryOnboardingCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? PersonalizationCell {
      cell.delegate = self
    } else if let cell = cell as? DiscoveryProjectCardCell {
      cell.delegate = self
      cell.layoutIfNeeded()
    }

    self.viewModel.inputs.willDisplayRow(
      self.dataSource.itemIndexAt(indexPath),
      outOf: self.dataSource.numberOfItems()
    )
  }

  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let project = self.dataSource.projectAtIndexPath(indexPath) {
      self.viewModel.inputs.tapped(project: project)
    } else if let activity = self.dataSource.activityAtIndexPath(indexPath) {
      self.viewModel.inputs.tapped(activity: activity)
    }
  }

  /// Presents a share sheet anchored to `shareContextView` on iPad.
  func showShareSheet(_ controller: UIActivityViewController, shareContextView: UIView?) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      controller.modalPresentationStyle = .popover
      controller.popoverPresentationController?.sourceView = shareContextView
    }
    self.present(controller, animated: true, completion: nil)
  }

  /// Presents the project page for a tapped activity sample project.
  func goTo(project: Project, refTag: RefTag) {
    let projectParam = Either<Project, any ProjectPageParam>(left: project)
    let nav = ProjectPageViewController.navigationController(
      withProjectOrParam: projectParam,
      refInfo: RefInfo(refTag)
    )
    self.present(nav, animated: true, completion: nil)
  }

  /// Presents the project page for a tapped discovery playlist project.
  func goTo(project: Project, initialPlaylist _: [Project], refTag: RefTag) {
    let projectParam = Either<Project, any ProjectPageParam>(left: project)
    let nav = ProjectPageViewController.navigationController(
      withProjectOrParam: projectParam,
      refInfo: RefInfo(refTag)
    )
    self.present(nav, animated: true, completion: nil)
  }

  /// Pushes a creator update detail screen from an activity sample card.
  func goTo(project: Project, update: Update) {
    let vc = UpdateViewController.configuredWith(project: project, update: update, context: .activitySample)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  /// Fades in the empty state overlay and disables discovery sort tabs.
  func showEmptyState(_ emptyState: EmptyState) {
    guard let emptyVC = self.emptyStatesController else { return }

    emptyVC.setEmptyState(emptyState)
    emptyVC.view.isHidden = false
    self.view.bringSubviewToFront(emptyVC.view)
    UIView.animate(withDuration: 0.3) {
      self.emptyStatesController?.view.alpha = 1.0
    }
    if let discovery = self.parent?.parent as? DiscoveryViewController {
      discovery.setSortsEnabled(false)
    }
  }
}

// MARK: - Cell & Child Delegates

extension DiscoveryPageViewController: VideoFeedBannerCellDelegate {
  func videoFeedBannerCellDidTapTryItNow(_ cell: VideoFeedBannerCell) {
    self.presentVideoFeed(from: cell)
  }
}

extension DiscoveryPageViewController: ActivitySampleBackingCellDelegate, ActivitySampleFollowCellDelegate,
  ActivitySampleProjectCellDelegate {
  func goToActivity() {
    guard let root = self.tabBarController as? RootTabBarViewController else { return }
    root.switchToActivities()
  }
}

extension DiscoveryPageViewController: DiscoveryOnboardingCellDelegate {
  func discoveryOnboardingTappedSignUpLoginButton() {
    self.viewModel.inputs.signupLoginButtonTapped()
  }
}

extension DiscoveryPageViewController: PersonalizationCellDelegate {
  func personalizationCellTapped(_: PersonalizationCell) {
    self.viewModel.inputs.personalizationCellTapped()
  }

  func personalizationCellDidTapDismiss(_: PersonalizationCell) {
    self.viewModel.inputs.personalizationCellDismissTapped()
  }
}

extension DiscoveryPageViewController: EmptyStatesViewControllerDelegate {
  func emptyStatesViewController(
    _: EmptyStatesViewController,
    goToDiscoveryWithParams params: DiscoveryParams?
  ) {
    self.view.window?.rootViewController
      .flatMap { $0 as? RootTabBarViewController }
      .doIfSome { $0.switchToDiscovery(params: params) }
  }

  func emptyStatesViewControllerGoToFriends() {
    let vc = FindFriendsViewController.configuredWith(source: .discovery)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension DiscoveryPageViewController: DiscoveryPostcardCellDelegate {
  func discoveryPostcard(
    cell _: DiscoveryPostcardCell,
    tappedShare context: ShareContext,
    fromSourceView: UIView
  ) {
    self.shareViewModel.inputs.configureWith(shareContext: context, shareContextView: fromSourceView)
    self.shareViewModel.inputs.shareButtonTapped()
  }

  func discoveryPostcardCellProjectSaveAlert() {
    let alertController = UIAlertController(
      title: Strings.Project_saved(),
      message: Strings.Well_remind_you_forty_eight_hours_before_this_project_ends(),
      preferredStyle: .alert
    )
    alertController.addAction(UIAlertAction(title: Strings.Got_it(), style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }

  func discoveryPostcardCellGoToLoginTout() {
    let vc = LoginToutViewController.configuredWith(loginIntent: .starProject)
    let isIpad = AppEnvironment.current.device.userInterfaceIdiom == .pad
    let nav = UINavigationController(rootViewController: vc)
      |> \.modalPresentationStyle .~ (isIpad ? .formSheet : .fullScreen)
    self.present(nav, animated: true, completion: nil)
  }
}

