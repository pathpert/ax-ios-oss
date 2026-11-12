import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Navigation payload emitted when opening a curated project detail page.
public struct ProjectData: Equatable {
  /// Selected curated project to display.
  public let project: Project
  /// Surrounding list of curated projects for context.
  public let projects: [Project]
  /// Attribution ref tag (`RefTag.onboarding`) attached to the project visit.
  public let refTag: RefTag

  /// Creates a `ProjectData` navigation payload.
  public init(project: Project, projects: [Project], refTag: RefTag) {
    self.project = project
    self.projects = projects
    self.refTag = refTag
  }
}

/// Inputs accepted by `CuratedProjectsViewModel`.
public protocol CuratedProjectsViewModelInputs {
  /// Configures the curated feed with the user's selected onboarding categories.
  func configure(with categories: [KsApi.Category])
  /// Signals that the user tapped Done to dismiss the curated projects view.
  func doneButtonTapped()
  /// Signals that a curated project row was tapped.
  func projectTapped(_ project: Project?)
  /// Signals that the curated projects view has loaded.
  func viewDidLoad()
}

/// Outputs emitted by `CuratedProjectsViewModel`.
public protocol CuratedProjectsViewModelOutputs {
  /// Emits when the view controller should dismiss.
  var dismissViewController: Signal<Void, Never> { get }
  /// Emits `ProjectData` for navigating to a tapped project detail page.
  var goToProject: Signal<ProjectData, Never> { get }
  /// Emits whether curated projects are currently being fetched.
  var isLoading: Signal<Bool, Never> { get }
  /// Emits shuffled live projects matching the selected categories.
  var loadProjects: Signal<[Project], Never> { get }
  /// Emits an error message when fetching returns no projects.
  var showErrorMessage: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `CuratedProjectsViewModel`.
public protocol CuratedProjectsViewModelType {
  /// Input receiver for curated project loading and selection events.
  var inputs: CuratedProjectsViewModelInputs { get }
  /// Output signals loading projects and routing navigation.
  var outputs: CuratedProjectsViewModelOutputs { get }
}

/// View model fetching and presenting curated onboarding project recommendations.
public final class CuratedProjectsViewModel: CuratedProjectsViewModelType, CuratedProjectsViewModelInputs,
  CuratedProjectsViewModelOutputs {
  /// Initializes the curated projects view model.
  public init() {
    let curatedProjects: Signal<[Project], Never> = self.categoriesSignal
      .combineLatest(with: self.viewDidLoadSignal.ignoreValues())
      .map(first)
      .filter { !$0.isEmpty }
      .flatMap { categories in
        projects(from: categories)
          .flatten()
          .reduce([], +)
      }
      .map { $0.shuffled() }

    self.loadProjects = curatedProjects

    self.showErrorMessage = curatedProjects
      .filter { $0.isEmpty }
      .ignoreValues()
      .map { _ in Strings.general_error_something_wrong() }

    self.dismissViewController = self.doneButtonTappedSignal

    self.isLoading = Signal.merge(
      self.viewDidLoadSignal.mapConst(true),
      curatedProjects.mapConst(false)
    )

    self.goToProject = curatedProjects
      .takePairWhen(self.projectTappedSignal.skipNil())
      .map { projects, project in ProjectData(project: project, projects: projects, refTag: .onboarding) }
  }

  private let (categoriesSignal, categoriesObserver) = Signal<[KsApi.Category], Never>.pipe()
  /// Configures the view model with selected categories to query.
  public func configure(with categories: [KsApi.Category]) {
    self.categoriesObserver.send(value: categories)
  }

  private let (doneButtonTappedSignal, doneButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Triggers dismissal when the Done button is tapped.
  public func doneButtonTapped() {
    self.doneButtonTappedObserver.send(value: ())
  }

  private let (projectTappedSignal, projectTappedObserver) = Signal<Project?, Never>.pipe()
  /// Handles selection of a curated `Project`.
  public func projectTapped(_ project: Project?) {
    self.projectTappedObserver.send(value: project)
  }

  private let (viewDidLoadSignal, viewDidLoadObserver) = Signal<Void, Never>.pipe()
  /// Signals that the view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadObserver.send(value: ())
  }

  /// Emits when the modal view should dismiss.
  public let dismissViewController: Signal<Void, Never>
  /// Emits navigation data when a project is tapped.
  public let goToProject: Signal<ProjectData, Never>
  /// Emits loading state transitions.
  public let isLoading: Signal<Bool, Never>
  /// Emits fetched curated projects.
  public let loadProjects: Signal<[Project], Never>
  /// Emits an error message when no curated projects could be loaded.
  public let showErrorMessage: Signal<String, Never>

  /// Returns `self` as `CuratedProjectsViewModelInputs`.
  public var inputs: CuratedProjectsViewModelInputs { return self }
  /// Returns `self` as `CuratedProjectsViewModelOutputs`.
  public var outputs: CuratedProjectsViewModelOutputs { return self }
}

private func projects(from categories: [KsApi.Category])
  -> SignalProducer<[[Project]], Never> {
  return SignalProducer.combineLatest(producers(from: categories))
}

private func producers(from categories: [KsApi.Category])
  -> [SignalProducer<[Project], Never>] {
  let projectsPerCategory = Int(floor(Float(30 / categories.count)))

  return categories.map { category in

    let params = DiscoveryParams.defaults
      |> DiscoveryParams.lens.category .~ category
      |> DiscoveryParams.lens.state .~ .live
      |> DiscoveryParams.lens.perPage .~ projectsPerCategory

    return AppEnvironment.current.apiService.fetchDiscovery(params: params)
      .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      .map { $0.projects }
      .demoteErrors(replaceErrorWith: [])
  }
}
