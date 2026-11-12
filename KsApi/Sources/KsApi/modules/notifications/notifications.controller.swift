import Foundation

// MARK: - Rule 2 & Rule 5: Notifications Controller

/// Agent-native REST controller managing project notification preferences and unseen-activity state.
///
/// Negative Constraint: Requires an `Idempotency-Key` header on every call.
public final class NotificationsController {
  /// Endpoint metadata for `PUT /ax/v1/notifications/projects`.
  public static let updateProjectNotificationEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/notifications/projects",
    summary: "Updates email/mobile notification preferences for a backed project with Idempotency-Key protection.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `POST /ax/v1/notifications/clear-unseen`.
  public static let clearUnseenActivityEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/notifications/clear-unseen",
    summary: "Clears the user's unseen activity badge counter with Idempotency-Key protection.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: NotificationsModuleService

  /// Creates a `NotificationsController` backed by `service`.
  public init(service: NotificationsModuleService) {
    self.service = service
  }

  /// Handles `PUT /ax/v1/notifications/projects` after validating `Idempotency-Key`.
  public func handleUpdateNotification(
    payload: UpdateProjectNotificationRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<ProjectNotificationContract>, AXProblemDetails> {
    let rawKey = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    return IdempotencyKey.validate(rawKey).flatMap { key in
      self.service.updateNotification(schema: payload, idempotencyKey: key).map { resp in
        AXControllerResponse(
          statusCode: resp.value.idempotencyReplayed ? 200 : 201,
          headers: resp.rateLimitHeaders.httpHeaders,
          body: resp.value
        )
      }
    }
  }

  /// Handles `POST /ax/v1/notifications/clear-unseen` after validating `Idempotency-Key`.
  public func handleClearUnseenActivity(
    payload: ClearUnseenActivityRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<ClearUnseenActivityContract>, AXProblemDetails> {
    let rawKey = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    return IdempotencyKey.validate(rawKey).flatMap { key in
      self.service.clearUnseenActivity(schema: payload, idempotencyKey: key).map { resp in
        AXControllerResponse(
          statusCode: resp.value.idempotencyReplayed ? 200 : 201,
          headers: resp.rateLimitHeaders.httpHeaders,
          body: resp.value
        )
      }
    }
  }
}
