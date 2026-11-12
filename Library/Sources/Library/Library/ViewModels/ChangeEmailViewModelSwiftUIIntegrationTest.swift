import Combine
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Input contract for the SwiftUI change-email integration view model; do not use for UIKit legacy screens.
public protocol ChangeEmailViewModelInputsSwiftUIIntegrationTest {
  func resendVerificationEmailButtonTapped()
  func viewDidLoad()
  func updateEmail(newEmail: String, currentPassword: String)
  func didTapSaveButton()
}

/// Output contract exposing Combine publishers for SwiftUI change-email state.
public protocol ChangeEmailViewModelOutputsSwiftUIIntegrationTest {
  var didFailToSendVerificationEmail: Signal<String, Never> { get }
  var didSendVerificationEmail: Signal<Void, Never> { get }
  var emailText: Signal<String, Never> { get }
  var messageLabelViewHidden: Signal<Bool, Never> { get }
  var resendVerificationEmailViewIsHidden: Signal<Bool, Never> { get }
  var unverifiedEmailLabelHidden: Signal<Bool, Never> { get }
  var warningMessageLabelHidden: Signal<Bool, Never> { get }
  var verificationEmailButtonTitle: Signal<String, Never> { get }
}

/// Combined inputs/outputs protocol for the SwiftUI change-email view model.
public protocol ChangeEmailViewModelTypeSwiftUIIntegrationTest {
  var inputs: ChangeEmailViewModelInputsSwiftUIIntegrationTest { get }
  var outputs: ChangeEmailViewModelOutputsSwiftUIIntegrationTest { get }
}

/// SwiftUI integration view model coordinating email changes and verification alerts.
public final class ChangeEmailViewModelSwiftUIIntegrationTest: ChangeEmailViewModelTypeSwiftUIIntegrationTest,
  ChangeEmailViewModelInputsSwiftUIIntegrationTest,
  ChangeEmailViewModelOutputsSwiftUIIntegrationTest, ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  /// Whether the email verification banner is hidden.
  @Published public var hideVerifyView = false
  /// Localized title displayed on the resend-verification button.
  @Published public var verifyEmailButtonTitle = ""
  /// Whether the inline warning message label is hidden.
  @Published public var hideMessageLabel = true
  /// Tuple of warning message copy and whether an alert state is active.
  @Published public var warningMessageWithAlert = ("", false)
  /// Publisher emitting `true` when both new email and password inputs satisfy save criteria.
  public var saveButtonEnabled: AnyPublisher<Bool, Never>
  /// Subject emitting banner feedback models for save success or error messages.
  public var bannerMessage: PassthroughSubject<MessageBannerViewViewModel, Never> = .init()
  /// Subject emitting the user's current account email loaded from the API.
  public var retrievedEmailText: PassthroughSubject<String, Never> = .init()
  /// Subject emitting edited new-email text changes from the SwiftUI field.
  public var newEmailText: PassthroughSubject<String, Never> = .init()
  /// Subject emitting edited current-password text changes from the SwiftUI field.
  public var currentPasswordText: PassthroughSubject<String, Never> = .init()
  /// Subject triggered when the user taps the save button.
  public var saveTriggered: PassthroughSubject<Bool, Never> = .init()
  /// Subject emitting `true` when editable input fields should reset after a successful save.
  public var resetEditableText: PassthroughSubject<Bool, Never> = .init()

  /// Initializes reactive and Combine bindings for the change-email SwiftUI integration view model.
  public init() {
    let changeEmailEvent = self.updateEmailAndPasswordProperty.signal.skipNil()
      .map(ChangeEmailInput.init(email:currentPassword:))
      .switchMap { input in
        AppEnvironment.current.apiService.changeEmail(input: input)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .map { _ in input.email }
          .materialize()
      }

    let userEmailEvent = self.viewDidLoadProperty.signal
      .switchMap { _ in
        AppEnvironment.current
          .apiService
          .fetchGraphUser(withStoredCards: false)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let resendEmailVerificationEvent = self.resendVerificationEmailButtonProperty.signal
      .switchMap { _ in
        AppEnvironment.current.apiService.sendVerificationEmail(input: EmptyInput())
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.didSendVerificationEmail = resendEmailVerificationEvent.values().ignoreValues()

    self.didFailToSendVerificationEmail = resendEmailVerificationEvent.errors()
      .map { $0.localizedDescription }

    self.emailText = Signal.merge(
      changeEmailEvent.values(),
      userEmailEvent.values().map { $0.me.email ?? "" }
    )

    let isEmailVerified = userEmailEvent.values().map { $0.me.isEmailVerified }.skipNil()
    let isEmailDeliverable = userEmailEvent.values().map { $0.me.isDeliverable }.skipNil()
    let emailVerifiedAndDeliverable: Signal<Bool, Never> = Signal
      .combineLatest(isEmailVerified, isEmailDeliverable)
      .map { isEmailVerified, isEmailDeliverable -> Bool in
        let r = isEmailVerified && isEmailDeliverable
        return r
      }

    self.resendVerificationEmailViewIsHidden = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst(true),
      emailVerifiedAndDeliverable
    ).skipRepeats()

    self.unverifiedEmailLabelHidden = Signal
      .combineLatest(isEmailVerified, isEmailDeliverable)
      .map { isEmailVerified, isEmailDeliverable -> Bool in
        guard isEmailVerified else { return !isEmailDeliverable }

        return true
      }

    self.warningMessageLabelHidden = isEmailDeliverable

    self.messageLabelViewHidden = Signal
      .merge(self.unverifiedEmailLabelHidden, self.warningMessageLabelHidden)
      .filter(isFalse)

    self.verificationEmailButtonTitle = self.viewDidLoadProperty.signal.map { _ in
      guard let user = AppEnvironment.current.currentUser else { return "" }
      return user.isCreator ? Strings.Resend_verification_email() : Strings.Send_verfication_email()
    }

    // MARK: Reactive Subscribers to Combine Publishers

    self.saveButtonEnabled = Publishers
      .CombineLatest3(self.retrievedEmailText, self.newEmailText, self.currentPasswordText)
      .removeDuplicates(by: ==)
      .map(shouldEnableSaveButton(email:newEmail:password:))
      .eraseToAnyPublisher()

    _ = changeEmailEvent.errors()
      .observeForUI()
      .observeValues { [weak self] errorValue in
        let messageBannerViewViewModel = MessageBannerViewViewModel(MessageBannerConfiguration(
          type: .error,
          message: errorValue.localizedDescription
        ))

        self?.saveTriggered.send(false)
        self?.resetEditableText.send(true)
        self?.bannerMessage.send(messageBannerViewViewModel)
      }

    _ = changeEmailEvent.values().ignoreValues()
      .observeForUI()
      .observeValues { [weak self] _ in
        let messageBannerViewViewModel = MessageBannerViewViewModel(MessageBannerConfiguration(
          type: .success,
          message: Strings.Got_it_your_changes_have_been_saved()
        ))

        self?.saveTriggered.send(false)
        self?.resetEditableText.send(true)
        self?.bannerMessage.send(messageBannerViewViewModel)
      }

    Publishers
      .CombineLatest4(self.saveButtonEnabled, self.saveTriggered, self.newEmailText, self.currentPasswordText)
      .filter { enabledValue, triggeredValue, _, _ in
        enabledValue && triggeredValue
      }
      .sink(receiveValue: { [weak self] _, _, newEmailTextValue, newPasswordTextValue in
        self?.updateEmail(newEmail: newEmailTextValue, currentPassword: newPasswordTextValue)
      })
      .store(in: &self.cancellables)

    _ = self.resendVerificationEmailViewIsHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        self?.hideVerifyView = isHidden
      }

    _ = self.didSendVerificationEmail
      .observeForUI()
      .observeValues { [weak self] in
        let messageBannerViewViewModel = MessageBannerViewViewModel(MessageBannerConfiguration(
          type: .success,
          message: Strings.Verification_email_sent()
        ))

        self?.bannerMessage.send(messageBannerViewViewModel)
      }

    _ = self.didFailToSendVerificationEmail
      .observeForUI()
      .observeValues { [weak self] message in
        let messageBannerViewViewModel = MessageBannerViewViewModel(MessageBannerConfiguration(
          type: .error,
          message: message
        ))

        self?.bannerMessage.send(messageBannerViewViewModel)
      }

    _ = self.emailText
      .observeForUI()
      .observeValues { [weak self] emailText in
        self?.retrievedEmailText.send(emailText)
      }

    _ = self.verificationEmailButtonTitle
      .observeForUI()
      .observeValues { [weak self] titleText in
        self?.verifyEmailButtonTitle = titleText
      }

    _ = self.messageLabelViewHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        self?.hideMessageLabel = isHidden
      }

    _ = self.unverifiedEmailLabelHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        guard !isHidden else { return }

        self?.warningMessageWithAlert = (Strings.Email_unverified(), false)
      }

    _ = self.warningMessageLabelHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        guard !isHidden else { return }

        self?.warningMessageWithAlert = (Strings.We_ve_been_unable_to_send_email(), true)
      }
  }

  internal let updateEmailAndPasswordProperty = MutableProperty<(String, String)?>(nil)
  internal let newEmailProperty = MutableProperty<String?>(nil)
  internal let passwordProperty = MutableProperty<String?>(nil)
  internal let resendVerificationEmailButtonProperty = MutableProperty(())
  internal let viewDidLoadProperty = MutableProperty(())

  /// Emits localized error banner copy when verification email resend fails.
  public let didFailToSendVerificationEmail: Signal<String, Never>
  /// Fires when verification email resend succeeds.
  public let didSendVerificationEmail: Signal<Void, Never>
  /// Emits the user's loaded account email address.
  public let emailText: Signal<String, Never>
  /// Controls visibility of the informational status banner label.
  public let messageLabelViewHidden: Signal<Bool, Never>
  /// Controls visibility of the resend-verification-email container.
  public let resendVerificationEmailViewIsHidden: Signal<Bool, Never>
  /// Controls visibility of the unverified-email notice label.
  public let unverifiedEmailLabelHidden: Signal<Bool, Never>
  /// Emits localized title copy for the verification email button.
  public let verificationEmailButtonTitle: Signal<String, Never>
  /// Controls visibility of the failed-verification warning label.
  public let warningMessageLabelHidden: Signal<Bool, Never>
}

private func shouldEnableSaveButton(email: String?, newEmail: String?, password: String?) -> Bool {
  guard
    let newEmail = newEmail,
    isValidEmail(newEmail),
    email != newEmail,
    password != nil

  else { return false }

  return ![newEmail, password]
    .compact()
    .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    .contains(false)
}
