import AVFoundation
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input events handled by `AudioVideoViewElementCellViewModel`.
public protocol AudioVideoViewElementCellViewModelInputs {
  /// Call to configure with a `AudioVideoViewElement` representing raw audio/video view with an optional `AVPlayer` and `UIImage`` if its ready with its asset.
  func configureWith(element: AudioVideoViewElement, player: AVPlayer?, thumbnailImage: UIImage?)

  /// Call to send a pause signal to `AVPlayer` to pause the playing audio/video and return a seek time.
  func pausePlayback() -> CMTime

  /// Call to record current playback seektime to resume playback later.
  func recordSeektime(_ seekTime: CMTime)
}

/// Output signals exposed by `AudioVideoViewElementCellViewModel`.
public protocol AudioVideoViewElementCellViewModelOutputs {
  /// Emits a signal to pause playback of audio/video
  var pauseAudioVideo: Signal<Void, Never> { get }

  /// Emits an optional `UIImage` that is the thumbnail image for the video.
  var thumbnailImage: Signal<UIImage, Never> { get }

  /// Emits an optional `AVPlayer` with an `AVPlayerItem` for audio/video view with a preset seektime if the element contained one.
  var audioVideoItem: Signal<AVPlayer, Never> { get }
}

/// Interface combining inputs and outputs for `AudioVideoViewElementCellViewModel`.
public protocol AudioVideoViewElementCellViewModelType {
  /// Input receiver for configuring playback items and seek state.
  var inputs: AudioVideoViewElementCellViewModelInputs { get }
  /// Output signals driving embedded audio/video playback and thumbnail visibility.
  var outputs: AudioVideoViewElementCellViewModelOutputs { get }
}

/// View model managing `AVPlayer` seek restoration and thumbnail display in story media cells.
public final class AudioVideoViewElementCellViewModel:
  AudioVideoViewElementCellViewModelType, AudioVideoViewElementCellViewModelInputs,
  AudioVideoViewElementCellViewModelOutputs {
  // MARK: Initializers

  /// Initializes the audio/video view element cell view model.
  public init() {
    self.audioVideoItem = self.audioVideoViewElementWithPlayerAndThumbnailProperty.signal
      .switchMap { audioVideoElementWithPlayer -> SignalProducer<AVPlayer?, Never> in
        guard let player = audioVideoElementWithPlayer?.player else {
          return SignalProducer(value: nil)
        }

        let seekTime = audioVideoElementWithPlayer?.element.seekPosition ?? .zero
        let validPlayTime = seekTime.isValid ? seekTime : .zero

        player.currentItem?.seek(to: validPlayTime, completionHandler: nil)

        return SignalProducer(value: player)
      }
      .skipNil()

    self.pauseAudioVideo = self.pausePlaybackProperty.signal.ignoreValues()
    self.thumbnailImage = self.audioVideoViewElementWithPlayerAndThumbnailProperty.signal
      .skipNil()
      .switchMap { element, _, thumbnailImage -> SignalProducer<UIImage?, Never> in
        guard element.seekPosition == .zero else {
          return SignalProducer(value: nil)
        }

        return SignalProducer(value: thumbnailImage)
      }
      .skipNil()
  }

  fileprivate let pausePlaybackProperty = MutableProperty<Void>(())
  /// Emits pause event and returns the most recently recorded `CMTime` seek offset.
  public func pausePlayback() -> CMTime {
    self.pausePlaybackProperty.value = ()

    return self.seekTimeProperty.value
  }

  fileprivate let seekTimeProperty = MutableProperty<CMTime>(.zero)
  /// Records the current player seek position for later resumption.
  public func recordSeektime(_ seekTime: CMTime) {
    self.seekTimeProperty.value = seekTime
  }

  fileprivate let audioVideoViewElementWithPlayerAndThumbnailProperty =
    MutableProperty<(element: AudioVideoViewElement, player: AVPlayer?, thumbnailImage: UIImage?)?>(nil)
  /// Configures the cell with its HTML media element, preloaded `AVPlayer`, and optional thumbnail image.
  public func configureWith(element: AudioVideoViewElement, player: AVPlayer?, thumbnailImage: UIImage?) {
    self.audioVideoViewElementWithPlayerAndThumbnailProperty.value = (element, player, thumbnailImage)
  }

  /// Emits when media playback should pause.
  public let pauseAudioVideo: Signal<Void, Never>
  /// Emits the prepared `AVPlayer` positioned at its saved seek offset.
  public let audioVideoItem: Signal<AVPlayer, Never>
  /// Emits the initial thumbnail image when playback begins from time zero.
  public let thumbnailImage: Signal<UIImage, Never>

  /// Returns `self` as `AudioVideoViewElementCellViewModelInputs`.
  public var inputs: AudioVideoViewElementCellViewModelInputs { self }
  /// Returns `self` as `AudioVideoViewElementCellViewModelOutputs`.
  public var outputs: AudioVideoViewElementCellViewModelOutputs { self }
}
