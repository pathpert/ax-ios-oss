import Foundation
import GraphAPI

extension PPOProjectCardModel.Alert {
  init?(flag: GraphAPI.PPOCardFragment.Flag) {
    let alertIcon: PPOProjectCardModel.Alert.AlertIcon? = switch flag.icon {
    case "alert":
      .alert
    case "time":
      .time
    default:
      nil
    }

    let alertType: PPOProjectCardModel.Alert.AlertType? = switch flag.type {
    case "alert":
      .alert
    case "warning":
      .warning
    case "info":
      .info
    default:
      nil
    }
    let message = flag.message

    guard let alertType, let message else {
      return nil
    }

    self = .init(type: alertType, icon: alertIcon, message: message)
  }
}

extension GraphAPI.MoneyFragment: Equatable {
  /// Compares two GraphQL `MoneyFragment` values across amount, currency, and symbol.
  public static func == (lhs: GraphAPI.MoneyFragment, rhs: GraphAPI.MoneyFragment) -> Bool {
    return lhs.amount == rhs.amount &&
      lhs.currency == rhs.currency &&
      lhs.symbol == rhs.symbol
  }
}

extension GraphAPI.MoneyFragment: Hashable {
  /// Hashes the fragment's amount, currency, and symbol components.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.amount)
    hasher.combine(self.currency)
    hasher.combine(self.symbol)
  }
}

