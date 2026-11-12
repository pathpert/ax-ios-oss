import KDS
import Library
import UIKit

/// Used when PLOT is loading to show a shimmering loading view instead of an option title.
final class PledgePaymentPlanOptionLoadingView: UIView {
  private lazy var contentView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var titleLabelPlaceholder = { UILabel(frame: .zero) }()
  private lazy var fillSpacer = { UIView(frame: .zero) }()
  private lazy var selectorPlaceholder: UIImageView = { UIImageView(frame: .zero) }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configureSubviews()
    self.setupConstraints()
    self.startLoading()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureSubviews() {
    self.addSubview(self.contentView)

    // This text isn't shown, just used to make the label a sensible width.
    self.titleLabelPlaceholder.text = Strings.Pledge_in_full()
    self.titleLabelPlaceholder.textColor = .clear
    self.titleLabelPlaceholder.backgroundColor = .gray
    self.titleLabelPlaceholder.layer.masksToBounds = true

    self.selectorPlaceholder.image = Library.image(named: SelectionIndicatorImageName.unselected.rawValue)
    self.selectorPlaceholder.contentMode = .center

    self.contentView.spacing = PledgePaymentPlanOptionConstants.defaultPaddingSpacing
    self.contentView.alignment = .leading
    self.contentView.addArrangedSubview(self.selectorPlaceholder)
    self.contentView.addArrangedSubview(self.titleLabelPlaceholder)
    self.contentView.addArrangedSubview(self.fillSpacer)
    self.contentView.axis = .horizontal
  }

  private func setupConstraints() {
    self.contentView.translatesAutoresizingMaskIntoConstraints = false

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
      self.selectorPlaceholder.widthAnchor
        .constraint(equalToConstant: PledgePaymentPlanOptionConstants.selectionIndicatorImageWidth),
      self.selectorPlaceholder.heightAnchor.constraint(
        equalTo: self.titleLabelPlaceholder.heightAnchor,
        multiplier: 1.0
      )
    ])

    self.titleLabelPlaceholder.setContentCompressionResistancePriority(.required, for: .vertical)
    self.titleLabelPlaceholder.setContentHuggingPriority(.required, for: .vertical)
    self.titleLabelPlaceholder.setContentHuggingPriority(.required, for: .horizontal)
  }
}

extension PledgePaymentPlanOptionLoadingView: ShimmerLoading {
  func shimmerViews() -> [UIView] {
    return [self.titleLabelPlaceholder]
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.layoutGradientLayers()
    self.titleLabelPlaceholder.layer.cornerRadius = self.titleLabelPlaceholder.frame.height / 2
  }
}

