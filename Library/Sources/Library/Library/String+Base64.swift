import Foundation

/// `String` extensions declared in `String+Base64.swift`.
extension String {
  func toBase64() -> String {
    return Data(self.utf8).base64EncodedString()
  }
}
