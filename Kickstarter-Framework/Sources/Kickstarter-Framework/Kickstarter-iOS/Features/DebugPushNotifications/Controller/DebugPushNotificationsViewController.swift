import KDS
import Library
import Prelude
import UIKit
import UserNotifications

/// Controller/component implementing `DebugPushNotificationsViewController`.
internal final class DebugPushNotificationsViewController: UIViewController {
  @IBOutlet fileprivate var rootStackView: UIStackView!
  @IBOutlet fileprivate var scrollView: UIScrollView!
  @IBOutlet fileprivate var separatorViews: [UIView]!

  override func viewDidLoad() {
    super.viewDidLoad()

    _ = self
      |> \.title .~ "Push notifications"
  }

  internal override func bindStyles() {
    super.bindStyles()

    _ = self
      |> baseControllerStyle()

    let rowsStackViews = self.rootStackView.arrangedSubviews.compactMap { $0 as? UIStackView }
    let rowStackViews = rowsStackViews.flatMap { rows in
      rows.arrangedSubviews.compactMap { $0 as? UIStackView }
    }
    let buttonStackViews = rowStackViews.compactMap { $0.arrangedSubviews.last as? UIStackView }
    let titleLabels = self.rootStackView.arrangedSubviews.compactMap { $0 as? UILabel }
    let buttons = buttonStackViews
      .flatMap { stackView in stackView.arrangedSubviews.compactMap { $0 as? UIButton } }
    let inAppButtons = buttons.enumerated().filter { idx, _ in idx % 2 == 0 }.map(second)
    let delayedButtons = buttons.enumerated().filter { idx, _ in idx % 2 == 1 }.map(second)

    _ = self.rootStackView
      |> UIStackView.lens.spacing .~ Styles.grid(3)

    _ = self.scrollView
      |> UIScrollView.lens.delaysContentTouches .~ false

    _ = rowsStackViews
      ||> UIStackView.lens.spacing .~ Styles.grid(2)

    _ = rowStackViews
      ||> UIStackView.lens.distribution .~ .equalSpacing
      ||> UIStackView.lens.alignment .~ .center

    _ = buttonStackViews
      ||> UIStackView.lens.spacing .~ Styles.grid(1)

    _ = titleLabels
      ||> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      ||> UILabel.lens.font .~ .ksr_title1(size: 22)

    _ = rowStackViews.compactMap { $0.arrangedSubviews.first as? UILabel }
      ||> UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
      ||> UILabel.lens.font .~ .ksr_body()

    for button in buttons {
      button.applyStyleConfiguration(KSRButtonStyle.green)
    }
    _ = buttons
      ||> UIButton.lens.contentEdgeInsets %~ {
        .init(top: $0.top / 2, left: $0.left / 2, bottom: $0.bottom / 2, right: $0.right / 2)
      }

    inAppButtons.enumerated().forEach { idx, button in
      _ = button
        |> UIButton.lens.tag .~ idx
        |> UIButton.lens.title(for: .normal) .~ "In-app"
        |> UIButton.lens.targets .~ [(self, #selector(self.inAppButtonTapped(_:)), .touchUpInside)]
    }

    delayedButtons.enumerated().forEach { idx, button in
      _ = button
        |> UIButton.lens.tag .~ idx
        |> UIButton.lens.title(for: .normal) .~ "Delayed"
        |> UIButton.lens.targets .~ [(self, #selector(self.delayedButtonTapped(_:)), .touchUpInside)]
    }

    _ = self.separatorViews
      ||> separatorStyle
  }

  @objc fileprivate func inAppButtonTapped(_ button: UIButton) {
    self.scheduleNotification(forIndex: button.tag, delay: false)
  }

  @objc fileprivate func delayedButtonTapped(_ button: UIButton) {
    self.scheduleNotification(forIndex: button.tag, delay: true)
  }

  fileprivate func scheduleNotification(forIndex index: Int, delay: Bool) {
    guard index >= 0, index < debugPushNotificationSamples.count else { return }

    let sample = debugPushNotificationSamples[index]
    self.addNotificationRequest(delay: delay, sample: sample)
  }

  private func addNotificationRequest(delay: Bool, sample: DebugPushNotificationSample) {
    let identifier = "notify-test"

    let content = UNMutableNotificationContent()
    content.body = sample.alert
    content.userInfo = sample.userInfo
    content.categoryIdentifier = identifier

    // timeInterval must be greater than 0.
    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: delay ? 5 : 0.5,
      repeats: false
    )

    let request = UNNotificationRequest(
      identifier: identifier,
      content: content,
      trigger: trigger
    )

    UNUserNotificationCenter.current().add(request)
  }
}
