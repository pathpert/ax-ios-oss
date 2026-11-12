import Foundation
import ReactiveSwift

/// Input events handled by `KSRSearchBarViewModel`.
public protocol KSRSearchBarViewModelInputs {
  /// Call when the cancel button is pressed.
  func cancelButtonPressed()

  /// Call when the search clear button is tapped.
  func clearSearchText()

  /// Call when the search field begins editing.
  func searchFieldDidBeginEditing()

  /// Call when the user taps the return key.
  func searchTextEditingDidEnd()

  /// Call when the user enters a new search term.
  func searchTextChanged(_ searchText: String)
}

/// Output signals exposed by `KSRSearchBarViewModel`.
public protocol KSRSearchBarViewModelOutputs {
  /// Emits booleans that determines if the search field should be focused or not, and whether that focus
  /// should be animated.
  var changeSearchFieldFocus: Signal<Bool, Never> { get }

  /// Emits when the search field should resign focus.
  var resignFirstResponder: Signal<(), Never> { get }

  /// Emits a string that should be filled into the search field.
  var searchFieldText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `KSRSearchBarViewModel`.
public protocol KSRSearchBarViewModelType {
  /// Input receiver for search bar focus and text editing events.
  var inputs: KSRSearchBarViewModelInputs { get }
  /// Output signals managing search field text and responder focus.
  var outputs: KSRSearchBarViewModelOutputs { get }
}

/// View model managing search text state and keyboard focus for the custom search bar.
public final class KSRSearchBarViewModel: KSRSearchBarViewModelType, KSRSearchBarViewModelInputs,
  KSRSearchBarViewModelOutputs {
  /// Initializes the search bar view model.
  public init() {
    self.changeSearchFieldFocus = Signal.merge(
      self.searchFieldDidBeginEditingProperty.signal.mapConst(true),
      self.searchTextEditingDidEndProperty.signal.mapConst(false)
    )

    self.searchFieldText = Signal.merge(
      self.searchTextChangedProperty.signal,
      self.cancelButtonPressedProperty.signal.mapConst(""),
      self.clearSearchTextProperty.signal.mapConst("")
    )

    self.resignFirstResponder = Signal
      .merge(
        self.cancelButtonPressedProperty.signal,
        self.searchTextEditingDidEndProperty.signal
      )
  }

  // MARK: - Inputs

  private let cancelButtonPressedProperty = MutableProperty(())
  /// Clears search text and resigns focus when Cancel is pressed.
  public func cancelButtonPressed() {
    self.cancelButtonPressedProperty.value = ()
  }

  private let clearSearchTextProperty = MutableProperty(())
  /// Clears the active search field text.
  public func clearSearchText() {
    self.clearSearchTextProperty.value = ()
  }

  private let searchFieldDidBeginEditingProperty = MutableProperty(())
  /// Signals that the user focused the search input field.
  public func searchFieldDidBeginEditing() {
    self.searchFieldDidBeginEditingProperty.value = ()
  }

  private let searchTextEditingDidEndProperty = MutableProperty(())
  /// Signals that search text editing ended (e.g., return key tapped).
  public func searchTextEditingDidEnd() {
    self.searchTextEditingDidEndProperty.value = ()
  }

  private let searchTextChangedProperty = MutableProperty("")
  /// Updates the current query text entered in the search bar.
  public func searchTextChanged(_ searchText: String) {
    self.searchTextChangedProperty.value = searchText
  }

  // MARK: - Outputs

  /// Emits whether the search field should focus (`true`) or unfocus (`false`).
  public let changeSearchFieldFocus: Signal<Bool, Never>
  /// Emits when the search field should resign first responder.
  public let resignFirstResponder: Signal<(), Never>
  /// Emits updated search field text after edits or resets.
  public let searchFieldText: Signal<String, Never>

  // MARK: - KSRSearchBarViewModelType

  /// Returns `self` as `KSRSearchBarViewModelInputs`.
  public var inputs: KSRSearchBarViewModelInputs { return self }
  /// Returns `self` as `KSRSearchBarViewModelOutputs`.
  public var outputs: KSRSearchBarViewModelOutputs { return self }
}
