import KDS
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// Display and selection state payload for a single saved credit card row in the pledge payment methods list.
///
/// Negative Constraint: `isEnabled` is `false` for card brands unsupported by `projectCountry`; do not allow selecting rows where `isEnabled == false`.
public struct PledgePaymentMethodCellData: Equatable {
  /// Saved credit card model represented by the row.
  public let card: UserCreditCards.CreditCard
  /// Whether this card brand is supported for the project's country.
  public let isEnabled: Bool
  /// Whether this row is currently selected as the active payment method.
  public var isSelected: Bool
  /// Project country display name shown when explaining why a card is unavailable.
  public let projectCountry: String
  /// Whether this card matches an errored backing payment source requiring retry.
  public let isErroredPaymentMethod: Bool

  /// Creates a `PledgePaymentMethodCellData` contract.
  public init(
    card: UserCreditCards.CreditCard,
    isEnabled: Bool,
    isSelected: Bool,
    projectCountry: String,
    isErroredPaymentMethod: Bool
  ) {
    self.card = card
    self.isEnabled = isEnabled
    self.isSelected = isSelected
    self.projectCountry = projectCountry
    self.isErroredPaymentMethod = isErroredPaymentMethod
  }
}

/// Inputs accepted by `PledgePaymentMethodCellViewModel`.
public protocol PledgePaymentMethodCellViewModelInputs {
  /// Call to configure cell with card and selected card values.
  func configureWith(value: PledgePaymentMethodCellData)

  /// Call with the currently selected card.
  func setSelectedCardId(_ id: String)
}

/// Outputs exposed by `PledgePaymentMethodCellViewModel`.
public protocol PledgePaymentMethodCellViewModelOutputs {
  /// Emits the alpha for the card image
  var cardImageAlpha: Signal<CGFloat, Never> { get }

  /// Emits the card's image name.
  var cardImageName: Signal<String, Never> { get }

  /// Emits a formatted accessibility string containing the card type, number and last four digits
  var cardNumberAccessibilityLabel: Signal<String, Never> { get }

  /// Emits a formatted string containing the card's last four digits.
  var cardNumberTextShortStyle: Signal<String, Never> { get }

  /// Emits when the checkmark image should be hidden.
  var checkmarkImageHidden: Signal<Bool, Never> { get }

  /// Emits the checkmark image.
  var checkmarkImageName: Signal<String, Never> { get }

  /// Emits the formatted card's expirationdate.
  var expirationDateText: Signal<String, Never> { get }

  /// Emits the text color for the last four digits label.
  var lastFourLabelTextColor: Signal<UIColor, Never> { get }

  /// Emits the selection cell's selection style.
  var selectionStyle: Signal<UITableViewCell.SelectionStyle, Never> { get }

  /// Emits whether or not the unavailable card type label should be hidden.
  var unavailableCardLabelHidden: Signal<Bool, Never> { get }

  /// Emits a string explaining why card type is unavailable.
  var unavailableCardText: Signal<String, Never> { get }
}

/// Combined inputs and outputs interface for `PledgePaymentMethodCellViewModel`.
public protocol PledgePaymentMethodCellViewModelType {
  /// The view model's inputs.
  var inputs: PledgePaymentMethodCellViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgePaymentMethodCellViewModelOutputs { get }
}

/// View model formatting a saved credit card row in the pledge checkout payment method list.
public final class PledgePaymentMethodCellViewModel: PledgePaymentMethodCellViewModelInputs,
  PledgePaymentMethodCellViewModelOutputs, PledgePaymentMethodCellViewModelType {
  /// Creates a new `PledgePaymentMethodCellViewModel`.
  public init() {
    let creditCard = self.configureValueProperty.signal.skipNil().map(\.card)
    let selectedCardId = self.selectedCardIdProperty.signal.skipNil()
    let cardTypeIsAvailable = self.configureValueProperty.signal.skipNil().map(\.isEnabled)
    let configuredAsSelected = self.configureValueProperty.signal.skipNil().map(\.isSelected)

    self.cardImageName = creditCard
      .map { $0.imageName }

    self.cardNumberAccessibilityLabel = creditCard
      .map {
        [$0.type?.description, Strings.Card_ending_in_last_four(last_four: $0.lastFour)]
          .compact()
          .joined(separator: ", ")
      }

    let redactedCardNumber = creditCard
      .map { "•••• \($0.lastFour)" }

    self.cardNumberTextShortStyle = redactedCardNumber

    let creditCardExpiryDate = creditCard
      .map { Strings.Credit_card_expiration(expiration_date: $0.expirationDate()) }

    self.expirationDateText = creditCardExpiryDate

    let cardAndSelectedCard = Signal.combineLatest(
      creditCard,
      selectedCardId
    )

    let setAsSelected = cardAndSelectedCard.map { card, id in
      card.id == id
    }

    let creditCardCheckImageName = Signal.merge(configuredAsSelected, setAsSelected)
      .map { $0 ? "icon-payment-method-selected" : "icon-payment-method-unselected" }

    self.checkmarkImageName = creditCardCheckImageName

    self.unavailableCardLabelHidden = self.configureValueProperty.signal.skipNil()
      .map { card in !card.isEnabled || card.isErroredPaymentMethod }.negate()

    self.unavailableCardText = self.configureValueProperty.signal.skipNil()
      .filter { card in !card.isEnabled || card.isErroredPaymentMethod }
      .map { card -> String in
        if !card.isEnabled {
          return Strings.You_cant_use_this_credit_card_to_back_a_project_from_project_country(
            project_country: card.projectCountry
          )
        }

        return Strings.Retry_or_select_another_method()
      }

    self.selectionStyle = cardTypeIsAvailable.map {
      $0 ? UITableViewCell.SelectionStyle.default : .none
    }

    self.cardImageAlpha = cardTypeIsAvailable.map {
      $0 ? 1.0 : 0.5
    }

    self.checkmarkImageHidden = cardTypeIsAvailable.negate()

    self.lastFourLabelTextColor = cardTypeIsAvailable.map { cardTypeIsAvailable in
      cardTypeIsAvailable ? LegacyColors.ksr_support_700.uiColor() : LegacyColors.ksr_support_400.uiColor()
    }
  }

  fileprivate let configureValueProperty = MutableProperty<PledgePaymentMethodCellData?>(nil)
  /// Configures the cell with saved card details and availability state.
  public func configureWith(value: PledgePaymentMethodCellData) {
    self.configureValueProperty.value = value
  }

  private let selectedCardIdProperty = MutableProperty<String?>(nil)
  /// Updates selection state based on the currently selected card ID.
  public func setSelectedCardId(_ id: String) {
    self.selectedCardIdProperty.value = id
  }

  /// Emits the opacity of the card brand icon.
  public let cardImageAlpha: Signal<CGFloat, Never>
  /// Emits the card brand asset name.
  public let cardImageName: Signal<String, Never>
  /// Emits the VoiceOver accessibility label describing card type and last four digits.
  public let cardNumberAccessibilityLabel: Signal<String, Never>
  /// Emits the masked last-four string (e.g., `"•••• 4242"`).
  public let cardNumberTextShortStyle: Signal<String, Never>
  /// Emits whether the checkmark icon is hidden.
  public let checkmarkImageHidden: Signal<Bool, Never>
  /// Emits the asset name for the selection checkmark icon.
  public let checkmarkImageName: Signal<String, Never>
  /// Emits the formatted expiration date label text.
  public let expirationDateText: Signal<String, Never>
  /// Emits the text color for the card number label.
  public let lastFourLabelTextColor: Signal<UIColor, Never>
  /// Emits the cell selection style (`default` when enabled, `.none` when disabled).
  public let selectionStyle: Signal<UITableViewCell.SelectionStyle, Never>
  /// Emits whether the unavailable/retry reason label should be hidden.
  public let unavailableCardLabelHidden: Signal<Bool, Never>
  /// Emits the explanation copy when a card is unavailable or errored.
  public let unavailableCardText: Signal<String, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgePaymentMethodCellViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgePaymentMethodCellViewModelOutputs { return self }
}
