import KsApi
import Library
import PassKit
import Stripe
import UIKit

// MARK: - Navigation & Payment Flows

extension PledgeViewController {
  /// Presents the Apple Pay payment sheet for the configured pledge amounts.
  func goToPaymentAuthorization(_ paymentAuthorizationData: PaymentAuthorizationData) {
    let request = PKPaymentRequest
      .paymentRequest(
        for: paymentAuthorizationData.project,
        reward: paymentAuthorizationData.reward,
        allRewardsTotal: paymentAuthorizationData.allRewardsTotal,
        additionalPledgeAmount: paymentAuthorizationData.additionalPledgeAmount,
        allRewardsShippingTotal: paymentAuthorizationData.allRewardsShippingTotal,
        merchantIdentifier: paymentAuthorizationData.merchantIdentifier
      )

    guard
      let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
    else { return }
    paymentAuthorizationViewController.delegate = self

    self.present(paymentAuthorizationViewController, animated: true)
  }

  /// Pushes the post-pledge confirmation screen.
  func goToThanks(data: ThanksPageData) {
    let thanksVC = ThanksViewController.configured(with: data)
    self.navigationController?.pushViewController(thanksVC, animated: true)
  }

  /// Modally presents the login/signup flow with the requested intent.
  func goToLoginSignup(with intent: LoginIntent) {
    let loginSignupViewController = LoginToutViewController.configuredWith(loginIntent: intent)
    let navigationController = UINavigationController(rootViewController: loginSignupViewController)
    self.present(navigationController, animated: true)
  }

  /// Launches Stripe 3D Secure setup-intent authentication for the given client secret.
  func beginSCAFlow(withClientSecret secret: String) {
    let setupIntentConfirmParams = STPSetupIntentConfirmParams(clientSecret: secret)

    STPPaymentHandler.shared()
      .confirmSetupIntent(setupIntentConfirmParams, with: self) { [weak self] status, _, error in
        self?.viewModel.inputs.scaFlowCompleted(with: status, error: error)
      }
  }
}

// MARK: - STPAuthenticationContext

extension PledgeViewController: STPAuthenticationContext {
  func authenticationPresentingViewController() -> UIViewController {
    return self
  }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension PledgeViewController: PKPaymentAuthorizationViewControllerDelegate {
  func paymentAuthorizationViewController(
    _: PKPaymentAuthorizationViewController,
    didAuthorizePayment payment: PKPayment,
    handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
  ) {
    let paymentDisplayName = payment.token.paymentMethod.displayName
    let paymentNetworkName = payment.token.paymentMethod.network?.rawValue
    let transactionId = payment.token.transactionIdentifier

    self.viewModel.inputs.paymentAuthorizationDidAuthorizePayment(paymentData: (
      paymentDisplayName,
      paymentNetworkName,
      transactionId
    ))

    STPAPIClient.shared.createToken(with: payment) { [weak self] token, error in
      guard let self = self else { return }

      let status = self.viewModel.inputs.stripeTokenCreated(token: token?.tokenId, error: error)
      let result = PKPaymentAuthorizationResult(status: status, errors: [])

      completion(result)
    }
  }

  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true, completion: { [weak self] in
      self?.viewModel.inputs.paymentAuthorizationViewControllerDidFinish()
    })
  }
}

// MARK: - PledgeViewCTAContainerViewDelegate

extension PledgeViewController: PledgeViewCTAContainerViewDelegate {
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

// MARK: - PledgeViewControllerMessageDisplaying

extension PledgeViewController: PledgeViewControllerMessageDisplaying {
  func pledgeViewController(_: UIViewController, didErrorWith message: String, error _: Error?) {
    self.messageBannerViewController?.showBanner(with: .error, message: message)
  }

  func pledgeViewController(_: UIViewController, didSucceedWith message: String) {
    self.messageBannerViewController?.showBanner(with: .success, message: message)
  }
}

// MARK: - PledgePaymentMethodsViewControllerDelegate

extension PledgeViewController: PledgePaymentMethodsViewControllerDelegate {
  func pledgePaymentMethodsViewController(
    _: PledgePaymentMethodsViewController,
    didSelectCreditCard paymentSource: PaymentSourceSelected
  ) {
    self.viewModel.inputs.creditCardSelected(with: paymentSource)
  }

  func pledgePaymentMethodsViewController(_: PledgePaymentMethodsViewController, loading flag: Bool) {
    if flag {
      self.showProcessingView()
    } else {
      self.hideProcessingView()
    }
  }
}

// MARK: - PledgeDisclaimerViewDelegate

extension PledgeViewController: PledgeDisclaimerViewDelegate {
  func pledgeDisclaimerView(_: PledgeDisclaimerView, didTapURL _: URL) {
    self.viewModel.inputs.pledgeDisclaimerViewDidTapLearnMore()
  }
}

// MARK: - PledgePaymentPlansViewControllerDelegate

extension PledgeViewController: PledgePaymentPlansViewControllerDelegate {
  func pledgePaymentPlansViewController(
    _: PledgePaymentPlansViewController,
    didSelectPaymentPlan paymentPlan: PledgePaymentPlansType
  ) {
    self.viewModel.inputs.paymentPlanSelected(paymentPlan)
  }

  func pledgePaymentPlansViewController(
    _: PledgePaymentPlansViewController,
    didTapTermsOfUseWith helpType: HelpType
  ) {
    self.paymentMethodsViewController.cancelModalPresentation(true)
    self.viewModel.inputs.termsOfUseTapped(with: helpType)
  }
}

