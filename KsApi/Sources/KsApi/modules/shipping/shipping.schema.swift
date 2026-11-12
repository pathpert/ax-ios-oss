import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Reward Shipping Rules & Backer Surveys (KsApi)

/// Poka-Yoke request schema for querying shipping rules applicable to a physical reward tier.
///
/// - Negative constraint: Both `projectId` and `rewardId` must be `> 0`; do not pass `rewardId == 0` (No Reward tier).
public struct FetchShippingRulesRequestSchema: Codable, Equatable, Sendable {
  /// Positive integer identifier of the project.
  public let projectId: Int
  /// Positive integer identifier of the physical reward tier.
  public let rewardId: Int

  /// Field-level descriptors and negative constraints for `FetchShippingRulesRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "projectId": .describe(
      field: "projectId",
      meaning: "Positive integer identifier of the project.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 or negative project IDs."
      ]
    ),
    "rewardId": .describe(
      field: "rewardId",
      meaning: "Positive integer identifier of the reward tier requiring shipping.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 (No Reward tier) or negative reward IDs when querying physical shipping rules.",
        "Do not consume legacy ShippingRule.cost floating-point Doubles; consume ShippingRuleItemContract.costInCents."
      ]
    )
  ]

  /// Creates a `FetchShippingRulesRequestSchema` payload.
  public init(projectId: Int, rewardId: Int) {
    self.projectId = projectId
    self.rewardId = rewardId
  }

  /// Validates that both `projectId` and `rewardId` are positive integers (`> 0`).
  public func validate() -> Result<(Int, Int), AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.projectId <= 0 {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be a positive integer > 0."))
    }

    if self.rewardId <= 0 {
      violations.append(AXInvalidParam(
        name: "rewardId",
        reason: "Must be a positive integer > 0 (physical reward tiers only; do not pass 0 / No Reward)."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Shipping Rules Query",
        status: 400,
        detail: "Shipping rules query failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide positive integer projectId (> 0) and rewardId (> 0).",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success((self.projectId, self.rewardId))
  }
}

/// Poka-Yoke request schema for fetching a single backer survey response.
public struct FetchSurveyResponseRequestSchema: Codable, Equatable, Sendable {
  /// Positive integer identifier of the backer survey response.
  public let surveyResponseId: Int

  /// Creates a `FetchSurveyResponseRequestSchema` payload.
  public init(surveyResponseId: Int) {
    self.surveyResponseId = surveyResponseId
  }

  /// Validates that `surveyResponseId` is a positive integer (`> 0`).
  public func validate() -> Result<Int, AXProblemDetails> {
    guard self.surveyResponseId > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Survey Response ID",
        status: 400,
        detail: "surveyResponseId must be a positive integer > 0.",
        suggestedAction: "Provide a positive integer surveyResponseId (> 0).",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "surveyResponseId", reason: "Must be > 0.")]
      ))
    }
    return .success(self.surveyResponseId)
  }
}

/// Normalized shipping rule contract expressing cost in integer minor-unit cents.
public struct ShippingRuleItemContract: Codable, Equatable, Sendable {
  /// Optional shipping rule record identifier.
  public let ruleId: Int?
  /// Destination location numeric identifier.
  public let locationId: Int
  /// Localized display name for the destination location.
  public let locationDisplayableName: String
  /// ISO country code for the destination.
  public let countryCode: String
  /// Shipping surcharge in integer minor currency units (cents).
  public let costInCents: Int
}

/// Collection of shipping rules returned for `(projectId, rewardId)`.
public struct ShippingRulesContract: Codable, Equatable, Sendable {
  /// Project identifier.
  public let projectId: Int
  /// Physical reward identifier.
  public let rewardId: Int
  /// Eligible shipping destinations and integer-cent costs.
  public let rules: [ShippingRuleItemContract]
}

/// Read contract describing a backer's survey link and completion status.
public struct SurveyResponseContract: Codable, Equatable, Sendable {
  /// Positive survey response identifier.
  public let surveyResponseId: Int
  /// Hosted web survey completion URL.
  public let webSurveyURL: String
  /// Whether the backer has already submitted the survey.
  public let isAnswered: Bool
}

