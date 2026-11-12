import Experimentation
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

internal func appDelegateDeviceToken(fromData data: Data) -> String {
  return data
    .map { String(format: "%02.2hhx", $0 as CVarArg) }
    .joined()
}

internal func navigation(fromPushEnvelope envelope: PushEnvelope) -> Navigation? {
  if let activity = envelope.activity {
    switch activity.category {
    case .backing, .failure, .launch, .success, .cancellation, .suspension:
      guard let projectId = activity.projectId else { return nil }
      return .project(.id(projectId), .root, refInfo: RefInfo(.push))
    case .update:
      guard let projectId = activity.projectId, let updateId = activity.updateId else { return nil }
      return .project(.id(projectId), .update(updateId, .root), refInfo: RefInfo(.push))
    case .commentPost:
      guard let projectId = activity.projectId, let updateId = activity.updateId else { return nil }
      if let commentId = activity.commentId {
        return .project(
          .id(projectId),
          .update(updateId, .commentThread(commentId, activity.replyId)),
          refInfo: RefInfo(.push)
        )
      }
      return .project(.id(projectId), .update(updateId, .comments), refInfo: RefInfo(.push))
    case .commentProject:
      guard let projectId = activity.projectId else { return nil }
      if let commentId = activity.commentId {
        return .project(.id(projectId), .commentThread(commentId, activity.replyId), refInfo: RefInfo(.push))
      }
      return .project(.id(projectId), .comments, refInfo: RefInfo(.push))
    case .follow:
      return .tab(.activity)
    case .funding, .shipped, .unknown, .watch:
      return nil
    }
  }

  if let order = envelope.order {
    let url = AppEnvironment.current.apiService.serverConfig.webBaseUrl.absoluteString + order.pledgeManagerPath
    return .project(.id(order.projectId), .pledgeManagerWebview(url), refInfo: RefInfo(.push))
  }

  if let project = envelope.project {
    return .project(.id(project.id), .root, refInfo: RefInfo(.push))
  }

  if let message = envelope.message {
    return .messages(messageThreadId: message.messageThreadId)
  }

  if let survey = envelope.survey {
    let url = AppEnvironment.current.apiService.serverConfig.webBaseUrl.absoluteString + survey.urls.web.survey
    return .project(.id(survey.projectId), .pledgeManagerWebview(url), refInfo: RefInfo(.push))
  }

  if let update = envelope.update {
    return .project(.id(update.projectId), .update(update.id, .root), refInfo: RefInfo(.push))
  }

  if let erroredPledge = envelope.erroredPledge {
    return .project(.id(erroredPledge.projectId), .pledge(.manage), refInfo: RefInfo(.push))
  }

  return nil
}

internal func shortcutItems(forUser user: User?) -> SignalProducer<[ShortcutItem], Never> {
  guard let user = user else {
    return SignalProducer(value: shortcutItems(isProjectMember: false, hasRecommendations: false))
  }

  let recommendationParams = .defaults
    |> DiscoveryParams.lens.recommended .~ true
    |> DiscoveryParams.lens.state .~ .live
    |> DiscoveryParams.lens.perPage .~ 1

  return AppEnvironment.current.apiService.fetchDiscovery(params: recommendationParams)
    .map { $0.stats.count }
    .flatMapError { _ in SignalProducer<Int, Never>(value: 0) }
    .map { recommendationsCount in
      shortcutItems(
        isProjectMember: (user.stats.memberProjectsCount ?? 0) > 0,
        hasRecommendations: recommendationsCount > 0
      )
    }
    .demoteErrors()
}

private func shortcutItems(isProjectMember _: Bool, hasRecommendations: Bool) -> [ShortcutItem] {
  var items: [ShortcutItem] = []
  if hasRecommendations {
    items.append(.recommendedForYou)
  }
  items.append(.projectsWeLove)
  if items.count < 4 {
    items.append(.search)
  }
  return items
}

extension ShortcutItem {
  /// Converts this shortcut item into a configured `UIApplicationShortcutItem` for the home screen quick actions menu.
  public var applicationShortcutItem: UIApplicationShortcutItem {
    switch self {
    case .projectsWeLove:
      return .init(
        type: self.typeString,
        localizedTitle: Strings.Projects_We_Love(),
        localizedSubtitle: nil,
        icon: UIApplicationShortcutIcon(templateImageName: "shortcut-icon-k"),
        userInfo: nil
      )
    case .recommendedForYou:
      return .init(
        type: self.typeString,
        localizedTitle: Strings.Recommended(),
        localizedSubtitle: nil,
        icon: UIApplicationShortcutIcon(templateImageName: "shortcut-icon-star"),
        userInfo: nil
      )
    case .search:
      return .init(
        type: self.typeString,
        localizedTitle: Strings.tabbar_search(),
        localizedSubtitle: nil,
        icon: UIApplicationShortcutIcon(templateImageName: "shortcut-icon-search"),
        userInfo: nil
      )
    }
  }
}

internal func visitorCookies() -> [HTTPCookie] {
  let uuidString = (AppEnvironment.current.device.identifierForVendor ?? UUID()).uuidString
  let config = AppEnvironment.current.apiService.serverConfig
  return [config.webBaseUrl.host, config.apiBaseUrl.host].compactMap { host in
    HTTPCookie(properties: [
      .name: "vis",
      .value: uuidString,
      .domain: host as Any,
      .path: "/",
      .version: 0,
      .expires: Date.distantFuture,
      .secure: true
    ])
  }
}

internal func configRetainingDebugFeatureFlags(_ config: Config) -> Config {
  guard AppEnvironment.current.mainBundle.isRelease == false else { return config }

  let currentFeatures = config.features
  let currentFeatureKeys = Set(currentFeatures.keys)
  let storedFeatures = (AppEnvironment.current.config?.features ?? [:])
    .filter { key, _ in currentFeatureKeys.contains(key) }

  return config |> Config.lens.features .~ currentFeatures.withAllValuesFrom(storedFeatures)
}

internal func statsigSDKKey() -> StatsigClientSDKKey {
  let mainBundle = AppEnvironment.current.mainBundle
  if mainBundle.isRelease {
    return .productionTier(Secrets.Statsig.production)
  } else if mainBundle.isBeta {
    return .stagingTier(Secrets.Statsig.staging)
  } else if mainBundle.isDebug {
    return .developmentTier(Secrets.Statsig.development)
  }
  return .stagingTier(Secrets.Statsig.sandbox)
}

