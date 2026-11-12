import KsApi
import Library
import Prelude
import StoreKit
import UIKit

/// `ThanksViewController` extensions declared in `ThanksViewController+Navigation.swift`.
extension ThanksViewController {
  internal func goToAppStore(link: String) {
    guard let url = URL(string: link) else { return }
    UIApplication.shared.open(url)
  }

  internal func goToProject(_ project: Project, projects _: [Project], refTag: RefTag) {
    let projectParam = Either<Project, any ProjectPageParam>(left: project)
    let nav = ProjectPageViewController.navigationController(
      withProjectOrParam: projectParam,
      refInfo: RefInfo(refTag)
    )

    self.present(nav, animated: true, completion: nil)
  }

  internal func showRatingAlert() {
    if let scene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      SKStoreReviewController.requestReview(in: scene)
    }
  }

  internal func showGamesNewsletterAlert() {
    self.present(
      UIAlertController.games(
        subscribeHandler: { [weak self] _ in
          self?.viewModel.inputs.gamesNewsletterSignupButtonTapped()
        }
      ),
      animated: true,
      completion: nil
    )
  }

  internal func showGamesNewsletterOptInAlert(title: String) {
    self.present(
      UIAlertController.newsletterOptIn(title),
      animated: true,
      completion: nil
    )
  }

  internal func showShareSheet(_ controller: UIActivityViewController) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      controller.modalPresentationStyle = .popover
      let popover = controller.popoverPresentationController
      popover?.sourceView = self.shareMoreButton
    }

    self.present(controller, animated: true, completion: nil)
  }
}

extension ThanksViewController: ThanksCategoryCellDelegate {
  func thanksCategoryCell(_: ThanksCategoryCell, didTapSeeAllProjectsWith category: KsApi.Category) {
    self.viewModel.inputs.categoryCellTapped(category)
  }
}

