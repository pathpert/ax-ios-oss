/**
 FIXME: This VM and its tests should be moved to the Library framework and refactored to not need the
 `viewControllerFactory` passed to its initializer.
 */

import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `SettingsViewModel`.
public protocol SettingsViewModelInputs {
  /// Signals that the current user profile was refreshed.
  func currentUserUpdated()
  /// Confirms that the user chose to log out from the confirmation prompt.
  func logoutConfirmed()
  /// Signals that a settings row of `cellType` was tapped.
  func settingsCellTapped(cellType: SettingsCellType)
  /// Signals that the settings view loaded.
  func viewDidLoad()
  /// Signals that the settings view is about to appear.
  func viewWillAppear()
}

/// Outputs emitted by `SettingsViewModel`.
public protocol SettingsViewModelOutputs {
  /// Property tracking whether Find Friends is disabled for the current user.
  var findFriendsDisabledProperty: MutableProperty<Bool> { get }
  /// Emits the App Store rating URL string when rating is selected.
  var goToAppStoreRating: Signal<String, Never> { get }
  /// Emits discovery parameters to load after logout completes.
  var logoutWithParams: Signal<DiscoveryParams, Never> { get }
  /// Emits the current user whenever settings rows should reload.
  var reloadDataWithUser: Signal<User, Never> { get }
  /// Emits alert copy for confirming user logout.
  var showConfirmLogoutPrompt: Signal<(message: String, cancel: String, confirm: String), Never> { get }
  /// Emits a destination view controller constructed for a tapped settings cell.
  var transitionToViewController: Signal<UIViewController, Never> { get }
}

/// Interface combining inputs, outputs, and row-selection policy for `SettingsViewModel`.
public protocol SettingsViewModelType {
  /// Input receiver for settings screen interactions.
  var inputs: SettingsViewModelInputs { get }
  /// Output signals driving settings presentation and navigation.
  var outputs: SettingsViewModelOutputs { get }

  /// Returns whether the row corresponding to `cellType` should be selectable.
  func shouldSelectRow(for cellType: SettingsCellType) -> Bool
}

/// View model managing account settings sections, logout confirmation, and row navigation.
public final class SettingsViewModel: SettingsViewModelInputs,
  SettingsViewModelOutputs, SettingsViewModelType {
  /// Initializes the settings view model with a destination view controller factory.
  public init(_ viewControllerFactory: @escaping (SettingsCellType) -> UIViewController?) {
    let user = Signal.merge(
      self.viewDidLoadProperty.signal,
      self.currentUserUpdatedProperty.signal
    )
    .flatMap {
      AppEnvironment.current.apiService.fetchUserSelf()
        .wrapInOptional()
        .prefix(value: AppEnvironment.current.currentUser)
        .demoteErrors()
    }
    .skipNil()

    let isFollowingEnabled = user
      .map { $0 |> (\User.social).view }
      .map { $0 ?? true }

    self.findFriendsDisabledProperty <~ isFollowingEnabled.negate()

    self.reloadDataWithUser = Signal.zip(user, self.findFriendsDisabledProperty.signal).map(first)

    self.showConfirmLogoutPrompt = self.selectedCellTypeProperty.signal
      .skipNil()
      .filter { $0 == .logout }
      .map { _ in
        (
          message: Strings.profile_settings_logout_alert_message(),
          cancel: Strings.profile_settings_logout_alert_cancel_button(),
          confirm: Strings.Yes()
        )
      }

    self.logoutWithParams = self.logoutConfirmedProperty.signal
      .map { .defaults
        |> DiscoveryParams.lens.includePOTD .~ true
        |> DiscoveryParams.lens.sort .~ .magic
      }

    self.goToAppStoreRating = self.selectedCellTypeProperty.signal
      .skipNil()
      .filter { $0 == .rateInAppStore }
      .map { _ in AppEnvironment.current.config?.iTunesLink ?? "" }

    self.transitionToViewController = self.selectedCellTypeProperty.signal
      .skipNil()
      .map(viewControllerFactory)
      .skipNil()
  }

  private var currentUserUpdatedProperty = MutableProperty(())
  /// Signals that the signed-in user changed and settings should reload.
  public func currentUserUpdated() {
    self.currentUserUpdatedProperty.value = ()
  }

  private var selectedCellTypeProperty = MutableProperty<SettingsCellType?>(nil)
  /// Handles tapping a settings row of the given `cellType`.
  public func settingsCellTapped(cellType: SettingsCellType) {
    self.selectedCellTypeProperty.value = cellType
  }

  fileprivate let logoutConfirmedProperty = MutableProperty(())
  /// Signals that the user confirmed logging out.
  public func logoutConfirmed() {
    self.logoutConfirmedProperty.value = ()
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the settings view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the settings view will appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  /// Property tracking whether Find Friends is disabled.
  public let findFriendsDisabledProperty = MutableProperty<Bool>(false)
  /// Emits the App Store rating URL string.
  public let goToAppStoreRating: Signal<String, Never>
  /// Emits default discovery params after logout confirmation.
  public let logoutWithParams: Signal<DiscoveryParams, Never>
  /// Emits logout confirmation dialog text.
  public let showConfirmLogoutPrompt: Signal<(message: String, cancel: String, confirm: String), Never>
  /// Emits the latest `User` model when settings rows should refresh.
  public let reloadDataWithUser: Signal<User, Never>
  /// Emits the next view controller for non-logout settings cells.
  public let transitionToViewController: Signal<UIViewController, Never>

  /// Returns `self` as `SettingsViewModelInputs`.
  public var inputs: SettingsViewModelInputs { return self }
  /// Returns `self` as `SettingsViewModelOutputs`.
  public var outputs: SettingsViewModelOutputs { return self }
}

// MARK: - Helpers

extension SettingsViewModel {
  /// Returns whether selecting `cellType` is currently permitted for the signed-in user.
  public func shouldSelectRow(for cellType: SettingsCellType) -> Bool {
    switch cellType {
    case .findFriends:
      guard let user = AppEnvironment.current.currentUser else {
        return true
      }

      return (user |> User.lens.social.view) ?? true
    default:
      return true
    }
  }
}
