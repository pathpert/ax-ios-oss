import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input contract for `DiscoveryProjectCategoryViewModel`.
public protocol DiscoveryProjectCategoryViewModelInputs {
  /// Configures the category pill with localized category name and asset image identifier.
  func configureWith(name: String, imageNameString: String)
}

/// Output contract for `DiscoveryProjectCategoryViewModel`.
public protocol DiscoveryProjectCategoryViewModelOutputs {
  /// Emits the category display name.
  var categoryNameText: Signal<String, Never> { get }
  /// Emits the asset image name for the category icon.
  var categoryImageName: Signal<String, Never> { get }
}

/// Composite ViewModel protocol pairing discovery project category badge inputs and outputs.
public protocol DiscoveryProjectCategoryViewModelType {
  /// Input receiver.
  var inputs: DiscoveryProjectCategoryViewModelInputs { get }
  /// Output signal provider.
  var outputs: DiscoveryProjectCategoryViewModelOutputs { get }
}

/// ViewModel formatting category icon and title overlays on discovery project cards.
public final class DiscoveryProjectCategoryViewModel: DiscoveryProjectCategoryViewModelType,
  DiscoveryProjectCategoryViewModelInputs,
  DiscoveryProjectCategoryViewModelOutputs {
  /// Self-conformance to `DiscoveryProjectCategoryViewModelInputs`.
  public var inputs: DiscoveryProjectCategoryViewModelInputs { return self }
  /// Self-conformance to `DiscoveryProjectCategoryViewModelOutputs`.
  public var outputs: DiscoveryProjectCategoryViewModelOutputs { return self }

  /// Initializes category label and icon name signals.
  public init() {
    self.categoryNameText = self.categoryNameTextProperty.signal.skipNil().map { $0 }
    self.categoryImageName = self.imageStringProperty.signal.skipNil()
  }

  /// Localized category name stream.
  public var categoryNameText: Signal<String, Never>
  /// Icon asset identifier stream.
  public var categoryImageName: Signal<String, Never>

  private let categoryNameTextProperty = MutableProperty<String?>(nil)
  private let imageStringProperty = MutableProperty<String?>(nil)

  /// Binds category `name` and `imageNameString` icon name.
  public func configureWith(name: String, imageNameString: String) {
    self.categoryNameTextProperty.value = name
    self.imageStringProperty.value = imageNameString
  }
}
