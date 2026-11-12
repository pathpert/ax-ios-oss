import Prelude
import ReactiveSwift

/// Input contract for `LoadingButtonViewModel`.
public protocol LoadingButtonViewModelInputs {
  /// Updates loading state (`true` disables interaction and starts spinner; `false` re-enables and stops spinner).
  func isLoading(_ isLoading: Bool)
}

/// Output contract for `LoadingButtonViewModel`.
public protocol LoadingButtonViewModelOutputs {
  /// Emits whether the button should accept user interaction (`!isLoading`).
  var isUserInteractionEnabled: Signal<Bool, Never> { get }
  /// Emits when `isLoading(true)` transitions the button into loading state.
  var startLoading: Signal<Void, Never> { get }
  /// Emits when `isLoading(false)` restores idle state.
  var stopLoading: Signal<Void, Never> { get }
}

/// Composite ViewModel protocol pairing loading button inputs and outputs.
public protocol LoadingButtonViewModelType {
  /// Input receiver.
  var inputs: LoadingButtonViewModelInputs { get }
  /// Output signal provider.
  var outputs: LoadingButtonViewModelOutputs { get }
}

/// ViewModel managing interaction locking and spinner lifecycle for `LoadingButton`.
///
/// Negative Constraint: Expects explicit `isLoading(_:)` calls; does not auto-timeout.
public final class LoadingButtonViewModel:
  LoadingButtonViewModelType,
  LoadingButtonViewModelInputs,
  LoadingButtonViewModelOutputs {
  /// Initializes signals deriving interaction state and start/stop triggers from `isLoading(_:)`.
  public init() {
    let isLoading = self.isLoadingProperty.signal
      .skipNil()

    self.isUserInteractionEnabled = isLoading
      .negate()

    self.startLoading = isLoading
      .filter(isTrue)
      .ignoreValues()

    self.stopLoading = isLoading
      .filter(isFalse)
      .ignoreValues()
  }

  private let isLoadingProperty = MutableProperty<Bool?>(nil)
  /// Sends a loading state update.
  public func isLoading(_ isLoading: Bool) {
    self.isLoadingProperty.value = isLoading
  }

  /// Emits `false` while loading, `true` when idle.
  public let isUserInteractionEnabled: Signal<Bool, Never>
  /// Fires on `isLoading(true)`.
  public let startLoading: Signal<Void, Never>
  /// Fires on `isLoading(false)`.
  public let stopLoading: Signal<Void, Never>

  /// Self-conformance to `LoadingButtonViewModelInputs`.
  public var inputs: LoadingButtonViewModelInputs { return self }
  /// Self-conformance to `LoadingButtonViewModelOutputs`.
  public var outputs: LoadingButtonViewModelOutputs { return self }
}
