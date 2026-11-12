import KDS
import KsApi
import Library
import Prelude
import Stripe
import SwiftUI
import UIKit

/// View controller coordinating the pledge checkout screen, payment methods, payment plans, and Apple Pay.
final class PledgeViewController: UIViewController,
  MessageBannerViewControllerPresenting, ProcessingViewPresenting {
  // MARK: - Properties

  lazy var confirmationSectionViews = { [self.pledgeDisclaimerView] }()
  /// Delegate notified on pledge submission, dismissal, or reward modification.
  public weak var delegate: PledgeViewControllerDelegate?
  var titleLabel: UILabel = { UILabel(frame: .zero) }()
  var collectionPlanSectionLabel: UILabel = { UILabel(frame: .zero) }()
  var paymentSectionLabel: UILabel = { UILabel(frame: .zero) }()
  var processingView: ProcessingView? = ProcessingView(frame: .zero)

  lazy var pledgeDisclaimerView: PledgeDisclaimerView = {
    PledgeDisclaimerView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> \.delegate .~ self
  }()

  fileprivate lazy var keyboardDimissingTapGestureRecognizer: UITapGestureRecognizer = {
    UITapGestureRecognizer(target: self, action: #selector(PledgeViewController.dismissKeyboard))
      |> \.cancelsTouchesInView .~ false
  }()

  var messageBannerViewController: MessageBannerViewController?

  lazy var pledgeAmountSummaryViewController: PledgeAmountSummaryViewController = {
    PledgeAmountSummaryViewController.instantiate()
  }()

  lazy var paymentMethodsSectionViews = { [self.paymentMethodsViewController.view] }()

  lazy var paymentMethodsViewController = {
    PledgePaymentMethodsViewController.instantiate()
      |> \.messageDisplayingDelegate .~ self
      |> \.delegate .~ self
  }()

  lazy var paymentPlansView: UIView = { self.paymentPlansViewController.view }()

  lazy var paymentPlansViewController = {
    PledgePaymentPlansViewController.instantiate()
      |> \.delegate .~ self
  }()

  lazy var localPickupLocationView = { PledgeLocalPickupView(frame: .zero) }()

  lazy var pledgeRewardsSummaryViewController = {
    PledgeRewardsSummaryViewController.instantiate()
  }()

  lazy var estimatedShippingViewContainer = UIHostingController(
    rootView: EstimatedShippingCheckoutView(estimatedCost: "", aboutConversion: "")
  )

  lazy var pledgeCTAContainerView: PledgeViewCTAContainerView = {
    PledgeViewCTAContainerView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> \.delegate .~ self
  }()

  lazy var rootScrollView: UIScrollView = {
    UIScrollView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var rootStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var rootInsetStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  lazy var estimatedShippingStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private var sessionStartedObserver: Any?
  let viewModel: PledgeViewModelType = PledgeViewModel()

  // MARK: - Lifecycle

  /// Configures the view controller with initial pledge view data before presentation.
  func configure(with data: PledgeViewData) {
    self.viewModel.inputs.configure(with: data)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configureNavigationBarForPledgeFlow()
    self.extendedLayoutIncludesOpaqueBars = true

    self.titleLabel.text = Strings.Checkout()
    self.collectionPlanSectionLabel.text = Strings.Collection_plan()
    self.paymentSectionLabel.text = Strings.Payment()

    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)
    self.view.addGestureRecognizer(self.keyboardDimissingTapGestureRecognizer)

    self.configureChildViewControllers()
    self.configureDisclaimerView()
    self.setupConstraints()

    self.viewModel.inputs.viewDidLoad()
    self.viewModel.inputs.paymentPlanSelected(.pledgeInFull)
  }

  deinit {
    self.sessionStartedObserver.doIfSome(NotificationCenter.default.removeObserver)
  }

  // MARK: - View model

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.title
      .observeForUI()
      .observeValues { [weak self] title in _ = self ?|> \.title .~ title }

    self.viewModel.outputs.beginSCAFlowWithClientSecret
      .observeForUI()
      .observeValues { [weak self] secret in self?.beginSCAFlow(withClientSecret: secret) }

    self.viewModel.outputs.configureLocalPickupViewWithData
      .observeForUI()
      .observeValues { [weak self] data in self?.localPickupLocationView.configure(with: data) }

    self.viewModel.outputs.configureStripeIntegration
      .observeForUI()
      .observeValues { stripeData in
        STPAPIClient.shared.publishableKey = stripeData.publishableKey
        STPAPIClient.shared.configuration.appleMerchantIdentifier = stripeData.merchantIdentifier
      }

    self.viewModel.outputs.configurePledgeRewardsSummaryViewWithData
      .observeForUI()
      .observeValues { [weak self] rewardsData, bonusAmount, pledgeData in
        self?.pledgeRewardsSummaryViewController
          .configureWith(rewardsData: rewardsData, bonusAmount: bonusAmount, pledgeData: pledgeData)
      }

    self.paymentPlansView.rac.hidden = self.viewModel.outputs.showPledgeOverTimeUI.negate()

    self.viewModel.outputs.showPledgeOverTimeUI
      .observeForUI()
      .observeValues { [weak self] isVisible in self?.configurePledgeOverTimeUI(isVisible) }

    self.viewModel.outputs.pledgeOverTimeConfigData
      .observeForUI()
      .observeValues { [weak self] data in
        if let data = data {
          self?.paymentPlansViewController.configure(with: data)
        }
        self?.pledgeRewardsSummaryViewController.configureWith(pledgeOverTimeData: data)
      }

    self.viewModel.outputs.configurePledgeAmountSummaryViewControllerWithData
      .observeForUI()
      .observeValues { [weak self] data in self?.pledgeAmountSummaryViewController.configureWith(data) }

    self.viewModel.outputs.configureEstimatedShippingView
      .observeForUI()
      .observeValues { [weak self] estimatedShippingText, estimatedConversionText in
        guard let shippingText = estimatedShippingText else { return }
        self?.configureEstimatedShippingView(shippingText, estimatedConversionText)
      }

    self.viewModel.outputs.estimatedShippingViewHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in self?.estimatedShippingViewContainer.view.isHidden = isHidden }

    self.viewModel.outputs.configurePledgeViewCTAContainerView
      .observeForUI()
      .observeValues { [weak self] value in self?.pledgeCTAContainerView.configureWith(value: value) }

    self.viewModel.outputs.configurePaymentMethodsViewControllerWithValue
      .observeForUI()
      .observeValues { [weak self] value in self?.paymentMethodsViewController.configure(with: value) }

    self.viewModel.outputs.goToLoginSignup
      .observeForControllerAction()
      .observeValues { [weak self] intent in self?.goToLoginSignup(with: intent) }

    self.sessionStartedObserver = NotificationCenter.default
      .addObserver(forName: .ksr_sessionStarted, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionDidChange()
      }

    self.viewModel.outputs.goToApplePayPaymentAuthorization
      .observeForControllerAction()
      .observeValues { [weak self] data in self?.goToPaymentAuthorization(data) }

    self.viewModel.outputs.goToThanks
      .observeForControllerAction()
      .observeValues { [weak self] data in
        generateNotificationSuccessFeedback()
        self?.goToThanks(data: data)
      }

    self.viewModel.outputs.notifyDelegateUpdatePledgeDidSucceedWithMessage
      .observeForUI()
      .observeValues { [weak self] message in
        guard let self = self else { return }
        self.delegate?.pledgeViewControllerDidUpdatePledge(self, message: message)
      }

    self.viewModel.outputs.popToRootViewController
      .observeForControllerAction()
      .observeValues { [weak self] in self?.navigationController?.popToRootViewController(animated: true) }

    Keyboard.change
      .observeForUI()
      .observeValues { [weak self] change in self?.rootScrollView.handleKeyboardVisibilityDidChange(change) }

    self.localPickupLocationView.rac.hidden = self.viewModel.outputs.localPickupViewHidden
    self.paymentMethodsViewController.view.rac.hidden = self.viewModel.outputs.paymentMethodsViewHidden
    self.paymentSectionLabel.rac.hidden = self.viewModel.outputs.paymentMethodsViewHidden

    self.viewModel.outputs.processingViewIsHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        if isHidden { self?.hideProcessingView() } else { self?.showProcessingView() }
      }

    self.viewModel.outputs.showWebHelp
      .observeForControllerAction()
      .observeValues { [weak self] helpType in
        guard let self = self else { return }
        self.paymentMethodsViewController.cancelModalPresentation(true)
        self.presentHelpWebViewController(with: helpType, presentationStyle: .formSheet)
      }

    // MARK: Errors

    self.viewModel.outputs.showErrorBannerWithMessage
      .observeForControllerAction()
      .observeValues { [weak self] errorMessage in
        self?.messageBannerViewController?.showBanner(with: .error, message: errorMessage)
      }
  }

  // MARK: - Actions

  @objc private func dismissKeyboard() {
    self.view.endEditing(true)
  }
}
