import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input protocol for friend-follow activity cells.
public protocol ActivityFriendFollowCellViewModelInputs {
  /// Call to configure activity with Activity.
  func configureWith(activity: Activity)

  /// Call when follow button is tapped.
  func followButtonTapped()
}

/// Output protocol for friend-follow activity cells.
public protocol ActivityFriendFollowCellViewModelOutputs {
  /// Emits a URL to the friend image.
  var friendImageURL: Signal<URL?, Never> { get }

  /// Emits whether to hide the follow button.
  var hideFollowButton: Signal<Bool, Never> { get }

  /// Emits text for title label.
  var title: Signal<NSAttributedString, Never> { get }
}

/// ViewModel handling follow actions and display formatting for friend-follow activity rows.
public final class ActivityFriendFollowCellViewModel: ActivityFriendFollowCellViewModelInputs,
  ActivityFriendFollowCellViewModelOutputs {
  /// Initializes ReactiveSwift bindings and optimistic friend-follow caching.
  public init() {
    let friend = self.activityProperty.signal.skipNil()
      .map(Activity.lens.user.view)
      .skipNil()
      .map(cached(friend:))

    self.friendImageURL = friend.map { URL.init(string: $0.avatar.small) }

    self.title = friend.map {
      let string = Strings.activity_user_name_is_now_following_you(user_name: "<b>\($0.name)</b>")
      return string.simpleHtmlAttributedString(
        base: [
          NSAttributedString.Key.font: UIFont.ksr_subhead(size: 14.0),
          NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_700.uiColor()
        ],
        bold: [
          NSAttributedString.Key.font: UIFont.ksr_headline(size: 14.0),
          NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_700.uiColor()
        ]
      ) ?? NSAttributedString(string: "")
    }

    let followFriendEvent = friend.takeWhen(self.followButtonTappedProperty.signal)
      .switchMap { user in
        AppEnvironment.current.apiService.followFriend(userId: user.id)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let followFriendSuccess = followFriendEvent.values()
      .on(value: { cache(friend: $0, isFriend: true) })

    self.hideFollowButton = Signal.merge(friend, followFriendSuccess)
      .map { $0.isFriend ?? false }
      .skipRepeats()
  }

  fileprivate let activityProperty = MutableProperty<Activity?>(nil)
  /// Binds an `Activity` item to the cell.
  public func configureWith(activity: Activity) {
    self.activityProperty.value = activity
  }

  fileprivate let followButtonTappedProperty = MutableProperty(())
  /// Triggers the follow-friend API request.
  public func followButtonTapped() {
    self.followButtonTappedProperty.value = ()
  }

  /// Friend avatar URL signal.
  public let friendImageURL: Signal<URL?, Never>
  /// Follow button visibility signal (`true` when already following).
  public let hideFollowButton: Signal<Bool, Never>
  /// Attributed title string displaying the follower's name.
  public let title: Signal<NSAttributedString, Never>

  /// Self-conformance to `ActivityFriendFollowCellViewModelInputs`.
  public var inputs: ActivityFriendFollowCellViewModelInputs { return self }
  /// Self-conformance to `ActivityFriendFollowCellViewModelOutputs`.
  public var outputs: ActivityFriendFollowCellViewModelOutputs { return self }
}

private func cached(friend: User) -> User {
  if let friendCache = AppEnvironment.current.cache[KSCache.ksr_activityFriendsFollowing] as? [Int: Bool] {
    let isFriend = friendCache[friend.id] ?? friend.isFriend
    return friend |> \.isFriend .~ isFriend
  } else {
    return friend
  }
}

private func cache(friend: User, isFriend: Bool) {
  AppEnvironment.current.cache[KSCache.ksr_activityFriendsFollowing] =
    AppEnvironment.current.cache[KSCache.ksr_activityFriendsFollowing] ?? [Int: Bool]()

  var cache = AppEnvironment.current.cache[KSCache.ksr_activityFriendsFollowing] as? [Int: Bool]
  cache?[friend.id] = isFriend

  AppEnvironment.current.cache[KSCache.ksr_activityFriendsFollowing] = cache
}
