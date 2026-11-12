import ObjectiveC
import Prelude
import Prelude_UIKit
import UIKit

private func swizzle(_ vc: UIViewController.Type) {
  [
    (#selector(vc.viewDidLoad), #selector(vc.ksr_viewDidLoad)),
    (#selector(vc.viewWillAppear(_:)), #selector(vc.ksr_viewWillAppear(_:))),
    (#selector(vc.traitCollectionDidChange(_:)), #selector(vc.ksr_traitCollectionDidChange(_:)))
  ]
  .forEach { original, swizzled in

    guard let originalMethod = class_getInstanceMethod(vc, original),
          let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }

    let didAddViewDidLoadMethod = class_addMethod(
      vc,
      original,
      method_getImplementation(swizzledMethod),
      method_getTypeEncoding(swizzledMethod)
    )

    if didAddViewDidLoadMethod {
      class_replaceMethod(
        vc,
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

extension UIViewController {
  /// Swizzles `viewDidLoad`, `viewWillAppear`, and `traitCollectionDidChange` once per process for lifecycle hooks.
  public final class func doBadSwizzleStuff() {
    guard !hasSwizzled else { return }

    hasSwizzled = true
    swizzle(self)
  }

  @objc internal func ksr_viewDidLoad() {
    self.ksr_viewDidLoad()
    self.bindViewModel()
  }

  @objc internal func ksr_viewWillAppear(_ animated: Bool) {
    self.ksr_viewWillAppear(animated)

    if !self.hasViewAppeared {
      self.bindStyles()
      self.hasViewAppeared = true
    }
  }

  /// Entry point to bind all view model outputs. Called just before `viewDidLoad`.
  @objc open func bindViewModel() {}

  /// Entry point to bind all styles to UI elements. Called just after `viewDidLoad`.
  @objc open func bindStyles() {}

  /// Swizzled hook invoking `bindStyles()` when trait collections change.
  @objc public func ksr_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    self.ksr_traitCollectionDidChange(previousTraitCollection)
    self.bindStyles()
  }

  private struct AssociatedKeys {
    static var hasViewAppeared = "hasViewAppeared"
  }

  // Helper to figure out if the `viewWillAppear` has been called yet
  private var hasViewAppeared: Bool {
    get {
      return (objc_getAssociatedObject(self, &AssociatedKeys.hasViewAppeared) as? Bool) ?? false
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKeys.hasViewAppeared,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
}

extension UIViewController {
  /// Default nib resource name derived from the class name without module prefix.
  public static var defaultNib: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }

  /// Default storyboard identifier derived from the class name without module prefix.
  public static var storyboardIdentifier: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
}
