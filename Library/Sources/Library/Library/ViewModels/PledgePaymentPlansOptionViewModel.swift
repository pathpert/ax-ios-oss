import Foundation
import KsApi
import ReactiveSwift

/// Configuration model for an individual pledge payment plan option row (`Pledge In Full` vs `Pledge Over Time`).
public struct PledgePaymentPlanOptionData: Equatable {
  /// `true` when the option is unavailable for the current pledge amount or project eligibility.
  public var ineligible: Bool = false
  /// Payment plan option represented by this row.
  public var type: PledgePaymentPlansType
  /// Currently selected payment plan across the group.
  public var selectedType: PledgePaymentPlansType
  // TODO: replece with API model in [MBL-1838](https://kickstarter.atlassian.net/browse/MBL-1838)
  /// Scheduled installment increments displayed when Pledge Over Time is expanded.
  public var paymentIncrements: [PledgePaymentIncrement]
  /// Associated project providing Plot copy and eligibility explanations.
  public var project: Project

  /// Creates a `PledgePaymentPlanOptionData` payload.
  public init(
    ineligible: Bool,
    type: PledgePaymentPlansType,
    selectedType: PledgePaymentPlansType,
    paymentIncrements: [PledgePaymentIncrement],
    project: Project
  ) {
    self.ineligible = ineligible
    self.type = type
    self.selectedType = selectedType
    self.paymentIncrements = paymentIncrements
    self.project = project
  }
}

/// Asset catalog image names for radio selection indicators on payment plan rows.
public enum SelectionIndicatorImageName: String {
  case selected = "icon-payment-method-selected"
  case unselected = "icon-payment-method-unselected"
}

/// Inputs accepted by `PledgePaymentPlansOptionViewModel`.
public protocol PledgePaymentPlansOptionViewModelInputs {
  /// Supplies initial configuration data for the payment plan row.
  func configureWith(data: PledgePaymentPlanOptionData)
  /// Notifies that the user tapped this payment plan row.
  func optionTapped()
  /// Notifies that the user tapped the terms-of-use link in the plan details.
  func termsOfUseTapped()
  /// Updates which payment plan is currently selected across the sibling group.
  func refreshSelectedType(_ selectedType: PledgePaymentPlansType)
}

/// Reactive outputs emitted by `PledgePaymentPlansOptionViewModel`.
public protocol PledgePaymentPlansOptionViewModelOutputs {
  /// Emits localized option title text.
  var titleText: Signal<String, Never> { get }
  /// Emits localized option subtitle or installment pitch copy.
  var subtitleText: Signal<String, Never> { get }
  /// Emits whether the subtitle label should be hidden.
  var subtitleLabelHidden: Signal<Bool, Never> { get }
  /// Emits selection radio icon asset name.
  var selectionIndicatorImageName: Signal<String, Never> { get }
  /// Emits whether the ineligibility badge should be hidden.
  var ineligibleBadgeHidden: Signal<Bool, Never> { get }
  /// Emits localized explanation text when an option is ineligible.
  var ineligibleBadgeText: Signal<String, Never> { get }
  /// Emits when the user selects this plan option.
  var notifyDelegatePaymentPlanOptionSelected: Signal<PledgePaymentPlansType, Never> { get }
  /// Emits `HelpType` when the user taps the terms-of-use link.
  var notifyDelegateTermsOfUseTapped: Signal<HelpType, Never> { get }
  /// Emits whether the option row is interactive.
  var optionViewEnabled: Signal<Bool, Never> { get }
  /// Emits formatted Plot installment rows when Pledge Over Time is active.
  var paymentIncrements: Signal<[PledgePaymentIncrementFormatted], Never> { get }
  /// Emits whether the Pledge Over Time installment schedule container is hidden.
  var plotSelectedStackViewHidden: Signal<Bool, Never> { get }
}

/// Combined inputs/outputs contract for a pledge payment plan row.
public protocol PledgePaymentPlansOptionViewModelType {
  /// Input receiver.
  var inputs: PledgePaymentPlansOptionViewModelInputs { get }
  /// Output signal provider.
  var outputs: PledgePaymentPlansOptionViewModelOutputs { get }
}

/// View model managing presentation, selection state, and installment formatting for a payment plan option.
public final class PledgePaymentPlansOptionViewModel:
  PledgePaymentPlansOptionViewModelType,
  PledgePaymentPlansOptionViewModelInputs,
  PledgePaymentPlansOptionViewModelOutputs {
  /// Creates a new `PledgePaymentPlansOptionViewModel`.
  public init() {
    let configData = self.configData.signal.skipNil()

    let ineligible: Signal<Bool, Never> = configData.map { $0.type == .pledgeOverTime && $0.ineligible }

    self.selectionIndicatorImageName = configData
      .map {
        $0.selectedType == $0.type ?
          SelectionIndicatorImageName.selected.rawValue : SelectionIndicatorImageName.unselected.rawValue
      }

    self.titleText = configData.map { getTitleText(by: $0.type) }
    self.subtitleText = configData
      .map { getSubtitleText(by: $0.type, isSelected: $0.selectedType == $0.type, project: $0.project) }
    self.subtitleLabelHidden = self.subtitleText
      .combineLatest(with: ineligible)
      .map { subtitle, ineligible in
        ineligible || subtitle.isEmpty
      }

    self.notifyDelegatePaymentPlanOptionSelected = self.optionTappedProperty
      .signal
      .withLatest(from: configData)
      .map { $1.type }

    let isPledgeOverTimeAndSelected: Signal<Bool, Never> = configData.map {
      $0.type == .pledgeOverTime && $0.type == $0.selectedType
    }

    self.plotSelectedStackViewHidden = isPledgeOverTimeAndSelected.negate()

    self.paymentIncrements = configData
      .filter { !$0.ineligible && $0.type == .pledgeOverTime && $0.selectedType == $0.type }
      .map { data in
        data.paymentIncrements
          .enumerated()
          .map { index, increment in
            PledgePaymentIncrementFormatted(from: increment, index: index)
          }
      }
      .filter { !$0.isEmpty }
      .take(first: 1)

    self.ineligibleBadgeHidden = ineligible.negate()

    self.optionViewEnabled = self.ineligibleBadgeHidden

    self.notifyDelegateTermsOfUseTapped = self.termsOfUseTappedProperty.signal.skipNil()

    self.ineligibleBadgeText = configData
      .filterWhenLatestFrom(ineligible, satisfies: { $0 == true })
      .compactMap { $0.project.pledgeOverTimeMinimumExplanation }
  }

  fileprivate let configData = MutableProperty<PledgePaymentPlanOptionData?>(nil)
  /// Configures the option row with initial `PledgePaymentPlanOptionData`.
  public func configureWith(data: PledgePaymentPlanOptionData) {
    self.configData.value = data
  }

  /// Updates the active selection across the payment plan radio group.
  public func refreshSelectedType(_ selectedType: PledgePaymentPlansType) {
    self.configData.value?.selectedType = selectedType
  }

  private let optionTappedProperty = MutableProperty<Void>(())
  /// Handles user tap on this option row.
  public func optionTapped() {
    self.optionTappedProperty.value = ()
  }

  private let termsOfUseTappedProperty = MutableProperty<HelpType?>(nil)
  /// Handles user tap on the terms-of-use link.
  public func termsOfUseTapped() {
    self.termsOfUseTappedProperty.value = .terms
  }

  /// Emits selection radio icon asset name.
  public let selectionIndicatorImageName: Signal<String, Never>
  /// Emits localized option title text.
  public var titleText: ReactiveSwift.Signal<String, Never>
  /// Emits localized option subtitle or installment pitch copy.
  public var subtitleText: ReactiveSwift.Signal<String, Never>
  /// Emits whether the subtitle label should be hidden.
  public var subtitleLabelHidden: Signal<Bool, Never>
  /// Emits whether the ineligibility badge should be hidden.
  public var ineligibleBadgeHidden: Signal<Bool, Never>
  /// Emits localized explanation text when an option is ineligible.
  public var ineligibleBadgeText: Signal<String, Never>
  /// Emits when the user selects this plan option.
  public var notifyDelegatePaymentPlanOptionSelected: Signal<PledgePaymentPlansType, Never>
  /// Emits `HelpType` when the user taps the terms-of-use link.
  public var notifyDelegateTermsOfUseTapped: Signal<HelpType, Never>
  /// Emits whether the option row is interactive.
  public var optionViewEnabled: Signal<Bool, Never>
  /// Emits formatted Plot installment rows when Pledge Over Time is active.
  public var paymentIncrements: Signal<[PledgePaymentIncrementFormatted], Never>
  /// Emits whether the Pledge Over Time installment schedule container is hidden.
  public var plotSelectedStackViewHidden: Signal<Bool, Never>

  /// Inputs receiver (`self`).
  public var inputs: PledgePaymentPlansOptionViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: PledgePaymentPlansOptionViewModelOutputs { return self }
}

private func getTitleText(by type: PledgePaymentPlansType) -> String {
  switch type {
  case .pledgeInFull: Strings.Pledge_in_full()
  case .pledgeOverTime: Strings.Pledge_Over_Time()
  }
}

private func getSubtitleText(by type: PledgePaymentPlansType, isSelected: Bool, project: Project) -> String {
  switch type {
  case .pledgeInFull:
    return ""
  case .pledgeOverTime:
    return makePledgeOverTimeSubtitle(isSelected: isSelected, project: project)
  }
}

private func makePledgeOverTimeSubtitle(isSelected: Bool, project: Project) -> String {
  guard let subtitle = project.pledgeOverTimeCollectionPlanShortPitch else {
    return ""
  }

  guard isSelected, let chargeExplanation = project.pledgeOverTimeCollectionPlanChargeExplanation else {
    return subtitle
  }

  return """
  \(subtitle)

  \(chargeExplanation)
  """
}
