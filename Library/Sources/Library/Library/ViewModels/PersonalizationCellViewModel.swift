import Foundation
import ReactiveSwift

/// Input contract for `PersonalizationCellViewModel`.
public protocol PersonalizationCellViewModelInputs {
  /// Call when the personalization promo cell body is tapped.
  func cellTapped()
  /// Call when the dismiss ("close") button on the cell is tapped.
  func dismissButtonTapped()
}

/// Output contract for `PersonalizationCellViewModel`.
public protocol PersonalizationCellViewModelOutputs {
  /// Emits when the cell should notify its delegate to dismiss personalization.
  var notifyDelegateDismissButtonTapped: Signal<Void, Never> { get }
  /// Emits when the cell should notify its delegate to open category personalization.
  var notifyDelegateViewTapped: Signal<Void, Never> { get }
}

/// Composite ViewModel protocol pairing personalization cell inputs and outputs.
public protocol PersonalizationCellViewModelType {
  /// Input receiver.
  var inputs: PersonalizationCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: PersonalizationCellViewModelOutputs { get }
}

/// ViewModel forwarding tap and dismiss actions for the Discovery personalization promo card.
public final class PersonalizationCellViewModel: PersonalizationCellViewModelType,
  PersonalizationCellViewModelInputs, PersonalizationCellViewModelOutputs {
  /// Initializes tap and dismiss forwarding signals.
  public init() {
    self.notifyDelegateDismissButtonTapped = self.dismissButtonTappedProperty.signal
    self.notifyDelegateViewTapped = self.cellTappedProperty.signal
  }

  private let cellTappedProperty = MutableProperty(())
  /// Signals that the card was tapped.
  public func cellTapped() {
    self.cellTappedProperty.value = ()
  }

  private let dismissButtonTappedProperty = MutableProperty(())
  /// Signals that the dismiss button was tapped.
  public func dismissButtonTapped() {
    self.dismissButtonTappedProperty.value = ()
  }

  /// Delegate notification trigger for card dismissal.
  public let notifyDelegateDismissButtonTapped: Signal<Void, Never>
  /// Delegate notification trigger for card selection.
  public let notifyDelegateViewTapped: Signal<Void, Never>

  /// Self-conformance to `PersonalizationCellViewModelInputs`.
  public var inputs: PersonalizationCellViewModelInputs { return self }
  /// Self-conformance to `PersonalizationCellViewModelOutputs`.
  public var outputs: PersonalizationCellViewModelOutputs { return self }
}
