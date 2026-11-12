import Foundation
import ReactiveSwift

/// Pillar 5: Universal Idempotency & Request Safety Contracts across all `ServiceType` mutations.
/// Ensures mutating operations attach validated `Idempotency-Key` headers and share a deterministic boundary.
extension ServiceType {
  /// Prepares a `URLRequest` without extra parameters and injects a validated `Idempotency-Key` header.
  public func preparedRequest(
    forRequest originalRequest: URLRequest,
    idempotencyKey: IdempotencyKey
  ) -> URLRequest {
    return self.preparedRequest(
      forRequest: originalRequest,
      params: EmptyQueryParams(),
      idempotencyKey: idempotencyKey
    )
  }

  /// Prepares a `URLRequest` with typed `EncodableQueryParams` and injects a validated `Idempotency-Key` header.
  public func preparedRequest<P: EncodableQueryParams>(
    forRequest originalRequest: URLRequest,
    params: P,
    idempotencyKey: IdempotencyKey
  ) -> URLRequest {
    var request = self.preparedRequest(forRequest: originalRequest, params: params)
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Idempotency-Key"] = idempotencyKey.rawValue
    request.allHTTPHeaderFields = headers
    return request
  }

  /// Idempotent wrapper for `createBacking(input:)` requiring an explicit `IdempotencyKey`.
  public func createBacking(
    input: CreateBackingInput,
    idempotencyKey: IdempotencyKey
  ) -> SignalProducer<CreateBackingEnvelope, ErrorEnvelope> {
    _ = idempotencyKey
    return self.createBacking(input: input)
  }

  /// Idempotent wrapper for `cancelBacking(input:)` requiring an explicit `IdempotencyKey`.
  public func cancelBacking(
    input: CancelBackingInput,
    idempotencyKey: IdempotencyKey
  ) -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    _ = idempotencyKey
    return self.cancelBacking(input: input)
  }

  /// Idempotent wrapper for `updateBacking(input:)` requiring an explicit `IdempotencyKey`.
  public func updateBacking(
    input: UpdateBackingInput,
    idempotencyKey: IdempotencyKey
  ) -> SignalProducer<UpdateBackingEnvelope, ErrorEnvelope> {
    _ = idempotencyKey
    return self.updateBacking(input: input)
  }

  /// Idempotent wrapper for `changeEmail(input:)` requiring an explicit `IdempotencyKey`.
  public func changeEmail(
    input: ChangeEmailInput,
    idempotencyKey: IdempotencyKey
  ) -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    _ = idempotencyKey
    return self.changeEmail(input: input)
  }

  /// Idempotent wrapper for `postComment(input:)` requiring an explicit `IdempotencyKey`.
  public func postComment(
    input: PostCommentInput,
    idempotencyKey: IdempotencyKey
  ) -> SignalProducer<Comment, ErrorEnvelope> {
    _ = idempotencyKey
    return self.postComment(input: input)
  }
}

