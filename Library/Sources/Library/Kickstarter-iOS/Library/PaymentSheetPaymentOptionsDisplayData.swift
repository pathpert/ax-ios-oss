import UIKit

/// Immutable value type representing `PaymentSheetPaymentOptionsDisplayData`.
public struct PaymentSheetPaymentOptionsDisplayData {
  let image: UIImage
  let label: String

  /// Creates display data from a payment method icon image and localized label.
  public init(image: UIImage, label: String) {
    self.image = image
    self.label = label
  }
}
