import KsApi
import Prelude
import ReactiveSwift

/// Output signals for `FindFriendsCellViewModel`.
public protocol FindFriendsCellViewModelOutputs {
  /// Emits `true` when the follow CTA should appear disabled because social following is turned off.
  var isDisabled: Signal<Bool, Never> { get }
}

/// Input actions for `FindFriendsCellViewModel`.
public protocol FindFriendsCellViewModelInputs {
  /// Configures the cell with the current signed-in `User`.
  func configure(with user: User?)
}

/// Combined inputs/outputs contract for `FindFriendsCellViewModel`.
public protocol FindFriendsCellViewModelType {
  /// Input receiver.
  var inputs: FindFriendsCellViewModelInputs { get }
  /// Output signals.
  var outputs: FindFriendsCellViewModelOutputs { get }
}

/// View model computing disabled state for the Find Friends onboarding cell from user social settings.
public final class FindFriendsCellViewModel: FindFriendsCellViewModelInputs,
  FindFriendsCellViewModelOutputs, FindFriendsCellViewModelType {
  /// Initializes social-following negation stream.
  public init() {
    let isFollowingEnabled = self.userProperty.signal
      .skipNil()
      .map { $0 |> User.lens.social.view }
      .skipNil()

    self.isDisabled = isFollowingEnabled.negate()
  }

  fileprivate var userProperty = MutableProperty<User?>(nil)
  /// Supplies the active user model (or `nil` when signed out).
  public func configure(with user: User?) {
    self.userProperty.value = user
  }

  /// Emits `true` when social friend discovery is disabled.
  public let isDisabled: Signal<Bool, Never>

  /// Concrete output interface.
  public var outputs: FindFriendsCellViewModelOutputs {
    return self
  }

  /// Concrete input interface.
  public var inputs: FindFriendsCellViewModelInputs {
    return self
  }
}
