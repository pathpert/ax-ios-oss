import AVFoundation
import KsApi
import Library
import UIKit

extension ProjectPageViewControllerDataSource {
  /// Localized section titles used in `ProjectHeaderCell`.
  enum HeaderValue {
    case overview
    case campaign
    case environmentalCommitments
    case faqs
    case risks
    case aiDisclosure

    var description: String {
      switch self {
      case .overview:
        return Strings.Overview()
      case .campaign:
        return Strings.Campaign()
      case .environmentalCommitments:
        return Strings.Environmental_commitments()
      case .faqs:
        return Strings.Frequently_asked_questions()
      case .risks:
        return Strings.Risks_and_challenges()
      case .aiDisclosure:
        return Strings.Use_of_ai()
      }
    }
  }

  /// Localized question headers used for AI-generated content sections.
  enum GeneratedAIQuestionHeaderValue {
    case doYouHaveConsentOfOwners
    case partsOfProjectAIGenerated

    var description: String {
      switch self {
      case .doYouHaveConsentOfOwners:
        return Strings.Do_you_have_the_consent_of_the_owners_of_the_works_used_for_AI()
      case .partsOfProjectAIGenerated:
        return Strings.What_parts_of_your_project_will_use_AI_generated_content()
      }
    }
  }

  /// Populates overview section cells for a resolved project and optional prelaunch/similar states.
  func loadOverviewSection(
    project: Project,
    refTag: RefTag?,
    similarProjectsState: SimilarProjectsState?
  ) {
    if currentUserIsCreator(of: project) {
      self.set(
        values: [project],
        cellClass: ProjectPamphletCreatorHeaderCell.self,
        inSection: Section.overviewCreatorHeader.rawValue
      )
    }

    self.set(
      values: [(project, refTag)],
      cellClass: ProjectPamphletMainCell.self,
      inSection: Section.overview.rawValue
    )

    guard let displayPrelaunch = project.displayPrelaunch, !displayPrelaunch else { return }

    let values: [ProjectPamphletSubpage] = [
      .comments(project.stats.commentsCount as Int?, .first),
      .updates(project.stats.updatesCount as Int?, .middle)
    ]

    self.set(
      values: values,
      cellClass: ProjectPamphletSubpageCell.self,
      inSection: Section.overviewSubpages.rawValue
    )

    if AppEnvironment.current.currentUser != nil {
      self.set(
        values: [project.flagging ?? false],
        cellClass: ReportProjectCell.self,
        inSection: Section.overviewReportProject.rawValue
      )
    }

    if let state = similarProjectsState {
      // Do not show this cell if there's an error. Proper error handling UI will be designed in SPC V2.
      switch state {
      case .error, .hidden:
        return
      default:
        self.set(
          values: [state],
          cellClass: SimilarProjectsTableViewCell.self,
          inSection: Section.overviewSimilarProjects.rawValue
        )
      }
    }
  }

  /// Populates campaign story HTML elements while preserving preloaded images and audio/video players.
  func loadCampaignSection(project: Project) {
    self.set(
      values: [HeaderValue.campaign.description],
      cellClass: ProjectHeaderCell.self,
      inSection: Section.campaignHeader.rawValue
    )

    let htmlViewElements = project.extendedProjectProperties?.story.htmlViewElements ?? []

    htmlViewElements.forEach { element in
      switch element {
      case let element as TextViewElement:
        self.appendRow(value: element, cellClass: TextViewElementCell.self, toSection: Section.campaign.rawValue)
      case let element as ImageViewElement:
        let preExistingElementImage = self.preexistingImageViewElementsWithData
          .first { $0.element.src == element.src }?.image
        let value = preExistingElementImage != nil ? (element, preExistingElementImage) : (element, nil)
        self.appendRow(value: value, cellClass: ImageViewElementCell.self, toSection: Section.campaign.rawValue)
      case let element as AudioVideoViewElement:
        let preExistingAudioVideo = self.preexistingAudioVideoViewElementsWithPlayer
          .first { $0.0.sourceURLString == element.sourceURLString }
        let elementWithPlayer = (element, preExistingAudioVideo?.player, preExistingAudioVideo?.image)
        self.appendRow(
          value: elementWithPlayer,
          cellClass: AudioVideoViewElementCell.self,
          toSection: Section.campaign.rawValue
        )
      case let element as ExternalSourceViewElement:
        self.appendRow(
          value: element,
          cellClass: ExternalSourceViewElementCell.self,
          toSection: Section.campaign.rawValue
        )
      default:
        break
      }
    }
  }

  /// Populates FAQ header, ask-a-question prompt, empty state, and expandable FAQ rows.
  func loadFAQSection(project: Project, isExpandedStates: [Bool]?) {
    self.set(
      values: [HeaderValue.faqs.description],
      cellClass: ProjectHeaderCell.self,
      inSection: Section.faqsHeader.rawValue
    )

    if AppEnvironment.current.currentUser != nil {
      self.set(
        values: [()],
        cellClass: ProjectFAQsAskAQuestionCell.self,
        inSection: Section.faqsAskAQuestion.rawValue
      )
    }

    let projectFAQs = project.extendedProjectProperties?.faqs ?? []
    guard !projectFAQs.isEmpty else {
      self.set(
        values: [()],
        cellClass: ProjectFAQsEmptyStateCell.self,
        inSection: Section.faqsEmpty.rawValue
      )
      return
    }

    guard let isExpandedStates = isExpandedStates else { return }

    let values = projectFAQs.enumerated().map { idx, faq in (faq, isExpandedStates[idx]) }
    self.set(values: values, cellClass: ProjectFAQsCell.self, inSection: Section.faqs.rawValue)
  }

  /// Populates risks copy and disclaimer cells.
  func loadRisksSection(project: Project) {
    let risks = project.extendedProjectProperties?.risks ?? ""

    self.set(
      values: [HeaderValue.risks.description],
      cellClass: ProjectHeaderCell.self,
      inSection: Section.risksHeader.rawValue
    )
    self.set(values: [risks], cellClass: ProjectRisksCell.self, inSection: Section.risks.rawValue)
    self.set(values: [()], cellClass: ProjectRisksDisclaimerCell.self, inSection: Section.risksDisclaimer.rawValue)
  }

  /// Populates AI funding, generation, and details disclosures.
  func loadAIDisclosureSection(project: Project) {
    self.set(
      values: [HeaderValue.aiDisclosure.description],
      cellClass: ProjectHeaderCell.self,
      inSection: Section.aiDisclosureHeader.rawValue
    )

    guard let aiDisclosure = project.extendedProjectProperties?.aiDisclosure else {
      self.set(
        values: [.aiDisclosure],
        cellClass: ProjectTabDisclaimerCell.self,
        inSection: Section.aiDisclosureDisclaimer.rawValue
      )
      return
    }

    let fundingAvailable = aiDisclosure.funding.fundingForAiAttribution
      || aiDisclosure.funding.fundingForAiConsent
      || aiDisclosure.funding.fundingForAiOption
    if fundingAvailable && aiDisclosure.involvesFunding {
      self.set(
        values: [aiDisclosure.funding],
        cellClass: ProjectTabCheckmarkListCell.self,
        inSection: Section.aiDisclosureFunding.rawValue
      )
    }

    if aiDisclosure.involvesGeneration, let generationDisclosure = aiDisclosure.generationDisclosure {
      self.set(
        values: [generationDisclosure],
        cellClass: ProjectTabAIGenerationCell.self,
        inSection: Section.aiDisclosureGenerated.rawValue
      )
    }

    if let otherAIDetailValues = aiDisclosure.otherAiDetails, aiDisclosure.involvesOther {
      self.set(
        values: [otherAIDetailValues],
        cellClass: ProjectTabCategoryDescriptionCell.self,
        inSection: Section.aiDisclosureOtherDetails.rawValue
      )
    }

    self.set(
      values: [.aiDisclosure],
      cellClass: ProjectTabDisclaimerCell.self,
      inSection: Section.aiDisclosureDisclaimer.rawValue
    )
  }

  /// Populates environmental commitments cells and footer disclaimer.
  func loadEnvironmentalCommitmentsSection(project: Project) {
    let environmentalCommitments = project.extendedProjectProperties?.environmentalCommitments ?? []

    self.set(
      values: [HeaderValue.environmentalCommitments.description],
      cellClass: ProjectHeaderCell.self,
      inSection: Section.environmentalCommitmentsHeader.rawValue
    )
    self.set(
      values: environmentalCommitments,
      cellClass: ProjectTabCategoryDescriptionCell.self,
      inSection: Section.environmentalCommitments.rawValue
    )
    self.set(
      values: [.environmental],
      cellClass: ProjectTabDisclaimerCell.self,
      inSection: Section.environmentalCommitmentsDisclaimer.rawValue
    )
  }
}

