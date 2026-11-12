import Foundation

extension ErrorEnvelope: Error {}

extension ErrorEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case errorMessages = "error_messages"
    case ksrCode = "ksr_code"
    case httpCode = "http_code"
    case status
    case data
    case exception
    case facebookUser = "facebook_user"
    case suggestedAction = "suggested_action"
    case isRetriable = "is_retriable"
  }

  /// Decodes either the standard v1 API error payload or the alternate `www` validation error format.
  public init(from decoder: Decoder) throws {
    // sometimes we make requests to the www server and JSON errors come back in a different envelope
    let values = try decoder.container(keyedBy: CodingKeys.self)
    if values.contains(.httpCode) {
      self.errorMessages = try values.decode([String].self, forKey: .errorMessages)
      let decodedKsrCode = try values.decodeIfPresent(KsrCode.self, forKey: .ksrCode)
      let decodedHttpCode = try values.decode(Int.self, forKey: .httpCode)
      self.ksrCode = decodedKsrCode
      self.httpCode = decodedHttpCode
      self.exception = try values.decodeIfPresent(Exception.self, forKey: .exception)
      self.facebookUser = try values.decodeIfPresent(FacebookUser.self, forKey: .facebookUser)
      self.graphError = nil
      self.suggestedAction = try values.decodeIfPresent(String.self, forKey: .suggestedAction)
        ?? Self.resolveSuggestedAction(ksrCode: decodedKsrCode, httpCode: decodedHttpCode, graphError: nil)
      self.isRetriable = try values.decodeIfPresent(Bool.self, forKey: .isRetriable)
        ?? Self.resolveIsRetriable(ksrCode: decodedKsrCode, httpCode: decodedHttpCode, graphError: nil)
      self.data = nil
    } else {
      self.data = try values.decodeIfPresent(ErrorEnvelope.AltErrorMessage.self, forKey: .data)
      self.errorMessages = self.data?.errors.details ?? []
      let decodedKsrCode = ErrorEnvelope.KsrCode.UnknownCode
      let decodedHttpCode = try values.decode(Int.self, forKey: .status)
      self.ksrCode = decodedKsrCode
      self.httpCode = decodedHttpCode
      self.exception = nil
      self.facebookUser = nil
      self.graphError = nil
      self.suggestedAction = try values.decodeIfPresent(String.self, forKey: .suggestedAction)
        ?? Self.resolveSuggestedAction(ksrCode: decodedKsrCode, httpCode: decodedHttpCode, graphError: nil)
      self.isRetriable = try values.decodeIfPresent(Bool.self, forKey: .isRetriable)
        ?? Self.resolveIsRetriable(ksrCode: decodedKsrCode, httpCode: decodedHttpCode, graphError: nil)
    }
  }
}

extension ErrorEnvelope.AltErrorMessage.AltErrorDetails: Decodable {
  enum CodingKeys: String, CodingKey {
    case amount
    case backerReward = "backer_reward"
  }

  /// Decodes validation error details keyed under either `amount` or `backer_reward`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.details = try values.decodeIfPresent([String].self, forKey: .amount) ?? values
      .decode([String].self, forKey: .backerReward)
  }
}

extension ErrorEnvelope.KsrCode: Decodable {
  /// Decodes a known `KsrCode` string or falls back to `.UnknownCode`.
  public init(from decoder: Decoder) throws {
    self = try ErrorEnvelope
      .KsrCode(rawValue: decoder.singleValueContainer().decode(String.self)) ?? ErrorEnvelope.KsrCode
      .UnknownCode
  }
}

// MARK: - GraphError

// FIXME: We should try to included error messages and/or httpCode
extension ErrorEnvelope {
  /// Wraps a `GraphError` into an `ErrorEnvelope` with default recovery guidance.
  public static func envelope(from graphError: GraphError) -> ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: [],
      ksrCode: nil,
      httpCode: 0,
      exception: nil,
      graphError: graphError
    )
  }
}
