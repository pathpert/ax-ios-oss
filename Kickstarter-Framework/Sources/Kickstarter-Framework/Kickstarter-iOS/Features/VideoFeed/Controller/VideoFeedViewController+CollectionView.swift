import Kingfisher
import KsApi
import Library
import SwiftUI
import UIKit

// MARK: - UICollectionViewDelegateFlowLayout

extension VideoFeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt _: IndexPath
  ) -> CGSize {
    CGSize(width: floor(collectionView.bounds.width), height: floor(collectionView.bounds.height))
  }

  func collectionView(
    _: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let cell = cell as? VideoFeedCell else { return }

    let items = self.viewModel.items
    guard indexPath.item < items.count else { return }

    let item = items[indexPath.item]

    cell.onEvent = { [weak self] event in
      self?.handleOnEvent(event, item: item)
    }
    cell.configureWith(
      item: Binding(
        get: { self.viewModel.items.first(where: { $0.id == item.id }) ?? item },
        set: { _ in }
      ),
      isSaved: self.viewModel.isSaved(projectId: item.id),
      isMuted: self.muteBinding
    )

    if let url = item.videoURL {
      cell.loadVideo(url: url)
    }

    let nextIndex = indexPath.item + 1
    self.previewImagePrefetcher?.stop()
    self.previewImagePrefetcher = nil

    if nextIndex < items.count, let nextPreviewURL = items[nextIndex].videoPreviewImageURL {
      let prefetcher = ImagePrefetcher(resources: [nextPreviewURL])
      prefetcher.start()
      self.previewImagePrefetcher = prefetcher
    }
  }

  /// Pauses and rewinds when a cell scrolls offscreen so the next appearance starts fresh.
  func collectionView(
    _: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt _: IndexPath
  ) {
    self.previewImagePrefetcher?.stop()
    self.previewImagePrefetcher = nil
    (cell as? VideoFeedCell)?.resetVideo()
  }

  // MARK: - Scroll based playback

  func scrollViewWillBeginDragging(_: UIScrollView) {
    self.isScrolling = true
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard !scrollView.isDragging else { return }

    self.isScrolling = false

    let pageHeight = self.collectionView.bounds.height
    guard pageHeight > 0 else { return }

    let newPageIndex = Int(round(self.collectionView.contentOffset.y / pageHeight))

    let departingCell = self.collectionView.visibleCells
      .compactMap { $0 as? VideoFeedCell }
      .first {
        self.collectionView.indexPath(for: $0)?.item == self.currentPageIndex
      }

    self.viewModel.trackPageViewed(
      atIndex: newPageIndex,
      totalWatchTimeMs: departingCell?.watchTimeMs ?? 0,
      totalVideoDurationMs: departingCell?.currentVideoDurationMs ?? 0
    )

    self.currentPageIndex = newPageIndex
    self.activateCurrentPageCell()
  }

  // MARK: - Helpers

  private func handleOnEvent(_ event: VideoFeedCell.Event, item: VideoFeedItem) {
    switch event {
    case .closeTapped:
      self.dismiss(animated: true)
    case .creatorTapped:
      self.goToCreatorProfile(for: item)
    case .shareTapped:
      self.viewModel.trackCTAClicked(ctaContext: .videoFeedShare, item: item)
      self.pauseVisibleCell()
      self.isShareSheetPresented = true
    case .sheetDismissedFromLinkCopied:
      self.isShareSheetPresented = false
      self.resumeVisibleCell()
    case .moreTapped:
      self.simpleAlert(title: "More")
    case .ctaTapped:
      self.goToProjectPage(for: item)
    case .pauseTapped, .resumeTapped:
      self.handlePlaybackTapped(for: event, item: item)
    case let .progressBarTapped(percentageWatched):
      self.trackProgressBarTapped(item: item, percentageWatched: percentageWatched)
    case .muteTapped:
      self.toggleMute()
    case .videoReady, .videoFailed:
      break
    }
  }

  private func handlePlaybackTapped(for event: VideoFeedCell.Event, item: VideoFeedItem) {
    switch event {
    case .pauseTapped:
      self.viewModel.trackCTAClicked(ctaContext: .videoFeedPause, item: item)
    case .resumeTapped:
      self.viewModel.trackCTAClicked(ctaContext: .videoFeedPlay, item: item)
    default:
      break
    }
  }

  private func trackProgressBarTapped(item: VideoFeedItem, percentageWatched: Float) {
    let pageHeight = self.collectionView.bounds.height
    let positionInSession = pageHeight > 0
      ? Int(round(self.collectionView.contentOffset.y / pageHeight))
      : 0
    self.viewModel.trackProgressBarTapped(
      item: item,
      positionInSession: positionInSession,
      percentageWatched: percentageWatched
    )
  }

  private func simpleAlert(title: String) {
    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true)
  }
}

