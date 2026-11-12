import UIKit

/// `UIFont` extensions declared in `UIFont.swift`.
public extension UIFont {
  func baselineOffsetToSuperscript(of font: UIFont) -> NSNumber {
    guard font.capHeight > self.capHeight else { return NSNumber(value: 0) }

    return NSNumber(value: Float(font.capHeight - self.capHeight))
  }
}
