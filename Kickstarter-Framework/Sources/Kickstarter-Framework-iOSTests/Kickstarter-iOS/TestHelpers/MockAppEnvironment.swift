import Foundation
@testable import Library
import UIKit

/// Unit tests covering `MockAppEnvironment` behavior and contracts.
struct MockAppEnvironment: AppEnvironmentType {
  static var logoutWasCalled = false

  static func logout() {
    self.logoutWasCalled = true
  }
}

struct MockPushNotificationDialog: PushNotificationDialogType {
  static var resetAllContextsWasCalled = false

  static func resetAllContexts() {
    self.resetAllContextsWasCalled = true
  }
}

class MockViewController: UIViewController {
  var dismissAnimatedWasCalled = false

  override func dismiss(animated _: Bool, completion _: (() -> Void)? = nil) {
    self.dismissAnimatedWasCalled = true
  }
}
