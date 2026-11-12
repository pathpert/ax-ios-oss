import KsApi
import ReactiveSwift

/// Category of projects shown in the backer dashboard list.
public enum ProfileProjectsType: Decodable {
  /// Projects backed by the current user.
  case backed
  /// Projects saved/starred by the current user.
  case saved

  var trackingString: String {
    switch self {
    case .backed: return "backed"
    case .saved: return "saved"
    }
  }
}

/// Inputs accepted by `BackerDashboardProjectsViewModel`.
public protocol BackerDashboardProjectsViewModelInputs {
  /// Call to configure with the ProfileProjectsType to display.
  func configureWith(projectsType: ProfileProjectsType)

  /// Call when the user has updated.
  func currentUserUpdated()

  /// Call when a project cell is tapped.
  func projectTapped(_ project: ProjectCardProperties)

  /// Call when pull-to-refresh is invoked.
  func refresh()

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when the view did appear.
  func viewDidAppear(_ animated: Bool)

  /// Call when a new row is displayed.
  func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

/// Outputs emitted by `BackerDashboardProjectsViewModel`.
public protocol BackerDashboardProjectsViewModelOutputs {
  /// Emits a boolean that determines if the empty state is visible and a ProfileProjectsType.
  var emptyStateIsVisible: Signal<(Bool, ProfileProjectsType), Never> { get }

  /// Emits the project, projects, and ref tag when should go to project page.
  var goToProject: Signal<(ProjectCardProperties, RefTag), Never> { get }

  /// Emits when the pull-to-refresh control is refreshing or not.
  var isRefreshing: Signal<Bool, Never> { get }

  /// Emits `true` when the next page is loading.
  var isLoadingNextPage: Signal<Bool, Never> { get }

  /// Emits a list of projects for the tableview datasource.
  var projects: Signal<[ProjectCardProperties], Never> { get }
}

/// Interface combining inputs and outputs for `BackerDashboardProjectsViewModel`.
public protocol BackerDashboardProjectsViewModelType {
  /// Input receiver for backer dashboard project list events.
  var inputs: BackerDashboardProjectsViewModelInputs { get }
  /// Output signals driving the project list UI.
  var outputs: BackerDashboardProjectsViewModelOutputs { get }
}

