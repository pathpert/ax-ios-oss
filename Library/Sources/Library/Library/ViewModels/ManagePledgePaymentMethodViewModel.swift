import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Display model summarizing the payment method associated with an existing backing.
public struct ManagePledgePaymentMethodViewData: Equatable {
  /// Whether to show the "Fix payment method" action button.
  public let showFixPaymentButton: Bool
  /// Raw card expiration date string from the API (`yyyy-MM-dd`).
  public let expirationDate: String?
  /// Last four digits of the card, if applicable.
  public let lastFour: String?
  /// Credit card network type, if applicable.
  public let creditCardType: CreditCardType?
  /// Payment method category (credit card, Apple Pay, Google Pay, or bank account).
  public let paymentType: PaymentType?
}

/// Inputs accepted by `ManagePledgePaymentMethodViewModel`.
public protocol ManagePledgePaymentMethodViewModelInputs {
  /// Call to configure payment method section the values from a backing
  func configureWith(data: ManagePledgePaymentMethodViewData)

  /// Call when the "Fix" button is tapped
  func fixButtonTapped()
}

/// Outputs exposed by `ManagePledgePaymentMethodViewModel`.
public protocol ManagePledgePaymentMethodViewModelOutputs {
  /// Emits the card's image.
  var cardImageName: Signal<String, Never> { get }

  /// Emits a formatted accessibility string containing the card type, number and last four digits
  var cardNumberAccessibilityLabel: Signal<String, Never> { get }

  /// Emits a formatted string containing the card's last four digits with the format: Ending in 8844.
  var cardNumberTextShortStyle: Signal<String, Never> { get }

  /// Emits the formatted card's expirationdate.
  var expirationDateText: Signal<String, Never> { get }

  /// Emits whether the Fix button is hidden
  var fixButtonHidden: Signal<Bool, Never> { get }

  /// Emits when the fix button was tapped
  var notifyDelegateFixButtonTapped: Signal<Void, Never> { get }
}

/// Combined inputs and outputs interface for `ManagePledgePaymentMethodViewModel`.
public protocol ManagePledgePaymentMethodViewModelType {
  /// The view model's inputs.
  var inputs: ManagePledgePaymentMethodViewModelInputs { get }
  /// The view model's outputs.
  var outputs: ManagePledgePaymentMethodViewModelOutputs { get }
}

/// View model formatting payment method details and fix-payment actions in Manage Pledge.
public final class ManagePledgePaymentMethodViewModel: ManagePledgePaymentMethodViewModelInputs,
  ManagePledgePaymentMethodViewModelOutputs, ManagePledgePaymentMethodViewModelType {
  /// Creates a new `ManagePledgePaymentMethodViewModel`.
  public init() {
    self.cardImageName = self.configureWithDataSignal
      .map { ($0.paymentType, $0.creditCardType) }
      .map(imageName(for:creditCardType:))
      .skipNil()

    let paymentType = self.configureWithDataSignal
      .map(\.paymentType)

    let cardType = self.configureWithDataSignal
      .map(\.creditCardType)

    let lastFour = self.configureWithDataSignal
      .map(\.lastFour)

    self.cardNumberAccessibilityLabel = Signal.combineLatest(
      paymentType,
      cardType,
      lastFour
    )
    .map(paymentMethodAccessibilityLabel)

    self.cardNumberTextShortStyle = lastFour
      .skipNil()
      .map { Strings.Ending_in_last_four(last_four: $0) }

    self.expirationDateText = self.configureWithDataSignal
      .map(\.expirationDate)
      .skipNil()
      .map { String($0.dropLast(3)) }
      .map(formatted(dateString:))
      .map { Strings.Credit_card_expiration(expiration_date: $0) }

    self.fixButtonHidden = self.configureWithDataSignal
      .map { !$0.showFixPaymentButton }

    self.notifyDelegateFixButtonTapped = self.fixButtonTappedSignal
  }

  fileprivate let (configureWithDataSignal, configureWithDataObserver)
    = Signal<ManagePledgePaymentMethodViewData, Never>.pipe()
  /// Configures the payment method card section with backing payment metadata.
  public func configureWith(data: ManagePledgePaymentMethodViewData) {
    self.configureWithDataObserver.send(value: data)
  }

  fileprivate let (fixButtonTappedSignal, fixButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Notifies the delegate that the user tapped the Fix Payment Method button.
  public func fixButtonTapped() {
    self.fixButtonTappedObserver.send(value: ())
  }

  /// Emits the asset name for the payment method icon.
  public let cardImageName: Signal<String, Never>
  /// Emits the VoiceOver accessibility label describing the payment method.
  public let cardNumberAccessibilityLabel: Signal<String, Never>
  /// Emits the short masked card number label (e.g., `"Ending in 8844"`).
  public let cardNumberTextShortStyle: Signal<String, Never>
  /// Emits the formatted expiration date string.
  public let expirationDateText: Signal<String, Never>
  /// Emits whether the Fix Payment button should be hidden.
  public let fixButtonHidden: Signal<Bool, Never>
  /// Emits when the user taps the Fix Payment button.
  public let notifyDelegateFixButtonTapped: Signal<Void, Never>

  /// The inputs interface for this view model.
  public var inputs: ManagePledgePaymentMethodViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: ManagePledgePaymentMethodViewModelOutputs { return self }
}

private func imageName(for paymentType: PaymentType?, creditCardType: CreditCardType?) -> String? {
  switch paymentType {
  case .creditCard:
    return creditCardType?.imageName
  case .applePay:
    return "icon--apple-pay"
  case .googlePay:
    return "icon--google-pay"
  case .bankAccount:
    return "icon--credit-card"
  case nil:
    return nil
  }
}

private func paymentMethodAccessibilityLabel(
  for paymentType: PaymentType?,
  cardType: CreditCardType?,
  lastFour: String?
) -> String {
  let paymentTypeDescription = paymentType.flatMap { paymentType in
    switch paymentType {
    case .applePay:
      return Strings.accessibility_payment_types_apple_pay()
    case .googlePay:
      return Strings.accessibility_payment_types_google_pay()
    case .bankAccount:
      return Strings.accessibility_payment_types_bank_account()
    case .creditCard:
      return nil
    }
  }

  let lastFourDescription = lastFour.map(Strings.Card_ending_in_last_four)

  return [paymentTypeDescription, cardType?.description, lastFourDescription]
    .compact()
    .joined(separator: ", ")
}

private func formatted(dateString: String) -> String {
  let date = toDate(dateString: dateString)
  return Format.date(
    secondsInUTC: date.timeIntervalSince1970,
    template: "MM-yyyy",
    timeZone: UTCTimeZone
  )
}

private func toDate(dateString: String) -> Date {
  // Always use UTC timezone here this date should be timezone agnostic
  guard let date = Format.date(
    from: dateString,
    dateFormat: "yyyy-MM",
    timeZone: UTCTimeZone
  ) else {
    fatalError("Unable to parse date format")
  }

  return date
}
