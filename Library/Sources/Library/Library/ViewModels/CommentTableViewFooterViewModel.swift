import KsApi
import ReactiveSwift

/// Display states for a comment table view footer.
public enum CommentTableViewFooterViewState {
  /// Loading indicator is visible while fetching comments.
  case activity
  /// Error state is visible with a retry action.
  case error
  /// Footer is hidden.
  case hidden
}

/// Inputs for `CommentTableViewFooterViewModel`.
public protocol CommentTableViewFooterViewModelInputs {
  /// Configures the footer with a display state.
  func configure(with value: CommentTableViewFooterViewState)
}

/// Outputs for `CommentTableViewFooterViewModel`.
public protocol CommentTableViewFooterViewModelOutputs {
  /// Emits whether the activity indicator should be hidden.
  var activityIndicatorHidden: Signal<Bool, Never> { get }
  /// Emits the bottom inset height for the footer.
  var bottomInsetHeight: Signal<Int, Never> { get }
  /// Emits whether the retry button should be hidden.
  var retryButtonHidden: Signal<Bool, Never> { get }
  /// Emits whether the root stack view should be hidden.
  var rootStackViewHidden: Signal<Bool, Never> { get }
}

/// Type interface for `CommentTableViewFooterViewModel`.
public protocol CommentTableViewFooterViewModelType {
  /// View model inputs.
  var inputs: CommentTableViewFooterViewModelInputs { get }
  /// View model outputs.
  var outputs: CommentTableViewFooterViewModelOutputs { get }
}

/// View model managing the loading/error footer state in comments table views.
public final class CommentTableViewFooterViewModel: CommentTableViewFooterViewModelType,
  CommentTableViewFooterViewModelInputs, CommentTableViewFooterViewModelOutputs {
  /// Initializes the footer view model and binds state signals.
  public init() {
    let state = self.stateProperty.signal.skipNil()

    self.activityIndicatorHidden = state.map { $0 == .activity }.negate()
    self.retryButtonHidden = state.map { $0 == .error }.negate()
    self.rootStackViewHidden = state.map { $0 == .hidden }

    // When the button is visible its content is aligned to top which pushes the text down
    // requiring more space at the bottom.
    self.bottomInsetHeight = state.map { state -> Int in
      if case .error = state { return 4 }
      return 2
    }
  }

  private let stateProperty = MutableProperty<CommentTableViewFooterViewState?>(nil)
  /// Configures the footer with a display state.
  public func configure(with value: CommentTableViewFooterViewState) {
    self.stateProperty.value = value
  }

  /// Emits whether the activity indicator should be hidden.
  public let activityIndicatorHidden: Signal<Bool, Never>
  /// Emits the bottom inset height for the footer.
  public let bottomInsetHeight: Signal<Int, Never>
  /// Emits whether the retry button should be hidden.
  public let retryButtonHidden: Signal<Bool, Never>
  /// Emits whether the root stack view should be hidden.
  public let rootStackViewHidden: Signal<Bool, Never>

  /// View model inputs.
  public var inputs: CommentTableViewFooterViewModelInputs { return self }
  /// View model outputs.
  public var outputs: CommentTableViewFooterViewModelOutputs { return self }
}
