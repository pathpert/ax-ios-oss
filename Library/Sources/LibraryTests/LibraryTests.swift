import Library
import XCTest

// This file is a stub so that a LibraryTests target can exist. Library tests
// tend to be in a test bundle in the main app solely because some of them rely
// on APIs that crash without a running iOS simulator. You can add tests to
// this LibraryTests package as you like and they will run in CI.
/// Unit tests covering `LibraryTests` behavior and contracts.
class LibraryTests: XCTestCase {
  func testExample() {
    XCTAssertEqual("42", "\(42)")
  }

  func testPerFeatureStringsNamespacesMatchLegacyStrings() {
    XCTAssertEqual(PledgeStrings.Add_ons(), Strings.Add_ons())
    XCTAssertEqual(PledgeStrings.Backing_details(), Strings.Backing_details())
    XCTAssertEqual(
      PledgeStrings.About_reward_amount(reward_amount: "$10"),
      Strings.About_reward_amount(reward_amount: "$10")
    )
    XCTAssertEqual(DiscoveryStrings.All_Art_Projects(), Strings.All_Art_Projects())
  }
}
