import Foundation
import ReactiveSwift

/// Display payload describing a shipped reward's tracking number and carrier URL.
public struct RewardTrackingDetailsViewData {
  /// Carrier tracking number displayed to the backer.
  public let trackingNumber: String
  /// Optional external tracking URL opened when tapping the track button.
  public let trackingURL: URL?

  /// Creates tracking details view data with a tracking number and optional URL.
  public init(trackingNumber: String, trackingURL: URL?) {
    self.trackingNumber = trackingNumber
    self.trackingURL = trackingURL
  }
}

/// Inputs accepted by `RewardTrackingDetailsViewModel`.
public protocol RewardTrackingDetailsViewModelInputs {
  /// Configures the tracking view with shipment number and URL details.
  func configure(with data: RewardTrackingDetailsViewData)
  /// Signals that the user tapped the Track Shipment button.
  func trackingButtonTapped()
}

/// Outputs emitted by `RewardTrackingDetailsViewModel`.
public protocol RewardTrackingDetailsViewModelOutputs {
  /// Emits localized shipment status copy.
  var rewardTrackingStatus: Signal<String, Never> { get }
  /// Emits formatted tracking number copy.
  var rewardTrackingNumber: Signal<String, Never> { get }
  /// Emits whether the Track Shipment button should be hidden when no URL is available.
  var trackingButtonHidden: Signal<Bool, Never> { get }
  /// Emits the carrier tracking URL when the tracking button is tapped.
  var trackShipping: Signal<URL?, Never> { get }
}

/// Interface combining inputs and outputs for `RewardTrackingDetailsViewModel`.
public protocol RewardTrackingDetailsViewModelType {
  /// Input receiver for tracking details configuration and button taps.
  var inputs: RewardTrackingDetailsViewModelInputs { get }
  /// Output signals formatting tracking status, number, and navigation URLs.
  var outputs: RewardTrackingDetailsViewModelOutputs { get }
}

/// View model formatting shipment tracking details and opening carrier URLs.
public final class RewardTrackingDetailsViewModel: RewardTrackingDetailsViewModelType,
  RewardTrackingDetailsViewModelInputs,
  RewardTrackingDetailsViewModelOutputs {
  /// Initializes the reward tracking details view model.
  public init() {
    let configData = self.configDataSignal

    self.rewardTrackingNumber = configData.map {
      Strings.Tracking_number(number: $0.trackingNumber)
    }

    self.rewardTrackingStatus = configData
      .ignoreValues().map {
        Strings.Your_reward_has_shipped()
      }

    self.trackingButtonHidden = configData.map { $0.trackingURL == nil }

    self.trackShipping = configData
      .takeWhen(self.trackingButtonTappedSignal)
      .map { $0.trackingURL }
  }

  private let (configDataSignal, configDataObserver) = Signal<RewardTrackingDetailsViewData, Never>.pipe()
  /// Configures the view model with `RewardTrackingDetailsViewData`.
  public func configure(with data: RewardTrackingDetailsViewData) {
    self.configDataObserver.send(value: data)
  }

  private let (trackingButtonTappedSignal, trackingButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Handles tapping the tracking link button.
  public func trackingButtonTapped() {
    self.trackingButtonTappedObserver.send(value: ())
  }

  /// Emits localized shipment status copy.
  public var rewardTrackingStatus: Signal<String, Never>
  /// Emits the formatted tracking number string.
  public var rewardTrackingNumber: Signal<String, Never>
  /// Emits whether the Track button is hidden.
  public var trackingButtonHidden: Signal<Bool, Never>
  /// Emits the carrier tracking URL on button tap.
  public var trackShipping: Signal<URL?, Never>

  /// Returns `self` as `RewardTrackingDetailsViewModelInputs`.
  public var inputs: RewardTrackingDetailsViewModelInputs { return self }
  /// Returns `self` as `RewardTrackingDetailsViewModelOutputs`.
  public var outputs: RewardTrackingDetailsViewModelOutputs { return self }
}
