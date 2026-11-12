import Foundation
import ReactiveSwift

/// Outputs emitted by `LoadingBarButtonItemViewModel`.
public protocol LoadingBarButtonItemViewModelOutputs {
  /// Emits whether the bar button's spinner is animating.
  var activityIndicatorIsLoading: Signal<Bool, Never> { get }
  /// Emits whether the bar button is enabled for interaction.
  var titleButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits whether the title button is hidden while loading.
  var titleButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits the bar button title text.
  var titleButtonText: Signal<String, Never> { get }
}

/// Inputs accepted by `LoadingBarButtonItemViewModel`.
public protocol LoadingBarButtonItemViewModelInputs {
  /// Updates whether the bar button is interactive.
  func setIsEnabled(isEnabled: Bool)
  /// Updates the displayed title text of the bar button.
  func setTitle(title: String)
  /// Updates whether the loading spinner replaces the button title.
  func setAnimating(isAnimating: Bool)
}

/// Interface combining inputs and outputs for `LoadingBarButtonItemViewModel`.
public protocol LoadingBarButtonItemViewModelType {
  /// Input receiver for bar button title, enabled, and animating states.
  var inputs: LoadingBarButtonItemViewModelInputs { get }
  /// Output signals updating the navigation bar button appearance.
  var outputs: LoadingBarButtonItemViewModelOutputs { get }
}

/// View model toggling a navigation `UIBarButtonItem` between title and loading spinner states.
public final class LoadingBarButtonItemViewModel: LoadingBarButtonItemViewModelType,
  LoadingBarButtonItemViewModelInputs, LoadingBarButtonItemViewModelOutputs {
  /// Initializes the loading bar button item view model.
  public init() {
    self.activityIndicatorIsLoading = self.isAnimatingProperty.signal
    self.titleButtonIsEnabled = self.isEnabledProperty.signal
    self.titleButtonIsHidden = self.isAnimatingProperty.signal
    self.titleButtonText = self.titleProperty.signal.skipNil()
  }

  private var isEnabledProperty = MutableProperty(false)
  /// Sets whether the bar button accepts taps.
  public func setIsEnabled(isEnabled: Bool) {
    self.isEnabledProperty.value = isEnabled
  }

  private var titleProperty = MutableProperty<String?>(nil)
  /// Sets the bar button's title text.
  public func setTitle(title: String) {
    self.titleProperty.value = title
  }

  private var isAnimatingProperty = MutableProperty(false)
  /// Sets whether the loading spinner is active.
  public func setAnimating(isAnimating: Bool) {
    self.isAnimatingProperty.value = isAnimating
  }

  /// Emits spinner animation state.
  public let activityIndicatorIsLoading: Signal<Bool, Never>
  /// Emits button enabled state.
  public let titleButtonIsEnabled: Signal<Bool, Never>
  /// Emits button visibility state.
  public let titleButtonIsHidden: Signal<Bool, Never>
  /// Emits button title text.
  public let titleButtonText: Signal<String, Never>

  /// Returns `self` as `LoadingBarButtonItemViewModelInputs`.
  public var inputs: LoadingBarButtonItemViewModelInputs {
    return self
  }

  /// Returns `self` as `LoadingBarButtonItemViewModelOutputs`.
  public var outputs: LoadingBarButtonItemViewModelOutputs {
    return self
  }
}
