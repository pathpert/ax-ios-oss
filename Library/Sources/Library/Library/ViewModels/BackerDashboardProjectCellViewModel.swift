import Foundation
import KDS
import KsApi
import ReactiveSwift
import UIKit

/// Inputs accepted by `BackerDashboardProjectCellViewModel`.
public protocol BackerDashboardProjectCellViewModelInputs {
  /// Call to configure with a backed project.
  func configureWith(project: any BackerDashboardProjectCellViewModel.ProjectCellModel)
}

/// Outputs exposed by `BackerDashboardProjectCellViewModel`.
public protocol BackerDashboardProjectCellViewModelOutputs {
  /// Emits a boolean whether to show the metadata timer icon.
  var metadataIconIsHidden: Signal<Bool, Never> { get }

  /// Emits text for the metadata label.
  var metadataText: Signal<String, Never> { get }

  /// Emits a color for the metadata background view.
  var metadataBackgroundColor: Signal<UIColor, Never> { get }

  /// Emits attributed text for the percent funded label.
  var percentFundedText: Signal<NSAttributedString, Never> { get }

  /// Emits the project's photo URL to be displayed.
  var photoURL: Signal<URL?, Never> { get }

  /// Emits the project's funding progress amount to be displayed.
  var progress: Signal<Float, Never> { get }

  /// Emits a color for the progress bar.
  var progressBarColor: Signal<UIColor, Never> { get }

  /// Emits the project name to be displayed.
  var projectTitleText: Signal<NSAttributedString, Never> { get }

  /// Emits a boolean when the saved icon is hidden or not.
  var savedIconIsHidden: Signal<Bool, Never> { get }

  /// Emits to hide information about pledging when project is prelaunch
  var prelaunchProject: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs interface for `BackerDashboardProjectCellViewModel`.
public protocol BackerDashboardProjectCellViewModelType {
  /// The view model's inputs.
  var inputs: BackerDashboardProjectCellViewModelInputs { get }
  /// The view model's outputs.
  var outputs: BackerDashboardProjectCellViewModelOutputs { get }
}

/// A view model for a backer dashboard project cell.
public final class BackerDashboardProjectCellViewModel: BackerDashboardProjectCellViewModelType,
  BackerDashboardProjectCellViewModelInputs, BackerDashboardProjectCellViewModelOutputs {
  /// A type that can provide a `ProjectCellModel`.
  public protocol HasProjectCellModel {
    /// Returns the project cell model representation.
    var projectCellModel: any ProjectCellModel { get }
  }

  /// Minimal project data required to render a backer dashboard project cell.
  public protocol ProjectCellModel {
    /// The project's display name.
    var name: String { get }
    /// The current funding state of the project.
    var state: Project.State { get }
    /// The URL string for the project's thumbnail image.
    var imageURL: String? { get }
    /// The normalized funding progress ratio (`0.0` to `1.0+`).
    var fundingProgress: Float { get }
    /// The integer percentage funded.
    var percentFunded: Int { get }
    /// Whether the project should display in prelaunch state.
    var displayPrelaunch: Bool? { get }
    /// Whether prelaunch is activated for the project.
    var prelaunchActivated: Bool? { get }
    /// The project's launch timestamp, in seconds since 1970.
    var launchedAt: TimeInterval? { get }
    /// The project's funding deadline timestamp, in seconds since 1970.
    var deadline: TimeInterval? { get }
    /// Whether the current user has starred/saved the project.
    var isStarred: Bool? { get }
  }

  /// Creates a new backer dashboard project cell view model and binds reactive outputs.
  public init() {
    let project = self.projectProperty.signal.skipNil()

    self.projectTitleText = project.map(titleString(for:))

    self.photoURL = project.map { project in
      guard let urlString = project.imageURL else {
        return nil
      }

      return URL(string: urlString)
    }

    self.progress = project.map { $0.fundingProgress }

    self.metadataBackgroundColor = project.map(metadataBackgroundColorForProject)

    self.metadataText = project.map(metadataString(for:))

    self.metadataIconIsHidden = project.map { project in
      guard !isProjectPrelaunch(project) else { return true }

      return project.state != .live
    }

    self.percentFundedText = project.map { percentFundedString(for: $0, fontSize: 10.0) }

    self.progressBarColor = project.map(progressBarColorForProject)

    self.savedIconIsHidden = project.map { $0.isStarred != .some(true) }

    self.prelaunchProject = project.map(isProjectPrelaunch)
  }

  fileprivate let projectProperty = MutableProperty<(any ProjectCellModel)?>(nil)
  /// Configures the view model with the given project cell model.
  public func configureWith(project: any ProjectCellModel) {
    self.projectProperty.value = project
  }

  /// Emits the background color for the metadata pill.
  public let metadataBackgroundColor: Signal<UIColor, Never>
  /// Emits whether the metadata clock/icon should be hidden.
  public let metadataIconIsHidden: Signal<Bool, Never>
  /// Emits the localized metadata label text.
  public let metadataText: Signal<String, Never>
  /// Emits the styled percentage funded string.
  public let percentFundedText: Signal<NSAttributedString, Never>
  /// Emits the URL for the project thumbnail image.
  public let photoURL: Signal<URL?, Never>
  /// Emits the funding progress value for the progress bar.
  public let progress: Signal<Float, Never>
  /// Emits the tint color for the progress bar.
  public let progressBarColor: Signal<UIColor, Never>
  /// Emits the styled project title text.
  public let projectTitleText: Signal<NSAttributedString, Never>
  /// Emits whether the project is currently in prelaunch.
  public let prelaunchProject: Signal<Bool, Never>
  /// Emits whether the saved/starred icon should be hidden.
  public let savedIconIsHidden: Signal<Bool, Never>

  /// The inputs interface for this view model.
  public var inputs: BackerDashboardProjectCellViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: BackerDashboardProjectCellViewModelOutputs { return self }
}

private func progressBarColorForProject(
  _ project: any BackerDashboardProjectCellViewModel
    .ProjectCellModel
) -> UIColor {
  switch project.state {
  case .live, .successful:
    return LegacyColors.ksr_create_700.uiColor()
  default:
    return LegacyColors.ksr_support_300.uiColor()
  }
}

// MARK: `ProjectCardProperties` extension

// Public class for easy conversions between `ProjectCardProperties` and
// `ProjectCellModel` protocol conformance.
/// Adapts `ProjectCardProperties` to `BackerDashboardProjectCellViewModel.ProjectCellModel`.
public struct ProjectCardPropertiesProjectCellModel: BackerDashboardProjectCellViewModel.ProjectCellModel {
  /// The underlying project card properties.
  public let properties: ProjectCardProperties
  init(_ properties: ProjectCardProperties) {
    self.properties = properties
  }

  /// The project's display name.
  public var name: String { self.properties.name }
  /// The current funding state of the project.
  public var state: KsApi.Project.State { self.properties.state }
  /// The URL string for the project's thumbnail image.
  public var imageURL: String? { self.properties.image.url?.absoluteString }
  /// The normalized funding progress ratio.
  public var fundingProgress: Float { Float(self.properties.percentFunded) / 100 }
  /// The integer percentage funded.
  public var percentFunded: Int { self.properties.percentFunded }
  /// Whether the project should display in prelaunch state.
  public var displayPrelaunch: Bool? { self.properties.shouldDisplayPrelaunch }
  /// Whether prelaunch is activated for the project.
  public var prelaunchActivated: Bool? { self.properties.isPrelaunchActivated }
  /// The project's launch timestamp, in seconds since 1970.
  public var launchedAt: TimeInterval? { self.properties.launchedAt?.timeIntervalSince1970 }
  /// The project's funding deadline timestamp, in seconds since 1970.
  public var deadline: TimeInterval? { self.properties.deadlineAt?.timeIntervalSince1970 }
  /// Whether the current user has starred/saved the project.
  public var isStarred: Bool? { self.properties.isStarred }
}

extension ProjectCardProperties: BackerDashboardProjectCellViewModel.HasProjectCellModel {
  /// Returns a cell model adapter backed by these card properties.
  public var projectCellModel: any BackerDashboardProjectCellViewModel.ProjectCellModel {
    ProjectCardPropertiesProjectCellModel(self)
  }
}
