import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Summary payload describing the selected shipping destination and formatted shipping cost.
public struct PledgeShippingSummaryViewData: Equatable {
  /// Localized display name of the selected shipping country or region.
  public let locationName: String
  /// Whether US dollar symbol omissions apply when formatting the cost.
  public let omitUSCurrencyCode: Bool
  /// ISO currency code for the shipping total.
  public let currencyCode: String
  /// Total shipping cost in the project's currency.
  public let total: Double
}

/// Inputs accepted by `PledgeShippingSummaryViewModel`.
public protocol PledgeShippingSummaryViewModelInputs {
  /// Configures the shipping summary view with `PledgeShippingSummaryViewData`.
  func configure(with data: PledgeShippingSummaryViewData)
}

/// Outputs emitted by `PledgeShippingSummaryViewModel`.
public protocol PledgeShippingSummaryViewModelOutputs {
  /// Emits an attributed currency string prefixed with `+` for the shipping cost.
  var amountLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits the formatted shipping destination name.
  var locationLabelText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `PledgeShippingSummaryViewModel`.
public protocol PledgeShippingSummaryViewModelType {
  /// Input receiver for shipping summary configuration.
  var inputs: PledgeShippingSummaryViewModelInputs { get }
  /// Output signals formatting destination and cost labels.
  var outputs: PledgeShippingSummaryViewModelOutputs { get }
}

/// View model formatting shipping destination and cost summary rows during checkout.
public class PledgeShippingSummaryViewModel: PledgeShippingSummaryViewModelType,
  PledgeShippingSummaryViewModelInputs, PledgeShippingSummaryViewModelOutputs {
  /// Initializes the pledge shipping summary view model.
  public init() {
    let configData = self.configureWithDataProperty.signal.skipNil()

    self.locationLabelText = configData.map(\.locationName)

    self.amountLabelAttributedText = configData.map {
      data in (data.currencyCode, data.omitUSCurrencyCode, data.total)
    }
    .map(attributedCurrency)
    .skipNil()
  }

  private let configureWithDataProperty = MutableProperty<PledgeShippingSummaryViewData?>(nil)
  /// Configures the view model with `PledgeShippingSummaryViewData`.
  public func configure(with data: PledgeShippingSummaryViewData) {
    self.configureWithDataProperty.value = data
  }

  /// Emits the attributed currency cost string.
  public let amountLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits the destination location name string.
  public let locationLabelText: Signal<String, Never>

  /// Returns `self` as `PledgeShippingSummaryViewModelInputs`.
  public var inputs: PledgeShippingSummaryViewModelInputs { return self }
  /// Returns `self` as `PledgeShippingSummaryViewModelOutputs`.
  public var outputs: PledgeShippingSummaryViewModelOutputs { return self }
}

private func attributedCurrency(
  with currencyCode: String,
  omitCurrencyCode: Bool,
  total: Double
) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
  let superscriptAttributes = checkoutCurrencySuperscriptAttributes()
  guard
    let attributedCurrency = Format.attributedCurrency(
      total,
      currencyCode: currencyCode,
      omitCurrencyCode: omitCurrencyCode,
      defaultAttributes: defaultAttributes,
      superscriptAttributes: superscriptAttributes
    ) else { return nil }

  let combinedAttributes = defaultAttributes.withAllValuesFrom(superscriptAttributes)

  return Format.attributedPlusSign(combinedAttributes) + attributedCurrency
}
