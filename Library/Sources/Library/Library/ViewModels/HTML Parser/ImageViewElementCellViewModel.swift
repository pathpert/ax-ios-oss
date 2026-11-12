import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input contract for `ImageViewElementCellViewModel`.
public protocol ImageViewElementCellViewModelInputs {
  /// Call to configure with a `ImageViewElement`  representing raw HTML along with an optional displayable image
  func configureWith(imageElement: ImageViewElement, image: UIImage?)
}

/// Output contract for `ImageViewElementCellViewModel`.
public protocol ImageViewElementCellViewModelOutputs {
  /// Emits optional attributed text containing content of image caption after styling has been applied.
  var attributedText: Signal<NSAttributedString?, Never> { get }

  /// Emits an optional image for image view
  var image: Signal<UIImage?, Never> { get }
}

/// Composite ViewModel protocol for campaign HTML image cells.
public protocol ImageViewElementCellViewModelType {
  /// Input receiver.
  var inputs: ImageViewElementCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: ImageViewElementCellViewModelOutputs { get }
}

/// ViewModel formatting campaign story images and clickable image captions.
public final class ImageViewElementCellViewModel:
  ImageViewElementCellViewModelType, ImageViewElementCellViewModelInputs,
  ImageViewElementCellViewModelOutputs {
  // MARK: Helpers

  /// Initializes caption formatting and image passthrough signals.
  public init() {
    self.attributedText = self.imageData.signal
      .skipNil()
      .switchMap { imageElement, _ -> SignalProducer<NSAttributedString?, Never> in
        attributedTextFrom(imageElement)
      }

    self.image = self.imageData.signal
      .skipNil()
      .switchMap { _, image -> SignalProducer<UIImage?, Never> in
        guard let displayableImage = image else {
          return SignalProducer(value: nil)
        }

        return SignalProducer(value: displayableImage)
      }
  }

  fileprivate let imageData = MutableProperty<(ImageViewElement, UIImage?)?>(nil)
  /// Binds a parsed `ImageViewElement` and optional decoded `UIImage`.
  public func configureWith(imageElement: ImageViewElement, image: UIImage?) {
    self.imageData.value = (imageElement, image)
  }

  /// Styled caption/link attributed text stream.
  public let attributedText: Signal<NSAttributedString?, Never>
  /// Displayable image stream.
  public let image: Signal<UIImage?, Never>

  /// Self-conformance to `ImageViewElementCellViewModelInputs`.
  public var inputs: ImageViewElementCellViewModelInputs { self }
  /// Self-conformance to `ImageViewElementCellViewModelOutputs`.
  public var outputs: ImageViewElementCellViewModelOutputs { self }
}

private func attributedTextFrom(_ imageElement: ImageViewElement)
  -> SignalProducer<NSAttributedString?, Never> {
  guard let captionText = imageElement.caption, !captionText.isEmpty else {
    return SignalProducer(value: nil)
  }

  let completedAttributedText = NSMutableAttributedString()
  let paragraphStyle = NSMutableParagraphStyle()
  let currentAttributedText = NSMutableAttributedString(string: captionText)
  let fullRange = (captionText as NSString).localizedStandardRange(of: captionText)
  let baseFontSize: CGFloat = 12.0
  let baseFont = UIFont.ksr_body(size: baseFontSize).italicized
  paragraphStyle.minimumLineHeight = 22
  let baseFontAttributes = [
    NSAttributedString.Key.font: baseFont,
    NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_400.uiColor(),
    NSAttributedString.Key.paragraphStyle: paragraphStyle
  ]

  var combinedAttributes: [NSAttributedString.Key: Any] = baseFontAttributes

  if let validURLString = imageElement.href,
     let validURL = URL(string: validURLString) {
    combinedAttributes[NSAttributedString.Key.foregroundColor] = LegacyColors.ksr_create_700.uiColor()
    combinedAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
    combinedAttributes[NSAttributedString.Key.link] = validURL
  }

  currentAttributedText.addAttributes(combinedAttributes, range: fullRange)
  completedAttributedText.append(currentAttributedText)

  return SignalProducer(value: completedAttributedText)
}
