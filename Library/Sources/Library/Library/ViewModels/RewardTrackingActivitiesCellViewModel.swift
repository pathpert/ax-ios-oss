import Foundation
import KsApi
import ReactiveSwift

/// Payload pairing reward tracking details with the associated `Project`.
public struct RewardTrackingActivitiesCellData {
  /// Shipment tracking details for the reward.
  public let trackingData: RewardTrackingDetailsViewData
  /// Backed project whose reward shipped.
  public let project: Project

  /// Creates cell data combining `trackingData` and `project`.
  public init(trackingData: RewardTrackingDetailsViewData, project: Project) {
    self.trackingData = trackingData
    self.project = project
  }
}

/// Inputs accepted by `RewardTrackingActivitiesCellViewModel`.
public protocol RewardTrackingActivitiesCellViewModelInputs {
  /// Configures the cell with the backed `Project`.
  func configure(with data: Project)
}

/// Outputs emitted by `RewardTrackingActivitiesCellViewModel`.
public protocol RewardTrackingActivitiesCellViewModelOutputs {
  /// Emits the project title.
  var projectName: Signal<String, Never> { get }
  /// Emits the project's full thumbnail image URL.
  var projectImageURL: Signal<URL, Never> { get }
}

/// Interface combining inputs and outputs for `RewardTrackingActivitiesCellViewModel`.
public protocol RewardTrackingActivitiesCellViewModelType {
  /// Input receiver for project configuration.
  var inputs: RewardTrackingActivitiesCellViewModelInputs { get }
  /// Output signals formatting project name and image URL.
  var outputs: RewardTrackingActivitiesCellViewModelOutputs { get }
}

/// View model formatting reward-tracking activity cell metadata.
public final class RewardTrackingActivitiesCellViewModel: RewardTrackingActivitiesCellViewModelType,
  RewardTrackingActivitiesCellViewModelInputs,
  RewardTrackingActivitiesCellViewModelOutputs {
  /// Initializes the reward tracking activities cell view model.
  public init() {
    self.projectName = self.configDataSignal.map { $0.name }
    self.projectImageURL = self.configDataSignal.map { URL(string: $0.photo.full) }.skipNil()
  }

  private let (configDataSignal, configDataObserver) = Signal<Project, Never>.pipe()
  /// Configures the cell with a `Project`.
  public func configure(with data: Project) {
    self.configDataObserver.send(value: data)
  }

  /// Emits the project's display name.
  public let projectName: Signal<String, Never>
  /// Emits the full-resolution project photo URL.
  public let projectImageURL: Signal<URL, Never>

  /// Returns `self` as `RewardTrackingActivitiesCellViewModelInputs`.
  public var inputs: RewardTrackingActivitiesCellViewModelInputs { return self }
  /// Returns `self` as `RewardTrackingActivitiesCellViewModelOutputs`.
  public var outputs: RewardTrackingActivitiesCellViewModelOutputs { return self }
}
