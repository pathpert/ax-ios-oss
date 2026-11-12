import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `MostPopularSearchProjectCellViewModel`.
public protocol MostPopularSearchProjectCellViewModelInputs {
  /// Configures the popular search cell with a project cell model.
  func configureWith(project: any BackerDashboardProjectCellViewModel.ProjectCellModel)
}

/// Outputs emitted by `MostPopularSearchProjectCellViewModel`.
public protocol MostPopularSearchProjectCellViewModelOutputs {
  /// Emits text for metadata label.
  var metadataText: Signal<String, Never> { get }

  /// Emits the attributed string for the percent funded label.
  var percentFundedText: Signal<NSAttributedString, Never> { get }

  /// Emits the project's funding progress amount to be displayed.
  var progress: Signal<Float, Never> { get }

  /// Emits a color for the progress bar.
  var progressBarColor: Signal<UIColor, Never> { get }

  /// Emits the project's photo URL to be displayed.
  var projectImageUrl: Signal<URL?, Never> { get }

  /// Emits project name to be displayed.
  var projectName: Signal<NSAttributedString, Never> { get }

  /// Emits to hide information about pledging when project is prelaunch
  var prelaunchProject: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `MostPopularSearchProjectCellViewModel`.
public protocol MostPopularSearchProjectCellViewModelType {
  /// Input receiver for popular project cell configuration.
  var inputs: MostPopularSearchProjectCellViewModelInputs { get }
  /// Output signals formatting search result cell labels, progress, and thumbnail URL.
  var outputs: MostPopularSearchProjectCellViewModelOutputs { get }
}

/// View model formatting featured/popular project cells in the Discovery search view.
public final class MostPopularSearchProjectCellViewModel: MostPopularSearchProjectCellViewModelType,
  MostPopularSearchProjectCellViewModelInputs, MostPopularSearchProjectCellViewModelOutputs {
  /// Initializes the most popular search project cell view model.
  public init() {
    let project = self.projectProperty.signal.skipNil()

    self.projectImageUrl = project.map { project in
      guard let urlString = project.imageURL else {
        return nil
      }

      return URL(string: urlString)
    }

    self.projectName = project.map(titleString(for:))

    self.progress = project.map { $0.fundingProgress }

    self.progressBarColor = project.map(progressBarColorForProject)

    self.percentFundedText = project.map { percentFundedString(for: $0) }

    self.metadataText = project.map(metadataString(for:))

    self.prelaunchProject = project.map(isProjectPrelaunch)
  }

  fileprivate let projectProperty =
    MutableProperty<(any BackerDashboardProjectCellViewModel.ProjectCellModel)?>(nil)
  /// Configures the cell with a `ProjectCellModel`.
  public func configureWith(project: any BackerDashboardProjectCellViewModel.ProjectCellModel) {
    self.projectProperty.value = project
  }

  /// Emits formatted campaign timing or funding status metadata text.
  public let metadataText: Signal<String, Never>
  /// Emits an attributed percentage-funded label string.
  public let percentFundedText: Signal<NSAttributedString, Never>
  /// Emits the normalized funding progress bar value.
  public let progress: Signal<Float, Never>
  /// Emits the progress bar fill color.
  public let progressBarColor: Signal<UIColor, Never>
  /// Emits the optional project thumbnail URL.
  public let projectImageUrl: Signal<URL?, Never>
  /// Emits an attributed project title string.
  public let projectName: Signal<NSAttributedString, Never>
  /// Emits whether the project is currently in prelaunch mode.
  public let prelaunchProject: Signal<Bool, Never>

  /// Returns `self` as `MostPopularSearchProjectCellViewModelInputs`.
  public var inputs: MostPopularSearchProjectCellViewModelInputs { return self }
  /// Returns `self` as `MostPopularSearchProjectCellViewModelOutputs`.
  public var outputs: MostPopularSearchProjectCellViewModelOutputs { return self }
}

private func progressBarColorForProject(
  _ project: any BackerDashboardProjectCellViewModel
    .ProjectCellModel
) -> UIColor {
  guard !isProjectPrelaunch(project) else { return LegacyColors.ksr_create_700.uiColor() }

  switch project.state {
  case .live, .successful:
    return LegacyColors.ksr_create_700.uiColor()
  default:
    return LegacyColors.ksr_support_400.uiColor()
  }
}
