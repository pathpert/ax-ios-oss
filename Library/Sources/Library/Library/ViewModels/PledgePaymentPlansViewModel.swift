import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Available payment plan options during pledge checkout.
public enum PledgePaymentPlansType: Equatable {
  /// Pay the entire pledge amount once the campaign ends successfully.
  case pledgeInFull
  /// Split the pledge into eligible installment increments over time.
  case pledgeOverTime
}

/// Configuration and selection state for displaying pledge payment plan options.
public struct PledgePaymentPlansAndSelectionData {
  /// Whether the backer/pledge is ineligible for Pledge Over Time.
  public var ineligible: Bool
  /// Scheduled payment increments when Pledge Over Time applies.
  public var paymentIncrements: [PledgePaymentIncrement]
  /// The project being pledged to.
  public var project: Project
  /// Currently selected payment plan option.
  public var selectedPlan: PledgePaymentPlansType

  /// Initializes a `PledgePaymentPlansAndSelectionData` payload.
  public init(
    selectedPlan: PledgePaymentPlansType,
    increments paymentIncrements: [PledgePaymentIncrement] = [],
    ineligible: Bool = false,
    project: Project
  ) {
    self.ineligible = ineligible
    self.paymentIncrements = paymentIncrements
    self.project = project
    self.selectedPlan = selectedPlan
  }

  /// `true` when `.pledgeOverTime` is currently selected.
  public var isPledgeOverTime: Bool {
    self.selectedPlan == .pledgeOverTime
  }
}

/// Inputs accepted by `PledgePaymentPlansViewModel`.
public protocol PledgePaymentPlansViewModelInputs {
  /// Signals that the payment plans view has loaded.
  func viewDidLoad()
  /// Configures the view model with payment plan options and current selection.
  func configure(with value: PledgePaymentPlansAndSelectionData)
  /// Selects a payment plan option.
  func didSelectPlanType(_ planType: PledgePaymentPlansType)
  /// Handles tapping a Terms of Use link for the given `HelpType`.
  func didTapTermsOfUse(with helpType: HelpType)
}

/// Outputs exposed by `PledgePaymentPlansViewModel`.
public protocol PledgePaymentPlansViewModelOutputs {
  /// Emits when the selected payment plan changes so the delegate can update checkout state.
  var notifyDelegatePaymentPlanSelected: Signal<PledgePaymentPlansType, Never> { get }
  /// Emits when a Terms of Use link is tapped.
  var notifyDelegateTermsOfUseTapped: Signal<HelpType, Never> { get }
  /// Emits updated plan data to reload the UI.
  var reloadPaymentPlans: Signal<PledgePaymentPlansAndSelectionData, Never> { get }
  /// `true` when no payment plan data has been set. A single `isLoading` event is sent after `viewDidLoad()` is called; more events are sent whenever `configure(with:)` is called.
  var isLoading: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs interface for `PledgePaymentPlansViewModel`.
public protocol PledgePaymentPlansViewModelType {
  /// The view model's inputs.
  var inputs: PledgePaymentPlansViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgePaymentPlansViewModelOutputs { get }
}

/// View model managing selection between Pledge in Full and Pledge Over Time payment plans.
public final class PledgePaymentPlansViewModel: PledgePaymentPlansViewModelType,
  PledgePaymentPlansViewModelInputs,
  PledgePaymentPlansViewModelOutputs {
  /// Emits payment plan data when configuration or plan selection changes.
  public var reloadPaymentPlans: Signal<PledgePaymentPlansAndSelectionData, Never>
  /// Emits the newly selected `PledgePaymentPlansType` to the delegate.
  public var notifyDelegatePaymentPlanSelected: Signal<PledgePaymentPlansType, Never>
  /// Emits the `HelpType` for a tapped Terms of Use link.
  public var notifyDelegateTermsOfUseTapped: Signal<HelpType, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgePaymentPlansViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgePaymentPlansViewModelOutputs { return self }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the payment plans view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Creates a new `PledgePaymentPlansViewModel` and binds selection and loading signals.
  public init() {
    let configureWithValue = Signal.combineLatest(
      self.viewDidLoadProperty.signal,
      self.configureWithValueProperty.signal.skipNil()
    )
    .map(second)

    let isLoadingAfterConfigData = self.configureWithValueProperty.signal.map { data in
      data == nil
    }

    let isLoadingAfterViewDidLoad = self.viewDidLoadProperty.signal.mapConst(true)
      .take(until: isLoadingAfterConfigData.mapConst(()))

    self.isLoading = Signal.merge(
      isLoadingAfterViewDidLoad,
      isLoadingAfterConfigData
    )

    let planType = configureWithValue.map { $0.selectedPlan }

    let selectedPlanType = self.didSelectPlanTypeProperty.signal
      .skipNil()

    self.reloadPaymentPlans = Signal.merge(
      planType,
      selectedPlanType
    ).combineLatest(with: configureWithValue)
      .map { selectedPlan, data in
        PledgePaymentPlansAndSelectionData(
          selectedPlan: selectedPlan,
          increments: data.paymentIncrements,
          ineligible: data.ineligible,
          project: data.project
        )
      }

    self.notifyDelegatePaymentPlanSelected = selectedPlanType.signal.skipRepeats()

    self.notifyDelegateTermsOfUseTapped = self.didTermsOfUseTappedProperty.signal.skipNil()
  }

  private let configureWithValueProperty = MutableProperty<PledgePaymentPlansAndSelectionData?>(nil)
  /// Configures the view model with payment plan availability and selection state.
  public func configure(with value: PledgePaymentPlansAndSelectionData) {
    self.configureWithValueProperty.value = value
  }

  private let didSelectPlanTypeProperty = MutableProperty<PledgePaymentPlansType?>(nil)
  /// Updates the active payment plan option.
  public func didSelectPlanType(_ planType: PledgePaymentPlansType) {
    self.didSelectPlanTypeProperty.value = planType
  }

  private let didTermsOfUseTappedProperty = MutableProperty<HelpType?>(nil)
  /// Notifies the view model that a Terms of Use help link was tapped.
  public func didTapTermsOfUse(with helpType: HelpType) {
    self.didTermsOfUseTappedProperty.value = helpType
  }

  /// Emits whether payment plan data is still loading.
  public let isLoading: Signal<Bool, Never>
}
