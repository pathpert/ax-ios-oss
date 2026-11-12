import Foundation
import KDS
import Library
import Prelude
import UIKit

extension DiscoveryProjectCardCell {
  /// Binds view model outputs and watch-project signals to cell UI elements.
  override func bindViewModel() {
    super.bindViewModel()

    self.goalMetIconImageView.rac.hidden = self.viewModel.outputs.goalMetIconHidden
    self.projectNameLabel.rac.text = self.viewModel.outputs.projectNameLabelText
    self.projectBlurbLabel.rac.text = self.viewModel.outputs.projectBlurbLabelText
    self.pillsViewContainer.rac.hidden = self.viewModel.outputs.tagsCollectionViewHidden
    self.facepileDescriptionLabel.rac.text = self.viewModel.outputs.facepileViewData.map(\.description)
    self.facepileStackView.rac.hidden = self.viewModel.outputs.facepileViewHidden
    self.youreABackerView.rac.hidden = self.viewModel.outputs.youreABackerViewHidden
    self.saveButton.rac.selected = self.watchProjectViewModel.outputs.saveButtonSelected

    self.viewModel.outputs.projectImageURL
      .observeForUI()
      .on(event: { [weak self] _ in
        self?.projectImageView.af.cancelImageRequest()
        self?.projectImageView.image = nil
      })
      .observeValues { [weak self] url in
        self?.projectImageView.ksr_setImageWithURL(url)
      }

    self.viewModel.outputs.facepileViewData.map(\.avatars)
      .observeForUI()
      .on(event: { [weak self] _ in
        self?.clearFacepileImageViews()
      })
      .observeValues { [weak self] avatars in
        self?.configureFacepileImageViews(with: avatars)
      }

    self.viewModel.outputs.percentFundedLabelData
      .observeForUI()
      .observeValues { [weak self] data in
        guard let self = self else { return }
        _ = self.percentFundedLabel
          |> \.attributedText .~ self.attributedString(bolding: data.boldedString, in: data.inString)
      }

    self.viewModel.outputs.backerCountLabelData
      .observeForUI()
      .observeValues { [weak self] data in
        guard let self = self else { return }
        _ = self.backersCountLabel
          |> \.attributedText .~ self.attributedString(bolding: data.boldedString, in: data.inString)
      }

    self.viewModel.outputs.projectStatusLabelData
      .observeForUI()
      .observeValues { [weak self] data in
        guard let self = self else { return }
        _ = self.projectStatusLabel
          |> \.attributedText .~ self.attributedString(bolding: data.boldedString, in: data.inString)
      }

    self.viewModel.outputs.projectStatusIconImageName
      .observeForUI()
      .observeValues { [weak self] imageName in
        _ = self?.projectStatusIconImageView
          ?|> \.image .~ Library.image(named: imageName)
      }

    self.viewModel.outputs.loadProjectTags
      .observeForUI()
      .observeValues { [weak self] values in
        self?.configurePillsView(values)
      }

    // Watch Project View Model
    self.watchProjectViewModel.outputs.showProjectSavedAlert
      .observeForUI()
      .observeValues { [weak self] in
        self?.delegate?.discoveryPostcardCellProjectSaveAlert()
      }

    self.watchProjectViewModel.outputs.goToLoginTout
      .observeForControllerAction()
      .observeValues { [weak self] in
        self?.delegate?.discoveryPostcardCellGoToLoginTout()
      }

    self.watchProjectViewModel.outputs.showNotificationDialog
      .observeForUI()
      .observeValues { NotificationCenter.default.post($0) }

    self.watchProjectViewModel.outputs.generateImpactFeedback
      .observeForUI()
      .observeValues { _ in generateImpactFeedback() }

    self.watchProjectViewModel.outputs.generateNotificationSuccessFeedback
      .observeForUI()
      .observeValues { generateNotificationSuccessFeedback() }

    self.watchProjectViewModel.outputs.generateSelectionFeedback
      .observeForUI()
      .observeValues { generateSelectionFeedback() }
  }

  /// Configures pill tags in `pillsView` from metadata items.
  func configurePillsView(_ pills: [DiscoveryPillData]) {
    let pillData = pills.map { data -> PillData in
      PillData(
        backgroundColor: data.type.backgroundColor,
        font: UIFont.ksr_caption1().bolded,
        margins: UIEdgeInsets(topBottom: Styles.gridHalf(2), leftRight: Styles.gridHalf(3)),
        text: data.text,
        textColor: data.type.textColor,
        imageName: data.imageName
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

  /// Builds an attributed string highlighting `boldedString` inside `fullString`.
  func attributedString(bolding boldedString: String, in fullString: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: fullString)
    let regularFontAttribute = [NSAttributedString.Key.font: UIFont.ksr_footnote().bolded]
    let boldFontAttribute = [NSAttributedString.Key.font: UIFont.ksr_subhead().bolded]
    let fullRange = (fullString as NSString).localizedStandardRange(of: fullString)
    let boldedRange = (fullString as NSString).localizedStandardRange(of: boldedString)

    attributedString.addAttributes(regularFontAttribute, range: fullRange)
    attributedString.addAttributes(boldFontAttribute, range: boldedRange)

    return attributedString
  }

  /// Populates overlapping circular facepile avatar image views from user avatar URLs.
  func configureFacepileImageViews(with avatars: [URL]) {
    let endIndex = avatars.endIndex

    self.facepileAvatarImageViews = avatars.enumerated().map { index, imageURL -> UIImageView in
      let overlap = CGFloat(index) * Styles.grid(1)
      let xOffset = index == 0 ? 0 : (CGFloat(index) * FacepileAvatarSize.width - overlap)

      let imageView = UIImageView(frame: .zero)
        |> discoveryCardAvatarImageViewStyle

      self.facepileAvatarContainerView.addSubview(imageView)
      self.facepileAvatarContainerView.sendSubviewToBack(imageView)

      imageView.ksr_setRoundedImageWith(imageURL)

      NSLayoutConstraint.activate([
        imageView.widthAnchor.constraint(equalToConstant: FacepileAvatarSize.width),
        imageView.heightAnchor.constraint(equalToConstant: FacepileAvatarSize.height),
        imageView.leftAnchor.constraint(
          equalTo: self.facepileAvatarContainerView.leftAnchor,
          constant: xOffset
        ),
        imageView.topAnchor.constraint(equalTo: self.facepileAvatarContainerView.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: self.facepileAvatarContainerView.bottomAnchor)
      ])

      if index == endIndex - 1 {
        _ = imageView.rightAnchor.constraint(equalTo: self.facepileAvatarContainerView.rightAnchor)
          |> \.isActive .~ true
      }

      return imageView
    }

    self.facepileAvatarContainerView.layoutIfNeeded()
  }

  /// Cancels pending avatar requests and removes existing facepile image views.
  func clearFacepileImageViews() {
    self.facepileAvatarImageViews.forEach { imageView in
      imageView.af.cancelImageRequest()
      imageView.image = nil
      imageView.removeFromSuperview()
    }

    self.facepileAvatarImageViews = []
  }
}

