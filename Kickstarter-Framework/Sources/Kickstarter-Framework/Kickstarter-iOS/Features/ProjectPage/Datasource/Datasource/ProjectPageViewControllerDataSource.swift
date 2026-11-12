import AVFoundation
import KsApi
import Library
import Prelude
import UIKit

/// Table view data source managing project page sections, story media caching, and cell configuration.
final class ProjectPageViewControllerDataSource: ValueCellDataSource {
  /// Ordered table view sections displayed on the project page.
  enum Section: Int {
    case overviewCreatorHeader
    case overview
    case overviewSubpages
    case overviewReportProject
    case overviewSimilarProjects
    case campaignHeader
    case campaign
    case faqsHeader
    case faqsEmpty
    case faqs
    case faqsAskAQuestion
    case risksHeader
    case risks
    case risksDisclaimer
    case aiDisclosureHeader
    case aiDisclosureFunding
    case aiDisclosureGenerated
    case aiDisclosureOtherDetails
    case aiDisclosureDisclaimer
    case environmentalCommitmentsHeader
    case environmentalCommitments
    case environmentalCommitmentsDisclaimer
  }

  var preexistingImageViewElementsWithData = [(element: ImageViewElement, image: UIImage?)]()
  var preexistingAudioVideoViewElementsWithPlayer =
    [(element: AudioVideoViewElement, player: AVPlayer?, image: UIImage?)]()

  /// Clears existing sections and populates cells for the requested navigation tab and project state.
  func load(
    navigationSection: NavigationSection,
    project: Either<Project, any ProjectPageParam>,
    refTag: RefTag?,
    isExpandedStates: [Bool]? = nil,
    similarProjectsState: SimilarProjectsState? = nil
  ) {
    self.prepareImagesInCampaignSection()
    self.prepareAudioVideosInCampaignSection()
    self.clearValues()

    switch (navigationSection, project) {
    case let (.overview, .left(project)):
      self.loadOverviewSection(project: project, refTag: refTag, similarProjectsState: similarProjectsState)
    case let (.overview, .right(param)):
      if let project = param.initialProject {
        self.set(
          values: [(project, refTag)],
          cellClass: ProjectPamphletMainCell.self,
          inSection: Section.overview.rawValue
        )
      }
    case let (.campaign, .left(project)):
      self.loadCampaignSection(project: project)
    case let (.faq, .left(project)):
      self.loadFAQSection(project: project, isExpandedStates: isExpandedStates)
    case let (.risks, .left(project)):
      self.loadRisksSection(project: project)
    case let (.aiDisclosure, .left(project)):
      self.loadAIDisclosureSection(project: project)
    case let (.environmentalCommitments, .left(project)):
      self.loadEnvironmentalCommitmentsSection(project: project)
    case (_, _):
      break
    }
  }

  /// Configures each `UITableViewCell` subclass with its strongly typed row model.
  override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
    switch (cell, value) {
    case let (cell as ProjectTabAIGenerationCell, value as ProjectTabGenerationDisclosure):
      cell.configureWith(value: value)
    case let (cell as ProjectTabCategoryDescriptionCell, value as ProjectTabCategoryDescription):
      cell.configureWith(value: value)
    case let (cell as ProjectTabCheckmarkListCell, value as ProjectTabFundingOptions):
      cell.configureWith(value: value)
    case let (cell as ProjectTabDisclaimerCell, value as ProjectDisclaimerType):
      cell.configureWith(value: value)
    case let (cell as ProjectHeaderCell, value as String):
      cell.configureWith(value: value)
    case let (cell as ProjectFAQsAskAQuestionCell, _):
      cell.configureWith(value: ())
    case let (cell as ProjectFAQsCell, value as (ProjectFAQ, Bool)):
      cell.configureWith(value: value)
    case let (cell as ProjectFAQsEmptyStateCell, _):
      cell.configureWith(value: ())
    case let (cell as ProjectPamphletCreatorHeaderCell, value as Project):
      cell.configureWith(value: value)
    case let (cell as ProjectPamphletMainCell, value as ProjectPamphletMainCellData):
      cell.configureWith(value: value)
    case let (cell as ProjectPamphletSubpageCell, value as ProjectPamphletSubpage):
      cell.configureWith(value: value)
    case let (cell as ProjectRisksCell, value as String):
      cell.configureWith(value: value)
    case let (cell as ProjectRisksDisclaimerCell, _):
      cell.configureWith(value: ())
    case let (cell as TextViewElementCell, value as TextViewElement):
      cell.configureWith(value: value)
    case let (cell as ImageViewElementCell, value as (ImageViewElement, UIImage?)):
      cell.configureWith(value: value)
    case let (cell as AudioVideoViewElementCell, value as (AudioVideoViewElement, AVPlayer?, UIImage?)):
      cell.configureWith(value: value)
    case let (cell as ExternalSourceViewElementCell, value as ExternalSourceViewElement):
      cell.configureWith(value: value)
    case let (cell as ReportProjectCell, value as Bool):
      cell.configureWith(value: value)
    case let (cell as SimilarProjectsTableViewCell, value as SimilarProjectsState):
      cell.configureWith(value: value)
    default:
      assertionFailure("Unrecognized combo: \(cell), \(value)")
    }
  }
}
