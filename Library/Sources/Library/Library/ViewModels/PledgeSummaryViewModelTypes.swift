import Foundation
import KsApi
import ReactiveSwift

/// Strongly-typed contract configuring the pledge summary and confirmation copy section.
///
/// Format: `total` is expressed in major currency units of `project.statsCurrency`.
/// Negative Constraint: Do not pass post-conversion user-currency amounts as `total`; conversion is computed internally.
public struct PledgeSummaryViewData {
  /// Project being backed (supplies currency formatting and campaign deadline).
  public let project: Project
  /// Total pledge amount in major units of `project.statsCurrency`.
  public let total: Double
  /// `true` to hide the pledge-charge confirmation disclosure label.
  public let confirmationLabelHidden: Bool
  /// Indicates whether the backing excludes a physical/digital reward tier; `nil` when unspecified.
  public let pledgeHasNoReward: Bool?

  /// Creates a typed `PledgeSummaryViewData` contract.
  public init(
    project: Project,
    total: Double,
    confirmationLabelHidden: Bool,
    pledgeHasNoReward: Bool?
  ) {
    self.project = project
    self.total = total
    self.confirmationLabelHidden = confirmationLabelHidden
    self.pledgeHasNoReward = pledgeHasNoReward
  }
}

/// Inputs accepted by `PledgeSummaryViewModel`.
public protocol PledgeSummaryViewModelInputs {
  /// Configures the summary view with project and total amount details.
  func configure(with data: PledgeSummaryViewData)
  /// Configures optional Pledge Over Time installment schedule details.
  func configureWith(pledgeOverTimeData: PledgePaymentPlansAndSelectionData?)
  /// Handles a tap on an informational link in the summary disclosure.
  func tapped(_ url: URL)
  /// Signals that the pledge summary view has loaded.
  func viewDidLoad()
}

/// Outputs exposed by `PledgeSummaryViewModel`.
public protocol PledgeSummaryViewModelOutputs {
  /// Emits the formatted pledge total amount attributed string.
  var amountLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits the charge timing disclosure attributed string.
  var confirmationLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the confirmation disclosure label should be hidden.
  var confirmationLabelHidden: Signal<Bool, Never> { get }
  /// Emits the resolved `HelpType` when a link in the summary disclosure is tapped.
  var notifyDelegateOpenHelpType: Signal<HelpType, Never> { get }
  /// Emits whether the Pledge Over Time charges summary stack should be hidden.
  var pledgeOverTimeStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the installment count description string for Pledge Over Time.
  var pledgeOverTimeChargesText: Signal<String, Never> { get }
  /// Emits the converted pledge total string in the user's local currency.
  var totalConversionLabelText: Signal<String, Never> { get }
  /// Emits the localized header title text for the pledge summary row.
  var titleLabelText: Signal<String, Never> { get }
}

/// Combined inputs and outputs interface for `PledgeSummaryViewModel`.
public protocol PledgeSummaryViewModelType {
  /// The view model's inputs.
  var inputs: PledgeSummaryViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgeSummaryViewModelOutputs { get }
}

