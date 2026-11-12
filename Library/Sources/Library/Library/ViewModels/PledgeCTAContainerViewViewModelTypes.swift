import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Strongly-typed prelaunch watch state rendered by `PledgeCTAContainerView`.
///
/// Negative Constraint: Only applicable when `prelaunch == true`; do not render watcher counts on live projects.
public struct PledgeCTAPrelaunchState: Equatable, Sendable {
  /// `true` when the project is in prelaunch state.
  public let prelaunch: Bool
  /// `true` when the current viewer has saved/watched this prelaunch project.
  public let saved: Bool
  /// Aggregate number of users watching the prelaunch project.
  public let watchesCount: Int

  /// Creates a typed `PledgeCTAPrelaunchState` contract.
  public init(prelaunch: Bool, saved: Bool, watchesCount: Int) {
    self.prelaunch = prelaunch
    self.saved = saved
    self.watchesCount = watchesCount
  }
}

/// The Pledge CTA can be in three states:
/// - It can be loading
/// - It can have a loaded project
/// - It can have a loading error
public enum PledgeCTAContainerViewData {
  /// The CTA is currently waiting for project data.
  case loading
  /// Project data finished loading and is available for rendering the CTA.
  case project(Project)
  /// Fetching the project failed with an API error.
  case error(ErrorEnvelope)
}

/// Inputs accepted by `PledgeCTAContainerViewViewModel`.
public protocol PledgeCTAContainerViewViewModelInputs {
  /// Configures the CTA with loading, loaded project, or error state.
  func configureWith(value: PledgeCTAContainerViewData)
  /// Notifies the view model that the primary CTA button was tapped.
  func pledgeCTAButtonTapped()
  /// Updates saved watch state when a project save notification arrives.
  func savedProjectFromNotification(project: Project?)
}

/// Outputs emitted by `PledgeCTAContainerViewViewModel`.
public protocol PledgeCTAContainerViewViewModelOutputs {
  /// Emits whether the loading indicator is hidden.
  var activityIndicatorIsHidden: Signal<Bool, Never> { get }
  /// Emits the styling variant for the primary CTA button.
  var buttonStyleType: Signal<ButtonStyleType, Never> { get }
  /// Emits the localized title text for the primary CTA button.
  var buttonTitleText: Signal<String, Never> { get }
  /// Emits the CTA action type when the delegate should handle a button tap.
  var notifyDelegateCTATapped: Signal<PledgeStateCTAType, Never> { get }
  /// Emits whether the primary CTA button is hidden.
  var pledgeCTAButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits whether the prelaunch watches count label is hidden.
  var watchesLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits the current prelaunch saved state and watch count.
  var prelaunchCTASaved: Signal<PledgeCTAPrelaunchState, Never> { get }
  /// Emits whether the retry stack view is hidden.
  var retryStackViewIsHidden: Signal<Bool, Never> { get }
  /// Emits whether the layout spacer is hidden.
  var spacerIsHidden: Signal<Bool, Never> { get }
  /// Emits whether the CTA content stack view is hidden.
  var stackViewIsHidden: Signal<Bool, Never> { get }
  /// Emits the CTA subtitle text summarizing backing details or error state.
  var subtitleText: Signal<String, Never> { get }
  /// Emits the CTA heading title text.
  var titleText: Signal<String, Never> { get }
  /// Emits formatted follower/watcher count text for prelaunch projects.
  var watchesCountText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `PledgeCTAContainerViewViewModel`.
public protocol PledgeCTAContainerViewViewModelType {
  /// Input methods consumed by the CTA view.
  var inputs: PledgeCTAContainerViewViewModelInputs { get }
  /// Output signals observed by the CTA view.
  var outputs: PledgeCTAContainerViewViewModelOutputs { get }
}

// MARK: - Helpers

internal func pledgeCTAState(project: Project, backing: Backing?) -> PledgeStateCTAType {
  guard project.displayPrelaunch != .some(true) else {
    let projectIsSaved = project.personalization.isStarred ?? false

    return .prelaunch(saved: projectIsSaved, watchCount: project.watchesCount ?? 0)
  }

  if backing?.status == .dummy || project.pledgeManagementAvailable {
    return PledgeStateCTAType.pledgeManager
  }

  let isInPostCampaign = project.isInPostCampaignPledgingPhase

  guard let projectBacking = backing, project.personalization.isBacking == .some(true) else {
    if currentUserIsCreator(of: project) {
      return PledgeStateCTAType.viewYourRewards
    }

    if isInPostCampaign {
      return PledgeStateCTAType.pledge
    }

    return project.state == .live ? PledgeStateCTAType.pledge : PledgeStateCTAType.viewRewards
  }

  // NB: Add error case back once correctly returned
  switch (project.state, projectBacking.status, isInPostCampaign) {
  case (.live, _, _):
    return .manage
  case (.successful, _, true):
    return .viewBacking
  case (.successful, .errored, _):
    return .fix
  case (_, _, _):
    return .viewBacking
  }
}

internal func pledgeCTASubtitle(project: Project, pledgeState: PledgeStateCTAType) -> String {
  guard let backing = project.personalization.backing else { return "" }

  switch pledgeState {
  case .fix:
    return pledgeState.subtitleLabel ?? ""
  default:
    break
  }

  let amount = formattedPledge(amount: backing.amount, project: project)

  let reward = backing.reward
    ?? project.rewards.first { $0.id == backing.rewardId }
    ?? Reward.noReward

  guard let rewardTitle = reward.title else { return "\(amount)" }
  return "\(amount) • \(rewardTitle)"
}

private func formattedPledge(amount: Double, project: Project) -> String {
  let numberOfDecimalPlaces = amount.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
  let formattedAmount = String(format: "%.\(numberOfDecimalPlaces)f", amount)

  return Format.formattedCurrency(
    formattedAmount,
    currencyCode: project.statsCurrency,
    omitCurrencyCode: project.stats.omitUSCurrencyCode
  )
}

/// PledgeCTAContainerViewData was originally a tuple like
/// `(projectOrError: Either<Project, ErrorEnvelope>, isLoading: Bool)`
///
/// These are some convenience methods that bridge the original interface
/// with the new `enum` interface for this type.
extension PledgeCTAContainerViewData {
  var projectOrError: Either<Project, ErrorEnvelope>? {
    switch self {
    case .loading:
      return nil
    case let .project(project):
      return Either.left(project)
    case let .error(error):
      return Either.right(error)
    }
  }

  var isLoading: Bool {
    switch self {
    case .loading:
      return true
    default:
      return false
    }
  }
}

extension PledgeCTAContainerViewData: Equatable {
  /// Compares two `PledgeCTAContainerViewData` instances for equality.
  public static func == (lhs: PledgeCTAContainerViewData, rhs: PledgeCTAContainerViewData) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case let (.project(lProject), .project(rProject)):
      return lProject == rProject
    case let (.error(lError), .error(rError)):
      return lError.errorMessages == rError.errorMessages
    default:
      return false
    }
  }
}

