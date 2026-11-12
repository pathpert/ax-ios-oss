import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input contract for `SettingsDeleteOrRequestCellViewModel`.
public protocol SettingsDeleteOrRequestCellViewModelInputs {
  /// Configures the cell with the current `User`.
  func configureWith(user: User)
  /// Call when the "Delete or request data" link/button is tapped.
  func deleteAccountTapped()
}

/// Output contract for `SettingsDeleteOrRequestCellViewModel`.
public protocol SettingsDeleteOrRequestCellViewModelOutputs {
  /// Emits the localized Kickstarter privacy portal URL for account deletion/data export.
  var notifyDeleteAccountTapped: Signal<URL, Never> { get }
}

/// Composite ViewModel protocol for the privacy-portal settings row.
public protocol SettingsDeleteOrRequestCellViewModelType {
  /// Input receiver.
  var inputs: SettingsDeleteOrRequestCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: SettingsDeleteOrRequestCellViewModelOutputs { get }
}

/// ViewModel generating the localized Kickstarter privacy-portal URL when users request or delete account data.
public final class SettingsDeleteOrRequestCellViewModel: SettingsDeleteOrRequestCellViewModelType,
  SettingsDeleteOrRequestCellViewModelInputs, SettingsDeleteOrRequestCellViewModelOutputs {
  /// Initializes the ViewModel and maps tap events to localized `legal.kickstarter.com` URLs.
  public init() {
    self.notifyDeleteAccountTapped = self.deleteAccountTappedProperty.signal
      .map {
        let code = Locale.current.languageCode ?? "en"
        return URL(string: "https://legal.kickstarter.com/policies/\(code)/?modal=take-control")
      }.skipNil()
  }

  fileprivate let deleteAccountTappedProperty = MutableProperty(())
  /// Triggers navigation to the data-control URL.
  public func deleteAccountTapped() {
    self.deleteAccountTappedProperty.value = ()
  }

  fileprivate let configureWithProperty = MutableProperty<User?>(nil)
  /// Binds the current `User` model.
  public func configureWith(user: User) {
    self.configureWithProperty.value = user
  }

  /// Emits the legal policy URL to open.
  public let notifyDeleteAccountTapped: Signal<URL, Never>

  /// Self-conformance to `SettingsDeleteOrRequestCellViewModelInputs`.
  public var inputs: SettingsDeleteOrRequestCellViewModelInputs { return self }
  /// Self-conformance to `SettingsDeleteOrRequestCellViewModelOutputs`.
  public var outputs: SettingsDeleteOrRequestCellViewModelOutputs { return self }
}
