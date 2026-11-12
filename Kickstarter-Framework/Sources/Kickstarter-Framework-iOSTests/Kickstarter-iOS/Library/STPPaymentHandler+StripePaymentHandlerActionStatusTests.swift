import Library
@testable import LibraryTestHelpers
import Stripe
import XCTest

/// Unit tests covering `STPPaymentHandler_StripePaymentHandlerActionStatusTests` behavior and contracts.
final class STPPaymentHandler_StripePaymentHandlerActionStatusTests: TestCase {
  func testTypeMapping() {
    XCTAssertEqual(
      STPPaymentHandlerActionStatus.succeeded.status,
      StripePaymentHandlerActionStatus.succeeded
    )

    XCTAssertEqual(
      STPPaymentHandlerActionStatus.canceled.status,
      StripePaymentHandlerActionStatus.canceled
    )

    XCTAssertEqual(
      STPPaymentHandlerActionStatus.failed.status,
      StripePaymentHandlerActionStatus.failed
    )
  }
}
