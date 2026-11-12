import AVFoundation
import KsApi
import ReactiveSwift

/// Input methods accepted by `VideoViewModel`.
public protocol VideoViewModelInputs {
  /// Call to configure cell with project value.
  func configureWith(project: any VideoViewConfiguration)

  /// Call when the video playback crosses the completion threshold.
  func crossedCompletionThreshold()

  /// Call with duration when video duration changes.
  func durationChanged(toNew duration: CMTime)

  /// Call when the play button is tapped.
  func playButtonTapped()

  /// Call with rate and current time when playback rate changes.
  func rateChanged(toNew rate: Double, atTime currentTime: CMTime)

  /// Call when the view did appear.
  func viewDidAppear()

  /// Call when the view did disappear.
  func viewDidDisappear(animated: Bool)

  /// Call when the view did load.
  func viewDidLoad()

  /// Call when the view will disappear.
  func viewWillDisappear()
}

/// Output signals emitted by `VideoViewModel`.
public protocol VideoViewModelOutputs {
  /// Emits when should add a boundary observer for the 85% completion time.
  var addCompletionObserver: Signal<CMTime, Never> { get }

  /// Emits with the video url to be played.
  var configurePlayerWithURL: Signal<URL, Never> { get }

  /// Emits for testing when the video complete stat is incremented.
  var incrementVideoCompletion: Signal<VoidEnvelope, Never> { get }

  /// Emits for testing when the video start stat is incremented.
  var incrementVideoStart: Signal<VoidEnvelope, Never> { get }

  /// Notifies delegates that video playback finished.
  var notifyDelegateThatVideoDidFinish: Signal<(), Never> { get }
  /// Notifies delegates that video playback started.
  var notifyDelegateThatVideoDidStart: Signal<(), Never> { get }

  /// Emits alpha value for play button and video overlay for transitioning.
  var opacityForViews: Signal<CGFloat, Never> { get }

  /// Emits when the video should be paused.
  var pauseVideo: Signal<Void, Never> { get }

  /// Emits when the video should be played.
  var playVideo: Signal<Void, Never> { get }

  /// Emits a boolean to determine whether or not the play button should be hidden.
  var playButtonHidden: Signal<Bool, Never> { get }

  /// Emits a boolean to determine whether or not the project image should be hidden.
  var projectImageHidden: Signal<Bool, Never> { get }

  /// Emits with the project image url to be displayed.
  var projectImageURL: Signal<URL?, Never> { get }

  /// Emits when should seek video back to beginning.
  var seekToBeginning: Signal<Void, Never> { get }

  /// Emits a boolean to determine whether or not the video player should be hidden.
  var videoViewHidden: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `VideoViewModel`.
public protocol VideoViewModelType {
  /// Input receiver for playback events.
  var inputs: VideoViewModelInputs { get }
  /// Output signals observed by the video player controller.
  var outputs: VideoViewModelOutputs { get }
}

