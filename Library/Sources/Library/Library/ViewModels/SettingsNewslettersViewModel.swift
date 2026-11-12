import KsApi
import Prelude
import ReactiveSwift

/// Input contract for `SettingsNewslettersViewModel`.
public protocol SettingsNewslettersViewModelInputs {
  /// Updates the current `User` after a newsletter subscription toggle succeeds.
  func didUpdate(user: User)
  /// Notifies the ViewModel that the newsletter settings screen loaded.
  func viewDidLoad()
}

/// Output contract for `SettingsNewslettersViewModel`.
public protocol SettingsNewslettersViewModelOutputs {
  /// Emits the latest `User` model reflecting newsletter subscription states.
  var currentUser: Signal<User, Never> { get }
}

/// Composite ViewModel protocol pairing newsletter settings inputs and outputs.
public protocol SettingsNewslettersViewModelType {
  /// Input receiver.
  var inputs: SettingsNewslettersViewModelInputs { get }
  /// Output signal provider.
  var outputs: SettingsNewslettersViewModelOutputs { get }
}

/// ViewModel fetching and broadcasting newsletter subscription preferences for Settings.
public final class SettingsNewslettersViewModel: SettingsNewslettersViewModelType,
  SettingsNewslettersViewModelInputs, SettingsNewslettersViewModelOutputs {
  /// Initializes user fetch and update-merge bindings.
  public init() {
    let initialUser = self.viewDidLoadProperty.signal
      .flatMap {
        AppEnvironment.current.apiService.fetchUserSelf()
          .wrapInOptional()
          .prefix(value: AppEnvironment.current.currentUser)
          .demoteErrors()
      }
      .skipNil()
      .skipRepeats()

    let updatedUser = self.didUpdateUserProperty.signal.skipNil()

    self.currentUser = Signal.merge(initialUser, updatedUser)
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals initial view load to refresh user subscription state.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let didUpdateUserProperty = MutableProperty<User?>(nil)
  /// Pushes an updated `User` snapshot from child cell updates.
  public func didUpdate(user: User) {
    self.didUpdateUserProperty.value = user
  }

  /// Emits updated `User` objects.
  public let currentUser: Signal<User, Never>

  /// Self-conformance to `SettingsNewslettersViewModelInputs`.
  public var inputs: SettingsNewslettersViewModelInputs { return self }
  /// Self-conformance to `SettingsNewslettersViewModelOutputs`.
  public var outputs: SettingsNewslettersViewModelOutputs { return self }
}
