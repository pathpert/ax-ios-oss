import FirebaseCrashlytics
import KDS
import Kingfisher
import KsApi
import Library
import SwiftUI
import UIKit

/// Full-screen swipeable video feed view controller driven by `VideoFeedViewModel`.
final class VideoFeedViewController: UIViewController {
  private enum Constants {
    static let backgroundColor = KDS.Colors.Icon.dark.uiColor()
  }

  let viewModel = VideoFeedViewModel()
  private let dataSource = VideoFeedDataSource()
  let audioController = VideoFeedAudioController()

  var lifecycleObservers: [any NSObjectProtocol] = []
  var previewImagePrefetcher: ImagePrefetcher?
  var isScrolling = false
  var currentPageIndex: Int = 0
  var isShareSheetPresented = false

  /// Called once the first batch of items has loaded and the feed is ready to present.
  var onReadyToPresent: (() -> Void)?

  /// Called if the initial fetch fails.
  var onFetchFailed: (() -> Void)?

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = Constants.backgroundColor
    self.audioController.configure()
    self.observeAppLifecycle()

    if #available(iOS 26, *) {
      self.audioController.onVolumeUpDetected = { [weak self] in
        self?.muteVisibleCells()
      }
      self.audioController.setupObservers(in: self.view)
    }

    self.setupCollectionView()
    self.bindViewModel()
  }

  /// Begins fetching initial video feed items and observes view model updates.
  func startFetch() {
    self.viewModel.viewDidLoad()
    self.bindViewModel()
  }

  deinit {
    self.lifecycleObservers.forEach(NotificationCenter.default.removeObserver)
  }

  /// Locks the full-screen video feed interface to portrait orientation.
  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.snapToCurrentPage()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    self.viewModel.viewWillAppear()

    DispatchQueue.main.async { [weak self] in
      self?.reconfigureVisibleCell()
      self?.activateCurrentPageCell()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    self.pauseVisibleCell()

    if self.isBeingDismissed, #available(iOS 26, *) {
      self.audioController.handleDismiss()
    }
  }

  // MARK: - CollectionView

  private func setupCollectionView() {
    self.collectionView.dataSource = self.dataSource
    self.collectionView.delegate = self
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.collectionView.backgroundColor = Constants.backgroundColor
    self.collectionView.isPagingEnabled = true
    self.collectionView.showsVerticalScrollIndicator = false
    self.collectionView.contentInsetAdjustmentBehavior = .never

    self.collectionView.register(
      VideoFeedCell.self,
      forCellWithReuseIdentifier: VideoFeedCell.reuseIdentifier
    )

    self.view.addSubview(self.collectionView)

    NSLayoutConstraint.activate([
      self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }

  // MARK: - Binding

  /// Observes Observation-tracked `VideoFeedViewModel` state changes to refresh feed cells and errors.
  public override func bindViewModel() {
    withObservationTracking {
      _ = self.viewModel.fetchedItems
    } onChange: { [weak self] in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }

        self.updateFeedWithFetchedItems(self.viewModel.items)
        if self.viewModel.isInitialLoadComplete {
          self.onReadyToPresent?()
        }

        self.bindViewModel()
      }
    }

    withObservationTracking {
      _ = self.viewModel.errorMessage
    } onChange: { [weak self] in
      DispatchQueue.main.async { [weak self] in
        guard let self, self.viewModel.errorMessage != nil else { return }
        self.onFetchFailed?()
        self.bindViewModel()
      }
    }

    withObservationTracking {
      _ = self.viewModel.loginIntent
    } onChange: { [weak self] in
      DispatchQueue.main.async { [weak self] in
        guard let self, let intent = self.viewModel.loginIntent else { return }
        self.goToLoginTout(intent: intent)
        self.viewModel.clearLoginIntent()
        self.bindViewModel()
      }
    }

    withObservationTracking {
      _ = self.viewModel.saveFailedItemId
    } onChange: { [weak self] in
      DispatchQueue.main.async { [weak self] in
        guard let self, let failedId = self.viewModel.saveFailedItemId else { return }
        self.collectionView.visibleCells
          .compactMap { $0 as? VideoFeedCell }
          .first { $0.currentItemId == failedId }?
          .showSaveErrorToast()
        self.viewModel.clearSaveFailedItemId()
        self.bindViewModel()
      }
    }

    withObservationTracking {
      _ = self.viewModel.items
    } onChange: { [weak self] in
      DispatchQueue.main.async { [weak self] in
        self?.reconfigureVisibleCell()
        self?.bindViewModel()
      }
    }
  }

  private func updateFeedWithFetchedItems(_ newItems: [VideoFeedItem]) {
    self.currentPageIndex = 0
    self.dataSource.load(newItems)
    self.collectionView.reloadData()

    DispatchQueue.main.async {
      self.activateCurrentPageCell()
    }
  }
}
