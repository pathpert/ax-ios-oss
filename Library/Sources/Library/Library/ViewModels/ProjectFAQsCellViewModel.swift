import KsApi
import Prelude
import ReactiveSwift

/// Inputs for `ProjectFAQsCellViewModel`.
public protocol ProjectFAQsCellViewModelInputs {
  /// Call to configure with a tuple of `ProjectFAQ, Bool`. The `Bool` represents whether the cell is expanded.
  func configureWith(value: (ProjectFAQ, Bool))
}

/// Outputs for `ProjectFAQsCellViewModel`.
public protocol ProjectFAQsCellViewModelOutputs {
  /// Emits a `String` of the answer from the FAQ object
  var answerLabelText: Signal<String, Never> { get }

  /// Emits a `Bool` for determining whether the stackview containing the answer is hidden
  var answerStackViewIsHidden: Signal<Bool, Never> { get }

  /// Emits a `Bool` to determine if the chevron image view should point up or down
  var configureChevronImageView: Signal<Bool, Never> { get }

  /// Emits a `String` of the question from the FAQ object
  var questionLabelText: Signal<String, Never> { get }

  /// Emits a `String` of the time stamp from the FAQ object
  var updatedLabelText: Signal<String, Never> { get }
}

/// Type interface for `ProjectFAQsCellViewModel`.
public protocol ProjectFAQsCellViewModelType {
  /// View model inputs.
  var inputs: ProjectFAQsCellViewModelInputs { get }
  /// View model outputs.
  var outputs: ProjectFAQsCellViewModelOutputs { get }
}

/// View model for displaying and toggling an individual project FAQ cell.
public final class ProjectFAQsCellViewModel:
  ProjectFAQsCellViewModelType, ProjectFAQsCellViewModelInputs, ProjectFAQsCellViewModelOutputs {
  /// Initializes the FAQ cell view model and binds question, answer, and expansion signals.
  public init() {
    let faq = self.configureWithProperty.signal
      .skipNil()
      .map(first)

    let isExpanded = self.configureWithProperty.signal
      .skipNil()
      .map(second)

    self.answerLabelText = faq.map(\.answer)
    self.answerStackViewIsHidden = isExpanded.negate()
    self.configureChevronImageView = isExpanded
    self.questionLabelText = faq.map(\.question)
    self.updatedLabelText = faq
      .map(\.createdAt)
      .skipNil()
      .map { createdAt in
        "Updated \(Format.date(secondsInUTC: createdAt, template: "MMM d, yyyy"))"
      }
  }

  fileprivate let configureWithProperty = MutableProperty<(ProjectFAQ, Bool)?>(nil)
  /// Configures the cell with the FAQ item and whether it is expanded.
  public func configureWith(value: (ProjectFAQ, Bool)) {
    self.configureWithProperty.value = value
  }

  /// Emits the formatted FAQ answer string.
  public let answerLabelText: Signal<String, Never>
  /// Emits whether the answer stack view should be hidden.
  public let answerStackViewIsHidden: Signal<Bool, Never>
  /// Emits whether the chevron image view indicates expanded state.
  public let configureChevronImageView: Signal<Bool, Never>
  /// Emits the FAQ question string.
  public let questionLabelText: Signal<String, Never>
  /// Emits the formatted last-updated timestamp string.
  public let updatedLabelText: Signal<String, Never>

  /// View model inputs.
  public var inputs: ProjectFAQsCellViewModelInputs { self }
  /// View model outputs.
  public var outputs: ProjectFAQsCellViewModelOutputs { self }
}
