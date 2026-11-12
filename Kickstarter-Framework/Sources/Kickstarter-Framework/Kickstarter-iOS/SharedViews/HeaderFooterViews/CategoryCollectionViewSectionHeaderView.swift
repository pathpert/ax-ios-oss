import Foundation
import KDS
import Library
import Prelude
import UIKit

/// Collection view section header rendering a single-line category heading.
public final class CategoryCollectionViewSectionHeaderView: UICollectionReusableView {
  // MARK: - Properties

  private lazy var label: UILabel = { UILabel(frame: .zero) }()

  private let viewModel: CategoryCollectionViewSectionHeaderViewModelType =
    CategoryCollectionViewSectionHeaderViewModel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setupSubviews()
    self.bindViewModel()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with value: String) {
    self.viewModel.inputs.configure(with: value)
  }

  /// Configures margin padding and section header label styling.
  public override func bindStyles() {
    super.bindStyles()

    _ = self
      |> baseStyle

    _ = self.label
      |> labelStyle
  }

  /// Binds the ViewModel's `text` output to the header label.
  public override func bindViewModel() {
    super.bindViewModel()

    self.label.rac.text = self.viewModel.outputs.text
  }

  private func setupSubviews() {
    _ = (self.label, self)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToMarginsInParent(priority: .defaultHigh)

    self.label.setContentCompressionResistancePriority(.required, for: .vertical)
    self.label.setContentHuggingPriority(.required, for: .vertical)
  }
}

private let baseStyle: ViewStyle = { view in
  view
    |> \.layoutMargins .~ .init(
      top: Styles.grid(4),
      left: Styles.grid(3),
      bottom: Styles.grid(1),
      right: Styles.grid(3)
    )
    |> \.backgroundColor .~ .clear
}

private let labelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 1
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.font .~ UIFont.ksr_headline()
}
