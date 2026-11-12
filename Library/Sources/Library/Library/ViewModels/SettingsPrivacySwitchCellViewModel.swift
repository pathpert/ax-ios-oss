import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Output contract for `SettingsPrivacySwitchCellViewModel`.
public protocol SettingsPrivacySwitchCellViewModelOutputs {
  /// Emits whether the private-profile switch should render ON (`!(user.showPublicProfile ?? false)`).
  var privacySwitchIsOn: Signal<Bool, Never> { get }
  /// Emits user toggle changes from the switch control.
  var privacySwitchToggledOn: Signal<Bool, Never> { get }
}

/// Input contract for `SettingsPrivacySwitchCellViewModel`.
public protocol SettingsPrivacySwitchCellViewModelInputs {
  /// Configures the switch from the current `User`.
  func configure(with user: User)
  /// Notifies the ViewModel when the user toggles the privacy switch.
  func switchToggled(on: Bool)
}

/// Composite ViewModel protocol for privacy switch settings cells.
public protocol SettingsPrivacySwitchCellViewModelType {
  /// Input receiver.
  var inputs: SettingsPrivacySwitchCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: SettingsPrivacySwitchCellViewModelOutputs { get }
}

/// ViewModel managing the "Private Profile" switch inside Privacy Settings.
///
/// Negative Constraint: Inverts `User.showPublicProfile` so ON means profile is hidden.
public final class SettingsPrivacySwitchCellViewModel: SettingsPrivacySwitchCellViewModelType,
  SettingsPrivacySwitchCellViewModelInputs, SettingsPrivacySwitchCellViewModelOutputs {
  /// Initializes switch state and toggle forwarding signals.
  public init() {
    self.privacySwitchIsOn = self.userProperty.signal
      .skipNil()
      .map { ($0 |> (\User.showPublicProfile).view) ?? false }
      .negate()

    self.privacySwitchToggledOn = self.switchToggledProperty.signal
  }

  private let userProperty = MutableProperty<User?>(nil)
  /// Binds the current `User` model to derive initial switch state.
  public func configure(with user: User) {
    self.userProperty.value = user
  }

  private let switchToggledProperty = MutableProperty<Bool>(false)
  /// Forwards switch toggle events.
  public func switchToggled(on: Bool) {
    self.switchToggledProperty.value = on
  }

  /// Emits initial/configured private-profile switch state.
  public let privacySwitchIsOn: Signal<Bool, Never>
  /// Emits user-initiated switch state updates.
  public let privacySwitchToggledOn: Signal<Bool, Never>

  /// Self-conformance to `SettingsPrivacySwitchCellViewModelInputs`.
  public var inputs: SettingsPrivacySwitchCellViewModelInputs {
    return self
  }

  /// Self-conformance to `SettingsPrivacySwitchCellViewModelOutputs`.
  public var outputs: SettingsPrivacySwitchCellViewModelOutputs {
    return self
  }
}
