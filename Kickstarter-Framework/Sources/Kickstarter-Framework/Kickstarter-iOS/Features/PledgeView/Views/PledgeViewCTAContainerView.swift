import KDS
import KsApi
import Library
import PassKit
import Prelude
import UIKit

/// Contract defining `PledgeViewCTAContainerViewDelegate` capabilities and boundaries.
protocol PledgeViewCTAContainerViewDelegate: AnyObject {
  func applePayButtonTapped()
  func goToLoginSignup()
  func submitButtonTapped()
  func termsOfUseTapped(with helptype: HelpType)
}

private enum Layout {
  enum Button {
    static let minHeight: CGFloat = 48.0
  }
}

final class PledgeViewCTAContainerView: UIView {
  // MARK: - Properties

  private lazy var titleLabel: UILabel = { UILabel(frame: .zero) }()
  private lazy var amountLabel: UILabel = { UILabel(frame: .zero) }()
  private(set) lazy var titleAndAmountStackView: UIStackView = { UIStackView(frame: .zero) }()

  private lazy var applePayButton: PKPaymentButton = { PKPaymentButton(
    paymentButtonType: .plain,
    paymentButtonStyle: .automatic
  ) }()

  private lazy var ctaStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var termsTextView: UITextView = { UITextView(frame: .zero) |> \.delegate .~ self }()

  private lazy var pledgeImmediatelyLabel: UILabel = {
    UILabel(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var disclaimerStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var continueButton: UIButton = {
    UIButton(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var submitButton: UIButton = {
    UIButton(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var rootStackView: UIStackView = {
    UIStackView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  weak var delegate: PledgeViewCTAContainerViewDelegate?

  private let viewModel: PledgeViewCTAContainerViewModelType = PledgeViewCTAContainerViewModel()

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configureSubviews()
    self.setupConstraints()
    self.bindViewModel()

    // Do this once, on `viewDidLoad`, instead of in `bindStyles`.
    // This fixes a crash when `bindStyles` is triggered by a background
    // trait update during app snapshotting.
    self.termsTextView.attributedText = pledgeCTAAttributedTermsText()
    self.pledgeImmediatelyLabel.attributedText = pledgeCTAPledgeImmediatelyText()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    _ = self
      |> \.layoutMargins .~ .init(all: Styles.grid(3))

    PledgeViewStyles.pledgeAmountStackViewStyle(self.titleAndAmountStackView)

    PledgeViewStyles.pledgeAmountHeadingStyle(self.titleLabel)
    self.titleLabel.text = Strings.Total_amount()

    PledgeViewStyles.pledgeAmountValueStyle(self.amountLabel)

    _ = applePayButtonStyle(self.applePayButton)

    pledgeCTAStackViewStyle(self.ctaStackView)

    pledgeCTATermsTextViewStyle(self.termsTextView)

    self.pledgeImmediatelyLabel.numberOfLines = 0
    self.pledgeImmediatelyLabel.textAlignment = .center
    self.pledgeImmediatelyLabel.textColor = LegacyColors.ksr_support_400.uiColor()

    pledgeCTADisclaimerStackViewStyle(self.disclaimerStackView)

    _ = self.layer
      |> pledgeCTALayerStyle

    self.continueButton.applyStyleConfiguration(KSRButtonStyle.green)
    self.continueButton.setTitle(Strings.Continue(), for: .normal)

    self.submitButton.applyStyleConfiguration(KSRButtonStyle.green)

    PledgeViewStyles.rootPledgeCTAStackViewStyle(self.rootStackView)
  }

  // MARK: - View Model

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.notifyDelegateToGoToLoginSignup
      .observeForUI()
      .observeValues { [weak self] in
        guard let self = self else { return }
        self.delegate?.goToLoginSignup()
      }

    self.viewModel.outputs.notifyDelegateSubmitButtonTapped
      .observeForUI()
      .observeValues { [weak self] in
        guard let self = self else { return }
        self.delegate?.submitButtonTapped()
      }

    self.viewModel.outputs.notifyDelegateApplePayButtonTapped
      .observeForUI()
      .observeValues { [weak self] in
        guard let self = self else { return }
        self.delegate?.applePayButtonTapped()
      }

    self.viewModel.outputs.notifyDelegateOpenHelpType
      .observeForUI()
      .observeValues { [weak self] helpType in
        guard let self = self else { return }
        self.delegate?.termsOfUseTapped(with: helpType)
      }

    self.applePayButton.rac.hidden = self.viewModel.outputs.applePayButtonIsHidden
    self.continueButton.rac.hidden = self.viewModel.outputs.continueButtonIsHidden
    self.submitButton.rac.hidden = self.viewModel.outputs.submitButtonIsHidden
    self.submitButton.rac.title = self.viewModel.outputs.submitButtonTitle
    self.submitButton.rac.enabled = self.viewModel.outputs.submitButtonIsEnabled

    self.pledgeImmediatelyLabel.rac.hidden = self.viewModel.outputs.pledgeImmediatelyLabelIsHidden
  }

  // MARK: - Configuration

  func configureWith(value: PledgeViewCTAContainerViewData) {
    let viewModelData = PledgeViewCTAContainerViewData(
      project: value.project,
      total: value.total,
      isLoggedIn: value.isLoggedIn,
      isEnabled: value.isEnabled,
      context: value.context,
      willRetryPaymentMethod: value.willRetryPaymentMethod
    )
    self.viewModel.inputs.configureWith(value: viewModelData)

    if let attributedAmount = attributedCurrency(withProject: value.project, total: value.total) {
      self.amountLabel.attributedText = attributedAmount
    }
  }

  // MARK: Functions

  private func configureSubviews() {
    _ = (self.rootStackView, self)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = ([self.titleLabel, self.amountLabel], self.titleAndAmountStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.continueButton, self.submitButton, self.applePayButton], self.ctaStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.pledgeImmediatelyLabel, self.termsTextView], self.disclaimerStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.titleAndAmountStackView, self.ctaStackView, self.disclaimerStackView], self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    self.submitButton.addTarget(
      self, action: #selector(self.submitButtonTapped), for: .touchUpInside
    )

    self.continueButton.addTarget(
      self, action: #selector(self.continueButtonTapped), for: .touchUpInside
    )

    self.applePayButton.addTarget(
      self,
      action: #selector(self.applePayButtonTapped),
      for: .touchUpInside
    )
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.submitButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.Button.minHeight),
      self.applePayButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.Button.minHeight)
    ])
  }

  @objc func submitButtonTapped() {
    self.viewModel.inputs.submitButtonTapped()
  }

  @objc func continueButtonTapped() {
    self.viewModel.inputs.continueButtonTapped()
  }

  @objc func applePayButtonTapped() {
    self.viewModel.inputs.applePayButtonTapped()
  }
}

extension PledgeViewCTAContainerView: UITextViewDelegate {
  func textView(
    _: UITextView, shouldInteractWith _: NSTextAttachment,
    in _: NSRange, interaction _: UITextItemInteraction
  ) -> Bool {
    return false
  }

  func textView(
    _: UITextView, shouldInteractWith url: URL, in _: NSRange,
    interaction _: UITextItemInteraction
  ) -> Bool {
    self.viewModel.inputs.tapped(url)
    return false
  }
}
