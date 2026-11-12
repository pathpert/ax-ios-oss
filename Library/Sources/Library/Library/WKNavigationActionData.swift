import WebKit

/// Testable value wrapper around WebKit's `WKNavigationAction` for view-model navigation decisions.
///
/// Negative Constraint: Do not pass dummy `WKNavigationAction()` instances to live `WKWebView` policy handlers.
public struct WKNavigationActionData {
  /// Original WebKit navigation action (or synthetic placeholder in tests).
  public let navigationAction: WKNavigationAction
  /// Navigation trigger classification (link activated, form submitted, etc.).
  public let navigationType: WKNavigationType
  /// HTTP/URL request associated with the navigation action.
  public let request: URLRequest
  /// Target frame metadata, or `nil` when opening a new window.
  public let targetFrame: WKFrameInfoData?

  /// Wraps a live `WKNavigationAction` from `WKNavigationDelegate`.
  public init(navigationAction: WKNavigationAction) {
    self.navigationAction = navigationAction
    self.navigationType = navigationAction.navigationType
    self.request = navigationAction.request
    self.targetFrame = navigationAction.targetFrame.map(WKFrameInfoData.init(frameInfo:))
  }

  internal init(
    navigationType: WKNavigationType,
    request: URLRequest,
    sourceFrame _: WKFrameInfoData,
    targetFrame: WKFrameInfoData?
  ) {
    self.navigationAction = WKNavigationAction()
    self.navigationType = navigationType
    self.request = request
    self.targetFrame = targetFrame
  }
}

/// Testable value wrapper around `WKFrameInfo`.
public struct WKFrameInfoData {
  /// Underlying WebKit frame object.
  public let frameInfo: WKFrameInfo
  /// Whether the target frame is the top-level main document frame.
  public let mainFrame: Bool

  /// Wraps a live `WKFrameInfo`.
  public init(frameInfo: WKFrameInfo) {
    self.frameInfo = frameInfo
    self.mainFrame = frameInfo.isMainFrame
  }

  /// Creates synthetic frame metadata for unit tests.
  public init(mainFrame: Bool, request _: URLRequest) {
    self.frameInfo = WKFrameInfo()
    self.mainFrame = mainFrame
  }
}
