import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Contract defining `PledgeCTAContainerViewDelegate` capabilities and boundaries.
protocol PledgeCTAContainerViewDelegate: AnyObject {
  func pledgeCTAButtonTapped(with state: PledgeStateCTAType)
}

private enum Layout {
  enum Button {
    static let minHeight: CGFloat = 48.0
    static let minWidth: CGFloat = 98.0
  }

  enum RetryButton {
    static let minWidth: CGFloat = 120.0
  }
}

final class PledgeCTAContainerView: UIView {
  lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(frame: .zero)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.startAnimating()
    return indicator
  }()

  lazy var activityIndicatorContainerView: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private(set) lazy var pledgeCTAButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true // Default to hidden until data is ready.
    return button
  }()

  private(set) lazy var retryButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var retryDescriptionLabel: UILabel = { UILabel(frame: .zero) }()

  lazy var retryStackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.isHidden = true // Default to hidden until data is ready.
    return stackView
  }()

  lazy var rootStackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var spacer: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var subtitleLabel: UILabel = { UILabel(frame: .zero) }()
  lazy var watchesLabel: UILabel = { UILabel(frame: .zero) }()

  lazy var titleAndSubtitleStackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var pledgeButtonAndWatchesStackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var titleLabel: UILabel = { UILabel(frame: .zero) }()
  private var projectSavedObserver: Any?

  weak var delegate: PledgeCTAContainerViewDelegate?
  private let viewModel: PledgeCTAContainerViewViewModelType = PledgeCTAContainerViewViewModel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configureSubviews()
    self.setupConstraints()
    self.bindViewModel()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.projectSavedObserver.doIfSome(NotificationCenter.default.removeObserver)
  }

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.notifyDelegateCTATapped
      .observeForUI()
      .observeValues { [weak self] state in self?.delegate?.pledgeCTAButtonTapped(with: state) }

    self.viewModel.outputs.buttonStyleType
      .observeForUI()
      .observeValues { [weak self] buttonStyleType in
        _ = self?.pledgeCTAButton ?|> buttonStyleType.style
      }

    self.viewModel.outputs.prelaunchCTASaved
      .observeForUI()
      .observeValues { [weak self] state in
        guard state.prelaunch else { return }

        _ = self?.pledgeCTAButton
          ?|> state.saved ? prelaunchButtonSavedImageStyle : prelaunchButtonUnsavedImageStyle

        self?.watchesLabel.isHidden = !state.prelaunch
      }

    self.projectSavedObserver = NotificationCenter.default
      .addObserver(forName: Notification.Name.ksr_projectSaved, object: nil, queue: nil) { [weak self]
        notification in
          self?.viewModel.inputs.savedProjectFromNotification(
            project: notification.userInfo?["project"] as? Project
          )
      }

    self.activityIndicatorContainerView.rac.hidden = self.viewModel.outputs.activityIndicatorIsHidden
    self.pledgeCTAButton.rac.hidden = self.viewModel.outputs.pledgeCTAButtonIsHidden
    self.pledgeCTAButton.rac.title = self.viewModel.outputs.buttonTitleText
    self.retryStackView.rac.hidden = self.viewModel.outputs.retryStackViewIsHidden
    self.spacer.rac.hidden = self.viewModel.outputs.spacerIsHidden
    self.subtitleLabel.rac.text = self.viewModel.outputs.subtitleText
    self.titleAndSubtitleStackView.rac.hidden = self.viewModel.outputs.stackViewIsHidden
    self.titleLabel.rac.text = self.viewModel.outputs.titleText
    self.pledgeButtonAndWatchesStackView.rac.hidden = self.viewModel.outputs.pledgeCTAButtonIsHidden
    self.watchesLabel.rac.hidden = self.viewModel.outputs.watchesLabelIsHidden
    self.watchesLabel.rac.text = self.viewModel.outputs.watchesCountText
  }

  func configureWith(value: PledgeCTAContainerViewData) {
    self.viewModel.inputs.configureWith(value: value)
  }

  private func configureSubviews() {
    _ = (self.rootStackView, self)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = (self.activityIndicator, self.activityIndicatorContainerView)
      |> ksr_addSubviewToParent()

    _ = ([self.titleLabel, self.subtitleLabel], self.titleAndSubtitleStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.pledgeCTAButton, self.watchesLabel], self.pledgeButtonAndWatchesStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.retryDescriptionLabel, self.retryButton], self.retryStackView)
      |> ksr_addArrangedSubviewsToStackView()

    self.setContentHuggingPriority(.required, for: .vertical)
    self.retryButton.setContentHuggingPriority(.required, for: .horizontal)

    _ = (
      [
        self.retryStackView,
        self.titleAndSubtitleStackView,
        self.spacer,
        self.pledgeButtonAndWatchesStackView,
        self.activityIndicatorContainerView
      ],
      self.rootStackView
    )
      |> ksr_addArrangedSubviewsToStackView()

    self.pledgeCTAButton.addTarget(
      self, action: #selector(self.pledgeCTAButtonTapped), for: .touchUpInside
    )
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.activityIndicator.centerXAnchor
        .constraint(equalTo: self.activityIndicatorContainerView.centerXAnchor),
      self.activityIndicator.centerYAnchor
        .constraint(equalTo: self.activityIndicatorContainerView.centerYAnchor),
      self.activityIndicatorContainerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.activityIndicatorContainerView.heightAnchor.constraint(equalToConstant: Layout.Button.minHeight),
      self.activityIndicatorContainerView.centerXAnchor
        .constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
      self.activityIndicatorContainerView.centerYAnchor
        .constraint(equalTo: self.layoutMarginsGuide.centerYAnchor),
      self.pledgeCTAButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.Button.minHeight),
      self.pledgeCTAButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Layout.Button.minWidth),
      self.retryButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.Button.minHeight),
      self.retryButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Layout.RetryButton.minWidth)
    ])
  }

  @objc func pledgeCTAButtonTapped() {
    self.viewModel.inputs.pledgeCTAButtonTapped()
  }
}
