import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `SettingsRecommendationsCellViewModel`.
public protocol SettingsRecommendationsCellViewModelInputs {
  /// Configures the cell with the signed-in `User`.
  func configureWith(user: User)
  /// Updates the user's recommendation opt-in preference switch.
  func recommendationsTapped(on: Bool)
}

/// Outputs emitted by `SettingsRecommendationsCellViewModel`.
public protocol SettingsRecommendationsCellViewModelOutputs {
  /// Emits `.ksr_recommendationsSettingChanged` notification after persisting a toggle change.
  var postNotification: Signal<Notification, Never> { get }
  /// Emits whether personalized recommendations are currently enabled.
  var recommendationsOn: Signal<Bool, Never> { get }
  /// Emits an error message string if saving the preference fails.
  var unableToSaveError: Signal<String, Never> { get }
  /// Emits the persisted or reverted `User` model.
  var updateCurrentUser: Signal<User, Never> { get }
}

/// Interface combining inputs and outputs for `SettingsRecommendationsCellViewModel`.
public protocol SettingsRecommendationsCellViewModelType {
  /// Input receiver for recommendation preference toggles.
  var inputs: SettingsRecommendationsCellViewModelInputs { get }
  /// Output signals updating the switch state and persisting preference changes.
  var outputs: SettingsRecommendationsCellViewModelOutputs { get }
}

/// View model managing the personalized project recommendations toggle in Privacy Settings.
public final class SettingsRecommendationsCellViewModel: SettingsRecommendationsCellViewModelType,
  SettingsRecommendationsCellViewModelInputs, SettingsRecommendationsCellViewModelOutputs {
  /// Initializes the settings recommendations cell view model.
  public init() {
    let initialUser = self.configureWithProperty.signal
      .skipNil()

    let userAttributeChanged: Signal<(UserAttribute, Bool), Never> =
      self.recommendationsTappedProperty.signal.map {
        (UserAttribute.privacy(UserAttribute.Privacy.recommendations), !$0)
      }

    let updatedUser = initialUser
      .switchMap { user in
        userAttributeChanged.scan(user) { user, attributeAndOn in
          let (attribute, on) = attributeAndOn
          return user |> attribute.keyPath .~ on
        }
      }

    let updateEvent = updatedUser
      .switchMap {
        AppEnvironment.current.apiService.updateUserSelf($0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.postNotification = updateEvent.values()
      .map { _ in
        Notification(
          name: .ksr_recommendationsSettingChanged,
          userInfo: nil
        )
      }

    self.unableToSaveError = updateEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.profile_settings_error()
      }

    let previousUserOnError = Signal.merge(initialUser, updatedUser)
      .combinePrevious()
      .takeWhen(self.unableToSaveError)
      .map { previous, _ in previous }

    self.updateCurrentUser = Signal.merge(initialUser, updatedUser, previousUserOnError)

    self.recommendationsOn = self.updateCurrentUser
      .map { $0.optedOutOfRecommendations }.skipNil().map { $0 ? false : true }.skipRepeats()
  }

  fileprivate let configureWithProperty = MutableProperty<User?>(nil)
  /// Configures the recommendations preference cell with `user`.
  public func configureWith(user: User) {
    self.configureWithProperty.value = user
  }

  fileprivate let recommendationsTappedProperty = MutableProperty(false)
  /// Updates whether recommendations are turned on and persists the setting.
  public func recommendationsTapped(on: Bool) {
    self.recommendationsTappedProperty.value = on
  }

  /// Emits recommendation change notifications after a successful save.
  public let postNotification: Signal<Notification, Never>
  /// Emits whether personalized recommendations are enabled.
  public let recommendationsOn: Signal<Bool, Never>
  /// Emits error alert copy if saving fails.
  public let unableToSaveError: Signal<String, Never>
  /// Emits updated or reverted `User` values.
  public let updateCurrentUser: Signal<User, Never>

  /// Returns `self` as `SettingsRecommendationsCellViewModelInputs`.
  public var inputs: SettingsRecommendationsCellViewModelInputs { return self }
  /// Returns `self` as `SettingsRecommendationsCellViewModelOutputs`.
  public var outputs: SettingsRecommendationsCellViewModelOutputs { return self }
}
