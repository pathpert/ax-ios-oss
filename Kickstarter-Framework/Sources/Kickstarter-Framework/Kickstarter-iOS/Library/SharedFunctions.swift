import Library
import UIKit

// MARK: - Haptic feedback

func generateImpactFeedback(
  feedbackGenerator: UIImpactFeedbackGeneratorType = UIImpactFeedbackGenerator(style: .light)
) {
  feedbackGenerator.prepare()
  feedbackGenerator.impactOccurred()
}

func generateNotificationSuccessFeedback(
  feedbackGenerator: UINotificationFeedbackGeneratorType = UINotificationFeedbackGenerator()
) {
  feedbackGenerator.prepare()
  feedbackGenerator.notificationOccurred(.success)
}

func generateNotificationWarningFeedback(
  feedbackGenerator: UINotificationFeedbackGeneratorType = UINotificationFeedbackGenerator()
) {
  feedbackGenerator.prepare()
  feedbackGenerator.notificationOccurred(.warning)
}

func generateSelectionFeedback(
  feedbackGenerator: UISelectionFeedbackGeneratorType = UISelectionFeedbackGenerator()
) {
  feedbackGenerator.prepare()
  feedbackGenerator.selectionChanged()
}

// MARK: - Login workflow

/// Clears the active user session, resets push notification prompts, posts `.ksr_sessionEnded`, and dismisses `viewController`.
/// - Negative Constraint: Do not call directly to switch accounts without clearing persisted keychain tokens via `appEnvironment.logout()`.
public func logoutAndDismiss(
  viewController: UIViewController,
  appEnvironment: AppEnvironmentType.Type = AppEnvironment.self,
  pushNotificationDialog: PushNotificationDialogType.Type =
    PushNotificationDialog.self
) {
  appEnvironment.logout()

  pushNotificationDialog.resetAllContexts()

  NotificationCenter.default.post(.init(name: .ksr_sessionEnded))

  viewController.dismiss(animated: true, completion: nil)
}
