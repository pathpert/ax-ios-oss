import AVFoundation
import Combine
import KsApi
import Library
import Prelude
import SwiftUI
import UIKit

/// `ProjectPageViewController` extensions declared in `ProjectPageViewController+Navigation.swift`.
extension ProjectPageViewController {
  internal func goToSimilarProject(_ param: any ProjectPageParam) {
    let nav = ProjectPageViewController.navigationController(
      withProjectOrParam: .right(param),
      refInfo: RefInfo(.similarProjects)
    )
    self.present(nav, animated: true)
  }

  internal func navigateBackToProjectPage() {
    if let presented = self.presentedViewController,
       presented is RewardPledgeNavigationController {
      self.dismiss(animated: true)
      self.navigationController?.popToRootViewController(animated: false)
      return
    }
    self.navigationController?.popToRootViewController(animated: true)
  }

  internal func showProjectStarredPrompt() {
    let alert = UIAlertController(
      title: Strings.Project_saved(),
      message: Strings.Well_remind_you_forty_eight_hours_before_this_project_ends(),
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: Strings.Got_it(), style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  internal func goToLoginTout() {
    let vc = LoginToutViewController.configuredWith(loginIntent: .starProject)
    let isIpad = AppEnvironment.current.device.userInterfaceIdiom == .pad
    let nav = UINavigationController(rootViewController: vc)
      |> \.modalPresentationStyle .~ (isIpad ? .formSheet : .fullScreen)
    self.present(nav, animated: true, completion: nil)
  }

  internal func goToRewards(project: Project, refTag: RefTag?, secretRewardToken: String?) {
    let vc = RewardsCollectionViewController.rewardsController(
      with: project,
      refTag: refTag,
      secretRewardToken: secretRewardToken
    )
    assert(
      self.navigationController.isSome,
      "The project page requires a navigation controller to push the rewards flow."
    )
    self.navigationController?.pushViewController(vc, animated: true)
  }

  internal func goToManagePledge(params: ManagePledgeViewParamConfigData) {
    let vc = ManagePledgeViewController.instantiate()
    vc.delegate = self
    vc.configureWith(params: params)
    self.presentRewardPledgeSheet(vc)
  }

  internal func goToPledgeManagementWebViewController(with backingDetailsURL: String) {
    let vc = PledgeManagerWebViewController.configuredWith(url: backingDetailsURL)
    self.presentRewardPledgeSheet(vc)
  }

  private func presentRewardPledgeSheet(_ viewController: UIViewController) {
    let nc = RewardPledgeNavigationController(rootViewController: viewController)
    if AppEnvironment.current.device.userInterfaceIdiom == .pad {
      nc.modalPresentationStyle = .pageSheet
    }
    self.present(nc, animated: true)
  }

  internal func goToComments(project: Project) {
    let vc = commentsViewController(for: project)
    if self.traitCollection.userInterfaceIdiom == .pad {
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .pageSheet
      self.present(nav, animated: true, completion: nil)
    } else {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  internal func goToReportProject(projectID: String, projectUrl: String) {
    let reportProjectInfoView = ReportProjectInfoView(
      projectID: projectID,
      projectUrl: projectUrl,
      onSuccessfulSubmit: { [weak self] in
        self?.viewModel.inputs.viewDidLoad()
      }
    )
    self.navigationController?
      .pushViewController(UIHostingController(rootView: reportProjectInfoView), animated: true)
  }

  internal func goToRestrictedCreator(message: String) {
    let restrictedCreatorVC = RestrictedCreatorViewController.configuredWith(message: message)
    let navigationVC = UINavigationController(rootViewController: restrictedCreatorVC)
    navigationVC.modalPresentationStyle = .formSheet
    navigationVC.setNavigationBarHidden(true, animated: false)
    if let sheetController = navigationVC.sheetPresentationController {
      if self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
        sheetController.detents = [.medium(), .large()]
      } else {
        sheetController.detents = [.medium()]
      }
      sheetController.prefersGrabberVisible = true
    }
    self.present(navigationVC, animated: true)
  }

  internal func goToUpdates(project: Project) {
    let vc = ProjectUpdatesViewController.configuredWith(project: project)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  internal func presentMessageDialog(project: Project) {
    let dialog = MessageDialogViewController
      .configuredWith(messageSubject: .project(id: project.id, name: project.name), context: .projectPage)
    dialog.modalPresentationStyle = .formSheet
    dialog.delegate = self
    self.present(UINavigationController(rootViewController: dialog), animated: true, completion: nil)
  }

  internal func pausePlayingMainCellVideo(navSection: NavigationSection) {
    let mainCellIndexPath = IndexPath(
      row: .zero,
      section: ProjectPageViewControllerDataSource.Section.overview.rawValue
    )
    if let _ = self.tableView.cellForRow(at: mainCellIndexPath) as? ProjectPamphletMainCell,
       navSection != .overview {
      self.playbackDelegate?.pauseAudioVideoPlayback()
    }
  }

  internal func presentBlockUserAlert(username: String, userId: Int) {
    let alert = UIAlertController.blockUserAlert(username: username, blockUserHandler: { _ in
      self.viewModel.inputs.blockUser(id: userId)
    })
    self.present(alert, animated: true)
  }

  internal func goToCreatorProfile(forProject project: any ProjectCreatorConfiguration) {
    let vc = ProjectCreatorViewController.configuredWith(project: project)
    if self.traitCollection.userInterfaceIdiom == .pad {
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .formSheet
      self.present(nav, animated: true, completion: nil)
    } else {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  internal func prepareToPlayAudioVideoURL(
    audioVideoURL: URL,
    thumbnailURL: URL?,
    completionHandler: @escaping (AVPlayer?, UIImage?) -> Void
  ) {
    var cachedImage: UIImage?
    if let audioVideoThumbnailURL = thumbnailURL {
      UIImageView.ksr_cacheImageWith(audioVideoThumbnailURL) { cachedImage = $0 }
    }

    let asset = AVAsset(url: audioVideoURL)
    asset.loadValuesAsynchronously(forKeys: ["duration", "tracks"]) {
      var durationError: NSError?
      var tracksError: NSError?
      guard
        asset.statusOfValue(forKey: "duration", error: &durationError) == .loaded,
        asset.statusOfValue(forKey: "tracks", error: &tracksError) == .loaded
      else { return }

      let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["duration", "tracks"])
      var player: AVPlayer?
      var cancellable: AnyCancellable?
      cancellable = playerItem.publisher(for: \.status)
        .subscribe(on: DispatchQueue.global(qos: .background))
        .sink { status in
          guard status == .readyToPlay else { return }
          completionHandler(player, cachedImage)
          cancellable = nil
        }
      player = AVPlayer(playerItem: playerItem)
    }
  }

  internal func prefetchImageDataAndUpdateWith(_ indexPath: IndexPath, imageUrls: [URL]) {
    guard
      let preexistingImageData = self.dataSource.imageViewElementWith(urls: imageUrls, indexPath: indexPath),
      preexistingImageData.image == nil
    else { return }

    UIImageView.ksr_cacheImageWith(preexistingImageData.url) { [weak self] image in
      guard
        let imageData = image,
        let tableView = self?.tableView,
        let dataSource = self?.dataSource,
        dataSource.isIndexPathAnImageViewElement(tableView: tableView, indexPath: indexPath, section: .campaign)
      else { return }

      dataSource.updateImageViewElementWith(
        preexistingImageData.element,
        image: imageData,
        indexPath: preexistingImageData.indexPath
      )
    }
  }
}
