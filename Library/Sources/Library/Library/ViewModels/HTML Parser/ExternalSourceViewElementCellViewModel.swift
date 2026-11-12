import KsApi
import Prelude
import ReactiveSwift

/// Input contract for `ExternalSourceViewElementCellViewModel`.
public protocol ExternalSourceViewElementCellViewModelInputs {
  /// Call to configure with a `ExternalSourceViewElement` representing external source element.
  func configureWith(element: ExternalSourceViewElement)
}

/// Output contract for `ExternalSourceViewElementCellViewModel`.
public protocol ExternalSourceViewElementCellViewModelOutputs {
  /// Emits a text `String` representing the iframe tag's src attibute captured in the html parser.
  var htmlText: Signal<String, Never> { get }

  /// Emits an optional `Int` taken from iframe representing that embedded content's height in a webview.
  var contentHeight: Signal<Int, Never> { get }
}

/// Composite ViewModel protocol for embedded external iframe cells.
public protocol ExternalSourceViewElementCellViewModelType {
  /// Input receiver.
  var inputs: ExternalSourceViewElementCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: ExternalSourceViewElementCellViewModelOutputs { get }
}

/// ViewModel extracting embed URL and explicit iframe height for story webview cells.
public final class ExternalSourceViewElementCellViewModel:
  ExternalSourceViewElementCellViewModelType, ExternalSourceViewElementCellViewModelInputs,
  ExternalSourceViewElementCellViewModelOutputs {
  // MARK: Initializers

  /// Initializes embed URL and optional height signals.
  public init() {
    self.htmlText = self.externalSourceViewElement.signal.skipNil()
      .switchMap { element -> SignalProducer<String?, Never> in
        guard !element.embeddedURLString.isEmpty else {
          return SignalProducer(value: nil)
        }

        return SignalProducer(value: element.embeddedURLString)
      }
      .skipNil()

    self.contentHeight = self.externalSourceViewElement.signal.skipNil()
      .switchMap { element -> SignalProducer<Int?, Never> in
        guard let contentHeight = element.embeddedURLContentHeight,
              !element.embeddedURLString.isEmpty else {
          return SignalProducer(value: nil)
        }

        return SignalProducer(value: contentHeight)
      }
      .skipNil()
  }

  fileprivate let externalSourceViewElement =
    MutableProperty<ExternalSourceViewElement?>(nil)
  /// Binds an `ExternalSourceViewElement` parsed from campaign HTML.
  public func configureWith(element: ExternalSourceViewElement) {
    self.externalSourceViewElement.value = element
  }

  /// Emits explicit iframe height in points, when declared.
  public let contentHeight: Signal<Int, Never>
  /// Emits non-empty iframe `src` URL strings.
  public let htmlText: Signal<String, Never>

  /// Self-conformance to `ExternalSourceViewElementCellViewModelInputs`.
  public var inputs: ExternalSourceViewElementCellViewModelInputs { self }
  /// Self-conformance to `ExternalSourceViewElementCellViewModelOutputs`.
  public var outputs: ExternalSourceViewElementCellViewModelOutputs { self }
}
