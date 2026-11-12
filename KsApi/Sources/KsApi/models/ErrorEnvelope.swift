

/// Canonical API error model emitted across REST and GraphQL `ServiceType` operations.
///
/// - Negative constraint: Inspect `ksrCode`, `httpCode`, and `suggestedAction` (or `toAXProblemDetails()`) before blindly retrying; only retry when `isRetriable == true`.
public struct ErrorEnvelope {
  /// Human-readable error descriptions returned by the backend or synthesized during client decoding.
  public let errorMessages: [String]
  /// Machine-readable Kickstarter error classification code, if provided or mapped.
  public let ksrCode: KsrCode?
  /// HTTP status code associated with the failure (`0` for synthesized GraphQL transport wrappers).
  public let httpCode: Int
  /// Optional server exception traceback and message for diagnostics.
  public let exception: Exception?
  /// Facebook profile metadata returned during `.ConfirmFacebookSignup` login flows.
  public let facebookUser: FacebookUser?
  /// Structured GraphQL error payload when the failure originated from Apollo/GraphQL.
  public let graphError: GraphError?
  /// Explicit RFC 9457 remediation instruction guiding the caller or AI agent on how to recover from this error.
  public let suggestedAction: String
  /// Indicates whether the failed request can be safely retried (with backoff or idempotency key).
  public let isRetriable: Bool
  internal let data: AltErrorMessage?

  /// Constructs an `ErrorEnvelope`, automatically resolving `suggestedAction` and `isRetriable` when omitted.
  public init(
    errorMessages: [String],
    ksrCode: KsrCode?,
    httpCode: Int,
    exception: Exception?,
    facebookUser: FacebookUser? = nil,
    graphError: GraphError? = nil,
    suggestedAction: String? = nil,
    isRetriable: Bool? = nil
  ) {
    self.errorMessages = errorMessages
    self.ksrCode = ksrCode
    self.httpCode = httpCode
    self.exception = exception
    self.facebookUser = facebookUser
    self.graphError = graphError
    self.suggestedAction = suggestedAction ?? Self.resolveSuggestedAction(
      ksrCode: ksrCode,
      httpCode: httpCode,
      graphError: graphError
    )
    self.isRetriable = isRetriable ?? Self.resolveIsRetriable(
      ksrCode: ksrCode,
      httpCode: httpCode,
      graphError: graphError
    )
    self.data = nil
  }

  /// Machine-readable Kickstarter server and client error classification codes.
  public enum KsrCode: String {
    // Codes defined by the server
    /// Returned when the OAuth token is expired or revoked. Recover by re-authenticating or refreshing the OAuth token via `AuthController`.
    case AccessTokenInvalid = "access_token_invalid"
    /// Returned when a Facebook login requires explicit account creation confirmation. Recover by prompting the user to confirm signup or calling `signup(facebookAccessToken:sendNewsletters:)`.
    case ConfirmFacebookSignup = "confirm_facebook_signup"
    /// Returned when the Facebook account is already linked to another Kickstarter user. Recover by signing in with that existing account instead of connecting.
    case FacebookConnectAccountTaken = "facebook_connect_account_taken"
    /// Returned when the Facebook account's email address is already registered on Kickstarter. Recover by logging in with email/password and linking the account.
    case FacebookConnectEmailTaken = "facebook_connect_email_taken"
    /// Returned when the Facebook SDK token is expired or malformed. Recover by requesting a fresh Facebook access token before retrying.
    case FacebookInvalidAccessToken = "facebook_invalid_access_token"
    /// Returned when email/password credentials fail xAuth validation. Do not retry with identical credentials; prompt for valid credentials or password reset.
    case InvalidXauthLogin = "invalid_xauth_login"
    /// Returned when the Facebook profile does not grant email permission. Recover by re-requesting Facebook `email` scope or signing up with an explicit email.
    case MissingFacebookEmail = "missing_facebook_email"
    /// Returned when the 2FA verification code is invalid or expired. Recover by requesting a fresh 6-digit TOTP/SMS code from the user.
    case TfaFailed = "tfa_failed"
    /// Returned when login credentials are valid but two-factor authentication is enabled. Recover by re-submitting `login(email:password:code:)` with the user's 2FA code.
    case TfaRequired = "tfa_required"

    // Catch all code for when server sends code we don't know about yet
    /// Fallback code when the server returns an unrecognized `ksr_code`. Inspect `httpCode` and `errorMessages` for remediation details.
    case UnknownCode = "__internal_unknown_code"

    // Codes defined by the client
    /// Emitted when raw HTTP response bytes cannot be parsed as valid JSON. Verify endpoint URL and server `Content-Type: application/json`.
    case JSONParsingFailed = "json_parsing_failed"
    /// Emitted when an HTTP error response body cannot be parsed into `ErrorEnvelope`. Inspect raw HTTP status code and retry if 5xx.
    case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
    /// Emitted when `JSONDecoder` fails to decode a response payload into the target model. Check `errorMessages` for the mismatched coding path.
    case DecodingJSONFailed = "decoding_json_failed"
    /// Emitted when a pagination cursor/URL is malformed. Do not retry with the same URL; re-fetch the initial page to obtain a fresh cursor.
    case InvalidPaginationUrl = "invalid_pagination_url"
    /// Emitted when a GraphQL operation returns top-level `errors`. Inspect `errorMessages` and validate query/mutation input variables.
    case GraphQLError = "graphql_error"
    /// Emitted when `validateCheckout` rejects the checkout state, payment source, or reward availability. Re-validate pledge amount, shipping rule, and payment method before retrying.
    case ValidateCheckoutError = "validate_checkout_error"
  }

  /// Alternate error wrapper returned by certain `www` pledge validation endpoints.
  public struct AltErrorMessage: Decodable {
    /// Nested validation error details.
    public let errors: AltErrorDetails

    /// Field-level validation messages extracted from `amount` or `backer_reward`.
    public struct AltErrorDetails {
      /// Validation failure messages returned by the server.
      public let details: [String]
    }
  }

  /// Server exception metadata included on unhandled 5xx responses when available.
  public struct Exception: Decodable {
    /// Stack frames emitted by the backend, if exposed.
    public let backtrace: [String]?
    /// Exception summary message, if exposed.
    public let message: String?
  }

  /// Partial Facebook user details surfaced when an account needs confirmation to complete signup.
  public struct FacebookUser: Decodable {
    /// Facebook user identifier string.
    public let id: String
    /// Full display name reported by Facebook.
    public let name: String
    /// Email address reported by Facebook.
    public let email: String
  }

  /**
   A general error that JSON could not be parsed.
   */
  internal static let couldNotParseJSON = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .JSONParsingFailed,
    httpCode: 400,
    exception: nil,
    facebookUser: nil,
    graphError: nil
  )

  /**
   A general error that the error envelope JSON could not be parsed.
   */
  internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .ErrorEnvelopeJSONParsingFailed,
    httpCode: 400,
    exception: nil,
    facebookUser: nil,
    graphError: nil
  )

  /**
   A general error that some JSON could not be decoded.

   - parameter decodeError: The JSONDecoder decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static func couldNotDecodeJSON(_ decodeError: Error) -> ErrorEnvelope {
    let errorMessage: String
    if let jsonDecodeError = decodeError as? DecodingError {
      errorMessage = jsonDecodeError.prettyDescription
    } else {
      errorMessage = "Could not decode JSON (with unknown error)"
    }

    return ErrorEnvelope(
      errorMessages: [errorMessage],
      ksrCode: .DecodingJSONFailed,
      httpCode: 400,
      exception: nil,
      facebookUser: nil,
      graphError: nil
    )
  }

  /**
   A error that the pagination URL is invalid.

   - parameter decodeError: The Decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static let invalidPaginationUrl = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .InvalidPaginationUrl,
    httpCode: 400,
    exception: nil,
    facebookUser: nil,
    graphError: nil
  )

  internal static func graphError(_ message: String) -> ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: [message],
      ksrCode: .GraphQLError,
      httpCode: 200,
      exception: nil
    )
  }

  /**
   An error that that occurs when the current checkout is invalid.

   - parameter message: The error message returned from the server.

   - returns: An error envelope that describes why the validation failed.
   */
  internal static func validateCheckoutError(_ message: [String]) -> ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: message,
      ksrCode: .ValidateCheckoutError,
      httpCode: 200,
      exception: nil
    )
  }
}
