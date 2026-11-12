import Foundation
import KsApi

// MARK: - Pillar 4: Shared RFC 9457 Problem Details & Rate-Limit Re-exports for Library and App Targets

/// RFC 9457 Problem Details error payload re-exported from `KsApi`.
public typealias AXProblemDetails = KsApi.AXProblemDetails
/// Invalid input parameter descriptor re-exported from `KsApi`.
public typealias AXInvalidParam = KsApi.AXInvalidParam
/// Machine-readable field validation constraint descriptor re-exported from `KsApi`.
public typealias AXFieldDescriptor = KsApi.AXFieldDescriptor
/// Standardized rate-limit metadata headers re-exported from `KsApi`.
public typealias AXRateLimitHeaders = KsApi.AXRateLimitHeaders
/// Validated `Idempotency-Key` wrapper re-exported from `KsApi`.
public typealias AXIdempotencyKey = KsApi.IdempotencyKey

extension Result where Failure == ErrorEnvelope {
  /// Maps a legacy `ErrorEnvelope` failure into an RFC 9457 `AXProblemDetails` failure with remediation guidance.
  public func mapErrorToProblemDetails(operation: String) -> Result<Success, AXProblemDetails> {
    self.mapError { $0.toAXProblemDetails(operation: operation) }
  }
}

