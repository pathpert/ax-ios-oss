import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Category of project disclosure disclaimer displayed in the project tab.
public enum ProjectDisclaimerType {
  /// Environmental commitments disclosure section.
  case environmental
  /// Artificial intelligence usage disclosure section.
  case aiDisclosure
}

/// Inputs for `ProjectTabDisclaimerCellViewModel`.
public protocol ProjectTabDisclaimerCellViewModelInputs {
  /// Call to configure the cell with disclaimer type
  func configure(with type: ProjectDisclaimerType)

  /// Call when a URL in the UITextView is tapped.
  func linkTapped(url: URL)
}

/// Outputs for `ProjectTabDisclaimerCellViewModel`.
public protocol ProjectTabDisclaimerCellViewModelOutputs {
  /// Emits an `URL` of the URL being tapped in the UITextView.
  var notifyDelegateLinkTappedWithURL: Signal<URL, Never> { get }

  /// Emits `ProjectDisclaimerType` to update the UITextView with the correct URL.
  var updateURLFromProjectType: Signal<ProjectDisclaimerType, Never> { get }
}

/// Type interface for `ProjectTabDisclaimerCellViewModel`.
public protocol ProjectTabDisclaimerCellViewModelType {
  /// View model inputs.
  var inputs: ProjectTabDisclaimerCellViewModelInputs { get }
  /// View model outputs.
  var outputs: ProjectTabDisclaimerCellViewModelOutputs { get }
}

/// View model managing disclaimer type configuration and help link taps on project tabs.
public final class ProjectTabDisclaimerCellViewModel:
  ProjectTabDisclaimerCellViewModelType,
  ProjectTabDisclaimerCellViewModelInputs,
  ProjectTabDisclaimerCellViewModelOutputs {
  /// Initializes the disclaimer cell view model and binds configuration and link tap signals.
  public init() {
    self.notifyDelegateLinkTappedWithURL = self.linkTappedProperty.signal.skipNil()

    self.updateURLFromProjectType = self.configureProperty.signal.skipNil()
  }

  fileprivate let configureProperty = MutableProperty<ProjectDisclaimerType?>(nil)
  /// Configures the cell with the specified disclaimer type.
  public func configure(with type: ProjectDisclaimerType) {
    self.configureProperty.value = type
  }

  fileprivate let linkTappedProperty = MutableProperty<URL?>(nil)
  /// Called when the user taps a link within the disclaimer text view.
  public func linkTapped(url: URL) {
    self.linkTappedProperty.value = url
  }

  /// Emits the tapped URL to notify the presenting delegate.
  public let notifyDelegateLinkTappedWithURL: Signal<URL, Never>
  /// Emits the configured `ProjectDisclaimerType` to update displayed copy and URL.
  public let updateURLFromProjectType: Signal<ProjectDisclaimerType, Never>

  /// View model inputs.
  public var inputs: ProjectTabDisclaimerCellViewModelInputs { self }
  /// View model outputs.
  public var outputs: ProjectTabDisclaimerCellViewModelOutputs { self }
}
