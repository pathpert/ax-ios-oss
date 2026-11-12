import Combine
import Foundation
import KDS
import SwiftUI

/// Observable view model formatting banner colors, alignment, icon state, and VoiceOver label from a configuration.
/// - Negative Constraint: Do not mutate presentation state after `init`; create a new instance per banner event.
public final class MessageBannerViewViewModel: ObservableObject, Equatable {
  /// Background fill color derived from the banner semantic type.
  @Published public var bannerBackgroundColor: Color
  /// Localized primary message string rendered inside the banner.
  @Published public var bannerMessage: String
  /// Combined VoiceOver announcement including dismiss instructions.
  @Published public var bannerMessageAccessibilityLabel: String
  /// Asset catalog image name for the banner leading icon, or `""` if none.
  @Published public var iconImageName: String
  /// Whether the leading status icon should be hidden.
  @Published public var iconIsHidden: Bool
  /// Tint color applied to the leading status icon.
  @Published public var iconTintColor: Color
  /// Text alignment applied to `bannerMessage`.
  @Published public var messageTextAlignment: TextAlignment
  /// Foreground text color applied to `bannerMessage`.
  @Published public var messageTextColor: Color

  /// Initializes the view model from a typed `MessageBannerConfiguration`.
  public init(_ configuration: MessageBannerConfiguration) {
    self.bannerBackgroundColor = Color(configuration.type.backgroundColor)
    self.bannerMessage = configuration.message
    self
      .bannerMessageAccessibilityLabel =
      "\(configuration.message) \(Strings.Message_banner_accessibility_Double_tap_to_dismiss())"
    self.iconImageName = configuration.type.iconImageName ?? ""
    self.iconIsHidden = configuration.type.shouldShowIconImage
    self.iconTintColor = Color(configuration.type.iconImageTintColor ?? LegacyColors.ksr_white.uiColor())
    self.messageTextAlignment = configuration.type == .info ? .center : .leading
    self.messageTextColor = Color(configuration.type.textColor)
  }

  /// Compares two banner view models by their displayed message text.
  public static func == (lhs: MessageBannerViewViewModel, rhs: MessageBannerViewViewModel) -> Bool {
    lhs.bannerMessage == rhs.bannerMessage
  }
}
