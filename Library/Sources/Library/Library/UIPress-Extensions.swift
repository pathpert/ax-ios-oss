import UIKit

/// `UIPress.Phase` extensions declared in `UIPress-Extensions.swift`.
public extension UIPress.Phase {
  var isStartingPhase: Bool {
    return self == .began
  }

  var isTerminatingPhase: Bool {
    return self == .cancelled || self == .ended
  }
}
