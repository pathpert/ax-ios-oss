import KDS
import Library
import MessageUI
import Prelude
import UIKit

// MARK: - UITableViewDelegate

/// `BetaToolsViewController` extensions declared in `BetaToolsViewController+TableView.swift`.
extension BetaToolsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let row = BetaToolsRow(rawValue: indexPath.row) else {
      return
    }

    self.viewModel.inputs.didSelectBetaToolsRow(row)

    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - BetaToolsFooterViewDelegate

extension BetaToolsViewController: BetaToolsFooterViewDelegate {
  func betaToolsFooterViewDelegateDidTapFeedbackButton() {
    self.viewModel.inputs.betaFeedbackButtonTapped(canSendMail: MFMailComposeViewController.canSendMail())
  }
}

// MARK: - UITableViewDataSource

extension BetaToolsViewController {
  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return BetaToolsRow.allCases.count
  }

  override func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let row = BetaToolsRow.init(rawValue: indexPath.row), let rowData = self.betaToolsData else {
      fatalError("Cannot create cell")
    }

    let cell = UITableViewCell(style: row.cellStyle, reuseIdentifier: nil)
      |> \.selectionStyle .~ row.selectionStyle

    if let imageName = row.rightIconImageName {
      let image = UIImage(named: imageName)

      _ = cell
        |> \.accessoryView .~ UIImageView(image: image)
    }

    _ = cell.textLabel
      ?|> titleLabelStyle
      ?|> \.text .~ row.titleText

    _ = cell.detailTextLabel
      ?|> detailLabelStyle
      ?|> \.text .~ row.detailText(from: rowData)

    return cell
  }
}

extension BetaToolsViewController: MFMailComposeViewControllerDelegate {
  internal func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error _: Error?
  ) {
    self.helpViewModel.inputs.mailComposeCompletion(result: result)
    controller.dismiss(animated: true, completion: nil)
  }
}

private let detailLabelStyle: Library.LabelStyle = { label in
  label
    |> \.font .~ .ksr_headline(size: 15)
    |> \.textColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.lineBreakMode .~ .byWordWrapping
    |> \.textAlignment .~ .right
}

private let titleLabelStyle: Library.LabelStyle = { label in
  label
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.font .~ .ksr_body()
}

