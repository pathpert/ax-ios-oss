import Foundation

/// Server environment target (production, staging, development, local, or custom URL).
///
/// Negative Constraint: Never use `.production` in automated tests or unauthenticated local mock runs.
public enum EnvironmentType: CaseIterable, CustomStringConvertible, Equatable {
  case custom(String?)
  case production
  case staging
  case development
  case local

  /// Initializes an `EnvironmentType` from its display string, falling back to `.custom(rawValue)` for unrecognized strings.
  public init?(rawValue: String) {
    let allCases = EnvironmentType.allCases.filter { c -> Bool in
      if case .custom = c { return false }
      return true
    }

    for envCase in allCases where envCase.description == rawValue {
      self = envCase
      return
    }

    self = .custom(rawValue)
  }

  /// Stripe publishable key associated with this environment.
  ///
  /// Negative Constraint: Returns the staging key for all non-production environments.
  public var stripePublishableKey: String {
    switch self {
    case .production:
      return Secrets.StripePublishableKey.production
    case .staging, .development, .local, .custom:
      return Secrets.StripePublishableKey.staging
    }
  }

  /// Ordered list of standard environments, starting with `.custom(nil)`.
  public static var allCases: [EnvironmentType] {
    return [.custom(nil), .production, .staging, .development, .local]
  }

  /// Display name of the environment (or custom base URL string).
  public var description: String {
    switch self {
    case let .custom(url):
      return url ?? "Custom"
    case .production:
      return "Production"
    case .staging:
      return "Staging"
    case .development:
      return "Development"
    case .local:
      return "Local"
    }
  }
}
