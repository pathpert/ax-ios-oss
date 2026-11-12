import Foundation
import KDS
import KsApi
import Library
import Prelude
import Stripe
import UIKit

extension PPOContainerViewController {
  // MARK: - Event Helpers

  internal func handleEvent(_ event: PPOPreparedEvent) {
    let tabBarController = self.tabBarController as? RootTabBarViewController

    switch event {
    case .backedProjects:
      tabBarController?.switchToProfile()
    case .exploreProjects:
      tabBarController?.switchToDiscovery(params: nil)
    case let .projectDetails(param):
      self.openProjectPage(param)
    case let .editAddress(url), let .survey(url), let .openPledgeManager(url):
      self.openSurvey(url)
    case let .contactCreator(messageSubject):
      self.messageCreator(messageSubject)
    case let .fixPaymentMethod(projectId, backingId),
         let .manageLivePledge(projectId, backingId):
      self.openNativeManagePledge(projectId: projectId, backingId: backingId)
    case let .fix3DSChallenge(clientSecret, onProgress):
      self.handle3DSChallenge(clientSecret: clientSecret, onProgress: onProgress)
    case let .confirmAddress(backingId, addressId, address, onProgress):
      self.confirmAddress(
        backingId: backingId,
        addressId: addressId,
        address: address,
        onProgress: onProgress
      )
    case let .updateRewardReceived(backingId: backingId, rewardReceived: rewardReceived):
      self.updateRewardReceived(backingId: backingId, rewardReceived: rewardReceived)
    }
  }

  private func openNativeManagePledge(projectId: Int, backingId: Int) {
    let data = ManagePledgeViewParamConfigData(
      projectParam: Param.id(projectId),
      backingParam: Param.id(backingId)
    )
    let vc = ManagePledgeViewController.controller(with: data, delegate: self)
    vc.presentationController?.delegate = self
    self.navigationController?.present(vc, animated: true)
  }

  private func openSurvey(_ url: String) {
    let vc = PledgeManagerWebViewController.configuredWith(url: url)
    vc.delegate = self
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .pageSheet
    nav.presentationController?.delegate = self

    self.navigationController?.present(nav, animated: true)
  }

  private func openProjectPage(_ param: ProjectPageParam) {
    let projectParam = Either<Project, any ProjectPageParam>(right: param)
    let nav = ProjectPageViewController.navigationController(
      withProjectOrParam: projectParam,
      refInfo: nil
    )

    nav.presentationController?.delegate = self
    self.present(nav, animated: true, completion: nil)
  }

  private func messageCreator(_ messageSubject: MessageSubject) {
    let vc = MessageDialogViewController.configuredWith(messageSubject: messageSubject, context: .backerModal)
    vc.delegate = self
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .formSheet
    nav.presentationController?.delegate = self

    self.present(nav, animated: true, completion: nil)
  }

  private func confirmAddress(
    backingId: String,
    addressId: String,
    address: String,
    onProgress: @escaping (PPOActionState) -> Void
  ) {
    onProgress(.processing)

    let alert = UIAlertController(
      title: Strings.Confirm_your_address(),
      message: address,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(
      title: Strings.Cancel(),
      style: .cancel,
      handler: { _ in onProgress(.cancelled) }
    ))
    alert.addAction(UIAlertAction(
      title: Strings.Confirm(),
      style: .default,
      handler: { [weak self] _ in
        self?.viewModel.confirmAddress(addressId: addressId, backingId: backingId, onProgress: onProgress)
      }
    ))
    self.present(alert, animated: true, completion: nil)
  }

  private func updateRewardReceived(backingId: String, rewardReceived: Bool) {
    self.viewModel.updateRewardReceived(backingId: backingId, rewardReceived: rewardReceived)
  }

  private func handle3DSChallenge(
    clientSecret: String,
    onProgress: @escaping (PPOActionState) -> Void
  ) {
    if clientSecret.hasPrefix("seti_") {
      onProgress(.processing)

      let confirmParams = STPSetupIntentConfirmParams(clientSecret: clientSecret)
      self.handle3DSSetupIntent(confirmParams: confirmParams, onProgress: onProgress)
    } else if clientSecret.hasPrefix("pi_") {
      onProgress(.processing)

      let paymentParams = STPPaymentIntentParams(clientSecret: clientSecret)
      self.handle3DSPaymentIntent(paymentParams: paymentParams, onProgress: onProgress)
    } else {
      onProgress(.failed)
    }
  }

  private func handle3DSSetupIntent(
    confirmParams: STPSetupIntentConfirmParams,
    onProgress: @escaping (PPOActionState) -> Void
  ) {
    STPPaymentHandler.shared().confirmSetupIntent(
      confirmParams,
      with: self,
      completion: { [weak self] status, _, _ in
        switch status {
        case .succeeded:
          self?.viewModel.process3DSAuthentication(state: .succeeded)
          onProgress(.succeeded)
        case .canceled:
          onProgress(.cancelled)
        case .failed:
          self?.viewModel.process3DSAuthentication(state: .failed)
          onProgress(.failed)
        }
      }
    )
  }

  private func handle3DSPaymentIntent(
    paymentParams: STPPaymentIntentParams,
    onProgress: @escaping (PPOActionState) -> Void
  ) {
    STPPaymentHandler.shared().confirmPayment(
      paymentParams,
      with: self,
      completion: { [weak self] status, _, _ in
        switch status {
        case .succeeded:
          self?.viewModel.process3DSAuthentication(state: .succeeded)
          onProgress(.succeeded)
        case .canceled:
          onProgress(.cancelled)
        case .failed:
          self?.viewModel.process3DSAuthentication(state: .failed)
          onProgress(.failed)
        }
      }
    )
  }
}

extension PPOContainerViewController: MessageDialogViewControllerDelegate {
  internal func messageDialogWantsDismissal(_ dialog: MessageDialogViewController) {
    dialog.dismiss(animated: true, completion: nil)
  }

  internal func messageDialog(_: MessageDialogViewController, postedMessage _: Message) {}
}

extension PPOContainerViewController: STPAuthenticationContext {
  /// Returns this view controller as the presenting context for Stripe 3DS authentication.
  public func authenticationPresentingViewController() -> UIViewController {
    return self
  }

  /// Notifies the view model when the Stripe 3DS authentication controller is about to dismiss.
  public func authenticationContextWillDismiss(_: UIViewController) {
    self.viewModel.actionFinishedPerforming()
  }
}

extension PPOContainerViewController: PledgeManagerWebViewControllerDelegate {
  /// Notifies the view model when the pledge manager web flow dismisses.
  public func pledgeManagerWebViewControllerDismissed() {
    self.viewModel.actionFinishedPerforming()
  }
}

extension PPOContainerViewController: ManagePledgeViewControllerDelegate {
  func managePledgeViewController(
    _: ManagePledgeViewController,
    managePledgeViewControllerFinishedWithMessage _: String?
  ) {
    self.viewModel.actionFinishedPerforming()
  }

  func managePledgeViewControllerDidDismiss(_: ManagePledgeViewController) {
    self.viewModel.actionFinishedPerforming()
  }
}

extension PPOContainerViewController: UIAdaptivePresentationControllerDelegate {
  /// Notifies the view model when an interactively presented sheet dismisses.
  public func presentationControllerDidDismiss(_: UIPresentationController) {
    self.viewModel.actionFinishedPerforming()
  }
}

