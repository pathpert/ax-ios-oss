import Foundation
import GraphAPI
/**
 TODO:
 This model is meant to replace `Project` which has almost been converted to use GraphQL properties.

 We're not replacing it completely right now because it has a lot of large dependencies to other models (`Backing`, `User`, `Reward`).

 Also a lot of `/v1/` endpoints still use this model so we cannot completely clean-up/remove/re-think and adjust in-app functionality to address each property's use-cases.

 This property will eventually replace `Project`, but right now we're using it to build out additional functionality that only comes from GraphQL.
 */

/// Supplementary GraphQL-backed project properties staged to eventually replace `Project`.
///
/// Negative Constraint: Do not assume these fields exist on v1 REST `Project` payloads; read from `ExtendedProjectProperties` after GraphQL queries.
public struct ExtendedProjectProperties {
  /// Environmental commitment statements published on the campaign page.
  public var environmentalCommitments: [ProjectTabCategoryDescription]
  /// Creator-curated frequently asked questions for the campaign.
  public var faqs: [ProjectFAQ]
  /// Structured disclosure describing how AI tools or outputs are used by the project.
  public var aiDisclosure: ProjectAIDisclosure?
  /// Creator-authored risks and challenges markdown/plain text section.
  public var risks: String
  /// Parsed campaign story elements and optional rich-text blocks.
  public var story: ProjectStoryElements
  /// Minimum pledge threshold in whole currency units (or project base units).
  public var minimumPledgeAmount: Int
  /// Optional moderation/trust notice shown at the top of the project page.
  public var projectNotice: String?

  /// Creates an `ExtendedProjectProperties` container.
  public init(
    environmentalCommitments: [ProjectTabCategoryDescription],
    faqs: [ProjectFAQ],
    aiDisclosure: ProjectAIDisclosure?,
    risks: String,
    story: ProjectStoryElements,
    minimumPledgeAmount: Int,
    projectNotice: String?
  ) {
    self.environmentalCommitments = environmentalCommitments
    self.faqs = faqs
    self.aiDisclosure = aiDisclosure
    self.risks = risks
    self.story = story
    self.minimumPledgeAmount = minimumPledgeAmount
    self.projectNotice = projectNotice
  }
}

/// Structured AI usage disclosure metadata surfaced in the project risks/AI tab.
public struct ProjectAIDisclosure {
  /// Numeric identifier of the AI disclosure record.
  public var id: Int
  /// Flags indicating whether AI usage is funded for attribution, consent, or opt-in licensing.
  public var funding: ProjectTabFundingOptions
  /// Details and consent text for generative AI outputs, if applicable.
  public var generationDisclosure: ProjectTabGenerationDisclosure?
  /// `true` if the project uses AI in any capacity.
  public var involvesAi: Bool
  /// `true` if the project disclosed ethical/licensed AI funding choices.
  public var involvesFunding: Bool
  /// `true` if the project uses generative AI media or text.
  public var involvesGeneration: Bool
  /// `true` if the project discloses non-generative AI involvement.
  public var involvesOther: Bool
  /// Narrative description of other AI usage when `involvesOther == true`.
  public var otherAiDetails: ProjectTabCategoryDescription?
}

/// Single creator FAQ entry rendered on the project FAQ tab.
public struct ProjectFAQ {
  /// Creator's answer copy.
  public var answer: String
  /// Question headline.
  public var question: String
  /// Numeric FAQ identifier.
  public var id: Int
  /// Unix timestamp (seconds) when the FAQ was created, if available.
  public var createdAt: TimeInterval?
}

/// Combined legacy HTML elements and GraphQL rich-text fragments representing the campaign story.
public struct ProjectStoryElements {
  /// Ordered legacy HTML view elements parsed from the campaign story body.
  public var htmlViewElements: [HTMLViewElement]
  /// GraphQL rich-text component fragment when available.
  public var richText: RichTextComponentFragment?

  /// Creates a `ProjectStoryElements` value.
  public init(
    htmlViewElements: [HTMLViewElement],
    richText: RichTextComponentFragment? = nil
  ) {
    self.htmlViewElements = htmlViewElements
    self.richText = richText
  }
}

/// Categorized Sustainability or AI disclosure bullet displayed on the project tabs.
public struct ProjectTabCategoryDescription {
  /// Localized or creator-supplied explanation text.
  public var description: String
  /// Category taxonomy identifying which sustainability or AI section owns this item.
  public var category: ProjectTabCategory
  /// Numeric identifier of the category description entry.
  public var id: Int
}

/// Disclosure text describing consent and methodology for AI-generated content.
public struct ProjectTabGenerationDisclosure: Equatable {
  /// Consent status or explanation provided by the creator.
  public var consent: String?
  /// Freeform details on generative AI tooling and workflow.
  public var details: String?
}

/// Flags describing funding commitments related to ethical AI data licensing.
public struct ProjectTabFundingOptions {
  /// `true` when AI training attribution funding is disclosed.
  public var fundingForAiAttribution: Bool
  /// `true` when explicit creator consent funding is disclosed.
  public var fundingForAiConsent: Bool
  /// `true` when opt-in data licensing funding is disclosed.
  public var fundingForAiOption: Bool
}

/// Sustainability and AI disclosure category labels used in project tab breakdowns.
public enum ProjectTabCategory: String {
  /// Durable product design intended for extended lifespan.
  case longLastingDesign = "Long-lasting design"
  /// Recycled, renewable, or low-impact physical materials.
  case sustainableMaterials = "Sustainable materials"
  /// Verified eco-conscious manufacturing facilities.
  case environmentallyFriendlyFactories = "Environmentally friendly factories"
  /// Low-emission logistics and packaging practices.
  case sustainableDistribution = "Sustainable distribution"
  /// Recyclable or reusable end-of-life product design.
  case reusabilityAndRecyclability = "Reusability and Recyclability"
  /// Freeform other AI disclosure category.
  case aiDisclosureOtherDetails
  /// Fallback sustainability category.
  case somethingElse
}

/// Categories of AI licensing/consent funding tracked in analytics and UI badges.
public enum ProjectTabAIFundingCategory: String {
  /// Explicit consent funding category.
  case consent
  /// Creator attribution funding category.
  case attribution
  /// Opt-in compensation funding category.
  case option
}
