import Foundation

extension String {
  /// Non-breaking space Unicode character (`\u{00A0}`).
  public static let nbsp = "\u{00A0}"

  /// Returns a new string with ASCII spaces replaced by non-breaking spaces (`\u{00A0}`).
  /// - returns: The non-breaking spaced string.
  public func nonBreakingSpaced() -> String {
    return self.replacingOccurrences(of: " ", with: "\u{00a0}")
  }

  /// Returns a copy trimmed of leading and trailing whitespace and newline characters.
  public func trimmed() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

/// Returns `true` when `s` contains only whitespace and newline characters.
/// - Negative Constraint: Does not perform Unicode zero-width normalization.
public func isWhitespacesAndNewlines(_ s: String) -> Bool {
  return s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}
