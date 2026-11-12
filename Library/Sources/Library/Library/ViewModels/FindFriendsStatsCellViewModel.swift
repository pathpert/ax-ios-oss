import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input events handled by `FindFriendsStatsCellViewModel`.
public protocol FindFriendsStatsCellViewModelInputs {
  /// Call to set with stats and the source from whence it comes
  func configureWith(stats: FriendStatsEnvelope, source: FriendsSource)

  /// Call when follow all button is tapped
  func followAllButtonTapped()
}

/// Output signals exposed by `FindFriendsStatsCellViewModel`.
public protocol FindFriendsStatsCellViewModelOutputs {
  /// Emits total friends' backed projects text
  var backedProjectsCountText: Signal<String, Never> { get }

  /// Emits text for Follow All button
  var followAllText: Signal<String, Never> { get }

  /// Emits friends count text
  var friendsCountText: Signal<String, Never> { get }

  /// Emits whether Follow All button should show
  var hideFollowAllButton: Signal<Bool, Never> { get }

  /// Emits when should show Follow All confirmation alert with friends count
  var notifyDelegateShowFollowAllFriendsAlert: Signal<Int, Never> { get }
}

/// Interface combining inputs and outputs for `FindFriendsStatsCellViewModel`.
public protocol FindFriendsStatsCellViewModelType {
  /// Input receiver for friend statistics configuration and Follow All taps.
  var inputs: FindFriendsStatsCellViewModelInputs { get }
  /// Output signals formatting friend counts and Follow All confirmation prompts.
  var outputs: FindFriendsStatsCellViewModelOutputs { get }
}

/// View model formatting social friend summary statistics and Follow All actions.
public final class FindFriendsStatsCellViewModel: FindFriendsStatsCellViewModelType,
  FindFriendsStatsCellViewModelInputs, FindFriendsStatsCellViewModelOutputs {
  /// Initializes the Find Friends stats cell view model.
  public init() {
    let friendProjectsCount: Signal<Int, Never> = self.configureWithStatsProperty.signal
      .map { $0?.stats.friendProjectsCount ?? 0 }

    let remoteFriendCount: Signal<Int, Never> = self.configureWithStatsProperty.signal
      .map { $0?.stats.remoteFriendsCount ?? 0 }

    self.backedProjectsCountText = friendProjectsCount.map { Format.wholeNumber($0) }

    self.followAllText = remoteFriendCount
      .map(Strings.social_following_stats_button_follow_all_friends(remote_friends_count:))

    self.friendsCountText = remoteFriendCount.map { Format.wholeNumber($0) }

    self.hideFollowAllButton = remoteFriendCount.map { $0 <= 2 }

    self.notifyDelegateShowFollowAllFriendsAlert = remoteFriendCount
      .map { $0 }
      .takeWhen(self.followAllButtonTappedProperty.signal)
  }

  /// Returns `self` as `FindFriendsStatsCellViewModelInputs`.
  public var inputs: FindFriendsStatsCellViewModelInputs { return self }
  /// Returns `self` as `FindFriendsStatsCellViewModelOutputs`.
  public var outputs: FindFriendsStatsCellViewModelOutputs { return self }

  fileprivate let configureWithStatsProperty = MutableProperty<FriendStatsEnvelope?>(nil)
  fileprivate let configureWithSourceProperty = MutableProperty<FriendsSource>(FriendsSource.findFriends)
  /// Configures the cell with friend stats and presentation source.
  public func configureWith(stats: FriendStatsEnvelope, source: FriendsSource) {
    self.configureWithStatsProperty.value = stats
    self.configureWithSourceProperty.value = source
  }

  fileprivate let confirmFollowAllFriendsProperty = MutableProperty(())
  func confirmFollowAllFriends() {
    self.confirmFollowAllFriendsProperty.value = ()
  }

  fileprivate let declineFollowAllFriendsProperty = MutableProperty(())
  func declineFollowAllFriends() {
    self.declineFollowAllFriendsProperty.value = ()
  }

  fileprivate let followAllButtonTappedProperty = MutableProperty(())
  /// Requests confirmation to follow all discovered friends.
  public func followAllButtonTapped() {
    self.followAllButtonTappedProperty.value = ()
  }

  /// Emits formatted total projects backed by friends.
  public let backedProjectsCountText: Signal<String, Never>
  /// Emits localized Follow All button title text.
  public let followAllText: Signal<String, Never>
  /// Emits formatted total discovered friends count.
  public let friendsCountText: Signal<String, Never>
  /// Emits whether the Follow All button should be hidden.
  public let hideFollowAllButton: Signal<Bool, Never>
  /// Emits the friend count when displaying the Follow All confirmation dialog.
  public let notifyDelegateShowFollowAllFriendsAlert: Signal<Int, Never>
}
