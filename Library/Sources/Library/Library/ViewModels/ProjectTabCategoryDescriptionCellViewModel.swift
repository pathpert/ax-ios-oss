import KsApi
import Prelude
import ReactiveSwift

/// Input contract for `ProjectTabCategoryDescriptionCellViewModel`.
public protocol ProjectTabCategoryDescriptionCellViewModelInputs {
  /// Call to configure with a `ProjectTabCategoryDescription`.
  func configureWith(value: ProjectTabCategoryDescription)
}

/// Output contract for `ProjectTabCategoryDescriptionCellViewModel`.
public protocol ProjectTabCategoryDescriptionCellViewModelOutputs {
  /// Emits a `String` of the category from the `ProjectTabCategoryDescription` object
  var categoryLabelText: Signal<String, Never> { get }

  /// Emits a `String` of the description from the `ProjectTabCategoryDescription` object
  var descriptionLabelText: Signal<String, Never> { get }
}

/// Composite ViewModel protocol for environmental/AI commitment disclosure cells.
public protocol ProjectTabCategoryDescriptionCellViewModelType {
  /// Input receiver.
  var inputs: ProjectTabCategoryDescriptionCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: ProjectTabCategoryDescriptionCellViewModelOutputs { get }
}

/// ViewModel formatting category headings and descriptions inside project environmental/AI tabs.
public final class ProjectTabCategoryDescriptionCellViewModel:
  ProjectTabCategoryDescriptionCellViewModelType, ProjectTabCategoryDescriptionCellViewModelInputs,
  ProjectTabCategoryDescriptionCellViewModelOutputs {
  /// Initializes localized category title and body signals.
  public init() {
    let categoryDescription = self.configureWithProperty.signal
      .skipNil()

    self.categoryLabelText = categoryDescription
      .map(\.category)
      .map(internationalizedString)

    self.descriptionLabelText = categoryDescription.map(\.description)
  }

  fileprivate let configureWithProperty = MutableProperty<ProjectTabCategoryDescription?>(nil)
  /// Binds a disclosure category-description item.
  public func configureWith(value: ProjectTabCategoryDescription) {
    self.configureWithProperty.value = value
  }

  /// Localized category heading signal.
  public let categoryLabelText: Signal<String, Never>
  /// Disclosure body text signal.
  public let descriptionLabelText: Signal<String, Never>

  /// Self-conformance to `ProjectTabCategoryDescriptionCellViewModelInputs`.
  public var inputs: ProjectTabCategoryDescriptionCellViewModelInputs { self }
  /// Self-conformance to `ProjectTabCategoryDescriptionCellViewModelOutputs`.
  public var outputs: ProjectTabCategoryDescriptionCellViewModelOutputs { self }
}

private func internationalizedString(for category: ProjectTabCategory) -> String {
  switch category {
  case .longLastingDesign:
    return Strings.Long_lasting_design()
  case .sustainableMaterials:
    return Strings.Sustainable_materials()
  case .environmentallyFriendlyFactories:
    return Strings.Environmentally_friendly_factories()
  case .sustainableDistribution:
    return Strings.Sustainable_distribution()
  case .reusabilityAndRecyclability:
    return Strings.Reusability_and_recyclability()
  case .aiDisclosureOtherDetails:
    return Strings.I_am_incorporating_AI_in_my_project()
  case .somethingElse:
    return Strings.Something_else()
  }
}
