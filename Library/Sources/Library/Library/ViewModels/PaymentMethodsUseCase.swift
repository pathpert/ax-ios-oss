import KsApi
import ReactiveSwift

/// Interface exposing UI inputs, UI outputs, and validation state for `PaymentMethodsUseCase`.
public protocol PaymentMethodsUseCaseType {
  /// Input receiver for credit card selection events.
  var uiInputs: PaymentMethodsUseCaseUIInputs { get }
  /// Output signals configuring and toggling the saved payment methods UI.
  var uiOutputs: PaymentMethodsUseCaseUIOutputs { get }
  /// Output signals emitting selected payment sources and validity state.
  var dataOutputs: PaymentMethodsUseCaseDataOutputs { get }
}

/// UI inputs accepted by `PaymentMethodsUseCase`.
public protocol PaymentMethodsUseCaseUIInputs {
  /// Updates the selected saved payment source during pledge checkout.
  func creditCardSelected(with paymentSourceData: PaymentSourceSelected)
}

/// UI outputs emitted by `PaymentMethodsUseCase`.
public protocol PaymentMethodsUseCaseUIOutputs {
  /// Emits whether the saved payment methods section should be hidden.
  var paymentMethodsViewHidden: Signal<Bool, Never> { get }
  /// Emits configuration values for `PledgePaymentMethodsViewController`.
  var configurePaymentMethodsViewControllerWithValue: Signal<PledgePaymentMethodsValue, Never> { get }
}

/// Data outputs emitted by `PaymentMethodsUseCase`.
public protocol PaymentMethodsUseCaseDataOutputs {
  /// Emits the currently selected payment source, or `nil` initially.
  var selectedPaymentSource: Signal<PaymentSourceSelected?, Never> { get }
  /// Emits whether the payment method change satisfies backing update requirements.
  var paymentMethodChangedAndValid: Signal<Bool, Never> { get }
}

/// Use case transforming `PledgeViewData` and auth state into `PledgePaymentMethodsValue` configurations for `PledgePaymentMethodsViewController`.
/// - Negative Constraint: Requires at least one `initialData` emission before outputs emit.
public final class PaymentMethodsUseCase: PaymentMethodsUseCaseType, PaymentMethodsUseCaseUIInputs,
  PaymentMethodsUseCaseUIOutputs, PaymentMethodsUseCaseDataOutputs {
  init(initialData: Signal<PledgeViewData, Never>, isLoggedIn isLoggedInChanged: Signal<Bool, Never>) {
    let project = initialData.map(\.project)
    let baseReward = initialData.map(\.rewards).map(\.first).skipNil()
    let refTag = initialData.map(\.refTag)
    let context = initialData.map(\.context)

    let initialDataUnpacked = Signal.zip(project, baseReward, refTag, context)
    let initialLoggedIn = initialData.map { _ in AppEnvironment.current.currentUser != nil }

    let isLoggedIn = Signal.merge(
      initialLoggedIn,
      isLoggedInChanged
    ).skipRepeats()

    let configurePaymentMethodsViewController = Signal.merge(
      initialDataUnpacked,
      initialDataUnpacked.takeWhen(isLoggedIn.filter { $0 == true })
    )

    self.configurePaymentMethodsViewControllerWithValue = configurePaymentMethodsViewController
      .filter { !$3.paymentMethodsViewHidden }
      .compactMap { project, reward, refTag, context -> PledgePaymentMethodsValue? in
        guard let user = AppEnvironment.current.currentUser else { return nil }
        return (user, project, "", reward, context, refTag)
      }

    self.paymentMethodsViewHidden = Signal.combineLatest(isLoggedIn, context)
      .map { !$0 || $1.paymentMethodsViewHidden }

    self.selectedPaymentSource = Signal.merge(
      initialData.mapConst(nil),
      self.creditCardSelectedSignal.wrapInOptional()
    )

    let notChangingPaymentMethod = context.map { context in
      if context.isUpdating {
        return context == .updateReward || context == .editPledgeOverTime
      }

      return false
    }

    /// The `paymentMethodChangedAndValid` compares  against the existing backing payment source id.
    self.paymentMethodChangedAndValid = Signal.merge(
      notChangingPaymentMethod,
      Signal.combineLatest(
        project,
        baseReward,
        self.creditCardSelectedSignal,
        context
      )
      .map(paymentMethodValid)
    )
  }

  /// Emits whether the payment methods section is hidden.
  public let paymentMethodsViewHidden: Signal<Bool, Never>
  /// Emits configuration tuples for the embedded payment methods controller.
  public let configurePaymentMethodsViewControllerWithValue: Signal<PledgePaymentMethodsValue, Never>
  /// Emits the currently selected `PaymentSourceSelected`, if any.
  public let selectedPaymentSource: Signal<PaymentSourceSelected?, Never>
  /// Emits whether the selected payment method is valid for submission.
  public let paymentMethodChangedAndValid: Signal<Bool, Never>

  private let (creditCardSelectedSignal, creditCardSelectedObserver) = Signal<PaymentSourceSelected, Never>
    .pipe()
  /// Records selection of a saved credit card payment source.
  public func creditCardSelected(with paymentSourceData: PaymentSourceSelected) {
    self.creditCardSelectedObserver.send(value: paymentSourceData)
  }

  /// Returns `self` as `PaymentMethodsUseCaseUIInputs`.
  public var uiInputs: PaymentMethodsUseCaseUIInputs { return self }
  /// Returns `self` as `PaymentMethodsUseCaseUIOutputs`.
  public var uiOutputs: PaymentMethodsUseCaseUIOutputs { return self }
  /// Returns `self` as `PaymentMethodsUseCaseDataOutputs`.
  public var dataOutputs: PaymentMethodsUseCaseDataOutputs { return self }
}

private func paymentMethodValid(
  project: Project,
  reward: Reward,
  paymentSource: PaymentSourceSelected,
  context: PledgeViewContext
) -> Bool {
  guard
    let backedPaymentSourceId = project.personalization.backing?.paymentSource?.id,
    context.isUpdating,
    userIsBacking(reward: reward, inProject: project)
  else {
    return true
  }

  if project.personalization.backing?.status == .errored {
    return true
  } else if backedPaymentSourceId != paymentSource.savedCreditCardId {
    return true
  }

  return false
}
