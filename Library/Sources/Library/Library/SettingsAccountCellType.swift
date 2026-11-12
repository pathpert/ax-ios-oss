import KDS
import KsApi
import UIKit

/// Section identifiers organizing the Account Settings table view.
public enum SettingsAccountSectionType: Int, CaseIterable, Equatable {
  case createPassword
  case changeEmailPassword
  case privacy
  case payment

  /// Fixed table section header spacing height.
  public static var sectionHeaderHeight: CGFloat {
    return Styles.grid(5)
  }

  /// Cell descriptors rendered within this section.
  public var cellRowsForSection: [SettingsAccountCellType] {
    switch self {
    case .createPassword:
      return [.createPassword]
    case .changeEmailPassword:
      return [.changePassword]
    case .privacy:
      return [.privacy]
    case .payment:
      return [.paymentMethods]
    }
  }
}

/// Row descriptors for the Account Settings table view.
/// - Negative Constraint: Do not hardcode settings cell titles in view controllers; derive copy from `title`.
public enum SettingsAccountCellType: SettingsCellTypeProtocol, Equatable {
  case createPassword
  case changeEmail
  case changePassword
  case privacy
  case paymentMethods
  case currency(Currency?)

  /// Accessibility traits applied to interactive account setting rows.
  public var accessibilityTraits: UIAccessibilityTraits {
    return .button
  }

  /// Whether to show the disclosure chevron indicator on the trailing edge.
  public var showArrowImageView: Bool {
    return true
  }

  /// Primary foreground color for the row title label.
  public var textColor: UIColor {
    return LegacyColors.ksr_support_700.uiColor()
  }

  /// Localized row title displayed in the Account Settings list.
  public var title: String {
    switch self {
    case .createPassword:
      return Strings.Create_password()
    case .changeEmail:
      return Strings.Change_email()
    case .changePassword:
      return Strings.Change_password()
    case .privacy:
      return Strings.Privacy()
    case .paymentMethods:
      return Strings.Payment_methods()
    case .currency:
      return Strings.Currency()
    }
  }

  /// Optional trailing detail value (populated for the selected currency row).
  public var description: String? {
    switch self {
    case let .currency(currency): return currency?.descriptionText
    default: return nil
    }
  }
}
