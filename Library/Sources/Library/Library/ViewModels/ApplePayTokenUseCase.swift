import Foundation
import KsApi
import PassKit
import ReactiveSwift

/// Interface exposing UI inputs, UI outputs, and tokenized payment outputs for `ApplePayTokenUseCase`.
public protocol ApplePayTokenUseCaseType {
  /// Input receiver for Apple Pay sheet lifecycle callbacks.
  var uiInputs: ApplePayTokenUseCaseUIInputs { get }
  /// Output signals presenting the Apple Pay authorization sheet.
  var uiOutputs: ApplePayTokenUseCaseUIOutputs { get }
  /// Output signals emitting tokenized `ApplePayParams` and authorization statuses.
  var dataOutputs: ApplePayTokenUseCaseDataOutputs { get }
}

/// UI inputs accepted by `ApplePayTokenUseCase`.
public protocol ApplePayTokenUseCaseUIInputs {
  /// Signals that the user tapped the Apple Pay checkout button.
  func applePayButtonTapped()
  /// Records authorized PassKit payment metadata before Stripe tokenization.
  func paymentAuthorizationDidAuthorizePayment(paymentData: (
    displayName: String?,
    network: String?,
    transactionIdentifier: String
  ))
  /// Signals that the Apple Pay authorization sheet finished dismissing.
  func paymentAuthorizationViewControllerDidFinish()
  /// Resolves PassKit authorization status after Stripe token creation completes.
  func stripeTokenCreated(token: String?, error: Error?) -> PKPaymentAuthorizationStatus
}

/// UI outputs emitted by `ApplePayTokenUseCase`.
public protocol ApplePayTokenUseCaseUIOutputs {
  /// Emits payment request metadata needed to present `PKPaymentAuthorizationViewController`.
  var goToApplePayPaymentAuthorization: Signal<PaymentAuthorizationData, Never> { get }
}

/// Data outputs emitted by `ApplePayTokenUseCase`.
public protocol ApplePayTokenUseCaseDataOutputs {
  /// Emits finalized Apple Pay token parameters once authorization dismisses.
  var applePayParams: Signal<ApplePayParams?, Never> { get }
  /// Emits `.success` or `.failure` following Stripe tokenization.
  var applePayAuthorizationStatus: Signal<PKPaymentAuthorizationStatus, Never> { get }
  /// Emits when `PKPaymentAuthorizationViewController` finishes dismissing.
  var paymentAuthorizationDidFinish: Signal<Void, Never> { get }
}

/// Use case coordinating Apple Pay authorization and Stripe tokenization for standard (non-post-campaign) pledges.
/// - Negative Constraint: Do not use for post-campaign pledge checkouts; requires an `initialData` event before other signals emit.
public final class ApplePayTokenUseCase: ApplePayTokenUseCaseType, ApplePayTokenUseCaseUIInputs,
  ApplePayTokenUseCaseUIOutputs, ApplePayTokenUseCaseDataOutputs {
  init(initialData: Signal<PaymentAuthorizationData, Never>) {
    self.goToApplePayPaymentAuthorization = initialData
      .takeWhen(self.applePayButtonTappedSignal)

    let pkPaymentData = self.pkPaymentSignal
      .map { pkPayment -> PKPaymentData? in
        guard let displayName = pkPayment.displayName, let network = pkPayment.network else {
          return nil
        }

        return PKPaymentData(
          displayName: displayName,
          network: network,
          transactionIdentifier: pkPayment.transactionIdentifier
        )
      }

    let applePayStatusSuccess = Signal.combineLatest(
      self.stripeTokenSignal.skipNil(),
      self.stripeErrorSignal.filter { $0 == nil },
      pkPaymentData.skipNil()
    )
    .mapConst(PKPaymentAuthorizationStatus.success)

    let applePayStatusFailure = Signal.merge(
      self.stripeErrorSignal.skipNil().ignoreValues(),
      self.stripeTokenSignal.filter { $0 == nil }.ignoreValues(),
      pkPaymentData.filter { $0 == nil }.ignoreValues()
    )
    .mapConst(PKPaymentAuthorizationStatus.failure)

    self.createApplePayBackingStatusProperty <~ Signal.merge(
      applePayStatusSuccess,
      applePayStatusFailure
    )

    let applePayParams = Signal.combineLatest(
      pkPaymentData.skipNil(),
      self.stripeTokenSignal.skipNil()
    )
    .map { paymentData, token in
      (
        paymentData.displayName,
        paymentData.network,
        paymentData.transactionIdentifier,
        token
      )
    }
    .map(ApplePayParams.init)
    .takeWhen(self.paymentAuthorizationDidFinishSignal)

    self.applePayParams = Signal.merge(
      initialData.mapConst(nil),
      applePayParams.wrapInOptional()
    )

    self.applePayAuthorizationStatus = self.createApplePayBackingStatusProperty.signal
  }

  // MARK: - Inputs

  private let (applePayButtonTappedSignal, applePayButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Triggers presenting the Apple Pay payment authorization sheet.
  public func applePayButtonTapped() {
    self.applePayButtonTappedObserver.send(value: ())
  }

  private let (pkPaymentSignal, pkPaymentObserver) = Signal<(
    displayName: String?,
    network: String?,
    transactionIdentifier: String
  ), Never>.pipe()
  /// Stores PassKit authorized payment details prior to Stripe tokenization.
  public func paymentAuthorizationDidAuthorizePayment(paymentData: (
    displayName: String?,
    network: String?,
    transactionIdentifier: String
  )) {
    self.pkPaymentObserver.send(value: paymentData)
  }

  private let (paymentAuthorizationDidFinishSignal, paymentAuthorizationDidFinishObserver)
    = Signal<Void, Never>.pipe()
  /// Notifies the use case that the Apple Pay authorization sheet dismissed.
  public func paymentAuthorizationViewControllerDidFinish() {
    self.paymentAuthorizationDidFinishObserver.send(value: ())
  }

  /// Emits when `PKPaymentAuthorizationViewController` has finished dismissing.
  public var paymentAuthorizationDidFinish: Signal<Void, Never> {
    return self.paymentAuthorizationDidFinishSignal
  }

  private let (stripeTokenSignal, stripeTokenObserver) = Signal<String?, Never>.pipe()
  private let (stripeErrorSignal, stripeErrorObserver) = Signal<Error?, Never>.pipe()

  private let createApplePayBackingStatusProperty = MutableProperty<PKPaymentAuthorizationStatus>(.failure)
  /// Updates tokenization state from the Stripe callback and returns the resulting PassKit status.
  public func stripeTokenCreated(token: String?, error: Error?) -> PKPaymentAuthorizationStatus {
    self.stripeTokenObserver.send(value: token)
    self.stripeErrorObserver.send(value: error)

    return self.createApplePayBackingStatusProperty.value
  }

  // MARK: - Outputs

  /// Emits payment request configuration to present Apple Pay authorization.
  public let goToApplePayPaymentAuthorization: Signal<PaymentAuthorizationData, Never>
  /// Emits `ApplePayParams` once authorization completes and the sheet dismisses.
  public let applePayParams: Signal<ApplePayParams?, Never>
  /// Emits PassKit authorization status after Stripe token creation.
  public let applePayAuthorizationStatus: Signal<PKPaymentAuthorizationStatus, Never>

  // MARK: - Interface

  /// Returns `self` as `ApplePayTokenUseCaseUIInputs`.
  public var uiInputs: ApplePayTokenUseCaseUIInputs { return self }
  /// Returns `self` as `ApplePayTokenUseCaseUIOutputs`.
  public var uiOutputs: ApplePayTokenUseCaseUIOutputs { return self }
  /// Returns `self` as `ApplePayTokenUseCaseDataOutputs`.
  public var dataOutputs: ApplePayTokenUseCaseDataOutputs { return self }
}
