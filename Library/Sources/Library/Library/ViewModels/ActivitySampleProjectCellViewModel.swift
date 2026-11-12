import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input events handled by `ActivitySampleProjectCellViewModel`.
public protocol ActivitySampleProjectCellViewModelInputs {
  /// Call to configure cell with activity value.
  func configureWith(activity: Activity)

  /// Call when the see all activity button is tapped.
  func seeAllActivityTapped()
}

/// Output signals exposed by `ActivitySampleProjectCellViewModel`.
public protocol ActivitySampleProjectCellViewModelOutputs {
  /// Emits the cell accessibility hint for VoiceOver.
  var cellAccessibilityHint: Signal<String, Never> { get }

  /// Emits when should go to activities screen.
  var goToActivity: Signal<Void, Never> { get }

  /// Emits the project image url to be displayed.
  var projectImageURL: Signal<URL?, Never> { get }

  /// Emits the project subtitle message to be displayed.
  var projectSubtitleText: Signal<String, Never> { get }

  /// Emits the project name title to be displayed.
  var projectTitleText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `ActivitySampleProjectCellViewModel`.
public protocol ActivitySampleProjectCellViewModelType {
  /// Input receiver for activity sample cell configuration and taps.
  var inputs: ActivitySampleProjectCellViewModelInputs { get }
  /// Output signals formatting the sampled project card and navigation triggers.
  var outputs: ActivitySampleProjectCellViewModelOutputs { get }
}

/// View model formatting compact project activity summary cells in Discovery.
public final class ActivitySampleProjectCellViewModel: ActivitySampleProjectCellViewModelInputs,
  ActivitySampleProjectCellViewModelOutputs, ActivitySampleProjectCellViewModelType {
  /// Initializes the activity sample project cell view model.
  public init() {
    let activity = self.activityProperty.signal.skipNil()

    self.cellAccessibilityHint = activity
      .map { $0.category == .update ? Strings.Opens_update() : Strings.Opens_project() }

    self.goToActivity = self.seeAllActivityTappedProperty.signal

    self.projectImageURL = activity
      .map { ($0.project?.photo.med).flatMap(URL.init) }

    self.projectTitleText = activity
      .map { $0.project?.name }.skipNil()

    self.projectSubtitleText = activity
      .map { activity in
        switch activity.category {
        case .cancellation:
          return Strings.activity_funding_canceled()
        case .failure:
          return Strings.activity_project_was_not_successfully_funded()
        case .launch:
          return Strings.activity_user_name_launched_project(user_name: activity.user?.name ?? "")
        case .success:
          return Strings.activity_successfully_funded()
        case .update:
          return Strings.activity_posted_update_number_title(
            update_number: Format.wholeNumber(activity.update?.sequence ?? 0),
            update_title: activity.update?.title ?? ""
          )
        default:
          return ""
        }
      }
  }

  fileprivate let activityProperty = MutableProperty<Activity?>(nil)
  /// Configures the cell with the featured `Activity`.
  public func configureWith(activity: Activity) {
    self.activityProperty.value = activity
  }

  fileprivate let seeAllActivityTappedProperty = MutableProperty(())
  /// Signals that the user tapped "See all activity".
  public func seeAllActivityTapped() {
    self.seeAllActivityTappedProperty.value = ()
  }

  /// Emits the VoiceOver accessibility hint describing navigation behavior.
  public let cellAccessibilityHint: Signal<String, Never>
  /// Emits when navigating to the full activity feed.
  public let goToActivity: Signal<Void, Never>
  /// Emits the project's medium thumbnail URL.
  public let projectImageURL: Signal<URL?, Never>
  /// Emits localized status or update subtitle copy.
  public let projectSubtitleText: Signal<String, Never>
  /// Emits the featured project's title.
  public let projectTitleText: Signal<String, Never>

  /// Returns `self` as `ActivitySampleProjectCellViewModelInputs`.
  public var inputs: ActivitySampleProjectCellViewModelInputs { return self }
  /// Returns `self` as `ActivitySampleProjectCellViewModelOutputs`.
  public var outputs: ActivitySampleProjectCellViewModelOutputs { return self }
}
