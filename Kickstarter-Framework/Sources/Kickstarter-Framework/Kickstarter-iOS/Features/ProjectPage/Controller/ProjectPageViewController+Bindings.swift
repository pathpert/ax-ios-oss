import AVFoundation
import Combine
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// `ProjectPageViewController` extensions declared in `ProjectPageViewController+Bindings.swift`.
extension ProjectPageViewController {
  internal func bindProjectPageViewModel() {
    self.viewModel.outputs.updateWatchProjectWithPrelaunchProjectState
      .observeForUI()
      .observeValues { [weak self] prelaunchState in
        self?.navigation.configureSaveWatchPrelaunchProject(with: prelaunchState)
      }

    self.viewModel.outputs.goToRewards
      .observeForControllerAction()
      .observeValues { [weak self] project, refTag, secretRewardToken in
        self?.goToRewards(project: project, refTag: refTag, secretRewardToken: secretRewardToken)
      }

    self.viewModel.outputs.goToManagePledge
      .observeForControllerAction()
      .observeValues { [weak self] params in
        self?.goToManagePledge(params: params)
      }

    Signal.merge(
      self.viewModel.outputs.goToPledgeManagementPledgeView,
      self.viewModel.outputs.goToPledgeManager
    )
    .observeForControllerAction()
    .observeValues { [weak self] url in
      self?.goToPledgeManagementWebViewController(with: url)
    }

    self.viewModel.outputs.configureChildViewControllersWithProject
      .observeForUI()
      .observeValues { [weak self] project, _ in
        self?.navigation.configureSharing(with: .project(project))
        let watchProjectValue = WatchProjectValue(
          project: project,
          context: KSRAnalytics.PageContext.project,
          discoveryParams: nil
        )
        self?.navigation.configureWatchProject(with: watchProjectValue)
      }

    self.viewModel.outputs.configureDataSource
      .observeForUI()
      .observeValues { [weak self] navSection, project, refTag in
        self?.dataSource.load(navigationSection: navSection, project: project, refTag: refTag)
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.configurePledgeCTAView
      .observeForUI()
      .observeValues { [weak self] value in
        self?.pledgeCTAContainerView.configureWith(value: value)
      }

    self.viewModel.outputs.configureProjectNavigationSelectorView
      .observeForUI()
      .observeValues { [weak self] projectAndRefTag in
        self?.projectNavigationSelectorView.configure(with: projectAndRefTag)
      }

    self.viewModel.outputs.dismissManagePledgeAndShowMessageBannerWithMessage
      .observeForControllerAction()
      .observeValues { [weak self] message in
        self?.dismiss(animated: true, completion: {
          self?.messageBannerViewController?.showBanner(with: .success, message: message)
        })
      }

    self.viewModel.outputs.goToComments
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToComments(project: $0) }

    self.viewModel.outputs.goToLoginWithIntent
      .observeForControllerAction()
      .observeValues { [weak self] intent in
        let loginTout = LoginToutViewController.configuredWith(loginIntent: intent)
        let isIpad = AppEnvironment.current.device.userInterfaceIdiom == .pad
        let nav = UINavigationController(rootViewController: loginTout)
          |> \.modalPresentationStyle .~ (isIpad ? .formSheet : .fullScreen)
        self?.present(nav, animated: true, completion: nil)
      }

    self.viewModel.outputs.goToReportProject
      .observeForControllerAction()
      .observeValues { [weak self] flagged, projectID, projectUrl in
        guard !flagged else { return }
        self?.goToReportProject(projectID: projectID, projectUrl: projectUrl)
      }

    self.viewModel.outputs.goToRestrictedCreator
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToRestrictedCreator(message: $0) }

    self.viewModel.outputs.goToUpdates
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToUpdates(project: $0) }

    self.viewModel.outputs.goToURL
      .observeForControllerAction()
      .observeValues { UIApplication.shared.open($0) }

    self.bindMediaAndTabOutputs()
    self.bindBannerAndNavigationOutputs()
  }

  private func bindMediaAndTabOutputs() {
    self.viewModel.outputs.prefetchImageURLs
      .observeValues { [weak self] urls, indexPath in
        self?.prefetchImageDataAndUpdateWith(indexPath, imageUrls: urls)
      }

    self.viewModel.outputs.prefetchImageURLsOnFirstLoad
      .observeValues { [weak self] imageViewElements in
        imageViewElements.forEach { element in
          guard let url = URL(string: element.src) else { return }
          UIImageView.ksr_cacheImageWith(url) { [weak self] image in
            guard let dataSource = self?.dataSource,
                  let crossPlatformImage = image else { return }
            dataSource.preloadCampaignImageViewElement(element, image: crossPlatformImage)
          }
        }
      }

    self.viewModel.outputs.precreateAudioVideoURLsOnFirstLoad
      .observeValues { [weak self] elements in
        elements.forEach { element in
          self?.prepareAudioVideoElement(element) { usablePlayer, image in
            self?.dataSource.preloadCampaignAudioVideoViewElement(element, player: usablePlayer, image: image)
          }
        }
      }

    self.viewModel.outputs.precreateAudioVideoURLs
      .observeValues { [weak self] element, indexPath in
        self?.prepareAudioVideoElement(element) { usablePlayer, image in
          self?.dataSource.updateAudioVideoViewElementWith(
            element,
            player: usablePlayer,
            thumbnailImage: image,
            indexPath: indexPath
          )
        }
      }

    self.viewModel.outputs.showProjectPageTabWithData
      .observeForUI()
      .observeValues { [weak self] data in
        let (navSection, project, refTag, initialIsExpandedArray, _, similarProjectsState, contentView) = data
        self?.pausePlayingMainCellVideo(navSection: navSection)
        self?.dataSource.load(
          navigationSection: navSection,
          project: .left(project),
          refTag: refTag,
          isExpandedStates: initialIsExpandedArray,
          similarProjectsState: similarProjectsState
        )
        self?.tableView.reloadData()
        self?.showContentView(contentView)
      }

    self.viewModel.outputs.updateFAQsInDataSource
      .observeForUI()
      .observeValues { [weak self] project, refTag, isExpandedValues in
        self?.dataSource.load(
          navigationSection: .faq,
          project: .left(project),
          refTag: refTag,
          isExpandedStates: isExpandedValues
        )
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.pauseMedia
      .observeForUI()
      .observeValues { [weak self] in
        guard let tableView = self?.tableView else { return }
        tableView.indexPathsForVisibleRows?.forEach { indexPath in
          if let cell = tableView.cellForRow(at: indexPath) as? AudioVideoViewElementCell,
             let isPlaying = cell.delegate?.isPlaying(),
             isPlaying,
             let seekTime = cell.delegate?.pausePlayback() {
            self?.dataSource.updateAudioVideoViewElementSeektime(
              with: seekTime,
              tableView: tableView,
              indexPath: indexPath
            )
          }
        }
      }

    self.viewModel.outputs.reloadCampaignData
      .observeForUI()
      .observeValues { [weak self] in self?.tableView.reloadData() }
  }

  private func bindBannerAndNavigationOutputs() {
    self.viewModel.outputs.presentMessageDialog
      .observeForUI()
      .observeValues { [weak self] in self?.presentMessageDialog(project: $0) }

    self.viewModel.outputs.showHelpWebViewController
      .observeForControllerAction()
      .observeValues { [weak self] in
        self?.presentHelpWebViewController(with: $0, presentationStyle: .formSheet)
      }

    self.viewModel.outputs.navigateBackToProjectPage
      .observeForControllerAction()
      .observeValues { [weak self] in self?.navigateBackToProjectPage() }

    self.viewModel.outputs.didBlockUser
      .observeForUI()
      .observeValues { [weak self] _ in
        self?.messageBannerViewController?.showBanner(with: .success, message: Strings.Block_user_success())
      }

    self.viewModel.outputs.didBlockUserError
      .observeForUI()
      .observeValues { [weak self] _ in
        self?.messageBannerViewController?.showBanner(with: .error, message: Strings.Block_user_fail())
      }

    self.viewModel.outputs.navigateToSimilarProject
      .observeForUI()
      .observeValues { [weak self] in self?.goToSimilarProject($0.projectPageParam) }
  }

  private func prepareAudioVideoElement(
    _ element: AudioVideoViewElement,
    onReady: @escaping (AVPlayer, UIImage?) -> Void
  ) {
    guard let url = URL(string: element.sourceURLString) else { return }
    let thumbnailURL = element.thumbnailURLString.flatMap(URL.init(string:))
    self.prepareToPlayAudioVideoURL(audioVideoURL: url, thumbnailURL: thumbnailURL) { player, image in
      guard let usablePlayer = player else { return }
      onReady(usablePlayer, image)
    }
  }
}
