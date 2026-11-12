import KsApi
import ReactiveSwift
import Foundation

/// Input data required to configure `PledgeStatusLabelViewModel`.
public struct PledgeStatusLabelViewData {
  /// Whether the signed-in user is the creator of the project.
  public let currentUserIsCreatorOfProject: Bool
  /// Whether the pledge currency requires conversion relative to the project's currency.
  public let needsConversion: Bool
  /// The pledged amount in the project currency.
  public let pledgeAmount: Double
  /// The ISO currency code for `pledgeAmount`.
  public let currencyCode: String
  /// The project's funding deadline timestamp in seconds since 1970.
  public let projectDeadline: TimeInterval
  /// The project's current campaign state.
  public let projectState: Project.State
  /// The backing's current status.
  public let backingState: Backing.Status
  /// Scheduled payment increments when Pledge Over Time is used.
  public let paymentIncrements: [PledgePaymentIncrement]?
  // Temporary property
  /// Optional associated `Project`, used when rendering links inside PLOT error text.
  public let project: Project?
}

extension PledgeStatusLabelViewData {
  /// `true` when at least one Pledge Over Time installment increment is present.
  public var isPledgeOverTime: Bool {
    guard let paymentIncrements = self.paymentIncrements, !paymentIncrements.isEmpty else { return false }

    return true
  }
}

/// Inputs accepted by `PledgeStatusLabelViewModel`.
public protocol PledgeStatusLabelViewModelInputs {
  /// Configures the status label with pledge and project state data.
  func configure(with data: PledgeStatusLabelViewData)
}

/// Outputs exposed by `PledgeStatusLabelViewModel`.
public protocol PledgeStatusLabelViewModelOutputs {
  /// Emits the formatted attributed string explaining the current pledge status.
  var labelText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the status attention badge should be hidden.
  var badgeHidden: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs interface for `PledgeStatusLabelViewModel`.
public protocol PledgeStatusLabelViewModelType {
  /// The view model's inputs.
  var inputs: PledgeStatusLabelViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgeStatusLabelViewModelOutputs { get }
}

