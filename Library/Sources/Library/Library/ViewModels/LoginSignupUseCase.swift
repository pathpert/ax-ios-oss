import Foundation
import ReactiveSwift

/// Interface exposing UI inputs, UI outputs, and authentication state for `LoginSignupUseCase`.
public protocol LoginSignupUseCaseType {
  /// Input receiver for login CTA taps and session updates.
  var uiInputs: LoginSignupUseCaseUIInputs { get }
  /// Output signals routing presentation of login/signup screens.
  var uiOutputs: LoginSignupUseCaseUIOutputs { get }
  /// Output signals exposing session change events and authentication status.
  var dataOutputs: LoginSignupUseCaseDataOutputs { get }
}

/// UI inputs accepted by `LoginSignupUseCase`.
public protocol LoginSignupUseCaseUIInputs {
  /// Signals that the user tapped the login or signup action button.
  func goToLoginSignupTapped()
  /// Signals that the global user authentication session changed.
  func userSessionDidChange()
}

/// UI outputs emitted by `LoginSignupUseCase`.
public protocol LoginSignupUseCaseUIOutputs {
  /// Emits the configured `LoginIntent` when presenting the login flow.
  var goToLoginSignup: Signal<LoginIntent, Never> { get }
}

/// Data outputs emitted by `LoginSignupUseCase`.
public protocol LoginSignupUseCaseDataOutputs {
  /// Emits whenever the active user session changes.
  var userSessionChanged: Signal<Void, Never> { get }
  /// Emits whether a user is currently authenticated.
  var isLoggedIn: Signal<Bool, Never> { get }
}

/// Use case coordinating login/signup prompts and session changes across live and late pledge flows.
/// - Negative Constraint: Requires an `initialData` emission to publish the initial `isLoggedIn` state.
public final class LoginSignupUseCase: LoginSignupUseCaseType, LoginSignupUseCaseUIInputs,
  LoginSignupUseCaseUIOutputs, LoginSignupUseCaseDataOutputs {
  init(withLoginIntent loginIntent: LoginIntent, initialData: Signal<Void, Never>) {
    self.goToLoginSignup = self.goToLoginSignupSignal
      .mapConst(loginIntent)

    self.isLoggedIn = Signal.merge(initialData, self.userSessionDidChangeSignal)
      .map { _ in AppEnvironment.current.currentUser != nil }
  }

  // MARK: - UI Inputs

  private let (goToLoginSignupSignal, goToLoginSignupObserver) = Signal<Void, Never>.pipe()
  /// Requests presentation of the login/signup flow.
  public func goToLoginSignupTapped() {
    self.goToLoginSignupObserver.send(value: ())
  }

  private let (userSessionDidChangeSignal, userSessionDidChangeObserver) = Signal<Void, Never>.pipe()
  /// Notifies subscribers that the active user session started or ended.
  public func userSessionDidChange() {
    self.userSessionDidChangeObserver.send(value: ())
  }

  // MARK: - UI Outputs

  /// Emits the `LoginIntent` when opening login/signup.
  public let goToLoginSignup: Signal<LoginIntent, Never>

  // MARK: - Data Outputs

  /// Emits when `userSessionDidChange()` is invoked.
  public var userSessionChanged: Signal<Void, Never> {
    return self.userSessionDidChangeSignal
  }

  /// Emits whether a logged-in user is present in `AppEnvironment.current`.
  public let isLoggedIn: Signal<Bool, Never>

  // MARK: - Type

  /// Returns `self` as `LoginSignupUseCaseUIInputs`.
  public var uiInputs: any LoginSignupUseCaseUIInputs { return self }
  /// Returns `self` as `LoginSignupUseCaseUIOutputs`.
  public var uiOutputs: any LoginSignupUseCaseUIOutputs { return self }
  /// Returns `self` as `LoginSignupUseCaseDataOutputs`.
  public var dataOutputs: any LoginSignupUseCaseDataOutputs { return self }
}
