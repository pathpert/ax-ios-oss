import FacebookLogin
import KsApi
import ReactiveSwift

/// Inputs accepted by `FindFriendsFacebookConnectCellViewModel`.
public protocol FindFriendsFacebookConnectCellViewModelInputs {
  /// Call when close button tapped to dismiss this view if used as a header
  func closeButtonTapped()

  /// Call to set where Friends View Controller was loaded from
  func configureWith(source: FriendsSource)

  /// Call when Facebook Connect button is tapped
  func facebookConnectButtonTapped()

  /// Call when Facebook login completed with error
  func facebookLoginFail(error: Error?)

  /// Call when Facebook login completed successfully with a result
  func facebookLoginSuccess(result: LoginManagerLoginResult)

  /// Call when the current user has been updated in the environment
  func userUpdated()
}

/// Outputs exposed by `FindFriendsFacebookConnectCellViewModel`.
public protocol FindFriendsFacebookConnectCellViewModelOutputs {
  /// Emits when Facebook login should start
  var attemptFacebookLogin: Signal<(), Never> { get }

  /// Emits whether close button should hide
  var hideCloseButton: Signal<Bool, Never> { get }

  /// Emits whether a request is loading or not
  var isLoading: Signal<Bool, Never> { get }

  /// Emits when should notify delegate to dismiss this view if used as a header
  var notifyDelegateToDismissHeader: Signal<(), Never> { get }

  /// Emits when should notify delegate that user successfully connected to Facebook
  var notifyDelegateUserFacebookConnected: Signal<(), Never> { get }

  /// Emits when a user updated notification should be posted
  var postUserUpdatedNotification: Signal<Notification, Never> { get }

  /// Emits when should error alert with AlertError
  var showErrorAlert: Signal<AlertError, Never> { get }

  /// Emits a User that can be used to replace the current user in the environment
  var updateUserInEnvironment: Signal<User, Never> { get }

  /// Emits the cell's title
  var facebookConnectCellTitle: Signal<String, Never> { get }

  /// Emits the cell's description
  var facebookConnectCellSubtitle: Signal<String, Never> { get }

  /// Emits the button's title
  var facebookConnectButtonTitle: Signal<String, Never> { get }
}

/// Combined inputs and outputs interface for `FindFriendsFacebookConnectCellViewModel`.
public protocol FindFriendsFacebookConnectCellViewModelType {
  /// The view model's inputs.
  var inputs: FindFriendsFacebookConnectCellViewModelInputs { get }
  /// The view model's outputs.
  var outputs: FindFriendsFacebookConnectCellViewModelOutputs { get }
}

