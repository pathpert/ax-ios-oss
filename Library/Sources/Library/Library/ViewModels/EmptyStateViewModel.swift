import Foundation
import KDS
import ReactiveSwift
import UIKit

/// Variants of the reusable empty state card view.
public enum EmptyStateViewType {
  /// Generic network or refresh failure banner prompting pull-to-refresh.
  case errorPullToRefresh
  /// Empty state shown when selected add-ons cannot ship to the chosen location.
  case addOnsUnavailable

  var imageName: String? {
    switch self {
    case .errorPullToRefresh: return "icon-exclamation"
    case .addOnsUnavailable: return "icon-globe"
    }
  }

  var leftRightMargins: CGFloat {
    switch self {
    case .errorPullToRefresh: return Styles.grid(10)
    case .addOnsUnavailable: return Styles.grid(3)
    }
  }

  var titleLabelHidden: Bool {
    switch self {
    case .errorPullToRefresh: return true
    case .addOnsUnavailable: return false
    }
  }

  var bodyLabelHidden: Bool {
    return false
  }

  var titleLabelText: String {
    switch self {
    case .errorPullToRefresh: return ""
    case .addOnsUnavailable:
      return Strings.Add_ons_unavailable()
    }
  }

  var bodyLabelText: String {
    switch self {
    case .errorPullToRefresh:
      return Strings.Something_went_wrong_pull_to_refresh()
    case .addOnsUnavailable:
      return Strings.Change_your_shipping_location_or_skip_add_ons_to_continue()
    }
  }

  var bodyLabelTextColor: UIColor {
    switch self {
    case .errorPullToRefresh:
      return LegacyColors.ksr_support_700.uiColor()
    case .addOnsUnavailable:
      return LegacyColors.ksr_support_400.uiColor()
    }
  }
}

/// Inputs accepted by `EmptyStateViewModel`.
public protocol EmptyStateViewModelInputs {
  /// Configures the view model with a specific `EmptyStateViewType`.
  func configure(with type: EmptyStateViewType)
}

/// Outputs emitted by `EmptyStateViewModel`.
public protocol EmptyStateViewModelOutputs {
  /// Emits whether the body label should be hidden.
  var bodyLabelHidden: Signal<Bool, Never> { get }
  /// Emits localized explanatory copy for the body label.
  var bodyLabelText: Signal<String, Never> { get }
  /// Emits the text color applied to the body label.
  var bodyLabelTextColor: Signal<UIColor, Never> { get }
  /// Emits the icon asset name to render above the message, if any.
  var imageName: Signal<String?, Never> { get }
  /// Emits horizontal side margins framing the empty state content.
  var leftRightMargins: Signal<CGFloat, Never> { get }
  /// Emits whether the title label should be hidden.
  var titleLabelHidden: Signal<Bool, Never> { get }
  /// Emits localized headline copy for the title label.
  var titleLabelText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `EmptyStateViewModel`.
public protocol EmptyStateViewModelType {
  /// Input receiver for empty state variant configuration.
  var inputs: EmptyStateViewModelInputs { get }
  /// Output signals styling the empty state view labels and image.
  var outputs: EmptyStateViewModelOutputs { get }
}

/// View model formatting icon, typography colors, and copy for generic empty state views.
public final class EmptyStateViewModel: EmptyStateViewModelType, EmptyStateViewModelInputs,
  EmptyStateViewModelOutputs {
  /// Initializes the empty state view model.
  public init() {
    let type = self.configDataProperty.signal.skipNil()

    self.bodyLabelHidden = type.map(\.bodyLabelHidden)
    self.bodyLabelText = type.map(\.bodyLabelText)
    self.bodyLabelTextColor = type.map(\.bodyLabelTextColor)
    self.imageName = type.map(\.imageName)
    self.leftRightMargins = type.map(\.leftRightMargins)
    self.titleLabelHidden = type.map(\.titleLabelHidden)
    self.titleLabelText = type.map(\.titleLabelText)
  }

  private let configDataProperty = MutableProperty<EmptyStateViewType?>(nil)
  /// Configures the empty state view with `data`.
  public func configure(with data: EmptyStateViewType) {
    self.configDataProperty.value = data
  }

  /// Emits whether the body label is hidden.
  public let bodyLabelHidden: Signal<Bool, Never>
  /// Emits localized body text.
  public let bodyLabelText: Signal<String, Never>
  /// Emits text color for the body label.
  public let bodyLabelTextColor: Signal<UIColor, Never>
  /// Emits asset name for the illustration icon.
  public let imageName: Signal<String?, Never>
  /// Emits horizontal margin padding around content.
  public let leftRightMargins: Signal<CGFloat, Never>
  /// Emits whether the title label is hidden.
  public let titleLabelHidden: Signal<Bool, Never>
  /// Emits localized title text.
  public let titleLabelText: Signal<String, Never>

  /// Returns `self` as `EmptyStateViewModelInputs`.
  public var inputs: EmptyStateViewModelInputs { return self }
  /// Returns `self` as `EmptyStateViewModelOutputs`.
  public var outputs: EmptyStateViewModelOutputs { return self }
}
