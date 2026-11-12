import KsApi
import Prelude
import ReactiveSwift

/// Output signals for `SettingsNotificationPickerViewModel`.
public protocol SettingsNotificationPickerViewModelOutputs {
  /// Emits the localized email digest frequency label text.
  var frequencyValueText: Signal<String, Never> { get }
}

/// Input actions for `SettingsNotificationPickerViewModel`.
public protocol SettingsNotificationPickerViewModelInputs {
  /// Configures the picker view model with the current notification row value.
  func configure(with cellValue: SettingsNotificationCellValue)
}

/// Combined inputs/outputs contract for `SettingsNotificationPickerViewModel`.
public protocol SettingsNotificationPickerViewModelType {
  /// Input receiver.
  var inputs: SettingsNotificationPickerViewModelInputs { get }
  /// Output signals.
  var outputs: SettingsNotificationPickerViewModelOutputs { get }
}

/// View model resolving localized email digest frequency labels for creator notification rows.
public final class SettingsNotificationPickerViewModel: SettingsNotificationPickerViewModelOutputs,
  SettingsNotificationPickerViewModelInputs, SettingsNotificationPickerViewModelType {
  /// Initializes digest frequency label mappings.
  public init() {
    let initialUser = self.initialUserProperty.signal.skipNil()

    let userDefinedEmailFrequency = initialUser.signal
      .map { user in
        user |> UserAttribute.notification(.creatorDigest).keyPath.view
      }.skipNil()
      .map { creatorDigestEnabled in
        creatorDigestEnabled ? EmailFrequency.dailySummary : EmailFrequency.twiceADaySummary
      }

    self.frequencyValueText = userDefinedEmailFrequency.signal
      .map { $0.descriptionText }
  }

  fileprivate var initialUserProperty = MutableProperty<User?>(nil)
  /// Configures the picker with the current user's notification cell value.
  public func configure(with cellValue: SettingsNotificationCellValue) {
    self.initialUserProperty.value = cellValue.user
  }

  /// Emits localized digest summary copy (`dailySummary` or `twiceADaySummary`).
  public let frequencyValueText: Signal<String, Never>

  /// Concrete output interface.
  public var outputs: SettingsNotificationPickerViewModelOutputs {
    return self
  }

  /// Concrete input interface.
  public var inputs: SettingsNotificationPickerViewModelInputs {
    return self
  }
}
