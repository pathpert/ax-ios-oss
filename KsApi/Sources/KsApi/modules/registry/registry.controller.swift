import Foundation

// MARK: - Rule 2: AX Registry Controller

/// Agent-native REST controller exposing the runtime AX capability catalog for all modernized modules.
public final class RegistryController {
  /// Endpoint metadata for `GET /ax/v1/registry/catalog`.
  public static let catalogEndpoint = AXEndpointDescriptor(
    method: "GET",
    path: "/ax/v1/registry/catalog",
    summary: "Returns the complete Agent Experience (AX) module capability catalog, field descriptors, and deprecation mappings.",
    requiresIdempotencyKey: false,
    deprecated: false
  )

  private let service: RegistryModuleService

  /// Creates a `RegistryController` backed by `service`.
  public init(service: RegistryModuleService = RegistryModuleService()) {
    self.service = service
  }

  /// Handles `GET /ax/v1/registry/catalog` with optional module filtering.
  public func handleGetCatalog(
    query: AXCatalogQuerySchema = AXCatalogQuerySchema()
  ) -> Result<AXControllerResponse<AXCatalogContract>, AXProblemDetails> {
    self.service.queryCatalog(schema: query).map { res in
      AXControllerResponse(
        statusCode: 200,
        headers: res.rateLimitHeaders.httpHeaders,
        body: res.value
      )
    }
  }
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `RegistryController` for catalog introspection.
  public func makeAXRegistryController(
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil
  ) -> RegistryController {
    let service = RegistryModuleService(
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota
    )
    return RegistryController(service: service)
  }
}

