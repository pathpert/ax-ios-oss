import AuthenticationServices
import FacebookLogin
import KsApi
import Prelude
import ReactiveSwift

/// Strongly-typed payload extracted from ASAuthorizationAppleIDCredential on Sign in with Apple success.
///
/// Negative Constraint: `token` is a short-lived identity token; do not persist it in long-term storage.
public struct SignInWithAppleData: Equatable, Sendable {
  /// Apple OAuth client/app bundle identifier.
  public let appId: String
  /// User's given name if shared during initial Apple authorization; otherwise `nil`.
  public let firstName: String?
  /// User's family name if shared during initial Apple authorization; otherwise `nil`.
  public let lastName: String?
  /// UTF-8 Sign in with Apple identity token string forwarded to GraphQL mutation.
  public let token: String

  /// Creates a typed `SignInWithAppleData` contract.
  public init(appId: String, firstName: String?, lastName: String?, token: String) {
    self.appId = appId
    self.firstName = firstName
    self.lastName = lastName
    self.token = token
  }
}

/// Input actions supported by `LoginToutViewModel`.
public protocol LoginToutViewModelInputs {
  /// Call when Apple completes authorization.
  func appleAuthorizationDidSucceed(with data: SignInWithAppleData?)
  /// Call when Apple completes authorization with error.
  func appleAuthorizationDidFail(with error: AppleAuthServicesError)
  /// Call when Continue with Apple button is pressed.
  func appleLoginButtonPressed()
  /// Call to set the reason the user is attempting to log in.
  func configureWith(_ intent: LoginIntent)
  /// Call when the environment has been logged into.
  func environmentLoggedIn()
  /// Call when Facebook login button is pressed.
  func facebookLoginButtonPressed()
  /// Call when Facebook login completed with error.
  func facebookLoginFail(error: Error?)
  /// Call when Facebook login completed successfully with a result.
  func facebookLoginSuccess(result: LoginManagerLoginResult)
  /// Call when login/signup with OAuth button is pressed.
  func signupOrLoginWithOAuthButtonPressed()
  /// Call when a user session starts.
  func userSessionStarted()
  /// Call when the view appears with a boolean telling us whether this controller was presented.
  func view(isPresented: Bool)
  /// Call when the view controller's `viewWillAppear()` method is called.
  func viewWillAppear()
}

/// UI and authentication outputs emitted by `LoginToutViewModel`.
public protocol LoginToutViewModelOutputs {
  /// Emits when Apple login should start.
  var attemptAppleLogin: Signal<Void, Never> { get }
  /// Emits when Facebook login should start.
  var attemptFacebookLogin: Signal<(), Never> { get }
  /// Emits when the controller should be dismissed.
  var dismissViewController: Signal<(), Never> { get }
  /// Emits if label should be hidden.
  var headlineLabelHidden: Signal<Bool, Never> { get }
  /// Emits whether a request is loading or not.
  var isLoading: Signal<Bool, Never> { get }
  /// Emits the login context to be displayed.
  var logInContextText: Signal<String, Never> { get }
  /// Emits an access token envelope that can be used to update the environment via Apple.
  var logIntoEnvironmentWithApple: Signal<AccessTokenEnvelope, Never> { get }
  /// Emits an access token envelope that can be used to update the environment via Facebook.
  var logIntoEnvironmentWithFacebook: Signal<AccessTokenEnvelope, Never> { get }
  /// Emits when a login success notification should be posted.
  var postNotification: Signal<(Notification, Notification), Never> { get }
  /// Emits when should show Apple error alert with error message.
  var showAppleErrorAlert: Signal<String, Never> { get }
  /// Emits when we should log a non-fatal Apple error.
  var logAppleError: Signal<NSError, Never> { get }
  /// Emits when should show Facebook error alert with AlertError.
  var showFacebookErrorAlert: Signal<AlertError, Never> { get }
  /// Emits when OAuth flow should be shown.
  var startOAuthSignupOrLogin: Signal<(), Never> { get }
  /// Emits a Facebook user and access token when Facebook login has occurred.
  var startFacebookConfirmation: Signal<(ErrorEnvelope.FacebookUser?, String), Never> { get }
  /// Emits an access token to show 2FA view when Facebook login fails with `tfaRequired` error.
  var startTwoFactorChallenge: Signal<String, Never> { get }
}

/// View model interface for the login tout screen.
public protocol LoginToutViewModelType {
  /// Input interface for the login tout view model.
  var inputs: LoginToutViewModelInputs { get }
  /// Output interface for the login tout view model.
  var outputs: LoginToutViewModelOutputs { get }
}

internal func loginToutStatusString(_ forStatus: LoginIntent) -> String {
  switch forStatus {
  case .starProject, .videoFeed:
    return Strings.Log_in_or_sign_up_to_save_this_project_and_we_ll_remind_you()
  case .backProject:
    return Strings.Please_log_in_or_sign_up_to_back_this_project()
  case .messageCreator:
    return Strings.Please_log_in_or_sign_up_to_message_this_creator()
  case .discoveryOnboarding, .onboarding, .generic, .activity, .loginTab, .erroredPledge:
    return Strings.Pledge_to_projects_and_view_all_your_saved_and_backed_projects_in_one_place()
  }
}

internal func loginToutAppleErrorMessage(from error: AppleAuthServicesError) -> String? {
  switch error {
  case let .other(error):
    return error.localizedDescription
  case .canceled:
    return nil
  }
}

