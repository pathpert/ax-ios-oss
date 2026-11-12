import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Contract defining `ProjectPamphletMainCellDelegate` capabilities and boundaries.
internal protocol ProjectPamphletMainCellDelegate: VideoViewControllerDelegate {
  func projectPamphletMainCell(_ cell: ProjectPamphletMainCell, addChildController child: UIViewController)
  func projectPamphletMainCell(
    _ cell: ProjectPamphletMainCell,
    goToCreatorForProject project: any ProjectPamphletMainCellConfiguration
  )
  func projectPamphletMainCellGoToProjectNotice(_ cell: ProjectPamphletMainCell)
}

internal final class ProjectPamphletMainCell: UITableViewCell, ValueCell {
  internal weak var delegate: ProjectPamphletMainCellDelegate? {
    didSet {
      self.viewModel.inputs.delegateDidSet()
    }
  }

  fileprivate let viewModel: ProjectPamphletMainCellViewModelType = ProjectPamphletMainCellViewModel()

  fileprivate weak var videoController: VideoViewController?

  @IBOutlet internal var backersSubtitleLabel: UILabel!
  @IBOutlet internal var backersTitleLabel: UILabel!
  @IBOutlet internal var blurbAndOverviewStackview: UIStackView!
  @IBOutlet internal var blurbStackView: UIStackView!
  @IBOutlet internal var categoryStackView: UIStackView!
  @IBOutlet internal var categoryAndLocationStackView: UIStackView!
  @IBOutlet internal var categoryIconImageView: UIImageView!
  @IBOutlet internal var categoryNameLabel: UILabel!
  @IBOutlet internal var contentStackView: UIStackView!
  @IBOutlet internal var conversionLabel: UILabel!
  @IBOutlet fileprivate(set) var creatorButton: UIButton! // Made visible so it can be used as a popover target
  @IBOutlet internal var creatorImageView: UIImageView!
  @IBOutlet internal var creatorLabel: UILabel!
  @IBOutlet internal var creatorStackView: UIStackView!
  @IBOutlet internal var deadlineSubtitleLabel: UILabel!
  @IBOutlet internal var deadlineTitleLabel: UILabel!
  @IBOutlet internal var fundingProgressBarView: UIView!
  @IBOutlet internal var fundingProgressContainerView: UIView!
  @IBOutlet internal var locationImageView: UIImageView!
  @IBOutlet internal var locationNameLabel: UILabel!
  @IBOutlet internal var locationStackView: UIStackView!
  @IBOutlet internal var pledgeSubtitleLabel: UILabel!
  @IBOutlet internal var pledgedTitleLabel: UILabel!
  @IBOutlet internal var projectBlurbLabel: UILabel!
  @IBOutlet internal var projectImageContainerView: UIView!
  @IBOutlet internal var projectNameAndCreatorStackView: UIStackView!
  @IBOutlet internal var projectNameLabel: UILabel!
  @IBOutlet internal var progressBarAndStatsStackView: UIStackView!
  @IBOutlet internal var stateLabel: UILabel!
  @IBOutlet internal var statsStackView: UIStackView!
  @IBOutlet internal var backingContainerView: UIView!
  @IBOutlet internal var backingContainerViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet internal var backingLabel: UILabel!

  private var alertBanner = AlertBanner(frame: CGRect.zero)

  internal override func awakeFromNib() {
    super.awakeFromNib()

    self.creatorButton.addTarget(
      self,
      action: #selector(self.creatorButtonTapped),
      for: .touchUpInside
    )

    self.alertBanner.configureWith(
      title: Strings.project_project_notices_header(),
      subtitle: Strings.project_project_notices_notice_intro(),
      buttonTitle: Strings.project_project_notices_notice_cta()
    ) { [weak self] in
      self?.alertBannerLearnMoreTapped()
    }
    self.contentStackView.insertArrangedSubview(self.alertBanner, at: 1)

    self.viewModel.inputs.awakeFromNib()
  }

  internal func configureWith(value: ProjectPamphletMainCellData) {
    self.viewModel.inputs.configureWith(value: value)
  }

  internal func scrollContentOffset(_ offset: CGFloat) {
    let height = self.projectImageContainerView.bounds.height
    let translation = offset / 2

    let scale: CGFloat
    if offset < 0 {
      scale = (height + abs(offset)) / height
    } else {
      scale = max(1, 1 - 0.5 * offset / height)
    }

    self.projectImageContainerView.transform = CGAffineTransform(
      a: scale, b: 0,
      c: 0, d: scale,
      tx: 0, ty: translation
    )
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.backersSubtitleLabel.rac.text = self.viewModel.outputs.backersSubtitleLabelText
    self.backersTitleLabel.rac.text = self.viewModel.outputs.backersTitleLabelText
    self.backersTitleLabel.rac.textColor = self.viewModel.outputs.projectUnsuccessfulLabelTextColor
    self.categoryNameLabel.rac.text = self.viewModel.outputs.categoryNameLabelText
    self.conversionLabel.rac.hidden = self.viewModel.outputs.conversionLabelHidden
    self.conversionLabel.rac.text = self.viewModel.outputs.conversionLabelText
    self.creatorButton.rac.accessibilityLabel = self.viewModel.outputs.creatorLabelText
    self.creatorLabel.rac.text = self.viewModel.outputs.creatorLabelText
    self.deadlineSubtitleLabel.rac.text = self.viewModel.outputs.deadlineSubtitleLabelText
    self.deadlineTitleLabel.rac.text = self.viewModel.outputs.deadlineTitleLabelText
    self.deadlineTitleLabel.rac.textColor = self.viewModel.outputs.projectUnsuccessfulLabelTextColor
    self.fundingProgressBarView.rac.backgroundColor =
      self.viewModel.outputs.fundingProgressBarViewBackgroundColor
    self.locationNameLabel.rac.text = self.viewModel.outputs.locationNameLabelText
    self.locationStackView.rac.hidden = self.viewModel.outputs.locationStackViewHidden
    self.pledgeSubtitleLabel.rac.text = self.viewModel.outputs.pledgedSubtitleLabelText
    self.pledgeSubtitleLabel.rac.textColor = self.viewModel.outputs.pledgedTitleLabelTextColor
    self.pledgedTitleLabel.rac.text = self.viewModel.outputs.pledgedTitleLabelText
    self.pledgedTitleLabel.rac.textColor = self.viewModel.outputs.pledgedTitleLabelTextColor
    self.projectBlurbLabel.rac.text = self.viewModel.outputs.projectBlurbLabelText
    self.projectNameLabel.rac.text = self.viewModel.outputs.projectNameLabelText
    self.stateLabel.rac.text = self.viewModel.outputs.projectStateLabelText
    self.stateLabel.rac.textColor = self.viewModel.outputs.projectStateLabelTextColor
    self.stateLabel.rac.hidden = self.viewModel.outputs.stateLabelHidden
    self.statsStackView.rac.accessibilityLabel = self.viewModel.outputs.statsStackViewAccessibilityLabel
    self.backingContainerView.rac.hidden = self.viewModel.outputs.backingLabelHidden
    self.progressBarAndStatsStackView.rac.hidden = self.viewModel.outputs.isPrelaunchProject
    self.backingLabel.rac.text = self.viewModel.outputs.prelaunchProjectBackingText
    self.alertBanner.rac.hidden = self.viewModel.outputs.projectNoticeBannerHidden

    self.viewModel.outputs.configureVideoPlayerController
      .observeForUI()
      .observeValues { [weak self] in self?.configureVideoPlayerController(forProject: $0) }

    self.viewModel.outputs.creatorImageUrl
      .observeForUI()
      .on(event: { [weak self] _ in self?.creatorImageView.image = nil })
      .skipNil()
      .observeValues { [weak self] in self?.creatorImageView.af.setImage(withURL: $0) }

    self.viewModel.outputs.notifyDelegateToGoToCreator
      .observeForControllerAction()
      .observeValues { [weak self] in
        guard let self = self else { return }
        self.delegate?.projectPamphletMainCell(self, goToCreatorForProject: $0)
      }

    self.viewModel.outputs.notifyDelegateToGoToProjectNotice
      .observeForControllerAction()
      .observeValues { [weak self] in
        guard let self = self else { return }
        self.delegate?.projectPamphletMainCellGoToProjectNotice(self)
      }

    self.viewModel.outputs.opacityForViews
      .observeForUI()
      .observeValues { [weak self] alpha in
        guard let self = self else { return }
        UIView.animate(
          withDuration: alpha == 0.0 ? 0.0 : 0.3,
          delay: 0.0,
          options: .curveEaseOut,
          animations: {
            self.creatorStackView.alpha = alpha
            self.statsStackView.alpha = alpha
            self.blurbAndOverviewStackview.alpha = alpha
          },
          completion: nil
        )
      }

    self.viewModel.outputs.progressPercentage
      .observeForUI()
      .observeValues { [weak self] progress in
        let anchorX = progress == 0 ? 0 : 0.5 / progress
        self?.fundingProgressBarView.layer.anchorPoint = CGPoint(x: CGFloat(anchorX), y: 0.5)
        self?.fundingProgressBarView.transform = CGAffineTransform(scaleX: CGFloat(progress), y: 1.0)
      }
  }

  fileprivate func configureVideoPlayerController(
    forProject project: any ProjectPamphletMainCellConfiguration
  ) {
    let vc = VideoViewController.configuredWith(project: project)
    vc.delegate = self
    vc.view.translatesAutoresizingMaskIntoConstraints = false
    self.projectImageContainerView.addSubview(vc.view)

    NSLayoutConstraint.activate([
      vc.view.topAnchor.constraint(equalTo: self.projectImageContainerView.topAnchor),
      vc.view.leadingAnchor.constraint(equalTo: self.projectImageContainerView.leadingAnchor),
      vc.view.bottomAnchor.constraint(equalTo: self.projectImageContainerView.bottomAnchor),
      vc.view.trailingAnchor.constraint(equalTo: self.projectImageContainerView.trailingAnchor)
    ])

    self.delegate?.projectPamphletMainCell(self, addChildController: vc)
    self.videoController = vc
    self.videoController?.playbackDelegate = vc
  }

  private func alertBannerLearnMoreTapped() {
    self.viewModel.inputs.projectNoticeLearnMoreTapped()
  }

  @objc fileprivate func creatorButtonTapped() {
    self.viewModel.inputs.creatorButtonTapped()
  }
}

extension ProjectPamphletMainCell: VideoViewControllerDelegate {
  internal func videoViewControllerDidFinish(_ controller: VideoViewController) {
    self.delegate?.videoViewControllerDidFinish(controller)
    self.viewModel.inputs.videoDidFinish()
  }

  internal func videoViewControllerDidStart(_ controller: VideoViewController) {
    self.delegate?.videoViewControllerDidStart(controller)
    self.viewModel.inputs.videoDidStart()
  }
}

extension ProjectPamphletMainCell: AudioVideoViewControllerPlaybackDelegate {
  func pauseAudioVideoPlayback() {
    self.videoController?.playbackDelegate?.pauseAudioVideoPlayback()
  }
}
