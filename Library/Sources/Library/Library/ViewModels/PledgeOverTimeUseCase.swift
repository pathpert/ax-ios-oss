import Foundation
import GraphAPI
import KsApi
import ReactiveSwift

/// Input contract for `PledgeOverTimeUseCase`.
public protocol PledgeOverTimeUseCaseInputs {
  /// Updates the user's selected pledge payment plan (full vs. split installments).
  func paymentPlanSelected(_ paymentPlan: PledgePaymentPlansType)
}

/// Output contract for `PledgeOverTimeUseCase`.
public protocol PledgeOverTimeUseCaseOutputs {
  /// Emits whether the Pledge Over Time UI section should be visible.
  var showPledgeOverTimeUI: Signal<Bool, Never> { get }
  /// Emits built installment plan options and current selection, or `nil` when hidden/unavailable.
  var pledgeOverTimeConfigData: Signal<PledgePaymentPlansAndSelectionData?, Never> { get }
  /// Emits loading spinner visibility while fetching `BuildPaymentPlanQuery`.
  var pledgeOverTimeIsLoading: Signal<Bool, Never> { get }

  // Visible only for testing
  /// Emits formatted `(projectSlug, amount)` pairs used to trigger `BuildPaymentPlanQuery`.
  var buildPaymentPlanInputs: Signal<(String, String), Never> { get }
}

/// Composite UseCase protocol pairing Pledge Over Time checkout inputs and outputs.
public protocol PledgeOverTimeUseCaseType {
  /// Input receiver.
  var inputs: PledgeOverTimeUseCaseInputs { get }
  /// Output signal provider.
  var outputs: PledgeOverTimeUseCaseOutputs { get }
}

/// A component view model for Pledge Over Time in the pledge checkout flow.
/// Creates one `BuildPaymentPlanQuery` and uses those results to create data for the UI.
///
/// Negative Constraint: Requires both `project` and `pledgeTotal` before `showPledgeOverTimeUI` or `pledgeOverTimeIsLoading` emit; automatically hides on query error.
public final class PledgeOverTimeUseCase: PledgeOverTimeUseCaseType, PledgeOverTimeUseCaseInputs,
  PledgeOverTimeUseCaseOutputs {
  init(
    project: Signal<Project, Never>,
    pledgeTotal: Signal<Double, Never>,
    context: Signal<PledgeViewContext, Never>
  ) {
    let pledgeOverTimeUIEnabled = Signal.combineLatest(project, context)
      .map { project, context -> Bool in
        project.isPledgeOverTimeAllowed == true && context.isAny(of: .pledge, .editPledgeOverTime)
      }

    self.buildPaymentPlanInputs = Signal.combineLatest(
      project,
      // just re-evaluate if the total is changed
      pledgeTotal.skipRepeats()
    )
    .map { (project: Project, pledgeTotal: Double) -> (
      String,
      String
    ) in
      let amountFormatter = NumberFormatter()
      amountFormatter.minimumFractionDigits = 2
      amountFormatter.maximumFractionDigits = 2
      let amount = amountFormatter.string(from: NSNumber(value: pledgeTotal)) ?? ""

      return (project.slug, amount)
    }

    let pledgeOverTimeQuery = self.buildPaymentPlanInputs
      .switchMap { (
        paymentPlanInputs: (slug: String, amount: String)
      ) -> SignalProducer<
        Signal<GraphAPI.BuildPaymentPlanQuery.Data?, ErrorEnvelope>.Event,
        Never
      > in
        AppEnvironment.current.apiService.buildPaymentPlan(
          projectSlug: paymentPlanInputs.slug,
          pledgeAmount: paymentPlanInputs.amount
        )
        // Wrap the response in an optional and convert the SignalProducer events into materialized values
        // to handle success or error scenarios downstream.
        .wrapInOptional()
        .materialize()
      }

    self.showPledgeOverTimeUI = Signal.merge(
      // Hide PLOT if the feature flag is off on either client or server
      pledgeOverTimeUIEnabled,
      // Hide PLOT if an error occurs
      pledgeOverTimeQuery.errors().map(value: false)
    )

    self.pledgeOverTimeIsLoading = Signal.merge(
      pledgeOverTimeUIEnabled,
      pledgeOverTimeQuery.values().map(value: false),
      pledgeOverTimeQuery.errors().map(value: false)
    )
    .skipRepeats()

    let pledgeOverTimeApiValues = pledgeOverTimeQuery
      .values()
      // Emit a default `nil` value to ensure the Signal pipeline remains active
      // and `combineLatest` in `pledgeOverTimeConfigData` emits a value even when errors occur.
      .demoteErrors(replaceErrorWith: nil)

    // Send an empty config when the view model is initialized
    let emptyConfigData: Signal<PledgePaymentPlansAndSelectionData?, Never> = self.showPledgeOverTimeUI
      .filter { $0 == false }
      .mapConst(nil)

    // Send a config once the query loads, defaulting to .pledgeInFull
    let configDataAfterQueryLoads: Signal<PledgePaymentPlansAndSelectionData?, Never> = Signal
      .combineLatest(project, pledgeOverTimeApiValues)
      .map { (
        project: Project,
        pledgeOverTimeApiValues: GraphAPI.BuildPaymentPlanQuery.Data?
      ) -> PledgePaymentPlansAndSelectionData? in

        // Wrap the value in `nil` to ensure the Signal emits consistently,
        // even when the API request fails or Pledge Over Time is disabled.
        guard let paymentPlan = pledgeOverTimeApiValues?.project?.paymentPlan else { return nil }

        let isPledgeOverTimePreSelected = project.personalization.backing?.paymentIncrements.isEmpty == false
        let isPledgeOverTimeEligible = paymentPlan.amountIsPledgeOverTimeEligible

        // Retain PLOT pre-selection only if the new pledge amount meets the eligibility threshold (amountIsPledgeOverTimeEligible)
        let defaultPlan = isPledgeOverTimePreSelected && isPledgeOverTimeEligible ?
          PledgePaymentPlansType.pledgeOverTime :
          PledgePaymentPlansType.pledgeInFull

        return PledgePaymentPlansAndSelectionData(
          withPaymentPlanFragment: paymentPlan,
          selectedPlan: defaultPlan,
          project: project
        )
      }

    // Send an updated config after changing the plan
    let configDataAfterChangingPlan: Signal<PledgePaymentPlansAndSelectionData?, Never> = Signal
      .combineLatest(configDataAfterQueryLoads.skipNil(), self.paymentPlanSelectedProperty.signal)
      .map { data, selectedPlan in
        PledgePaymentPlansAndSelectionData(
          selectedPlan: selectedPlan,
          increments: data.paymentIncrements,
          ineligible: data.ineligible,
          project: data.project
        )
      }

    self.pledgeOverTimeConfigData = Signal.merge(
      emptyConfigData,
      configDataAfterQueryLoads,
      configDataAfterChangingPlan
    )
    .skipRepeats { a, b in
      if a.isNil && b.isNil {
        return true
      }

      return false
    }
  }

  /// Visibility signal for the Pledge Over Time installment selector card.
  public let showPledgeOverTimeUI: Signal<Bool, Never>
  /// Payment plan configuration and selection snapshot stream.
  public let pledgeOverTimeConfigData: Signal<PledgePaymentPlansAndSelectionData?, Never>
  /// Loading indicator state while building installment options.
  public let pledgeOverTimeIsLoading: Signal<Bool, Never>
  /// Formatted `(slug, amount)` query inputs exposed for unit-test assertions.
  public let buildPaymentPlanInputs: Signal<(String, String), Never>

  /// Self-conformance to `PledgeOverTimeUseCaseOutputs`.
  public var outputs: PledgeOverTimeUseCaseOutputs { return self }
  /// Self-conformance to `PledgeOverTimeUseCaseInputs`.
  public var inputs: PledgeOverTimeUseCaseInputs { return self }

  // MARK: - Inputs

  private let paymentPlanSelectedProperty = MutableProperty<PledgePaymentPlansType>(.pledgeInFull)
  /// Selects `.pledgeInFull` or `.pledgeOverTime`.
  public func paymentPlanSelected(_ paymentPlan: PledgePaymentPlansType) {
    self.paymentPlanSelectedProperty.value = paymentPlan
  }

  // MARK: - Outputs
}
