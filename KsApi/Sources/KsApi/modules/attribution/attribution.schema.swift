import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Attribution & Push Registration

/// Poka-Yoke request schema for firing a validated third-party attribution event.
///
/// - Negative constraint: Pass integer minor-unit cents (`pledgeAmountInCents`, `shippingAmountInCents`) rather than floating-point currency strings.
public struct TriggerThirdPartyEventRequestSchema: Codable, Equatable, Sendable {
  /// Vendor device UUID string (36 characters).
  public let deviceId: String
  /// Canonical third-party attribution event name (`1...64` characters, no whitespace).
  public let eventName: String
  /// Base64-encoded GraphQL Global ID of the attributed Project (`"Project-<id>"`).
  public let projectId: String
  /// Optional pledge amount in integer minor currency units (`>= 100` cents when provided).
  public let pledgeAmountInCents: Int?
  /// Optional shipping amount in integer minor currency units (`>= 0` cents when provided).
  public let shippingAmountInCents: Int?
  /// Optional backend transaction identifier for attribution deduplication.
  public let transactionId: String?
  /// Optional external user identifier associated with the conversion event.
  public let userId: String?

  /// Field-level descriptors and negative constraints for `TriggerThirdPartyEventRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "deviceId": .describe(
      field: "deviceId",
      meaning: "Vendor device UUID identifier.",
      format: "UUID v4 string (36 characters)",
      negativeConstraints: [
        "Do not pass empty or zeroed-out device identifiers.",
        "Do not pass raw hardware MAC addresses."
      ]
    ),
    "eventName": .describe(
      field: "eventName",
      meaning: "Canonical third-party attribution event name.",
      format: "Non-empty snake_case or PascalCase identifier (1..64 chars)",
      negativeConstraints: ["Do not pass whitespace-only strings or full URLs."]
    ),
    "projectId": .describe(
      field: "projectId",
      meaning: "Base64-encoded GraphQL ID of the attributed Project.",
      format: "Base64 string decoding to 'Project-<numeric_id>'",
      negativeConstraints: ["Do not pass raw integer project IDs or slugs."]
    ),
    "pledgeAmountInCents": .describe(
      field: "pledgeAmountInCents",
      meaning: "Optional attributed pledge amount in integer cents.",
      format: "Non-negative integer cents >= 100 or nil",
      negativeConstraints: [
        "Do not pass floating-point Double currency (replaces legacy pledgeAmount: Double?); use integer cents.",
        "Do not pass negative integers."
      ]
    ),
    "shippingAmountInCents": .describe(
      field: "shippingAmountInCents",
      meaning: "Optional attributed shipping amount in integer cents.",
      format: "Non-negative integer cents >= 0 or nil",
      negativeConstraints: [
        "Do not pass floating-point Double currency (replaces legacy shipping: Double?); use integer cents.",
        "Do not pass negative integers."
      ]
    )
  ]

  /// Creates a `TriggerThirdPartyEventRequestSchema` payload.
  public init(
    deviceId: String,
    eventName: String,
    projectId: String,
    pledgeAmountInCents: Int? = nil,
    shippingAmountInCents: Int? = nil,
    transactionId: String? = nil,
    userId: String? = nil
  ) {
    self.deviceId = deviceId
    self.eventName = eventName
    self.projectId = projectId
    self.pledgeAmountInCents = pledgeAmountInCents
    self.shippingAmountInCents = shippingAmountInCents
    self.transactionId = transactionId
    self.userId = userId
  }

  /// Validates UUID, GraphID, event name, and integer-cents currency boundaries.
  public func validate() -> Result<ValidatedThirdPartyEventContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if UUID(uuidString: self.deviceId) == nil {
      violations.append(AXInvalidParam(name: "deviceId", reason: "Must be a valid 36-character UUID string."))
    }
    let trimmedEvent = self.eventName.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedEvent.isEmpty || trimmedEvent.count > 64 || trimmedEvent.contains(" ") {
      violations.append(AXInvalidParam(name: "eventName", reason: "Must be 1..64 characters without spaces."))
    }
    if !CreateCheckoutRequestSchema.isValidGraphID(self.projectId, expectedPrefix: "Project-") {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be Base64 'Project-<id>'."))
    }
    if let pledge = self.pledgeAmountInCents, pledge < 100 {
      violations.append(AXInvalidParam(
        name: "pledgeAmountInCents",
        reason: "When present, must be integer cents >= 100. Do not pass floating-point currency."
      ))
    }
    if let shipping = self.shippingAmountInCents, shipping < 0 {
      violations.append(AXInvalidParam(
        name: "shippingAmountInCents",
        reason: "When present, must be non-negative integer cents >= 0."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "TriggerThirdPartyEvent request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a UUID deviceId, Base64 'Project-<id>', and integer cents for pledgeAmountInCents / shippingAmountInCents.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedThirdPartyEventContract(
      deviceId: self.deviceId.lowercased(),
      eventName: trimmedEvent,
      projectId: self.projectId,
      legacyPledgeDollars: self.pledgeAmountInCents.map { Double($0) / 100.0 },
      legacyShippingDollars: self.shippingAmountInCents.map { Double($0) / 100.0 },
      transactionId: self.transactionId,
      userId: self.userId
    ))
  }
}

/// Validated third-party attribution contract produced by `TriggerThirdPartyEventRequestSchema.validate()`.
public struct ValidatedThirdPartyEventContract: Equatable, Sendable {
  /// Lowercased UUID device identifier.
  public let deviceId: String
  /// Trimmed canonical attribution event name.
  public let eventName: String
  /// Validated Base64 `"Project-<id>"` GraphQL identifier.
  public let projectId: String
  /// Legacy decimal dollar representation converted from `pledgeAmountInCents` for GraphQL input bridging.
  public let legacyPledgeDollars: Double?
  /// Legacy decimal dollar representation converted from `shippingAmountInCents` for GraphQL input bridging.
  public let legacyShippingDollars: Double?
  /// Optional backend transaction identifier.
  public let transactionId: String?
  /// Optional external user identifier.
  public let userId: String?
}

/// Poka-Yoke request schema for registering a hex-encoded APNs push notification token.
public struct RegisterPushTokenRequestSchema: Codable, Equatable, Sendable {
  /// Hex-encoded APNs device token string (`64...256` hex characters, no brackets or spaces).
  public let apnsHexToken: String

  /// Field-level descriptors and negative constraints for `RegisterPushTokenRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "apnsHexToken": .describe(
      field: "apnsHexToken",
      meaning: "Hex-encoded Apple Push Notification service (APNs) device token.",
      format: "Hexadecimal string between 64 and 256 characters (0-9, a-f, A-F)",
      negativeConstraints: [
        "Do not pass angle brackets or spaces from raw NSData debug descriptions (e.g. '<deadbeef...>').",
        "Do not pass Firebase/Braze SDK keys in place of the APNs device token."
      ]
    )
  ]

  /// Creates a `RegisterPushTokenRequestSchema` payload.
  public init(apnsHexToken: String) {
    self.apnsHexToken = apnsHexToken
  }

  /// Validates APNs hexadecimal encoding and length (`64...256` hex digits).
  public func validate() -> Result<String, AXProblemDetails> {
    let trimmed = self.apnsHexToken.trimmingCharacters(in: .whitespacesAndNewlines)
    let isHex = trimmed.count >= 64 && trimmed.count <= 256 && trimmed.allSatisfy(\.isHexDigit)
    guard isHex else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "apnsHexToken must be a 64..256 character hexadecimal string without spaces or brackets.",
        suggestedAction: "Strip '<', '>', and spaces from the raw APNs token Data and encode as lowercase hex (>= 64 chars).",
        isRetriable: false,
        invalidParams: [AXInvalidParam(
          name: "apnsHexToken",
          reason: "Must be 64..256 hexadecimal characters."
        )]
      ))
    }
    return .success(trimmed.lowercased())
  }
}

