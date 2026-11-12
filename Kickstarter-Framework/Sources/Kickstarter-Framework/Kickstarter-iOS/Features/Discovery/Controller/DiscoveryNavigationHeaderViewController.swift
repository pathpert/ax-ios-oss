import KDS
import KsApi
import Library
import Prelude
import Prelude_UIKit
import UIKit

internal protocol DiscoveryNavigationHeaderViewDelegate: AnyObject {
  /// Call to update params when filter selected.
  func discoveryNavigationHeaderFilterSelectedParams(_ params: DiscoveryParams)
}

internal final class DiscoveryNavigationHeaderViewController: UIViewController {
  internal let viewModel: DiscoveryNavigationHeaderViewModelType = DiscoveryNavigationHeaderViewModel()

  @IBOutlet internal var arrowImageView: UIImageView!
  @IBOutlet fileprivate var betaToolsButton: UIButton!
  @IBOutlet fileprivate var bgView: UIView!
  @IBOutlet internal var bookmarkImageView: UIImageView!
  @IBOutlet internal var bookmarkOutlineImageView: UIImageView!
  @IBOutlet fileprivate var debugContainerView: UIView!
  @IBOutlet fileprivate var debugImageView: UIImageView!
  @IBOutlet fileprivate var dividerLabel: UILabel!
  @IBOutlet fileprivate var exploreLabel: UILabel!
  @IBOutlet fileprivate var favoriteButton: UIButton!
  @IBOutlet fileprivate var favoriteContainerView: UIView!
  @IBOutlet fileprivate var primaryLabel: UILabel!
  @IBOutlet fileprivate var secondaryLabel: UILabel!
  @IBOutlet fileprivate var titleButton: UIButton!
  @IBOutlet fileprivate var containerStackView: UIStackView!
  @IBOutlet fileprivate var outerStackViewTopConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate var titleStackView: UIStackView! {
    didSet {
      self.titleStackView.pinBackground()
    }
  }

  internal weak var delegate: DiscoveryNavigationHeaderViewDelegate?

  internal static func instantiate() -> DiscoveryNavigationHeaderViewController {
    return Storyboard.Discovery.instantiate(DiscoveryNavigationHeaderViewController.self)
  }

  internal func configureWith(params: DiscoveryParams) {
    self.viewModel.inputs.configureWith(params: params)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.betaToolsButton.addTarget(
      self,
      action: #selector(DiscoveryNavigationHeaderViewController.betaToolsButtonTapped),
      for: .touchUpInside
    )

    self.favoriteButton.addTarget(
      self,
      action: #selector(DiscoveryNavigationHeaderViewController.favoriteButtonTapped),
      for: .touchUpInside
    )

    self.titleButton.addTarget(
      self,
      action: #selector(DiscoveryNavigationHeaderViewController.titleButtonTapped),
      for: .touchUpInside
    )

    self.viewModel.inputs.viewDidLoad()

    // Initial style
    self.primaryLabel.font = self.traitCollection.isRegularRegular
      ? UIFont.ksr_body(size: 18)
      : UIFont.ksr_body(size: 17)
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.debugContainerView.rac.hidden = self.viewModel.outputs.debugContainerViewIsHidden
    self.exploreLabel.rac.hidden = self.viewModel.outputs.exploreLabelIsHidden
    self.favoriteContainerView.rac.hidden = self.viewModel.outputs.favoriteViewIsHidden
    self.favoriteButton.rac.accessibilityLabel = self.viewModel.outputs.favoriteButtonAccessibilityLabel
    self.primaryLabel.rac.text = self.viewModel.outputs.primaryLabelText
    self.secondaryLabel.rac.text = self.viewModel.outputs.secondaryLabelText
    self.secondaryLabel.rac.hidden = self.viewModel.outputs.secondaryLabelIsHidden
    self.dividerLabel.rac.hidden = self.viewModel.outputs.dividerIsHidden
    self.titleButton.rac.accessibilityLabel = self.viewModel.outputs.titleButtonAccessibilityLabel
    self.titleButton.rac.accessibilityHint = self.viewModel.outputs.titleButtonAccessibilityHint

    self.viewModel.outputs.primaryLabelOpacityAnimated
      .observeForUI()
      .observeValues { [weak self] alpha, animated in
        UIView.animate(
          withDuration: animated ? 0.2 : 0.0, delay: 0.0, options: .curveEaseOut, animations: {
            self?.primaryLabel.alpha = alpha
          },
          completion: nil
        )
      }

    self.viewModel.outputs.arrowOpacityAnimated
      .observeForUI()
      .observeValues { [weak self] alpha, animated in
        UIView.animate(
          withDuration: animated ? 0.2 : 0.0, delay: 0.0, options: .curveEaseOut, animations: {
            self?.arrowImageView.alpha = alpha
          },
          completion: nil
        )
      }

    self.viewModel.outputs.primaryLabelFont
      .observeForUI()
      .observeValues { [weak self] isBold in
        guard let label = self?.primaryLabel else { return }

        _ = label
          |> UILabel.lens.font %~~ { _, label in
            label.traitCollection.isRegularRegular
              ? isBold ? UIFont.ksr_body(size: 18).bolded : UIFont.ksr_body(size: 18)
              : isBold ? UIFont.ksr_callout().bolded : UIFont.ksr_callout()
          }
      }

    self.viewModel.outputs.animateArrowToDown
      .observeForUI()
      .observeValues { [weak self] in
        self?.animateArrow(toDown: $0)
      }

    self.viewModel.outputs.updateFavoriteButton
      .observeForUI()
      .observeValues { [weak self] in
        self?.updateFavoriteButton(selected: $0, animated: $1)
      }

    self.viewModel.outputs.notifyDelegateFilterSelectedParams
      .observeForUI()
      .observeValues { [weak self] in
        self?.delegate?.discoveryNavigationHeaderFilterSelectedParams($0)
      }

    self.viewModel.outputs.showDiscoveryFilters
      .observeForControllerAction()
      .observeValues { [weak self] in
        self?.showDiscoveryFilters(selectedRow: $0)
      }

    self.viewModel.outputs.dismissDiscoveryFilters
      .observeForControllerAction()
      .observeValues { [weak self] in
        self?.dismiss(animated: false, completion: nil)
      }

    self.viewModel.outputs.showFavoriteOnboardingAlert
      .observeForUI()
      .observeValues { [weak self] in
        self?.showFavoriteCategoriesAlert(categoryName: $0)
      }

    self.viewModel.outputs.favoriteViewIsDimmed
      .observeForUI()
      .observeValues { [weak self] isDimmed in
        UIView.animate(
          withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self?.favoriteContainerView.alpha = isDimmed ? 0.4 : 1.0
          },
          completion: nil
        )
      }

    self.viewModel.outputs.debugImageViewIsDimmed
      .observeForUI()
      .observeValues { [weak self] isDimmed in
        _ = self?.debugImageView
          ?|> \.tintAdjustmentMode .~ (isDimmed ? .dimmed : .normal)
      }
  }

  internal override func bindStyles() {
    super.bindStyles()

    _ = self.arrowImageView
      |> UIView.lens.tintColor .~ discoveryPrimaryColor()

    _ = self.bgView
      |> UIView.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.dividerLabel
      |> discoveryNavDividerLabelStyle
      |> UILabel.lens.isAccessibilityElement .~ false
      |> UILabel.lens.textColor .~ discoveryPrimaryColor()

    _ = self.exploreLabel
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()
      |> UILabel.lens.font %~~ { _, label in
        label.traitCollection.isRegularRegular
          ? .ksr_body(size: 18)
          : .ksr_body(size: 17)
      }
      |> UILabel.lens.text %~ { _ in Strings.Explore() }

    _ = self.favoriteContainerView
      |> UIView.lens.layoutMargins .~ .init(left: Styles.grid(2))

    _ = self.bookmarkImageView
      |> UIView.lens.tintColor .~ discoveryPrimaryColor()

    _ = self.bookmarkOutlineImageView
      |> UIView.lens.tintColor .~ discoveryPrimaryColor()

    _ = self.debugImageView
      |> UIImageView.lens.image .~ image(named: "icon--debug")

    _ = self.primaryLabel
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
      |> UILabel.lens.isAccessibilityElement .~ false
      |> UILabel.lens.textColor .~ discoveryPrimaryColor()

    _ = self.secondaryLabel
      |> UILabel.lens.font %~~ { _, label in
        label.traitCollection.isRegularRegular
          ? UIFont.ksr_body(size: 18).bolded
          : UIFont.ksr_callout().bolded
      }
      |> UILabel.lens.isAccessibilityElement .~ false
      |> UILabel.lens.textColor .~ discoveryPrimaryColor()

    _ = self.containerStackView
      |> discoveryNavTitleStackViewStyle

    if self.view.traitCollection.isRegularRegular {
      self.outerStackViewTopConstraint.constant = -6.0
    }
  }
}
