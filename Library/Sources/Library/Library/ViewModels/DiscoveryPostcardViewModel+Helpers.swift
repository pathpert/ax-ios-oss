import KDS
import KsApi
import UIKit

private enum PostcardMetadataType {
  case backing
  case featured

  fileprivate func data(forProject project: Project) -> PostcardMetadataData? {
    switch self {
    case .backing:
      return PostcardMetadataData(
        iconImage: image(named: "metadata-backing"),
        labelText: Strings.discovery_baseball_card_metadata_backer(),
        iconAndTextColor: LegacyColors.ksr_create_700.uiColor()
      )
    case .featured:
      guard let rootCategory = project.category?.parentName else { return nil }
      return PostcardMetadataData(
        iconImage: image(named: "metadata-featured"),
        labelText: Strings.discovery_baseball_card_metadata_featured_project(
          category_name: rootCategory
        ),
        iconAndTextColor: LegacyColors.ksr_support_700.uiColor()
      )
    }
  }
}

internal func postcardSocialText(forFriends friends: [User]) -> String? {
  if friends.count == 1 {
    return Strings.project_social_friend_is_backer(friend_name: friends[0].name)
  } else if friends.count == 2 {
    return Strings.project_social_friend_and_friend_are_backers(
      friend_name: friends[0].name,
      second_friend_name: friends[1].name
    )
  } else if friends.count > 2 {
    let remainingCount = max(0, friends.count - 2)
    return Strings.discovery_baseball_card_social_friends_are_backers(
      friend_name: friends[0].name,
      second_friend_name: friends[1].name,
      remaining_count: remainingCount
    )
  } else {
    return nil
  }
}

internal func postcardFundingStatusText(forProject project: Project) -> String {
  switch project.state {
  case .canceled:
    return Strings.Project_cancelled()
  case .failed:
    return Strings.dashboard_creator_project_funding_unsuccessful()
  case .successful:
    return Strings.Funding_successful()
  case .suspended:
    return Strings.dashboard_creator_project_funding_suspended()
  case .live, .purged, .started, .submitted:
    return ""
  }
}

/// Returns the disparate metadata data for a project based on metadata precedence.
internal func postcardMetadata(forProject project: Project) -> PostcardMetadataData? {
  let today = AppEnvironment.current.dateType.init().date

  let userHasBacked = userIsBackingProject(project)
  let projectIsFeaturedToday = project.isFeaturedToday(today: today)

  if userHasBacked {
    return PostcardMetadataType.backing.data(forProject: project)
  } else if projectIsFeaturedToday {
    return PostcardMetadataType.featured.data(forProject: project)
  } else {
    return nil
  }
}

