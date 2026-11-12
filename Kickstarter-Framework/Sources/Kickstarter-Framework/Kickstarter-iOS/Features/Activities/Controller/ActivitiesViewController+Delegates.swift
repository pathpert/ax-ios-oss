import KsApi
import Library
import UIKit

// MARK: - ActivityUpdateCellDelegate

/// `ActivitiesViewController` extensions declared in `ActivitiesViewController+Delegates.swift`.
extension ActivitiesViewController: ActivityUpdateCellDelegate {
  internal func activityUpdateCellTappedProjectImage(activity: Activity) {
    self.viewModel.inputs.activityUpdateCellTappedProjectImage(activity: activity)
  }
}

// MARK: - ActivitySurveyResponseCellDelegate

extension ActivitiesViewController: ActivitySurveyResponseCellDelegate {
  func activityTappedRespondNow(forSurveyResponse surveyResponse: SurveyResponse) {
    self.viewModel.inputs.tappedRespondNow(forSurveyResponse: surveyResponse)
  }
}

// MARK: - EmptyStatesViewControllerDelegate

extension ActivitiesViewController: EmptyStatesViewControllerDelegate {
  func emptyStatesViewController(
    _: EmptyStatesViewController,
    goToDiscoveryWithParams params: DiscoveryParams?
  ) {
    guard let tabController = self.tabBarController as? RootTabBarViewController else { return }
    tabController.switchToDiscovery(params: params)
  }

  func emptyStatesViewControllerGoToFriends() {}
}

extension ActivitiesViewController: PledgeManagerWebViewControllerDelegate {
  func pledgeManagerWebViewControllerDismissed() {
    self.viewModel.inputs.surveyResponseViewControllerDismissed()
  }
}

extension ActivitiesViewController: TabBarControllerScrollable {}

// MARK: - ErroredBackingViewDelegate

extension ActivitiesViewController: ErroredBackingViewDelegate {
  func erroredBackingViewDidTapManage(_: ErroredBackingView, backing: ProjectAndBackingEnvelope) {
    self.viewModel.inputs.erroredBackingViewDidTapManage(with: backing)
  }
}

// MARK: - ManagePledgeViewControllerDelegate

extension ActivitiesViewController: ManagePledgeViewControllerDelegate {
  func managePledgeViewController(
    _: ManagePledgeViewController,
    managePledgeViewControllerFinishedWithMessage _: String?
  ) {
    self.viewModel.inputs.managePledgeViewControllerDidFinish()
  }

  func managePledgeViewControllerDidDismiss(_: ManagePledgeViewController) {}
}

// MARK: - RewardTrackingDetailsViewDelegate

extension ActivitiesViewController: RewardTrackingDetailsViewDelegate {
  func didTapTrackingButton(with trackingURL: URL) {
    self.viewModel.inputs.tappedTrackShipping(with: trackingURL)
  }
}

