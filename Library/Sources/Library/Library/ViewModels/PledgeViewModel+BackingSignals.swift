import Foundation
import KsApi
import PassKit
import Prelude
import ReactiveSwift

/// Immutable value type representing `PledgeBackingFlowOutputs`.
internal struct PledgeBackingFlowOutputs {
  let goToApplePayPaymentAuthorization: Signal<PaymentAuthorizationData, Never>
  let createApplePayBackingStatus: Signal<PKPaymentAuthorizationStatus, Never>
  let processingViewIsHidden: Signal<Bool, Never>
  let beginSCAFlowWithClientSecret: Signal<String, Never>
  let goToThanks: Signal<ThanksPageData, Never>
  let notifyDelegateUpdatePledgeDidSucceedWithMessage: Signal<String, Never>
  let showErrorBannerWithMessage: Signal<String, Never>
  let configurePledgeViewCTAContainerView: Signal<PledgeViewCTAContainerViewData, Never>
  let createBackingData: Signal<CreateBackingData, Never>
}

internal func makePledgeBackingFlowSignals(
  initialData: Signal<PledgeViewData, Never>,
  project: Signal<Project, Never>,
  baseReward: Signal<Reward, Never>,
  rewards: Signal<[Reward], Never>,
  selectedQuantities: Signal<SelectedRewardQuantities, Never>,
  selectedShippingRule: Signal<ShippingRule?, Never>,
  refTag: Signal<RefTag?, Never>,
  context: Signal<PledgeViewContext, Never>,
  backing: Signal<Backing, Never>,
  summary: PledgeSummarySetupOutputs,
  loginSignupUseCase: LoginSignupUseCase,
  paymentMethodsUseCase: PaymentMethodsUseCase,
  pledgeOverTimeUseCase: PledgeOverTimeUseCase,
  viewDidLoadSignal: Signal<Void, Never>,
  submitButtonTappedSignal: Signal<Void, Never>,
  applePayButtonTappedSignal: Signal<Void, Never>,
  pkPaymentSignal: Signal<(displayName: String?, network: String?, transactionIdentifier: String), Never>,
  stripeTokenSignal: Signal<String?, Never>,
  stripeErrorSignal: Signal<Error?, Never>,
  scaFlowCompletedSignal: Signal<(StripePaymentHandlerActionStatusType, Error?), Never>,
  paymentAuthorizationDidFinishSignal: Signal<Void, Never>
) -> PledgeBackingFlowOutputs {
  let paymentAuthorizationData = Signal.combineLatest(
    project,
    baseReward,
    summary.allRewardsTotal,
    summary.additionalPledgeAmount,
    summary.allRewardsShippingTotal
  ).map { args -> PaymentAuthorizationData in
    let (project, reward, rewardsTotal, additionalAmount, shippingTotal) = args
    return PaymentAuthorizationData(
      project: project,
      reward: reward,
      allRewardsTotal: rewardsTotal,
      additionalPledgeAmount: additionalAmount,
      allRewardsShippingTotal: shippingTotal,
      merchantIdentifier: Secrets.ApplePay.merchantIdentifier
    )
  }

  let pkPaymentData = pkPaymentSignal.map { pkPayment -> PKPaymentData? in
    guard let displayName = pkPayment.displayName, let network = pkPayment.network else { return nil }
    return PKPaymentData(
      displayName: displayName,
      network: network,
      transactionIdentifier: pkPayment.transactionIdentifier
    )
  }

  let applePayStatusSuccess = Signal.combineLatest(
    stripeTokenSignal.skipNil(),
    stripeErrorSignal.filter(isNil),
    pkPaymentData.skipNil()
  ).mapConst(PKPaymentAuthorizationStatus.success)

  let applePayStatusFailure = Signal.merge(
    stripeErrorSignal.skipNil().ignoreValues(),
    stripeTokenSignal.filter(isNil).ignoreValues(),
    pkPaymentData.filter(isNil).ignoreValues()
  ).mapConst(PKPaymentAuthorizationStatus.failure)

  let applePayParams = Signal.combineLatest(pkPaymentData.skipNil(), stripeTokenSignal.skipNil())
    .map { ($0.displayName, $0.network, $0.transactionIdentifier, $1) }
    .map(ApplePayParams.init)
  let applePayParamsData = Signal.merge(initialData.mapConst(nil), applePayParams.wrapInOptional())

  let selectedPaymentPlan = pledgeOverTimeUseCase.pledgeOverTimeConfigData
    .map { $0?.selectedPlan ?? .pledgeInFull }

  let createBackingData = Signal.combineLatest(
    project,
    rewards,
    summary.pledgeTotal,
    selectedQuantities,
    selectedShippingRule,
    paymentMethodsUseCase.dataOutputs.selectedPaymentSource,
    applePayParamsData,
    selectedPaymentPlan,
    refTag
  ).map { project, rewards, pledgeTotal, selectedQuantities, shippingRule, paymentSource, applePayParams, paymentPlan, refTag in
    CreateBackingData(
      project: project,
      rewards: rewards,
      pledgeTotal: pledgeTotal,
      selectedQuantities: selectedQuantities,
      shippingRule: shippingRule,
      paymentSourceId: paymentSource?.savedCreditCardId,
      setupIntentClientSecret: nil,
      applePayParams: applePayParams,
      refTag: refTag,
      incremental: paymentPlan == .pledgeOverTime
    )
  }

  let willCreateApplePayBacking = Signal.combineLatest(applePayStatusSuccess, context)
    .map { $1.isCreating }.filter(isTrue)
  let createButtonTapped = context.takeWhen(submitButtonTappedSignal)
    .filter { $0.isCreating }.ignoreValues()
  let createBackingDataAndIsApplePay = createBackingData.takePairWhen(
    Signal.merge(createButtonTapped.mapConst(false), willCreateApplePayBacking)
  )

  let checkoutIdProperty = MutableProperty<Int?>(nil)
  let processingViewIsHidden = MutableProperty<Bool>(true)

  let createBackingEvents = createBackingDataAndIsApplePay
    .map(CreateBackingInput.input(from:isApplePay:))
    .switchMap { [checkoutIdProperty] input in
      AppEnvironment.current.apiService.createBacking(input: input)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .on(starting: { processingViewIsHidden.value = false }, terminated: { processingViewIsHidden.value = true })
        .map { envelope -> StripeSCARequiring in
          checkoutIdProperty.value = decompose(id: envelope.createBacking.checkout.id)
          return envelope as StripeSCARequiring
        }
        .materialize()
    }

  let updateBackingData = Signal.combineLatest(
    backing,
    rewards,
    summary.pledgeTotal,
    selectedQuantities,
    selectedShippingRule,
    paymentMethodsUseCase.dataOutputs.selectedPaymentSource,
    applePayParamsData,
    context,
    selectedPaymentPlan
  ).map { backing, rewards, pledgeTotal, selectedQuantities, shippingRule, paymentSource, applePayParams, context, paymentPlan in
    UpdateBackingData(
      backing: backing,
      rewards: rewards,
      pledgeTotal: pledgeTotal,
      selectedQuantities: selectedQuantities,
      shippingRule: shippingRule,
      paymentSourceId: paymentSource?.savedCreditCardId,
      setupIntentClientSecret: nil,
      applePayParams: applePayParams,
      pledgeContext: context,
      incremental: paymentPlan == .pledgeOverTime
    )
  }

  let willUpdateApplePayBacking = Signal.combineLatest(applePayStatusSuccess, context)
    .map { $1.isUpdating }.filter(isTrue)
  let updateButtonTapped = context.takeWhen(submitButtonTappedSignal)
    .filter { $0.isUpdating }.ignoreValues()
  let updateBackingEvents = updateBackingData.takePairWhen(
    Signal.merge(updateButtonTapped.mapConst(false), willUpdateApplePayBacking)
  )
  .map(UpdateBackingInput.input(from:isApplePay:))
  .switchMap { input in
    AppEnvironment.current.apiService.updateBacking(input: input)
      .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      .on(starting: { processingViewIsHidden.value = false }, terminated: { processingViewIsHidden.value = true })
      .map { $0 as StripeSCARequiring }
      .materialize()
  }

  let createOrUpdateEvent = Signal.merge(createBackingEvents, updateBackingEvents)
  let valuesChangedAndValid = Signal.combineLatest(
    paymentMethodsUseCase.dataOutputs.paymentMethodChangedAndValid,
    pledgeOverTimeUseCase.pledgeOverTimeIsLoading,
    context
  ).map(allPledgeValuesChangedAndValid)

  let didCreateOrUpdateBacking = createOrUpdateEvent.filter { $0.isTerminating }
  let isEnabled = Signal.merge(
    viewDidLoadSignal.mapConst(false).take(until: valuesChangedAndValid.ignoreValues()),
    valuesChangedAndValid,
    submitButtonTappedSignal.mapConst(false),
    valuesChangedAndValid.takeWhen(didCreateOrUpdateBacking)
  ).skipRepeats()

  let isCreateOrUpdateBacking = Signal.merge(
    submitButtonTappedSignal.mapConst(true),
    Signal.merge(willUpdateApplePayBacking, willCreateApplePayBacking).mapConst(false)
  )

  let scaFlowCompletedWithError = scaFlowCompletedSignal.filter { $0.0.status == .failed }.map(second).skipNil()
  let scaFlowCompletedWithSuccess = scaFlowCompletedSignal.filter { $0.0.status == .succeeded }.map(first).ignoreValues()

  let didInitiateApplePayBacking = Signal.merge(willCreateApplePayBacking, willUpdateApplePayBacking)
  let paymentAuthorizationDidFinish = didInitiateApplePayBacking.takeWhen(paymentAuthorizationDidFinishSignal)
  let createOrUpdateApplePayBackingCompleted = Signal.zip(
    didInitiateApplePayBacking,
    didCreateOrUpdateBacking.ignoreValues(),
    paymentAuthorizationDidFinish
  )

  let valuesOrNil = Signal.merge(createOrUpdateEvent.values().wrapInOptional(), isCreateOrUpdateBacking.mapConst(nil))
  let createOrUpdateNoSCA = valuesOrNil.skipNil().filter(pledgeRequiresSCA >>> isFalse)
  let createOrUpdateDidCompleteNoSCA = isCreateOrUpdateBacking.takeWhen(createOrUpdateNoSCA).filter(isTrue).ignoreValues()
  let didCompleteApplePayBacking = valuesOrNil.takeWhen(createOrUpdateApplePayBackingCompleted).skipNil()

  let creatingContext = context.filter { $0.isCreating }
  let createCompletionEvents = Signal.merge(
    didCompleteApplePayBacking.combineLatest(with: willCreateApplePayBacking).ignoreValues(),
    createOrUpdateDidCompleteNoSCA.combineLatest(with: creatingContext).ignoreValues(),
    scaFlowCompletedWithSuccess.combineLatest(with: creatingContext).ignoreValues()
  )

  let thanksPageData = Signal.combineLatest(
    createBackingDataAndIsApplePay,
    checkoutIdProperty.signal,
    baseReward,
    summary.additionalPledgeAmount,
    summary.allRewardsShippingTotal
  ).map { dataAndIsApplePay, checkoutId, baseReward, additionalAmount, shippingTotal in
    makePledgeThanksPageData(
      data: dataAndIsApplePay.0,
      isApplePay: dataAndIsApplePay.1,
      checkoutId: checkoutId,
      baseReward: baseReward,
      additionalPledgeAmount: additionalAmount,
      shippingTotal: shippingTotal
    )
  }

  let errorsOrNil = Signal.merge(createOrUpdateEvent.errors().wrapInOptional(), isCreateOrUpdateBacking.mapConst(nil))
  let applePayError = createOrUpdateApplePayBackingCompleted.withLatest(from: errorsOrNil).map(second).skipNil()
  let backingError = isCreateOrUpdateBacking.takePairWhen(errorsOrNil.skipNil()).filter(first >>> isTrue).map(second)

  let updatingContext = context.filter { $0.isUpdating }
  let updateCompletionEvents = Signal.merge(
    didCompleteApplePayBacking.combineLatest(with: willUpdateApplePayBacking).ignoreValues(),
    createOrUpdateDidCompleteNoSCA.combineLatest(with: updatingContext).ignoreValues(),
    scaFlowCompletedWithSuccess.combineLatest(with: updatingContext).ignoreValues()
  )

  let willRetryPaymentMethod = Signal.combineLatest(
    context,
    project,
    paymentMethodsUseCase.selectedPaymentSource
  ).map {
    $0 == .fixPaymentMethod && $1.personalization.backing?.paymentSource?.id == $2?.savedCreditCardId
  }.skipRepeats()

  let configurePledgeViewCTAContainerView = Signal.combineLatest(
    project,
    summary.pledgeTotal.skipRepeats(),
    loginSignupUseCase.dataOutputs.isLoggedIn,
    isEnabled,
    context,
    willRetryPaymentMethod
  ).map { args -> PledgeViewCTAContainerViewData in
    let (project, total, isLoggedIn, isEnabled, context, willRetry) = args
    return PledgeViewCTAContainerViewData(
      project: project,
      total: total,
      isLoggedIn: isLoggedIn,
      isEnabled: isEnabled,
      context: context,
      willRetryPaymentMethod: willRetry
    )
  }

  return PledgeBackingFlowOutputs(
    goToApplePayPaymentAuthorization: paymentAuthorizationData.takeWhen(applePayButtonTappedSignal),
    createApplePayBackingStatus: Signal.merge(applePayStatusSuccess, applePayStatusFailure),
    processingViewIsHidden: processingViewIsHidden.signal,
    beginSCAFlowWithClientSecret: valuesOrNil.skipNil().filter(pledgeRequiresSCA).map { $0.clientSecret }.skipNil(),
    goToThanks: thanksPageData.takeWhen(createCompletionEvents),
    notifyDelegateUpdatePledgeDidSucceedWithMessage: updateCompletionEvents
      .mapConst(Strings.Got_it_your_changes_have_been_saved()),
    showErrorBannerWithMessage: Signal.merge(
      Signal.merge(applePayError, backingError).map { $0.localizedDescription },
      scaFlowCompletedWithError.map { $0.localizedDescription }
    ),
    configurePledgeViewCTAContainerView: configurePledgeViewCTAContainerView,
    createBackingData: createBackingData
  )
}
