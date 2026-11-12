import Prelude

extension ShippingRule {
  /// Functional optics namespace for `ShippingRule`.
  public enum lens {
    /// Lens focusing on legacy floating-point shipping `cost`.
    public static let cost = Lens<ShippingRule, Double>(
      view: { $0.cost },
      set: { .init(
        cost: $0,
        id: $1.id,
        location: $1.location,
        estimatedMin: $1.estimatedMin,
        estimatedMax: $1.estimatedMax
      ) }
    )

    /// Lens focusing on optional shipping rule `id`.
    public static let id = Lens<ShippingRule, Int?>(
      view: { $0.id },
      set: { .init(
        cost: $1.cost,
        id: $0,
        location: $1.location,
        estimatedMin: $1.estimatedMin,
        estimatedMax: $1.estimatedMax
      ) }
    )

    /// Lens focusing on shipping rule destination `location`.
    public static let location = Lens<ShippingRule, Location>(
      view: { $0.location },
      set: { .init(
        cost: $1.cost,
        id: $1.id,
        location: $0,
        estimatedMin: $1.estimatedMin,
        estimatedMax: $1.estimatedMax
      ) }
    )

    /// Lens focusing on optional `estimatedMin` money bound.
    public static let estimatedMin = Lens<ShippingRule, Money?>(
      view: { $0.estimatedMin },
      set: { .init(
        cost: $1.cost,
        id: $1.id,
        location: $1.location,
        estimatedMin: $0,
        estimatedMax: $1.estimatedMax
      ) }
    )

    /// Lens focusing on optional `estimatedMax` money bound.
    public static let estimatedMax = Lens<ShippingRule, Money?>(
      view: { $0.estimatedMax },
      set: { .init(
        cost: $1.cost,
        id: $1.id,
        location: $1.location,
        estimatedMin: $1.estimatedMin,
        estimatedMax: $0
      ) }
    )
  }
}
