/**
 FIXME: This VM and its tests should be moved to the Library framework and refactored to not need the
 `viewControllerFactory` passed to its initializer.
 */
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Account settings snapshot containing currency, email warnings, and login-method flags.
public typealias SettingsAccountData = (
  currency: Currency,
  email: String?,
  shouldHideEmailWarning: Bool,
  shouldHideEmailPasswordSection: Bool,
  isAppleConnectedAccount: Bool
)

/// Inputs accepted by `SettingsAccountViewModel`.
public protocol SettingsAccountViewModelInputs {
  /// Signals that the user tapped an account settings row.
  func didSelectRow(cellType: SettingsAccountCellType)
  /// Signals that the account settings view is about to appear.
  func viewWillAppear()
  /// Signals that the account settings view has loaded.
  func viewDidLoad()
}

/// Outputs emitted by `SettingsAccountViewModel`.
public protocol SettingsAccountViewModelOutputs {
  /// Emits when fetching account fields fails.
  var fetchAccountFieldsError: Signal<Void, Never> { get }
  /// Emits formatted `SettingsAccountData` whenever rows should reload.
  var reloadData: Signal<SettingsAccountData, Never> { get }
  /// Emits the destination view controller for the selected account settings cell.
  var transitionToViewController: Signal<UIViewController, Never> { get }

  /// Returns whether to show a create-password footer and the user's email address.
  func shouldShowCreatePasswordFooter() -> (Bool, String?)?
}

/// Interface combining inputs and outputs for `SettingsAccountViewModel`.
public protocol SettingsAccountViewModelType {
  /// Input receiver for account settings lifecycle and row selection events.
  var inputs: SettingsAccountViewModelInputs { get }
  /// Output signals driving account rows, errors, and destination transitions.
  var outputs: SettingsAccountViewModelOutputs { get }
}

/// View model managing account currency, email/password status, and sub-screen navigation.
public final class SettingsAccountViewModel: SettingsAccountViewModelInputs,
  SettingsAccountViewModelOutputs, SettingsAccountViewModelType {
  /// Initializes the account settings view model with a destination view controller factory.
  public init(_ viewControllerFactory: @escaping (SettingsAccountCellType, Currency) -> UIViewController?) {
    let userAccountFields = Signal.merge(
      self.viewDidLoadProperty.signal,
      self.viewWillAppearProperty.signal.skip(first: 1)
    )
    .switchMap { _ in
      AppEnvironment.current.apiService
        .fetchGraphUser(withStoredCards: false)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

    self.fetchAccountFieldsError = userAccountFields.errors().ignoreValues()

    let user = userAccountFields.values().map(\.me)

    let shouldHideEmailWarning = user
      .map { user -> Bool in
        if user.isAppleConnected == .some(true) {
          return true
        }

        guard let isEmailVerified = user.isEmailVerified,
              let isDeliverable = user.isDeliverable else {
          return true
        }

        return isEmailVerified && isDeliverable
      }

    let shouldHideEmailPasswordSection = user
      .map { $0.hasPassword == .some(false) || $0.isAppleConnected == .some(true) }

    let shouldShowCreatePasswordFooter = user
      .map { user -> (Bool, String?) in
        let isAppleConnected = user.isAppleConnected == .some(true)
        let userHasPassword = user.hasPassword == .some(true)
        let shouldShow = !userHasPassword && !isAppleConnected

        return (shouldShow, user.email)
      }

    let isAppleConnectedAccount = user.map { $0.isAppleConnected == .some(true) }

    self.shouldShowCreatePasswordFooterAndEmailProperty <~ shouldShowCreatePasswordFooter

    let chosenCurrency = user
      .map { Currency(rawValue: $0.chosenCurrency ?? Currency.USD.rawValue) ?? Currency.USD }

    self.reloadData = Signal.zip(
      chosenCurrency,
      user.map(\.email),
      shouldHideEmailWarning,
      shouldHideEmailPasswordSection,
      isAppleConnectedAccount
    ).map { $0 as SettingsAccountData }

    self.transitionToViewController = chosenCurrency
      .takePairWhen(self.selectedCellTypeProperty.signal.skipNil())
      .map { ($1, $0) }
      .map(viewControllerFactory)
      .skipNil()
  }

  private let selectedCellTypeProperty = MutableProperty<SettingsAccountCellType?>(nil)
  /// Handles selecting a settings account row of type `cellType`.
  public func didSelectRow(cellType: SettingsAccountCellType) {
    self.selectedCellTypeProperty.value = cellType
  }

  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the account settings screen is appearing.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the account settings screen loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let shouldShowCreatePasswordFooterAndEmailProperty = MutableProperty<(Bool, String?)?>(nil)
  /// Returns whether the Create Password explanatory footer should be displayed and for which email.
  public func shouldShowCreatePasswordFooter() -> (Bool, String?)? {
    return self.shouldShowCreatePasswordFooterAndEmailProperty.value
  }

  /// Emits when fetching account fields errors out.
  public let fetchAccountFieldsError: Signal<Void, Never>
  /// Emits current account configuration data to populate cells.
  public let reloadData: Signal<SettingsAccountData, Never>
  /// Emits the destination view controller for a tapped row.
  public let transitionToViewController: Signal<UIViewController, Never>

  /// Returns `self` as `SettingsAccountViewModelInputs`.
  public var inputs: SettingsAccountViewModelInputs { return self }
  /// Returns `self` as `SettingsAccountViewModelOutputs`.
  public var outputs: SettingsAccountViewModelOutputs { return self }
}
