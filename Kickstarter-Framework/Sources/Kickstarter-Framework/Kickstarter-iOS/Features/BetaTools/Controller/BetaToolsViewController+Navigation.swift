import KDS
import KsApi
import Library
import MessageUI
import Prelude
import ServerDrivenUI
import SwiftUI
import UIKit

/// `BetaToolsViewController` extensions declared in `BetaToolsViewController+Navigation.swift`.
extension BetaToolsViewController {
  func goToDebugPushNotifications() {
    self.navigationController?.pushViewController(
      Storyboard.DebugPushNotifications.instantiate(DebugPushNotificationsViewController.self),
      animated: true
    )
  }

  func goToConfigFeatureFlagTools() {
    self.navigationController?.pushViewController(
      FeatureFlagToolsViewController.instantiate(),
      animated: true
    )
  }

  func goToRemoteConfigFeatureFlagTools() {
    self.navigationController?.pushViewController(
      RemoteConfigFeatureFlagToolsViewController.instantiate(),
      animated: true
    )
  }

  func showStatsigDebugger() {
    let viewController = UIHostingController(
      rootView: StatsigDebugView(client: AppEnvironment.current.statsigClient)
    )
    viewController.navigationItem.title = "Statsig"

    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func goToPaginatedScrollView() {
    let viewController = UIHostingController(rootView: PaginationExampleView())
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  @ViewBuilder private func richTextView(
    for project: RichTextExampleProjectsViewModel.ProjectItem
  ) -> some View {
    ScrollView {
      RichTextView(element: project.richText.asRichTextElements())
    }
    .navigationTitle(project.name)
  }

  func goToRichTextExample() {
    let viewController = UIHostingController(
      rootView: RichTextExampleProjectsView(onSelectProject: { [weak self] project in
        guard let self else { return }
        let detail = UIHostingController(rootView: self.richTextView(for: project))
        self.navigationController?.pushViewController(detail, animated: true)
      })
    )
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func goToDesignSystem() {
    self.navigationController?.pushViewController(DesignSystemViewController.instantiate(), animated: true)
  }

  func goToColors() {
    let viewController = UIHostingController(rootView: ColorsView())
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func showLanguageActionSheet(sourceViewIndex: Int) {
    guard let sourceView = self.tableView
      .cellForRow(at: IndexPath(row: sourceViewIndex, section: 0))?.detailTextLabel else {
      return
    }

    let preferredStyle: UIAlertController.Style = AppEnvironment.current.device.userInterfaceIdiom == .pad ?
      .alert : .actionSheet

    let alert = UIAlertController.alert(
      title: "Change Language",
      preferredStyle: preferredStyle,
      sourceView: sourceView
    )

    Language.allLanguages.forEach { language in
      alert.addAction(
        UIAlertAction(title: language.displayString, style: .default) { [weak self] _ in
          self?.viewModel.inputs.setCurrentLanguage(language)
        }
      )
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    self.present(alert, animated: true, completion: nil)
  }

  func showEnvironmentActionSheet(sourceViewIndex: Int) {
    guard let sourceView = self.tableView
      .cellForRow(at: IndexPath(row: sourceViewIndex, section: 0))?.detailTextLabel else {
      return
    }

    let preferredStyle: UIAlertController.Style = AppEnvironment.current.device.userInterfaceIdiom == .pad ?
      .alert : .actionSheet

    let alert = UIAlertController.alert(
      title: "Change Environment",
      preferredStyle: preferredStyle,
      sourceView: sourceView
    )

    let customAlertController = UIAlertController(
      title: "Custom HQ",
      message: "Enter the name of the HQ environment, e.g. for \"native.dev\" enter \"native\"",
      preferredStyle: .alert
    )
    customAlertController.addTextField()
    let submitAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
      guard let url = customAlertController.textFields?[0].text else { return }
      self?.viewModel.inputs.setEnvironment(.custom(url))
    }
    customAlertController.addAction(submitAction)
    customAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    EnvironmentType.allCases.forEach { environment in
      alert.addAction(UIAlertAction(title: environment.description, style: .default) { [weak self] _ in
        switch environment {
        case .custom:
          self?.present(customAlertController, animated: true)
        default:
          self?.viewModel.inputs.setEnvironment(environment)
        }
      })
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    self.present(alert, animated: true, completion: nil)
  }

  func updateLanguage(language: Language) {
    AppEnvironment.updateLanguage(language)

    NotificationCenter.default.post(
      name: Notification.Name.ksr_userLocalePreferencesChanged,
      object: nil,
      userInfo: nil
    )

    self.navigationController?.popViewController(animated: true)
  }

  func updateEnvironment(environment: EnvironmentType) {
    AppEnvironment.updateServerConfig(ServerConfig.config(for: environment))
    self.viewModel.inputs.didUpdateEnvironment()
  }

  func goToBetaFeedback() {
    let userName = AppEnvironment.current.currentUser?.name ?? "Logged out user"
    let userId = AppEnvironment.current.currentUser?.id ?? 0
    let version = AppEnvironment.current.mainBundle.version
    let shortVersion = AppEnvironment.current.mainBundle.shortVersionString
    let device = UIDevice.current

    let controller = MFMailComposeViewController()
    controller.setToRecipients([Secrets.fieldReportEmail])
    controller.setSubject("Field report: ")
    controller.setMessageBody(
      "\(userName) | \(userId) | \(version) | \(shortVersion) | " +
        "\(device.systemVersion) | \(device.modelCode)\n\n" +
        "Describe the bug here. Attach images if it helps!\n" +
        "---------------------------\n\n\n\n\n\n",
      isHTML: false
    )

    controller.mailComposeDelegate = self
    self.present(controller, animated: true, completion: nil)
  }

  func showMailDisabledAlert() {
    let alert = UIAlertController(
      title: "Cannot send mail",
      message: "Mail is disabled. Please set up mail and try again.",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

    self.present(alert, animated: true, completion: nil)
  }

  func logoutAndDismiss(params _: DiscoveryParams) {
    AppEnvironment.logout()

    NotificationCenter.default.post(.init(name: .ksr_sessionEnded))
    // Refresh the discovery screens
    NotificationCenter.default.post(.init(name: .ksr_environmentChanged))

    self.navigationController?.popViewController(animated: true)
  }
}

