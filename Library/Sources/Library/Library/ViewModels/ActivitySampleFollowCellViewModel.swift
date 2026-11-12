import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs for `ActivitySampleFollowCellViewModel`.
public protocol ActivitySampleFollowCellViewModelInputs {
  /// Call to configure cell with activity value.
  func configureWith(activity: Activity)

  /// Call when the see all activity button is tapped.
  func seeAllActivityTapped()
}

/// Outputs for `ActivitySampleFollowCellViewModel`.
public protocol ActivitySampleFollowCellViewModelOutputs {
  /// Emits the friend follow to be displayed.
  var friendFollowText: Signal<String, Never> { get }

  /// Emits the friend image url to be displayed.
  var friendImageURL: Signal<URL?, Never> { get }

  /// Emits when should go to activities screen.
  var goToActivity: Signal<Void, Never> { get }
}

/// Type interface for `ActivitySampleFollowCellViewModel`.
public protocol ActivitySampleFollowCellViewModelType {
  /// View model inputs.
  var inputs: ActivitySampleFollowCellViewModelInputs { get }
  /// View model outputs.
  var outputs: ActivitySampleFollowCellViewModelOutputs { get }
}

/// View model formatting an activity sample follow cell and handling see-all-activity navigation.
public final class ActivitySampleFollowCellViewModel: ActivitySampleFollowCellViewModelInputs,
  ActivitySampleFollowCellViewModelOutputs, ActivitySampleFollowCellViewModelType {
  /// Initializes the cell view model and binds friend follow text and avatar URL signals.
  public init() {
    let activity = self.activityProperty.signal.skipNil()

    self.friendFollowText = activity
      .map { Strings.activity_user_name_is_now_following_you(user_name: $0.user?.name ?? "") }

    self.friendImageURL = activity
      .map { ($0.user?.avatar.medium).flatMap(URL.init) }

    self.goToActivity = self.seeAllActivityTappedProperty.signal
  }

  fileprivate let activityProperty = MutableProperty<Activity?>(nil)
  /// Configures the cell with the follower `Activity` item.
  public func configureWith(activity: Activity) {
    self.activityProperty.value = activity
  }

  fileprivate let seeAllActivityTappedProperty = MutableProperty(())
  /// Called when the user taps the see-all activity button.
  public func seeAllActivityTapped() {
    self.seeAllActivityTappedProperty.value = ()
  }

  /// Emits the localized follower notification string.
  public let friendFollowText: Signal<String, Never>
  /// Emits the follower's avatar image URL.
  public let friendImageURL: Signal<URL?, Never>
  /// Emits when the user taps to open the full activity feed.
  public let goToActivity: Signal<Void, Never>

  /// View model inputs.
  public var inputs: ActivitySampleFollowCellViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ActivitySampleFollowCellViewModelOutputs { return self }
}
