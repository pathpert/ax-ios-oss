import KDS
import Library
import UIKit

protocol PledgePaymentPlanOptionViewDelegate: AnyObject {
  func pledgePaymentPlanOptionView(
    _ optionView: PledgePaymentPlanOptionView,
    didSelectPlanType paymentPlanType: PledgePaymentPlansType
  )
  func pledgePaymentPlansViewController(
    _ optionView: PledgePaymentPlanOptionView,
    didTapTermsOfUseWith helpType: HelpType
  )
}

final class PledgePaymentPlanOptionView: UIView {
  // MARK: - Properties

  private lazy var contentView: UIView = UIView(frame: .zero)
  private lazy var optionDescriptorStackView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var titleLabel = { UILabel(frame: .zero) }()
  private lazy var subtitleLabel = { UILabel(frame: .zero) }()
  private lazy var selectionIndicatorImageView: UIImageView = { UIImageView(frame: .zero) }()
  private lazy var termsOfUseButton: UIButton = { UIButton(frame: .zero) }()
  private lazy var paymentIncrementsStackView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var plotSelectedStackView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var ineligibleBadgeView: BadgeView = { BadgeView(frame: .zero) }()

  private let viewModel: PledgePaymentPlansOptionViewModelType = PledgePaymentPlansOptionViewModel()

  /// Delegate notified when the user selects a payment plan option or taps terms of use.
  public weak var delegate: PledgePaymentPlanOptionViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.bindViewModel()
    self.configureSubviews()
    self.setupConstraints()
    self.configureTapGestureAndActions()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration

  private func configureSubviews() {
    self.addSubview(self.contentView)

    self.contentView.addSubview(self.selectionIndicatorImageView)
    self.contentView.addSubview(self.optionDescriptorStackView)

    self.plotSelectedStackView.addArrangedSubviews(self.termsOfUseButton, self.paymentIncrementsStackView)

    self.optionDescriptorStackView.addArrangedSubviews(
      self.titleLabel,
      self.subtitleLabel,
      self.ineligibleBadgeView,
      self.plotSelectedStackView
    )

    self.termsOfUseButton.setAttributedTitle(
      NSAttributedString(
        string: Strings.See_our_terms_of_use(),
        attributes: [NSAttributedString.Key.font: UIFont.ksr_caption1()]
      ),
      for: .normal
    )
  }

  private func setupConstraints() {
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    self.selectionIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
    self.optionDescriptorStackView.translatesAutoresizingMaskIntoConstraints = false

    self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    self.titleLabel.setContentHuggingPriority(.required, for: .vertical)

    self.subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    self.subtitleLabel.setContentHuggingPriority(.required, for: .vertical)

    NSLayoutConstraint.activate([
      self.contentView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: PledgePaymentPlanOptionConstants.defaultPaddingSpacing
      ),
      self.contentView.trailingAnchor.constraint(
        equalTo: self.trailingAnchor,
        constant: -PledgePaymentPlanOptionConstants.defaultPaddingSpacing
      ),
      self.contentView.topAnchor.constraint(
        equalTo: self.topAnchor,
        constant: PledgePaymentPlanOptionConstants.defaultPaddingSpacing
      ),
      self.contentView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor,
        constant: -PledgePaymentPlanOptionConstants.defaultPaddingSpacing
      )
    ])

    NSLayoutConstraint.activate([
      self.optionDescriptorStackView.leadingAnchor.constraint(
        equalTo: self.selectionIndicatorImageView.trailingAnchor,
        constant: PledgePaymentPlanOptionConstants.defaultPaddingSpacing
      ),
      self.optionDescriptorStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.optionDescriptorStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.optionDescriptorStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])

    NSLayoutConstraint.activate([
      self.selectionIndicatorImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.selectionIndicatorImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.selectionIndicatorImageView.widthAnchor
        .constraint(equalToConstant: PledgePaymentPlanOptionConstants.selectionIndicatorImageWidth),
      self.selectionIndicatorImageView.heightAnchor.constraint(
        equalTo: self.titleLabel.heightAnchor,
        multiplier: 1.0
      )
    ])

    self.termsOfUseButton.setContentHuggingPriority(.required, for: .horizontal)
  }

  private func configureTapGestureAndActions() {
    self.addGestureRecognizer(UITapGestureRecognizer(
      target: self,
      action: #selector(self.onOptionTapped)
    ))

    self.termsOfUseButton.addTarget(
      self,
      action: #selector(self.onTermsOfUseButtonTapped),
      for: .touchUpInside
    )
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    applyOptionDescriptorStackViewStyle(self.optionDescriptorStackView)
    self.optionDescriptorStackView.setCustomSpacing(0, after: self.subtitleLabel)

    applyOptionTitleLabelStyle(self.titleLabel)
    applyOptionSubtitleLabelStyle(self.subtitleLabel)
    applySelectionIndicatorImageViewStyle(self.selectionIndicatorImageView)
    applyOptionTermsOfUseStyle(self.termsOfUseButton)
    applyPaymentIncrementsStackViewStyle(self.paymentIncrementsStackView)
    applyPlotSelectedStackViewStyle(self.plotSelectedStackView)
  }

  // MARK: - View model

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.selectionIndicatorImageName
      .observeForUI()
      .observeValues { [weak self] imageName in
        self?.selectionIndicatorImageView.image = Library.image(named: imageName)
      }

    self.titleLabel.rac.text = self.viewModel.outputs.titleText

    self.subtitleLabel.rac.text = self.viewModel.outputs.subtitleText
    self.subtitleLabel.rac.hidden = self.viewModel.outputs.subtitleLabelHidden

    self.viewModel.outputs.notifyDelegatePaymentPlanOptionSelected
      .observeForUI()
      .observeValues { [weak self] paymentPlan in
        guard let self = self else { return }

        self.delegate?.pledgePaymentPlanOptionView(self, didSelectPlanType: paymentPlan)
      }

    self.viewModel.outputs.notifyDelegateTermsOfUseTapped
      .observeForUI()
      .observeValues { [weak self] helpType in
        guard let self = self else { return }

        self.delegate?.pledgePaymentPlansViewController(self, didTapTermsOfUseWith: helpType)
      }

    self.ineligibleBadgeView.rac.hidden = self.viewModel.outputs.ineligibleBadgeHidden

    self.viewModel.outputs.ineligibleBadgeText
      .observeForUI()
      .observeValues { [weak self] badgeText in
        self?.ineligibleBadgeView.configure(with: badgeText, style: .neutral)
      }

    self.plotSelectedStackView.rac.hidden = self.viewModel.outputs.plotSelectedStackViewHidden

    self.viewModel.outputs.optionViewEnabled
      .observeForUI()
      .observeValues { [weak self] isOptionViewEnabled in
        guard let self = self else { return }

        self.isUserInteractionEnabled = isOptionViewEnabled
        applyOptionTextColorByState(self.titleLabel, isEnabled: isOptionViewEnabled)
      }

    self.viewModel.outputs.paymentIncrements
      .observeForUI()
      .observeValues { [weak self] increments in
        guard let self = self else { return }

        self.setupIncrementsStackView(with: increments)
      }
  }

  func configureWith(value: PledgePaymentPlanOptionData) {
    self.viewModel.inputs.configureWith(data: value)
  }

  func refreshSelectedOption(_ selectedType: PledgePaymentPlansType) {
    self.viewModel.inputs.refreshSelectedType(selectedType)
  }

  // MARK: - Actions

  @objc private func onOptionTapped() {
    self.viewModel.inputs.optionTapped()
  }

  @objc private func onTermsOfUseButtonTapped() {
    self.viewModel.inputs.termsOfUseTapped()
  }

  // MARK: - Functions

  private func setupIncrementsStackView(with increments: [PledgePaymentIncrementFormatted]) {
    let widthGuide = UILayoutGuide()
    self.paymentIncrementsStackView.addLayoutGuide(widthGuide)

    increments.forEach { increment in
      let incrementView = PledgeOverTimeIncrementView()
      self.paymentIncrementsStackView.addArrangedSubview(incrementView)
      incrementView.configure(with: increment)
      incrementView.configureDateLabelWidthGuide(widthGuide)
    }
  }
}
