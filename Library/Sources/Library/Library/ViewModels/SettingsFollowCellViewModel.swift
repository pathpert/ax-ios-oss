import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs for `SettingsFollowCellViewModel`.
public protocol SettingsFollowCellViewModelInputs {
  /// Configures the cell with the current signed-in user.
  func configureWith(user: User)
  /// Called when the social following privacy toggle is changed.
  func followTapped(on: Bool)
}

/// Outputs for `SettingsFollowCellViewModel`.
public protocol SettingsFollowCellViewModelOutputs {
  /// Emits whether social following privacy is currently enabled.
  var followingPrivacyOn: Signal<Bool, Never> { get }
  /// Emits when disabling following should prompt a confirmation dialog.
  var showPrivacyFollowingPrompt: Signal<(), Never> { get }
  /// Emits the updated user model when following privacy changes.
  var updateCurrentUser: Signal<User, Never> { get }
}

/// Type interface for `SettingsFollowCellViewModel`.
public protocol SettingsFollowCellViewModelType {
  /// View model inputs.
  var inputs: SettingsFollowCellViewModelInputs { get }
  /// View model outputs.
  var outputs: SettingsFollowCellViewModelOutputs { get }
}

/// View model managing the social-following privacy toggle cell in Settings.
public final class SettingsFollowCellViewModel: SettingsFollowCellViewModelType,
  SettingsFollowCellViewModelInputs, SettingsFollowCellViewModelOutputs {
  /// Initializes the settings follow cell view model and binds user attribute updates.
  public init() {
    let initialUser = self.configureWithProperty.signal.skipNil()

    let userAttributeChanged: Signal<(UserAttribute, Bool), Never> =
      self.followTappedProperty.signal.filter { $0 == true }.map {
        (UserAttribute.privacy(UserAttribute.Privacy.following), $0)
      }

    self.updateCurrentUser = initialUser
      .switchMap { user in
        userAttributeChanged.scan(user) { user, attributeAndOn in
          let (attribute, on) = attributeAndOn
          return user |> attribute.keyPath .~ on
        }
      }

    self.followingPrivacyOn = initialUser
      .map { $0.social }.skipNil()

    self.showPrivacyFollowingPrompt = self.followTappedProperty.signal
      .filter { $0 == false }
      .ignoreValues()
  }

  fileprivate let configureWithProperty = MutableProperty<User?>(nil)
  /// Configures the cell with the signed-in user.
  public func configureWith(user: User) {
    self.configureWithProperty.value = user
  }

  fileprivate let followTappedProperty = MutableProperty(false)
  /// Called when the follow toggle switch is changed.
  public func followTapped(on: Bool) {
    self.followTappedProperty.value = on
  }

  /// Emits the user's current social-following setting.
  public let followingPrivacyOn: Signal<Bool, Never>
  /// Emits when disabling social-following requires a confirmation prompt.
  public let showPrivacyFollowingPrompt: Signal<(), Never>
  /// Emits the updated `User` after enabling social-following.
  public let updateCurrentUser: Signal<User, Never>

  /// View model inputs.
  public var inputs: SettingsFollowCellViewModelInputs { return self }
  /// View model outputs.
  public var outputs: SettingsFollowCellViewModelOutputs { return self }
}
