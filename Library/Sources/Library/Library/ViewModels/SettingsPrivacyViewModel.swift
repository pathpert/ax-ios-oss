import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `SettingsPrivacyViewModel`.
public protocol SettingsPrivacyViewModelInputs {
  /// Signals that the user cancelled opting out of social following.
  func didCancelSocialOptOut()
  /// Signals that the user confirmed opting out of social following.
  func didConfirmSocialOptOut()
  /// Submits an explicit updated `User` model for persistence.
  func didUpdate(user: User)
  /// Updates whether the user's profile is set to private.
  func privateProfileToggled(on: Bool)
  /// Signals that the privacy settings view has loaded.
  func viewDidLoad()
}

/// Outputs emitted by `SettingsPrivacyViewModel`.
public protocol SettingsPrivacyViewModelOutputs {
  /// Emits when VoiceOver focus should return to the Following privacy cell.
  var focusScreenReaderOnFollowingCell: Signal<Void, Never> { get }
  /// Emits the current `User` when privacy rows should reload.
  var reloadData: Signal<User, Never> { get }
  /// Emits when the Following section toggle should revert after cancellation.
  var resetFollowingSection: Signal<Void, Never> { get }
  /// Emits an error message string if saving privacy settings fails.
  var unableToSaveError: Signal<String, Never> { get }
  /// Emits the persisted (or reverted) `User` model after a save attempt.
  var updateCurrentUser: Signal<User, Never> { get }
}

/// Interface combining inputs and outputs for `SettingsPrivacyViewModel`.
public protocol SettingsPrivacyViewModelType {
  /// Input receiver for privacy toggle and opt-out actions.
  var inputs: SettingsPrivacyViewModelInputs { get }
  /// Output signals updating privacy UI state and current user preferences.
  var outputs: SettingsPrivacyViewModelOutputs { get }
}

/// View model managing profile visibility and social following privacy preferences.
public final class SettingsPrivacyViewModel: SettingsPrivacyViewModelType,
  SettingsPrivacyViewModelInputs, SettingsPrivacyViewModelOutputs {
  /// Initializes the privacy settings view model.
  public init() {
    let initialUser = self.viewDidLoadProperty.signal
      .flatMap { _ in
        AppEnvironment.current.apiService.fetchUserSelf()
          .wrapInOptional()
          .prefix(value: AppEnvironment.current.currentUser)
          .demoteErrors()
      }
      .skipNil()

    self.reloadData = initialUser

    let privateProfileAttributeChanged: Signal<(UserAttribute, Bool), Never> =
      self.privateProfileProperty.signal.negate()
        .map { (UserAttribute.privacy(UserAttribute.Privacy.showPublicProfile), $0) }

    let followingAttributeChanged = self.didConfirmSocialOptOutProperty.signal
      .map { _ in
        (UserAttribute.privacy(UserAttribute.Privacy.following), false)
      }

    let userAttributeChanged = Signal.merge(privateProfileAttributeChanged, followingAttributeChanged)

    let updatedUser = initialUser
      .switchMap { user in
        userAttributeChanged.scan(user) { user, attributeAndOn in
          let (attribute, on) = attributeAndOn
          return user |> attribute.keyPath .~ on
        }
      }

    let updateEvent = Signal.merge(updatedUser, self.updateUserProperty.signal.skipNil())
      .switchMap {
        AppEnvironment.current.apiService.updateUserSelf($0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let updatedFetchedUser = updateEvent.values()

    self.unableToSaveError = updateEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.profile_settings_error()
      }

    let previousUserOnError = Signal.merge(initialUser, updatedUser)
      .combinePrevious()
      .takeWhen(self.unableToSaveError)
      .map { previous, _ in previous }

    self.updateCurrentUser = Signal.merge(updatedFetchedUser, previousUserOnError)

    self.resetFollowingSection = self.didCancelSocialOptOutProperty.signal

    self.focusScreenReaderOnFollowingCell = Signal.merge(
      self.didCancelSocialOptOutProperty.signal,
      self.didConfirmSocialOptOutProperty.signal
    )
    .filter { _ in AppEnvironment.current.isVoiceOverRunning() }
  }

  fileprivate let didCancelSocialOptOutProperty = MutableProperty(())
  /// Reverts the Following toggle after cancelling opt-out confirmation.
  public func didCancelSocialOptOut() {
    self.didCancelSocialOptOutProperty.value = ()
  }

  fileprivate let didConfirmSocialOptOutProperty = MutableProperty(())
  /// Persists opting out of social following after confirmation.
  public func didConfirmSocialOptOut() {
    self.didConfirmSocialOptOutProperty.value = ()
  }

  fileprivate let privateProfileProperty = MutableProperty<Bool>(true)
  /// Updates whether the user's public profile should be hidden.
  public func privateProfileToggled(on: Bool) {
    self.privateProfileProperty.value = on
  }

  fileprivate let updateUserProperty = MutableProperty<User?>(nil)
  /// Triggers saving an externally modified `User` privacy state.
  public func didUpdate(user: User) {
    self.updateUserProperty.value = user
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the privacy settings view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits when VoiceOver should focus on the Following cell.
  public let focusScreenReaderOnFollowingCell: Signal<Void, Never>
  /// Emits the initial or refreshed `User` model.
  public let reloadData: Signal<User, Never>
  /// Emits when the Following section needs to reset.
  public let resetFollowingSection: Signal<Void, Never>
  /// Emits an error string when updating privacy settings fails.
  public let unableToSaveError: Signal<String, Never>
  /// Emits the synchronized `User` model after mutation or rollback.
  public let updateCurrentUser: Signal<User, Never>

  /// Returns `self` as `SettingsPrivacyViewModelInputs`.
  public var inputs: SettingsPrivacyViewModelInputs { return self }
  /// Returns `self` as `SettingsPrivacyViewModelOutputs`.
  public var outputs: SettingsPrivacyViewModelOutputs { return self }
}
