import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

private enum Constants {
  /// Date format string for expected reward delivery (`"MMMM d, yyyy"`).
  public static let dateFormat = "MMMM d, yyyy"
}

/// View model formatting total pledge amounts, currency conversion copy, and PLOT disclosures.
public class PledgeSummaryViewModel: PledgeSummaryViewModelType,
  PledgeSummaryViewModelInputs, PledgeSummaryViewModelOutputs {
  /// Creates a new `PledgeSummaryViewModel` and binds pledge formatting streams.
  public init() {
    let initialData = Signal.combineLatest(
      self.configureWithDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let projectAndPledgeTotal = initialData
      .map { ($0.project, $0.total) }

    let pledgeHasNoReward = initialData
      .map(\.pledgeHasNoReward)

    let pledgeOverTimeData = Signal.combineLatest(
      self.pledgeOverTimeDataProperty.signal,
      self.viewDidLoadProperty.signal
    )
    .map(first)

    self.amountLabelAttributedText = projectAndPledgeTotal
      .map(attributedCurrency(with:total:))
      .skipNil()

    self.totalConversionLabelText = projectAndPledgeTotal
      .filter { project, _ in project.stats.needsConversion }
      .map { project, total in
        let convertedTotal = total * Double(project.stats.userCurrencyRate ?? project.stats.staticUsdRate)
        let userCurrency = project.stats.userCurrency ?? Project.Country.us.currencyCode

        return Format.currency(
          convertedTotal,
          currencyCode: userCurrency,
          omitCurrencyCode: project.stats.omitUSCurrencyCode,
          roundingMode: .halfUp,
          maximumFractionDigits: 2,
          minimumFractionDigits: 2
        )
      }
      .map { Strings.About_reward_amount(reward_amount: $0) }

    self.notifyDelegateOpenHelpType = self.tappedUrlSignal.map { url -> HelpType? in
      let helpType = HelpType.allCases.filter { helpType in
        url.absoluteString == helpType.url(
          withBaseUrl: AppEnvironment.current.apiService.serverConfig.webBaseUrl
        )?.absoluteString
      }
      .first

      return helpType
    }
    .skipNil()

    self.titleLabelText = pledgeHasNoReward
      .map { hasNoRewards in
        hasNoRewards == true
          ? Strings.Pledge_without_a_reward()
          : Strings.Pledge_amount()
      }

    self.confirmationLabelAttributedText = Signal.combineLatest(initialData, pledgeOverTimeData)
      .map { data, pledgeOverTimeData in
        attributedConfirmationString(with: data, pledgeOverTimeData: pledgeOverTimeData)
      }

    let project = initialData.map(\.project)

    self.confirmationLabelHidden = Signal.combineLatest(initialData, project)
      .map { initialData, project in
        guard project.isInPostCampaignPledgingPhase else {
          return initialData.confirmationLabelHidden
        }

        return true
      }

    self.pledgeOverTimeStackViewHidden = pledgeOverTimeData.map { $0?.isPledgeOverTime ?? false }.negate()

    self.pledgeOverTimeChargesText = pledgeOverTimeData.skipNil()
      .compactMap {
        $0.project.pledgeOverTimeCollectionPlanChargedAsNPayments
      }
  }

  private let configureWithDataProperty = MutableProperty<PledgeSummaryViewData?>(nil)
  /// Configures the summary view with project and pledge total values.
  public func configure(with data: PledgeSummaryViewData) {
    self.configureWithDataProperty.value = data
  }

  private let pledgeOverTimeDataProperty = MutableProperty<PledgePaymentPlansAndSelectionData?>(nil)
  /// Supplies Pledge Over Time selection and payment increment data.
  public func configureWith(pledgeOverTimeData: PledgePaymentPlansAndSelectionData?) {
    self.pledgeOverTimeDataProperty.value = pledgeOverTimeData
  }

  private let (tappedUrlSignal, tappedUrlObserver) = Signal<URL, Never>.pipe()
  /// Handles tapping an informational link URL inside the confirmation text.
  public func tapped(_ url: URL) {
    self.tappedUrlObserver.send(value: url)
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the pledge summary view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits the formatted pledge total amount.
  public let amountLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits the confirmation disclosure attributed copy.
  public let confirmationLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits whether the confirmation disclosure label is hidden.
  public let confirmationLabelHidden: Signal<Bool, Never>
  /// Emits the resolved `HelpType` for a tapped help link.
  public let notifyDelegateOpenHelpType: Signal<HelpType, Never>
  /// Emits whether the Pledge Over Time summary stack is hidden.
  public let pledgeOverTimeStackViewHidden: Signal<Bool, Never>
  /// Emits the formatted Pledge Over Time installment description.
  public let pledgeOverTimeChargesText: Signal<String, Never>
  /// Emits the converted currency string when project currency differs from user currency.
  public let totalConversionLabelText: Signal<String, Never>
  /// Emits the localized summary row title.
  public let titleLabelText: Signal<String, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgeSummaryViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgeSummaryViewModelOutputs { return self }
}

private func attributedCurrency(with project: Project, total: Double) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
    .withAllValuesFrom([.foregroundColor: LegacyColors.ksr_support_700.uiColor()])

  return Format.attributedCurrency(
    total,
    currencyCode: project.statsCurrency,
    omitCurrencyCode: project.stats.omitUSCurrencyCode,
    defaultAttributes: defaultAttributes,
    superscriptAttributes: checkoutCurrencySuperscriptAttributes()
  )
}

private func attributedConfirmationString(with project: Project, pledgeTotal: Double) -> NSAttributedString {
  var date = ""

  if let deadline = project.dates.deadline {
    date = Format.date(secondsInUTC: deadline, template: Constants.dateFormat)
  }

  let pledgeTotal = Format.currency(pledgeTotal, currencyCode: project.statsCurrency)

  let font = UIFont.ksr_caption1()
  let foregroundColor = LegacyColors.ksr_support_400.uiColor()

  return Strings
    .If_the_project_reaches_its_funding_goal_you_will_be_charged_total_on_project_deadline_and_receive_proof_of_pledge(
      total: pledgeTotal,
      project_deadline: date
    )
    .attributed(
      with: font, foregroundColor: foregroundColor, attributes: [:], bolding: [pledgeTotal, date]
    )
}

private func attributedConfirmationPledgeOverTimeString(
  with project: Project,
  increments: [PledgePaymentIncrement]
) -> NSAttributedString {
  guard let firstIncrement = increments.first else { return NSAttributedString() }

  let date = Format.date(secondsInUTC: firstIncrement.scheduledCollection, template: Constants.dateFormat)

  let projectCurrencyCountry = projectCountry(forCurrency: project.statsCurrency) ?? project.country
  let chargeAmount = firstIncrement.amount.amountFormattedInProjectNativeCurrency

  let font = UIFont.ksr_caption1()
  let foregroundColor = LegacyColors.ksr_support_400.uiColor()

  return Strings
    .If_the_project_reaches_its_funding_goal_the_first_charge_will_be_collected_on_project_deadline(
      amount: chargeAmount,
      project_deadline: date
    )
    .attributed(
      with: font, foregroundColor: foregroundColor, attributes: [:], bolding: [chargeAmount, date]
    )
}

private func attributedConfirmationString(
  with data: PledgeSummaryViewData,
  pledgeOverTimeData: PledgePaymentPlansAndSelectionData?
) -> NSAttributedString {
  if let plotData = pledgeOverTimeData, plotData.isPledgeOverTime {
    return attributedConfirmationPledgeOverTimeString(
      with: data.project,
      increments: plotData.paymentIncrements
    )
  }

  return attributedConfirmationString(with: data.project, pledgeTotal: data.total)
}
