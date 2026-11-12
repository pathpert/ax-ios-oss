import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Account Mutations

/// Isolates legacy `ServiceType` account-mutation calls behind `AXProblemDetails` errors.
public protocol AccountLegacyBridgeProtocol {
  /// Updates the user's email address after validating password credentials.
  func changeEmail(contract: ValidatedChangeEmailContract) -> Result<EmptyResponseEnvelope, AXProblemDetails>
  /// Updates the user's account password.
  func changePassword(contract: ChangePasswordRequestSchema) -> Result<EmptyResponseEnvelope, AXProblemDetails>
  /// Updates the user's preferred pledge display currency.
  func changeCurrency(currency: AXSupportedCurrencyCode) -> Result<EmptyResponseEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating account mutations to `ServiceType`.
public final class LegacyAccountServiceAdapter: AccountLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Updates the user email synchronously and translates legacy errors.
  public func changeEmail(
    contract: ValidatedChangeEmailContract
  ) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let input = ChangeEmailInput(email: contract.normalizedEmail, currentPassword: contract.currentPassword)
    guard let result = self.legacyService.changeEmail(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on changeEmail"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "changeEmail"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "changeEmail") }
  }

  /// Updates the user password synchronously and translates legacy errors.
  /// Changes the user password idempotently while enforcing rate-limit quota.
  public func changePassword(
    contract: ChangePasswordRequestSchema
  ) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let input = ChangePasswordInput(
      currentPassword: contract.currentPassword,
      newPassword: contract.newPassword,
      newPasswordConfirmation: contract.newPasswordConfirmation
    )
    guard let result = self.legacyService.changePassword(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on changePassword"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "changePassword"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "changePassword") }
  }

  /// Updates the user currency synchronously and translates legacy errors.
  /// Changes the user display currency idempotently while enforcing rate-limit quota.
  public func changeCurrency(
    currency: AXSupportedCurrencyCode
  ) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let input = ChangeCurrencyInput(chosenCurrency: currency.rawValue)
    guard let result = self.legacyService.changeCurrency(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on changeCurrency"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "changeCurrency"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "changeCurrency") }
  }
}

// MARK: - Rule 2 & Rule 5: Account Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating email, password, and currency mutations.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified account payload fails with HTTP 409 conflict.
public final class AccountModuleService {
  private let bridge: AccountLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var emailStore: [IdempotencyKey: (ChangeEmailRequestSchema, AccountMutationReceipt)] = [:]
  private var passwordStore: [IdempotencyKey: (ChangePasswordRequestSchema, AccountMutationReceipt)] = [:]
  private var currencyStore: [IdempotencyKey: (ChangeCurrencyRequestSchema, AccountMutationReceipt)] = [:]

  /// Creates an `AccountModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: AccountLegacyBridgeProtocol,
    rateLimitMax: Int = 20,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 20,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.init(
      bridge: LegacyAccountServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Changes the user email idempotently while enforcing rate-limit quota.
  public func changeEmail(
    schema: ChangeEmailRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<AccountMutationReceipt>, AXProblemDetails> {
    if let (savedSchema, receipt) = self.emailStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = AccountMutationReceipt(
        operation: receipt.operation,
        updatedValue: receipt.updatedValue,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.changeEmail(contract: validated).map { _ in
        let receipt = AccountMutationReceipt(operation: "changeEmail", updatedValue: validated.normalizedEmail)
        self.emailStore[idempotencyKey] = (schema, receipt)
        return AXServiceResponse(
          value: receipt,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Changes the user password idempotently while enforcing rate-limit quota.
  public func changePassword(
    schema: ChangePasswordRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<AccountMutationReceipt>, AXProblemDetails> {
    if let (savedSchema, receipt) = self.passwordStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = AccountMutationReceipt(
        operation: receipt.operation,
        updatedValue: receipt.updatedValue,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.changePassword(contract: validated).map { _ in
        let receipt = AccountMutationReceipt(operation: "changePassword", updatedValue: "[REDACTED]")
        self.passwordStore[idempotencyKey] = (schema, receipt)
        return AXServiceResponse(
          value: receipt,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Changes the user display currency idempotently while enforcing rate-limit quota.
  public func changeCurrency(
    schema: ChangeCurrencyRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<AccountMutationReceipt>, AXProblemDetails> {
    if let (savedSchema, receipt) = self.currencyStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = AccountMutationReceipt(
        operation: receipt.operation,
        updatedValue: receipt.updatedValue,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { currency in
      self.bridge.changeCurrency(currency: currency).map { _ in
        let receipt = AccountMutationReceipt(operation: "changeCurrency", updatedValue: currency.rawValue)
        self.currencyStore[idempotencyKey] = (schema, receipt)
        return AXServiceResponse(
          value: receipt,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  private static func idempotencyConflict(key: IdempotencyKey) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/idempotency-conflict",
      title: "Idempotency-Key Payload Conflict",
      status: 409,
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different account mutation payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each account mutation.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key bound to another account mutation payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) account mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

