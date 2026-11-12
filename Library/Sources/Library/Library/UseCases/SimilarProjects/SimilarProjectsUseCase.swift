import Foundation
import GraphAPI
import KsApi
import ReactiveSwift

/// Composite UseCase protocol pairing similar-projects inputs and outputs.
public protocol SimilarProjectsUseCaseType {
  /// Input receiver.
  var inputs: SimilarProjectsUseCaseInputs { get }
  /// Output signal provider.
  var outputs: SimilarProjectsUseCaseOutputs { get }
}

/// Input contract for `SimilarProjectsUseCase`.
public protocol SimilarProjectsUseCaseInputs {
  /// Call when a user taps on a similar project.
  /// Triggers navigation to the selected project's details.
  ///
  /// - Parameter project: The project that was tapped.
  func projectTapped(project: ProjectCardProperties)

  /// Call when a project ID is loaded or becomes available.
  /// Initiates fetching of similar projects for the given project ID.
  ///
  /// - Parameter projectID: The ID of the project to find similar projects for.
  func projectIDLoaded(projectID: String)
}

/// Output signals emitted by `SimilarProjectsUseCase`.
public protocol SimilarProjectsUseCaseOutputs {
  /// The current state of similar projects.
  var similarProjects: Property<SimilarProjectsState> { get }

  /// Signal that emits when a user has tapped on a similar project.
  /// Use this to navigate to the selected project's details.
  var navigateToProject: Signal<ProjectCardProperties, Never> { get }
}

/// A Use Case for fetching similar projects and navigating to them when the user taps them.
public final class SimilarProjectsUseCase: SimilarProjectsUseCaseType, SimilarProjectsUseCaseInputs,
  SimilarProjectsUseCaseOutputs {
  // MARK: - Initialization

  init() {
    self.navigateToProject = self.projectTappedSignal

    self.projectIDLoadedSignal
      .flatMap(.latest, self.fetchProjects(projectID:))
      .observeForUI()
      .observeValues { [weak self] state in
        self?.similarProjectsProperty.value = state
      }
  }

  // MARK: - Data loading

  private func fetchProjects(projectID: String) -> SignalProducer<SimilarProjectsState, Never> {
    AppEnvironment.current.apiService.fetch(query: GraphAPI.FetchSimilarProjectsQuery(projectID: projectID))
      .map { response in response.projects?.nodes ?? [] }
      .map { nodes in nodes
        .compactMap { node in node?.fragments.projectCardFragment }
        .compactMap { fragment in ProjectCardProperties(fragment) }
      }
      .map { projects in .loaded(projects: projects) }
      .flatMapError { error in
        SignalProducer(value: SimilarProjectsState.error(error: error))
      }
  }

  // MARK: - Inputs

  private let (projectTappedSignal, projectTappedObserver) = Signal<ProjectCardProperties, Never>.pipe()
  /// Records user selection of a recommended similar project card.
  public func projectTapped(project: ProjectCardProperties) {
    self.projectTappedObserver.send(value: project)
  }

  private let (projectIDLoadedSignal, projectIDLoadedObserver) = Signal<String, Never>.pipe()
  /// Triggers `FetchSimilarProjectsQuery` for the given GraphQL `projectID`.
  public func projectIDLoaded(projectID: String) {
    self.projectIDLoadedObserver.send(value: projectID)
  }

  // MARK: - Outputs

  /// Navigation trigger emitting tapped similar-project properties.
  public let navigateToProject: Signal<ProjectCardProperties, Never>

  /// Backing mutable property holding the current loading/loaded/error state.
  public let similarProjectsProperty = MutableProperty<SimilarProjectsState>(.loading)
  /// Read-only `Property` reflecting similar-projects fetch state.
  public var similarProjects: Property<SimilarProjectsState> {
    Property(self.similarProjectsProperty)
  }

  // MARK: - Type

  /// Self-conformance to `SimilarProjectsUseCaseInputs`.
  public var inputs: any SimilarProjectsUseCaseInputs { return self }
  /// Self-conformance to `SimilarProjectsUseCaseOutputs`.
  public var outputs: any SimilarProjectsUseCaseOutputs { return self }
}
