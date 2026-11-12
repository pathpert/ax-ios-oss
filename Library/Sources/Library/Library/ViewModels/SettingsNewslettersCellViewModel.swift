import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `SettingsNewsletterCellViewModel`.
public protocol SettingsNewslettersCellViewModelInputs {
  /// Toggles subscription status across all Kickstarter newsletters simultaneously.
  func allNewslettersSwitchTapped(on: Bool)
  /// Configures the master "subscribe to all" row with the current `User`.
  func configureWith(value: User)
  /// Configures an individual newsletter preference row with a newsletter and `User`.
  func configureWith(value: (newsletter: Newsletter, user: User))
  /// Toggles subscription status for the configured newsletter.
  func newslettersSwitchTapped(on: Bool)
}

/// Outputs emitted by `SettingsNewsletterCellViewModel`.
public protocol SettingsNewslettersCellViewModelOutputs {
  /// Emits the newsletter display name when German double opt-in confirmation should be shown.
  var showOptInPrompt: Signal<String, Never> { get }
  /// Emits whether the "subscribe to all" switch is toggled on.
  var subscribeToAllSwitchIsOn: Signal<Bool?, Never> { get }
  /// Emits whether an individual newsletter switch is toggled on.
  var switchIsOn: Signal<Bool?, Never> { get }
  /// Emits an error message string if saving newsletter preferences fails.
  var unableToSaveError: Signal<String, Never> { get }
  /// Emits the updated or reverted `User` model after a mutation attempt.
  var updateCurrentUser: Signal<User, Never> { get }
}

/// Interface combining inputs and outputs for `SettingsNewsletterCellViewModel`.
public protocol SettingsNewslettersCellViewModelType {
  /// Input receiver for newsletter toggle interactions.
  var inputs: SettingsNewslettersCellViewModelInputs { get }
  /// Output signals updating switch states and persisted user settings.
  var outputs: SettingsNewslettersCellViewModelOutputs { get }
}

/// View model managing individual and batch newsletter subscription switches in Settings.
public final class SettingsNewsletterCellViewModel: SettingsNewslettersCellViewModelType,
  SettingsNewslettersCellViewModelInputs, SettingsNewslettersCellViewModelOutputs {
  /// Initializes the newsletter cell view model.
  public init() {
    let newsletter = self.newsletterProperty.signal.skipNil()

    let initialUser = self.initialUserProperty.signal.skipNil()

    let newsletterOn: Signal<(Newsletter, Bool), Never> = newsletter
      .takePairWhen(self.newslettersSwitchTappedProperty.signal.skipNil())
      .map { newsletter, isOn in (newsletter, isOn) }

    self.showOptInPrompt = newsletterOn
      .filter { _, on in AppEnvironment.current.config?.countryCode == "DE" && on }
      .map { newsletter, _ in newsletter.displayableName }

    let userAttributeChanged = newsletter
      .takePairWhen(self.newslettersSwitchTappedProperty.signal.skipNil())
      .map { newsletter, isOn in
        (UserAttribute.newsletter(newsletter), isOn)
      }

    let updatedUser = initialUser
      .switchMap { user in
        userAttributeChanged.scan(user) { user, attributeAndOn in
          let (attribute, on) = attributeAndOn
          return user |> attribute.keyPath .~ on
        }
      }

    let updateUserAllOn = initialUser
      .takePairWhen(self.allNewslettersSwitchProperty.signal.skipNil())
      .map { user, on in
        user
          |> \.newsletters .~ User.NewsletterSubscriptions.all(on: on)
      }

    let updateEvent = Signal.merge(updatedUser, updateUserAllOn)
      .switchMap { user in
        AppEnvironment.current.apiService.updateUserSelf(user)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.unableToSaveError = updateEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.profile_settings_error()
      }

    let initialUserOnError = initialUser
      .takeWhen(self.unableToSaveError)

    self.updateCurrentUser = Signal.merge(
      initialUser,
      updatedUser,
      updateUserAllOn,
      initialUserOnError
    )
    .takeWhen(updateEvent.values().ignoreValues())

    self.subscribeToAllSwitchIsOn = initialUser
      .map(userIsSubscribedToAll(user:))

    self.switchIsOn = initialUser
      .combineLatest(with: newsletter)
      .map(userIsSubscribed(user:newsletter:))
  }

  fileprivate let initialUserProperty = MutableProperty<User?>(nil)
  fileprivate let newsletterProperty = MutableProperty<Newsletter?>(nil)
  /// Configures the cell with a specific `Newsletter` option and the current `User`.
  public func configureWith(value: (newsletter: Newsletter, user: User)) {
    self.newsletterProperty.value = value.newsletter
    self.initialUserProperty.value = value.user
  }

  /// Configures the "all newsletters" header cell with the current `User`.
  public func configureWith(value: User) {
    self.initialUserProperty.value = value
  }

  fileprivate let newslettersSwitchTappedProperty = MutableProperty<Bool?>(nil)
  /// Updates subscription state for the configured newsletter.
  public func newslettersSwitchTapped(on: Bool) {
    self.newslettersSwitchTappedProperty.value = on
  }

  fileprivate let allNewslettersSwitchProperty = MutableProperty<Bool?>(nil)
  /// Updates subscription state for all newsletters simultaneously.
  public func allNewslettersSwitchTapped(on: Bool) {
    self.allNewslettersSwitchProperty.value = on
  }

  /// Emits newsletter display name when a confirmation opt-in prompt is required.
  public let showOptInPrompt: Signal<String, Never>
  /// Emits the toggle state for the "subscribe to all" switch.
  public let subscribeToAllSwitchIsOn: Signal<Bool?, Never>
  /// Emits the toggle state for an individual newsletter switch.
  public let switchIsOn: Signal<Bool?, Never>
  /// Emits a localized error message on save failure.
  public let unableToSaveError: Signal<String, Never>
  /// Emits the updated or rolled-back `User` model.
  public let updateCurrentUser: Signal<User, Never>

  /// Returns `self` as `SettingsNewslettersCellViewModelInputs`.
  public var inputs: SettingsNewslettersCellViewModelInputs { return self }
  /// Returns `self` as `SettingsNewslettersCellViewModelOutputs`.
  public var outputs: SettingsNewslettersCellViewModelOutputs { return self }
}

private func userIsSubscribedToAll(user: User) -> Bool? {
  return user.newsletters.arts == true
    && user.newsletters.games == true
    && user.newsletters.happening == true
    && user.newsletters.invent == true
    && user.newsletters.promo == true
    && user.newsletters.weekly == true
    && user.newsletters.films == true
    && user.newsletters.publishing == true
    && user.newsletters.alumni == true
}

private func userIsSubscribed(user: User, newsletter: Newsletter) -> Bool? {
  return user |> UserAttribute.newsletter(newsletter).keyPath.view
}
