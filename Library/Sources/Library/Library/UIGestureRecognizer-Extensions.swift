import UIKit

/// `UIGestureRecognizer.State` extensions declared in `UIGestureRecognizer-Extensions.swift`.
public extension UIGestureRecognizer.State {
  var isStartingState: Bool {
    return self == .began
  }

  var isTerminatingState: Bool {
    return self == .cancelled || self == .ended || self == .failed
  }
}
