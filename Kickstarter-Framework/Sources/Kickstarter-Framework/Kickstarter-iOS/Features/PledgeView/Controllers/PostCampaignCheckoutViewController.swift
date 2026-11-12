import KDS
import KsApi
import Library
import Prelude
import Stripe
import SwiftUI
import UIKit

/// View controller coordinating post-campaign late-pledge checkout, Stripe confirmation, and Apple Pay.
final class PostCampaignCheckoutViewController: UIViewController,
  MessageBannerViewControllerPresenting,
  ProcessingViewPresenting {
  // MARK: - Properties

  internal var messageBannerViewController: MessageBannerViewController?
  var applePayPaymentIntent: String?
  lazy var titleLabel = UILabel(frame: .zero)

  lazy var paymentMethodsViewController = {
    PledgePaymentMethodsViewController.instantiate()
      |> \.messageDisplayingDelegate .~ self
      |> \.delegate .~ self
  }()

  lazy var estimatedShippingViewContainer = UIHostingController(
    rootView: EstimatedShippingCheckoutView(estimatedCost: "", aboutConversion: "")
  )

  lazy var pledgeCTAContainerView: PledgeViewCTAContainerView = {
    PledgeViewCTAContainerView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> \.delegate .~ self
  }()

  lazy var pledgeDisclaimerView: PledgeDisclaimerView = {
    PledgeDisclaimerView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
      |> \.delegate .~ self
  }()

  lazy var pledgeRewardsSummaryViewController = {
    PostCampaignPledgeRewardsSummaryViewController.instantiate()
  }()

  internal var processingView: ProcessingView? = ProcessingView(frame: .zero)

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

  let viewModel: PostCampaignCheckoutViewModelType =
    PostCampaignCheckoutViewModel(stripeIntentService: StripeIntentService())

  // MARK: - Lifecycle

  /// Configures the view model with pledge data prior to presentation.
  func configure(with data: PledgeViewData) {
    self.viewModel.inputs.configure(with: data)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configureNavigationBarForPledgeFlow()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

    _ = self |> \.extendedLayoutIncludesOpaqueBars .~ true

    self.title = Strings.Pledge_flow_navigation_bar_titles_Payment()
    self.messageBannerViewController = self.configureMessageBannerViewController(on: self)

    self.configureChildViewControllers()
    self.setupConstraints()

    if let attributedText = PledgeViewControllerHelpers.attributedLearnMoreText() {
      self.pledgeDisclaimerView.configure(
        with: PledgeDisclaimerViewData(iconImageName: "icon-not-a-store", attributedText: attributedText)
      )
    }

    self.viewModel.inputs.viewDidLoad()
  }

  deinit {
    self.hideProcessingView()
    self.sessionStartedObserver.doIfSome(NotificationCenter.default.removeObserver)
  }

  // MARK: - View model

  override func bindViewModel() {
    super.bindViewModel()

    self.paymentMethodsViewController.view.rac.hidden = self.viewModel.outputs.paymentMethodsViewHidden

    self.viewModel.outputs.configurePledgeRewardsSummaryViewWithData
      .observeForUI()
      .observeValues { [weak self] rewardsData, bonusAmount, pledgeData in
        self?.pledgeRewardsSummaryViewController
          .configureWith(rewardsData: rewardsData, bonusAmount: bonusAmount, pledgeData: pledgeData)
      }

    self.viewModel.outputs.configurePledgeViewCTAContainerView
      .observeForUI()
      .observeValues { [weak self] value in self?.pledgeCTAContainerView.configureWith(value: value) }

    self.viewModel.outputs.processingViewIsHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in
        if isHidden { self?.hideProcessingView() } else { self?.showProcessingView() }
      }

    self.viewModel.outputs.configurePaymentMethodsViewControllerWithValue
      .observeForUI()
      .observeValues { [weak self] value in self?.paymentMethodsViewController.configure(with: value) }

    self.viewModel.outputs.estimatedShippingViewHidden
      .observeForUI()
      .observeValues { [weak self] isHidden in self?.estimatedShippingViewContainer.view.isHidden = isHidden }

    self.viewModel.outputs.configureEstimatedShippingView
      .observeForUI()
      .observeValues { [weak self] estimatedShippingText, estimatedConversionText in
        guard let shippingText = estimatedShippingText else { return }
        self?.configureEstimatedShippingView(shippingText, estimatedConversionText)
      }

    self.viewModel.outputs.showWebHelp
      .observeForControllerAction()
      .observeValues { [weak self] helpType in
        self?.presentHelpWebViewController(with: helpType, presentationStyle: .formSheet)
      }

    self.sessionStartedObserver = NotificationCenter.default
      .addObserver(forName: .ksr_sessionStarted, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionDidChange()
      }

    self.viewModel.outputs.goToLoginSignup
      .observeForControllerAction()
      .observeValues { [weak self] intent in self?.goToLoginSignup(with: intent) }

    self.viewModel.outputs.validateCheckoutSuccess
      .observeForControllerAction()
      .observeValues { [weak self] validation in self?.confirmPayment(with: validation) }

    self.viewModel.outputs.showErrorBannerWithMessage
      .observeForControllerAction()
      .observeValues { [weak self] errorMessage in
        self?.messageBannerViewController?.showBanner(
          with: .error,
          message: errorMessage,
          dismissType: .bannerAndViewController
        )
      }

    self.viewModel.outputs.configureStripeIntegration
      .observeForUI()
      .observeValues { stripeData in
        STPAPIClient.shared.publishableKey = stripeData.publishableKey
        STPAPIClient.shared.configuration.appleMerchantIdentifier = stripeData.merchantIdentifier
      }

    self.viewModel.outputs.goToApplePayPaymentAuthorization
      .observeForControllerAction()
      .observeValues { [weak self] paymentAuthorizationData in
        self?.goToPaymentAuthorization(paymentAuthorizationData)
      }

    self.viewModel.outputs.checkoutComplete
      .observeForUI()
      .observeValues { [weak self] thanksPageData in
        let thanksVC = ThanksViewController.configured(with: thanksPageData)
        self?.navigationController?.pushViewController(thanksVC, animated: true)
      }

    self.viewModel.outputs.checkoutError
      .observeForUI()
      .observeValues { [weak self] error in
        #if DEBUG
          let serverError = error.errorMessages.first ?? "Unknown server error"
          let message = "\(Strings.Something_went_wrong_please_try_again())\n\(serverError)"
        #else
          let message = Strings.Something_went_wrong_please_try_again()
        #endif

        self?.messageBannerViewController?
          .showBanner(with: .error, message: message, dismissType: .bannerAndViewController)
      }
  }
}
