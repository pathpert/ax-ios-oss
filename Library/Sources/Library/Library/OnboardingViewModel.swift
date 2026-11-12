import AppTrackingTransparency
import Foundation
import KsApi
import ReactiveSwift
import UserNotifications

/// Inputs accepted by `OnboardingViewModel`.
public protocol OnboardingViewModelInputs {
  /// Handles tapping the Allow Tracking CTA on the onboarding ATT prompt card.
  func allowTrackingTapped()
  /// Records the system App Tracking Transparency authorization result.
  func didCompleteAppTrackingDialog(with authStatus: ATTrackingManager.AuthorizationStatus)
  /// Records the system push notification authorization result.
  func didCompletePushNotificationsDialog(with authStatus: UNAuthorizationStatus)
  /// Handles tapping the Get Notified CTA on the onboarding notifications card.
  func getNotifiedTapped()
  /// Handles tapping the login/signup button from onboarding.
  func goToLoginSignupTapped()
  /// Advances tracking when moving to the specified onboarding item.
  func goToNextItemTapped(item: OnboardingItem)
  /// Records initial presentation of the onboarding welcome step.
  func onAppear()
  /// Records dismissal/completion of the onboarding flow.
  func onboardingFlowEnded()
}

/// Outputs emitted by `OnboardingViewModel`.
public protocol OnboardingViewModelOutputs {
  /// Producer emitting the ordered onboarding items to display.
  var onboardingItems: SignalProducer<[OnboardingItem], Never> { get }
  /// Emits when push notification authorization prompting finishes.
  var didCompletePushNotificationSystemDialog: Signal<Void, Never> { get }
  /// Emits when the App Tracking Transparency system prompt should be triggered.
  var triggerAppTrackingTransparencyPopup: Signal<Void, Never> { get }
}

/// Interface combining inputs and outputs for `OnboardingViewModel`.
public protocol OnboardingViewModelType {
  /// Input receiver for onboarding user actions and system prompt callbacks.
  var inputs: OnboardingViewModelInputs { get }
  /// Output signals driving onboarding items and system prompts.
  var outputs: OnboardingViewModelOutputs { get }
}

/// View model coordinating onboarding steps, permissions prompts, and analytics tracking.
public final class OnboardingViewModel: OnboardingViewModelType, Equatable & Identifiable & ObservableObject,
  OnboardingViewModelOutputs, OnboardingViewModelInputs {
  // MARK: - Properties

  private let useCase: OnboardingUseCaseType

  // MARK: - Outputs

  /// Producer emitting the onboarding carousel items.
  public let onboardingItems: SignalProducer<[OnboardingItem], Never>
  /// Emits after the push notification permission flow completes.
  public let didCompletePushNotificationSystemDialog: Signal<Void, Never>
  /// Emits when the App Tracking Transparency prompt is displayed.
  public let triggerAppTrackingTransparencyPopup: Signal<Void, Never>

  // MARK: - Init

  /// Initializes the onboarding view model with the bundle containing onboarding resources.
  public init(with bundle: Bundle = .library) {
    self.useCase = OnboardingUseCase(for: bundle)

    self.onboardingItems = self.useCase.uiOutputs.onboardingItems

    self.didCompletePushNotificationSystemDialog = self.useCase.outputs
      .didCompletePushNotificationSystemDialog

    self.triggerAppTrackingTransparencyPopup = self.useCase.outputs.triggerAppTrackingTransparencyDialog
      .map { _ in
        AppEnvironment.current.ksrAnalytics
          .trackSystemPermissionsDialogViewed(on: .onboardingAppTrackingDialog)

        return ()
      }
  }

  /// Compares two `OnboardingViewModel` instances by object identity.
  public static func == (lhs: OnboardingViewModel, rhs: OnboardingViewModel) -> Bool {
    lhs.id == rhs.id
  }

  /// Returns `self` as `OnboardingViewModelInputs`.
  public var inputs: OnboardingViewModelInputs { return self }
  /// Returns `self` as `OnboardingViewModelOutputs`.
  public var outputs: OnboardingViewModelOutputs { return self }

  // MARK: - Inputs

  /// Tracks initial appearance of the onboarding welcome screen.
  public func onAppear() {
    AppEnvironment.current.ksrAnalytics.trackOnboardingPageViewed(at: .welcome)
  }

  /// Forwards the Get Notified CTA tap and logs analytics.
  public func getNotifiedTapped() {
    self.useCase.uiInputs.getNotifiedTapped()

    AppEnvironment.current.ksrAnalytics.trackOnboardingPageButtonTapped(
      context: .onboardingGetNotified,
      item: .enableNotifications
    )
  }

  /// Forwards the Allow Tracking CTA tap and logs analytics.
  public func allowTrackingTapped() {
    self.useCase.uiInputs.allowTrackingTapped()

    AppEnvironment.current.ksrAnalytics.trackOnboardingPageButtonTapped(
      context: .onboardingAllowTracking,
      item: .allowTracking
    )
  }

  /// Logs the outcome of the push notification system permission dialog.
  public func didCompletePushNotificationsDialog(with authStatus: UNAuthorizationStatus) {
    /// Send analytics event when the user has finished interacting with the PN system dialog. `authStatus` let's insights know whether they allowed or denied permissions.

    AppEnvironment.current.ksrAnalytics.trackPushNotificationPermissionsDialogInteraction(
      .onboardingNotificationsDialog,
      authStatus: authStatus
    )
  }

  /// Logs authorized App Tracking Transparency permission interactions.
  public func didCompleteAppTrackingDialog(with authStatus: ATTrackingManager.AuthorizationStatus) {
    /// Send analytics event if the user has allowed AppTracking permission.
    guard authStatus == .authorized else { return }

    AppEnvironment.current.ksrAnalytics.trackAppTrackingTransparencyPermissionsDialogInteraction(
      .onboardingAppTrackingDialog
    )
  }

  /// Tracks transitioning from onboarding to login/signup.
  public func goToLoginSignupTapped() {
    AppEnvironment.current.ksrAnalytics.trackOnboardingPageButtonTapped(
      context: .onboardingSignUpLogIn,
      item: .loginSignUp
    )

    AppEnvironment.current.ksrAnalytics.trackOnboardingPageButtonTapped(context: .onboardingClose)
  }

  /// Tracks completion/dismissal of the onboarding carousel.
  public func onboardingFlowEnded() {
    AppEnvironment.current.ksrAnalytics.trackOnboardingPageButtonTapped(context: .onboardingClose)
  }

  /// Tracks viewing and advancing to a given `OnboardingItem`.
  public func goToNextItemTapped(item: OnboardingItem) {
    AppEnvironment.current.ksrAnalytics.trackOnboardingPageViewed(at: item.type)
    AppEnvironment.current.ksrAnalytics.trackOnboardingPageButtonTapped(
      context: .onboardingNext,
      item: item.type
    )
  }
}
