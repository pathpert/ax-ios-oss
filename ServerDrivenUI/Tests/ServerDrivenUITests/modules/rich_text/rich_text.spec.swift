import KsApi
import ServerDrivenUI
import XCTest

final class RichTextModuleSpec: XCTestCase {
  // MARK: - 1. Happy Path: Splits Inline Photo Nested in Text Into Standalone Sibling Blocks

  func testNormalizeRichText_SplitsNestedInlinePhotoAndPropagatesLink() {
    let controller = RichTextController(service: RichTextModuleService(rateLimitMax: 10))

    let request = NormalizeRichTextRequestSchema(nodes: [
      RichTextNodeInputSchema(
        nodeType: "text",
        text: "Intro paragraph ",
        linkURL: "https://www.kickstarter.com/projects/creator/story",
        styles: ["STRONG"],
        children: [
          RichTextNodeInputSchema(
            nodeType: "photo",
            photoURL: "https://ksr-ugc.imgix.net/photo1.jpg",
            photoAltText: "Prototype photo"
          ),
          RichTextNodeInputSchema(
            nodeType: "text",
            text: "Closing caption"
          )
        ]
      )
    ])

    let response = try? controller.handleNormalizeRichText(request: request).get()
    XCTAssertEqual(response?.statusCode, 200)
    XCTAssertEqual(response?.body.inputNodeCount, 1)
    XCTAssertEqual(response?.body.normalizedBlockCount, 3)
    XCTAssertEqual(response?.body.blocks[0].blockKind, "text")
    XCTAssertEqual(response?.body.blocks[1].blockKind, "photo")
    XCTAssertEqual(response?.body.blocks[1].photoURL, "https://ksr-ugc.imgix.net/photo1.jpg")
    XCTAssertEqual(response?.body.blocks[1].linkURL, "https://www.kickstarter.com/projects/creator/story")
    XCTAssertEqual(response?.body.blocks[2].blockKind, "text")
  }

  // MARK: - 2. Boundary Rejections: Unknown Styles (Prevents Legacy assertionFailure) & Non-HTTPS Photos

  func testNormalizeRichText_RejectsUnknownStyleAndNonHttpsPhoto() {
    let controller = RichTextController()

    let badRequest = NormalizeRichTextRequestSchema(nodes: [
      RichTextNodeInputSchema(
        nodeType: "text",
        text: "Bad style",
        styles: ["BLINK_TAG"]
      ),
      RichTextNodeInputSchema(
        nodeType: "photo",
        photoURL: "http://insecure.example.com/pic.jpg"
      )
    ])

    let response = controller.handleNormalizeRichText(request: badRequest)
    guard case let .failure(problem) = response else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.count, 2)
  }
}
