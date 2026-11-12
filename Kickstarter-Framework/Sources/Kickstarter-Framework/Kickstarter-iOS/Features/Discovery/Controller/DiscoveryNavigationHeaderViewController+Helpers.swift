import KDS
import KsApi
import Library
import UIKit

/// `DiscoveryNavigationHeaderViewController` extensions declared in `DiscoveryNavigationHeaderViewController+Helpers.swift`.
extension DiscoveryNavigationHeaderViewController {
  func showDiscoveryFilters(selectedRow: SelectableRow) {
    let vc = DiscoveryFiltersViewController.configuredWith(selectedRow: selectedRow)
    vc.delegate = self
    vc.modalPresentationStyle = .overFullScreen
    self.present(vc, animated: false, completion: nil)
  }

  func showFavoriteCategoriesAlert(categoryName: String) {
    let alertController = UIAlertController(
      title: categoryName,
      message: Strings.To_access_all_your_favorite_categories_tap_the_explore_dropdown(),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.discovery_favorite_categories_alert_buttons_got_it(),
        style: .cancel,
        handler: nil
      )
    )

    self.present(alertController, animated: true, completion: nil)
  }

  func animateArrow(toDown: Bool) {
    let scale: CGFloat = toDown ? 1.0 : -1.0

    UIView.animate(
      withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
        self.arrowImageView.transform = CGAffineTransform(scaleX: 1.0, y: scale)
      },
      completion: nil
    )
  }

  func updateFavoriteButton(selected: Bool, animated: Bool) {
    let duration = animated ? 0.4 : 0.0

    if selected {
      self.bookmarkImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)

      UIView.animate(
        withDuration: duration,
        delay: 0.0,
        usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.8,
        options: .curveEaseOut,
        animations: {
          self.bookmarkImageView.alpha = 1.0
          self.bookmarkImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          self.bookmarkOutlineImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        },
        completion: nil
      )

      UIView.animate(
        withDuration: duration,
        delay: animated ? 0.1 : 0.0,
        usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.8,
        options: .curveEaseOut,
        animations: {
          self.bookmarkOutlineImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          self.bookmarkOutlineImageView.alpha = 0.0
        },
        completion: nil
      )
    } else {
      UIView.animate(
        withDuration: duration,
        delay: 0.0,
        usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.8,
        options: .curveEaseOut,
        animations: {
          self.bookmarkImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
          self.bookmarkOutlineImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
          self.bookmarkOutlineImageView.alpha = 1.0
        },
        completion: nil
      )

      UIView.animate(
        withDuration: duration,
        delay: animated ? 0.1 : 0.0,
        usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.8,
        options: .curveEaseOut,
        animations: {
          self.bookmarkOutlineImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        },
        completion: { _ in
          self.bookmarkImageView.alpha = 0.0
        }
      )
    }
  }

  @objc func betaToolsButtonTapped() {
    let betaToolsViewController = BetaToolsViewController.instantiate()
    let navigationController = UINavigationController(rootViewController: betaToolsViewController)
    navigationController.modalPresentationStyle = .formSheet

    self.present(navigationController, animated: true)
  }

  @objc func titleButtonTapped() {
    self.viewModel.inputs.titleButtonTapped()
  }

  @objc func favoriteButtonTapped() {
    self.viewModel.inputs.favoriteButtonTapped()
  }
}

extension DiscoveryNavigationHeaderViewController: DiscoveryFiltersViewControllerDelegate {
  internal func discoveryFiltersDidClose(_: DiscoveryFiltersViewController) {
    self.viewModel.inputs.titleButtonTapped()
  }

  internal func discoveryFilters(
    _: DiscoveryFiltersViewController,
    selectedRow: SelectableRow
  ) {
    self.viewModel.inputs.filtersSelected(row: selectedRow)
  }
}

