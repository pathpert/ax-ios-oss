import Foundation
import KsApi

/// Display-ready formatting model representing a single Pledge Over Time installment row.
/// - Negative Constraint: Use only for presentation; do not parse numbers back out of `amount` or `scheduledCollection`.
public struct PledgePaymentIncrementFormatted: Equatable {
  /// Localized installment ordinal header (e.g., `"Charge 1"`).
  public var incrementChargeNumber: String
  /// Currency-formatted charge amount in the project's native currency.
  public var amount: String
  /// Medium-style UTC formatted scheduled collection date string.
  public var scheduledCollection: String

  init(from increment: PledgePaymentIncrement, index: Int) {
    let chargeNumber = String(index + 1)
    self.incrementChargeNumber = Strings.Charge_number(number: chargeNumber)
    self.amount = increment.amount.amountFormattedInProjectNativeCurrency
    self.scheduledCollection = getDateFormatted(increment.scheduledCollection)
  }
}

private func getDateFormatted(_ timeStamp: TimeInterval) -> String {
  Format.date(
    secondsInUTC: timeStamp,
    dateStyle: .medium,
    timeStyle: .none
  )
}
