import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input contract for `ThanksCategoryCellViewModel`.
public protocol ThanksCategoryCellViewModelInputs {
  /// Call when the "See all <Category> projects" button is tapped.
  func seeAllProjectsButtonTapped()
  /// Configures the cell with the backed project's `Category`.
  func configureWith(category: KsApi.Category)
}

/// Output contract for `ThanksCategoryCellViewModel`.
public protocol ThanksCategoryCellViewModelOutputs {
  /// Emits the `Category` when the user asks to browse all projects in that category.
  var notifyDelegateToGoToDiscovery: Signal<KsApi.Category, Never> { get }
  /// Emits the localized CTA button title containing the category name.
  var seeAllProjectCategoryTitle: Signal<String, Never> { get }
}

/// Composite ViewModel protocol pairing post-pledge thanks category inputs and outputs.
public protocol ThanksCategoryCellViewModelType {
  /// Input receiver.
  var inputs: ThanksCategoryCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: ThanksCategoryCellViewModelOutputs { get }
}

/// ViewModel driving the "Explore more <Category> projects" card shown after a successful pledge.
public final class ThanksCategoryCellViewModel: ThanksCategoryCellViewModelType,
  ThanksCategoryCellViewModelInputs, ThanksCategoryCellViewModelOutputs {
  /// Initializes localized title formatting and navigation triggers.
  public init() {
    let projectCategory = self.categoryProperty.signal.skipNil()

    self.seeAllProjectCategoryTitle = projectCategory.map {
      Strings.See_all_category_name_projects(category_name: $0.name)
    }

    self.notifyDelegateToGoToDiscovery = projectCategory
      .takeWhen(self.seeAllProjectsButtonTappedProperty.signal)
  }

  fileprivate let categoryProperty = MutableProperty<KsApi.Category?>(nil)
  /// Binds the backed project's category.
  public func configureWith(category: KsApi.Category) {
    self.categoryProperty.value = category
  }

  fileprivate let seeAllProjectsButtonTappedProperty = MutableProperty(())
  /// Signals that the user tapped the explore-category button.
  public func seeAllProjectsButtonTapped() {
    self.seeAllProjectsButtonTappedProperty.value = ()
  }

  /// Localized CTA label text.
  public let seeAllProjectCategoryTitle: Signal<String, Never>
  /// Fires with the configured category when tapped.
  public let notifyDelegateToGoToDiscovery: Signal<KsApi.Category, Never>

  /// Self-conformance to `ThanksCategoryCellViewModelInputs`.
  public var inputs: ThanksCategoryCellViewModelInputs { return self }
  /// Self-conformance to `ThanksCategoryCellViewModelOutputs`.
  public var outputs: ThanksCategoryCellViewModelOutputs { return self }
}
