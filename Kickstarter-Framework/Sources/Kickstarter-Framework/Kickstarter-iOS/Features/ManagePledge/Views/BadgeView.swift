import KDS
import Library
import UIKit

private enum Constants {
  /// Top and bottom vertical padding inside the badge pill.
  public static let badgeTopButtonPadding = 6.0
  /// Leading and trailing horizontal padding inside the badge pill.
  public static let badgeLeadingTrailingPadding = Spacing.unit_02
  /// Default horizontal spacing between the badge icon and label.
  public static let defaultStackViewSpacing = Styles.grid(1)

  /// Default corner radius applied to the rounded badge container.
  public static let defaultCornerRadius = Styles.grid(1)
}

final class BadgeView: UIView {
  // MARK: - Properties

  private lazy var rootStackView: UIStackView = { UIStackView(frame: .zero) }()
  private var imageView: UIImageView?
  private lazy var badgeLabel: UILabel = { UILabel(frame: .zero) }()
  private var style: BadgeStyle = .success

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configureSubviews()
    self.bindStyles()
    self.setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration

  private func configureSubviews() {
    self.addSubview(self.rootStackView)

    self.rootStackView.addArrangedSubview(self.badgeLabel)
  }

  private func setupConstraints() {
    self.rootStackView.translatesAutoresizingMaskIntoConstraints = false

    self.badgeLabel.setContentHuggingPriority(.required, for: .horizontal)
    self.badgeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    self.badgeLabel.setContentHuggingPriority(.required, for: .vertical)
    self.badgeLabel.setContentCompressionResistancePriority(.required, for: .vertical)

    NSLayoutConstraint.activate([
      self.rootStackView.topAnchor.constraint(
        equalTo: self.topAnchor,
        constant: Constants.badgeTopButtonPadding
      ),
      self.rootStackView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor,
        constant: -Constants.badgeTopButtonPadding
      ),
      self.rootStackView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: Constants.badgeLeadingTrailingPadding
      ),
      self.rootStackView.trailingAnchor.constraint(
        equalTo: self.trailingAnchor,
        constant: -Constants.badgeLeadingTrailingPadding
      )
    ])
  }

  /// Configures the badge text, optional leading icon, and visual semantic style.
  /// - Parameters:
  ///   - text: Display text rendered inside the badge label.
  ///   - image: Optional leading icon image, or `nil` for text-only badges.
  ///   - style: Semantic `BadgeStyle` controlling foreground and background colors.
  /// - Negative Constraint: Do not use for interactive buttons; this view is display-only.
  public func configure(with text: String, image: UIImage? = nil, style: BadgeStyle = .success) {
    self.badgeLabel.text = text
    self.style = style

    if let image = image {
      // Allow image and text to be of different heights.
      self.rootStackView.alignment = .center
      self.imageViewSetup(image)
    } else {
      // If there's no image, prevent the stack view from stretching.
      self.rootStackView.alignment = .fill
    }

    self.updateStyle()
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    applyRootStackViewStyle(self.rootStackView)
    applyBadgeViewStyle(self)
    applyBadgeLabelStyle(self.badgeLabel)
    self.updateStyle()
  }

  private func updateStyle() {
    self.badgeLabel.textColor = self.style.foregroundColor
    self.backgroundColor = self.style.backgroundColor
    self.imageView?.tintColor = self.style.foregroundColor
  }

  private func imageViewSetup(_ image: UIImage) {
    guard self.imageView == nil else { return }

    self.imageView = UIImageView(image: image)
    self.rootStackView.insertArrangedSubview(self.imageView!, at: 0)

    applyImageViewStyle(self.imageView!)
  }
}

private func applyRootStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .horizontal
  stackView.spacing = Styles.grid(1)
}

private func applyBadgeViewStyle(_ view: UIView) {
  view.rounded(with: Constants.defaultCornerRadius)
}

private func applyBadgeLabelStyle(_ label: UILabel) {
  label.font = UIFont.ksr_caption1().bolded
  label.textAlignment = .center
  label.numberOfLines = 1
  label.adjustsFontForContentSizeCategory = true
}

private func applyImageViewStyle(_ imageView: UIImageView) {
  imageView.contentMode = .scaleAspectFit
  imageView.setContentHuggingPriority(.required, for: .horizontal)
  imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
  imageView.setContentHuggingPriority(.required, for: .vertical)
  imageView.setContentCompressionResistancePriority(.required, for: .vertical)
}
