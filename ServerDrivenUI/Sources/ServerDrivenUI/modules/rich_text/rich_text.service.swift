import Foundation
import KsApi

// MARK: - Rule 1: Strangler Fig Legacy Adapter for ServerDrivenUI RichTextElement

/// Bridge protocol abstracting legacy rich text tree normalization.
public protocol RichTextNormalizerBridgeProtocol {
  /// Normalizes nested rich text elements into sibling renderable blocks.
  func normalize(elements: [RichTextElement]) -> [RichTextElement]
}

/// Legacy adapter delegating normalization to `Array.withNormalizedNestedElements()`.
public final class LegacyRichTextNormalizerAdapter: RichTextNormalizerBridgeProtocol {
  /// Creates a legacy rich text normalizer adapter.
  public init() {}

  /// Normalizes nested rich text elements into sibling renderable blocks.
  public func normalize(elements: [RichTextElement]) -> [RichTextElement] {
    elements.withNormalizedNestedElements()
  }
}

// MARK: - Rule 2 & Rule 5: RichText Module Service

/// Domain service validating and normalizing rich text payloads with rate-limit enforcement.
public final class RichTextModuleService {
  private let bridge: RichTextNormalizerBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int

  /// Initializes the service with a normalizer bridge and machine-tempo rate limit quota.
  public init(
    bridge: RichTextNormalizerBridgeProtocol = LegacyRichTextNormalizerAdapter(),
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Validates and normalizes the incoming request schema into an `AXServiceResponse`.
  public func normalizeRichText(
    schema: NormalizeRichTextRequestSchema
  ) -> Result<AXServiceResponse<RichTextNormalizationContract>, AXProblemDetails> {
    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) RichText normalizations exceeded.",
        suggestedAction: "Wait 15 seconds before re-normalizing RichText blocks.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      ))
    }
    self.remainingQuota -= 1

    return schema.validate().map { elements in
      let normalized = self.bridge.normalize(elements: elements)
      let contracts = normalized.map(Self.mapElementToContract)
      let output = RichTextNormalizationContract(
        inputNodeCount: elements.count,
        normalizedBlockCount: contracts.count,
        blocks: contracts
      )
      return AXServiceResponse(
        value: output,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      )
    }
  }

  private static func mapElementToContract(_ element: RichTextElement) -> NormalizedRichTextBlockContract {
    switch element {
    case let .text(text, _):
      let combinedText = ([text.text] + text.children.compactMap { child -> String? in
        if case let .text(childText, _) = child { return childText.text }
        return nil
      }).filter { !$0.isEmpty }.joined()
      return NormalizedRichTextBlockContract(
        blockKind: "text",
        text: combinedText,
        photoURL: nil,
        linkURL: text.link?.absoluteString
      )
    case let .photo(photo):
      return NormalizedRichTextBlockContract(
        blockKind: "photo",
        text: photo.altText,
        photoURL: photo.url,
        linkURL: photo.link?.absoluteString
      )
    case let .listItem(text):
      return NormalizedRichTextBlockContract(
        blockKind: "listItem",
        text: text.text,
        photoURL: nil,
        linkURL: text.link?.absoluteString
      )
    default:
      return NormalizedRichTextBlockContract(blockKind: "other", text: nil, photoURL: nil, linkURL: nil)
    }
  }
}

