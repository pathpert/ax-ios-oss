import FBSDKShareKit
import KDS
import Kingfisher
import Library
import SwiftUI

extension VideoFeedShareSheetView {
  // MARK: - Presenting View Controller

  func presentingViewController() -> UIViewController? {
    guard let windowScene = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .first(where: { $0.activationState == .foregroundActive }),
      let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
      return nil
    }

    var vc = window.rootViewController
    while let presented = vc?.presentedViewController {
      vc = presented
    }
    return vc
  }

  // MARK: - Facebook Feed

  func shareToFacebookFeed() {
    guard let url = VideoFeedShareDestination.projectURL(for: self.item, refTag: .videoFeedShareFacebookFeed),
          let presentingVC = self.presentingViewController() else { return }

    let content = ShareLinkContent()
    content.contentURL = url

    /// imported from FacebookShare SDK
    ShareDialog(viewController: presentingVC, content: content, delegate: nil).show()
  }

  // MARK: - Facebook Stories

  func shareToFacebookStories() {
    guard let imageData = self.renderedPreviewCard()?.pngData() else { return }

    guard let facebookAppID = Bundle.main.object(forInfoDictionaryKey: FacebookConstants.appIDKey) as? String
    else {
      assertionFailure("FacebookAppID is missing from Info.plist")
      return
    }

    UIPasteboard.general.setItems(
      [[
        FacebookConstants.stickerBackgroundImageKey: imageData,
        FacebookConstants.stickerAppIDKey: facebookAppID
      ]],
      options: [.expirationDate: Date().addingTimeInterval(60 * 5)]
    )

    self.dismiss()

    guard let url = URL(string: FacebookConstants.storiesURLScheme) else { return }

    UIApplication.shared.open(url)
  }

  // MARK: - Messages

  func shareToMessages() {
    guard let url = VideoFeedShareDestination.projectURL(for: self.item, refTag: .videoFeedShareMessages),
          let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let smsURL = URL(string: "sms:?body=\(encoded)") else {
      return
    }

    self.dismiss()

    UIApplication.shared.open(smsURL)
  }

  // MARK: - WhatsApp

  func shareToWhatsApp() {
    guard let url = VideoFeedShareDestination.projectURL(for: self.item, refTag: .videoFeedShareWhatsApp),
          let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let whatsAppURL = URL(string: "whatsapp://send?text=\(encoded)") else { return }

    UIApplication.shared.open(whatsAppURL)
  }

  // MARK: - Email

  func shareToEmail() {
    guard let url = VideoFeedShareDestination.projectURL(for: self.item, refTag: .videoFeedShareEmail),
          let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let mailURL = URL(string: "mailto:?body=\(encoded)") else { return }

    UIApplication.shared.open(mailURL)
  }

  // MARK: - X

  func shareToX() {
    guard let url = VideoFeedShareDestination.projectURL(for: self.item, refTag: .videoFeedShareX),
          let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let xURL = URL(string: "https://x.com/intent/tweet?text=\(encoded)") else { return }
    UIApplication.shared.open(xURL)
  }
}

// MARK: - ShareDestinationButton

struct ShareDestinationButton: View {
  private enum Constants {
    static let iconSize: CGFloat = 28
    static let iconCircleSize: CGFloat = 56
    static let iconLabelSpacing: CGFloat = 6
    static let labelHeight: CGFloat = 28
  }

  let destination: VideoFeedShareDestination
  let action: () -> Void

  var body: some View {
    Button(action: self.action) {
      VStack(spacing: Constants.iconLabelSpacing) {
        ZStack {
          Circle()
            .fill(Color.white)
            .frame(width: Constants.iconCircleSize, height: Constants.iconCircleSize)

          self.icon
        }

        Text(self.destination.label)
          .font(Font(UIFont.ksr_caption2()))
          .foregroundColor(Color(Colors.Text.constantPrimary.uiColor()))
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .minimumScaleFactor(0.75)
          .frame(height: Constants.labelHeight, alignment: .top)
      }
    }
    .accessibilityLabel(self.destination.label)
    .buttonStyle(.plain)
  }

  @ViewBuilder
  private var icon: some View {
    if let image = Library.image(named: self.destination.iconAssetName) {
      Image(uiImage: image)
        .renderingMode(self.destination.usesDarkTint ? .template : .original)
        .resizable()
        .scaledToFit()
        .frame(width: self.destination.iconSize, height: self.destination.iconSize)
        .foregroundColor(self.destination.usesDarkTint ? Color(Colors.Icon.dark.uiColor()) : nil)
        .accessibilityHidden(true)
    } else {
      Image(systemName: self.destination.fallbackSystemIcon)
        .resizable()
        .scaledToFit()
        .frame(width: Constants.iconSize, height: Constants.iconSize)
        .foregroundColor(Color(Colors.Text.primary.uiColor()))
        .accessibilityHidden(true)
    }
  }
}

// MARK: - Fallback SF Symbols

extension VideoFeedShareDestination {
  var fallbackSystemIcon: String {
    switch self {
    case .copyLink: return "link"
    case .x: return "bird"
    case .instagramStories: return "camera.circle"
    case .facebookStories: return "f.circle"
    case .whatsApp: return "bubble.left.fill"
    case .facebookFeed: return "f.square"
    case .messages: return "message"
    case .email: return "envelope"
    case .more: return "ellipsis"
    }
  }
}

