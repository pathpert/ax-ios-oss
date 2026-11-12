import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Input data configuring the itemized pledge, bonus, and shipping summary rows.
public struct PledgeAmountSummaryViewData {
  /// Optional bonus amount above reward minimum, in project currency units.
  public let bonusAmount: Double?
  /// `true` when the bonus row should remain hidden.
  public let bonusAmountHidden: Bool
  /// `true` when backing without a reward tier.
  public let isNoReward: Bool
  /// Shipping destination display name, if applicable.
  public let locationName: String?
  /// `true` to suppress trailing `"US"` on USD currency labels.
  public let omitUSCurrencyCode: Bool
  /// ISO 4217 project currency code.
  public let currencyCode: String
  /// Unix timestamp (UTC seconds) when the pledge occurred.
  public let pledgedOn: TimeInterval
  /// Minimum amount for the selected reward tier.
  public let rewardMinimum: Double
  /// Shipping charge in project currency units, if any.
  public let shippingAmount: Double?
  /// `true` when the shipping amount row should remain hidden.
  public let shippingAmountHidden: Bool
  /// `true` when the reward uses local pickup instead of shipping.
  public let rewardIsLocalPickup: Bool
}

/// Inputs accepted by `PledgeAmountSummaryViewModel`.
public protocol PledgeAmountSummaryViewModelInputs {
  /// Configures the amount summary with view data.
  func configureWith(_ data: PledgeAmountSummaryViewData)
  /// Notifies the view model that the summary view has loaded.
  func viewDidLoad()
}

/// Reactive outputs emitted by `PledgeAmountSummaryViewModel`.
public protocol PledgeAmountSummaryViewModelOutputs {
  /// Emits formatted `+<bonus>` attributed text.
  var bonusAmountText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the bonus row container should be hidden.
  var bonusAmountStackViewIsHidden: Signal<Bool, Never> { get }
  /// Emits formatted attributed base pledge amount text.
  var pledgeAmountText: Signal<NSAttributedString, Never> { get }
  /// Emits formatted `+<shipping>` attributed text.
  var shippingAmountText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the shipping location row should be hidden.
  var shippingLocationStackViewIsHidden: Signal<Bool, Never> { get }
  /// Emits localized `"Shipping to <location>"` label text.
  var shippingLocationText: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for the pledge amount summary section.
public protocol PledgeAmountSummaryViewModelType {
  /// Input receiver.
  var inputs: PledgeAmountSummaryViewModelInputs { get }
  /// Output signal provider.
  var outputs: PledgeAmountSummaryViewModelOutputs { get }
}

/// View model formatting itemized reward minimum, bonus support, and shipping amounts.
public class PledgeAmountSummaryViewModel: PledgeAmountSummaryViewModelType,
  PledgeAmountSummaryViewModelInputs, PledgeAmountSummaryViewModelOutputs {
  /// Creates a new `PledgeAmountSummaryViewModel`.
  public init() {
    let data = Signal.combineLatest(
      self.configureWithDataSignal,
      self.viewDidLoadProperty.signal
    )
    .map(first)

    self.pledgeAmountText = data
      .map {
        (
          $0.currencyCode,
          $0.isNoReward ? ($0.bonusAmount ?? 0) : $0.rewardMinimum,
          $0.omitUSCurrencyCode
        )
      }
      .map(attributedCurrency)
      .skipNil()

    self.bonusAmountText = data
      .map { data in (data.currencyCode, data.bonusAmount ?? 0, data.omitUSCurrencyCode) }
      .map(plusSignAmount)
      .skipNil()

    self.shippingAmountText = data
      .map { ($0.currencyCode, $0.shippingAmount ?? 0, $0.omitUSCurrencyCode) }
      .map(plusSignAmount)
      .skipNil()

    self.shippingLocationText = data.map { $0.locationName }
      .skipNil()
      .map { Strings.Shipping_to_country(country: $0) }

    self.bonusAmountStackViewIsHidden = data.map { $0.isNoReward || $0.bonusAmountHidden }
    self.shippingLocationStackViewIsHidden = data.map {
      let nonLocalPickupShippingLocationStackViewIsHiddenConditions = (
        $0.locationName == nil || $0
          .shippingAmountHidden
      )

      return $0.rewardIsLocalPickup ? true : nonLocalPickupShippingLocationStackViewIsHiddenConditions
    }
  }

  private let (configureWithDataSignal, configureWithDataObserver)
    = Signal<PledgeAmountSummaryViewData, Never>.pipe()
  /// Supplies itemized amount data for formatting.
  public func configureWith(_ data: PledgeAmountSummaryViewData) {
    self.configureWithDataObserver.send(value: data)
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the summary view finished loading.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits formatted `+<bonus>` attributed text.
  public let bonusAmountText: Signal<NSAttributedString, Never>
  /// Emits whether the bonus row container should be hidden.
  public let bonusAmountStackViewIsHidden: Signal<Bool, Never>
  /// Emits formatted attributed base pledge amount text.
  public let pledgeAmountText: Signal<NSAttributedString, Never>
  /// Emits formatted `+<shipping>` attributed text.
  public let shippingAmountText: Signal<NSAttributedString, Never>
  /// Emits whether the shipping location row should be hidden.
  public let shippingLocationStackViewIsHidden: Signal<Bool, Never>
  /// Emits localized `"Shipping to <location>"` label text.
  public let shippingLocationText: Signal<String, Never>

  /// Inputs receiver (`self`).
  public var inputs: PledgeAmountSummaryViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: PledgeAmountSummaryViewModelOutputs { return self }
}

private func formattedPledgeDate(_ backing: Backing) -> String {
  let formattedDate = Format.date(secondsInUTC: backing.pledgedAt, dateStyle: .long, timeStyle: .none)
  return Strings.As_of_pledge_date(pledge_date: formattedDate)
}

private func attributedCurrency(
  with currencyCode: String,
  amount: Double,
  omitUSCurrencyCode: Bool
) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
  let superscriptAttributes = checkoutCurrencySuperscriptAttributes()
  guard
    let attributedCurrency = Format.attributedCurrency(
      amount,
      currencyCode: currencyCode,
      omitCurrencyCode: omitUSCurrencyCode,
      defaultAttributes: defaultAttributes,
      superscriptAttributes: superscriptAttributes
    ) else { return nil }

  return attributedCurrency
}

private func plusSignAmount(
  with currencyCode: String,
  amount: Double,
  omitUSCurrencyCode: Bool
) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
  let superscriptAttributes = checkoutCurrencySuperscriptAttributes()
  guard
    let attributedCurrency = Format.attributedCurrency(
      amount,
      currencyCode: currencyCode,
      omitCurrencyCode: omitUSCurrencyCode,
      defaultAttributes: defaultAttributes,
      superscriptAttributes: superscriptAttributes
    ) else { return nil }

  let combinedAttributes = defaultAttributes.withAllValuesFrom(superscriptAttributes)

  return Format.attributedPlusSign(combinedAttributes) + attributedCurrency
}
