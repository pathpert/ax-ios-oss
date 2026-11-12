import Foundation

/// `Double` extensions declared in `Double+Currency.swift`.
extension Double {
  /// Adds `otherDouble` using `Decimal` precision to avoid binary floating-point rounding drift in currency totals.
  public func addingCurrency(_ otherDouble: Double) -> Double {
    let amountDecimal = Decimal(self)
    let otherDecimal = Decimal(otherDouble)

    let sum = NSDecimalNumber(decimal: amountDecimal + otherDecimal)

    return sum.doubleValue
  }

  /// Multiplies `self` by `otherDouble` using `Decimal` precision for currency calculations.
  public func multiplyingCurrency(_ otherDouble: Double) -> Double {
    let amountDecimal = Decimal(self)
    let otherDecimal = Decimal(otherDouble)

    let multiplied = NSDecimalNumber(decimal: amountDecimal * otherDecimal)

    return multiplied.doubleValue
  }

  /// Subtracts `otherDouble` from `self` using `Decimal` precision for currency calculations.
  public func subtractingCurrency(_ otherDouble: Double) -> Double {
    let amountDecimal = Decimal(self)
    let otherDecimal = Decimal(otherDouble)

    let subtraction = NSDecimalNumber(decimal: amountDecimal - otherDecimal)

    return subtraction.doubleValue
  }
}
