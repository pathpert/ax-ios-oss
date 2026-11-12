/// Protocol for analytics identity synchronization and session resets (e.g., Segment).
///
/// Negative Constraint: Prefer `KSRAnalyticsIdentityData` typed traits at caller boundaries before invoking `identify(userId:traits:)`.
public protocol IdentifyingTrackingClient {
  /**
   Identifies a user for event tracking, using the Segment SDK.

   - parameter userId: The userId associated with this user on Segment.
   - parameter traits: Typed `Codable` traits associated with the user.
   */
  func identify<T: Codable>(userId: String, traits: T?)

  /**
   Resets the identity of a user with Segment.
   */
  func reset()

  /// Anonymous tracking identifier generated before or between authenticated sessions.
  var anonymousId: String { get }
  /// Currently identified Kickstarter user ID, or `nil` when signed out.
  var userId: String? { get }
}
