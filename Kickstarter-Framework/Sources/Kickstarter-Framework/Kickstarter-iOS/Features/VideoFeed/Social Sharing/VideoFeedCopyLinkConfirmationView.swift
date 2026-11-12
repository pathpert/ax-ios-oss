import Lottie
import SwiftUI

/// SwiftUI wrapper around a play-once Lottie animation confirming a copied video feed link.
public struct VideoFeedCopyLinkConfirmationView: UIViewRepresentable {
  let animationName: String

  /// Creates and starts the configured Lottie animation view.
  public func makeUIView(context _: Context) -> LottieAnimationView {
    let animation = LottieAnimation.named(self.animationName, bundle: .library)

    let view = LottieAnimationView(animation: animation)
    view.contentMode = .scaleAspectFit
    view.loopMode = .playOnce
    view.play()

    return view
  }

  /// Updates the Lottie animation view on SwiftUI state changes.
  public func updateUIView(_: LottieAnimationView, context _: Context) {}
}
