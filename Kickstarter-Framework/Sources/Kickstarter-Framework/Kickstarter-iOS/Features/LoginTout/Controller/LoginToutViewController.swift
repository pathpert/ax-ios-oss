import FacebookLogin
import FirebaseCrashlytics
import Foundation
import KDS
import KsApi
import Library
import MessageUI
import Prelude
import ReactiveSwift
import UIKit

/// Entry view controller presenting Sign in with Apple, Facebook Login, and OAuth login/signup options.
public final class LoginToutViewController: UIViewController, MFMailComposeViewControllerDelegate,
  ProcessingViewPresenting {
  // MARK: - Properties

  lazy var appleLoginButton: AdaptiveAppleIDButton = { AdaptiveAppleIDButton() }()
  lazy var backgroundImageView: UIImageView = { UIImageView(frame: .zero) }()
  lazy var bringCreativeProjectsToLifeLabel = { UILabel(frame: .zero) }()
  lazy var contextLabel = { UILabel(frame: .zero) }()
  lazy var emailLoginStackView = { UIStackView(frame: .zero) }()
  lazy var fbLoginButton = { UIButton(type: .custom)
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var fbLoginManager: LoginManager = {
    let manager = LoginManager()
    manager.defaultAudience = .friends
    return manager
  }()

  lazy var fbLoginStackView = { UIStackView(frame: .zero) }()
  lazy var getNotifiedLabel = { UILabel(frame: .zero) }()
  let helpViewModel = HelpViewModel()

  lazy var signupOrLoginWithOAuthButton = { UIButton(type: .custom)
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var loginContextStackView = { UIStackView() }()
  lazy var logoImageView = { UIImageView(frame: .zero) }()
  internal var processingView: ProcessingView? = ProcessingView(frame: .zero)
  lazy var rootStackView = { UIStackView() }()
  lazy var scrollView = {
    UIScrollView(frame: .zero)
      |> \.alwaysBounceVertical .~ true
  }()

  lazy var separatorView: UIView = { UIView(frame: .zero) }()
  private var sessionStartedObserver: Any?
  let viewModel: LoginToutViewModelType = LoginToutViewModel()

  // MARK: - Configuration

  /// Instantiates and configures a `LoginToutViewController` for the given login intent.
  public static func configuredWith(loginIntent intent: LoginIntent) -> LoginToutViewController {
    let vc = LoginToutViewController.instantiate()
    vc.viewModel.inputs.configureWith(intent)
    vc.helpViewModel.inputs.configureWith(helpContext: .loginTout)
    vc.helpViewModel.inputs.canSendEmail(MFMailComposeViewController.canSendMail())
    return vc
  }

  // MARK: - Lifecycle

  /// Configures localized login tout copy, button titles, and ReactiveSwift view model bindings.
  /// - Negative Constraint: Do not call directly to trigger navigation; bind through `viewModel.inputs`.
  public override func viewDidLoad() {
    super.viewDidLoad()

    self.configureViews()
    self.setupConstraints()
    self.configureTargets()

    self.fbLoginManager.logOut()

    self.sessionStartedObserver = NotificationCenter.default
      .addObserver(forName: .ksr_sessionStarted, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionStarted()
      }

    if self.presentingViewController != nil {
      self.navigationItem.leftBarButtonItem = .close(self, selector: #selector(self.closeButtonPressed))
    }

    _ = self.navigationItem
      |> \.rightBarButtonItem .~ .help(self, selector: #selector(self.helpButtonPressed))
  }

  /// Notifies the login tout view model when the screen is about to appear so navigation chrome updates.
  /// - Parameter animated: Whether the appearance transition is animated.
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.inputs.view(isPresented: self.presentingViewController != nil)
    self.viewModel.inputs.viewWillAppear()
  }

  deinit {
    self.sessionStartedObserver.doIfSome(NotificationCenter.default.removeObserver)
  }

  // MARK: - View Model

  /// Binds OAuth, Apple, Facebook, two-factor, and help flows from the login tout view models.
  public override func bindViewModel() {
    self.viewModel.outputs.startOAuthSignupOrLogin
      .observeForControllerAction()
      .observeValues { [weak self] _ in self?.pushOAuthFlow() }

    self.viewModel.outputs.logIntoEnvironmentWithApple
      .observeValues { [weak self] accessTokenEnv in
        AppEnvironment.login(accessTokenEnv)
        self?.viewModel.inputs.environmentLoggedIn()
      }

    self.viewModel.outputs.logIntoEnvironmentWithFacebook
      .observeValues { [weak self] accessTokenEnv in
        AppEnvironment.login(accessTokenEnv)
        self?.viewModel.inputs.environmentLoggedIn()
      }

    self.viewModel.outputs.postNotification
      .observeForUI()
      .observeValues {
        NotificationCenter.default.post($0.0)
        NotificationCenter.default.post($0.1)
      }

    self.viewModel.outputs.startFacebookConfirmation
      .observeForControllerAction()
      .observeValues { [weak self] user, token in
        self?.pushFacebookConfirmationController(facebookUser: user, facebookToken: token)
      }

    self.viewModel.outputs.startTwoFactorChallenge
      .observeForControllerAction()
      .observeValues { [weak self] token in
        self?.pushTwoFactorViewController(facebookAccessToken: token)
      }

    self.viewModel.outputs.attemptFacebookLogin
      .observeValues { [weak self] _ in self?.attemptFacebookLogin() }

    self.viewModel.outputs.showFacebookErrorAlert
      .observeForControllerAction()
      .observeValues { [weak self] error in
        self?.present(UIAlertController.alertController(forError: error), animated: true, completion: nil)
        Crashlytics.crashlytics().record(error: error.nsError)
      }

    self.viewModel.outputs.dismissViewController
      .observeForControllerAction()
      .observeValues { [weak self] in self?.dismiss(animated: true) }

    self.helpViewModel.outputs.showHelpSheet
      .observeForControllerAction()
      .observeValues { [weak self] in self?.showHelpSheet(helpTypes: $0) }

    self.helpViewModel.outputs.showMailCompose
      .observeForControllerAction()
      .observeValues { [weak self] in
        guard let strongSelf = self else { return }
        let controller = MFMailComposeViewController.support()
        controller.mailComposeDelegate = strongSelf
        strongSelf.present(controller, animated: true, completion: nil)
      }

    self.helpViewModel.outputs.showNoEmailError
      .observeForControllerAction()
      .observeValues { [weak self] alert in self?.present(alert, animated: true, completion: nil) }

    self.helpViewModel.outputs.showWebHelp
      .observeForControllerAction()
      .observeValues { [weak self] helpType in self?.goToHelpType(helpType) }

    self.contextLabel.rac.text = self.viewModel.outputs.logInContextText
    self.bringCreativeProjectsToLifeLabel.rac.hidden = self.viewModel.outputs.headlineLabelHidden

    self.viewModel.outputs.headlineLabelHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        _ = self?.contextLabel
          ?|> UILabel.lens.font .~ (isHidden ? UIFont.ksr_title2() : UIFont.ksr_subhead())
      }

    self.viewModel.outputs.attemptAppleLogin
      .observeForUI()
      .observeValues { [weak self] in self?.attemptAppleLogin() }

    self.viewModel.outputs.showAppleErrorAlert
      .observeForControllerAction()
      .observeValues { [weak self] message in self?.present(UIAlertController.genericError(message), animated: true) }

    self.viewModel.outputs.logAppleError
      .observeForUI()
      .observeValues { error in Crashlytics.crashlytics().record(error: error) }

    self.viewModel.outputs.isLoading
      .observeForUI()
      .observeValues { [weak self] isLoading in
        if isLoading { self?.showProcessingView() } else { self?.hideProcessingView() }
      }
  }

  private func configureTargets() {
    self.appleLoginButton.addTarget(self, action: #selector(self.appleLoginButtonPressed(_:)), for: .touchUpInside)
    self.fbLoginButton.addTarget(self, action: #selector(self.facebookLoginButtonPressed(_:)), for: .touchUpInside)
    self.signupOrLoginWithOAuthButton
      .addTarget(self, action: #selector(self.signupOrLoginWithOAuthButtonPressed), for: .touchUpInside)
  }

  // MARK: - Accessors

  /// Handles mail composer dismissal after submitting a support request from the login help sheet.
  @objc public func mailComposeController(
    _: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error _: Error?
  ) {
    self.helpViewModel.inputs.mailComposeCompletion(result: result)
    self.dismiss(animated: true, completion: nil)
  }

  @objc private func appleLoginButtonPressed(_: UIButton) { self.viewModel.inputs.appleLoginButtonPressed() }
  @objc private func closeButtonPressed() { self.dismiss(animated: true, completion: nil) }
  @objc private func helpButtonPressed() { self.helpViewModel.inputs.showHelpSheetButtonTapped() }
  @objc private func facebookLoginButtonPressed(_: UIButton) { self.viewModel.inputs.facebookLoginButtonPressed() }
  @objc private func signupOrLoginWithOAuthButtonPressed() {
    self.viewModel.inputs.signupOrLoginWithOAuthButtonPressed()
  }
}
