import KDS
import KsApi
import Library
import ReactiveSwift
import UIKit

protocol RewardAddOnCardViewDelegate: AnyObject {
  func rewardAddOnCardView(
    _ cardView: RewardAddOnCardView,
    didSelectQuantity quantity: Int,
    rewardId: Int
  )
}

/// Card view displaying an optional reward add-on, its price, included items, shipping, and quantity controls.
public final class RewardAddOnCardView: UIView {
  weak var delegate: RewardAddOnCardViewDelegate?
  private let viewModel: RewardAddOnCardViewModelType = RewardAddOnCardViewModel()

  let rootStackView = UIStackView(frame: .zero)
  let detailsStackView = UIStackView(frame: .zero)
  let rewardImageView = UIImageView(frame: .zero)
  let addButton = UIButton(type: .custom)
  let amountConversionLabel = UILabel(frame: .zero)
  let amountLabel = UILabel(frame: .zero)
  let descriptionLabel = UILabel(frame: .zero)
  let includedItemsSeparator = UIView(frame: .zero)
  let includedItemsStackView = UIStackView(frame: .zero)
  let includedItemsTitleLabel = UILabel(frame: .zero)
  let includedItemsLabel = UILabel(frame: .zero)
  let estimatedShippingSeparator = UIView(frame: .zero)
  let estimatedShippingStackView = UIStackView(frame: .zero)
  let estimatedShippingTitleLabel = UILabel(frame: .zero)
  let estimatedShippingLabel = UILabel(frame: .zero)
  let quantityLabel = UILabel(frame: .zero)
  let quantityLabelContainer = UIView(frame: .zero)
  let pillsView = PillsView(frame: .zero)
  var pillsViewHeightConstraint: NSLayoutConstraint?
  let stepper = UIStepper(frame: .zero)
  let stepperStackView = UIStackView(frame: .zero)
  let rewardLocationStackView = UIStackView(frame: .zero)
  let rewardLocationTitleLabel = UILabel(frame: .zero)
  let rewardLocationPickupLabel = UILabel(frame: .zero)
  let rewardTitleLabel = UILabel(frame: .zero)
  let titleAmountStackView = UIStackView(frame: .zero)

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addButton.addTarget(
      self,
      action: #selector(RewardAddOnCardView.addButtonTapped),
      for: .touchUpInside
    )

    self.stepper.addTarget(
      self,
      action: #selector(RewardAddOnCardView.stepperValueChanged(_:)),
      for: .valueChanged
    )

    self.configureViews()
    self.setupConstraints()
    self.bindViewModel()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Updates the dynamic pills container height constraint to match intrinsic pill layout height.
  public override func layoutSubviews() {
    super.layoutSubviews()

    self.pillsViewHeightConstraint?.constant = self.pillsView.intrinsicContentSize.height
  }

  /// Binds `RewardAddOnCardViewModel` outputs to labels, stepper controls, images, pills, and delegate callbacks.
  public override func bindViewModel() {
    super.bindViewModel()

    self.addButton.rac.hidden = self.viewModel.outputs.addButtonHidden
    self.amountConversionLabel.rac.hidden = self.viewModel.outputs.amountConversionLabelHidden
    self.amountConversionLabel.rac.text = self.viewModel.outputs.amountConversionLabelText
    self.descriptionLabel.rac.text = self.viewModel.outputs.descriptionLabelText
    self.includedItemsStackView.rac.hidden = self.viewModel.outputs.includedItemsStackViewHidden
    self.includedItemsLabel.rac.attributedText = self.viewModel.outputs.includedItemsLabelAttributedText
    self.estimatedShippingStackView.rac.hidden = self.viewModel.outputs.estimatedShippingStackViewHidden
    self.amountLabel.rac.attributedText = self.viewModel.outputs.amountLabelAttributedText
    self.pillsView.rac.hidden = self.viewModel.outputs.pillsViewHidden
    self.quantityLabel.rac.text = self.viewModel.outputs.quantityLabelText
    self.rewardLocationStackView.rac.hidden = self.viewModel.outputs.rewardLocationStackViewHidden
    self.rewardLocationPickupLabel.rac.text = self.viewModel.outputs.rewardLocationPickupLabelText
    self.rewardTitleLabel.rac.text = self.viewModel.outputs.rewardTitleLabelText
    self.stepperStackView.rac.hidden = self.viewModel.outputs.stepperStackViewHidden
    self.stepper.rac.maximumValue = self.viewModel.outputs.stepperMaxValue
    self.stepper.rac.value = self.viewModel.outputs.stepperValue
    self.rewardImageView.rac.hidden = self.viewModel.outputs.rewardImageHidden

    self.viewModel.outputs.notifiyDelegateDidSelectQuantity
      .observeForUI()
      .observeValues { [weak self] quantity, rewardId in
        guard let self = self else { return }
        self.delegate?.rewardAddOnCardView(self, didSelectQuantity: quantity, rewardId: rewardId)
      }

    self.viewModel.outputs.reloadPills
      .observeForUI()
      .observeValues { [weak self] values in self?.configurePillsView(values) }

    self.viewModel.outputs.generateSelectionFeedback
      .observeForUI()
      .observeValues { generateSelectionFeedback() }

    self.viewModel.outputs.generateNotificationWarningFeedback
      .observeForUI()
      .observeValues { generateNotificationWarningFeedback() }

    self.viewModel.outputs.estimatedShippingLabelText
      .observeForUI()
      .observeValues { [weak self] text in
        guard let labelText = text else { return }
        self?.estimatedShippingLabel.text = labelText
      }

    self.viewModel.outputs.rewardImage
      .observeForUI()
      .on(event: { [weak rewardImageView] _ in
        rewardImageView?.af.cancelImageRequest()
        rewardImageView?.image = nil
      })
      .observeValues { [weak rewardImageView] image in
        rewardImageView?.accessibilityLabel = image.altText
        guard let url = image.url, let imageURL = URL(string: url) else { return }
        rewardImageView?.ksr_setImageWithURL(imageURL)
      }
  }

  private func configureViews() {
    self.addSubview(self.rootStackView)
    self.rootStackView.constrainViewToEdges(in: self)
    self.rootStackView.addArrangedSubviews(self.rewardImageView, self.detailsStackView)
    self.rewardImageView.isHidden = true

    self.detailsStackView.addArrangedSubviews(
      self.rewardTitleLabel,
      self.titleAmountStackView,
      self.descriptionLabel,
      self.estimatedShippingStackView,
      self.includedItemsStackView,
      self.rewardLocationStackView,
      self.pillsView,
      self.addButton,
      self.stepperStackView
    )

    self.titleAmountStackView.addArrangedSubviews(
      self.rewardTitleLabel,
      self.amountLabel,
      self.amountConversionLabel
    )

    self.includedItemsStackView.addArrangedSubviews(
      self.includedItemsSeparator,
      self.includedItemsTitleLabel,
      self.includedItemsLabel
    )

    self.estimatedShippingStackView.addArrangedSubviews(
      self.estimatedShippingSeparator,
      self.estimatedShippingTitleLabel,
      self.estimatedShippingLabel
    )

    self.quantityLabelContainer.addSubview(self.quantityLabel)
    self.quantityLabel.constrainViewToMargins(in: self.quantityLabelContainer)

    self.stepperStackView.addArrangedSubviews(
      self.stepper,
      UIView(),
      self.quantityLabelContainer
    )
  }

  private func setupConstraints() {
    self.detailsStackView.translatesAutoresizingMaskIntoConstraints = false

    let pillsViewHeightConstraint = self.pillsView.heightAnchor.constraint(equalToConstant: 0)
    self.pillsViewHeightConstraint = pillsViewHeightConstraint

    let constraints = [
      self.addButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Styles.minTouchSize.height),
      self.stepperStackView.heightAnchor.constraint(equalTo: self.addButton.heightAnchor),
      self.includedItemsSeparator.heightAnchor.constraint(equalToConstant: 1),
      pillsViewHeightConstraint
    ]
    NSLayoutConstraint.activate(constraints)

    let aspectRatio: CGFloat = 1.5
    let rewardImageViewConstraint = self.rewardImageView.heightAnchor.constraint(
      equalTo: self.rewardImageView.widthAnchor,
      multiplier: 1.0 / aspectRatio
    )
    rewardImageViewConstraint.priority = UILayoutPriority(rawValue: 999)
    rewardImageViewConstraint.isActive = true
  }

  private func configurePillsView(_ pills: [String]) {
    let pillData = pills.map { text -> PillData in
      PillData(
        backgroundColor: LegacyColors.Tags.Warn.background.uiColor(),
        font: UIFont.ksr_footnote().bolded,
        margins: UIEdgeInsets(topBottom: Styles.gridHalf(2), leftRight: Styles.gridHalf(3)),
        text: text,
        textColor: LegacyColors.Tags.Warn.foreground.uiColor(),
        imageName: nil
      )
    }

    let data = PillsViewData(
      interimLineSpacing: Styles.grid(1),
      interimPillSpacing: Styles.grid(1),
      margins: .zero,
      pills: pillData
    )
    self.pillsView.configure(with: data)
  }

  internal func configure(with data: RewardAddOnCardViewData) {
    self.viewModel.inputs.configure(with: data)
    self.layoutIfNeeded()
  }

  @objc func addButtonTapped() {
    self.viewModel.inputs.addButtonTapped()
  }

  @objc func stepperValueChanged(_ stepper: UIStepper) {
    self.viewModel.inputs.stepperValueChanged(stepper.value)
  }
}
