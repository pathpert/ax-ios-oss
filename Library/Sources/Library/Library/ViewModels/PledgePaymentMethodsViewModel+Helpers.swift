import KsApi
import ReactiveSwift
import UIKit

/// Helper definitions for `pledgePaymentSheetMethodCellDataAndSelectedCardSetupIntent` in `PledgePaymentMethodsViewModel+Helpers.swift`.
internal func pledgePaymentSheetMethodCellDataAndSelectedCardSetupIntent(
  with paymentMethodData: PledgePaymentMethodsAndSelectionData
) -> PledgePaymentMethodsAndSelectionData {
  // New payment sheet cards only contain redacted metadata, so deselect existing cards and pick the first newly added enabled card.
  let preexistingCardDataUnselected = cellData(paymentMethodData.existingPaymentMethods, selecting: nil)
  let newCardDataUnselected = cellData(paymentMethodData.newPaymentMethods, selecting: nil)

  guard
    let newestPaymentSheetPaymentMethod = paymentMethodData.newPaymentMethods.first,
    newestPaymentSheetPaymentMethod.isEnabled == true
  else {
    return paymentMethodData
  }

  var data = newCardDataUnselected
  var updatedSelectedPaymentSheetPaymentMethod = data[0]
  if updatedSelectedPaymentSheetPaymentMethod.isEnabled {
    updatedSelectedPaymentSheetPaymentMethod.isSelected = true
  }
  data[0] = updatedSelectedPaymentSheetPaymentMethod

  var updatePaymentMethodData = paymentMethodData
  updatePaymentMethodData.existingPaymentMethods = preexistingCardDataUnselected
  updatePaymentMethodData.newPaymentMethods = data

  if newestPaymentSheetPaymentMethod.isEnabled {
    updatePaymentMethodData
      .selectedPaymentMethod = createSelectedPaymentMethod(from: newestPaymentSheetPaymentMethod.card)
  }

  return updatePaymentMethodData
}

internal func pledgePaymentMethodCellDataAndSelectedCard(
  with cards: [UserCreditCards.CreditCard],
  availableCardTypes: [String],
  project: Project,
  newCardAdded: Bool
) -> ([PledgePaymentMethodCellData], UserCreditCards.CreditCard?) {
  let data = cards.compactMap { card -> PledgePaymentMethodCellData? in
    guard let cardBrand = card.type?.rawValue else { return nil }
    let backing = project.personalization.backing
    let isAvailableCardType = availableCardTypes.contains(cardBrand)
    let isErroredPaymentMethod = card.id == backing?.paymentSource?.id && backing?.status == .errored

    return PledgePaymentMethodCellData(
      card: card,
      isEnabled: isAvailableCardType,
      isSelected: false,
      projectCountry: project.location?.displayableName ?? "",
      isErroredPaymentMethod: isErroredPaymentMethod
    )
  }
  .sorted { data1, data2 -> Bool in data1.isEnabled && !data2.isEnabled }

  let orderedCards = data.map { $0.card }

  guard let backing = project.personalization.backing else {
    guard let cardData = data.first, cardData.isEnabled else {
      return (data, nil)
    }
    let selected = orderedCards.first
    return (cellData(data, selecting: selected), selected)
  }

  if newCardAdded {
    let selected = orderedCards.first
    return (cellData(data, selecting: selected), selected)
  }

  if cards.first(where: { $0.id == backing.paymentSource?.id }) != nil, backing.status == .errored {
    return (data, nil)
  }

  let backedCard = orderedCards.first(where: { $0.id == backing.paymentSource?.id })
  return (cellData(data, selecting: backedCard), backedCard)
}

internal func cellData(
  _ data: [PledgePaymentMethodCellData],
  selecting card: UserCreditCards.CreditCard?
) -> [PledgePaymentMethodCellData] {
  return data.map { value in
    PledgePaymentMethodCellData(
      card: value.card,
      isEnabled: value.isEnabled,
      isSelected: value.card == card,
      projectCountry: value.projectCountry,
      isErroredPaymentMethod: value.isErroredPaymentMethod
    )
  }
}

internal func cards(
  _ cards: [UserCreditCards.CreditCard],
  orderedBy backing: Backing?
) -> [UserCreditCards.CreditCard] {
  return cards.sorted { card1, _ in card1.id == backing?.paymentSource?.id }
}

internal func createSelectedPaymentMethod(from card: UserCreditCards.CreditCard) -> PaymentSourceSelected {
  guard let stripeCardId = card.stripeCardId, !stripeCardId.isEmpty else {
    assert(false, "Expected stripeCardId to be set. Late pledges may fail if this value is missing.")
    return .savedCreditCard(card.id, nil)
  }

  return .savedCreditCard(card.id, stripeCardId)
}

internal func makeUpdatedPaymentMethodsSelection(
  from data: PledgePaymentMethodsAndSelectionData,
  selecting indexPath: IndexPath
) -> PledgePaymentMethodsAndSelectionData? {
  var updatedData = PledgePaymentMethodsAndSelectionData(
    existingPaymentMethods: [],
    newPaymentMethods: [],
    selectedPaymentMethod: nil,
    isLoading: false,
    shouldReload: true
  )

  let paymentMethodCount = data.existingPaymentMethods.count
  let paymentSheetPaymentMethodCount = data.newPaymentMethods.count

  if indexPath.row < paymentSheetPaymentMethodCount {
    let card = data.newPaymentMethods[indexPath.row].card
    updatedData.existingPaymentMethods = cellData(data.existingPaymentMethods, selecting: nil)
    updatedData.newPaymentMethods = cellData(data.newPaymentMethods, selecting: card)
    updatedData.selectedPaymentMethod = createSelectedPaymentMethod(from: card)
    return updatedData
  } else if indexPath.row < paymentSheetPaymentMethodCount + paymentMethodCount {
    let card = data.existingPaymentMethods[indexPath.row - paymentSheetPaymentMethodCount].card
    updatedData.existingPaymentMethods = cellData(data.existingPaymentMethods, selecting: card)
    updatedData.newPaymentMethods = cellData(data.newPaymentMethods, selecting: nil)
    updatedData.selectedPaymentMethod = createSelectedPaymentMethod(from: card)
    return updatedData
  }

  return nil
}

internal func canSelectPaymentMethodRow(
  cellData: ([PledgePaymentMethodCellData], [PledgePaymentMethodCellData]),
  indexPath: IndexPath
) -> IndexPath? {
  let allEnabled = cellData.1.map(\.isEnabled) + cellData.0.map(\.isEnabled)
  let validSections = [
    PaymentMethodsTableViewSection.paymentMethods.rawValue,
    PaymentMethodsTableViewSection.addNewCard.rawValue
  ]

  guard
    validSections.contains(indexPath.section),
    (allEnabled.count > indexPath.row && allEnabled[indexPath.row])
      || indexPath.section == PaymentMethodsTableViewSection.addNewCard.rawValue
  else { return nil }

  return indexPath
}

internal func bindPaymentSheetAppearanceTracking(
  project: Signal<Project, Never>,
  viewDidLoadSignal: Signal<Void, Never>,
  stripePaymentSheetDidAppearSignal: Signal<Void, Never>
) {
  Signal.combineLatest(project, viewDidLoadSignal)
    .takeWhen(stripePaymentSheetDidAppearSignal)
    .observeValues { project, _ in
      AppEnvironment.current.appTrackingTransparency.updateAdvertisingIdentifier()
      guard let externalId = AppEnvironment.current.appTrackingTransparency.advertisingIdentifier
      else { return }

      let userId = AppEnvironment.current.currentUser.map { "\($0.id)" } ?? ""
      var extInfo = Array(repeating: "", count: 16)
      extInfo[0] = "i2"
      extInfo[4] = AppEnvironment.current.mainBundle.platformVersion

      _ = AppEnvironment.current.apiService.triggerThirdPartyEventInput(
        input: .init(
          deviceId: externalId,
          eventName: ThirdPartyEventInputName.AddNewPaymentMethod.rawValue,
          projectId: "\(project.id)",
          pledgeAmount: nil,
          shipping: nil,
          transactionId: nil,
          userId: userId,
          appData: .init(
            advertiserTrackingEnabled: true,
            applicationTrackingEnabled: true,
            extinfo: extInfo
          ),
          clientMutationId: ""
        )
      )
    }
}

