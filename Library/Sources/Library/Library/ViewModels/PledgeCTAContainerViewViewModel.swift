import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// View model driving the persistent project pledge CTA container banner.
public final class PledgeCTAContainerViewViewModel: PledgeCTAContainerViewViewModelType,
  PledgeCTAContainerViewViewModelInputs, PledgeCTAContainerViewViewModelOutputs {
  /// Creates a new `PledgeCTAContainerViewViewModel`.
  public init() {
    let projectOrError = self.configData.signal
      .skipNil()
      .map { $0.projectOrError }
      .skipNil()

    let isLoading = self.configData.signal
      .skipNil()
      .map { $0.isLoading }

    let project = projectOrError
      .map(Either.left)
      .skipNil()

    let projectError = projectOrError
      .map(Either.right)
      .skipNil()

    self.activityIndicatorIsHidden = isLoading
      .negate()

    let backing = project.map { $0.personalization.backing }

    let savedProjectFromNotificationAfterDebounce = self.savedProjectFromNotificationProperty.signal.skipNil()
      .ksr_debounce(.milliseconds(100), on: AppEnvironment.current.scheduler)

    self.pledgeState <~ Signal
      .merge(
        Signal.combineLatest(project, backing),
        savedProjectFromNotificationAfterDebounce
      )
      .map(pledgeCTAState(project:backing:))
      .skipRepeats()

    let inError = Signal.merge(
      projectError.ignoreValues().mapConst(true),
      project.ignoreValues().mapConst(false),
      // TODO: these changes are temporary and will likely be removed when we get to the native implementation in this ticket [MBL-2012](https://kickstarter.atlassian.net/browse/MBL-2012)
      // The purpose of this change is to force the error state when a non-PLOT pledge has a backing state of "authentication_required"
      project.filter {
        $0.personalization.backing?.status == .authenticationRequired && $0.personalization.backing?
          .paymentIncrements.isEmpty == true
      }.mapConst(true)
    )

    let updateButtonStates = Signal.merge(
      projectOrError.ignoreValues(),
      isLoading.filter(isFalse).ignoreValues()
    )

    self.notifyDelegateCTATapped = self.pledgeState.signal.skipNil()
      .takeWhen(self.pledgeCTAButtonTappedProperty.signal)

    self.retryStackViewIsHidden = inError
      .map(isFalse)
      .takeWhen(updateButtonStates)
      .merge(with: isLoading.filter(isTrue).mapConst(true))
      .skipRepeats()

    self.pledgeCTAButtonIsHidden = inError
      .map(isTrue)
      .takeWhen(updateButtonStates)
      .merge(with: isLoading.filter(isTrue).mapConst(true))
      .skipRepeats()

    self.prelaunchState <~ self.pledgeState.signal.skipNil().map { state -> PledgeCTAPrelaunchState in
      switch state {
      case let .prelaunch(saved, watchCount):
        return PledgeCTAPrelaunchState(
          prelaunch: true,
          saved: saved,
          watchesCount: watchCount
        )
      default:
        return PledgeCTAPrelaunchState(prelaunch: false, saved: false, watchesCount: 0)
      }
    }

    self.prelaunchCTASaved = self.prelaunchState.signal.skipNil()

    self.watchesLabelIsHidden = self.prelaunchState.signal.skipNil()
      .map { !$0.prelaunch }

    let updatedWatchCountProject = project
      .takePairWhen(self.prelaunchState.signal.skipNil())
      .map { project, prelaunchStateValue -> Project in
        let updatedProjectWithWatchesCount = project |> \.watchesCount .~ prelaunchStateValue.watchesCount

        return updatedProjectWithWatchesCount
      }

    self.buttonStyleType = self.pledgeState.signal.skipNil().map { $0.buttonStyle }
    self.buttonTitleText = self.pledgeState.signal.skipNil().map { $0.buttonTitle }
    let stackViewAndSpacerAreHidden = Signal.merge(
      self.pledgeState.signal.skipNil().map { $0.stackViewAndSpacerAreHidden },
      // Always hide the main stack view + spacer if we're not showing the pledge button
      self.pledgeCTAButtonIsHidden.filter { $0 == true }
    )
    self.spacerIsHidden = stackViewAndSpacerAreHidden
    self.stackViewIsHidden = stackViewAndSpacerAreHidden
    self.titleText = self.pledgeState.signal.skipNil().map { $0.titleLabel }.skipNil()
    self.watchesCountText = Signal.merge(project, updatedWatchCountProject)
      .map { project in
        let watchesCountText = project.watchesCount ?? 0

        return Strings.activity_followers(number_of_followers: "\(watchesCountText)")
      }

    self.subtitleText = Signal.combineLatest(project, self.pledgeState.signal.skipNil())
      .map(pledgeCTASubtitle(project:pledgeState:))

    let pledgeTypeAndProject = Signal.combineLatest(self.pledgeState.signal.skipNil(), project)

    // Tracking
    pledgeTypeAndProject
      .takeWhen(self.pledgeCTAButtonTappedProperty.signal)
      .observeValues { state, project in

        AppEnvironment.current.ksrAnalytics.trackPledgeCTAButtonClicked(
          stateType: state,
          project: project
        )
      }
  }

  private var pledgeState = MutableProperty<PledgeStateCTAType?>(nil)
  private var prelaunchState = MutableProperty<PledgeCTAPrelaunchState?>(nil)

  fileprivate let configData = MutableProperty<PledgeCTAContainerViewData?>(nil)
  /// Configures the CTA with loading, project, or error state.
  public func configureWith(value: PledgeCTAContainerViewData) {
    self.configData.value = value
  }

  fileprivate let pledgeCTAButtonTappedProperty = MutableProperty(())
  /// Signals that the user tapped the pledge CTA button.
  public func pledgeCTAButtonTapped() {
    self.pledgeCTAButtonTappedProperty.value = ()
  }

  fileprivate let savedProjectFromNotificationProperty = MutableProperty<(Project, Backing?)?>(nil)
  /// Updates the CTA state when a project save notification provides an updated project.
  public func savedProjectFromNotification(project: Project?) {
    guard let projectValue = project else { return }
    self.savedProjectFromNotificationProperty.value = (projectValue, projectValue.personalization.backing)
  }

  /// Input receiver (`self`).
  public var inputs: PledgeCTAContainerViewViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: PledgeCTAContainerViewViewModelOutputs { return self }

  /// Emits whether the loading activity indicator is hidden.
  public let activityIndicatorIsHidden: Signal<Bool, Never>
  /// Emits the button style type for the primary CTA.
  public let buttonStyleType: Signal<ButtonStyleType, Never>
  /// Emits the localized button title text for the primary CTA.
  public let buttonTitleText: Signal<String, Never>
  /// Emits prelaunch saved state and watch count updates.
  public let prelaunchCTASaved: Signal<PledgeCTAPrelaunchState, Never>
  /// Emits the CTA state when the button is tapped.
  public let notifyDelegateCTATapped: Signal<PledgeStateCTAType, Never>
  /// Emits whether the CTA button is hidden.
  public let pledgeCTAButtonIsHidden: Signal<Bool, Never>
  /// Emits whether the prelaunch watches count label is hidden.
  public let watchesLabelIsHidden: Signal<Bool, Never>
  /// Emits whether the retry stack view is hidden.
  public let retryStackViewIsHidden: Signal<Bool, Never>
  /// Emits whether the layout spacer is hidden.
  public let spacerIsHidden: Signal<Bool, Never>
  /// Emits whether the CTA content stack view is hidden.
  public let stackViewIsHidden: Signal<Bool, Never>
  /// Emits the subtitle text describing backing details or error messaging.
  public let subtitleText: Signal<String, Never>
  /// Emits the heading title text.
  public let titleText: Signal<String, Never>
  /// Emits localized prelaunch watcher count text.
  public let watchesCountText: Signal<String, Never>
}
