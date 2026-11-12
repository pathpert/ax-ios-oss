import Library
import UIKit

/// Row model enumerating input fields rendered in `CreatePasswordTableViewController`.
enum CreatePasswordRow: CaseIterable {
  case newPassword
  case confirmNewPassword
}

extension CreatePasswordRow {
  var placeholder: String {
    return Strings.signup_input_fields_password()
  }

  var returnKeyType: UIReturnKeyType {
    switch self {
    case .newPassword: return .next
    case .confirmNewPassword: return .done
    }
  }

  var title: String {
    switch self {
    case .newPassword: return Strings.New_password()
    case .confirmNewPassword: return Strings.Confirm_password()
    }
  }
}

