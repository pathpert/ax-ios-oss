import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Configuration payload describing the active pledge to be canceled.
public struct CancelPledgeViewData {
  /// Backed project associated with the pledge.
  public let project: Project // TODO: remove once tracking is updated.
  /// Project display name interpolated into confirmation copy.
  public let projectName: String
  /// `true` to omit trailing `"US"` on USD currency strings.
  public let omitUSCurrencyCode: Bool
  /// Relay GraphQL identifier of the backing being canceled.
  public let backingId: String
  /// Current total pledge amount in project currency units.
  public let pledgeAmount: Double
}

/// Inputs accepted by `CancelPledgeViewModel`.
public protocol CancelPledgeViewModelInputs {
  /// Triggers backing cancellation using the entered optional note.
  func cancelPledgeButtonTapped()
  /// Supplies pledge and project context prior to display.
  func configure(with data: CancelPledgeViewData)
  /// Dismisses cancellation screen via back navigation.
  func goBackButtonTapped()
  /// Records optional cancellation feedback text entered by the backer.
  func textFieldDidEndEditing(with text: String?)
  /// Handles keyboard return press on the note field.
  func textFieldShouldReturn()
  /// Recomputes dynamic type attributed confirmation copy when traits change.
  func traitCollectionDidChange()
  /// Notifies the view model that the view finished loading.
  func viewDidLoad()
  /// Handles background tap to dismiss the software keyboard.
  func viewTapped()
}

/// Reactive outputs emitted by `CancelPledgeViewModel`.
public protocol CancelPledgeViewModelOutputs {
  /// Emits attributed confirmation prompt containing bolded pledge amount and project name.
  var cancellationDetailsAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the confirm-cancellation button is enabled.
  var cancelPledgeButtonEnabled: Signal<Bool, Never> { get }
  /// Emits localized API error copy when cancellation fails.
  var cancelPledgeError: Signal<String, Never> { get }
  /// Emits when the keyboard should be dismissed.
  var dismissKeyboard: Signal<Void, Never> { get }
  /// Emits loading state while the cancellation mutation is in flight.
  var isLoading: Signal<Bool, Never> { get }
  /// Emits localized confirmation banner message when cancellation succeeds.
  var notifyDelegateCancelPledgeSuccess: Signal<String, Never> { get }
  /// Emits when the navigation controller should pop back to Manage Pledge.
  var popCancelPledgeViewController: Signal<Void, Never> { get }
}

/// Combined inputs/outputs contract for canceling an active pledge.
public protocol CancelPledgeViewModelType {
  /// Input receiver.
  var inputs: CancelPledgeViewModelInputs { get }
  /// Output signal provider.
  var outputs: CancelPledgeViewModelOutputs { get }
}

/// View model managing confirmation copy, optional reason text, and the cancel-backing API mutation.
public final class CancelPledgeViewModel: CancelPledgeViewModelType, CancelPledgeViewModelInputs,
  CancelPledgeViewModelOutputs {
  /// Creates a new `CancelPledgeViewModel`.
  public init() {
    let data = Signal.combineLatest(
      self.configureWithDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    self.cancellationDetailsAttributedText = Signal.merge(
      data,
      data.takeWhen(self.traitCollectionDidChangeProperty.signal)
    )
    .map { data in

      let formattedAmount = Format.currency(
        data.pledgeAmount,
        currencyCode: data.project.statsCurrency,
        omitCurrencyCode: data.omitUSCurrencyCode
      )
      return (formattedAmount, data.projectName)
    }
    .map(createCancellationDetailsAttributedText(with:projectName:))

    self.popCancelPledgeViewController = self.goBackButtonTappedProperty.signal

    self.dismissKeyboard = Signal.merge(
      self.textFieldShouldReturnProperty.signal,
      self.viewTappedProperty.signal
    )

    let cancellationNote = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst(nil),
      self.textFieldDidEndEditingTextProperty.signal
    )

    let cancelPledgeSubmit = Signal.combineLatest(
      data.map { $0.backingId },
      cancellationNote
    )
    .takeWhen(self.cancelPledgeButtonTappedProperty.signal)

    let cancelPledgeEvent = cancelPledgeSubmit
      .map(CancelBackingInput.init(backingId:cancellationReason:))
      .switchMap { input in
        AppEnvironment.current.apiService.cancelBacking(input: input)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.isLoading = Signal.merge(
      self.cancelPledgeButtonTappedProperty.signal.mapConst(true),
      cancelPledgeEvent.filter { $0.isTerminating }.mapConst(false)
    )

    self.notifyDelegateCancelPledgeSuccess = cancelPledgeEvent.values()
      .map { _ in Strings.Youve_canceled_your_pledge() }

    self.cancelPledgeError = cancelPledgeEvent
      .errors()
      .map { $0.localizedDescription }

    self.cancelPledgeButtonEnabled = Signal.merge(
      data.mapConst(true),
      cancelPledgeSubmit.mapConst(false),
      cancelPledgeEvent.map { $0.isTerminating }.mapConst(true)
    )
    .skipRepeats()
  }

  private let cancelPledgeButtonTappedProperty = MutableProperty(())
  /// Submits the cancel-backing mutation.
  public func cancelPledgeButtonTapped() {
    self.cancelPledgeButtonTappedProperty.value = ()
  }

  private let configureWithDataProperty = MutableProperty<CancelPledgeViewData?>(nil)
  /// Configures the view model with backing and project details.
  public func configure(with data: CancelPledgeViewData) {
    self.configureWithDataProperty.value = data
  }

  private let goBackButtonTappedProperty = MutableProperty(())
  /// Dismisses cancellation flow without mutating the backing.
  public func goBackButtonTapped() {
    self.goBackButtonTappedProperty.value = ()
  }

  private let textFieldDidEndEditingTextProperty = MutableProperty<String?>(nil)
  /// Stores optional cancellation reason text.
  public func textFieldDidEndEditing(with text: String?) {
    self.textFieldDidEndEditingTextProperty.value = text
  }

  private let textFieldShouldReturnProperty = MutableProperty(())
  /// Requests keyboard dismissal on return key.
  public func textFieldShouldReturn() {
    self.textFieldShouldReturnProperty.value = ()
  }

  private let traitCollectionDidChangeProperty = MutableProperty(())
  /// Refreshes typography when trait collection changes.
  public func traitCollectionDidChange() {
    self.traitCollectionDidChangeProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let viewTappedProperty = MutableProperty(())
  /// Requests keyboard dismissal on background tap.
  public func viewTapped() {
    self.viewTappedProperty.value = ()
  }

  /// Emits attributed confirmation prompt containing bolded pledge amount and project name.
  public let cancellationDetailsAttributedText: Signal<NSAttributedString, Never>
  /// Emits whether the confirm-cancellation button is enabled.
  public let cancelPledgeButtonEnabled: Signal<Bool, Never>
  /// Emits localized API error copy when cancellation fails.
  public let cancelPledgeError: Signal<String, Never>
  /// Emits when the keyboard should be dismissed.
  public let dismissKeyboard: Signal<Void, Never>
  /// Emits loading state while the cancellation mutation is in flight.
  public let isLoading: Signal<Bool, Never>
  /// Emits localized confirmation banner message when cancellation succeeds.
  public let notifyDelegateCancelPledgeSuccess: Signal<String, Never>
  /// Emits when the navigation controller should pop back to Manage Pledge.
  public let popCancelPledgeViewController: Signal<Void, Never>

  /// Inputs receiver (`self`).
  public var inputs: CancelPledgeViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: CancelPledgeViewModelOutputs { return self }
}

private func createCancellationDetailsAttributedText(with amount: String, projectName: String)
  -> NSAttributedString {
  let fullString = Strings
    .Are_you_sure_you_wish_to_cancel_your_amount_pledge_to_project_name(
      amount: amount,
      project_name: projectName
    )
  let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: fullString)
  let regularFontAttribute = [NSAttributedString.Key.font: UIFont.ksr_callout()]
  let boldFontAttribute = [NSAttributedString.Key.font: UIFont.ksr_callout().bolded]
  let fullRange = (fullString as NSString).localizedStandardRange(of: fullString)
  let rangeAmount: NSRange = (fullString as NSString).localizedStandardRange(of: amount)
  let rangeProjectName: NSRange = (fullString as NSString).localizedStandardRange(of: projectName)

  attributedString.addAttributes(regularFontAttribute, range: fullRange)
  attributedString.addAttributes(boldFontAttribute, range: rangeAmount)
  attributedString.addAttributes(boldFontAttribute, range: rangeProjectName)

  return attributedString
}
