import Foundation
import GraphAPI

/// `User` extensions declared in `User+UserFragmentHelpers.swift`.
extension User {
  internal static func userStats(from userFragment: GraphAPI.UserFragment) -> Stats {
    let backedProjectsCount = userFragment.backingsCount
    let createdProjectsCount = userFragment.createdProjects?.totalCount
    let draftProjectsCount: Int? = nil /// Unavailable on GQL at this time.
    let starredProjectsCount = userFragment.savedProjects?.totalCount
    /** FIXME:
     Adding this to the `UserFragment` causes an issue with the query because user has to be logged in. However we use the `UserFragment` on loading a project page, so we need that query `FetchProjectQueryById` and `FetchProjectQueryBySlug` to not error, because the user needs the data regardless of their session state.

     This fragment can be added back into `UserFragment` once we come up with a new GQL model for our Project Page:
     ```
     membershipProjects {
       totalCount
     }
     ```
     */
    let memberProjectsCount: Int? =
      nil // TODO: Once above FIXME is resolved use `userFragment.membershipProjects?.totalCount` here.
    let hasUnreadMessages = userFragment.hasUnreadMessages ?? false
    let unreadMessagesCount: Int = hasUnreadMessages ? 1 : 0
    let unansweredSurveysCount = userFragment.surveyResponses?.totalCount

    let userStats = Stats(
      backedProjectsCount: backedProjectsCount,
      createdProjectsCount: createdProjectsCount,
      draftProjectsCount: draftProjectsCount,
      memberProjectsCount: memberProjectsCount,
      starredProjectsCount: starredProjectsCount,
      unansweredSurveysCount: unansweredSurveysCount,
      unreadMessagesCount: unreadMessagesCount
    )

    return userStats
  }

  internal static func erroredBackingsCount(userFragment: GraphAPI.UserFragment) -> Int {
    var erroredBackingsCount = 0

    if let erroredBackings = userFragment.backings?.nodes {
      erroredBackingsCount = erroredBackings.reduce(0) { accum, backing in
        var increment = false

        if backing?.errorReason != nil {
          increment = true
        }

        return increment ? accum + 1 : accum
      }
    }

    return erroredBackingsCount
  }

  internal static func isFacebookConnected(userFragment: GraphAPI.UserFragment) -> Bool? {
    var isFacebookConnected: Bool?

    if let facebookConnected = userFragment.isFacebookConnected {
      isFacebookConnected = facebookConnected
    }

    return isFacebookConnected
  }

  internal static func needsPassword(userFragment: GraphAPI.UserFragment) -> Bool {
    guard let userHasPassword = userFragment.hasPassword else {
      return true
    }

    return !userHasPassword
  }

  internal static func isAdmin(userFragment: GraphAPI.UserFragment) -> Bool? {
    var isAdmin: Bool?

    if let ksrAdmin = userFragment.isKsrAdmin {
      isAdmin = ksrAdmin
    }

    return isAdmin
  }

  internal static func isEmailVerified(userFragment: GraphAPI.UserFragment) -> Bool? {
    var isEmailVerified: Bool?

    if let emailVerified = userFragment.isEmailVerified {
      isEmailVerified = emailVerified
    }

    return isEmailVerified
  }

  internal static func location(locationFragment: GraphAPI.LocationFragment?) -> Location? {
    guard let locationFragment = locationFragment else {
      return nil
    }

    return Location.location(from: locationFragment)
  }
}

