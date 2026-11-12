import GraphAPI
import KsApi
import Prelude
import ReactiveSwift
import StripePaymentSheet
import UIKit

/// Immutable value type representing `PledgePaymentMethodsSetupOutputs`.
internal struct PledgePaymentMethodsSetupOutputs {
  let reloadPaymentMethods: Signal<PledgePaymentMethodsAndSelectionData, Never>
  let updatedCards: Signal<PledgePaymentMethodsAndSelectionData, Never>
  let createSetupIntentEvent: Signal<Signal<PaymentSheetSetupData, ErrorEnvelope>.Event, Never>
  let storedCardsErrors: Signal<ErrorEnvelope, Never>
  let newlyAddedCardErrors: Signal<ErrorEnvelope, Never>
  let showLoadingIndicator: Signal<Bool, Never>
}

internal func makePledgePaymentMethodsSignals(
  configureWithValue: Signal<PledgePaymentMethodsValue, Never>,
  newStripeIntentCreditCardSignal: Signal<(String, String?), Never>,
  didSelectRowAtIndexPathSignal: Signal<IndexPath, Never>,
  stripeIntentService: StripeIntentServiceType
) -> PledgePaymentMethodsSetupOutputs {
  let project = configureWithValue.map(\.project)
  let context = configureWithValue.map(\.context)
  let checkoutId = configureWithValue.map(\.checkoutId)
  let availableCardTypes = project.map(\.availableCardTypes).skipNil()
  let backing = configureWithValue.map(\.project.personalization.backing)

  let storedCardsEvent = configureWithValue
    .switchMap { _ in
      AppEnvironment.current.apiService
        .fetchGraphUser(withStoredCards: true)
        .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler)
        .map { envelope in (envelope, false) }
        .prefix(value: (nil, true))
        .materialize()
    }

  let storedCardsValues = storedCardsEvent.values()
    .filter(second >>> isFalse)
    .map(first)
    .skipNil()
    .map { $0.me.storedCards.storedCards }

  let storedCards = Signal.combineLatest(storedCardsValues, backing)
    .map(cards(_:orderedBy:))

  let newlyAddedCardProducer = newStripeIntentCreditCardSignal
    .switchMap { setupIntent, paymentMethodId -> SignalProducer<
      Signal<UserCreditCards.CreditCard, ErrorEnvelope>.Event,
      Never
    > in
      let input = CreatePaymentSourceSetupIntentInput(intentClientSecret: setupIntent, reuseable: true)
      return AppEnvironment.current.apiService.addPaymentSheetPaymentSource(input: input)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .map { (envelope: CreatePaymentSourceEnvelope) -> UserCreditCards.CreditCard? in
          guard envelope.createPaymentSource.isSuccessful else { return nil }
          var card = envelope.createPaymentSource.paymentSource
          if card.stripeCardId == nil {
            card.stripeCardId = paymentMethodId
          }
          return card
        }
        .skipNil()
        .materialize()
    }

  let allNewlyAddedCards: Signal<[UserCreditCards.CreditCard], Never> = newlyAddedCardProducer.values()
    .scan(into: []) { array, card in
      array.insert(card, at: 0)
    }

  let newCardsData = Signal.combineLatest(allNewlyAddedCards, availableCardTypes, project)
    .map { args -> ([PledgePaymentMethodCellData], UserCreditCards.CreditCard?) in
      let (cards, availableCardTypes, project) = args
      return pledgePaymentMethodCellDataAndSelectedCard(
        with: cards,
        availableCardTypes: availableCardTypes,
        project: project,
        newCardAdded: true
      )
    }

  let initialCardData = Signal.combineLatest(storedCards, availableCardTypes, project)
    .map { args in (args.0, args.1, args.2, false) }

  let reloadWithLoadingCell: Signal<PledgePaymentMethodsAndSelectionData, Never> = storedCardsEvent.values()
    .filter(second >>> isTrue)
    .map { _ in
      PledgePaymentMethodsAndSelectionData(
        existingPaymentMethods: [],
        newPaymentMethods: [],
        selectedPaymentMethod: nil,
        isLoading: true,
        shouldReload: true
      )
    }

  let configuredCards: Signal<PledgePaymentMethodsAndSelectionData, Never> = initialCardData
    .map(pledgePaymentMethodCellDataAndSelectedCard)
    .map { args in
      let (cellData, selectedCard) = args
      return PledgePaymentMethodsAndSelectionData(
        existingPaymentMethods: cellData,
        newPaymentMethods: [],
        selectedPaymentMethod: selectedCard.map(createSelectedPaymentMethod(from:)),
        isLoading: false,
        shouldReload: true
      )
    }

  let configuredCardsWithNewSetupIntentCards = configuredCards
    .takePairWhen(newCardsData)
    .map { args -> PledgePaymentMethodsAndSelectionData in
      let (cards, setupIntentCards) = args
      var updatedCardData = cards
      updatedCardData.newPaymentMethods = setupIntentCards.0
      if let selectedCard = setupIntentCards.1 {
        updatedCardData.selectedPaymentMethod = createSelectedPaymentMethod(from: selectedCard)
      }
      return pledgePaymentSheetMethodCellDataAndSelectedCardSetupIntent(with: updatedCardData)
    }

  let updatedCardsWithNewSetupIntentCards = Signal.merge(
    configuredCards,
    configuredCardsWithNewSetupIntentCards
  )
  .map { data in
    var updated = data
    updated.isLoading = false
    updated.shouldReload = false
    return updated
  }

  let updatedCards = updatedCardsWithNewSetupIntentCards
    .takePairWhen(didSelectRowAtIndexPathSignal)
    .filter { _, indexPath in indexPath.section == PaymentMethodsTableViewSection.paymentMethods.rawValue }
    .compactMap { data, indexPath in makeUpdatedPaymentMethodsSelection(from: data, selecting: indexPath) }

  let reloadPaymentMethods = Signal.merge(
    reloadWithLoadingCell,
    configuredCards,
    configuredCardsWithNewSetupIntentCards,
    updatedCards
  )

  let didTapToAddNewCard = didSelectRowAtIndexPathSignal
    .filter { $0.section == PaymentMethodsTableViewSection.addNewCard.rawValue }

  let showLoadingIndicator = Signal.combineLatest(project, context.mapConst(true).filter(isTrue))
    .takeWhen(didTapToAddNewCard)
    .mapConst(true)

  let createSetupIntentEvent = Signal.combineLatest(project, checkoutId, context)
    .takeWhen(didTapToAddNewCard)
    .switchMap { project, _, pledgeContext -> SignalProducer<
      Signal<PaymentSheetSetupData, ErrorEnvelope>.Event,
      Never
    > in
      let setupIntentContext = pledgeContext == .latePledge
        ? GraphAPI.StripeIntentContextTypes.postCampaignCheckout
        : GraphAPI.StripeIntentContextTypes.crowdfundingCheckout

      return stripeIntentService.createSetupIntent(for: project.graphID, context: setupIntentContext)
        .map(\.clientSecret)
        .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .switchMap { clientSecret -> SignalProducer<PaymentSheetSetupData, ErrorEnvelope> in
          var configuration = PaymentSheet.Configuration()
          configuration.merchantDisplayName = Strings.general_accessibility_kickstarter()
          configuration.allowsDelayedPaymentMethods = true
          configuration.defaultBillingDetails.email = AppEnvironment.current.currentUserEmail
          return SignalProducer(value: PaymentSheetSetupData(clientSecret: clientSecret, configuration: configuration))
        }
        .materialize()
    }

  return PledgePaymentMethodsSetupOutputs(
    reloadPaymentMethods: reloadPaymentMethods,
    updatedCards: updatedCards,
    createSetupIntentEvent: createSetupIntentEvent,
    storedCardsErrors: storedCardsEvent.errors(),
    newlyAddedCardErrors: newlyAddedCardProducer.errors(),
    showLoadingIndicator: showLoadingIndicator
  )
}
