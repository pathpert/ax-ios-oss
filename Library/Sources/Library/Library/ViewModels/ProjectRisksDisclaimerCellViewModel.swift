import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Input actions for `ProjectRisksDisclaimerCellViewModel`.
public protocol ProjectRisksDisclaimerCellViewModelInputs {
  /// Call when the UILabel  is tapped.
  func descriptionLabelTapped(url: URL)
}

/// Output signals for `ProjectRisksDisclaimerCellViewModel`.
public protocol ProjectRisksDisclaimerCellViewModelOutputs {
  /// Emits an `URL` when the description label is tapped.
  var notifyDelegateDescriptionLabelTapped: Signal<URL, Never> { get }
}

/// Combined inputs/outputs contract for `ProjectRisksDisclaimerCellViewModel`.
public protocol ProjectRisksDisclaimerCellViewModelType {
  /// Input receiver.
  var inputs: ProjectRisksDisclaimerCellViewModelInputs { get }
  /// Signal outputs.
  var outputs: ProjectRisksDisclaimerCellViewModelOutputs { get }
}

/// View model forwarding accountability link taps from the project risks disclaimer cell.
public final class ProjectRisksDisclaimerCellViewModel:
  ProjectRisksDisclaimerCellViewModelType,
  ProjectRisksDisclaimerCellViewModelInputs,
  ProjectRisksDisclaimerCellViewModelOutputs {
  /// Initializes tap-forwarding signal stream.
  public init() {
    self.notifyDelegateDescriptionLabelTapped = self.descriptionLabelTappedProperty.signal
      .skipNil()
  }

  fileprivate let descriptionLabelTappedProperty = MutableProperty<URL?>(nil)
  /// Notifies the view model that a link URL inside the disclaimer label was tapped.
  public func descriptionLabelTapped(url: URL) {
    self.descriptionLabelTappedProperty.value = url
  }

  /// Emits tapped help URLs for delegate presentation.
  public let notifyDelegateDescriptionLabelTapped: Signal<URL, Never>

  /// Concrete input interface.
  public var inputs: ProjectRisksDisclaimerCellViewModelInputs { self }
  /// Concrete output interface.
  public var outputs: ProjectRisksDisclaimerCellViewModelOutputs { self }
}
