import KsApi
import Prelude
import ReactiveSwift

/// Tuple pairing a project with an optional referral tag for pamphlet content rendering.
public typealias ProjectPamphletContentData = (Project, RefTag?)

/// Inputs accepted by `ProjectPamphletContentViewModel`.
public protocol ProjectPamphletContentViewModelInputs {
  /// Configures the content view model with a project and optional referral tag.
  func configureWith(value: (Project, RefTag?))
  /// Signals that the user tapped the comments row.
  func tappedComments()
  /// Signals that the user tapped the pledge-any-amount row.
  func tappedPledgeAnyAmount()
  /// Signals that the user tapped a reward tier or existing backing row.
  func tapped(rewardOrBacking: Either<Reward, Backing>)
  /// Signals that the user tapped the updates row.
  func tappedUpdates()
  /// Signals that the user tapped to view project progress details.
  func tappedViewProgress(of project: Project)
  /// Signals that the view appeared.
  func viewDidAppear(animated: Bool)
  /// Signals that the view loaded.
  func viewDidLoad()
  /// Signals that the view will appear.
  func viewWillAppear(animated: Bool)
}

/// Outputs exposed by `ProjectPamphletContentViewModel`.
public protocol ProjectPamphletContentViewModelOutputs {
  /// Emits parameters to navigate to manage an existing backing.
  var goToBacking: Signal<ManagePledgeViewParamConfigData, Never> { get }
  /// Emits the project when navigating to comments.
  var goToComments: Signal<Project, Never> { get }
  /// Emits the project and selected reward when navigating to pledge checkout.
  var goToRewardPledge: Signal<(Project, Reward), Never> { get }
  /// Emits the project when navigating to updates.
  var goToUpdates: Signal<Project, Never> { get }
  /// Emits the project for lightweight initial placeholder rendering before swipe settles.
  var loadMinimalProjectIntoDataSource: Signal<Project, Never> { get }
  /// Emits full pamphlet data once transition timing is ready to populate the data source.
  var loadProjectPamphletContentDataIntoDataSource: Signal<ProjectPamphletContentData, Never> { get }
}

/// Combined inputs and outputs interface for `ProjectPamphletContentViewModel`.
public protocol ProjectPamphletContentViewModelType {
  /// The view model's inputs.
  var inputs: ProjectPamphletContentViewModelInputs { get }
  /// The view model's outputs.
  var outputs: ProjectPamphletContentViewModelOutputs { get }
}

/// View model driving the project pamphlet table content and subpage navigation.
public final class ProjectPamphletContentViewModel: ProjectPamphletContentViewModelType,
  ProjectPamphletContentViewModelInputs, ProjectPamphletContentViewModelOutputs {
  /// Creates a new `ProjectPamphletContentViewModel` and binds data-loading and navigation signals.
  public init() {
    let projectAndRefTag = Signal.combineLatest(
      self.configDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let project = projectAndRefTag.map(first)

    let loadDataSourceOnSwipeCompletion = self.viewDidAppearAnimatedProperty.signal
      .filter(isTrue)
      .ignoreValues()
      .flatMap { _ in
        // NB: skip a run loop to ease the initial rendering of the cells and the swipe animation
        SignalProducer(value: ()).delay(0, on: AppEnvironment.current.scheduler)
      }

    let loadDataSourceOnModalCompletion = self.viewWillAppearAnimatedProperty.signal
      .filter(isFalse)
      .ignoreValues()

    let timeToLoadDataSource = Signal.merge(
      loadDataSourceOnSwipeCompletion,
      loadDataSourceOnModalCompletion
    )
    .take(first: 1)

    self.loadProjectPamphletContentDataIntoDataSource = Signal.combineLatest(
      projectAndRefTag,
      timeToLoadDataSource
    )
    .map(first)

    self.loadMinimalProjectIntoDataSource = project
      .takePairWhen(self.viewWillAppearAnimatedProperty.signal)
      .take(first: 1)
      .filter(second)
      .map(first)

    let rewardOrBackingTapped = Signal.merge(
      self.tappedRewardOrBackingProperty.signal.skipNil(),
      self.tappedPledgeAnyAmountProperty.signal.mapConst(.left(Reward.noReward))
    )

    self.goToRewardPledge = project
      .takePairWhen(rewardOrBackingTapped)
      .map(goToRewardPledgeData(forProject:rewardOrBacking:))
      .skipNil()

    self.goToBacking = project
      .takePairWhen(rewardOrBackingTapped)
      .map(goToBackingData(forProject:rewardOrBacking:))
      .skipNil()

    self.goToComments = project
      .takeWhen(self.tappedCommentsProperty.signal)

    self.goToUpdates = project
      .takeWhen(self.tappedUpdatesProperty.signal)
  }

  fileprivate let configDataProperty = MutableProperty<(Project, RefTag?)?>(nil)
  /// Configures the view model with the displayed project and optional referral tag.
  public func configureWith(value: (Project, RefTag?)) {
    self.configDataProperty.value = value
  }

  fileprivate let tappedCommentsProperty = MutableProperty(())
  /// Navigates to the project's comments screen.
  public func tappedComments() {
    self.tappedCommentsProperty.value = ()
  }

  fileprivate let tappedPledgeAnyAmountProperty = MutableProperty(())
  /// Starts a pledge without a preselected reward.
  public func tappedPledgeAnyAmount() {
    self.tappedPledgeAnyAmountProperty.value = ()
  }

  fileprivate let tappedRewardOrBackingProperty = MutableProperty<Either<Reward, Backing>?>(nil)
  /// Handles tapping either a reward tier or the user's current backing row.
  public func tapped(rewardOrBacking: Either<Reward, Backing>) {
    self.tappedRewardOrBackingProperty.value = rewardOrBacking
  }

  fileprivate let tappedUpdatesProperty = MutableProperty(())
  /// Navigates to the project's updates screen.
  public func tappedUpdates() {
    self.tappedUpdatesProperty.value = ()
  }

  fileprivate let tappedViewProgressProperty = MutableProperty<Project?>(nil)
  /// Records that the user tapped to inspect project funding progress.
  public func tappedViewProgress(of project: Project) {
    self.tappedViewProgressProperty.value = project
  }

  fileprivate let viewDidAppearAnimatedProperty = MutableProperty(false)
  /// Signals that the content view appeared.
  public func viewDidAppear(animated: Bool) {
    self.viewDidAppearAnimatedProperty.value = animated
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the content view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let viewWillAppearAnimatedProperty = MutableProperty(false)
  /// Signals that the content view will appear.
  public func viewWillAppear(animated: Bool) {
    self.viewWillAppearAnimatedProperty.value = animated
  }

  /// Emits backing management configuration data when a non-live backing is tapped.
  public let goToBacking: Signal<ManagePledgeViewParamConfigData, Never>
  /// Emits the project when navigating to comments.
  public let goToComments: Signal<Project, Never>
  /// Emits the project and reward when starting a pledge flow.
  public let goToRewardPledge: Signal<(Project, Reward), Never>
  /// Emits the project when navigating to updates.
  public let goToUpdates: Signal<Project, Never>
  /// Emits the project for initial lightweight rendering.
  public let loadMinimalProjectIntoDataSource: Signal<Project, Never>
  /// Emits the full `(Project, RefTag?)` data for the pamphlet data source.
  public let loadProjectPamphletContentDataIntoDataSource: Signal<ProjectPamphletContentData, Never>

  /// The inputs interface for this view model.
  public var inputs: ProjectPamphletContentViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: ProjectPamphletContentViewModelOutputs { return self }
}

private func reward(forBacking backing: Backing, inProject project: Project) -> Reward? {
  return backing.reward
    ?? project.rewards.first { $0.id == backing.rewardId }
    ?? Reward.noReward
}

private func goToRewardPledgeData(forProject project: Project, rewardOrBacking: Either<Reward, Backing>)
  -> (Project, Reward)? {
  guard project.state == .live else { return nil }

  switch rewardOrBacking {
  case let .left(reward):
    guard reward.remaining != .some(0) else { return nil }
    return (project, reward)

  case let .right(backing):
    guard let reward = reward(forBacking: backing, inProject: project) else { return nil }

    return (project, reward)
  }
}

private func goToBackingData(forProject project: Project, rewardOrBacking: Either<Reward, Backing>)
  -> ManagePledgeViewParamConfigData? {
  guard project.state != .live, let backing = rewardOrBacking.right else {
    return nil
  }

  return ManagePledgeViewParamConfigData(
    projectParam: Param.slug(project.slug),
    backingParam: Param.id(backing.id)
  )
}
