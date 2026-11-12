import KDS
import Library
import SwiftUI

/// Toast-style SwiftUI banner presenting transient status feedback with automatic VoiceOver-aware dismissal.
struct MessageBannerView: View {
  @Binding var viewModel: MessageBannerViewViewModel?
  @SwiftUI.Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

  private enum Constants {
    /// Spacing between optional icon and banner message text.
    public static let defaultSpacing = Styles.grid(2)
    /// Vertical inner banner padding.
    public static let verticalPadding = Styles.grid(3)
    /// Minimum height ensuring comfortable tap target and single-line centering.
    public static let minTextHeight = 40.0
    /// Standard auto-dismiss duration in seconds.
    public static let dismissTime = 4.0
    /// Extended auto-dismiss duration when VoiceOver is enabled.
    public static let dismissTimeVoiceoverOn = 10.0
  }

  var body: some View {
    if let vm = viewModel {
      HStack(alignment: .center, spacing: Constants.defaultSpacing) {
        if vm.iconImageName.count > 0 {
          Image(vm.iconImageName, bundle: Bundle.framework)
        }
        Text(vm.bannerMessage)
          .font(Font(UIFont.ksr_subhead()))
          .multilineTextAlignment(vm.messageTextAlignment)
          .frame(
            maxWidth: .infinity,
            minHeight: Constants.minTextHeight,
            alignment: self.alignmentFromTextAlignment(vm.messageTextAlignment)
          )
      }
      .foregroundColor(vm.messageTextColor)
      .padding(EdgeInsets(
        top: Constants.verticalPadding,
        leading: Constants.defaultSpacing,
        bottom: Constants.verticalPadding,
        trailing: Constants.defaultSpacing
      ))
      .background {
        RoundedRectangle(cornerRadius: Dimension.CornerRadius.small)
          .foregroundColor(vm.bannerBackgroundColor)
      }
      .accessibilityElement()
      .accessibilityLabel(vm.bannerMessageAccessibilityLabel)
      .onAppear {
        let dismissTime =
          self.voiceOverEnabled ? Constants.dismissTimeVoiceoverOn : Constants.dismissTime
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissTime) {
          self.viewModel = nil
        }
      }
      .onTapGesture {
        self.viewModel = nil
      }
    }
  }

  // MARK: - Helpers

  private func alignmentFromTextAlignment(_ textAligment: TextAlignment) -> Alignment {
    switch textAligment {
    case .center: return .center
    case .leading: return .leading
    case .trailing: return .trailing
    }
  }
}

#Preview {
  MessageBannerView(
    viewModel: .constant(
      MessageBannerViewViewModel(
        MessageBannerConfiguration(type: .success, message: "Short string")
      )
    )
  )
}
