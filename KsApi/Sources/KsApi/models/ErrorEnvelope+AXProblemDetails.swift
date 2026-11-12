import Foundation

extension ErrorEnvelope.KsrCode {
  /// Deterministic RFC 9457 remediation guidance for each `KsrCode` case.
  public var suggestedAction: String {
    switch self {
    case .AccessTokenInvalid:
      return "Refresh or re-authenticate the user's OAuth token via AuthController before retrying this request."
    case .ConfirmFacebookSignup:
      return "Prompt the user to confirm Facebook account creation and invoke signup(facebookAccessToken:sendNewsletters:)."
    case .FacebookConnectAccountTaken:
      return "Do not retry Facebook connect; instruct the user to sign in directly with the existing linked account."
    case .FacebookConnectEmailTaken:
      return "Instruct the user to sign in with their registered email/password first, then link Facebook in account settings."
    case .FacebookInvalidAccessToken:
      return "Request a fresh access token from the Facebook Login SDK and retry with the new token."
    case .InvalidXauthLogin:
      return "Do not retry with the same email/password; prompt the user to verify credentials or trigger resetPassword(email:)."
    case .MissingFacebookEmail:
      return "Re-request the 'email' permission scope from Facebook Login or fall back to standard email signup."
    case .TfaFailed:
      return "Prompt the user for a new 6-digit two-factor authentication code and retry login(email:password:code:)."
    case .TfaRequired:
      return "Prompt the user for their 2FA verification code and resubmit login(email:password:code:) with the code populated."
    case .UnknownCode:
      return "Inspect errorMessages and httpCode for specific server constraints before retrying."
    case .JSONParsingFailed:
      return "Verify the endpoint returns valid UTF-8 JSON and check network proxy/gateway responses."
    case .ErrorEnvelopeJSONParsingFailed:
      return "Inspect the raw HTTP status code; if 5xx or network timeout, retry with exponential backoff."
    case .DecodingJSONFailed:
      return "Inspect errorMessages for the mismatched CodingKey path and align the client response schema with the API."
    case .InvalidPaginationUrl:
      return "Do not reuse this pagination URL; re-fetch the first page to obtain a fresh cursor or pagination URL."
    case .GraphQLError:
      return "Inspect errorMessages for GraphQL field validation errors and fix the input variables before re-submitting."
    case .ValidateCheckoutError:
      return "Re-validate the pledge amount, reward availability, shipping rule, and payment source via CheckoutController before retrying."
    }
  }

  /// Indicates whether the caller or agent may retry the operation after applying the remediation or backoff.
  public var isRetriable: Bool {
    switch self {
    case .AccessTokenInvalid, .FacebookInvalidAccessToken, .TfaFailed, .TfaRequired:
      return true
    case .ConfirmFacebookSignup, .FacebookConnectAccountTaken, .FacebookConnectEmailTaken,
         .InvalidXauthLogin, .MissingFacebookEmail, .UnknownCode,
         .JSONParsingFailed, .ErrorEnvelopeJSONParsingFailed, .DecodingJSONFailed,
         .InvalidPaginationUrl, .GraphQLError, .ValidateCheckoutError:
      return false
    }
  }
}

extension ErrorEnvelope {
  /// Resolves a deterministic `suggestedAction` from `ksrCode`, `graphError`, and `httpCode`.
  public static func resolveSuggestedAction(
    ksrCode: KsrCode?,
    httpCode: Int,
    graphError: GraphError?
  ) -> String {
    if let ksrCode = ksrCode, ksrCode != .UnknownCode {
      return ksrCode.suggestedAction
    }
    if let graphError = graphError {
      switch graphError {
      case .emptyResponse:
        return "Verify the GraphQL query selection set is non-empty and retry if the server experienced a transient empty response."
      case .invalidInput:
        return "Validate all GraphQL mutation input fields against the module's schema contract before retrying."
      case .invalidJson, .decodeError, .jsonDecodingError:
        return "Inspect the GraphQL response payload structure and ensure required non-null fields match the schema."
      case .requestError:
        return "Check network connectivity or GraphQL request error details and retry with exponential backoff if transient."
      }
    }
    switch httpCode {
    case 401:
      return "Provide a valid OAuth bearer token in the Authorization header or re-authenticate via AuthController."
    case 403:
      return "Verify the current user has permission for this resource or check CSRF/client auth headers."
    case 404:
      return "Verify the requested resource ID or slug exists before retrying."
    case 409, 422:
      return "Inspect errorMessages for domain validation failures and correct the input parameters before retrying."
    case 429:
      return "Respect the Retry-After / X-RateLimit-Reset backoff window before re-issuing the request."
    case 500...599:
      return "Server encountered a transient error; retry with exponential backoff and preserve the Idempotency-Key."
    default:
      return ksrCode?.suggestedAction
        ?? "Inspect errorMessages and httpCode to remediate the request parameters before retrying."
    }
  }

  /// Resolves whether the error is retriable based on HTTP status code, `ksrCode`, and `graphError`.
  public static func resolveIsRetriable(
    ksrCode: KsrCode?,
    httpCode: Int,
    graphError: GraphError?
  ) -> Bool {
    if httpCode == 429 || (500...599).contains(httpCode) {
      return true
    }
    if let graphError = graphError {
      if case .requestError = graphError {
        return true
      }
    }
    if let ksrCode = ksrCode {
      return ksrCode.isRetriable
    }
    return false
  }

  /// Converts this `ErrorEnvelope` into a standards-compliant RFC 9457 `AXProblemDetails` object.
  public func toAXProblemDetails(operation: String = "ksapi") -> AXProblemDetails {
    let resolvedStatus = self.httpCode > 0 ? self.httpCode : 500
    let codeSlug = self.ksrCode?.rawValue ?? "http_\(resolvedStatus)"
    let detailMessage = self.errorMessages.isEmpty
      ? "Request '\(operation)' failed with status \(resolvedStatus) (\(codeSlug))."
      : self.errorMessages.joined(separator: " ")

    return AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/\(operation)/\(codeSlug)",
      title: self.ksrCode?.rawValue ?? "API Error (\(resolvedStatus))",
      status: resolvedStatus,
      detail: detailMessage,
      suggestedAction: self.suggestedAction,
      isRetriable: self.isRetriable,
      invalidParams: self.errorMessages.enumerated().map { index, message in
        AXInvalidParam(name: "error_\(index)", reason: message)
      }
    )
  }
}
