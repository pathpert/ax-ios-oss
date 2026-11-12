import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// Inputs for `ActivitySampleBackingCellViewModel`.
public protocol ActivitySampleBackingCellViewModelInputs {
  /// Call to configure cell with activity value.
  func configureWith(activity: Activity)

  /// Call when the see all activity button is tapped.
  func seeAllActivityTapped()
}

/// Outputs for `ActivitySampleBackingCellViewModel`.
public protocol ActivitySampleBackingCellViewModelOutputs {
  /// Emits the backer image url to be displayed.
  var backerImageURL: Signal<URL?, Never> { get }

  /// Emits the backing message to be displayed.
  var backingTitleText: Signal<NSAttributedString, Never> { get }

  /// Emits when should go to activities screen.
  var goToActivity: Signal<Void, Never> { get }
}

/// Type interface for `ActivitySampleBackingCellViewModel`.
public protocol ActivitySampleBackingCellViewModelType {
  /// View model inputs.
  var inputs: ActivitySampleBackingCellViewModelInputs { get }
  /// View model outputs.
  var outputs: ActivitySampleBackingCellViewModelOutputs { get }
}

/// View model formatting an activity sample backing cell and handling see-all-activity navigation.
public final class ActivitySampleBackingCellViewModel: ActivitySampleBackingCellViewModelInputs,
  ActivitySampleBackingCellViewModelOutputs, ActivitySampleBackingCellViewModelType {
  /// Initializes the cell view model and binds formatted title and avatar outputs.
  public init() {
    let activity = self.activityProperty.signal.skipNil()

    self.backingTitleText = activity.map {
      let string = Strings.activity_friend_backed_project_name_by_creator_name(
        friend_name: $0.user?.name ?? "",
        project_name: $0.project?.name ?? "",
        creator_name: $0.project?.creator.name ?? ""
      )

      return string.simpleHtmlAttributedString(font: UIFont.ksr_subhead()) ?? NSAttributedString(string: "")
    }

    self.backerImageURL = activity
      .map { ($0.user?.avatar.medium).flatMap(URL.init) }

    self.goToActivity = self.seeAllActivityTappedProperty.signal
  }

  fileprivate let activityProperty = MutableProperty<Activity?>(nil)
  /// Configures the cell with the friend-backing `Activity` item.
  public func configureWith(activity: Activity) {
    self.activityProperty.value = activity
  }

  fileprivate let seeAllActivityTappedProperty = MutableProperty(())
  /// Called when the user taps the see-all activity button.
  public func seeAllActivityTapped() {
    self.seeAllActivityTappedProperty.value = ()
  }

  /// Emits the formatted HTML-attributed backing description.
  public let backingTitleText: Signal<NSAttributedString, Never>
  /// Emits the backing friend's avatar image URL.
  public let backerImageURL: Signal<URL?, Never>
  /// Emits when the user taps to open the full activity feed.
  public let goToActivity: Signal<Void, Never>

  /// View model inputs.
  public var inputs: ActivitySampleBackingCellViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ActivitySampleBackingCellViewModelOutputs { return self }
}
