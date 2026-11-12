import KsApi
import Prelude
import ReactiveSwift

/// Input actions for `ProjectRisksCellViewModel`.
public protocol ProjectRisksCellViewModelInputs {
  /// Call to configure with a `String` of the risks.
  func configureWith(value: String)
}

/// Output signals for `ProjectRisksCellViewModel`.
public protocol ProjectRisksCellViewModelOutputs {
  /// Emits a `String` of the risks.
  var descriptionLabelText: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for `ProjectRisksCellViewModel`.
public protocol ProjectRisksCellViewModelType {
  /// Input receiver.
  var inputs: ProjectRisksCellViewModelInputs { get }
  /// Output signals.
  var outputs: ProjectRisksCellViewModelOutputs { get }
}

/// View model delivering campaign risk disclosure copy to the project risks table cell.
public final class ProjectRisksCellViewModel:
  ProjectRisksCellViewModelType, ProjectRisksCellViewModelInputs,
  ProjectRisksCellViewModelOutputs {
  /// Initializes risk text signal mapping.
  public init() {
    self.descriptionLabelText = self.configureWithProperty.signal.skipNil()
  }

  fileprivate let configureWithProperty = MutableProperty<String?>(nil)
  /// Supplies the creator's risks and challenges copy.
  public func configureWith(value: String) {
    self.configureWithProperty.value = value
  }

  /// Emits formatted risk description strings.
  public let descriptionLabelText: Signal<String, Never>

  /// Concrete input interface.
  public var inputs: ProjectRisksCellViewModelInputs { self }
  /// Concrete output interface.
  public var outputs: ProjectRisksCellViewModelOutputs { self }
}
