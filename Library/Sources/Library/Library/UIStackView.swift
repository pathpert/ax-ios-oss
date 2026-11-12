import KDS
import UIKit.UIStackView

/// Helper definitions for `stackViewBackgroundViewTag` in `UIStackView.swift`.
private let stackViewBackgroundViewTag: Int = 1

/// Appends an array of arranged subviews onto a `UIStackView`.
public func ksr_addArrangedSubviewsToStackView() -> (([UIView], UIStackView) -> UIStackView) {
  return { subviews, stackView in
    subviews.forEach(stackView.addArrangedSubview)

    return stackView
  }
}

/// Applies custom spacing after `view` in a `UIStackView`.
public func ksr_setCustomSpacing(_ spacing: CGFloat) -> ((UIView, UIStackView) -> UIStackView) {
  return { view, stackView in
    stackView.setCustomSpacing(spacing, after: view)

    return stackView
  }
}

/// Inserts or updates a background subview behind a `UIStackView`'s arranged content with `color`.
public func ksr_setBackgroundColor(_ color: UIColor) -> ((UIStackView) -> (UIStackView)) {
  return { stackView in
    if let firstSubview = stackView.subviews.first, firstSubview.tag == stackViewBackgroundViewTag {
      firstSubview.backgroundColor = color

      return stackView
    }

    let backgroundView = UIView(frame: stackView.bounds)
    backgroundView.tag = stackViewBackgroundViewTag
    backgroundView.backgroundColor = color
    backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    stackView.insertSubview(backgroundView, at: 0)

    return stackView
  }
}
