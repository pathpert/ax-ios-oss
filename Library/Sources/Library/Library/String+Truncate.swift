import Foundation

extension String {
  /// Returns a string truncated to at most `maxLength` characters, appending `suffix` when shortened.
  /// - parameter maxLength: Maximum character length before truncation.
  /// - parameter suffix: Suffix appended when truncation occurs (defaults to `"…"`).
  /// - returns: Truncated string.
  public func truncated(maxLength: Int, suffix: String = "…") -> String {
    guard self.count > maxLength else { return self }

    let advancedBy = maxLength - suffix.count

    guard let index = self.index(self.startIndex, offsetBy: advancedBy, limitedBy: self.endIndex) else {
      return self
    }

    return String(self.prefix(upTo: index)) + suffix
  }
}
