import KDS
import Library
import Prelude
import UIKit

extension DiscoveryProjectCardCell {
  /// Builds the view hierarchy inside the discovery card cell.
  func configureSubviews() {
    _ = (self.cardContainerView, self.contentView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToMarginsInParent()

    _ = (self.rootStackView, self.cardContainerView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = (self.pillsView, self.pillsViewContainer)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToMarginsInParent()

    _ = ([self.projectImageView, self.projectDetailsStackView], self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = (self.saveButton, self.cardContainerView)
      |> ksr_addSubviewToParent()

    _ = (self.projectStatusContainerView, self.cardContainerView)
      |> ksr_addSubviewToParent()

    _ = (self.youreABackerView, self.cardContainerView)
      |> ksr_addSubviewToParent()

    _ = (self.youreABackerLabel, self.youreABackerView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToMarginsInParent()

    _ = (self.projectStatusStackView, self.projectStatusContainerView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToMarginsInParent()

    _ = ([self.projectStatusIconImageView, self.projectStatusLabel], self.projectStatusStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.facepileAvatarContainerView, self.facepileDescriptionLabel], self.facepileStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([
      self.projectNameLabel,
      self.projectBlurbLabel,
      self.projectInfoStackView,
      self.facepileStackView,
      self.pillsViewContainer
    ], self.projectDetailsStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.goalMetIconImageView, self.percentFundedLabel], self.goalPercentFundedStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.backersCountIconImageView, self.backersCountLabel], self.backersCountStackView)
      |> ksr_addArrangedSubviewsToStackView()

    let spacer = UIView(frame: .zero)
      |> UIView.lens.contentHuggingPriority(for: .horizontal) .~ UILayoutPriority(rawValue: 249)

    _ = (
      [self.goalPercentFundedStackView, self.backersCountStackView, spacer],
      self.projectInfoStackView
    )
      |> ksr_addArrangedSubviewsToStackView()
  }

  /// Activates Auto Layout constraints for the card image, overlays, and pill tags.
  func setupConstraints() {
    _ = [
      self.rootStackView,
      self.projectImageView,
      self.projectStatusContainerView,
      self.youreABackerView,
      self.goalMetIconImageView,
      self.backersCountIconImageView,
      self.saveButton,
      self.pillsView
    ]
      ||> \.translatesAutoresizingMaskIntoConstraints .~ false

    let aspectRatio = CGFloat(9.0 / 16.0)

    let pillsViewHeightConstraint = self.pillsView.heightAnchor.constraint(equalToConstant: 0)
    self.pillsViewHeightConstraint = pillsViewHeightConstraint

    NSLayoutConstraint.activate([
      pillsViewHeightConstraint,
      self.projectImageView.widthAnchor.constraint(equalTo: self.cardContainerView.widthAnchor),
      self.projectImageView.heightAnchor.constraint(
        equalTo: self.projectImageView.widthAnchor,
        multiplier: aspectRatio
      ),
      self.youreABackerView.centerYAnchor.constraint(
        equalTo: self.projectImageView.bottomAnchor,
        constant: -Styles.grid(1)
      ),
      self.youreABackerView.leftAnchor.constraint(
        equalTo: self.cardContainerView.leftAnchor,
        constant: Styles.grid(3)
      ),
      self.saveButton.topAnchor.constraint(
        equalTo: self.cardContainerView.topAnchor,
        constant: Styles.grid(2)
      ),
      self.saveButton.rightAnchor.constraint(
        equalTo: self.cardContainerView.rightAnchor,
        constant: -Styles.grid(2)
      ),
      self.projectStatusContainerView.topAnchor.constraint(
        equalTo: self.cardContainerView.topAnchor,
        constant: Styles.grid(2)
      ),
      self.projectStatusContainerView.leftAnchor.constraint(
        equalTo: self.cardContainerView.leftAnchor,
        constant: Styles.grid(2)
      ),
      self.projectStatusContainerView.rightAnchor.constraint(
        lessThanOrEqualTo: self.saveButton.leftAnchor,
        constant: -Styles.grid(2)
      ),
      self.projectStatusContainerView.bottomAnchor
        .constraint(
          lessThanOrEqualTo: self.projectDetailsStackView.topAnchor,
          constant: -Styles.grid(2)
        )
    ])
  }

  /// Inserts drop-shadow shape layers behind the status badge and save button.
  func addShadowLayers() {
    let projectStatusShadowLayer = CAShapeLayer()
      |> \.fillColor .~ LegacyColors.ksr_white.uiColor(opacity: 0.95).cgColor
      |> \.shadowColor .~ LegacyColors.ksr_black.uiColor().cgColor
      |> \.shadowOpacity .~ 0.15
      |> \.shadowRadius .~ 4
      |> \.shadowOffset .~ CGSize(width: 0, height: 1)

    projectStatusShadowLayer.shadowPath = projectStatusShadowLayer.path
    self.projectStatusContainerView.layer.insertSublayer(projectStatusShadowLayer, at: 0)

    let saveButtonShadowLayer = CAShapeLayer()
      |> \.fillColor .~ LegacyColors.ksr_white.uiColor(opacity: 0.95).cgColor
      |> \.shadowColor .~ LegacyColors.ksr_black.uiColor().cgColor
      |> \.shadowOpacity .~ 0.15
      |> \.shadowRadius .~ 4
      |> \.shadowOffset .~ CGSize(width: 0, height: 1)

    saveButtonShadowLayer.shadowPath = saveButtonShadowLayer.path
    self.saveButton.layer.insertSublayer(saveButtonShadowLayer, at: 0)
  }

  /// Updates shadow paths after bounds changes during layout passes.
  func updateShadowLayerPaths() {
    if let projectStatusShadowLayer = self.projectStatusContainerView.layer.sublayers?[0] as? CAShapeLayer {
      projectStatusShadowLayer.path = UIBezierPath(
        roundedRect: self.projectStatusContainerView.bounds,
        cornerRadius: Styles.grid(1)
      ).cgPath
    }

    if let saveButtonShadowLayer = self.saveButton.layer.sublayers?
      .first(where: { $0 is CAShapeLayer }) as? CAShapeLayer {
      let cornerRadius = self.saveButton.bounds.width / 2

      saveButtonShadowLayer.path = UIBezierPath(
        roundedRect: self.saveButton.bounds,
        cornerRadius: cornerRadius
      ).cgPath

      if let imageView = self.saveButton.imageView {
        self.saveButton.bringSubviewToFront(imageView)
      }
    }
  }
}

