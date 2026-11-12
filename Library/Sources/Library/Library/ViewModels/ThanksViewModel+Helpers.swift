import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Helper definitions for `thanksRecommendedParams` in `ThanksViewModel+Helpers.swift`.
let thanksRecommendedParams = DiscoveryParams.defaults
  |> DiscoveryParams.lens.backed .~ false
  |> DiscoveryParams.lens.perPage .~ 6
  |> DiscoveryParams.lens.recommended .~ true

/*
 This is a work around that fixes the incompatibility between the types of category id returned by
 the server (Int) and the type we need to send when requesting category by id
 through GraphQL (base64 encoded String). This will be removed once we start consuming GraphQL to fetch
 Discovery projects.
 */
func thanksCategoryBase64Id(_ category: Project.Category) -> String {
  let id = category.parentId ?? category.id
  return Category.decode(id: "\(id)").toBase64()
}

func thanksRelatedProjects(
  toProject project: Project,
  inCategory category: KsApi.Category
) -> SignalProducer<[Project], Never> {
  let base = DiscoveryParams.lens.perPage .~ 3 <> DiscoveryParams.lens.backed .~ false

  let similarToParams = DiscoveryParams.defaults |> base
    |> DiscoveryParams.lens.similarTo .~ project

  let staffPickParams = DiscoveryParams.defaults |> base
    |> DiscoveryParams.lens.staffPicks .~ true
    |> DiscoveryParams.lens.category .~ category

  let recommendedProjects = AppEnvironment.current.apiService.fetchDiscovery(params: thanksRecommendedParams)
    .demoteErrors()
    .map { shuffleProjects(projects: $0.projects) }
    .uncollect()

  let similarToProjects = AppEnvironment.current.apiService.fetchDiscovery(params: similarToParams)
    .demoteErrors()
    .map { $0.projects }
    .uncollect()

  let staffPickProjects = AppEnvironment.current.apiService.fetchDiscovery(params: staffPickParams)
    .demoteErrors()
    .map { $0.projects }
    .uncollect()

  return SignalProducer.concat(recommendedProjects, similarToProjects, staffPickProjects)
    .filter { $0.id != project.id }
    .uniqueValues { $0.id }
    .take(first: 3)
    .collect()
}

func shouldShowThanksPledgeDialog() -> Bool {
  return PushNotificationDialog.canShowDialog(for: .pledge) &&
    AppEnvironment.current.currentUser?.stats.backedProjectsCount == 0
}

func wireThanksThirdPartyAndAnalytics(
  project: Signal<Project, Never>,
  configData: Signal<ThanksPageData, Never>,
  viewDidLoad: Signal<Void, Never>,
  projectTapped: Signal<Project, Never>,
  rewardAndCheckoutData: Signal<(Reward, KSRAnalytics.CheckoutPropertiesData?), Never>
) {
  projectTapped
    .map { project in (project, thanksRecommendedParams) }
    .combineLatest(with: rewardAndCheckoutData)
    .observeValues { projectAndParams, rewardAndCheckoutData in
      let (project, params) = projectAndParams
      let (reward, checkoutData) = rewardAndCheckoutData

      AppEnvironment.current.ksrAnalytics.trackProjectCardClicked(
        page: .thanks,
        project: project,
        checkoutData: checkoutData,
        typeContext: .recommended,
        location: .curated,
        params: params,
        reward: reward
      )
    }

  Signal.combineLatest(configData, viewDidLoad.ignoreValues())
    .map(first)
    .observeValues {
      AppEnvironment.current.ksrAnalytics.trackThanksPageViewed(
        project: $0.project,
        reward: $0.reward,
        checkoutData: $0.checkoutData
      )
    }

  _ = Signal.combineLatest(project, configData)
    .observeValues { project, configData in
      var pledgeAmount: Double?
      var shipping: Double?
      var transactionId: String?

      if let checkoutDataValues = configData.checkoutData {
        transactionId = checkoutDataValues.checkoutId
        shipping = checkoutDataValues.shippingAmountUsd
        pledgeAmount = NSDecimalNumber(decimal: checkoutDataValues.revenueInUsd).doubleValue
          + NSDecimalNumber(decimal: checkoutDataValues.bonusAmountInUsd ?? 0).doubleValue
          + checkoutDataValues.addOnsMinimumUsd
      }

      AppEnvironment.current.appTrackingTransparency.updateAdvertisingIdentifier()

      guard let externalId = AppEnvironment.current.appTrackingTransparency.advertisingIdentifier else {
        return
      }

      let userId = AppEnvironment.current.currentUser.map { "\($0.id)" } ?? ""
      var extInfo = Array(repeating: "", count: 16)
      extInfo[0] = "i2"
      extInfo[4] = AppEnvironment.current.mainBundle.platformVersion

      _ = AppEnvironment.current.apiService
        .triggerThirdPartyEventInput(input: .init(
          deviceId: externalId,
          eventName: ThirdPartyEventInputName.BackingComplete.rawValue,
          projectId: "\(project.id)",
          pledgeAmount: pledgeAmount,
          shipping: shipping,
          transactionId: transactionId,
          userId: userId,
          appData: .init(
            advertiserTrackingEnabled: true,
            applicationTrackingEnabled: true,
            extinfo: extInfo
          ),
          clientMutationId: ""
        ))
    }
}

// Shuffle an array without mutating the input argument.
// Based on the Fisher-Yates shuffle algorithm https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle.
private func shuffleProjects(projects xs: [Project]) -> [Project] {
  var ys = xs
  let length = ys.count
  guard length > 1 else { return xs }

  for i in 0...length - 1 {
    let j = Int(arc4random_uniform(UInt32(length - 1)))
    ys.swapAt(i, j)
  }
  return ys
}

