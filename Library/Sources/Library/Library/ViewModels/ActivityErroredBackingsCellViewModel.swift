import KsApi
import ReactiveSwift

/// Input actions for `ActivityErroredBackingsCellViewModel`.
public protocol ActivityErroredBackingsCellInputs {
  /// Configures the banner cell with the user's failed backings.
  func configure(with value: [ProjectAndBackingEnvelope])
}

/// Output signals for `ActivityErroredBackingsCellViewModel`.
public protocol ActivityErroredBackingsCellOutputs {
  /// Emits errored project-and-backing pairs to render in the stacked banner.
  var erroredBackings: Signal<[ProjectAndBackingEnvelope], Never> { get }
}

/// Combined inputs/outputs contract for `ActivityErroredBackingsCellViewModel`.
public protocol ActivityErroredBackingsCellViewModelType {
  /// Input receiver.
  var inputs: ActivityErroredBackingsCellInputs { get }
  /// Output signals.
  var outputs: ActivityErroredBackingsCellOutputs { get }
}

/// View model exposing errored backings to `ActivityErroredBackingsCell`.
public final class ActivityErroredBackingsCellViewModel: ActivityErroredBackingsCellViewModelType,
  ActivityErroredBackingsCellInputs, ActivityErroredBackingsCellOutputs {
  /// Initializes the errored backings signal pipe.
  public init() {
    self.erroredBackings = self.backingsSignal
  }

  private let (backingsSignal, backingsObserver) = Signal<[ProjectAndBackingEnvelope], Never>.pipe()
  /// Supplies the list of errored backings to render.
  public func configure(with value: [ProjectAndBackingEnvelope]) {
    self.backingsObserver.send(value: value)
  }

  /// Emits errored backings arrays received from `configure(with:)`.
  public let erroredBackings: Signal<[ProjectAndBackingEnvelope], Never>

  /// Concrete input interface.
  public var inputs: ActivityErroredBackingsCellInputs { return self }
  /// Concrete output interface.
  public var outputs: ActivityErroredBackingsCellOutputs { return self }
}
