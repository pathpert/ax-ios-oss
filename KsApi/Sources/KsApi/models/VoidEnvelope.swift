
/// Empty response envelope used for API endpoints that succeed with no meaningful JSON payload.
public struct VoidEnvelope {}

extension VoidEnvelope: Decodable {}
