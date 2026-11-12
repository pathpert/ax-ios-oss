import Foundation
import Prelude

/// Lightweight GraphQL viewer email response decoded from `me.email`.
///
/// Negative Constraint: Do not confuse with full `User` profile models; only contains the viewer's email address.
public struct GraphUserEmail: Decodable {
  /// Viewer email address returned by GraphQL, or `nil` when unverified/absent.
  public var email: String?
}

extension GraphUserEmail: Equatable {
  /// Compares two `GraphUserEmail` records by their `email` string.
  public static func == (lhs: GraphUserEmail, rhs: GraphUserEmail) -> Bool {
    lhs.email == rhs.email
  }
}
