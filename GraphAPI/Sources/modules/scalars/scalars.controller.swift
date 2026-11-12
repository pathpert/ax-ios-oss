import Foundation

// MARK: - Rule 2: GraphAPI Scalars Controller

/// HTTP-style controller response envelope for GraphAPI custom scalar validation endpoints.
public struct AXGraphScalarControllerResponse<T: Codable & Equatable & Sendable>: Equatable, Sendable {
  /// HTTP status code (`200`, `400`, or `429`).
  public let statusCode: Int
  /// Rate-limit and metadata headers.
  public let headers: [String: String]
  /// Validated scalar contract on success.
  public let body: T?
  /// Structured RFC 9457 error payload on failure.
  public let problem: AXGraphScalarProblemDetails?
}

/// Controller exposing custom GraphQL scalar validation endpoints.
public final class GraphScalarsController {
  private let service: GraphScalarsModuleService

  /// Creates a controller backed by `GraphScalarsModuleService`.
  public init(service: GraphScalarsModuleService = GraphScalarsModuleService()) {
    self.service = service
  }

  /// Validates an incoming `ValidateGraphScalarsRequestSchema` and formats an HTTP-style response.
  public func handleValidateScalars(
    request: ValidateGraphScalarsRequestSchema
  ) -> AXGraphScalarControllerResponse<ValidatedGraphScalarsContract> {
    switch self.service.validateScalars(schema: request) {
    case let .success((contract, headers)):
      return AXGraphScalarControllerResponse(statusCode: 200, headers: headers, body: contract, problem: nil)
    case let .failure(problem):
      return AXGraphScalarControllerResponse(statusCode: problem.status, headers: [:], body: nil, problem: problem)
    }
  }
}

