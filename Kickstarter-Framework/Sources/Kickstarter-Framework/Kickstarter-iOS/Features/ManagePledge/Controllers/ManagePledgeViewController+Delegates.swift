import KsApi
import Library
import Prelude
import UIKit

// MARK: - Actions & Navigation

extension ManagePledgeViewController {
  /// Presents an action sheet of available pledge management actions.
  func showActionSheetMenuWithOptions(_ options: [ManagePledgeAlertAction]) {
    let actionSheet = UIAlertController.alert(
      title: Strings.Select_an_option(),
      preferredStyle: .actionSheet,
      barButtonItem: self.menuButton
    )

    options.forEach { option in
      let title: String
      switch option {
      case .editPledgeOverTimePledge:
        title = Strings.Edit_pledge()
      case .changePaymentMethod:
        title = Strings.Change_payment_method()
      case .chooseAnotherReward:
        title = Strings.Edit_reward()
      case .contactCreator:
        title = Strings.Contact_creator()
      case .cancelPledge:
        title = Strings.Cancel_pledge()
      case .viewRewards:
        title = Strings.View_rewards()
      }

      let style: UIAlertAction.Style = option == .cancelPledge ? .destructive : .default
      actionSheet.addAction(
        UIAlertAction(title: title, style: style, handler: { _ in
          self.viewModel.inputs.menuOptionSelected(with: option)
        })
      )
    }

    actionSheet.addAction(UIAlertAction(title: Strings.Cancel(), style: .cancel))
    self.present(actionSheet, animated: true)
  }

  /// Pushes the rewards collection screen to change or view rewards.
  func goToRewards(_ project: Project) {
    let vc = RewardsCollectionViewController.instantiate(with: project, refTag: nil, context: .managePledge)
    vc.pledgeViewDelegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }

  /// Pushes the pledge cancellation confirmation flow.
  func goToCancelPledge(with data: CancelPledgeViewData) {
    let cancelPledgeViewController = CancelPledgeViewController.instantiate()
      |> \.delegate .~ self
    cancelPledgeViewController.configure(with: data)
    self.navigationController?.pushViewController(cancelPledgeViewController, animated: true)
  }

  /// Pushes the checkout flow configured to update the pledge payment method.
  func goToChangePaymentMethod(data: PledgeViewData) {
    let vc = PledgeViewController.instantiate()
    vc.configure(with: data)
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }

  /// Pushes the checkout flow configured to retry or fix an errored payment method.
  func goToFixPaymentMethod(data: PledgeViewData) {
    let vc = PledgeViewController.instantiate()
    vc.configure(with: data)
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }

  /// Modally presents the creator messaging sheet.
  func goToContactCreator(
    messageSubject: MessageSubject,
    context: KSRAnalytics.MessageDialogContext
  ) {
    let vc = MessageDialogViewController.configuredWith(messageSubject: messageSubject, context: context)
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .formSheet
    vc.delegate = self
    self.present(nav, animated: true, completion: nil)
  }
}

// MARK: - CancelPledgeViewControllerDelegate

extension ManagePledgeViewController: CancelPledgeViewControllerDelegate {
  func cancelPledgeViewController(
    _: CancelPledgeViewController,
    didCancelPledgeWithMessage message: String
  ) {
    self.viewModel.inputs.cancelPledgeDidFinish(with: message)
  }
}

// MARK: - ManagePledgePaymentMethodViewDelegate

extension ManagePledgeViewController: ManagePledgePaymentMethodViewDelegate {
  func managePledgePaymentMethodViewDidTapFixButton(_: ManagePledgePaymentMethodView) {
    self.viewModel.inputs.fixButtonTapped()
  }
}

// MARK: - PledgeViewControllerDelegate

extension ManagePledgeViewController: PledgeViewControllerDelegate {
  func pledgeViewControllerDidUpdatePledge(_: PledgeViewController, message: String) {
    self.viewModel.inputs.pledgeViewControllerDidUpdatePledgeWithMessage(message)
  }
}

// MARK: - MessageDialogViewControllerDelegate

extension ManagePledgeViewController: MessageDialogViewControllerDelegate {
  internal func messageDialogWantsDismissal(_ dialog: MessageDialogViewController) {
    dialog.dismiss(animated: true, completion: nil)
  }

  internal func messageDialog(_: MessageDialogViewController, postedMessage _: Message) {}
}

// MARK: - PledgeOverTimePaymentScheduleDelegate

extension ManagePledgeViewController: PledgeOverTimePaymentScheduleDelegate {
  func termsOfUseTapped(with helpType: HelpType) {
    self.viewModel.inputs.termsOfUseTapped(with: helpType)
  }
}

