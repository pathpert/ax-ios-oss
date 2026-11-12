import Foundation

// MARK: - Rule 2: KDS Design Tokens Controller

/// HTTP-style response envelope returned by `DesignTokensController`.
public struct AXDesignTokenControllerResponse<T: Codable & Equatable & Sendable>: Equatable, Sendable {
  /// HTTP status code representing the resolution outcome.
  public let statusCode: Int
  /// Response headers including rate-limit metadata when available.
  public let headers: [String: String]
  /// Resolved design token contract on success.
  public let body: T?
  /// Structured RFC 9457 problem details on validation or rate-limit failure.
  public let problem: AXDesignTokenProblemDetails?
}

/// Controller exposing KDS spacing and semantic color resolution endpoints.
public final class DesignTokensController {
  private let service: DesignTokensModuleService

  /// Creates a controller backed by `DesignTokensModuleService`.
  public init(service: DesignTokensModuleService = DesignTokensModuleService()) {
    self.service = service
  }

  /// Resolves a KDS spacing unit request into an `AXDesignTokenControllerResponse`.
  public func handleResolveSpacing(
    request: ResolveSpacingTokenRequestSchema
  ) -> AXDesignTokenControllerResponse<SpacingTokenContract> {
    switch self.service.resolveSpacing(schema: request) {
    case let .success((contract, headers)):
      return AXDesignTokenControllerResponse(
        statusCode: 200,
        headers: headers.httpHeaders,
        body: contract,
        problem: nil
      )
    case let .failure(problem):
      return AXDesignTokenControllerResponse(
        statusCode: problem.status,
        headers: problem.rateLimitHeaders?.httpHeaders ?? [:],
        body: nil,
        problem: problem
      )
    }
  }

  /// Resolves a KDS semantic color token request into an `AXDesignTokenControllerResponse`.
  public func handleResolveSemanticColor(
    request: ResolveSemanticColorRequestSchema
  ) -> AXDesignTokenControllerResponse<SemanticColorTokenContract> {
    switch self.service.resolveSemanticColor(schema: request) {
    case let .success((contract, headers)):
      return AXDesignTokenControllerResponse(
        statusCode: 200,
        headers: headers.httpHeaders,
        body: contract,
        problem: nil
      )
    case let .failure(problem):
      return AXDesignTokenControllerResponse(
        statusCode: problem.status,
        headers: problem.rateLimitHeaders?.httpHeaders ?? [:],
        body: nil,
        problem: problem
      )
    }
  }
}

