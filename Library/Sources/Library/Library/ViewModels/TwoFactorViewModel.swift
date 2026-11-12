import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `TwoFactorViewModel`.
public protocol TwoFactorViewModelInputs {
  /// Call when code textfield is updated
  func codeChanged(_ code: String?)

  /// Call to set email and password
  func email(_ email: String, password: String)

  /// Call when the environment has been logged into
  func environmentLoggedIn()

  /// Call to set facebook token
  func facebookToken(_ token: String)

  /// Call when resend button pressed
  func resendPressed()

  /// Call when submit button pressed
  func submitPressed()

  /// Call when the view did load.
  func viewDidLoad()

  /// Call when view will appear
  func viewWillAppear()
}

/// Outputs exposed by `TwoFactorViewModel`.
public protocol TwoFactorViewModelOutputs {
  /// Emits when the code text field is the first responder.
  var codeTextFieldBecomeFirstResponder: Signal<(), Never> { get }

  /// Emits whether the form is valid or not
  var isFormValid: Signal<Bool, Never> { get }

  /// Emits whether a request is loading or not
  var isLoading: Signal<Bool, Never> { get }

  /// Emits an access token envelope that can be used to update the environment.
  var logIntoEnvironment: Signal<AccessTokenEnvelope, Never> { get }

  /// Emits when a login success notification should be posted.
  var postNotification: Signal<(Notification, Notification), Never> { get }

  /// Emits when code was resent successfully
  var resendSuccess: Signal<(), Never> { get }

  /// Emits a message when the code submitted is not correct or login fails
  var showError: Signal<String, Never> { get }
}

/// Combined inputs and outputs interface for `TwoFactorViewModel`.
public protocol TwoFactorViewModelType {
  /// The view model's inputs.
  var inputs: TwoFactorViewModelInputs { get }
  /// The view model's outputs.
  var outputs: TwoFactorViewModelOutputs { get }
}

/// View model managing two-factor authentication code entry, resend requests, and login completion.
public final class TwoFactorViewModel: TwoFactorViewModelType, TwoFactorViewModelInputs,
  TwoFactorViewModelOutputs {
  // A simple type to hold all the data needed to login.
  fileprivate struct TfaData {
    fileprivate let email: String?
    fileprivate let password: String?
    fileprivate let facebookToken: String?
    fileprivate let code: String?

    fileprivate enum lens {
      fileprivate static let code = Lens<TfaData, String?>(
        view: { $0.code },
        set: { TfaData(email: $1.email, password: $1.password, facebookToken: $1.facebookToken, code: $0) }
      )
    }
  }

  /// Creates a new `TwoFactorViewModel` and binds login and resend verification code signals.
  public init() {
    let isLoading = MutableProperty(false)

    let loginData = SignalProducer.combineLatest(
      self.emailProperty.producer,
      self.passwordProperty.producer,
      self.facebookTokenProperty.producer,
      self.codeProperty.producer
    )
    .map(TfaData.init)

    let resendData = loginData.map(TfaData.lens.code .~ nil)

    let loginEvent = loginData
      .takeWhen(self.submitPressedProperty.signal)
      .switchMap { data in
        login(data, apiService: AppEnvironment.current.apiService, isLoading: isLoading)
          .materialize()
      }

    self.codeTextFieldBecomeFirstResponder = self.viewDidLoadProperty.signal

    self.logIntoEnvironment = loginEvent.values()

    self.resendSuccess = resendData
      .takeWhen(self.resendPressedProperty.signal)
      .switchMap { data in
        login(data, apiService: AppEnvironment.current.apiService, isLoading: isLoading)
          .materialize()
          .errors()
          .filter { error in error.ksrCode == .TfaRequired }
          .ignoreValues()
      }

    self.isLoading = isLoading.signal

    self.isFormValid = Signal.merge([
      self.codeProperty.signal.map { code in code?.count == 6 },
      self.viewWillAppearProperty.signal.mapConst(false)
    ])
    .skipRepeats()

    let codeMismatch = loginEvent.errors()
      .filter { $0.ksrCode == .TfaFailed }
      .map { $0.errorMessages.first ?? Strings.two_factor_error_message() }

    let genericFail = loginEvent.errors()
      .filter { $0.ksrCode != .TfaFailed }
      .map { $0.errorMessages.first ?? Strings.login_errors_unable_to_log_in() }

    self.showError = Signal.merge([codeMismatch, genericFail])

    self.postNotification = self.environmentLoggedInProperty.signal
      .mapConst((
        Notification(name: .ksr_sessionStarted),
        Notification(
          name: .ksr_showNotificationsDialog,
          userInfo: [UserInfoKeys.context: PushNotificationDialog.Context.login]
        )
      ))
  }

  fileprivate let codeProperty = MutableProperty<String?>(nil)
  /// Updates the entered 2FA verification code.
  public func codeChanged(_ code: String?) {
    self.codeProperty.value = code
  }

  fileprivate let emailProperty = MutableProperty<String?>(nil)
  fileprivate let passwordProperty = MutableProperty<String?>(nil)
  /// Supplies email and password credentials when logging in with password auth.
  public func email(_ email: String, password: String) {
    self.emailProperty.value = email
    self.passwordProperty.value = password
  }

  fileprivate let environmentLoggedInProperty = MutableProperty(())
  /// Notifies the view model that the authenticated session has been saved into `AppEnvironment`.
  public func environmentLoggedIn() {
    self.environmentLoggedInProperty.value = ()
  }

  fileprivate let facebookTokenProperty = MutableProperty<String?>(nil)
  /// Supplies the Facebook access token when completing 2FA for Facebook login.
  public func facebookToken(_ token: String) {
    self.facebookTokenProperty.value = token
  }

  fileprivate let resendPressedProperty = MutableProperty(())
  /// Requests a new two-factor verification code.
  public func resendPressed() {
    self.resendPressedProperty.value = ()
  }

  fileprivate let submitPressedProperty = MutableProperty(())
  /// Submits the entered 2FA code to complete login.
  public func submitPressed() {
    self.submitPressedProperty.value = ()
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the two-factor screen has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the two-factor screen will appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  /// Emits when the verification code field should become first responder.
  public let codeTextFieldBecomeFirstResponder: Signal<(), Never>
  /// Emits whether the verification code form is valid to submit.
  public let isFormValid: Signal<Bool, Never>
  /// Emits whether a login or resend request is currently in flight.
  public let isLoading: Signal<Bool, Never>
  /// Emits the access token envelope returned on successful verification.
  public let logIntoEnvironment: Signal<AccessTokenEnvelope, Never>
  /// Emits session-started and notification-dialog notifications after login.
  public let postNotification: Signal<(Notification, Notification), Never>
  /// Emits when resending the verification code succeeds.
  public let resendSuccess: Signal<(), Never>
  /// Emits a localized error message when verification fails.
  public let showError: Signal<String, Never>

  /// The inputs interface for this view model.
  public var inputs: TwoFactorViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: TwoFactorViewModelOutputs { return self }
}

private func login(
  _ tfaData: TwoFactorViewModel.TfaData,
  apiService: ServiceType,
  isLoading: MutableProperty<Bool>
) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
  let login: SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  if let email = tfaData.email, let password = tfaData.password {
    login = apiService.login(email: email, password: password, code: tfaData.code)
  } else if let facebookToken = tfaData.facebookToken {
    login = apiService.login(facebookAccessToken: facebookToken, code: tfaData.code)
  } else {
    login = .empty
  }

  return login
    .on(
      starting: { isLoading.value = true },
      terminated: { isLoading.value = false }
    )
}
