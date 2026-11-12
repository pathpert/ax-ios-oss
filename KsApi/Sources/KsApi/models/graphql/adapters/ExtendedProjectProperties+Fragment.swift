import Foundation
import GraphAPI

/**
 Returns a `ExtendedProjectProperties` object from `ExtendedProjectPropertiesFragment`
 */
/// `ExtendedProjectProperties` extensions declared in `ExtendedProjectProperties+Fragment.swift`.
internal extension ExtendedProjectProperties {
  static func extendedProject(
    from fragment: GraphAPI.ExtendedProjectPropertiesFragment
  ) -> ExtendedProjectProperties {
    let risks = fragment.risks
    let environmentalCommitments = extendedProjectEnvironmentalCommitments(from: fragment)
    let faqs = extendedProjectFAQs(from: fragment)
    let minimumSingleTierPledgeAmount = fragment.minPledge
    let aiDisclosure = extendedProjectAIDisclosure(from: fragment)
    let prelaunchStoryRichTextFragment = fragment.prelaunchStoryRichText.fragments.richTextComponentFragment
    let liveStoryRichTextFragment = fragment.storyRichText.fragments.richTextComponentFragment
    let launched = fragment.isLaunched

    let storyRichTextFragment = if launched {
      liveStoryRichTextFragment
    } else {
      prelaunchStoryRichTextFragment
    }

    return ExtendedProjectProperties(
      environmentalCommitments: environmentalCommitments,
      faqs: faqs,
      aiDisclosure: aiDisclosure,
      risks: risks,
      story: storyElements(from: fragment, storyRichText: storyRichTextFragment),
      minimumPledgeAmount: minimumSingleTierPledgeAmount,
      projectNotice: fragment.projectNotice
    )
  }
}

/**
 Returns a `ProjectStoryElements` object from `ExtendedProjectPropertiesFragment`
 */
private func storyElements(
  from fragment: GraphAPI.ExtendedProjectPropertiesFragment,
  storyRichText: GraphAPI.RichTextComponentFragment? = nil
) -> ProjectStoryElements {
  let viewElements = Project.htmlParser.parse(bodyHtml: fragment.story)
  var seenURLStrings = Set<String>()
  var htmlElementsWithUniqueAudioVideoViewElements = [HTMLViewElement]()

  for viewElement in viewElements {
    guard let audioVideoViewElement = viewElement as? AudioVideoViewElement else {
      htmlElementsWithUniqueAudioVideoViewElements.append(viewElement)
      continue
    }

    if !seenURLStrings.contains(audioVideoViewElement.sourceURLString) {
      htmlElementsWithUniqueAudioVideoViewElements.append(viewElement)
      seenURLStrings.insert(audioVideoViewElement.sourceURLString)
    }
  }

  return ProjectStoryElements(
    htmlViewElements: htmlElementsWithUniqueAudioVideoViewElements,
    richText: storyRichText
  )
}

/**
 Returns a `GraphQLProject.ProjectFAQ` from `ExtendedProjectPropertiesFragment`
 */
private func extendedProjectFAQs(
  from fragment: GraphAPI.ExtendedProjectPropertiesFragment
) -> [ProjectFAQ] {
  var faqs = [ProjectFAQ]()

  if let allFaqs = fragment.faqs?.nodes.flatMap({ $0 }) {
    for faq in allFaqs {
      guard let id = faq?.id,
            let decomposedId = decompose(id: id),
            let faqQuestion = faq?.question,
            let faqAnswer = faq?.answer else {
        continue
      }

      var createdAtDate: TimeInterval?

      if let existingDate = faq?.createdAt {
        createdAtDate = TimeInterval(existingDate)
      }

      let faq = ProjectFAQ(
        answer: faqAnswer,
        question: faqQuestion,
        id: decomposedId,
        createdAt: createdAtDate
      )

      faqs.append(faq)
    }
  }

  return faqs
}

/**
 Returns a `GraphQLProject.EnvironmentalCommitment` from `ExtendedProjectPropertiesFragment`
 */
private func extendedProjectEnvironmentalCommitments(
  from fragment: GraphAPI.ExtendedProjectPropertiesFragment
) -> [ProjectTabCategoryDescription] {
  var environmentalCommitments = [ProjectTabCategoryDescription]()

  if let allEnvironmentalCommitments = fragment.environmentalCommitments {
    for commitment in allEnvironmentalCommitments {
      guard let id = commitment?.id,
            let decomposedId = decompose(id: id),
            let description = commitment?.description else {
        continue
      }

      let commitmentCategory: ProjectTabCategory

      switch commitment?.commitmentCategory.value {
      case .longLastingDesign:
        commitmentCategory = .longLastingDesign
      case .sustainableMaterials:
        commitmentCategory = .sustainableMaterials
      case .environmentallyFriendlyFactories:
        commitmentCategory = .environmentallyFriendlyFactories
      case .sustainableDistribution:
        commitmentCategory = .sustainableDistribution
      case .reusabilityAndRecyclability:
        commitmentCategory = .reusabilityAndRecyclability
      default:
        commitmentCategory = .somethingElse
      }

      let environmentalCommitment = ProjectTabCategoryDescription(
        description: description,
        category: commitmentCategory,
        id: decomposedId
      )

      environmentalCommitments.append(environmentalCommitment)
    }
  }

  return environmentalCommitments
}

private func extendedProjectAIDisclosure(
  from fragment: GraphAPI.ExtendedProjectPropertiesFragment
) -> ProjectAIDisclosure? {
  guard let aiDisclosureRawData = fragment.aiDisclosure,
        let decomposedId = decompose(id: aiDisclosureRawData.id) else {
    return nil
  }

  let generatedByAIConsent = aiDisclosureRawData.generatedByAiConsent ?? ""
  let generatedByAIDetails = aiDisclosureRawData.generatedByAiDetails ?? ""
  let generatedOtherAIDetails = aiDisclosureRawData.otherAiDetails ?? ""

  let aiDisclosureOther = ProjectTabCategoryDescription(
    description: generatedOtherAIDetails,
    category: .aiDisclosureOtherDetails,
    id: decomposedId + 2
  )

  let availableAIOtherDisclosure = !generatedOtherAIDetails.isEmpty

  let fundingOptions = ProjectTabFundingOptions(
    fundingForAiAttribution: aiDisclosureRawData.fundingForAiAttribution ?? false,
    fundingForAiConsent: aiDisclosureRawData.fundingForAiConsent ?? false,
    fundingForAiOption: aiDisclosureRawData.fundingForAiOption ?? false
  )

  let generationDisclosure = generatedByAIConsent.isEmpty && generatedByAIDetails.isEmpty ? nil :
    ProjectTabGenerationDisclosure(
      consent: generatedByAIConsent,
      details: generatedByAIDetails
    )

  return ProjectAIDisclosure(
    id: decomposedId,
    funding: fundingOptions,
    generationDisclosure: generationDisclosure,
    involvesAi: aiDisclosureRawData.involvesAi,
    involvesFunding: aiDisclosureRawData.involvesFunding,
    involvesGeneration: aiDisclosureRawData.involvesGeneration,
    involvesOther: aiDisclosureRawData.involvesOther,
    otherAiDetails: availableAIOtherDisclosure ? aiDisclosureOther : nil
  )
}

