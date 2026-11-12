import KDS
import KsApi
import Library
import Prelude
import ServerDrivenUI
import SwiftUI
import UIKit

extension ProjectPageViewController {
  /// Configures the navigation bar appearance, bar button items, and project title.
  public func configureNavigation() {
    self.navigation.delegate = self
    self.navigationItem.rightBarButtonItems = self.navigation.rightBarButtonItems

    let appearance = UINavigationBarAppearance.projectPageNavigationBarAppearance
    self.navigationItem.standardAppearance = appearance
    self.navigationItem.scrollEdgeAppearance = appearance

    // TODO(CHECK-84): Once we consolidate all the calls to wrap a ProjectPageViewController in
    // a navigation controller, we should set the close button there.
    guard let root = self.navigationController?.viewControllers.first else { return }
    if self == root {
      self.navigationItem.leftBarButtonItem = self.navigation.closeButton
    }

    self.navigationItem.title = Strings.Pledge_flow_navigation_bar_titles_Project()
    self.navigationItem.titleView = UIView()
  }

  internal func configurePledgeCTAContainerView() {
    _ = (self.pledgeCTAContainerView, self.view)
      |> ksr_addSubviewToParent()

    self.pledgeCTAContainerView.retryButton.addTarget(
      self,
      action: #selector(ProjectPageViewController.pledgeRetryButtonTapped),
      for: .touchUpInside
    )
    self.pledgeCTAContainerView.delegate = self
  }

  internal func configureTableView() {
    _ = self.tableView
      |> \.prefetchDataSource .~ self
      |> \.dataSource .~ self.dataSource
      |> \.delegate .~ self
      |> \.tableFooterView .~
      UIView(frame: CGRect(
        x: 0,
        y: 0,
        width: 0,
        height: ProjectPageViewControllerStyles.Layout.tableFooterViewHeight
      ))

    _ = (self.tableView, self.view)
      |> ksr_addSubviewToParent()
  }

  internal func registerTableViewCells() {
    let cellClasses: [UITableViewCell.Type] = [
      ProjectFAQsAskAQuestionCell.self,
      ProjectFAQsCell.self,
      ProjectFAQsEmptyStateCell.self,
      ProjectTabAIGenerationCell.self,
      ProjectTabCategoryDescriptionCell.self,
      ProjectTabDisclaimerCell.self,
      ProjectTabCheckmarkListCell.self,
      ProjectHeaderCell.self,
      ProjectPamphletCreatorHeaderCell.self,
      TextViewElementCell.self,
      ImageViewElementCell.self,
      AudioVideoViewElementCell.self,
      ExternalSourceViewElementCell.self,
      ReportProjectCell.self,
      SimilarProjectsTableViewCell.self,
      ProjectRisksCell.self,
      ProjectRisksDisclaimerCell.self
    ]
    cellClasses.forEach { self.tableView.registerCellClass($0) }
    self.tableView.register(nib: .ProjectPamphletMainCell)
    self.tableView.register(nib: .ProjectPamphletSubpageCell)
  }

  internal func configureRichTextView() {
    _ = self.storyRichTextHostingController.view
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
      |> \.isHidden .~ true

    self.storyRichTextHostingController.view.setContentHuggingPriority(.defaultLow, for: .vertical)

    _ = (self.storyRichTextHostingController.view, self.view)
      |> ksr_addSubviewToParent()

    self.addChild(self.storyRichTextHostingController)
    self.storyRichTextHostingController.didMove(toParent: self)
  }

  internal func configureNavigationSelectorView() {
    _ = (self.projectNavigationSelectorView, self.view)
      |> ksr_addSubviewToParent()
    self.projectNavigationSelectorView.delegate = self
  }

  internal func configureNavigationShadowView() {
    _ = (self.projectNavigationShadowView, self.view)
      |> ksr_addSubviewToParent()
  }

  internal func applyProjectPageStyles() {
    _ = self.view |>
      \.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.tableView |> tableViewStyle

    _ = self.projectNavigationShadowView
      |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
      |> dropShadowStyle(
        offset: .init(width: 0, height: 0),
        shadowOpacity: ProjectPageViewControllerStyles.Layout
          .projectNavigationSelectorShadowOpacity
      )
  }

  internal func updateTableViewConstraints() {
    let tableViewBottomToPledgeCTA = self.tableView.bottomAnchor
      .constraint(equalTo: self.pledgeCTAContainerView.topAnchor, constant: -Styles.grid(1))

    NSLayoutConstraint.activate([
      tableViewBottomToPledgeCTA,
      self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.tableView.topAnchor.constraint(equalTo: self.projectNavigationSelectorView.bottomAnchor),
      self.tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
    ])
  }

  internal func updateNavigationSelectorViewConstraints() {
    NSLayoutConstraint.activate([
      self.projectNavigationSelectorView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.projectNavigationSelectorView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.projectNavigationSelectorView.topAnchor
        .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
    ])
  }

  internal func updateNavigationShadowViewConstraints() {
    NSLayoutConstraint.activate([
      self.projectNavigationShadowView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.projectNavigationShadowView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.projectNavigationShadowView.topAnchor
        .constraint(
          equalTo: self.projectNavigationSelectorView.bottomAnchor,
          constant: ProjectPageViewControllerStyles.Layout
            .projectNavigationSelectorShadowVerticalOriginModifier
        ),
      self.projectNavigationShadowView.heightAnchor
        .constraint(
          equalToConstant: ProjectPageViewControllerStyles.Layout
            .projectNavigationSelectorShadowViewHeight
        )
    ])
  }

  internal func updatePledgeCTAConstraints() {
    NSLayoutConstraint.activate([
      self.pledgeCTAContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.pledgeCTAContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.pledgeCTAContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }

  internal func updateRichTextViewConstraints() {
    let verticalConstraint = self.storyRichTextHostingController.view.bottomAnchor
      .constraint(equalTo: self.pledgeCTAContainerView.topAnchor, constant: -1)
    self.richTextViewConstraints = [
      self.storyRichTextHostingController.view.topAnchor
        .constraint(equalTo: self.projectNavigationSelectorView.bottomAnchor),
      verticalConstraint,
      self.storyRichTextHostingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.storyRichTextHostingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
    ]
  }

  internal func setupNotifications() {
    let notifications: [(Selector, Notification.Name)] = [
      (#selector(ProjectPageViewController.didBackProject), .ksr_projectBacked),
      (#selector(ProjectPageViewController.userSessionStarted), .ksr_sessionStarted),
      (#selector(self.appBackgrounded), .ksr_applicationDidEnterBackground)
    ]
    notifications.forEach { selector, name in
      NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
  }

  internal func showContentView(_ contentView: ProjectPageContentView) {
    switch contentView {
    case .tableView:
      self.tableView.isHidden = false
      NSLayoutConstraint.deactivate(self.richTextViewConstraints)
      self.storyRichTextHostingController.view.removeFromSuperview()
      self.storyRichTextHostingController.removeFromParent()
      self.storyRichTextHostingController.didMove(toParent: nil)
    case let .richTextView(elements):
      self.storyRichTextHostingController.rootView = ScrollView {
        RichTextView(element: elements)
      }
      self.tableView.isHidden = true
      if self.storyRichTextHostingController.parent == nil {
        self.addChild(self.storyRichTextHostingController)
        self.view.addSubview(self.storyRichTextHostingController.view)
        self.storyRichTextHostingController.didMove(toParent: self)
      }
      self.storyRichTextHostingController.view.isHidden = false
      NSLayoutConstraint.activate(self.richTextViewConstraints)
    }
  }
}

private let tableViewStyle: TableViewStyle = { tableView in
  tableView
    |> \.estimatedRowHeight .~ 100.0
    |> \.rowHeight .~ UITableView.automaticDimension
}

