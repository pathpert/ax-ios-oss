import AuthenticationServices
import FacebookLogin
import KsApi
import Library
import Prelude
import UIKit

// MARK: - Auth & Navigation Flows

extension LoginToutViewController {
  /// Starts Sign in with Apple authorization flow.
  func attemptAppleLogin() {
    let appleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
      |> \.requestedScopes .~ [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
      |> \.delegate .~ self
      ?|> \.presentationContextProvider .~ self
    authorizationController?.performRequests()
  }

  /// Starts Facebook SDK login with default read permissions.
  func attemptFacebookLogin() {
    self.fbLoginManager.logIn(
      permissions: ["public_profile", "email", "user_friends"], from: nil
    ) { result, error in
      if let error = error {
        self.viewModel.inputs.facebookLoginFail(error: error)
      } else if let result = result, !result.isCancelled {
        self.viewModel.inputs.facebookLoginSuccess(result: result)
      }
    }
  }

  /// Pushes a help web page onto the navigation stack.
  func goToHelpType(_ helpType: HelpType) {
    let vc = HelpWebViewController.configuredWith(helpType: helpType)
    self.navigationController?.pushViewController(vc, animated: true)
    self.navigationItem.backBarButtonItem = UIBarButtonItem.back(nil, selector: nil)
  }

  /// Starts an `ASWebAuthenticationSession` OAuth login or signup flow.
  func pushOAuthFlow() {
    guard let session = createAuthorizationSession() else {
      return
    }

    session.presentationContextProvider = self
    session.start()
  }

  /// Creates the configured OAuth web authentication session.
  func createAuthorizationSession() -> ASWebAuthenticationSession? {
    return OAuth.createAuthorizationSession { [weak self] result in
      switch result {
      case .loggedIn:
        self?.viewModel.inputs.environmentLoggedIn()
      case let .failure(errorMessage):
        let alert = UIAlertController(
          title: Strings.login_errors_title(),
          message: errorMessage,
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Strings.login_errors_button_ok(), style: .cancel))
        self?.present(alert, animated: true)
      case .canceled:
        break
      }
    }
  }

  /// Pushes two-factor authentication verification following Facebook login.
  func pushTwoFactorViewController(facebookAccessToken token: String) {
    let vc = TwoFactorViewController.configuredWith(facebookAccessToken: token)
    self.navigationController?.pushViewController(vc, animated: true)
    self.navigationItem.backBarButtonItem = UIBarButtonItem.back(nil, selector: nil)
  }

  /// Pushes the Facebook account confirmation screen.
  func pushFacebookConfirmationController(
    facebookUser user: ErrorEnvelope.FacebookUser?,
    facebookToken token: String
  ) {
    let vc = FacebookConfirmationViewController
      .configuredWith(facebookUserEmail: user?.email ?? "", facebookAccessToken: token)
    self.navigationController?.pushViewController(vc, animated: true)
    self.navigationItem.backBarButtonItem = UIBarButtonItem.back(nil, selector: nil)
  }

  /// Presents an action sheet listing available help and legal options.
  func showHelpSheet(helpTypes: [HelpType]) {
    let helpSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    helpTypes.forEach { helpType in
      helpSheet.addAction(
        UIAlertAction(title: helpType.title, style: .default) { [weak helpVM = self.helpViewModel] _ in
          helpVM?.inputs.helpTypeButtonTapped(helpType)
        }
      )
    }

    helpSheet.addAction(
      UIAlertAction(
        title: Strings.login_tout_help_sheet_cancel(),
        style: .cancel,
        handler: nil
      )
    )

    helpSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    self.present(helpSheet, animated: true, completion: nil)
  }
}

// MARK: - TabBarControllerScrollable

extension LoginToutViewController: TabBarControllerScrollable {
  /// Scrolls the login scroll view to its top edge.
  func scrollToTop() {
    guard let scrollView = self.view.subviews
      .first(where: { view in view is UIScrollView })
      .flatMap({ view in view as? UIScrollView })
    else { return }

    scrollView.scrollToTop()
  }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginToutViewController: ASAuthorizationControllerDelegate {
  /// Forwards successful Sign in with Apple credentials to the login view model.
  public func authorizationController(
    controller _: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let authToken = credential.authorizationCode else {
      return
    }

    let fullName = credential.fullName
    let token = String(data: authToken, encoding: .utf8)

    let data = (
      appId: AppEnvironment.current.apiService.appId,
      firstName: fullName?.givenName,
      lastName: fullName?.familyName,
      token: token
    ) as? SignInWithAppleData
    self.viewModel.inputs.appleAuthorizationDidSucceed(with: data)
  }

  /// Maps Sign in with Apple authorization failures and notifies the login view model.
  public func authorizationController(
    controller _: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    if let error = error as? ASAuthorizationError {
      let authError: AppleAuthServicesError
      switch error.errorCode {
      case ASAuthorizationError.canceled.rawValue:
        authError = .canceled
      default:
        authError = .other(error)
      }
      self.viewModel.inputs.appleAuthorizationDidFail(with: authError)
    }
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginToutViewController: ASAuthorizationControllerPresentationContextProviding {
  /// Provides the hosting window anchor for Sign in with Apple authorization sheets.
  public func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window ?? ASPresentationAnchor()
  }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension LoginToutViewController: ASWebAuthenticationPresentationContextProviding {
  /// Provides the hosting window anchor for web authentication sessions.
  public func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return self.view.window ?? ASPresentationAnchor()
  }
}

