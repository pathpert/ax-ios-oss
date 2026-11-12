import Foundation

/// Lifecycle state of a Kickstarter `Project` decoded from GraphQL APIs.
///
/// Negative Constraint: GraphQL enum raw values are uppercase strings (`LIVE`, `CANCELED`, etc.); v1 REST uses lowercase equivalents.
public enum ProjectState: String, CaseIterable, Decodable, Equatable {
  /// Project campaign was canceled before its deadline.
  case canceled = "CANCELED"
  /// Campaign deadline passed without reaching its funding goal.
  case failed = "FAILED"
  /// Campaign is actively accepting pledges.
  case live = "LIVE"
  /// Project has been purged/removed from public listing.
  case purged = "PURGED"
  /// Draft project created by the creator and not yet submitted.
  case started = "STARTED"
  /// Draft project submitted for Kickstarter review.
  case submitted = "SUBMITTED"
  /// Campaign reached or exceeded its funding goal and succeeded.
  case successful = "SUCCESSFUL"
  /// Campaign was suspended for trust-and-safety review.
  case suspended = "SUSPENDED"
}
