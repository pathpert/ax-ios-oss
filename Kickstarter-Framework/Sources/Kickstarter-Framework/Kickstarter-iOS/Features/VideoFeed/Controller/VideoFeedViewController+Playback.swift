import KDS
import KsApi
import Library
import SwiftUI
import UIKit

// MARK: - Playback, Lifecycle & Navigation

extension VideoFeedViewController {
  /// Re-runs `UIHostingConfiguration` on the active visible cell so save and watch counts stay current.
  func reconfigureVisibleCell() {
    guard let indexPath = self.collectionView.indexPathsForVisibleItems.first,
          let cell = self.collectionView.cellForItem(at: indexPath) as? VideoFeedCell else { return }

    let items = self.viewModel.items
    guard indexPath.item < items.count else { return }

    let item = items[indexPath.item]
    cell.configureWith(
      item: Binding(
        get: { self.viewModel.items.first(where: { $0.id == item.id }) ?? item },
        set: { _ in }
      ),
      isSaved: self.viewModel.isSaved(projectId: item.id),
      isMuted: self.muteBinding
    )
  }

  /// Binding bridging the view model mute flag to cell playback controls.
  var muteBinding: Binding<Bool> {
    Binding {
      self.viewModel.isMuted
    } set: { [weak self] newValue in
      guard let self, newValue != self.viewModel.isMuted else { return }
      self.toggleMute()
    }
  }

  /// Snaps collection view offset back to an exact full-page boundary after modal layout passes.
  func snapToCurrentPage() {
    let pageHeight = self.collectionView.bounds.height
    guard pageHeight > 0 else { return }

    let currentPage = round(self.collectionView.contentOffset.y / pageHeight)
    self.collectionView.contentOffset.y = currentPage * pageHeight
  }

  /// Pause video on background, resume on foreground, and re-render the active cell after login.
  func observeAppLifecycle() {
    let center = NotificationCenter.default

    self.lifecycleObservers = [
      center.addObserver(
        forName: UIApplication.didEnterBackgroundNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        self?.pauseVisibleCell()
      },
      center.addObserver(
        forName: UIApplication.willEnterForegroundNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        self?.resumeVisibleCell()
      },
      center.addObserver(
        forName: .ksr_sessionStarted,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        self?.viewModel.userSessionStarted()

        DispatchQueue.main.async { [weak self] in
          self?.reconfigureVisibleCell()
        }
      }
    ]
  }

  /// Toggles mute across the view model, visible cells, and audio session controller.
  func toggleMute() {
    self.viewModel.toggleMute()
    self.muteVisibleCells()
    self.reconfigureVisibleCell()

    if #available(iOS 26, *), !self.viewModel.isMuted {
      self.audioController.handleOverlayUnmute()
    }
  }

  /// Applies the view model's mute flag to all visible `VideoFeedCell` instances.
  func muteVisibleCells() {
    let isMuted = self.viewModel.isMuted
    self.collectionView.visibleCells
      .compactMap { $0 as? VideoFeedCell }
      .forEach { $0.mutePlayback(isMuted) }
  }

  /// Pauses playback on all currently visible video cells.
  func pauseVisibleCell() {
    self.collectionView.visibleCells
      .compactMap { $0 as? VideoFeedCell }
      .forEach { $0.pausePlayback() }
  }

  /// Resumes active cell playback when returning to foreground unless a share sheet covers the feed.
  func resumeVisibleCell() {
    guard self.view.window != nil, !self.isShareSheetPresented else { return }
    self.activateCurrentPageCell()
  }

  /// Starts playback on the settled current page cell and pauses any off-page cells.
  func activateCurrentPageCell() {
    let pageHeight = self.collectionView.bounds.height
    guard pageHeight > 0 else { return }

    let currentPage = Int(round(self.collectionView.contentOffset.y / pageHeight))
    let activeIndexPath = IndexPath(item: currentPage, section: 0)

    for cell in self.collectionView.visibleCells.compactMap({ $0 as? VideoFeedCell }) {
      if self.collectionView.indexPath(for: cell) == activeIndexPath {
        if #available(iOS 26, *) {
          self.audioController.handleNewVideoActivated()
        }
        cell.startPlayback()
        cell.mutePlayback(self.viewModel.isMuted)
      } else {
        cell.pausePlayback()
      }
    }
  }

  // MARK: - Navigation

  /// Presents the login/signup flow when a signed-out user attempts a protected feed action.
  func goToLoginTout(intent: LoginIntent) {
    let loginTout = LoginToutViewController.configuredWith(loginIntent: intent)
    let isIpad = AppEnvironment.current.device.userInterfaceIdiom == .pad
    let nav = UINavigationController(rootViewController: loginTout)
    nav.modalPresentationStyle = isIpad ? .formSheet : .fullScreen

    if !isIpad {
      nav.view.backgroundColor = Colors.Background.Surface.primary.uiColor()
    }

    self.present(nav, animated: true)
  }

  /// Presents the project creator profile modal for the selected video feed item.
  func goToCreatorProfile(for item: VideoFeedItem) {
    let vc = ProjectCreatorViewController.configuredWith(project: item)
    vc.isPresentedFromVideoFeed = true

    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = AppEnvironment.current.device.userInterfaceIdiom == .pad
      ? .formSheet
      : .fullScreen

    self.present(nav, animated: true)
  }

  /// Modally presents the full project page for the selected video feed item.
  func goToProjectPage(for item: VideoFeedItem) {
    let vc = ProjectPageViewController.navigationController(
      withProjectOrParam: .right(Param.slug(item.slug)),
      refInfo: RefInfo(.videoFeed)
    )
    vc.modalPresentationStyle = .fullScreen

    self.present(vc, animated: true)
  }
}

