import KsApi
import ReactiveSwift
import UIKit

/// Inputs accepted by `DiscoveryViewModel`.
public protocol DiscoveryViewModelInputs {
  /// Call when Recommendations setting changes on Settings > Account > Privacy > Recommendations.
  func didChangeRecommendationsSetting()

  /// Call when params have been selected.
  func filter(withParams params: DiscoveryParams)

  /// Call when the Remote Config Client has been configured
  func remoteConfigClientConfigured()

  /// Call when the RemoteConfigClient configuration has failed
  func remoteConfigClientConfigurationFailed()

  /// Call when the UIPageViewController finishes transitioning.
  func pageTransition(completed: Bool)

  /// Call when the SortPagerViewController wants to switch to a specific sort.
  func sortPagerSelected(sort: DiscoveryParams.Sort)

  /// Call to disable/enable the sorts when an empty state is displayed/dismissed.
  func setSortsEnabled(_ enabled: Bool)

  /// Call from the controller's viewDidLoad.
  func viewDidLoad()

  /// Call from the controller's viewWillAppear.
  func viewWillAppear(animated: Bool)

  /// Call when the UIPageViewController begins a transition sequence.
  func willTransition(toPage nextPage: Int)
}

/// Outputs exposed by `DiscoveryViewModel`.
public protocol DiscoveryViewModelOutputs {
  /// Emits params to configure the navigation header.
  var configureNavigationHeader: Signal<DiscoveryParams, Never> { get }

  /// Emits an array of sorts that should be used to configure the pager data source.
  var configurePagerDataSource: Signal<[DiscoveryParams.Sort], Never> { get }

  /// Emits an array of sorts that should be used to configure the sort pager controller.
  var configureSortPager: Signal<[DiscoveryParams.Sort], Never> { get }

  /// Emits a discovery params value that should be passed to all the pages in discovery.
  var loadFilterIntoDataSource: Signal<DiscoveryParams, Never> { get }

  /// Emits when we should manually navigate to a sort's page.
  var navigateToSort: Signal<
    (DiscoveryParams.Sort, UIPageViewController.NavigationDirection),
    Never
  > { get }

  /// Emits a sort that should be passed on to the sort pager view controller.
  var selectSortPage: Signal<DiscoveryParams.Sort, Never> { get }

  /// Emits to disable/enable the sorts when an empty state is displayed/dismissed.
  var sortsAreEnabled: Signal<Bool, Never> { get }

  /// Emits a category id to update the sort pager view controller style.
  var updateSortPagerStyle: Signal<Int?, Never> { get }
}

/// Combined inputs and outputs interface for `DiscoveryViewModel`.
public protocol DiscoveryViewModelType {
  /// The view model's inputs.
  var inputs: DiscoveryViewModelInputs { get }
  /// The view model's outputs.
  var outputs: DiscoveryViewModelOutputs { get }
}

