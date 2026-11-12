/// Response envelope returned after triggering a verification email request.
public struct EmailVerificationResponseEnvelope: Decodable {
  /// Server-supplied confirmation or status message for display.
  public let message: String
}
