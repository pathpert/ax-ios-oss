import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// View model managing backing retrieval, menu actions, reward delivery confirmation, and Plot payment schedules.
public final class ManagePledgeViewModel:
  ManagePledgeViewModelType, ManagePledgeViewModelInputs, ManagePledgeViewModelOutputs {
  /// Creates a new `ManagePledgeViewModel`.
  public init() {
    let params = Signal.combineLatest(
      self.configureWithProjectOrParamSignal,
      self.viewDidLoadSignal
    )
    .map(first)

    let projectParam = params.map(\.projectParam)

    let shouldBeginRefresh = Signal.merge(
      self.pledgeViewControllerDidUpdatePledgeWithMessageSignal.ignoreValues(),
      self.beginRefreshSignal
    )

    let (fetchProjectEvent, graphBackingEvent, project, backing) = managePledgeFetchSignals(
      projectParam: projectParam,
      backingParamFromConfigData: params.map(\.backingParam).skipNil(),
      shouldBeginRefresh: shouldBeginRefresh
    )

    self.endRefreshing = Signal.merge(
      fetchProjectEvent.errors().ignoreValues(),
      graphBackingEvent
        .filter { $0.isTerminating }
        .ksr_delay(.milliseconds(300), on: AppEnvironment.current.scheduler)
        .ignoreValues()
    )
    .ignoreValues()

    let userIsCreatorOfProject = project.map { currentUserIsCreator(of: $0) }

    let projectAndReward = Signal.combineLatest(project, backing)
      .compactMap { project, backing -> (Project, Reward)? in
        (project, backing.reward ?? .noReward)
      }

    self.title = project.combineLatest(with: userIsCreatorOfProject)
      .map(navigationBarTitle(with:userIsCreatorOfProject:))

    self.configurePaymentMethodView = backing.map(managePledgePaymentMethodViewData)

    let projectOrBackingFailedToLoad = Signal.merge(
      fetchProjectEvent.map { $0.error as Error? },
      graphBackingEvent.map { $0.error as Error? }
    )
    .filter(isNotNil)

    self.loadPullToRefreshHeaderView = projectOrBackingFailedToLoad
      .take(until: backing.ignoreValues())
      .ignoreValues()

    self.paymentMethodViewHidden = Signal.combineLatest(userIsCreatorOfProject, backing)
      .map { userIsCreatorOfProject, backing in
        if userIsCreatorOfProject { return true }
        if shouldShowFixPaymentMethodButton(for: backing) { return false }
        return backing.paymentSource == nil
      }
      .skipRepeats()

    self.loadProjectAndRewardsIntoDataSource = projectAndReward.combineLatest(with: backing)
      .map(unpack)
      .map { project, reward, backing in
        (project, distinctRewards([reward] + (backing.addOns ?? [])))
      }

    self.rightBarButtonItemHidden = Signal.merge(
      params.mapConst(true),
      self.loadPullToRefreshHeaderView.mapConst(true),
      self.loadProjectAndRewardsIntoDataSource.mapConst(false)
    )
    .skipRepeats()

    self.pledgeDetailsSectionLabelText = userIsCreatorOfProject.map {
      $0 ? Strings.Pledge_details() : Strings.Your_pledge_details()
    }

    self.startRefreshing = Signal.merge(params.ignoreValues(), shouldBeginRefresh.ignoreValues())

    let summaryOutputs = buildManagePledgeSummaryOutputs(
      project: project,
      backing: backing,
      loadProjectAndRewardsIntoDataSource: self.loadProjectAndRewardsIntoDataSource,
      userIsCreatorOfProject: userIsCreatorOfProject
    )

    let navOutputs = buildManagePledgeNavigationOutputs(
      project: project,
      backing: backing,
      backedRewards: self.loadProjectAndRewardsIntoDataSource.map(second),
      userIsCreatorOfProject: userIsCreatorOfProject,
      menuButtonTappedSignal: self.menuButtonTappedSignal,
      menuOptionSelectedSignal: self.menuOptionSelectedSignal,
      fixButtonTappedSignal: self.fixButtonTappedSignal
    )

    self.showActionSheetMenuWithOptions = navOutputs.showActionSheetMenuWithOptions
    self.goToRewards = navOutputs.goToRewards
    self.goToEditPledgeOverTime = navOutputs.goToEditPledgeOverTime
    self.goToCancelPledge = navOutputs.goToCancelPledge
    self.goToContactCreator = navOutputs.goToContactCreator
    self.goToChangePaymentMethod = navOutputs.goToChangePaymentMethod
    self.goToFixPaymentMethod = navOutputs.goToFixPaymentMethod

    self.notifyDelegateManagePledgeViewControllerFinishedWithMessage = Signal.merge(
      self.cancelPledgeDidFinishWithMessageProperty.signal,
      backing.skip(first: 1).mapConst(nil)
    )

    self.configurePledgeSummaryView = Signal.combineLatest(
      projectAndReward,
      backing,
      summaryOutputs.rewardReceivedWithData,
      summaryOutputs.rewardReceivedViewIsHidden
    )
    .compactMap(managePledgeSummaryViewData)

    self.showSuccessBannerWithMessage = self.pledgeViewControllerDidUpdatePledgeWithMessageSignal

    let attemptedDisallowedCancelBackingMessage = backing
      .map { $0.cancelable }
      .filter(isFalse)
      .takeWhen(navOutputs.cancelPledgeSelected)
      .map { _ in
        // swiftformat:disable wrap
        Strings.We_dont_allow_cancelations_that_will_cause_a_project_to_fall_short_of_its_goal_within_the_last_24_hours()
        // swiftformat:enable wrap
      }

    let networkErrorMessage = Signal.merge(
      fetchProjectEvent.errors().ignoreValues(),
      graphBackingEvent.errors().ignoreValues()
    )
    .map { _ in Strings.Something_went_wrong_please_try_again() }

    self.showErrorBannerWithMessage = Signal.merge(attemptedDisallowedCancelBackingMessage, networkErrorMessage)

    Signal.zip(self.loadProjectAndRewardsIntoDataSource, backing)
      .map(unpack)
      .observeValues { project, rewards, backing in
        guard let reward = backing.reward else { return }

        let checkoutData = checkoutProperties(
          from: project,
          baseReward: reward,
          addOnRewards: rewards,
          selectedQuantities: selectedRewardQuantities(in: backing),
          additionalPledgeAmount: backing.bonusAmount,
          pledgeTotal: backing.amount,
          shippingTotal: Double(backing.shippingAmount ?? 0),
          isApplePay: backing.paymentSource?.paymentType == .applePay
        )

        AppEnvironment.current.ksrAnalytics.trackManagePledgePageViewed(
          project: project,
          reward: reward,
          checkoutData: checkoutData
        )
      }

    let pledgeOverTimeEnabled = backing.map { isPledgeOverTime(with: $0) }
    self.plotPaymentScheduleViewHidden = pledgeOverTimeEnabled.negate()
    self.configurePlotPaymentScheduleView = backing
      .filterWhenLatestFrom(pledgeOverTimeEnabled, satisfies: { $0 })
      .map { $0.paymentIncrements }
    self.showWebHelp = self.termsOfUseTappedSignal
  }

  private let (beginRefreshSignal, beginRefreshObserver) = Signal<Void, Never>.pipe()
  /// Triggers reloading backing details via pull-to-refresh or pledge update.
  public func beginRefresh() { self.beginRefreshObserver.send(value: ()) }

  private let (configureWithProjectOrParamSignal, configureWithProjectOrParamObserver)
    = Signal<ManagePledgeViewParamConfigData, Never>.pipe()
  /// Supplies project and optional backing parameters to load.
  public func configureWith(_ params: ManagePledgeViewParamConfigData) {
    self.configureWithProjectOrParamObserver.send(value: params)
  }

  private let cancelPledgeDidFinishWithMessageProperty = MutableProperty<String?>(nil)
  /// Notifies that the cancel-pledge flow completed with `message`.
  public func cancelPledgeDidFinish(with message: String) {
    self.cancelPledgeDidFinishWithMessageProperty.value = message
  }

  private let (fixButtonTappedSignal, fixButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Handles tap on the Fix Payment Method button.
  public func fixButtonTapped() { self.fixButtonTappedObserver.send(value: ()) }

  private let (menuButtonTappedSignal, menuButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Opens the contextual pledge management action sheet.
  public func menuButtonTapped() { self.menuButtonTappedObserver.send(value: ()) }

  private let (menuOptionSelectedSignal, menuOptionSelectedObserver) = Signal<ManagePledgeAlertAction, Never>.pipe()
  /// Handles user selection of a management menu `action`.
  public func menuOptionSelected(with action: ManagePledgeAlertAction) {
    self.menuOptionSelectedObserver.send(value: action)
  }

  private let (termsOfUseTappedSignal, termsOfUseTappedObserver) = Signal<HelpType, Never>.pipe()
  /// Opens terms-of-use help content for `helpType`.
  public func termsOfUseTapped(with helpType: HelpType) { self.termsOfUseTappedObserver.send(value: helpType) }

  private let (
    pledgeViewControllerDidUpdatePledgeWithMessageSignal,
    pledgeViewControllerDidUpdatePledgeWithMessageObserver
  ) = Signal<String, Never>.pipe()
  /// Displays success banner `message` after updating a pledge.
  public func pledgeViewControllerDidUpdatePledgeWithMessage(_ message: String) {
    self.pledgeViewControllerDidUpdatePledgeWithMessageObserver.send(value: message)
  }

  private let (viewDidLoadSignal, viewDidLoadObserver) = Signal<(), Never>.pipe()
  /// Signals that the Manage Pledge view finished loading.
  public func viewDidLoad() { self.viewDidLoadObserver.send(value: ()) }

  /// Emits payment method card summary data for the current backing.
  public let configurePaymentMethodView: Signal<ManagePledgePaymentMethodViewData, Never>
  /// Emits itemized pledge summary data for `ManagePledgeSummaryViewController`.
  public let configurePledgeSummaryView: Signal<ManagePledgeSummaryViewData, Never>
  /// Emits Plot installment increments when displaying a Pledge Over Time schedule.
  public let configurePlotPaymentScheduleView: Signal<[PledgePaymentIncrement], Never>
  /// Emits when the pull-to-refresh control should finish animating.
  public let endRefreshing: Signal<Void, Never>
  /// Emits configuration to push `CancelPledgeViewController`.
  public let goToCancelPledge: Signal<CancelPledgeViewData, Never>
  /// Emits pledge configuration to update the backing's payment method.
  public let goToChangePaymentMethod: Signal<PledgeViewData, Never>
  /// Emits creator message recipient subject and analytics context.
  public let goToContactCreator: Signal<(MessageSubject, KSRAnalytics.MessageDialogContext), Never>
  /// Emits pledge configuration to fix a failed payment method.
  public let goToFixPaymentMethod: Signal<PledgeViewData, Never>
  /// Emits project when viewing or switching rewards.
  public let goToRewards: Signal<Project, Never>
  /// Emits project when editing a Pledge Over Time backing.
  public let goToEditPledgeOverTime: Signal<Project, Never>
  /// Emits the project and distinct list of backed reward + add-on items for display.
  public let loadProjectAndRewardsIntoDataSource: Signal<(Project, [Reward]), Never>
  /// Emits when an initial load failure requires showing a pull-to-refresh recovery header.
  public let loadPullToRefreshHeaderView: Signal<(), Never>
  /// Emits whether the payment method card section is hidden.
  public let paymentMethodViewHidden: Signal<Bool, Never>
  /// Emits localized section header (`"Pledge details"` vs `"Your pledge details"`).
  public let pledgeDetailsSectionLabelText: Signal<String, Never>
  /// Emits whether the Pledge Over Time schedule section is hidden.
  public let plotPaymentScheduleViewHidden: Signal<Bool, Never>
  /// Emits an optional completion message when Manage Pledge should dismiss back to caller.
  public let notifyDelegateManagePledgeViewControllerFinishedWithMessage: Signal<String?, Never>
  /// Emits whether the navigation bar actions menu button is hidden.
  public let rightBarButtonItemHidden: Signal<Bool, Never>
  /// Emits available menu actions when the user taps the management menu button.
  public let showActionSheetMenuWithOptions: Signal<[ManagePledgeAlertAction], Never>
  /// Emits localized success banner copy after pledge updates.
  public let showSuccessBannerWithMessage: Signal<String, Never>
  /// Emits localized error banner copy when loading or restricted cancellation fails.
  public let showErrorBannerWithMessage: Signal<String, Never>
  /// Emits `HelpType` for opening help documentation in a web view.
  public let showWebHelp: Signal<HelpType, Never>
  /// Emits when the pull-to-refresh indicator should begin animating.
  public let startRefreshing: Signal<(), Never>
  /// Emits the localized navigation bar title.
  public let title: Signal<String, Never>

  /// Inputs receiver (`self`).
  public var inputs: ManagePledgeViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: ManagePledgeViewModelOutputs { return self }
}
