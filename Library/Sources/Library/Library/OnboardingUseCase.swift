import Foundation
import KsApi
import Lottie
import ReactiveSwift
import UIKit

/// Logical step identifiers displayed across the onboarding carousel.
public enum OnboardingItemType {
  /// Welcome splash, save-projects primer, notification prompt, tracking prompt, and login/signup steps.
  case welcome, saveProjects, enableNotifications, allowTracking, loginSignUp

  /// Used to send analytics around whether the user decided to skip the push notification or apptracking permission request dialogs.
  var isPermissionType: Bool {
    switch self {
    case .allowTracking, .enableNotifications:
      return true
    default:
      return false
    }
  }

  var lottieFileName: String {
    switch self {
    case .welcome:
      "onboarding-flow-welcome"
    case .allowTracking:
      "onboarding-flow-activity-tracking"
    case .enableNotifications:
      "onboarding-flow-enable-notifications"
    case .saveProjects:
      "onboarding-flow-save-projects"
    case .loginSignUp:
      "onboarding-flow-login-signup"
    }
  }
}

/// Model representing a single step card in the onboarding carousel.
public struct OnboardingItem: Identifiable, Equatable {
  /// Stable unique identifier for SwiftUI `ForEach` / diffing.
  public let id: UUID = .init()
  /// Localized headline title for the onboarding step.
  public let title: String
  /// Localized explanatory subtitle for the onboarding step.
  public let subtitle: String
  /// Configured Lottie animation view displayed on the step card.
  public var lottieView: LottieAnimationView = .init()
  /// Logical onboarding step type.
  public let type: OnboardingItemType

  /// Creates an `OnboardingItem` model.
  public init(
    title: String,
    subtitle: String,
    lottieView: LottieAnimationView = .init(),
    type: OnboardingItemType
  ) {
    self.title = title
    self.subtitle = subtitle
    self.lottieView = lottieView
    self.type = type
  }
}

/// Combined inputs and outputs interface for `OnboardingUseCase`.
public protocol OnboardingUseCaseType {
  /// UI-driven inputs for onboarding interactions.
  var uiInputs: OnboardingUseCaseUIInputs { get }
  /// UI-facing data stream outputs.
  var uiOutputs: OnboardingUseCaseUIOutputs { get }
  /// Coordinator/system dialog event outputs.
  var outputs: OnboardingUseCaseOutputs { get }
}

/// User interaction inputs accepted by `OnboardingUseCase`.
public protocol OnboardingUseCaseUIInputs {
  /// Triggers the AppTrackingTransparency system dialog.
  func allowTrackingTapped()

  /// Triggers the Push notifications  system dialog.
  func getNotifiedTapped()

  /// Call when a user taps on the "Next", "Not right now", or "Explore the app" buttons.
  func goToNextItemTapped(item: OnboardingItemType)
}

/// UI data streams exposed by `OnboardingUseCase`.
public protocol OnboardingUseCaseUIOutputs {
  /// Emits the ordered array of onboarding cards to render.
  var onboardingItems: SignalProducer<[OnboardingItem], Never> { get }
}

/// System-permission outputs exposed by `OnboardingUseCase`.
public protocol OnboardingUseCaseOutputs {
  /// Emits when the user has finished interacting with the Push Notificaiton system dialog.
  var triggerAppTrackingTransparencyDialog: Signal<Void, Never> { get }

  /// Emits when the user has finished interacting with the Push Notification system permission dialog.
  var didCompletePushNotificationSystemDialog: Signal<Void, Never> { get }
}

/// A use case that outputs `OnboardingItem`s, checks/requests push and tracking permissions, and emits onboarding analytics.
/// - Negative Constraint: Do not instantiate directly inside views; wire through the owning onboarding view model.
public final class OnboardingUseCase: OnboardingUseCaseType, OnboardingUseCaseUIInputs,
  OnboardingUseCaseUIOutputs, OnboardingUseCaseOutputs {
  // MARK: - Initialization

  /// Injecting a bundle so that we can test that the correct Lottie JSON files are being loaded as expected.
  init(for bundle: Bundle = .library) {
    let onboardingItems = allOnboardingItems(in: bundle)

    self.onboardingItems = SignalProducer(value: onboardingItems)

    self.triggerAppTrackingTransparencyDialog = self.allowTrackingTappedSignal.signal
      .filter {
        let appTrackingTransparency = AppEnvironment.current.appTrackingTransparency
        return appTrackingTransparency.advertisingIdentifier == nil && appTrackingTransparency
          .shouldRequestAuthorizationStatus()
      }
      .map { _ in () }

    self.didCompletePushNotificationSystemDialog = self.getNotifiedTappedSignal.signal
      .flatMap {
        let pushRegistrationType = AppEnvironment.current.pushRegistrationType

        /// First, check if push notifications have already been authorized.
        return pushRegistrationType.hasAuthorizedNotifications()
          // hasAuthorizedNotifications() sends its events on a background thread.
          // `observeForUI` is a bit of a misnomer. We're not observing the `SignalProducer`,
          // just making sure it forwards all its events on the UI scheduler before flatMap is called.
          .observeForUI()
          .flatMap { hasAuthorized -> SignalProducer<Bool, Never> in
            if hasAuthorized {
              /// If already authorized, do nothing.
              return .empty
            } else {
              /// Otherwise, trigger the system dialog to request authorization and emit an analytics event.
              AppEnvironment.current.ksrAnalytics
                .trackSystemPermissionsDialogViewed(on: .onboardingNotificationsDialog)

              return pushRegistrationType.register(for: [.alert, .sound, .badge])
            }
          }
      }
      /// Map any output to Void, since we only care about triggering the dialog
      .mapConst(())

    _ = self.goToNextItemTappedSignal.signal
  }

  // MARK: - Inputs

  private let (getNotifiedTappedSignal, getNotifiedTappedObserver) = Signal<Void, Never>.pipe()
  /// Requests push notification authorization from the system.
  public func getNotifiedTapped() {
    self.getNotifiedTappedObserver.send(value: ())
  }

  private let (allowTrackingTappedSignal, allowTrackingTappedObserver) = Signal<Void, Never>.pipe()
  /// Requests App Tracking Transparency authorization from the system.
  public func allowTrackingTapped() {
    self.allowTrackingTappedObserver.send(value: ())
  }

  private let (goToNextItemTappedSignal, goToNextItemTappedObserver) = Signal<OnboardingItemType, Never>
    .pipe()
  /// Advances past the current onboarding step and records skip analytics when applicable.
  public func goToNextItemTapped(item: OnboardingItemType) {
    self.goToNextItemTappedObserver.send(value: item)
  }

  // MARK: - UI Outputs

  /// Emits when App Tracking Transparency prompting has completed.
  public let triggerAppTrackingTransparencyDialog: Signal<Void, Never>
  /// Emits when the system push-notification prompt finishes.
  public let didCompletePushNotificationSystemDialog: Signal<Void, Never>

  // MARK: - Data Outputs

  /// Producer emitting the localized list of `OnboardingItem` cards.
  public let onboardingItems: SignalProducer<[OnboardingItem], Never>

  // MARK: - Type

  /// The UI inputs interface.
  public var uiInputs: any OnboardingUseCaseUIInputs { return self }
  /// The UI outputs interface.
  public var uiOutputs: any OnboardingUseCaseUIOutputs { return self }
  /// The coordinator outputs interface.
  public var outputs: any OnboardingUseCaseOutputs { return self }
}

// MARK: - Helpers

private func allOnboardingItems(
  in bundle: Bundle = .library
) -> [OnboardingItem] {
  return [
    makeOnboardingItem(
      title: Strings.onboarding_welcome_to_kickstarter_title(),
      subTitle: Strings.onboarding_welcome_to_kickstarter_subtitle(),
      type: .welcome,
      in: bundle
    ),
    makeOnboardingItem(
      title: Strings.onboarding_save_projects_for_later_title(),
      subTitle: Strings.onboarding_save_projects_for_later_subtitle(),
      type: .saveProjects,
      in: bundle
    ),
    makeOnboardingItem(
      title: Strings.onboarding_personalize_your_experience_title(),
      subTitle: Strings.onboarding_personalize_your_experience_subtitle(),
      type: .allowTracking,
      in: bundle
    ),
    makeOnboardingItem(
      title: Strings.onboarding_stay_in_the_know_title(),
      subTitle: Strings.onboarding_stay_in_the_know_subtitle(),
      type: .enableNotifications,
      in: bundle
    ),
    makeOnboardingItem(
      title: Strings.onboarding_join_the_community_title(),
      subTitle: Strings.onboarding_join_the_community_subtitle(),
      type: .loginSignUp,
      in: bundle
    )
  ]
  .compactMap { $0 }
}

private func makeOnboardingItem(
  title: String,
  subTitle: String,
  type: OnboardingItemType,
  in bundle: Bundle = .library
) -> OnboardingItem? {
  guard let lottieName = localizedOnboardingLottieFile(for: type.lottieFileName, in: bundle) else {
    assertionFailure("Missing Lottie file for onboarding type: \(type)")
    return nil
  }

  return OnboardingItem(
    title: title,
    subtitle: subTitle,
    lottieView: .init(name: lottieName, bundle: bundle),
    type: type
  )
}
