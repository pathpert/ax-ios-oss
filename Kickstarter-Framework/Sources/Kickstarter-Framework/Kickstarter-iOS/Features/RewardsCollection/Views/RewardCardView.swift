import KDS
import KsApi
import Library
import ReactiveSwift
import UIKit

protocol RewardCardViewDelegate: AnyObject {
  func rewardCardView(_ rewardCardView: RewardCardView, didTapWithRewardId rewardId: Int)
}

/// Card view displaying a project reward's price, title, description, included items, shipping, and badge pills.
public final class RewardCardView: UIView {
  weak var delegate: RewardCardViewDelegate?
  private let viewModel: RewardCardViewModelType = RewardCardViewModel()

  let rootStackView = UIStackView(frame: .zero)
  let detailsStackView = UIStackView(frame: .zero)
  let rewardImageView = UIImageView(frame: .zero)
  let rewardBadgeView = BadgeView(frame: .zero)
  let descriptionLabel = UILabel(frame: .zero)
  let descriptionStackView = UIStackView(frame: .zero)
  let estimatedDeliveryStackView = UIStackView(frame: .zero)
  let estimatedDeliveryTitleLabel = UILabel(frame: .zero)
  let estimatedDeliveryDateLabel = UILabel(frame: .zero)
  let includedItemsStackView = UIStackView(frame: .zero)
  let includedItemsTitleLabel = UILabel(frame: .zero)
  let minimumPriceConversionLabel = UILabel(frame: .zero)
  let minimumPriceLabel = UILabel(frame: .zero)
  let pillsView = PillsView(frame: .zero)
  var pillsViewHeightConstraint: NSLayoutConstraint?
  let priceStackView = UIStackView(frame: .zero)
  let rewardLocationStackView = UIStackView(frame: .zero)
  let rewardLocationTitleLabel = UILabel(frame: .zero)
  let rewardLocationPickupLabel = UILabel(frame: .zero)
  let rewardTitleLabel = UILabel(frame: .zero)
  let titleStackView = UIStackView(frame: .zero)
  let estimatedShippingStackView = UIStackView(frame: .zero)
  let estimatedShippingTitleLabel = UILabel(frame: .zero)
  let estimatedShippingLabel = UILabel(frame: .zero)

  override init(frame: CGRect) {
    super.init(frame: frame)

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

  /// Binds `RewardCardViewModel` outputs to labels, stack visibility, images, pills, and selection callbacks.
  public override func bindViewModel() {
    super.bindViewModel()

    self.minimumPriceConversionLabel.rac.hidden = self.viewModel.outputs.conversionLabelHidden
    self.minimumPriceConversionLabel.rac.text = self.viewModel.outputs.conversionLabelText
    self.descriptionLabel.rac.text = self.viewModel.outputs.descriptionLabelText
    self.estimatedShippingStackView.rac.hidden = self.viewModel.outputs.estimatedShippingStackViewHidden
    self.estimatedDeliveryStackView.rac.hidden = self.viewModel.outputs.estimatedDeliveryStackViewHidden
    self.estimatedDeliveryDateLabel.rac.text = self.viewModel.outputs.estimatedDeliveryDateLabelText
    self.rewardLocationStackView.rac.hidden = self.viewModel.outputs.rewardLocationStackViewHidden
    self.rewardLocationPickupLabel.rac.text = self.viewModel.outputs.rewardLocationPickupLabelText
    self.includedItemsStackView.rac.hidden = self.viewModel.outputs.includedItemsStackViewHidden
    self.minimumPriceLabel.rac.text = self.viewModel.outputs.rewardMinimumLabelText
    self.pillsView.rac.hidden = self.viewModel.outputs.pillCollectionViewHidden
    self.rewardTitleLabel.rac.hidden = self.viewModel.outputs.rewardTitleLabelHidden
    self.rewardTitleLabel.rac.attributedText = self.viewModel.outputs.rewardTitleLabelAttributedText
    self.rewardImageView.rac.hidden = self.viewModel.outputs.rewardImageHidden

    self.viewModel.outputs.items
      .observeForUI()
      .observeValues { [weak self] in self?.load(items: $0) }

    self.viewModel.outputs.rewardSelected
      .observeForUI()
      .observeValues { [weak self] rewardId in
        guard let self = self else { return }
        self.delegate?.rewardCardView(self, didTapWithRewardId: rewardId)
      }

    self.viewModel.outputs.cardUserInteractionIsEnabled
      .observeForUI()
      .observeValues { [weak self] isUserInteractionEnabled in
        self?.isUserInteractionEnabled = isUserInteractionEnabled
      }

    self.viewModel.outputs.reloadPills
      .observeForUI()
      .observeValues { [weak self] values in self?.configurePillsView(values) }

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

    self.viewModel.outputs.rewardBadge
      .observeForUI()
      .observeValues { [weak rewardBadgeView] data in
        guard let data else {
          rewardBadgeView?.isHidden = true
          return
        }

        rewardBadgeView?.configure(with: data.text, image: data.image, style: data.badgeStyle)
        rewardBadgeView?.isHidden = false
      }
  }

  private func configureViews() {
    self.addSubview(self.rootStackView)
    self.rootStackView.constrainViewToEdges(in: self)
    self.rootStackView.addArrangedSubviews(self.rewardImageView, self.detailsStackView)
    self.addSubview(self.rewardBadgeView)
    self.rewardImageView.isHidden = true

    self.detailsStackView.addArrangedSubviews(
      self.titleStackView,
      self.rewardTitleLabel,
      self.descriptionStackView,
      self.includedItemsStackView,
      self.estimatedShippingStackView,
      self.estimatedDeliveryStackView,
      self.rewardLocationStackView,
      self.pillsView
    )

    self.priceStackView.addArrangedSubviews(self.minimumPriceLabel, self.minimumPriceConversionLabel)
    self.includedItemsStackView.addArrangedSubview(self.includedItemsTitleLabel)
    self.estimatedShippingStackView.addArrangedSubviews(
      self.estimatedShippingTitleLabel,
      self.estimatedShippingLabel
    )
    self.estimatedDeliveryStackView.addArrangedSubviews(
      self.estimatedDeliveryTitleLabel,
      self.estimatedDeliveryDateLabel
    )
    self.rewardLocationStackView.addArrangedSubviews(
      self.rewardLocationTitleLabel,
      self.rewardLocationPickupLabel
    )
    self.descriptionStackView.addArrangedSubview(self.descriptionLabel)
    self.titleStackView.addArrangedSubview(self.priceStackView)

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.rewardCardTapped))
    self.addGestureRecognizer(tapGestureRecognizer)
  }

  private func setupConstraints() {
    self.detailsStackView.translatesAutoresizingMaskIntoConstraints = false

    let pillsViewHeightConstraint = self.pillsView.heightAnchor.constraint(equalToConstant: 0)
    self.pillsViewHeightConstraint = pillsViewHeightConstraint
    NSLayoutConstraint.activate([pillsViewHeightConstraint])

    let aspectRatio: CGFloat = 1.5
    let constraint = self.rewardImageView.heightAnchor.constraint(
      equalTo: self.rewardImageView.widthAnchor,
      multiplier: 1.0 / aspectRatio
    )
    constraint.priority = UILayoutPriority(rawValue: 999)
    constraint.isActive = true

    self.rewardBadgeView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.rewardBadgeView.bottomAnchor.constraint(
        equalTo: self.detailsStackView.topAnchor,
        constant: Styles.grid(2)
      ),
      self.rewardBadgeView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: Styles.grid(3)
      )
    ])
  }

  private func configurePillsView(_ pills: [RewardCardPillData]) {
    let pillData = pills.map { rewardCardPillData -> PillData in
      PillData(
        backgroundColor: rewardCardPillData.backgroundColor,
        font: UIFont.ksr_footnote().bolded,
        margins: UIEdgeInsets(topBottom: Styles.gridHalf(2), leftRight: Styles.gridHalf(3)),
        text: rewardCardPillData.text,
        textColor: rewardCardPillData.textColor,
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

  internal func configure(with data: RewardCardViewData) {
    self.viewModel.inputs.configure(with: data)
  }

  @objc func rewardCardTapped() {
    self.viewModel.inputs.rewardCardTapped()
  }
}
