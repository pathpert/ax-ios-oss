@testable import Kickstarter_Framework
import Library
@testable import LibraryTestHelpers
import SnapshotTesting
import SwiftUI
import XCTest

/// Unit tests covering `MessageBannerViewTests` behavior and contracts.
internal final class MessageBannerViewTests: TestCase {
  func testBannerSuccess() {
    @State var viewModel: MessageBannerViewViewModel? = MessageBannerViewViewModel(
      MessageBannerConfiguration(
        type: .success,
        message: "Everything completed successfully and now's the time to celebrate! Goooooo team!"
      )
    )
    let messageBannerView = MessageBannerView(viewModel: $viewModel)
      .defaultPortraitFrame()

    assertSnapshot(matching: messageBannerView, as: .image)
  }

  func testBannerError() {
    @State var viewModel: MessageBannerViewViewModel? = MessageBannerViewViewModel(
      MessageBannerConfiguration(
        type: .error,
        message: "Something went wrong"
      )
    )
    let messageBannerView = MessageBannerView(viewModel: $viewModel)
      .defaultPortraitFrame()

    assertSnapshot(matching: messageBannerView, as: .image)
  }

  func testBannerInfo_shortString() {
    @State var viewModel: MessageBannerViewViewModel? = MessageBannerViewViewModel(
      MessageBannerConfiguration(
        type: .info,
        message: "Something happened"
      )
    )
    let messageBannerView = MessageBannerView(viewModel: $viewModel)
      .defaultPortraitFrame()

    assertSnapshot(matching: messageBannerView, as: .image)
  }

  func testBannerInfo_longString() {
    @State var viewModel: MessageBannerViewViewModel? = MessageBannerViewViewModel(
      MessageBannerConfiguration(
        type: .info,
        message: "Something unexpected happened but everything is probably fine."
      )
    )
    let messageBannerView = MessageBannerView(viewModel: $viewModel)
      .defaultPortraitFrame()

    assertSnapshot(matching: messageBannerView, as: .image)
  }
}
