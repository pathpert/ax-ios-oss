import Foundation

/// Serializes attribution event payloads for server-side campaign attribution tracking.
struct AttributionTracking {
  /// Supported attribution event names.
  public enum AttributionEvent: String {
    /// Fired when a user opens a project page from an attribution link.
    case projectPageViewed = "Project Page Viewed"
  }

  static func eventParametersString(refInfo: RefInfo?) -> String? {
    let sessionRefTag = refInfo?.refTag?.stringTag
    let contextPageUrl = refInfo?.deeplinkUrl
    var props = [String: String]()
    if let sessionRefTag {
      props["session_ref_tag"] = sessionRefTag
    }
    props["context_page_url"] = contextPageUrl ?? ""

    guard let propsData = try? JSONSerialization.data(withJSONObject: props) else {
      return nil
    }
    return String(data: propsData, encoding: .utf8)
  }
}
