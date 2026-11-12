import AVFoundation
import KsApi
import Library
import Prelude
import UIKit

// MARK: - Media Preloading & IndexPath Helpers

extension ProjectPageViewControllerDataSource {
  /// Caches already-loaded images from the campaign section before clearing values.
  func prepareImagesInCampaignSection() {
    guard self.numberOfSections(in: UITableView()) > Section.campaign.rawValue else { return }

    self.items(in: Section.campaign.rawValue).forEach { valueAndReuseId in
      guard let imageViewData = valueAndReuseId.value as? (element: ImageViewElement, image: UIImage?),
            imageViewData.image != nil else {
        return
      }

      self.preexistingImageViewElementsWithData.append(imageViewData)

      var seenURLStrings = Set<String>()
      var uniqueElements = [(element: ImageViewElement, image: UIImage?)]()
      for (imageElement, image) in self.preexistingImageViewElementsWithData {
        if !seenURLStrings.contains(imageElement.src) {
          uniqueElements.append((imageElement, image))
          seenURLStrings.insert(imageElement.src)
        }
      }

      self.preexistingImageViewElementsWithData = uniqueElements
    }
  }

  /// Caches already-initialized audio/video players and poster frames from the campaign section.
  func prepareAudioVideosInCampaignSection() {
    guard self.numberOfSections(in: UITableView()) > Section.campaign.rawValue else { return }

    self.items(in: Section.campaign.rawValue).forEach { valueAndReuseId in
      guard let audioVideoViewElementWithPlayer = valueAndReuseId
        .value as? (AudioVideoViewElement, AVPlayer?, UIImage?) else {
        return
      }

      self.preexistingAudioVideoViewElementsWithPlayer.append(audioVideoViewElementWithPlayer)

      var seenURLStrings = Set<String>()
      var uniqueElements = [(element: AudioVideoViewElement, player: AVPlayer?, image: UIImage?)]()
      for (audioVideoElement, player, image) in self.preexistingAudioVideoViewElementsWithPlayer {
        if !seenURLStrings.contains(audioVideoElement.sourceURLString) {
          uniqueElements.append((audioVideoElement, player, image))
          seenURLStrings.insert(audioVideoElement.sourceURLString)
        }
      }

      self.preexistingAudioVideoViewElementsWithPlayer = uniqueElements
    }
  }

  /// Replaces the row value for an image element once its `UIImage` finishes downloading.
  func updateImageViewElementWith(
    _ imageViewElement: ImageViewElement,
    image: UIImage,
    indexPath: IndexPath
  ) {
    self.set(
      value: (imageViewElement, image),
      cellClass: ImageViewElementCell.self,
      inSection: indexPath.section,
      row: indexPath.row
    )
  }

  /// Replaces the row value for an audio/video element once its `AVPlayer` and thumbnail are ready.
  func updateAudioVideoViewElementWith(
    _ audioVideoViewElement: AudioVideoViewElement,
    player: AVPlayer,
    thumbnailImage: UIImage?,
    indexPath: IndexPath
  ) {
    self.set(
      value: (audioVideoViewElement, player, thumbnailImage),
      cellClass: AudioVideoViewElementCell.self,
      inSection: indexPath.section,
      row: indexPath.row
    )
  }

  /// Matches any URL in `urls` against the image element stored at `indexPath`.
  func imageViewElementWith(
    urls: [URL],
    indexPath: IndexPath
  ) -> (
    url: URL,
    element: ImageViewElement,
    image: UIImage?,
    indexPath: IndexPath
  )? {
    let allURLStrings = urls.map { $0.absoluteString }

    guard let indexPathSection = Section(rawValue: indexPath.section)?.rawValue,
          let imageViewElementItem = self.items(in: indexPathSection)[indexPath.row]
          .value as? (element: ImageViewElement, image: UIImage?) else {
      return nil
    }

    for index in 0..<allURLStrings.count {
      if allURLStrings[index] == imageViewElementItem.element.src {
        return (urls[index], imageViewElementItem.element, imageViewElementItem.image, indexPath)
      }
    }

    return nil
  }

  /// Returns whether `indexPath` points to the Comments overview subpage row.
  func indexPathIsCommentsSubpage(_ indexPath: IndexPath) -> Bool {
    return (self[indexPath] as? ProjectPamphletSubpage)?.isComments == true
  }

  /// Returns whether `indexPath` points to the Updates overview subpage row.
  func indexPathIsUpdatesSubpage(_ indexPath: IndexPath) -> Bool {
    return (self[indexPath] as? ProjectPamphletSubpage)?.isUpdates == true
  }

  /// Returns the current expanded/collapsed states for all loaded FAQ rows, if present.
  func isExpandedValuesForFAQsSection() -> [Bool]? {
    guard let values = self[section: Section.faqs.rawValue] as? [(ProjectFAQ, Bool)] else { return nil }
    return values.map { _, isExpanded in isExpanded }
  }

  /// Returns `true` if `indexPath` in `section` holds an image view element item.
  func isIndexPathAnImageViewElement(
    tableView: UITableView,
    indexPath: IndexPath,
    section: ProjectPageViewControllerDataSource.Section
  ) -> Bool {
    guard indexPath.section == section.rawValue else { return false }

    if self.numberOfSections(in: tableView) > section.rawValue,
       self.numberOfItems(in: section.rawValue) > indexPath.row,
       let _ = self.items(in: section.rawValue)[indexPath.row].value as? (ImageViewElement, UIImage?) {
      return true
    }

    return false
  }

  /// Returns the hyperlink URL associated with a campaign image element at `indexPath`, if any.
  func imageViewElementURL(
    tableView: UITableView,
    indexPath: IndexPath
  ) -> URL? {
    let section = ProjectPageViewControllerDataSource.Section.campaign
    guard indexPath.section == section.rawValue else { return nil }

    if self.numberOfSections(in: tableView) > section.rawValue,
       self.numberOfItems(in: section.rawValue) > indexPath.row,
       let (imageViewElement, _) = self.items(in: section.rawValue)[indexPath.row]
       .value as? (ImageViewElement, UIImage?),
       let urlString = imageViewElement.href,
       let url = URL(string: urlString) {
      return url
    }

    return nil
  }

  /// Returns the audio/video element at `indexPath` if its `AVPlayer` has not been created yet.
  func audioVideoViewElementWithNoPlayer(
    tableView: UITableView,
    indexPath: IndexPath,
    section: ProjectPageViewControllerDataSource.Section
  ) -> (AudioVideoViewElement, IndexPath)? {
    guard indexPath.section == section.rawValue else { return nil }

    if self.numberOfSections(in: tableView) > section.rawValue,
       self.numberOfItems(in: section.rawValue) > indexPath.row,
       let (element, player, _) = self.items(in: section.rawValue)[indexPath.row]
       .value as? (AudioVideoViewElement, AVPlayer?, UIImage?),
       player == nil {
      return (element, indexPath)
    }

    return nil
  }

  /// Updates the stored seek time for a campaign audio/video element at `indexPath`.
  func updateAudioVideoViewElementSeektime(
    with seekTime: CMTime,
    tableView: UITableView,
    indexPath: IndexPath
  ) {
    if self.numberOfSections(in: tableView) > indexPath.section,
       self.numberOfItems(in: indexPath.section) > indexPath.row,
       let audioVideoViewElementWithPlayerAndImage = self.items(in: indexPath.section)[indexPath.row]
       .value as? (AudioVideoViewElement, AVPlayer, UIImage?) {
      let updatedAudioVideoElement = audioVideoViewElementWithPlayerAndImage.0
        |> AudioVideoViewElement.lens.seekPosition .~ seekTime

      self.set(
        value: (
          updatedAudioVideoElement,
          audioVideoViewElementWithPlayerAndImage.1,
          audioVideoViewElementWithPlayerAndImage.2
        ),
        cellClass: AudioVideoViewElementCell.self,
        inSection: indexPath.section,
        row: indexPath.row
      )
    }
  }

  /// Stores a preloaded campaign image element so it survives section reloads.
  func preloadCampaignImageViewElement(_ element: ImageViewElement, image: UIImage) {
    self.preexistingImageViewElementsWithData.append((element, image))
  }

  /// Stores a preloaded campaign audio/video player so it survives section reloads.
  func preloadCampaignAudioVideoViewElement(
    _ element: AudioVideoViewElement,
    player: AVPlayer,
    image: UIImage?
  ) {
    self.preexistingAudioVideoViewElementsWithPlayer.append((element, player, image))
  }
}

