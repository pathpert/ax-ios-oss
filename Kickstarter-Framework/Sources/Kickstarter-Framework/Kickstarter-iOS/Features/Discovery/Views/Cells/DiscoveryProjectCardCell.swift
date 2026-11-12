import Foundation
import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Table view cell rendering a full project discovery card with status pill, stats, facepile, and save button.
final class DiscoveryProjectCardCell: UITableViewCell, ValueCell {
  weak var delegate: DiscoveryPostcardCellDelegate?

  // MARK: - Properties

  lazy var backersCountLabel = { UILabel(frame: .zero) }()
  lazy var backersCountIconImageView = { UIImageView(frame: .zero) }()
  lazy var backersCountStackView = { UIStackView(frame: .zero) }()
  lazy var cardContainerView = { UIView(frame: .zero) }()
  lazy var facepileAvatarContainerView = { UIView(frame: .zero) }()
  var facepileAvatarImageViews: [UIImageView] = []
  lazy var facepileDescriptionLabel = { UILabel(frame: .zero) }()
  lazy var facepileStackView = { UIStackView(frame: .zero) }()
  lazy var goalMetIconImageView = { UIImageView(frame: .zero) }()
  lazy var goalPercentFundedStackView = { UIStackView(frame: .zero) }()
  lazy var percentFundedLabel = { UILabel(frame: .zero) }()
  let pillsViewContainer: UIView = UIView(frame: .zero)
  let pillsView: PillsView = PillsView(frame: .zero)
  var pillsViewHeightConstraint: NSLayoutConstraint?
  lazy var projectDetailsStackView = { UIStackView(frame: .zero) }()
  lazy var projectBlurbLabel = { UILabel(frame: .zero) }()
  lazy var projectImageView = { UIImageView(frame: .zero) }()
  // Stack view container for "percent funded" and "backer count" info
  lazy var projectInfoStackView = { UIStackView(frame: .zero) }()
  lazy var projectNameLabel = { UILabel(frame: .zero) }()
  lazy var projectStatusContainerView = { UIView(frame: .zero) }()
  lazy var projectStatusIconImageView = { UIImageView(frame: .zero) }()
  lazy var projectStatusLabel = { UILabel(frame: .zero) }()
  lazy var projectStatusStackView = { UIStackView(frame: .zero) }()
  lazy var rootStackView = { UIStackView(frame: .zero) }()
  lazy var saveButton = { UIButton(type: .custom) }()
  var tagsCollectionViewHeightConstraint: NSLayoutConstraint?
  lazy var youreABackerLabel = { UILabel(frame: .zero) }()
  lazy var youreABackerView = { UIView(frame: .zero) }()

  let viewModel: DiscoveryProjectCardViewModelType = DiscoveryProjectCardViewModel()
  let watchProjectViewModel: WatchProjectViewModelType = WatchProjectViewModel()

  // MARK: - Notification Observers

  private var projectSavedObserver: Any?
  private var sessionEndedObserver: Any?
  private var sessionStartedObserver: Any?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.configureSubviews()
    self.setupConstraints()
    self.addShadowLayers()
    self.configureWatchProjectObservers()

    self.bindStyles()
    self.bindViewModel()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    [
      self.projectSavedObserver,
      self.sessionEndedObserver,
      self.sessionStartedObserver
    ]
    .forEach { $0.doIfSome(NotificationCenter.default.removeObserver) }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    self.updateShadowLayerPaths()
  }

  /// Configures the cell with a discovery project row value and updates pills height.
  func configureWith(value: DiscoveryProjectCellRowValue) {
    self.viewModel.inputs.configure(with: value)

    self.watchProjectViewModel.inputs.configure(with: WatchProjectValue(
      project: value.project,
      context: KSRAnalytics.PageContext.discovery,
      discoveryParams: value.params
    ))

    self.pillsViewHeightConstraint?.constant = self.pillsView.intrinsicContentSize.height
  }

  override func bindStyles() {
    super.bindStyles()

    _ = self |> \.selectionStyle .~ .none

    _ = self.contentView
      |> discoveryCardContentViewStyle
      |> \.layoutMargins %~~ { _, cell in
        cell.traitCollection.isRegularRegular ?
          .init(top: Styles.grid(1), left: Styles.grid(30), bottom: Styles.grid(1), right: Styles.grid(30)) :
          .init(top: Styles.grid(1), left: Styles.grid(2), bottom: Styles.grid(1), right: Styles.grid(2))
      }

    _ = self.rootStackView
      |> verticalStackViewStyle
      |> \.spacing .~ 0

    styleDiscoverySaveButton(self.saveButton)

    _ = self.cardContainerView |> discoveryCardContainerViewStyle
    _ = self.projectImageView |> discoveryCardProjectImageViewStyle
    _ = self.projectDetailsStackView |> discoveryCardProjectDetailsStackViewStyle
    _ = self.projectStatusContainerView |> discoveryCardStatusContainerViewStyle

    _ = self.projectStatusStackView
      |> adaptableStackViewStyle(self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory)
      |> \.spacing .~ Styles.grid(1)
      |> \.alignment %~ { _ in
        self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? .leading : .center
      }

    _ = self.projectStatusIconImageView |> discoveryCardProjectStatusIconImageStyle
    _ = self.projectNameLabel |> discoveryCardProjectNameLabelStyle
    _ = self.projectBlurbLabel |> discoveryCardProjectBlurbLabelStyle

    _ = self.percentFundedLabel
      |> discoveryCardPercentFundedLabelStyle
      |> UIView.lens.contentCompressionResistancePriority(for: .horizontal) .~ .defaultLow

    _ = self.backersCountLabel |> discoveryCardBackersCountLabelStyle
    _ = self.projectStatusLabel |> discoveryCardProjectStatusLabelStyle
    _ = self.facepileDescriptionLabel |> discoveryCardFacepileDescriptionLabelStyle
    _ = self.backersCountStackView |> discoveryCardInfoStackViewStyle
    _ = self.goalPercentFundedStackView |> discoveryCardInfoStackViewStyle
    _ = self.goalMetIconImageView |> discoveryCardGoalMetIconImageViewStyle
    _ = self.backersCountIconImageView |> discoveryCardBackersCountIconImageViewStyle

    _ = self.projectInfoStackView
      |> adaptableStackViewStyle(self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory)
      |> discoveryCardProjectInfoStackViewStyle

    _ = self.facepileStackView |> discoveryCardFacepileStackViewStyle
    _ = self.pillsViewContainer |> \.layoutMargins .~ (UIEdgeInsets.zero |> UIEdgeInsets.lens.top .~ Styles.grid(1))
    _ = self.youreABackerView |> discoveryCardYoureABackerViewStyle
    _ = self.youreABackerLabel |> discoveryCardYoureABackerLabelStyle
  }

  /// Registers session and save-state notification observers and button targets.
  func configureWatchProjectObservers() {
    self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
    self.saveButton.addTarget(self, action: #selector(self.saveButtonPressed(_:)), for: .touchDown)

    self.sessionStartedObserver = NotificationCenter.default
      .addObserver(forName: Notification.Name.ksr_sessionStarted, object: nil, queue: nil) { [weak self] _ in
        self?.watchProjectViewModel.inputs.userSessionStarted()
      }

    self.sessionEndedObserver = NotificationCenter.default
      .addObserver(forName: Notification.Name.ksr_sessionEnded, object: nil, queue: nil) { [weak self] _ in
        self?.watchProjectViewModel.inputs.userSessionEnded()
      }

    self.projectSavedObserver = NotificationCenter.default
      .addObserver(forName: Notification.Name.ksr_projectSaved, object: nil, queue: nil) { [weak self] notification in
        self?.watchProjectViewModel.inputs.projectFromNotification(
          project: notification.userInfo?["project"] as? Project
        )
      }

    self.watchProjectViewModel.inputs.awakeFromNib()
  }

  // MARK: - Accessors

  @objc func saveButtonPressed(_: UIButton) {
    self.watchProjectViewModel.inputs.saveButtonTouched()
  }

  @objc func saveButtonTapped(_ button: UIButton) {
    self.watchProjectViewModel.inputs.saveButtonTapped(selected: button.isSelected)
  }
}
