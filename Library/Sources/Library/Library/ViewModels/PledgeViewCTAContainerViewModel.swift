import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `PledgeViewCTAContainerViewModel`.
public protocol PledgeViewCTAContainerViewModelInputs {
  /// Signals that the Apple Pay button was tapped.
  func applePayButtonTapped()
  /// Configures the CTA container with pledge availability and state data.
  func configureWith(value: PledgeViewCTAContainerViewData)
  /// Signals that the logged-out Continue button was tapped.
  func continueButtonTapped()
  /// Signals that the pledge submit/retry button was tapped.
  func submitButtonTapped()
  /// Handles a tap on an informational help link URL.
  func tapped(_ url: URL)
}

/// Outputs exposed by `PledgeViewCTAContainerViewModel`.
public protocol PledgeViewCTAContainerViewModelOutputs {
  /// Emits whether the Apple Pay button should be hidden.
  var applePayButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits whether the logged-out Continue button should be hidden.
  var continueButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits when the delegate should start the Apple Pay flow.
  var notifyDelegateApplePayButtonTapped: Signal<Void, Never> { get }
  /// Emits the `HelpType` to open when a help link is tapped.
  var notifyDelegateOpenHelpType: Signal<HelpType, Never> { get }
  /// Emits when the delegate should submit the pledge.
  var notifyDelegateSubmitButtonTapped: Signal<Void, Never> { get }
  /// Emits when the delegate should present login/signup before pledging.
  var notifyDelegateToGoToLoginSignup: Signal<Void, Never> { get }
  /// Emits whether the "charged immediately" late-pledge label should be hidden.
  var pledgeImmediatelyLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits whether the submit button should be enabled.
  var submitButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits whether the submit button should be hidden.
  var submitButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits the localized title text for the submit button.
  var submitButtonTitle: Signal<String, Never> { get }
}

/// Combined inputs and outputs interface for `PledgeViewCTAContainerViewModel`.
public protocol PledgeViewCTAContainerViewModelType {
  /// The view model's inputs.
  var inputs: PledgeViewCTAContainerViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgeViewCTAContainerViewModelOutputs { get }
}

/// View model controlling the primary action buttons and helper links in the pledge CTA container.
public final class PledgeViewCTAContainerViewModel: PledgeViewCTAContainerViewModelType,
  PledgeViewCTAContainerViewModelInputs, PledgeViewCTAContainerViewModelOutputs {
  /// Creates a new `PledgeViewCTAContainerViewModel` and binds button visibility and actions.
  public init() {
    let context = self.configDataSignal.map { $0.context }
    let isLoggedIn = self.configDataSignal.map { $0.isLoggedIn }

    self.notifyDelegateOpenHelpType = self.tappedUrlProperty.signal.skipNil()
      .map(HelpType.helpType)
      .skipNil()

    self.submitButtonIsEnabled = self.configDataSignal.map { $0.isEnabled }
    self.submitButtonTitle = self.configDataSignal.map { data in
      guard data.willRetryPaymentMethod == false else { return Strings.Retry() }

      return data.context.submitButtonTitle
    }

    self.submitButtonIsHidden = isLoggedIn.map { $0 }.negate()
    self.applePayButtonIsHidden = Signal.combineLatest(context, isLoggedIn)
      .map { context, isLoggedIn in
        context.applePayButtonHidden || isLoggedIn == false
      }
    self.continueButtonIsHidden = isLoggedIn

    self.notifyDelegateApplePayButtonTapped = self.applePayButtonTappedProperty.signal
    self.notifyDelegateSubmitButtonTapped = self.submitButtonTappedProperty.signal
    self.notifyDelegateToGoToLoginSignup = self.continueButtonTappedProperty.signal

    self.pledgeImmediatelyLabelIsHidden = context
      .map { context in
        context != .latePledge
      }
  }

  private let applePayButtonTappedProperty = MutableProperty(())
  /// Notifies the view model that the Apple Pay button was tapped.
  public func applePayButtonTapped() {
    self.applePayButtonTappedProperty.value = ()
  }

  private let (configDataSignal, configDataObserver) = Signal<PledgeViewCTAContainerViewData, Never>.pipe()
  /// Updates the CTA container with new pledge configuration data.
  public func configureWith(value: PledgeViewCTAContainerViewData) {
    self.configDataObserver.send(value: value)
  }

  private let continueButtonTappedProperty = MutableProperty(())
  /// Notifies the view model that the Continue button was tapped.
  public func continueButtonTapped() {
    self.continueButtonTappedProperty.value = ()
  }

  private let submitButtonTappedProperty = MutableProperty(())
  /// Notifies the view model that the Submit button was tapped.
  public func submitButtonTapped() {
    self.submitButtonTappedProperty.value = ()
  }

  private let tappedUrlProperty = MutableProperty<URL?>(nil)
  /// Handles a tap on an informational help link URL.
  public func tapped(_ url: URL) {
    self.tappedUrlProperty.value = url
  }

  /// Emits whether the Apple Pay button is hidden.
  public let applePayButtonIsHidden: Signal<Bool, Never>
  /// Emits whether the Continue button is hidden.
  public let continueButtonIsHidden: Signal<Bool, Never>
  /// Emits whether the Submit button is hidden.
  public let submitButtonIsHidden: Signal<Bool, Never>
  /// Emits when the Apple Pay button is tapped.
  public let notifyDelegateApplePayButtonTapped: Signal<Void, Never>
  /// Emits the resolved `HelpType` for a tapped help URL.
  public let notifyDelegateOpenHelpType: Signal<HelpType, Never>
  /// Emits when the Submit button is tapped.
  public let notifyDelegateSubmitButtonTapped: Signal<Void, Never>
  /// Emits when the delegate should navigate to login/signup.
  public let notifyDelegateToGoToLoginSignup: Signal<Void, Never>
  /// Emits whether the immediate-charge label is hidden.
  public let pledgeImmediatelyLabelIsHidden: Signal<Bool, Never>
  /// Emits whether the Submit button is enabled.
  public let submitButtonIsEnabled: Signal<Bool, Never>
  /// Emits the localized Submit button title.
  public let submitButtonTitle: Signal<String, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgeViewCTAContainerViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgeViewCTAContainerViewModelOutputs { return self }
}
