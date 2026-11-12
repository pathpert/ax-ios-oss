import Prelude

extension ShippingRulesEnvelope {
  /// Functional optics namespace for `ShippingRulesEnvelope`.
  public enum lens {
    /// Lens focusing on `shippingRules` array.
    public static let shippingRules = Lens<ShippingRulesEnvelope, [ShippingRule]>(
      view: { $0.shippingRules },
      set: { shippingRules, _ in .init(shippingRules: shippingRules) }
    )
  }
}
