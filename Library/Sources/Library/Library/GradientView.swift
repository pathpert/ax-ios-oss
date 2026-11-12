import Foundation
import UIKit

/// `UIView` subclass backed by `CAGradientLayer` for configurable vertical/linear color stops.
/// - Negative Constraint: Do not access `layer` as `CALayer`; mutate colors and stops through `gradientLayer` or `setGradient(_:)`.
public final class GradientView: UIView {
  /// Returns `CAGradientLayer.self` as the backing CoreAnimation layer class.
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }

  /// Strongly typed backing gradient layer.
  public var gradientLayer: CAGradientLayer? {
    return self.layer as? CAGradientLayer
  }

  /// Normalized starting coordinate (`0...1`) of the linear gradient.
  @IBInspectable
  public var startPoint: CGPoint {
    get {
      return self.gradientLayer?.startPoint ?? .zero
    }
    set {
      self.gradientLayer?.startPoint = newValue
    }
  }

  /// Normalized ending coordinate (`0...1`) of the linear gradient.
  @IBInspectable
  public var endPoint: CGPoint {
    get {
      return self.gradientLayer?.endPoint ?? .zero
    }
    set {
      self.gradientLayer?.endPoint = newValue
    }
  }

  /// Interface Builder configurable color at `startPoint`.
  @IBInspectable public var startColor: UIColor?
  /// Interface Builder configurable color at `endPoint`.
  @IBInspectable public var endColor: UIColor?

  /// Applies the two-stop gradient configured in Interface Builder after nib decoding.
  public override func awakeFromNib() {
    super.awakeFromNib()
    self.setGradient([(self.startColor, 0.0), (self.endColor, 1.0)])
  }

  /// Renders the configured two-stop gradient in Xcode Interface Builder previews.
  public override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    self.setGradient([(self.startColor, 0.0), (self.endColor, 1.0)])
  }

  /// Configures multi-stop gradient colors and normalized locations in `0.0...1.0`.
  public func setGradient(_ points: [(color: UIColor?, location: Float)]) {
    self.backgroundColor = .clear

    self.gradientLayer?.colors = points.map { point in
      point.color?.cgColor ?? UIColor.clear.cgColor
    }

    self.gradientLayer?.locations = points.map { point in
      NSNumber(value: point.location)
    }
  }
}
