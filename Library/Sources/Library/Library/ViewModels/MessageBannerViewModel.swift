import Prelude
import ReactiveSwift
import UIKit

/// Strongly-typed configuration contract for displaying an in-app message banner.
///
/// Negative Constraint: Keep `message` concise (1–2 lines); do not include raw HTTP stack traces.
public struct MessageBannerConfiguration: Equatable {
  /// Visual severity/style category (`.success`, `.error`, `.info`).
  public let type: MessageBannerType
  /// Localized user-facing banner copy.
  public let message: String

  /// Creates a typed `MessageBannerConfiguration` contract.
  public init(type: MessageBannerType, message: String) {
    self.type = type
    self.message = message
  }
}

/// Inputs accepted by `MessageBannerViewModel`.
public protocol MessageBannerViewModelInputs {
  /// Reports completion of the banner show/hide animation.
  func bannerViewAnimationFinished(isHidden: Bool)
  /// Shows or hides the banner view.
  func bannerViewWillShow(_ show: Bool)
  /// Configures the banner with severity type and copy.
  func update(with configuration: MessageBannerConfiguration)
}

/// Outputs exposed by `MessageBannerViewModel`.
public protocol MessageBannerViewModelOutputs {
  /// Emits the banner background color.
  var bannerBackgroundColor: Signal<UIColor, Never> { get }
  /// Emits the banner message string.
  var bannerMessage: Signal<String, Never> { get }
  /// Emits the accessibility label combining the message with dismissal instructions.
  var bannerMessageAccessibilityLabel: Signal<String, Never> { get }
  /// Emits the leading status icon asset name.
  var iconImageName: Signal<String, Never> { get }
  /// Emits whether the status icon should be hidden.
  var iconIsHidden: Signal<Bool, Never> { get }
  /// Emits the tint color applied to the status icon.
  var iconTintColor: Signal<UIColor, Never> { get }
  /// Emits whether the banner view should be hidden (with auto-dismissal debounce).
  var messageBannerViewIsHidden: Signal<Bool, Never> { get }
  /// Emits text alignment for the banner message label.
  var messageTextAlignment: Signal<NSTextAlignment, Never> { get }
  /// Emits foreground text color for the banner message label.
  var messageTextColor: Signal<UIColor, Never> { get }
}

/// Combined inputs and outputs interface for `MessageBannerViewModel`.
public protocol MessageBannerViewModelType {
  /// The view model's inputs.
  var inputs: MessageBannerViewModelInputs { get }
  /// The view model's outputs.
  var outputs: MessageBannerViewModelOutputs { get }
}

/// View model managing styling, VoiceOver accessibility copy, and auto-dismissal timers for `MessageBannerView`.
public class MessageBannerViewModel: MessageBannerViewModelType,
  MessageBannerViewModelInputs, MessageBannerViewModelOutputs {
  /// Creates a new `MessageBannerViewModel`.
  public init() {
    let bannerType = self.messageBannerConfiguration.signal
      .skipNil()
      .map(\.type)

    self.bannerBackgroundColor = bannerType
      .map { $0.backgroundColor }

    self.iconTintColor = bannerType
      .map { $0.iconImageTintColor }
      .skipNil()

    self.iconImageName = bannerType
      .map { $0.iconImageName }
      .skipNil()

    self.iconIsHidden = bannerType
      .map { $0.shouldShowIconImage }
      .negate()

    self.messageTextColor = bannerType.map { $0.textColor }
    self.messageTextAlignment = bannerType.map { $0.textAlignment }

    self.bannerMessage = self.messageBannerConfiguration.signal.skipNil().map(\.message)
    self.bannerMessageAccessibilityLabel = self.bannerMessage
      .map { "\($0) \(Strings.Message_banner_accessibility_Double_tap_to_dismiss())" }

    let bannerViewShouldHide = self.showBannerViewProperty.signal.negate()

    let dismissBanner = self.bannerViewIsHiddenProperty.signal
      .filter(isFalse)

    // Dismisses the banner after 4 seconds when VoiceOver is OFF
    // This should give the user enough time to read the banner
    let dismissBannerVoiceOverOff = dismissBanner
      .filter { _ in !AppEnvironment.current.isVoiceOverRunning() }
      .debounce(4, on: QueueScheduler.main)
      .negate()

    // Dismisses the banner after 10 seconds when VoiceOver is ON
    // This should give the VoiceOver reader enough time to read the banner
    let dismissBannerVoiceOverOn = dismissBanner
      .filter { _ in AppEnvironment.current.isVoiceOverRunning() }
      .debounce(10, on: QueueScheduler.main)
      .negate()

    let postAnimationBannerViewShouldHide = Signal.merge(
      dismissBannerVoiceOverOff,
      dismissBannerVoiceOverOn
    )

    let bannerShouldHide = Signal.merge(bannerViewShouldHide, postAnimationBannerViewShouldHide)

    self.messageBannerViewIsHidden = bannerShouldHide.skipRepeats()
  }

  private var showBannerViewProperty = MutableProperty(false)
  /// Triggers displaying or hiding the banner.
  public func bannerViewWillShow(_ show: Bool) {
    self.showBannerViewProperty.value = show
  }

  private var bannerViewIsHiddenProperty = MutableProperty(true)
  /// Notifies the view model when banner visibility animation finishes so auto-dismiss timers start.
  public func bannerViewAnimationFinished(isHidden: Bool) {
    self.bannerViewIsHiddenProperty.value = isHidden
  }

  private var messageBannerConfiguration = MutableProperty<MessageBannerConfiguration?>(nil)
  /// Updates the displayed banner severity and message text.
  public func update(with configuration: MessageBannerConfiguration) {
    self.messageBannerConfiguration.value = configuration
  }

  /// Emits the banner background color.
  public let bannerBackgroundColor: Signal<UIColor, Never>
  /// Emits the displayed banner message.
  public let bannerMessage: Signal<String, Never>
  /// Emits the accessibility label for VoiceOver users.
  public let bannerMessageAccessibilityLabel: Signal<String, Never>
  /// Emits the icon image asset name.
  public let iconImageName: Signal<String, Never>
  /// Emits whether the status icon is hidden.
  public let iconIsHidden: Signal<Bool, Never>
  /// Emits the icon tint color.
  public let iconTintColor: Signal<UIColor, Never>
  /// Emits whether the banner should be hidden.
  public let messageBannerViewIsHidden: Signal<Bool, Never>
  /// Emits the text alignment for the banner label.
  public let messageTextAlignment: Signal<NSTextAlignment, Never>
  /// Emits the text color for the banner label.
  public let messageTextColor: Signal<UIColor, Never>

  /// The inputs interface for this view model.
  public var inputs: MessageBannerViewModelInputs {
    return self
  }

  /// The outputs interface for this view model.
  public var outputs: MessageBannerViewModelOutputs {
    return self
  }
}
