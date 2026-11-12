import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Delegate notified when `DiscoveryPageViewController` scrolls to a new content offset.
protocol DiscoveryPageViewControllerDelegate: AnyObject {
  /// Reports scroll view content offset changes while discovery projects are not loading.
  func discoverPageViewController(
    _ viewController: DiscoveryPageViewController,
    contentOffsetDidChangeTo offset: CGPoint
  )
}

// MARK: - Styles & Helpers

extension DiscoveryPageViewController {
  /// Applies row height, background color, and header label styling.
  override func bindStyles() {
    super.bindStyles()

    _ = self.tableView
      |> \.rowHeight .~ UITableView.automaticDimension
      |> \.estimatedRowHeight .~ 200.0

    _ = self.view
      |> \.backgroundColor .~ discoveryPageBackgroundColor()

    _ = self.headerLabel
      |> discoveryHeaderLabelStyle
  }

  /// Registers a `NotificationCenter` observer and retains it for deregistration in `deinit`.
  func subscribe(
    toNotification notification: Notification.Name,
    using action: @escaping @Sendable (Notification) -> Void
  ) {
    let observer = NotificationCenter.default.addObserver(
      forName: notification,
      object: nil,
      queue: nil,
      using: action
    )
    self.observers.append(observer)
  }

  /// Embeds the reusable `EmptyStatesViewController` child controller over the discovery table.
  func configureEmptyStatesController() {
    let emptyVC = EmptyStatesViewController.configuredWith(emptyState: nil)
    self.emptyStatesController = emptyVC
    emptyVC.delegate = self
    self.addChild(emptyVC)
    self.view.addSubview(emptyVC.view)
    NSLayoutConstraint.activate([
      emptyVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
      emptyVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      emptyVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      emptyVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    emptyVC.didMove(toParent: self)
  }
}

extension UIView {
  /// Executes `closure` immediately or within `UIView.performWithoutAnimation` based on `animated`.
  static func performDiscoveryTransition(animated: Bool, _ closure: () -> Void) {
    if animated {
      closure()
    } else {
      UIView.performWithoutAnimation { closure() }
    }
  }
}

private let discoveryHeaderLabelStyle: LabelStyle = { label in
  label
    |> \.textColor .~ LegacyColors.ksr_trust_700.uiColor()
    |> \.font .~ UIFont.ksr_subhead().bolded
    |> \.lineBreakMode .~ .byWordWrapping
    |> \.numberOfLines .~ 0
    |> \.textAlignment .~ .center
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
}

