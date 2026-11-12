/// HTTP request verb used by legacy v1 REST endpoints.
/// - Negative Constraint: Do not use `Method` for Apollo GraphQL queries or mutations (which always execute over POST).
public enum Method: String {
  /// HTTP GET request.
  case GET
  /// HTTP POST request.
  case POST
  /// HTTP PUT request.
  case PUT
  /// HTTP DELETE request.
  case DELETE
}
