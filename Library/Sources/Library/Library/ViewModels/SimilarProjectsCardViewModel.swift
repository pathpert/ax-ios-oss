import KDS
import Kingfisher
import KsApi
import ReactiveSwift
import UIKit

/// Inputs accepted by `ProjectCardViewModel`.
public protocol ProjectsCardViewModelInputs {
  /// Configures the similar-projects card with `ProjectCardProperties`.
  func configureWith(project: ProjectCardProperties)
}

/// Outputs emitted by `ProjectCardViewModel`.
public protocol ProjectsCardViewModelOutputs {
  /// Emits the project's photo URL to be displayed.
  var projectImageSource: Signal<Kingfisher.Source?, Never> { get }

  /// Emits text for the project status label. (days left, ended, launching soon, late pledges active)
  var projectStatus: Signal<String, Never> { get }

  /// Emits image for the project status based on the project status label.
  var projectStatusImage: Signal<UIImage?, Never> { get }

  /// Emits project name to be displayed.
  var projectTitle: Signal<String, Never> { get }

  /// Emits the project's funding progress amount to be displayed.
  var progress: Signal<Float, Never> { get }

  /// Emits a color for the progress bar.
  var progressBarColor: Signal<UIColor, Never> { get }

  /// Emits to hide information about pledging when project is prelaunch
  var prelaunchProject: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `ProjectCardViewModel`.
public protocol ProjectCardViewModelType {
  /// Input receiver for project card configuration.
  var inputs: ProjectsCardViewModelInputs { get }
  /// Output signals formatting card imagery, status, and funding progress.
  var outputs: ProjectsCardViewModelOutputs { get }
}

/// View model formatting compact similar-project recommendation cards.
public final class ProjectCardViewModel: ProjectCardViewModelType,
  ProjectsCardViewModelInputs,
  ProjectsCardViewModelOutputs {
  /// Initializes the similar project card view model.
  public init() {
    let project = self.projectProperty.signal.skipNil()

    self.projectImageSource = project.map { $0.image }

    self.projectStatus = project.map(getProjectStatus(for:))

    self.projectStatusImage = project.map(getProjectStatusImage(for:))

    self.projectTitle = project.map { $0.name }

    self.progress = project.map { Float($0.percentFunded) / 100 }

    self.progressBarColor = project.map(progressBarColorForProject)

    self.prelaunchProject = project.map(isProjectPrelaunch)
  }

  fileprivate let projectProperty = MutableProperty<ProjectCardProperties?>(nil)
  /// Configures the card view model with `ProjectCardProperties`.
  public func configureWith(project: ProjectCardProperties) {
    self.projectProperty.value = project
  }

  /// Emits the Kingfisher image source for the project card thumbnail.
  public let projectImageSource: Signal<Kingfisher.Source?, Never>
  /// Emits formatted campaign timing and funding percentage text.
  public let projectStatus: Signal<String, Never>
  /// Emits the optional status icon accompanying the status string.
  public let projectStatusImage: Signal<UIImage?, Never>
  /// Emits the project title.
  public let projectTitle: Signal<String, Never>
  /// Emits a normalized `Float` funding progress value.
  public let progress: Signal<Float, Never>
  /// Emits the fill color for the funding progress bar.
  public let progressBarColor: Signal<UIColor, Never>
  /// Emits whether the project is currently in a prelaunch state.
  public let prelaunchProject: Signal<Bool, Never>

  /// Returns `self` as `ProjectsCardViewModelInputs`.
  public var inputs: ProjectsCardViewModelInputs { return self }
  /// Returns `self` as `ProjectsCardViewModelOutputs`.
  public var outputs: ProjectsCardViewModelOutputs { return self }
}

private func getProjectStatus(for project: ProjectCardProperties) -> String {
  guard !isProjectPrelaunch(project) else { return Strings.Launching_soon() }

  let percentage = Format.percentage(project.percentFunded)

  guard !(project.isInPostCampaignPledgingPhase && project.isPostCampaignPledgingEnabled)
  else { return Strings.Late_pledges_active() + " • " + Strings
    .percentage_funded(percentage: percentage)
  }

  switch project.state {
  case .live:
    guard let deadline = project.deadlineAt?.timeIntervalSince1970 else {
      return ""
    }

    let duration = Format.duration(secondsInUTC: deadline, abbreviate: true, useToGo: false)

    return Strings.Time_left_left(time_left: "\(duration.time) \(duration.unit)") + " • " + Strings
      .percentage_funded(percentage: percentage)
  case .successful, .failed:
    return Strings.Ended() + " • " + Strings
      .percentage_funded(percentage: percentage)
  default:
    return ""
  }
}

private func getProjectStatusImage(for project: ProjectCardProperties) -> UIImage? {
//  guard !(project.isInPostCampaignPledgingPhase && project.isPostCampaignPledgingEnabled)
//  else { return UIImage(named: "icon-late-pledge-timer") }

  guard !isProjectPrelaunch(project) else { return image(named: "icon-launching-soon") }

  switch project.state {
  case .successful, .failed:
    return image(named: "icon-project-ended-flag")
  case .live:
    return image(named: "icon-timer")
  default:
    return nil
  }
}

private func isProjectPrelaunch(_ project: ProjectCardProperties) -> Bool {
  project.shouldDisplayPrelaunch && project.isPrelaunchActivated
}

private func progressBarColorForProject(_ project: ProjectCardProperties) -> UIColor {
  switch project.state {
  case .live, .successful:
    return LegacyColors.ksr_create_500.uiColor()
  default:
    return LegacyColors.ksr_support_200.uiColor()
  }
}
