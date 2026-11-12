import Foundation
import KsApi
import ReactiveSwift

/// Strongly-typed view data configuring the trust-and-safety / pledge disclaimer banner.
///
/// Negative Constraint: `iconImageName` must reference a valid asset in the KDS/app bundle; do not pass SF Symbol names unless supported by the view.
public struct PledgeDisclaimerViewData: Equatable {
  /// Asset catalog image name displayed beside the disclaimer copy.
  public let iconImageName: String
  /// Styled disclaimer text containing clickable help/policy URLs.
  public let attributedText: NSAttributedString

  /// Creates a typed `PledgeDisclaimerViewData` contract.
  public init(iconImageName: String, attributedText: NSAttributedString) {
    self.iconImageName = iconImageName
    self.attributedText = attributedText
  }
}

/// Outputs for `PledgeDisclaimerViewModel`.
public protocol PledgeDisclaimerViewModelOutputs {
  /// Emits the disclaimer icon asset name.
  var iconImageName: Signal<String, Never> { get }
  /// Emits the attributed disclaimer copy containing interactive links.
  var attributedText: Signal<NSAttributedString, Never> { get }
  /// Emits the destination URL when the user taps a disclaimer link.
  var notifyDelegateLinkTappedWithURL: Signal<URL, Never> { get }
}

/// Inputs for `PledgeDisclaimerViewModel`.
public protocol PledgeDisclaimerViewModelInputs {
  /// Configures the disclaimer view with icon and attributed text data.
  func configure(with data: PledgeDisclaimerViewData)
  /// Called when the user taps an embedded link in the disclaimer text.
  func linkTapped(url: URL)
}

/// Type interface for `PledgeDisclaimerViewModel`.
public protocol PledgeDisclaimerViewModelType {
  /// View model inputs.
  var inputs: PledgeDisclaimerViewModelInputs { get }
  /// View model outputs.
  var outputs: PledgeDisclaimerViewModelOutputs { get }
}

/// View model driving the pledge disclaimer banner and its interactive help links.
public final class PledgeDisclaimerViewModel: PledgeDisclaimerViewModelType,
  PledgeDisclaimerViewModelInputs, PledgeDisclaimerViewModelOutputs {
  /// Initializes the pledge disclaimer view model and binds display/link signals.
  public init() {
    self.notifyDelegateLinkTappedWithURL = self.linkTappedURLProperty.signal.skipNil()
    self.iconImageName = self.configDataProperty.signal.skipNil().map(\.iconImageName)
    self.attributedText = self.configDataProperty.signal.skipNil().map(\.attributedText)
  }

  private let configDataProperty = MutableProperty<PledgeDisclaimerViewData?>(nil)
  /// Configures the disclaimer view with icon and attributed text data.
  public func configure(with data: PledgeDisclaimerViewData) {
    self.configDataProperty.value = data
  }

  private let linkTappedURLProperty = MutableProperty<URL?>(nil)
  /// Called when the user taps an embedded link in the disclaimer text.
  public func linkTapped(url: URL) {
    self.linkTappedURLProperty.value = url
  }

  /// Emits the attributed disclaimer copy.
  public let attributedText: Signal<NSAttributedString, Never>
  /// Emits the disclaimer icon asset name.
  public let iconImageName: Signal<String, Never>
  /// Emits the tapped URL to notify the presenting delegate.
  public let notifyDelegateLinkTappedWithURL: Signal<URL, Never>

  /// View model inputs.
  public var inputs: PledgeDisclaimerViewModelInputs { return self }
  /// View model outputs.
  public var outputs: PledgeDisclaimerViewModelOutputs { return self }
}
