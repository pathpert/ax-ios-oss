import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Account Controller & Deprecation Guardrails

/// Agent-native REST controller handling validated email, password, and currency mutations.
///
/// Negative Constraint: Always supply a unique `Idempotency-Key` header; do not fall back to legacy `ChangeEmailInput`, `ChangePasswordInput`, or `ChangeCurrencyInput`.
public final class AccountController {
  /// Endpoint metadata for `PUT /ax/v1/account/email`.
  public static let changeEmailEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/account/email",
    summary: "Updates the user's primary email address with RFC 5322 validation and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `PUT /ax/v1/account/password`.
  public static let changePasswordEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/account/password",
    summary: "Updates the user's password with minimum length/confirmation checks and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `PUT /ax/v1/account/currency`.
  public static let changeCurrencyEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/account/currency",
    summary: "Updates the user's preferred currency using strictly validated ISO 4217 codes and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: AccountModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates an `AccountController` backed by `service` and an optional audit hook.
  public init(
    service: AccountModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `PUT /ax/v1/account/email` after validating `Idempotency-Key` and email format.
  public func handleChangeEmail(
    payload: ChangeEmailRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<AccountMutationReceipt>, AXProblemDetails> {
    self.dispatch(endpoint: Self.changeEmailEndpoint.path, headers: headers) { key in
      self.service.changeEmail(schema: payload, idempotencyKey: key)
    }
  }

  /// Handles `PUT /ax/v1/account/password` after validating `Idempotency-Key` and password confirmation rules.
  public func handleChangePassword(
    payload: ChangePasswordRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<AccountMutationReceipt>, AXProblemDetails> {
    self.dispatch(endpoint: Self.changePasswordEndpoint.path, headers: headers) { key in
      self.service.changePassword(schema: payload, idempotencyKey: key)
    }
  }

  /// Handles `PUT /ax/v1/account/currency` after validating `Idempotency-Key` and ISO 4217 currency membership.
  public func handleChangeCurrency(
    payload: ChangeCurrencyRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<AccountMutationReceipt>, AXProblemDetails> {
    self.dispatch(endpoint: Self.changeCurrencyEndpoint.path, headers: headers) { key in
      self.service.changeCurrency(schema: payload, idempotencyKey: key)
    }
  }

  private func dispatch(
    endpoint: String,
    headers: [String: String],
    operation: (IdempotencyKey) -> Result<AXServiceResponse<AccountMutationReceipt>, AXProblemDetails>
  ) -> Result<AXControllerResponse<AccountMutationReceipt>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: endpoint,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch operation(key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: endpoint,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: endpoint,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }
}

// MARK: - Rule 6: Loud Deprecation Metadata for Legacy Account Inputs

extension ChangeEmailInput {
  /// Deprecation descriptor redirecting callers to `ChangeEmailRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ChangeEmailInput",
    meaning: "Legacy GraphQL input using untyped dictionary serialization and lacking email validation.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through ChangeEmailInput."],
    deprecated: true,
    replacementPrimitive: "ChangeEmailRequestSchema via AccountController.handleChangeEmail(payload:headers:)"
  )
}

extension ChangePasswordInput {
  /// Deprecation descriptor redirecting callers to `ChangePasswordRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ChangePasswordInput",
    meaning: "Legacy GraphQL input using untyped dictionary serialization and lacking password policy checks.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through ChangePasswordInput."],
    deprecated: true,
    replacementPrimitive: "ChangePasswordRequestSchema via AccountController.handleChangePassword(payload:headers:)"
  )
}

extension ChangeCurrencyInput {
  /// Deprecation descriptor redirecting callers to `ChangeCurrencyRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ChangeCurrencyInput",
    meaning: "Legacy GraphQL input accepting arbitrary unvalidated currency strings.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through ChangeCurrencyInput."],
    deprecated: true,
    replacementPrimitive: "ChangeCurrencyRequestSchema via AccountController.handleChangeCurrency(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `AccountController` backed by `self`.
  public func makeAXAccountController(
    rateLimitMax: Int = 20,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> AccountController {
    let service = AccountModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return AccountController(service: service, onMutationHook: onMutationHook)
  }
}

