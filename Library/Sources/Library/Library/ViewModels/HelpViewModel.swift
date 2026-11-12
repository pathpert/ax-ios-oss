import MessageUI
import Prelude
import ReactiveSwift

/// Screen context from which help and support actions are presented.
public enum HelpContext {
  /// Presented from the login tout screen.
  case loginTout
  /// Presented from the Facebook account confirmation screen.
  case facebookConfirmation
  /// Presented from account settings.
  case settings
  /// Presented from the signup flow.
  case signup

  /// Analytics event string representing this help context.
  public var trackingString: String {
    switch self {
    case .loginTout:
      return "Login Tout"
    case .facebookConfirmation:
      return "Facebook Confirmation"
    case .settings:
      return "Settings"
    case .signup:
      return "Signup"
    }
  }
}

/// Input events handled by `HelpViewModel`.
public protocol HelpViewModelInputs {
  /// Call to set whether Mail can be composed.
  func canSendEmail(_ canSend: Bool)

  /// Call to configure with HelpContext.
  func configureWith(helpContext: HelpContext)

  /// Call when a help button is tapped.
  func helpTypeButtonTapped(_ helpType: HelpType)

  /// Call when mail compose view controller has closed with a result.
  func mailComposeCompletion(result: MFMailComposeResult)

  /// Call when to show the help sheet from a button tap.
  func showHelpSheetButtonTapped()
}

/// Output signals exposed by `HelpViewModel`.
public protocol HelpViewModelOutputs {
  /// Emits to show an alert when Mail is not available.
  var showNoEmailError: Signal<UIAlertController, Never> { get }

  /// Emits when to show the help actionsheet.
  var showHelpSheet: Signal<[HelpType], Never> { get }

  /// Emits when to show a MFMailComposeViewController to contact support.
  var showMailCompose: Signal<(), Never> { get }

  /// Emits when to show a WebViewController with a HelpType.
  var showWebHelp: Signal<HelpType, Never> { get }
}

/// Interface combining inputs and outputs for `HelpViewModel`.
public protocol HelpViewModelType {
  /// Input receiver for help sheet and link actions.
  var inputs: HelpViewModelInputs { get }
  /// Output signals presenting help sheets, web help, and mail composers.
  var outputs: HelpViewModelOutputs { get }
}

/// View model routing help menu options to email support, action sheets, and web help pages.
public final class HelpViewModel: HelpViewModelType, HelpViewModelInputs, HelpViewModelOutputs {
  /// Initializes the help view model.
  public init() {
    let canSendEmail = self.canSendEmailProperty.signal.skipNil()
    let helpTypeTapped = self.helpTypeButtonTappedProperty.signal.skipNil()

    self.showMailCompose = canSendEmail
      .takePairWhen(helpTypeTapped)
      .filter { canSend, type in type == .contact && canSend }
      .ignoreValues()

    self.showNoEmailError = canSendEmail
      .takePairWhen(helpTypeTapped)
      .filter { canSend, type in type == .contact && !canSend }
      .map { _ in noEmailError() }

    self.showWebHelp = helpTypeTapped
      .filter { $0 != .contact }

    self.showHelpSheet = self.showHelpSheetButtonTappedProperty.signal
      .mapConst([HelpType.howItWorks, .contact, .terms, .privacy, .cookie])
  }

  /// Returns `self` as `HelpViewModelInputs`.
  public var inputs: HelpViewModelInputs { return self }
  /// Returns `self` as `HelpViewModelOutputs`.
  public var outputs: HelpViewModelOutputs { return self }

  /// Emits an error alert controller when email composition is unavailable.
  public let showNoEmailError: Signal<UIAlertController, Never>
  /// Emits available `HelpType` actions when displaying the help action sheet.
  public let showHelpSheet: Signal<[HelpType], Never>
  /// Emits when the system mail compose sheet should appear.
  public let showMailCompose: Signal<(), Never>
  /// Emits the selected `HelpType` for non-contact web help topics.
  public let showWebHelp: Signal<HelpType, Never>

  fileprivate let canSendEmailProperty = MutableProperty<Bool?>(nil)
  /// Configures whether the device can send support emails.
  public func canSendEmail(_ canSend: Bool) {
    self.canSendEmailProperty.value = canSend
  }

  fileprivate let helpContextProperty = MutableProperty<HelpContext?>(nil)
  /// Configures the analytics context in which help was opened.
  public func configureWith(helpContext: HelpContext) {
    self.helpContextProperty.value = helpContext
  }

  fileprivate let showHelpSheetButtonTappedProperty = MutableProperty(())
  /// Signals that the user tapped the button to open the help options sheet.
  public func showHelpSheetButtonTapped() {
    self.showHelpSheetButtonTappedProperty.value = ()
  }

  fileprivate let helpTypeButtonTappedProperty = MutableProperty<HelpType?>(nil)
  /// Handles selecting a specific `HelpType` topic.
  public func helpTypeButtonTapped(_ helpType: HelpType) {
    self.helpTypeButtonTappedProperty.value = helpType
  }

  fileprivate let mailComposeCompletionProperty = MutableProperty<MFMailComposeResult?>(nil)
  /// Records completion of the mail compose sheet.
  public func mailComposeCompletion(result: MFMailComposeResult) {
    self.mailComposeCompletionProperty.value = result
  }
}

private func noEmailError() -> UIAlertController {
  let alertController = UIAlertController(
    title: Strings.support_email_noemail_title(),
    message: Strings.support_email_noemail_message(),
    preferredStyle: .alert
  )
  alertController.addAction(
    UIAlertAction(
      title: Strings.general_alert_buttons_ok(),
      style: .cancel,
      handler: nil
    )
  )

  return alertController
}
