import FacebookLogin
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// View model for the Facebook Connect prompt cell shown in Find Friends and Discovery.
public final class FindFriendsFacebookConnectCellViewModel: FindFriendsFacebookConnectCellViewModelType,
  FindFriendsFacebookConnectCellViewModelInputs, FindFriendsFacebookConnectCellViewModelOutputs {
  /// Creates a new `FindFriendsFacebookConnectCellViewModel` and binds Facebook connection flows.
  public init() {
    self.notifyDelegateToDismissHeader = self.closeButtonTappedProperty.signal

    let isLoading: MutableProperty<Bool> = MutableProperty(false)

    self.isLoading = isLoading.signal

    self.attemptFacebookLogin = self.facebookConnectButtonTappedProperty.signal

    let tokenString: Signal<String, Never> = self.facebookLoginSuccessProperty.signal.skipNil()
      .map { $0.token?.tokenString ?? "" }

    let facebookConnect = tokenString
      .switchMap { token in
        AppEnvironment.current.apiService.facebookConnect(facebookAccessToken: token)
          .on(
            starting: {
              isLoading.value = true
            },
            terminated: {
              isLoading.value = false
            }
          )
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.updateUserInEnvironment = facebookConnect.values()

    self.postUserUpdatedNotification = self.userUpdatedProperty.signal
      .mapConst(Notification(name: .ksr_userUpdated))

    self.notifyDelegateUserFacebookConnected = self.userUpdatedProperty.signal

    let genericFacebookErrorAlert = facebookConnect.errors()
      .filter { env in
        env.ksrCode != .FacebookInvalidAccessToken &&
          env.ksrCode != .FacebookConnectAccountTaken &&
          env.ksrCode != .FacebookConnectEmailTaken
      }
      .map { AlertError.genericFacebookError(envelope: $0) }

    let facebookTokenFailAlert = facebookConnect.errors()
      .filter { $0.ksrCode == .FacebookInvalidAccessToken }
      .ignoreValues()
      .mapConst(AlertError.facebookTokenFail)

    let facebookConnectAccountTakenAlert = facebookConnect.errors()
      .filter { $0.ksrCode == .FacebookConnectAccountTaken }
      .map { AlertError.facebookConnectAccountTaken(envelope: $0) }

    let facebookConnectEmailTakenAlert = facebookConnect.errors()
      .filter { $0.ksrCode == .FacebookConnectEmailTaken }
      .map { AlertError.facebookConnectEmailTaken(envelope: $0) }

    let facebookLoginAttemptFailAlert = self.facebookLoginFailProperty.signal
      .map { $0 as NSError? }
      .skipNil()
      .map(AlertError.facebookLoginAttemptFail)

    self.showErrorAlert = Signal.merge([
      genericFacebookErrorAlert,
      facebookTokenFailAlert,
      facebookConnectAccountTakenAlert,
      facebookConnectEmailTakenAlert,
      facebookLoginAttemptFailAlert
    ])

    let source = self.configureWithProperty.signal.skipNil().map { $0 }
    let connectionType = self.configureWithProperty.signal.skipNil().map { _ in
      FindFriendsFacebookConnectCellViewModel.connectionType(user: AppEnvironment.current.currentUser)
    }

    self.hideCloseButton = source.map { $0 == FriendsSource.findFriends }

    self.facebookConnectCellTitle = connectionType.signal
      .skipNil()
      .map { $0.titleText }
    self.facebookConnectCellSubtitle = connectionType.signal
      .skipNil()
      .map { $0.subtitleText }
    self.facebookConnectButtonTitle = connectionType.signal
      .skipNil()
      .map { $0.buttonText }
  }

  /// The inputs interface for this view model.
  public var inputs: FindFriendsFacebookConnectCellViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: FindFriendsFacebookConnectCellViewModelOutputs { return self }

  fileprivate let closeButtonTappedProperty = MutableProperty(())
  /// Signals that the close button on the header cell was tapped.
  public func closeButtonTapped() {
    self.closeButtonTappedProperty.value = ()
  }

  fileprivate let configureWithProperty = MutableProperty<FriendsSource?>(nil)
  /// Configures the cell with the screen source presenting it.
  public func configureWith(source: FriendsSource) {
    self.configureWithProperty.value = source
  }

  fileprivate let facebookConnectButtonTappedProperty = MutableProperty(())
  /// Starts the Facebook login flow when the connect button is tapped.
  public func facebookConnectButtonTapped() {
    self.facebookConnectButtonTappedProperty.value = ()
  }

  fileprivate let facebookLoginFailProperty = MutableProperty<Error?>(nil)
  /// Handles a failed Facebook login attempt.
  public func facebookLoginFail(error: Error?) {
    self.facebookLoginFailProperty.value = error
  }

  fileprivate let facebookLoginSuccessProperty = MutableProperty<LoginManagerLoginResult?>(nil)
  /// Handles a successful Facebook login result containing an access token.
  public func facebookLoginSuccess(result: LoginManagerLoginResult) {
    self.facebookLoginSuccessProperty.value = result
  }

  fileprivate let userUpdatedProperty = MutableProperty(())
  /// Notifies the view model that the current user has been updated in `AppEnvironment`.
  public func userUpdated() {
    self.userUpdatedProperty.value = ()
  }

  /// Emits when Facebook login should be initiated.
  public let attemptFacebookLogin: Signal<(), Never>
  /// Emits the localized title for the Facebook Connect CTA button.
  public let facebookConnectButtonTitle: Signal<String, Never>
  /// Emits the localized title text for the cell.
  public let facebookConnectCellTitle: Signal<String, Never>
  /// Emits the localized subtitle description for the cell.
  public let facebookConnectCellSubtitle: Signal<String, Never>
  /// Emits whether the dismiss button should be hidden.
  public let hideCloseButton: Signal<Bool, Never>
  /// Emits whether the Facebook connect network request is in flight.
  public let isLoading: Signal<Bool, Never>
  /// Emits when the delegate should dismiss this header view.
  public let notifyDelegateToDismissHeader: Signal<(), Never>
  /// Emits when the delegate should be informed that Facebook connection succeeded.
  public let notifyDelegateUserFacebookConnected: Signal<(), Never>
  /// Emits a `.ksr_userUpdated` notification to broadcast after updating the user.
  public let postUserUpdatedNotification: Signal<Notification, Never>
  /// Emits the updated `User` to store in `AppEnvironment`.
  public let updateUserInEnvironment: Signal<User, Never>
  /// Emits an `AlertError` if connecting to Facebook fails.
  public let showErrorAlert: Signal<AlertError, Never>
}

extension FindFriendsFacebookConnectCellViewModel {
  /// Returns `true` when the Facebook Connect/Reconnect section should be shown for the given user.
  public static func showFacebookConnectionSection(for user: User?) -> Bool {
    guard let isFacebookConnected = user?.facebookConnected else {
      return true
    }

    let needsFreshFacebookToken = user?.needsFreshFacebookToken ?? false

    // Show section in "reconnect" state if facebook connected but requiring a new token
    return !isFacebookConnected || (
      isFacebookConnected
        && needsFreshFacebookToken
    )
  }

  private static func connectionType(user: User?) -> FacebookConnectionType? {
    guard let isFacebookConnected = user?.facebookConnected else {
      return .connect
    }

    let needsRefresh = user?.needsFreshFacebookToken ?? false

    if isFacebookConnected, needsRefresh {
      return .reconnect
    }

    return .connect
  }
}
