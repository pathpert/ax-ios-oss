import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Project Notifications & Unseen Activity

/// Isolates legacy `ServiceType` notification calls behind `AXProblemDetails` errors.
public protocol NotificationsLegacyBridgeProtocol {
  /// Updates email and mobile notification preferences for a project.
  func updateProjectNotification(_ notification: ProjectNotification) -> Result<ProjectNotification, AXProblemDetails>
  /// Clears unseen activity indicator counts for the current user.
  func clearUserUnseenActivity(input: EmptyInput) -> Result<ClearUserUnseenActivityEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating notification calls to `ServiceType`.
public final class LegacyNotificationsServiceAdapter: NotificationsLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Updates a project notification setting synchronously and translates legacy errors.
  public func updateProjectNotification(
    _ notification: ProjectNotification
  ) -> Result<ProjectNotification, AXProblemDetails> {
    guard let result = self.legacyService.updateProjectNotification(notification).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on updateProjectNotification"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "updateProjectNotification"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "updateProjectNotification") }
  }

  /// Clears unseen activity synchronously and translates legacy errors.
  public func clearUserUnseenActivity(
    input: EmptyInput
  ) -> Result<ClearUserUnseenActivityEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.clearUserUnseenActivity(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on clearUserUnseenActivity"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "clearUserUnseenActivity"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "clearUserUnseenActivity") }
  }
}

// MARK: - Rule 2 & Rule 5: Notifications Module Service

/// Rate-limited, idempotent service orchestrating project notification updates and clearing unseen activity.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified payload returns HTTP 409 conflict.
public final class NotificationsModuleService {
  private let bridge: NotificationsLegacyBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int
  private var updateStore: [IdempotencyKey: (UpdateProjectNotificationRequestSchema, ProjectNotificationContract)] = [:]
  private var clearStore: [IdempotencyKey: (ClearUnseenActivityRequestSchema, ClearUnseenActivityContract)] = [:]

  /// Creates a `NotificationsModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: NotificationsLegacyBridgeProtocol,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.init(
      bridge: LegacyNotificationsServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota
    )
  }

  /// Updates project notification settings idempotently while enforcing rate-limit quota.
  public func updateNotification(
    schema: UpdateProjectNotificationRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<ProjectNotificationContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.updateStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = ProjectNotificationContract(
        notificationId: contract.notificationId,
        projectId: contract.projectId,
        emailEnabled: contract.emailEnabled,
        mobileEnabled: contract.mobileEnabled,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { model in
      self.bridge.updateProjectNotification(model).map { updated in
        let contract = ProjectNotificationContract(
          notificationId: updated.id,
          projectId: updated.project.id,
          emailEnabled: updated.email,
          mobileEnabled: updated.mobile,
          idempotencyReplayed: false
        )
        self.updateStore[idempotencyKey] = (schema, contract)
        return AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Clears unseen activity counts idempotently while enforcing rate-limit quota.
  public func clearUnseenActivity(
    schema: ClearUnseenActivityRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<ClearUnseenActivityContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.clearStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = ClearUnseenActivityContract(
        activityIndicatorCount: contract.activityIndicatorCount,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { input in
      self.bridge.clearUserUnseenActivity(input: input).map { env in
        let contract = ClearUnseenActivityContract(
          activityIndicatorCount: env.activityIndicatorCount,
          idempotencyReplayed: false
        )
        self.clearStore[idempotencyKey] = (schema, contract)
        return AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  private func consumeQuota() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit exceeded on notifications module.",
        suggestedAction: "Wait 30 seconds before sending more notification mutations.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 30)
      )
    }
    self.remainingQuota -= 1
    return nil
  }

  private static func idempotencyConflict(key: IdempotencyKey) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/idempotency-key-conflict",
      title: "Idempotency Key Reused With Different Payload",
      status: 409,
      detail: "Idempotency-Key '\(key.rawValue)' was already used for a different notification mutation.",
      suggestedAction: "Generate a fresh UUID v4 Idempotency-Key for distinct notification requests.",
      isRetriable: false
    )
  }
}

