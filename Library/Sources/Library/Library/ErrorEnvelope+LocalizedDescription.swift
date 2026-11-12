import Foundation
import KsApi

/// `ErrorEnvelope` extensions declared in `ErrorEnvelope+LocalizedDescription.swift`.
public extension ErrorEnvelope {
  var localizedDescription: String {
    if let message = self.errorMessages.first {
      return message
    }

    return Strings.general_error_something_wrong()
  }
}
