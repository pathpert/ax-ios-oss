import KDS
import KsApi
import Library
import Prelude
import UIKit

/// `ProjectNavigationSelectorView` extensions declared in `ProjectNavigationSelectorView+Helpers.swift`.
extension ProjectNavigationSelectorView {
  internal func pinSelectedButtonBorderView(toIndex index: Int) {
    guard let navigationSection = NavigationSection(rawValue: index),
          let button = self.buttonsStackView.arrangedSubviews.first(where: { $0.tag == index }),
          let buttonSection = NavigationSection(rawValue: button.tag),
          buttonSection == navigationSection else { return }

    let leadingConstant = button.frame.origin.x - safeAreaInsets.left

    // The value of the constraint is originally set to the width of the first button so we have subtract this each time we want to calculate the constant
    let widthConstant = button.frame.width - self.buttonsStackView.arrangedSubviews[0].frame
      .width

    UIView.animate(
      withDuration: 0.3,
      delay: 0.0,
      options: .curveEaseOut,
      animations: {
        self.contentView.setNeedsLayout()
        self.selectedButtonBorderViewLeadingConstraint?.constant = leadingConstant
        self.selectedButtonBorderViewWidthConstraint?.constant = widthConstant
        self.contentView.layoutIfNeeded()
      }
    )

    let origin = CGPoint(
      x: button.frame
        .minX,
      y: 0.0
    )
    let size = CGSize(
      width: button.frame.size
        .width,
      height: 1.0
    )
    let scrollToRect = CGRect(
      origin: origin,
      size: size
    )

    self.scrollView.scrollRectToVisible(scrollToRect, animated: true)
  }

  internal func selectButton(atIndex index: Int) {
    let indexSection = NavigationSection(rawValue: index)

    for button in self.buttonsStackView.arrangedSubviews {
      let navigationSection = NavigationSection(rawValue: button.tag)
      let validNavigationSection = navigationSection != nil

      let isButtonSelected = validNavigationSection ? navigationSection == indexSection : false
      let buttonSelectedFont = isButtonSelected ? UIFont.ksr_footnote().weighted(.bold) : UIFont
        .ksr_footnote().weighted(.semibold)

      _ = (button as? UIButton)
        ?|> UIButton.lens.isSelected .~ isButtonSelected
        ?|> UIButton.lens.titleLabel.font .~ buttonSelectedFont
    }
  }
}

// MARK: - Styles

internal let projectNavigationSelectedButtonBorderViewStyle: ViewStyle = { view in
  view
    |> \.backgroundColor .~ LegacyColors.Project.Navigation.selected.uiColor()
}

internal let projectNavigationRootStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.axis .~ NSLayoutConstraint.Axis.horizontal
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.layoutMargins .~ UIEdgeInsets(
      top: Styles.grid(0),
      left: Styles.grid(0),
      bottom: Styles.grid(1),
      right: Styles.grid(0)
    )
    |> \.spacing .~ Styles.grid(2)
}

