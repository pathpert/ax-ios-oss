import Foundation
import ReactiveSwift

/// Input contract for `RewardCellViewModel`.
public protocol RewardCellViewModelInputs {
  /// Configures the cell with a `RewardCardViewData` value.
  func configure(with data: RewardCardViewData)
  /// Resets cell scroll state prior to collection view reuse.
  func prepareForReuse()
}

/// Output contract for `RewardCellViewModel`.
public protocol RewardCellViewModelOutputs {
  /// Emits `true` when the "Your Selection" backer badge should be hidden.
  var backerLabelHidden: Signal<Bool, Never> { get }
  /// Emits when the embedded scroll view should reset to top offset.
  var scrollScrollViewToTop: Signal<Void, Never> { get }
}

/// Composite ViewModel protocol pairing reward cell inputs and outputs.
public protocol RewardCellViewModelType {
  /// Input receiver.
  var inputs: RewardCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: RewardCellViewModelOutputs { get }
}

/// ViewModel managing outer cell state (backer badge visibility and scroll reset) for `RewardCell`.
public final class RewardCellViewModel: RewardCellViewModelType, RewardCellViewModelInputs,
  RewardCellViewModelOutputs {
  /// Initializes scroll-reset and backer-badge signals.
  public init() {
    self.scrollScrollViewToTop = self.prepareForReuseProperty.signal
    self.backerLabelHidden = self.configDataProperty.signal.skipNil()
      .map { data in
        userIsBacking(reward: data.reward, inProject: data.project)
      }
      .negate()
  }

  private let configDataProperty = MutableProperty<RewardCardViewData?>(nil)
  /// Binds reward and project state to the cell ViewModel.
  public func configure(with data: RewardCardViewData) {
    self.configDataProperty.value = data
  }

  private let prepareForReuseProperty = MutableProperty(())
  /// Signals cell reuse so scroll position resets to top.
  public func prepareForReuse() {
    self.prepareForReuseProperty.value = ()
  }

  /// Controls visibility of the "Backed" indicator badge.
  public let backerLabelHidden: Signal<Bool, Never>
  /// Fires on `prepareForReuse()` to scroll content back to top.
  public let scrollScrollViewToTop: Signal<Void, Never>

  /// Self-conformance to `RewardCellViewModelInputs`.
  public var inputs: RewardCellViewModelInputs { return self }
  /// Self-conformance to `RewardCellViewModelOutputs`.
  public var outputs: RewardCellViewModelOutputs { return self }
}
