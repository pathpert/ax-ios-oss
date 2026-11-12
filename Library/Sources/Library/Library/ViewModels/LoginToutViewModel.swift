import AuthenticationServices
import FacebookLogin
import KsApi
import Prelude
import ReactiveSwift

/// View model coordinating OAuth, Facebook, and Sign in with Apple authentication flows.
public final class LoginToutViewModel: LoginToutViewModelType, LoginToutViewModelInputs,
  LoginToutViewModelOutputs {
  /// Initializes the login tout view model.
  public init() {
    let intent: Signal<LoginIntent, Never> = self.loginIntentProperty.signal.skipNil()
      .takeWhen(self.viewWillAppearProperty.signal)

    self.logInContextText = intent.map(loginToutStatusString)

    self.headlineLabelHidden = intent.map {
      $0 != LoginIntent.generic && $0 != LoginIntent.discoveryOnboarding
    }

    let isLoading: MutableProperty<Bool> = MutableProperty(false)

    self.isLoading = isLoading.signal.skipRepeats()
    self.startOAuthSignupOrLogin = self.signupOrLoginWithOAuthButtonPressedProperty.signal
    self.attemptFacebookLogin = self.facebookLoginButtonPressedProperty.signal
    self.attemptAppleLogin = self.appleLoginButtonPressedProperty.signal.ignoreValues()

    let tokenString: Signal<String, Never> = self.facebookLoginSuccessProperty.signal.skipNil()
      .map { $0.token?.tokenString ?? "" }

    let facebookLogin = tokenString
      .switchMap { token in
        AppEnvironment.current.apiService.login(facebookAccessToken: token, code: nil)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .on(starting: { isLoading.value = true }, terminated: { isLoading.value = false })
          .materialize()
      }

    let tfaRequiredError = facebookLogin.errors().filter { $0.ksrCode == .TfaRequired }
    let facebookSignupError = facebookLogin.errors().filter { $0.ksrCode == .ConfirmFacebookSignup }
    let genericFacebookErrorAlert = facebookLogin.errors()
      .filter { env in
        env.ksrCode != .TfaRequired &&
          env.ksrCode != .ConfirmFacebookSignup &&
          env.ksrCode != .FacebookInvalidAccessToken
      }
      .map { AlertError.genericFacebookError(envelope: $0) }

    let facebookTokenFailAlert = facebookLogin.errors()
      .filter { $0.ksrCode == .FacebookInvalidAccessToken }
      .ignoreValues()
      .mapConst(AlertError.facebookTokenFail)

    let facebookLoginAttemptFailAlert = self.facebookLoginFailProperty.signal
      .map { $0 as NSError? }
      .skipNil()
      .map(AlertError.facebookLoginAttemptFail)

    self.startTwoFactorChallenge = tokenString.takeWhen(tfaRequiredError)
    self.startFacebookConfirmation = tokenString
      .takePairWhen(facebookSignupError)
      .map { token, error in (error.facebookUser ?? nil, token) }

    self.postNotification = self.environmentLoggedInProperty.signal
      .mapConst((
        Notification(name: .ksr_sessionStarted),
        Notification(
          name: .ksr_showNotificationsDialog,
          userInfo: [UserInfoKeys.context: PushNotificationDialog.Context.login]
        )
      ))
      // Post notifications on the next run loop to avoid race condition with VCs being deallocated.
      .ksr_delay(.nanoseconds(0), on: AppEnvironment.current.scheduler)

    self.dismissViewController = self.viewIsPresentedProperty.signal
      .filter(isTrue)
      .takeWhen(self.userSessionStartedProperty.signal)
      .ignoreValues()

    self.showFacebookErrorAlert = Signal.merge(
      facebookTokenFailAlert,
      facebookLoginAttemptFailAlert,
      genericFacebookErrorAlert
    )

    let logIntoEnvironmentWithFacebook = facebookLogin.values()

    // MARK: - Sign-in with Apple

    let appleSignInInput = self.appleAuthorizationDidSucceedWithDataProperty.signal
      .skipNil()
      .map { data in
        SignInWithAppleInput(
          appId: data.appId,
          authCode: data.token,
          firstName: data.firstName,
          lastName: data.lastName
        )
      }

    let appleSignInEvent = appleSignInInput
      .switchMap { input in
        AppEnvironment.current.apiService.signInWithApple(input: input)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .on(starting: { isLoading.value = true }, failed: { _ in isLoading.value = false })
          .materialize()
      }

    let userId = appleSignInEvent.values().map { Int($0.signInWithApple.user.uid) }.skipNil()
    let apiAccessToken = appleSignInEvent.values().map(\.signInWithApple.apiAccessToken)

    let fetchUserEvent = userId
      .switchMap { id in
        AppEnvironment.current.apiService.fetchUser(userId: id)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .on(starting: { isLoading.value = true }, terminated: { isLoading.value = false })
          .materialize()
      }

    let logIntoEnvironmentWithApple = Signal.combineLatest(apiAccessToken, fetchUserEvent.values())
      .map(AccessTokenEnvelope.init)

    let appleSignInEventError = appleSignInEvent.errors().map { $0.localizedDescription }
    let appleAuthorizationError = self.appleAuthorizationDidFailWithErrorProperty.signal
      .skipNil()
      .map(loginToutAppleErrorMessage(from:))
      .skipNil()
    let fetchUserEventError = fetchUserEvent.errors().map { $0.localizedDescription }

    self.showAppleErrorAlert = Signal
      .merge(appleAuthorizationError, fetchUserEventError, appleSignInEventError)

    self.logAppleError = self.appleAuthorizationDidFailWithErrorProperty.signal
      .skipNil()
      .map { $0.nsError }
      .skipNil()

    self.logIntoEnvironmentWithApple = logIntoEnvironmentWithApple.signal
    self.logIntoEnvironmentWithFacebook = logIntoEnvironmentWithFacebook.signal

    self.viewWillAppearProperty.signal
      .take(first: 1)
      .observeValues { AppEnvironment.current.ksrAnalytics.trackLoginTOutPageViewed() }

    self.signupOrLoginWithOAuthButtonPressedProperty.signal
      .observeValues { AppEnvironment.current.ksrAnalytics.trackLoginInitiateButtonClicked() }
  }

  /// Input interface for this view model.
  public var inputs: LoginToutViewModelInputs { return self }
  /// Output interface for this view model.
  public var outputs: LoginToutViewModelOutputs { return self }

  fileprivate let appleLoginButtonPressedProperty = MutableProperty(())
  /// Triggers Apple authentication flow.
  public func appleLoginButtonPressed() { self.appleLoginButtonPressedProperty.value = () }

  fileprivate let appleAuthorizationDidSucceedWithDataProperty = MutableProperty<SignInWithAppleData?>(nil)
  /// Supplies Sign in with Apple credential payload.
  public func appleAuthorizationDidSucceed(with data: SignInWithAppleData?) {
    self.appleAuthorizationDidSucceedWithDataProperty.value = data
  }

  fileprivate let appleAuthorizationDidFailWithErrorProperty = MutableProperty<AppleAuthServicesError?>(nil)
  /// Reports Sign in with Apple failure.
  public func appleAuthorizationDidFail(with error: AppleAuthServicesError) {
    self.appleAuthorizationDidFailWithErrorProperty.value = error
  }

  fileprivate let loginIntentProperty = MutableProperty<LoginIntent?>(.loginTab)
  /// Configures the login intent driving context copy.
  public func configureWith(_ intent: LoginIntent) { self.loginIntentProperty.value = intent }

  fileprivate let environmentLoggedInProperty = MutableProperty(())
  /// Signals that environment credentials were updated after login.
  public func environmentLoggedIn() { self.environmentLoggedInProperty.value = () }

  fileprivate let facebookLoginButtonPressedProperty = MutableProperty(())
  /// Triggers Facebook authentication flow.
  public func facebookLoginButtonPressed() { self.facebookLoginButtonPressedProperty.value = () }

  fileprivate let facebookLoginFailProperty = MutableProperty<Error?>(nil)
  /// Reports Facebook SDK login failure.
  public func facebookLoginFail(error: Error?) { self.facebookLoginFailProperty.value = error }

  fileprivate let facebookLoginSuccessProperty = MutableProperty<LoginManagerLoginResult?>(nil)
  /// Supplies Facebook SDK login result.
  public func facebookLoginSuccess(result: LoginManagerLoginResult) {
    self.facebookLoginSuccessProperty.value = result
  }

  fileprivate let signupOrLoginWithOAuthButtonPressedProperty = MutableProperty(())
  /// Triggers native OAuth login/signup flow.
  public func signupOrLoginWithOAuthButtonPressed() {
    self.signupOrLoginWithOAuthButtonPressedProperty.value = ()
  }

  fileprivate let userSessionStartedProperty = MutableProperty(())
  /// Signals that a user session started.
  public func userSessionStarted() { self.userSessionStartedProperty.value = () }

  fileprivate let viewIsPresentedProperty = MutableProperty<Bool>(false)
  /// Updates whether the tout controller was modally presented.
  public func view(isPresented: Bool) { self.viewIsPresentedProperty.value = isPresented }

  fileprivate var viewWillAppearProperty = MutableProperty(())
  /// Signals `viewWillAppear` lifecycle appearance.
  public func viewWillAppear() { self.viewWillAppearProperty.value = () }

  /// Emits when Apple login should start.
  public let attemptAppleLogin: Signal<(), Never>
  /// Emits when Facebook login should start.
  public let attemptFacebookLogin: Signal<(), Never>
  /// Emits when the controller should be dismissed.
  public let dismissViewController: Signal<(), Never>
  /// Emits whether the headline label should be hidden.
  public let headlineLabelHidden: Signal<Bool, Never>
  /// Emits whether an authentication request is loading.
  public let isLoading: Signal<Bool, Never>
  /// Emits the login context message.
  public let logInContextText: Signal<String, Never>
  /// Emits access token envelope after Sign in with Apple completes.
  public let logIntoEnvironmentWithApple: Signal<AccessTokenEnvelope, Never>
  /// Emits access token envelope after Facebook login completes.
  public let logIntoEnvironmentWithFacebook: Signal<AccessTokenEnvelope, Never>
  /// Emits login and notification-prompt notifications after sign-in.
  public let postNotification: Signal<(Notification, Notification), Never>
  /// Emits email and token for Facebook confirmation flow.
  public let startFacebookConfirmation: Signal<(ErrorEnvelope.FacebookUser?, String), Never>
  /// Emits when OAuth login/signup flow should begin.
  public let startOAuthSignupOrLogin: Signal<(), Never>
  /// Emits Facebook token when two-factor challenge is required.
  public let startTwoFactorChallenge: Signal<String, Never>
  /// Emits Sign in with Apple alert message.
  public let showAppleErrorAlert: Signal<String, Never>
  /// Emits Facebook error alert model.
  public let showFacebookErrorAlert: Signal<AlertError, Never>
  /// Emits non-fatal Apple authorization error for logging.
  public let logAppleError: Signal<NSError, Never>
}
