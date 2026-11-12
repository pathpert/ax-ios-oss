extension ShippingRule {
  /// Reusable US `$5` shipping rule fixture template for unit tests.
  /// - Negative Constraint: Do not use in production builds.
  public static let template = ShippingRule(
    cost: 5.0,
    id: 1,
    location: .template,
    estimatedMin: Money(amount: 5.0, currency: Money.CurrencyCode.usd),
    estimatedMax: Money(amount: 10.0, currency: Money.CurrencyCode.usd)
  )
}
