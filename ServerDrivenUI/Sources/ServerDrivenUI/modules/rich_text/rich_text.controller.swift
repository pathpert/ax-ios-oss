import Foundation
import KsApi

// MARK: - Rule 2: RichText Controller

/// Controller exposing the RichText normalization endpoint contract.
public final class RichTextController {
  /// Endpoint metadata describing `POST /ax/v1/sdui/rich-text/normalize`.
  public static let normalizeEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/sdui/rich-text/normalize",
    summary: "Validates and normalizes Server-Driven UI RichText trees (splitting nested inline photos into sibling blocks).",
    requiresIdempotencyKey: false
  )

  private let service: RichTextModuleService

  /// Creates a controller backed by `RichTextModuleService`.
  public init(service: RichTextModuleService = RichTextModuleService()) {
    self.service = service
  }

  /// Handles a RichText normalization request and wraps the service result in an `AXControllerResponse`.
  public func handleNormalizeRichText(
    request: NormalizeRichTextRequestSchema
  ) -> Result<AXControllerResponse<RichTextNormalizationContract>, AXProblemDetails> {
    self.service.normalizeRichText(schema: request).map { response in
      AXControllerResponse(
        statusCode: 200,
        headers: response.rateLimitHeaders.httpHeaders,
        body: response.value
      )
    }
  }
}
