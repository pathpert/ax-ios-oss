import FBSDKShareKit
import KDS
import Kingfisher
import Library
import SwiftUI

/// Immutable value type representing `VideoFeedShareSheetView`.
struct VideoFeedShareSheetView: View {
  private enum Constants {
    static let horizontalPadding: CGFloat = 38
    static let gridColumns = 4
    static let gridSpacing: CGFloat = 24
    static let cardToGridSpacing: CGFloat = 47
    static let titleTopPadding: CGFloat = 20
    static let titleBottomPadding: CGFloat = 16
    static let gridBottomPadding: CGFloat = 32

    static let previewCornerRadius: CGFloat = 12
    static let previewPadding: CGFloat = 12
    static let previewItemSpacing: CGFloat = 32

    static let iconSize: CGFloat = 28
    static let iconCircleSize: CGFloat = 56
    static let iconLabelSpacing: CGFloat = 6

    static let linkCopiedAnimationName = "video-feed-copy-link-checkmark"
    static let linkCopiedAnimationSize: CGFloat = 32
    static let linkCopiedDismissDelay: TimeInterval = 2.5
  }

  enum FacebookConstants {
    static let appIDKey = "FacebookAppID"
    static let storiesURLScheme = "facebook-stories://share"
    static let stickerBackgroundImageKey = "com.facebook.sharedSticker.backgroundImage"
    static let stickerAppIDKey = "com.facebook.sharedSticker.appID"
  }

  @SwiftUI.Environment(\.dismiss) var dismiss

  let item: VideoFeedItem

  @State private var destinations: [VideoFeedShareDestination] = VideoFeedShareDestination.available()
  @State private var linkCopied = false

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        Text(Strings.dashboard_accessibility_label_share_project())
          .font(Font(UIFont.ksr_headline()))
          .foregroundColor(.black)
          .frame(maxWidth: .infinity)
          .padding(.top, Constants.titleTopPadding)
          .padding(.bottom, Constants.titleBottomPadding)

        self.previewCard
          .padding(.horizontal, Constants.horizontalPadding)

        if self.linkCopied {
          self.linkCopiedConfirmation
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, Constants.cardToGridSpacing)
            .padding(.bottom, Constants.gridBottomPadding)
        } else {
          self.appGrid
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, Constants.cardToGridSpacing)
            .padding(.bottom, Constants.gridBottomPadding)
        }
      }
      .frame(width: geometry.size.width, alignment: .top)
    }
    .background {
      ZStack {
        Color(UIColor(coreColor: .green_04))
        Image(ImageResource.shareBackgroundSwirl)
          .resizable()
          .scaledToFill()
          .clipped()
          .accessibilityHidden(true)
      }
      .ignoresSafeArea()
    }
  }

  private var previewCard: some View {
    VideoFeedSharePreviewCard(item: self.item) {
      KFImage(self.item.videoPreviewImageURL)
        .resizable()
        .scaledToFill()
        .accessibilityHidden(true)
    }
  }

  private var appGrid: some View {
    LazyVGrid(
      columns: Array(
        repeating: GridItem(.flexible(), spacing: Constants.gridSpacing),
        count: Constants.gridColumns
      ),
      spacing: Constants.gridSpacing
    ) {
      ForEach(self.destinations) { destination in
        ShareDestinationButton(destination: destination) { [destination] in
          self.destinationTapped(destination)
        }
      }
    }
  }

  private var linkCopiedConfirmation: some View {
    VStack(spacing: 12) {
      ZStack {
        Circle()
          .fill(Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)))
          .frame(width: Constants.iconCircleSize, height: Constants.iconCircleSize)

        VideoFeedCopyLinkConfirmationView(animationName: Constants.linkCopiedAnimationName)
          .frame(width: Constants.linkCopiedAnimationSize, height: Constants.linkCopiedAnimationSize)
      }

      Text(Strings.Link_copied_spread_the_word())
        .font(Font(UIFont.ksr_subhead()))
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
  }

  private func destinationTapped(_ destination: VideoFeedShareDestination) {
    AppEnvironment.current.ksrAnalytics.trackVideoFeedShareDestinationClicked(
      destination: destination.analyticsContext,
      videoId: self.item.id,
      projectId: self.item.projectId
    )

    switch destination {
    case .copyLink:
      self.copyLink()
    case .facebookFeed:
      self.shareToFacebookFeed()
    case .facebookStories:
      self.shareToFacebookStories()
    case .x:
      self.shareToX()
    case .whatsApp:
      self.shareToWhatsApp()
    case .messages:
      self.shareToMessages()
    case .email:
      self.shareToEmail()
    case .more:
      self.moreShareOptions()
    default:
      destination.perform(item: self.item)
    }
  }

  // MARK: - More Options

  private func moreShareOptions() {
    guard let url = VideoFeedShareDestination.projectURL(for: self.item, refTag: .videoFeedShareMore),
          let presentingVC = self.presentingViewController() else { return }

    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

    if let popover = activityVC.popoverPresentationController {
      popover.sourceView = presentingVC.view
      popover.sourceRect = CGRect(
        x: presentingVC.view.bounds.midX,
        y: presentingVC.view.bounds.midY,
        width: 0,
        height: 0
      )
      popover.permittedArrowDirections = []
    }

    presentingVC.present(activityVC, animated: true)
  }

  // MARK: - Copy Link

  private func copyLink() {
    UIPasteboard.general.string = VideoFeedShareDestination
      .projectURL(for: self.item, refTag: .videoFeedShareCopyLink)?.absoluteString
    withAnimation { self.linkCopied = true }
    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.linkCopiedDismissDelay) {
      self.dismiss()
    }
  }

  // MARK: - Image Rendering

  func renderedPreviewCard() -> UIImage? {
    guard let previewURL = self.item.videoPreviewImageURL,
          let thumbnailImage = KingfisherManager.shared.cache
          .retrieveImageInMemoryCache(forKey: previewURL.absoluteString) else {
      return nil
    }

    let screenWidth = UIScreen.main.bounds.width
    let storyHeight = screenWidth * 16 / 9

    let renderer = ImageRenderer(
      content: ZStack {
        Color(UIColor(coreColor: .green_04))

        VideoFeedSharePreviewCard(item: self.item) {
          Image(uiImage: thumbnailImage)
            .resizable()
            .scaledToFill()
            .accessibilityHidden(true)
        }
        .padding(.horizontal, Constants.horizontalPadding)
      }
      .frame(width: screenWidth, height: storyHeight)
    )

    renderer.scale = UIScreen.main.scale

    return renderer.uiImage
  }
}
