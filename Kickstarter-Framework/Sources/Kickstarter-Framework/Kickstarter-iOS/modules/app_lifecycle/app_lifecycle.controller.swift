import Foundation
import KsApi

// MARK: - Rule 2 & Rule 5: App Lifecycle Controller

/// Controller exposing scene lifecycle shortcut and email link verification endpoints.
public final class AppLifecycleController {
  /// Endpoint descriptor for `POST /ax/v1/app/scene/shortcut`.
  public static let triggerShortcutEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/app/scene/shortcut",
    summary: "Validates and routes a home-screen UIApplicationShortcutItem into a deterministic SceneShortcutNavigationContract.",
    requiresIdempotencyKey: false
  )

  /// Endpoint descriptor for `POST /ax/v1/app/scene/verify-email-link`.
  public static let verifyEmailLinkEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/app/scene/verify-email-link",
    summary: "Validates and executes an email verification universal link with Idempotency-Key protection.",
    requiresIdempotencyKey: true
  )

  private let service: AppLifecycleModuleService

  /// Creates a controller backed by `AppLifecycleModuleService`.
  public init(service: AppLifecycleModuleService = AppLifecycleModuleService()) {
    self.service = service
  }

  /// Handles a home-screen shortcut trigger request and maps it to an HTTP-style response.
  public func handleTriggerShortcut(
    request: TriggerHomeScreenShortcutRequestSchema
  ) -> Result<AXControllerResponse<SceneShortcutNavigationContract>, AXProblemDetails> {
    self.service.triggerShortcut(schema: request).map { resp in
      AXControllerResponse(
        statusCode: 200,
        headers: resp.rateLimitHeaders.httpHeaders,
        body: resp.value
      )
    }
  }

  /// Validates the `Idempotency-Key` header and executes the email link verification flow.
  public func handleVerifyEmailSceneLink(
    headers: [String: String],
    request: VerifyEmailSceneLinkRequestSchema
  ) -> Result<AXControllerResponse<EmailVerificationSceneContract>, AXProblemDetails> {
    let rawKey = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    return IdempotencyKey.validate(rawKey).flatMap { key in
      self.service.verifyEmailSceneLink(schema: request, idempotencyKey: key).map { resp in
        AXControllerResponse(
          statusCode: resp.value.idempotencyReplayed ? 200 : 201,
          headers: resp.rateLimitHeaders.httpHeaders,
          body: resp.value
        )
      }
    }
  }
}
