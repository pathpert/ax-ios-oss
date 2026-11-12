import Foundation
import ReactiveSwift

/// Flow origin in which curated projects are displayed.
public enum CuratedProjectsContext {
  /// Step 2 of user onboarding.
  case onboarding
  /// Personalized discovery feed presentation.
  case discovery
}

/// Header display context distinguishing category selection from curated project recommendations.
public enum CategorySelectionOnboardingHeaderViewContext {
  /// Category selection step (Step 1).
  case categorySelection
  /// Curated projects recommendation step (Step 2 or discovery).
  case curatedProjects(CuratedProjectsContext)

  var stepLabelText: String? {
    switch self {
    case .categorySelection:
      return Strings.Step_number(current_step: "1", total_steps: "2")
    case let .curatedProjects(context):
      switch context {
      case .onboarding:
        return Strings.Step_number(current_step: "2", total_steps: "2")
      case .discovery:
        return nil
      }
    }
  }

  var stepLabelHidden: Bool {
    switch self {
    case .categorySelection:
      return false
    case let .curatedProjects(context):
      switch context {
      case .discovery:
        return true
      case .onboarding:
        return false
      }
    }
  }

  var subtitleLabelText: String? {
    switch self {
    case .categorySelection:
      return Strings.Select_up_to_five()
    case .curatedProjects:
      return nil
    }
  }

  var titleLabelText: String {
    switch self {
    case .categorySelection:
      return Strings.Which_categories_interest_you()
    case .curatedProjects:
      return Strings.Check_out_these_handpicked_projects()
    }
  }
}

/// Inputs accepted by `CategorySelectionHeaderViewModel`.
public protocol CategorySelectionHeaderViewModelInputs {
  /// Configures the header with the current onboarding or discovery context.
  func configure(with context: CategorySelectionOnboardingHeaderViewContext)
}

/// Outputs emitted by `CategorySelectionHeaderViewModel`.
public protocol CategorySelectionHeaderViewModelOutputs {
  /// Emits whether the step indicator label should be hidden.
  var stepLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits formatted step progress text (e.g., `"Step 1 of 2"`).
  var stepLabelText: Signal<String, Never> { get }
  /// Emits localized instructional subtitle copy, when applicable.
  var subtitleLabelText: Signal<String, Never> { get }
  /// Emits the main localized header title text.
  var titleLabelText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `CategorySelectionHeaderViewModel`.
public protocol CategorySelectionHeaderViewModelType {
  /// Input receiver for header context configuration.
  var inputs: CategorySelectionHeaderViewModelInputs { get }
  /// Output signals formatting header titles and step indicators.
  var outputs: CategorySelectionHeaderViewModelOutputs { get }
}

/// View model formatting header copy and step indicators for category personalization screens.
public final class CategorySelectionHeaderViewModel: CategorySelectionHeaderViewModelType,
  CategorySelectionHeaderViewModelInputs, CategorySelectionHeaderViewModelOutputs {
  /// Initializes the category selection header view model.
  public init() {
    self.stepLabelText = self.contextSignal
      .map(\.stepLabelText)
      .skipNil()

    self.subtitleLabelText = self.contextSignal
      .map(\.subtitleLabelText)
      .skipNil()

    self.titleLabelText = self.contextSignal
      .map(\.titleLabelText)

    self.stepLabelIsHidden = self.contextSignal
      .map(\.stepLabelHidden)
  }

  private let (contextSignal, contextObserver)
    = Signal<CategorySelectionOnboardingHeaderViewContext, Never>.pipe()
  /// Configures the header with a `CategorySelectionOnboardingHeaderViewContext`.
  public func configure(with context: CategorySelectionOnboardingHeaderViewContext) {
    self.contextObserver.send(value: context)
  }

  /// Emits whether the step label is hidden.
  public let stepLabelIsHidden: Signal<Bool, Never>
  /// Emits the step progress text.
  public let stepLabelText: Signal<String, Never>
  /// Emits the subtitle copy.
  public let subtitleLabelText: Signal<String, Never>
  /// Emits the primary header title text.
  public let titleLabelText: Signal<String, Never>

  /// Returns `self` as `CategorySelectionHeaderViewModelInputs`.
  public var inputs: CategorySelectionHeaderViewModelInputs { return self }
  /// Returns `self` as `CategorySelectionHeaderViewModelOutputs`.
  public var outputs: CategorySelectionHeaderViewModelOutputs { return self }
}
