import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// Inputs for `CreditCardCellViewModel`.
public protocol CreditCardCellViewModelInputs {
  /// Call to configure cell with card value.
  func configureWith(creditCard: UserCreditCards.CreditCard)
}

/// Outputs for `CreditCardCellViewModel`.
public protocol CreditCardCellViewModelOutputs {
  /// Emits the card's image.
  var cardImage: Signal<UIImage?, Never> { get }

  /// Emits a formatted accessibility string containing the card type, number and last four digits
  var cardNumberAccessibilityLabel: Signal<String, Never> { get }

  /// Emits a formatted string containing the card's last four digits with the format: Card ending in 8844.
  var cardNumberTextLongStyle: Signal<String, Never> { get }

  /// Emits the formatted card's expirationdate.
  var expirationDateText: Signal<String, Never> { get }
}

/// Type interface for `CreditCardCellViewModel`.
public protocol CreditCardCellViewModelType {
  /// View model inputs.
  var inputs: CreditCardCellViewModelInputs { get }
  /// View model outputs.
  var outputs: CreditCardCellViewModelOutputs { get }
}

/// View model formatting a saved credit card's icon, masked digits, expiration, and VoiceOver label.
public final class CreditCardCellViewModel: CreditCardCellViewModelInputs,
  CreditCardCellViewModelOutputs, CreditCardCellViewModelType {
  /// Initializes the credit card cell view model and binds display signals.
  public init() {
    self.cardImage = self.cardProperty.signal.skipNil()
      .map(cardImageForCard)

    self.cardNumberAccessibilityLabel = self.cardProperty.signal.skipNil()
      .map {
        [$0.type?.description, Strings.Card_ending_in_last_four(last_four: $0.lastFour)]
          .compact()
          .joined(separator: ", ")
      }

    self.cardNumberTextLongStyle = self.cardProperty.signal.skipNil()
      .map { Strings.Card_ending_in_last_four(last_four: $0.lastFour) }

    self.expirationDateText = self.cardProperty.signal.skipNil()
      .map { Strings.Credit_card_expiration(expiration_date: $0.expirationDate()) }
  }

  fileprivate let cardProperty = MutableProperty<UserCreditCards.CreditCard?>(nil)
  /// Configures the cell with the saved credit card model.
  public func configureWith(creditCard: UserCreditCards.CreditCard) {
    self.cardProperty.value = creditCard
  }

  /// Emits the card brand icon image.
  public let cardImage: Signal<UIImage?, Never>
  /// Emits the localized VoiceOver description of the card brand and last four digits.
  public let cardNumberAccessibilityLabel: Signal<String, Never>
  /// Emits the formatted "Card ending in XXXX" label.
  public let cardNumberTextLongStyle: Signal<String, Never>
  /// Emits the localized card expiration date string.
  public let expirationDateText: Signal<String, Never>

  /// View model inputs.
  public var inputs: CreditCardCellViewModelInputs { return self }
  /// View model outputs.
  public var outputs: CreditCardCellViewModelOutputs { return self }
}

private func cardImageForCard(_ card: UserCreditCards.CreditCard) -> UIImage? {
  return image(named: card.imageName)
}
