import KsApi
import Library
import PassKit
import Stripe
import UIKit

// MARK: - Navigation & Payment Confirmation

extension PostCampaignCheckoutViewController {
  /// Presents the login/signup sheet for the given intent.
  func goToLoginSignup(with intent: LoginIntent) {
    let loginSignupViewController = LoginToutViewController.configuredWith(loginIntent: intent)
    let navigationController = UINavigationController(rootViewController: loginSignupViewController)
    _ = navigationController.navigationBar.bounds.height
    self.present(navigationController, animated: true)
  }

  /// Confirms the validated Stripe payment intent or short-circuits if confirmation is already done.
  func confirmPayment(with validation: PaymentSourceValidation) {
    guard validation.requiresConfirmation else {
      self.viewModel.inputs.confirmPaymentSuccessful(clientSecret: validation.paymentIntentClientSecret)
      return
    }

    let paymentParams = STPPaymentIntentParams(clientSecret: validation.paymentIntentClientSecret)
    if let id = validation.selectedCardStripeCardId {
      paymentParams.paymentMethodId = id
    }

    STPPaymentHandler.shared()
      .confirmPayment(paymentParams, with: self) { status, _, error in
        guard error == nil, status == .succeeded else {
          if status == .failed {
            self.messageBannerViewController?
              .showBanner(
                with: .error,
                message: Strings.Something_went_wrong_please_try_again(),
                dismissType: .bannerAndViewController
              )
          }
          self.viewModel.inputs.checkoutTerminated()
          return
        }

        self.viewModel.inputs.confirmPaymentSuccessful(clientSecret: validation.paymentIntentClientSecret)
      }
  }

  /// Presents `STPApplePayContext` for late-pledge checkout authorization.
  func goToPaymentAuthorization(_ paymentAuthorizationData: PostCampaignPaymentAuthorizationData) {
    let request = PKPaymentRequest.paymentRequest(for: paymentAuthorizationData)
    guard let applePayContext = STPApplePayContext(paymentRequest: request, delegate: self) else {
      self.viewModel.inputs.checkoutTerminated()
      return
    }

    self.applePayPaymentIntent = paymentAuthorizationData.paymentIntent
    applePayContext.presentApplePay()
  }
}

// MARK: - STPAuthenticationContext

extension PostCampaignCheckoutViewController: STPAuthenticationContext {
  func authenticationPresentingViewController() -> UIViewController {
    return self
  }
}

// MARK: - PledgeDisclaimerViewDelegate

extension PostCampaignCheckoutViewController: PledgeDisclaimerViewDelegate {
  func pledgeDisclaimerView(_: PledgeDisclaimerView, didTapURL _: URL) {
    self.viewModel.inputs.pledgeDisclaimerViewDidTapLearnMore()
  }
}

// MARK: - PledgeViewCTAContainerViewDelegate

extension PostCampaignCheckoutViewController: PledgeViewCTAContainerViewDelegate {
  func goToLoginSignup() {
    self.paymentMethodsViewController.cancelModalPresentation(true)
    self.viewModel.inputs.goToLoginSignupTapped()
  }

  func applePayButtonTapped() {
    self.paymentMethodsViewController.cancelModalPresentation(true)
    self.viewModel.inputs.applePayButtonTapped()
  }

  func submitButtonTapped() {
    self.paymentMethodsViewController.cancelModalPresentation(true)
    self.viewModel.inputs.submitButtonTapped()
  }

  func termsOfUseTapped(with helpType: HelpType) {
    self.paymentMethodsViewController.cancelModalPresentation(true)
    self.viewModel.inputs.termsOfUseTapped(with: helpType)
  }
}

// MARK: - PledgePaymentMethodsViewControllerDelegate

extension PostCampaignCheckoutViewController: PledgePaymentMethodsViewControllerDelegate {
  func pledgePaymentMethodsViewController(
    _: PledgePaymentMethodsViewController,
    didSelectCreditCard paymentSource: PaymentSourceSelected
  ) {
    self.viewModel.inputs.creditCardSelected(source: paymentSource)
  }
}

// MARK: - PledgeViewControllerMessageDisplaying

extension PostCampaignCheckoutViewController: PledgeViewControllerMessageDisplaying {
  func pledgeViewController(_: UIViewController, didErrorWith message: String, error: Error?) {
    // If the error is a stripe error from attempting to add a new card, dismiss the banner only
    // instead of restarting the checkout flow.
    let stripeError = error as? NSError
    let dismissBannerOnly = stripeError?.domain == STPError.stripeDomain &&
      stripeError?.code == STPErrorCode.cardError.rawValue

    self.messageBannerViewController?.showBanner(
      with: .error,
      message: message,
      dismissType: dismissBannerOnly ? .bannerOnly : .bannerAndViewController
    )
  }

  func pledgeViewController(_: UIViewController, didSucceedWith message: String) {
    self.messageBannerViewController?.showBanner(with: .success, message: message)
  }
}

// MARK: - STPApplePayContextDelegate

/// Errors raised while fulfilling an Apple Pay payment intent during post-campaign checkout.
enum PostCampaignCheckoutApplePayError: Error {
  case missingPaymentMethodInfo(String)
  case missingPaymentIntent(String)
}

extension PostCampaignCheckoutViewController: STPApplePayContextDelegate {
  func applePayContext(
    _: StripeApplePay.STPApplePayContext,
    didCreatePaymentMethod paymentMethod: StripePayments.STPPaymentMethod,
    paymentInformation _: PKPayment,
    completion: @escaping StripeApplePay.STPIntentClientSecretCompletionBlock
  ) {
    guard let paymentIntentClientSecret = self.applePayPaymentIntent else {
      completion(
        nil,
        PostCampaignCheckoutApplePayError.missingPaymentIntent("Missing PaymentIntent")
      )
      return
    }

    self.viewModel.inputs.applePayContextDidCreatePayment(with: paymentMethod.stripeId)
    completion(paymentIntentClientSecret, nil)
  }

  func applePayContext(
    _: StripeApplePay.STPApplePayContext,
    didCompleteWith status: StripePayments.STPPaymentStatus,
    error _: Error?
  ) {
    switch status {
    case .success:
      self.viewModel.inputs.applePayContextDidComplete()
    case .error:
      self.viewModel.inputs.checkoutTerminated()
      self.messageBannerViewController?
        .showBanner(
          with: .error,
          message: Strings.Something_went_wrong_please_try_again(),
          dismissType: .bannerAndViewController
        )
    case .userCancellation:
      self.viewModel.inputs.checkoutTerminated()
    @unknown default:
      self.viewModel.inputs.checkoutTerminated()
      fatalError()
    }
  }
}

