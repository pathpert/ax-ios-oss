import AVFoundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

private let playRate = 1.0
private let pauseRate = 0.0

/// View model managing project video playback state, completion tracking, and analytics.
public final class VideoViewModel: VideoViewModelInputs, VideoViewModelOutputs, VideoViewModelType {
  /// Creates a new `VideoViewModel`.
  public init() {
    let project = Signal.combineLatest(
      self.projectProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let duration = self.durationProperty.signal.skipNil().skipRepeats()
    let rateCurrentTime = self.rateCurrentTimeProperty.signal.skipNil().skipRepeats(==)

    let completionThreshold = duration
      .map { 0.85 * CMTimeGetSeconds($0) }

    let reachedEndOfVideo = Signal.combineLatest(rateCurrentTime, duration)
      .filter { rateCurrentTime, duration in rateCurrentTime.1 == duration }

    let videoCompletedOnScrub = Signal.combineLatest(rateCurrentTime, completionThreshold)
      .filter { rateCurrentTime, completionThreshold in
        let currentTimeSeconds = CMTimeGetSeconds(rateCurrentTime.1)
        return currentTimeSeconds >= completionThreshold
      }
      .take(first: 1)
      .ignoreValues()

    let videoCompleted = Signal.merge(videoCompletedOnScrub, self.crossedCompletionThresholdProperty.signal)
      .take(first: 1)

    let videoStarted = rateCurrentTime
      .filter { rate, currentTime in currentTime == CMTime.zero && rate == playRate }
      .take(first: 1)

    self.addCompletionObserver = completionThreshold.map { CMTimeMakeWithSeconds($0, preferredTimescale: 1) }

    self.configurePlayerWithURL = project
      .map { $0.videoViewProperties }
      .filter { $0.video != nil }
      .takeWhen(self.playButtonTappedProperty.signal)
      .map { URL(string: $0.video?.hls ?? $0.video?.high ?? "") }
      .skipNil()
      .skipRepeats()

    self.playVideo = self.playButtonTappedProperty.signal

    self.pauseVideo = self.playVideo
      .takeWhen(self.viewWillDisappearProperty.signal)

    let elementsHiddenOnPlayback = Signal.merge(
      self.playVideo.mapConst(true),
      reachedEndOfVideo.mapConst(false)
    )
    .skipRepeats()

    self.projectImageHidden = Signal.merge(elementsHiddenOnPlayback, project.mapConst(false))
      .skipRepeats()

    self.playButtonHidden = Signal.merge(
      project.map { $0.videoViewProperties.video == nil },
      elementsHiddenOnPlayback
    )
    .skipRepeats()

    self.projectImageURL = project.map { URL(string: $0.videoViewProperties.photoFull) }.skipRepeats(==)

    self.seekToBeginning = reachedEndOfVideo.ignoreValues()

    self.incrementVideoCompletion = Signal.combineLatest(project, videoCompleted)
      .map(first)
      .switchMap {
        AppEnvironment.current.apiService.incrementVideoCompletion(for: $0)
          .demoteErrors()
      }

    self.incrementVideoStart = Signal.combineLatest(project, videoStarted)
      .map(first)
      .switchMap {
        AppEnvironment.current.apiService.incrementVideoStart(forProject: $0)
          .demoteErrors()
      }

    self.videoViewHidden = self.projectImageHidden.map(negate)

    self.notifyDelegateThatVideoDidFinish = reachedEndOfVideo.ignoreValues()
    self.notifyDelegateThatVideoDidStart = self.playButtonTappedProperty.signal

    self.opacityForViews = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst(0.0),
      self.playButtonHidden.filter(isFalse)
        .takeWhen(self.viewDidAppearProperty.signal)
        .mapConst(1.0)
    )

    // Tracking

    /// When the rate == 1, the video is playing
    let currentPlayTime = rateCurrentTime
      .filter { $0.rate == 1 }
      .map { $0.currentTime }

    Signal.combineLatest(
      project,
      duration,
      currentPlayTime
    )
    .observeValues { project, duration, currentPlayTime in
      AppEnvironment.current.ksrAnalytics.trackProjectVideoPlaybackStarted(
        project: project,
        videoLength: lround(duration.seconds),
        videoPosition: lround(currentPlayTime.seconds)
      )
    }
  }

  fileprivate let crossedCompletionThresholdProperty = MutableProperty(())
  /// Marks playback as having reached the 85% completion threshold.
  public func crossedCompletionThreshold() {
    self.crossedCompletionThresholdProperty.value = ()
  }

  fileprivate let durationProperty = MutableProperty<CMTime?>(nil)
  /// Updates the loaded video duration.
  public func durationChanged(toNew duration: CMTime) {
    self.durationProperty.value = duration
  }

  fileprivate let playButtonTappedProperty = MutableProperty(())
  /// Starts video playback when the overlay play button is tapped.
  public func playButtonTapped() {
    self.playButtonTappedProperty.value = ()
  }

  fileprivate let projectProperty = MutableProperty<(any VideoViewConfiguration)?>(nil)
  /// Configures the player with the target project's video metadata.
  public func configureWith(project: any VideoViewConfiguration) {
    self.projectProperty.value = project
  }

  fileprivate let rateCurrentTimeProperty = MutableProperty<(rate: Double, currentTime: CMTime)?>(nil)
  /// Updates playback rate and current playback timestamp from `AVPlayer`.
  public func rateChanged(toNew rate: Double, atTime currentTime: CMTime) {
    self.rateCurrentTimeProperty.value = (rate, currentTime)
  }

  fileprivate let viewDidAppearProperty = MutableProperty(())
  /// Signals that the video view appeared.
  public func viewDidAppear() {
    self.viewDidAppearProperty.value = ()
  }

  fileprivate let viewDidDisappearProperty = MutableProperty(false)
  /// Signals that the video view disappeared.
  public func viewDidDisappear(animated: Bool) {
    self.viewDidDisappearProperty.value = animated
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the video view finished loading.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let viewWillDisappearProperty = MutableProperty(())
  /// Signals that the video view will disappear.
  public func viewWillDisappear() {
    self.viewWillDisappearProperty.value = ()
  }

  /// Emits timestamp for adding the 85% completion boundary observer.
  public let addCompletionObserver: Signal<CMTime, Never>
  /// Emits resolved playable stream URL.
  public let configurePlayerWithURL: Signal<URL, Never>
  /// Emits API completion tracking confirmation.
  public let incrementVideoCompletion: Signal<VoidEnvelope, Never>
  /// Emits API start tracking confirmation.
  public let incrementVideoStart: Signal<VoidEnvelope, Never>
  /// Emits when video playback reaches completion.
  public let notifyDelegateThatVideoDidFinish: Signal<(), Never>
  /// Emits when video playback transitions from stopped to playing.
  public let notifyDelegateThatVideoDidStart: Signal<(), Never>
  /// Emits target alpha for transitioning overlay controls.
  public let opacityForViews: Signal<CGFloat, Never>
  /// Emits when `AVPlayer` should pause.
  public let pauseVideo: Signal<Void, Never>
  /// Emits when `AVPlayer` should play.
  public let playVideo: Signal<Void, Never>
  /// Emits whether the play button should be hidden.
  public var playButtonHidden: Signal<Bool, Never>
  /// Emits whether the cover thumbnail image should be hidden.
  public var projectImageHidden: Signal<Bool, Never>
  /// Emits optional cover thumbnail image URL.
  public let projectImageURL: Signal<URL?, Never>
  /// Emits when playback should seek back to `0`.
  public let seekToBeginning: Signal<Void, Never>
  /// Emits whether the video layer container should be hidden.
  public var videoViewHidden: Signal<Bool, Never>

  /// Input receiver (`self`).
  public var inputs: VideoViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: VideoViewModelOutputs { return self }
}
