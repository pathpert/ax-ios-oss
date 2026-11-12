import Foundation

/// Lifecycle state of a Kickstarter backing decoded from GraphQL/v1 responses.
///
/// Negative Constraint: Enum raw values are lowercase API tokens; do not serialize display labels directly.
public enum BackingState: String, CaseIterable, Decodable, Equatable {
  /// Backing was canceled by the backer prior to campaign end.
  case canceled
  /// Pledge funds were successfully charged and collected.
  case collected
  /// Pledge failed final charge collection after retries exhausted.
  case dropped
  /// Payment charge encountered a recoverable error awaiting retry/update.
  case errored
  /// Active pledge on a live campaign prior to charge collection.
  case pledged
  /// Pre-authorized payment state before final settlement.
  case preauth
}
