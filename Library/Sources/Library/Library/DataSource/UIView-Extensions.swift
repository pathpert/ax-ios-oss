import UIKit

private func swizzle(_ v: UIView.Type) {
  [
    (#selector(v.traitCollectionDidChange(_:)), #selector(v.ksr_traitCollectionDidChange(_:))),
    (#selector(v.didMoveToSuperview), #selector(v.ksr_didMoveToSuperview))
  ]
  .forEach { original, swizzled in

    guard let originalMethod = class_getInstanceMethod(v, original),
          let swizzledMethod = class_getInstanceMethod(v, swizzled) else { return }

    let didAddViewDidLoadMethod = class_addMethod(
      v,
      original,
      method_getImplementation(swizzledMethod),
      method_getTypeEncoding(swizzledMethod)
    )

    if didAddViewDidLoadMethod {
      class_replaceMethod(
        v,
        swizzled,
        method_getImplementation(originalMethod),
        method_getTypeEncoding(originalMethod)
      )
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }
}

private var hasSwizzled = false

extension UIView {
  /// Swizzles `traitCollectionDidChange` and `didMoveToSuperview` once per process to automate `bindStyles()`.
  public final class func doBadSwizzleStuff() {
    guard !hasSwizzled else { return }

    hasSwizzled = true
    swizzle(self)
  }

  /// Calls `bindViewModel()` automatically when the view wakes from a nib.
  open override func awakeFromNib() {
    super.awakeFromNib()
    self.bindViewModel()
  }

  /// Override point for applying declarative `KDS`/Prelude styles to subviews.
  @objc open func bindStyles() {}

  /// Override point for wiring view-model inputs and outputs.
  @objc open func bindViewModel() {}

  /// Default cell/view reuse identifier derived from the class name without module prefix.
  public static var defaultReusableId: String {
    return self.description()
      .components(separatedBy: ".")
      .dropFirst()
      .joined(separator: ".")
  }

  @objc internal func ksr_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection) {
    self.ksr_traitCollectionDidChange(previousTraitCollection)
    self.bindStyles()
  }

  @objc internal func ksr_didMoveToSuperview() {
    self.ksr_didMoveToSuperview()
    self.bindStyles()
  }
}
