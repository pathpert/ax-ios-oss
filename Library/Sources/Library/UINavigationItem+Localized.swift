import UIKit

/// `UINavigationItem` extensions declared in `UINavigationItem+Localized.swift`.
public extension UINavigationItem {
  @IBInspectable
  var titleLocalizedKey: String {
    set(key) {
      self.title = localizedString(key: key, defaultValue: self.title ?? "")
    }
    get {
      return ""
    }
  }

  #if os(iOS)
    /// Localized prompt string key bound from Interface Builder (`NSLocalizedString` lookup on `prompt`).
    @IBInspectable
    public var promptLocalizedKey: String {
      set(key) {
        self.prompt = localizedString(key: key, defaultValue: self.prompt ?? "")
      }
      get {
        return ""
      }
    }
  #endif
}
