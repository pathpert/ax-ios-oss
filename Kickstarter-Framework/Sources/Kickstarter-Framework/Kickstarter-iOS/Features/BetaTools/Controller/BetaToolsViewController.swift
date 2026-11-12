import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Internal debug menu presenting environment, language, feature-flag, design system, and feedback tools.
internal final class BetaToolsViewController: UITableViewController {
  // MARK: - Properties

  var betaToolsData: BetaToolsData?
  let helpViewModel: HelpViewModelType = HelpViewModel()
  let viewModel: BetaToolsViewModelType = BetaToolsViewModel()

  internal static func instantiate() -> BetaToolsViewController {
    return BetaToolsViewController(style: .plain)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    _ = self
      |> \.title .~ "Beta tools"

    _ = self.tableView
      |> \.dataSource .~ self

    self.configureFooterView()

    let doneButton = UIBarButtonItem(
      title: Strings.Done(), style: .done, target: self,
      action: #selector(self.doneButtonTapped)
    )

    _ = self.navigationItem
      ?|> \.rightBarButtonItem .~ doneButton

    self.viewModel.inputs.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    self.tableView.ksr_sizeHeaderFooterViewsToFit()
  }

  override func bindStyles() {
    _ = self.navigationController
      ?|> UINavigationController.lens.isNavigationBarHidden .~ false
  }

  override func bindViewModel() {
    self.viewModel.outputs.reloadWithData
      .observeForUI()
      .observeValues { [weak self] data in
        self?.betaToolsData = data
        self?.tableView.reloadData()
      }

    self.viewModel.outputs.goToPushNotificationTools
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToDebugPushNotifications() }

    self.viewModel.outputs.goToConfigFeatureFlagTools
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToConfigFeatureFlagTools() }

    self.viewModel.outputs.goToRemoteConfigFeatureFlagTools
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToRemoteConfigFeatureFlagTools() }

    self.viewModel.outputs.showStatsigDebugger
      .observeForControllerAction()
      .observeValues { [weak self] in self?.showStatsigDebugger() }

    self.viewModel.outputs.goToPaginatedScrollView
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToPaginatedScrollView() }

    self.viewModel.outputs.goToRichTextExample
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToRichTextExample() }

    self.viewModel.outputs.goToDesignSystem
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToDesignSystem() }

    self.viewModel.outputs.goToBetaFeedback
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToBetaFeedback() }

    self.viewModel.outputs.goToColors
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToColors() }

    self.viewModel.outputs.showChangeEnvironmentSheetWithSourceViewIndex
      .observeForControllerAction()
      .observeValues { [weak self] index in self?.showEnvironmentActionSheet(sourceViewIndex: index) }

    self.viewModel.outputs.showChangeLanguageSheetWithSourceViewIndex
      .observeForControllerAction()
      .observeValues { [weak self] index in self?.showLanguageActionSheet(sourceViewIndex: index) }

    self.viewModel.outputs.updateLanguage
      .observeForControllerAction()
      .observeValues { [weak self] language in self?.updateLanguage(language: language) }

    self.viewModel.outputs.updateEnvironment
      .observeForControllerAction()
      .observeValues { [weak self] environment in self?.updateEnvironment(environment: environment) }

    self.viewModel.outputs.logoutWithParams
      .observeForControllerAction()
      .observeValues { [weak self] in self?.logoutAndDismiss(params: $0) }

    self.viewModel.outputs.showMailDisabledAlert
      .observeForControllerAction()
      .observeValues { [weak self] in self?.showMailDisabledAlert() }
  }

  @objc private func doneButtonTapped() {
    self.navigationController?.dismiss(animated: true)
  }

  private func configureFooterView() {
    let containerView = UIView(frame: .zero)

    let betaToolsFooterView = BetaToolsFooterView(frame: .zero)
      |> \.delegate .~ self

    /* Silences autolayout warnings between conflicting table view frame-based sizing and our
     tableFooterView's autolayout constraints
     */
    let priority = UILayoutPriority(rawValue: 999)

    _ = (betaToolsFooterView, containerView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToMarginsInParent(priority: priority)

    _ = self.tableView
      |> \.tableFooterView .~ containerView

    NSLayoutConstraint.activate([
      betaToolsFooterView.widthAnchor
        .constraint(equalTo: self.tableView.layoutMarginsGuide.widthAnchor)
        |> \.priority .~ .defaultHigh
    ])
  }
}
