import KsApi
import Library
import UIKit

// MARK: - PledgeCTAContainerViewDelegate

extension ProjectPageViewController: PledgeCTAContainerViewDelegate {
  func pledgeCTAButtonTapped(with state: PledgeStateCTAType) {
    self.viewModel.inputs.pledgeCTAButtonTapped(with: state)
  }
}

// MARK: - VideoViewControllerDelegate

extension ProjectPageViewController: VideoViewControllerDelegate {
  /// Invoked when embedded video playback finishes.
  public func videoViewControllerDidFinish(_: VideoViewController) {}
  /// Invoked when embedded video playback starts.
  public func videoViewControllerDidStart(_: VideoViewController) {}
}

// MARK: - ManagePledgeViewControllerDelegate

extension ProjectPageViewController: ManagePledgeViewControllerDelegate {
  func managePledgeViewController(
    _: ManagePledgeViewController,
    managePledgeViewControllerFinishedWithMessage message: String?
  ) {
    self.viewModel.inputs.managePledgeViewControllerFinished(with: message)
  }

  func managePledgeViewControllerDidDismiss(_: ManagePledgeViewController) {}
}

// MARK: - ProjectPageNavigationDelegate

extension ProjectPageViewController: ProjectPageNavigationDelegate {
  func goToLogin() { self.goToLoginTout() }
  func displayProjectStarredPrompt() { self.showProjectStarredPrompt() }
  func dismissPage(animated flag: Bool, completion: (() -> Void)?) {
    self.dismiss(animated: flag, completion: completion)
  }

  func showShareSheet(_ controller: UIActivityViewController, sourceView: UIView?) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      controller.modalPresentationStyle = .popover
      controller.popoverPresentationController?.sourceView = sourceView
    }
    self.present(controller, animated: true, completion: nil)
  }
}

// MARK: - ProjectNavigationSelectorViewDelegate

extension ProjectPageViewController: ProjectNavigationSelectorViewDelegate {
  func projectNavigationSelectorViewDidSelect(_: ProjectNavigationSelectorView, index: Int) {
    self.viewModel.inputs.projectNavigationSelectorViewDidSelect(index: index)
  }
}

// MARK: - UITableViewDelegate

extension ProjectPageViewController: UITableViewDelegate {
  /// Handles row selection across project overview, FAQs, report, and campaign sections.
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case ProjectPageViewControllerDataSource.Section.overviewSubpages.rawValue:
      if self.dataSource.indexPathIsCommentsSubpage(indexPath) {
        self.viewModel.inputs.tappedComments()
      } else if self.dataSource.indexPathIsUpdatesSubpage(indexPath) {
        self.viewModel.inputs.tappedUpdates()
      }
    case ProjectPageViewControllerDataSource.Section.overviewReportProject.rawValue:
      self.viewModel.inputs.tappedReportProject()
    case ProjectPageViewControllerDataSource.Section.faqsAskAQuestion.rawValue:
      self.viewModel.inputs.askAQuestionCellTapped()
    case ProjectPageViewControllerDataSource.Section.faqs.rawValue:
      let values = self.dataSource.isExpandedValuesForFAQsSection() ?? []
      self.viewModel.inputs.didSelectFAQsRowAt(row: indexPath.row, values: values)
    case ProjectPageViewControllerDataSource.Section.campaign.rawValue:
      if let url = self.dataSource.imageViewElementURL(tableView: tableView, indexPath: indexPath) {
        self.viewModel.inputs.didSelectCampaignImageLink(url: url)
      }
    default:
      return
    }
  }

  /// Wires cell delegates and separator styling before each project page cell displays.
  public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? ProjectTabDisclaimerCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? ProjectRisksDisclaimerCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? ProjectPamphletMainCell, cell.delegate == nil {
      cell.delegate = self
    } else if let cell = cell as? ProjectPamphletMainCell, self.playbackDelegate == nil {
      self.playbackDelegate = cell
    } else if let cell = cell as? ImageViewElementCell {
      cell.pinchToZoomDelegate = self
    } else if let cell = cell as? SimilarProjectsTableViewCell {
      cell.delegate = self
    }

    self.tableView.separatorStyle = indexPath.section == ProjectPageViewControllerDataSource.Section
      .overviewReportProject.rawValue ? .none : .singleLine
    self.tableView.layoutIfNeeded()
  }

  /// Returns custom height for the similar projects carousel row and automatic dimension otherwise.
  public func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = self.dataSource.items(in: indexPath.section)[indexPath.row]
    if cell.reusableId == SimilarProjectsTableViewCell.defaultReusableId {
      return SimilarProjectsCellConstants.collectionViewHeight
    }
    return UITableView.automaticDimension
  }

  /// Pauses audio/video playback and persists seek time when a media cell scrolls off screen.
  public func tableView(_: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? AudioVideoViewElementCell,
       let seekTime = cell.delegate?.pausePlayback() {
      self.dataSource
        .updateAudioVideoViewElementSeektime(with: seekTime, tableView: self.tableView, indexPath: indexPath)
    }
  }

  /// Notifies the view model ahead of trait/size transitions.
  public override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    self.viewModel.inputs.viewWillTransition()
  }
}

// MARK: - UITableViewDataSourcePrefetching

extension ProjectPageViewController: UITableViewDataSourcePrefetching {
  /// Prefetches campaign images and prepares audio/video players for upcoming rows.
  public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let campaignSectionImageIndexPaths = indexPaths.filter {
      self.dataSource.isIndexPathAnImageViewElement(tableView: self.tableView, indexPath: $0, section: .campaign)
    }
    campaignSectionImageIndexPaths.forEach { self.viewModel.inputs.prepareImageAt($0) }

    let campaignSectionAudioVideoIndexPaths = indexPaths.compactMap {
      self.dataSource.audioVideoViewElementWithNoPlayer(
        tableView: self.tableView,
        indexPath: $0,
        section: .campaign
      )
    }
    campaignSectionAudioVideoIndexPaths.forEach { self.viewModel.inputs.prepareAudioVideoAt($1, with: $0) }
  }
}

// MARK: - Message, Disclaimer & Cell Delegates

extension ProjectPageViewController: MessageDialogViewControllerDelegate {
  internal func messageDialogWantsDismissal(_ dialog: MessageDialogViewController) {
    dialog.dismiss(animated: true, completion: nil)
  }

  internal func messageDialog(_: MessageDialogViewController, postedMessage _: Message) {}
}

extension ProjectPageViewController: ProjectTabDisclaimerCellDelegate {
  func projectTabDisclaimerCell(_: ProjectTabDisclaimerCell, didTapURL: URL) {
    self.viewModel.inputs.projectTabDisclaimerCellDidTapURL(didTapURL)
  }
}

extension ProjectPageViewController: ProjectRisksDisclaimerCellDelegate {
  func projectRisksDisclaimerCell(_: ProjectRisksDisclaimerCell, didTapURL: URL) {
    self.viewModel.inputs.projectRisksDisclaimerCellDidTapURL(didTapURL)
  }
}

extension ProjectPageViewController: ProjectPamphletMainCellDelegate {
  func projectPamphletMainCellGoToProjectNotice(_: ProjectPamphletMainCell) {
    self.viewModel.inputs.projectNoticeDetailsRequested()
  }

  internal func projectPamphletMainCell(_: ProjectPamphletMainCell, addChildController child: UIViewController) {
    self.addChild(child)
    child.beginAppearanceTransition(true, animated: false)
    child.didMove(toParent: self)
    child.endAppearanceTransition()
  }

  internal func projectPamphletMainCell(
    _ cell: ProjectPamphletMainCell,
    goToCreatorForProject project: any ProjectPamphletMainCellConfiguration
  ) {
    guard
      let currentUser = AppEnvironment.current.currentUser,
      currentUser.id != project.projectPamphletMainCellProperties.creatorId,
      !project.projectPamphletMainCellProperties.isCreatorBlocked
    else {
      self.goToCreatorProfile(forProject: project)
      return
    }

    let actionSheet = UIAlertController.blockUserActionSheet(
      blockUserHandler: { _ in
        self.presentBlockUserAlert(
          username: project.projectPamphletMainCellProperties.creatorName,
          userId: project.projectPamphletMainCellProperties.creatorId
        )
      },
      viewProfileHandler: { _ in self.goToCreatorProfile(forProject: project) },
      sourceView: cell.creatorButton,
      isIPad: self.traitCollection.userInterfaceIdiom == .pad
    )
    self.present(actionSheet, animated: true)
  }
}

extension ProjectPageViewController: SimilarProjectsTableViewCellDelegate {
  func didSelectProject(_ project: ProjectCardProperties) {
    self.viewModel.inputs.similarProjectTapped(project: project)
  }
}

extension ProjectPageViewController: MessageBannerViewControllerDelegate {
  /// Dismisses the project page when a success banner completes hiding.
  public func messageBannerViewDidHide(type: MessageBannerType) {
    if type == .success {
      self.dismiss(animated: true)
    }
  }
}

