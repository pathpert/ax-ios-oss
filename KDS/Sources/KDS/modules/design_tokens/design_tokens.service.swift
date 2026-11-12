import Foundation

// MARK: - Rule 1: Strangler Fig Adapter for KDS Colors & Spacing

/// Legacy bridge abstracting semantic color resolution from KDS `Colors`.
public protocol DesignTokensLegacyBridgeProtocol {
  /// Resolves a semantic color token by its slash-delimited name, or returns `nil` if unknown.
  func resolveSemanticColor(name: String) -> SemanticColor?
}

/// Adapter mapping canonical design token names to KDS `Colors` semantic color definitions.
public final class LegacyKDSDesignTokensAdapter: DesignTokensLegacyBridgeProtocol {
  private let catalog: [String: SemanticColor] = [
    "scrim": Colors.scrim,
    "text/primary": Colors.Text.primary,
    "text/secondary": Colors.Text.secondary,
    "text/disabled": Colors.Text.disabled,
    "text/placeholder": Colors.Text.placeholder,
    "text/light": Colors.Text.light,
    "text/accent/gray": Colors.Text.Accent.gray,
    "text/accent/green": Colors.Text.Accent.green,
    "text/accent/red": Colors.Text.Accent.red
  ]

  /// Creates an instance of the KDS semantic color catalog adapter.
  public init() {}

  /// Resolves a semantic color token from the internal catalog by name.
  public func resolveSemanticColor(name: String) -> SemanticColor? {
    self.catalog[name]
  }

  /// Sorted list of all supported semantic color token names.
  public var supportedTokenNames: [String] {
    self.catalog.keys.sorted()
  }
}

// MARK: - Rule 2 & Rule 5: KDS Design Tokens Module Service

/// Domain service resolving KDS spacing and semantic color tokens with validation and rate limiting.
public final class DesignTokensModuleService {
  private let adapter: LegacyKDSDesignTokensAdapter
  private let rateLimitMax: Int
  private var remainingQuota: Int

  /// Initializes the service with an adapter and machine-tempo rate limit quota.
  public init(
    adapter: LegacyKDSDesignTokensAdapter = LegacyKDSDesignTokensAdapter(),
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil
  ) {
    self.adapter = adapter
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Validates a spacing unit request and returns the resolved spacing token contract.
  public func resolveSpacing(
    schema: ResolveSpacingTokenRequestSchema
  ) -> Result<(SpacingTokenContract, AXDesignTokenRateLimitHeaders), AXDesignTokenProblemDetails> {
    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().map { index, points in
      let formatted = String(format: "Spacing.unit_%02d", index)
      let contract = SpacingTokenContract(tokenIdentifier: formatted, unitIndex: index, points: points)
      return (contract, AXDesignTokenRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota))
    }
  }

  /// Validates a semantic color name and opacity percentage and returns the token contract.
  public func resolveSemanticColor(
    schema: ResolveSemanticColorRequestSchema
  ) -> Result<(SemanticColorTokenContract, AXDesignTokenRateLimitHeaders), AXDesignTokenProblemDetails> {
    if let err = self.consumeQuota() { return .failure(err) }

    var violations: [AXDesignTokenInvalidParam] = []
    let trimmed = schema.tokenName.trimmingCharacters(in: .whitespacesAndNewlines)

    if self.adapter.resolveSemanticColor(name: trimmed) == nil {
      let allowed = self.adapter.supportedTokenNames.joined(separator: ", ")
      violations.append(AXDesignTokenInvalidParam(
        name: "tokenName",
        reason: "Unknown semantic color '\(schema.tokenName)'. Supported tokens: \(allowed)."
      ))
    }

    if schema.opacityPercent < 1 || schema.opacityPercent > 100 {
      violations.append(AXDesignTokenInvalidParam(
        name: "opacityPercent",
        reason: "Must be an integer percentage between 1 and 100."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXDesignTokenProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-design-token",
        title: "Invalid Design Token",
        status: 400,
        detail: "Semantic color resolution failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide a registered KDS semantic color tokenName and an integer opacityPercent in 1...100.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    let contract = SemanticColorTokenContract(tokenName: trimmed, opacityPercent: schema.opacityPercent)
    return .success((contract, AXDesignTokenRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)))
  }

  private func consumeQuota() -> AXDesignTokenProblemDetails? {
    guard self.remainingQuota > 0 else {
      let headers = AXDesignTokenRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      return AXDesignTokenProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit exceeded on KDS design_tokens module.",
        suggestedAction: "Cache resolved design tokens and wait 15 seconds before re-querying.",
        isRetriable: true,
        rateLimitHeaders: headers
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

