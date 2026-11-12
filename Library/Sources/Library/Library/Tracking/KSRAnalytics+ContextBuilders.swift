import KsApi
import UIKit

// MARK: - Context, Interaction & User Property Builders

/// Helper definitions for `contextProperties` in `KSRAnalytics+ContextBuilders.swift`.
internal func contextProperties(
  ctaContext: KSRAnalytics.CTAContext? = nil,
  tabBarLabel: KSRAnalytics.TabBarItemLabel? = nil,
  page: KSRAnalytics.PageContext? = nil,
  sectionContext: KSRAnalytics.SectionContext? = nil,
  typeContext: KSRAnalytics.TypeContext? = nil,
  locationContext: KSRAnalytics.LocationContext? = nil,
  prefix: String = "context_"
) -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  result["cta"] = ctaContext?.trackingString
  result["location"] = locationContext?.trackingString
  result["page"] = page?
    .rawValue ??
    "other" // Product/Insight want some event with no `context_page` to be defaulted as `other` until a context_page is defined for them.
  result["section"] = sectionContext?.trackingString
  result["tab_bar_label"] = tabBarLabel?.trackingString
  result["type"] = typeContext?.trackingString

  return result.prefixedKeys(prefix)
}

internal func interactionProperties(
  targetUserId: String,
  prefix: String = "interaction_"
) -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  result["target_uid"] = targetUserId

  return result.prefixedKeys(prefix)
}

internal func pageContext(from tabBarItemLabel: KSRAnalytics.TabBarItemLabel) -> KSRAnalytics.PageContext? {
  switch tabBarItemLabel {
  case .activity:
    return .activities
  case .discovery:
    return .discovery
  case .profile:
    return .profile
  case .search:
    return .search
  default:
    return nil
  }
}

internal func userProperties(for user: User?, _ prefix: String = "user_") -> AnalyticsPropertyBag {
  guard let user = user else { return AnalyticsPropertyBag() }
  var props = AnalyticsPropertyBag()

  props["backed_projects_count"] = user.stats.backedProjectsCount
  // the product/insights team definition of created_projects_count is the sum of createdProjectsCount and draftProjectsCount
  props["created_projects_count"] = (user.stats.createdProjectsCount ?? 0) +
    (user.stats.draftProjectsCount ?? 0)
  props["is_admin"] = user.isAdmin
  props["launched_projects_count"] = user.stats
    .createdProjectsCount // product and insights defines launched_projects_count as only the createdProjectsCount
  props["uid"] = "\(user.id)"
  props["watched_projects_count"] = user.stats.starredProjectsCount
  props["facebook_connected"] = user.facebookConnected

  return props.prefixedKeys(prefix)
}

internal func videoProperties(
  videoLength: Int,
  videoPosition: Int,
  prefix: String = "video_"
) -> AnalyticsPropertyBag {
  var props = AnalyticsPropertyBag()

  props["length"] = videoLength
  props["position"] = videoPosition

  return props.prefixedKeys(prefix)
}

private func properties(update: Update, prefix: String = "update_") -> AnalyticsPropertyBag {
  var properties = AnalyticsPropertyBag()

  properties["comments_count"] = update.commentsCount
  properties["user_has_liked"] = update.hasLiked
  properties["likes_count"] = update.likesCount
  properties["published_at"] = update.publishedAt
  properties["sequence"] = update.sequence

  return properties.prefixedKeys(prefix)
}

private func properties(comment: ActivityComment, prefix: String = "comment_") -> AnalyticsPropertyBag {
  var properties = AnalyticsPropertyBag()

  properties["body_length"] = comment.body.count

  return properties.prefixedKeys(prefix)
}

private func properties(userActivity: NSUserActivity) -> AnalyticsPropertyBag {
  var props = AnalyticsPropertyBag()

  props["user_activity_type"] = userActivity.activityType
  props["user_activity_title"] = userActivity.title
  props["user_activity_webpage_url"] = userActivity.webpageURL?.absoluteString
  props["user_activity_keywords"] = Array(userActivity.keywords)

  return props
}

private func properties(
  shareContext: ShareContext,
  loggedInUser: User?,
  shareActivityType: UIActivity.ActivityType? = nil
) -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  result["share_activity_type"] = shareActivityType?.rawValue
  result["share_type"] = shareActivityType.flatMap(shareTypeProperty)

  switch shareContext {
  case let .discovery(project):
    result = result.withAllValuesFrom(projectProperties(from: project, loggedInUser: loggedInUser))
    result["context"] = "discovery"
  case let .project(project):
    result = result.withAllValuesFrom(projectProperties(from: project, loggedInUser: loggedInUser))
    result["context"] = "project"
  case let .thanks(project):
    result = result.withAllValuesFrom(projectProperties(from: project, loggedInUser: loggedInUser))
    result["context"] = "thanks"
  case let .update(project, update):
    result = result.withAllValuesFrom(projectProperties(from: project, loggedInUser: loggedInUser))
    result = result.withAllValuesFrom(properties(update: update))
    result["context"] = "update"
  }

  return result
}

private func shareTypeProperty(_ shareType: UIActivity.ActivityType?) -> String? {
  guard let shareType = shareType else { return nil }

  if shareType == .postToFacebook {
    return "facebook"
  } else if shareType == .message {
    return "message"
  } else if shareType == .mail {
    return "email"
  } else if shareType == .copyToPasteboard {
    return "copy link"
  } else if shareType == .postToTwitter {
    return "twitter"
  } else if shareType == UIActivity.ActivityType("com.apple.mobilenotes.SharingExtension") {
    return "notes"
  } else if shareType == SafariActivityType {
    return "safari"
  } else {
    return shareType.rawValue
  }
}

