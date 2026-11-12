import Foundation
import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
/// Enumeration representing `Route` cases.
internal enum Route {
  case activities(categories: [Activity.Category], count: Int?)
  case addImage(fileUrl: URL, toDraft: UpdateDraft)
  case backing(projectId: Int, backerId: Int)
  case backingUpdate(projectId: Int, backerId: Int, received: Bool)
  case config
  case deleteImage(UpdateDraft.Image, fromDraft: UpdateDraft)
  case discover(DiscoveryParams)
  case exchangeToken(params: OAuthTokenExchangeParams)
  case facebookConnect(facebookAccessToken: String)
  case facebookLogin(facebookAccessToken: String, code: String?)
  case facebookSignup(facebookAccessToken: String, sendNewsletters: Bool)
  case fetchUpdateDraft(forProject: Project)
  case friends
  case friendStats
  case followAllFriends
  case followFriend(userId: Int)
  case incrementVideoCompletion(project: any HasProjectWebURL)
  case incrementVideoStart(project: any HasProjectWebURL)
  case login(email: String, password: String, code: String?)
  case markAsRead(MessageThread)
  case messagesForThread(messageThreadId: Int)
  case messagesForBacking(Backing)
  case messageThreads(mailbox: Mailbox, project: Project?)
  case project(Param)
  case projectActivities(Project)
  case projectNotifications
  case projects(member: Bool)
  case projectStats(projectId: Int)
  case publishUpdateDraft(UpdateDraft)
  case registerPushToken(String)
  case resetPassword(email: String)
  case searchMessages(query: String, project: Project?)
  case sendMessage(body: String, messageSubject: MessageSubject)
  case shippingRules(projectId: Int, rewardId: Int)
  case surveyResponse(surveyResponseId: Int)
  case unansweredSurveyResponses
  case unfollowFriend(userId: Int)
  case update(updateId: Int, projectParam: Param)
  case updateProjectNotification(notification: ProjectNotification)
  case updateUpdateDraft(UpdateDraft, title: String, body: String, isPublic: Bool)
  case updateUserSelf(User)
  case userSelf
  case user(userId: Int)
  case verifyEmail(accessToken: String)

  enum UploadParam: String {
    case image
    case video
  }

  internal var requestProperties: (
    method: Method,
    path: String,
    params: any EncodableQueryParams,
    file: (name: UploadParam, url: URL)?
  ) {
    switch self {
    case let .activities(categories, count):
      return (
        .GET,
        "/v1/activities",
        ActivitiesQueryParams(categories: categories.map { $0.rawValue }, count: count),
        nil
      )

    case let .addImage(file, draft):
      return (.POST, "/v1/projects/\(draft.update.projectId)/updates/draft/images", EmptyQueryParams(), (.image, file))

    case let .backing(projectId, backerId):
      return (.GET, "/v1/projects/\(projectId)/backers/\(backerId)", EmptyQueryParams(), nil)

    case let .backingUpdate(projectId, backerId, received):
      return (.PUT, "/v1/projects/\(projectId)/backers/\(backerId)", BackingUpdateQueryParams(received: received), nil)

    case .config:
      return (.GET, "/v1/app/ios/config", CacheBustQueryParams(), nil)

    case let .exchangeToken(params):
      return (.POST, "v1/oauth/authorizations/exchange", params, nil)

    case let .deleteImage(i, draft):
      return (.DELETE, "/v1/projects/\(draft.update.projectId)/updates/draft/images/\(i.id)", EmptyQueryParams(), nil)

    case let .discover(params):
      return (.GET, "/v1/discover", DiscoveryQueryParams(params: params), nil)

    case let .facebookConnect(token):
      return (.PUT, "v1/facebook/connect", FacebookConnectQueryParams(accessToken: token), nil)

    case let .facebookLogin(facebookAccessToken, code):
      return (.PUT, "/v1/facebook/access_token", FacebookLoginQueryParams(accessToken: facebookAccessToken, code: code), nil)

    case let .facebookSignup(facebookAccessToken, sendNewsletters):
      return (
        .PUT,
        "/v1/facebook/access_token",
        FacebookSignupQueryParams(accessToken: facebookAccessToken, sendNewsletters: sendNewsletters),
        nil
      )

    case let .fetchUpdateDraft(project):
      return (.GET, "/v1/projects/\(project.id)/updates/draft", EmptyQueryParams(), nil)

    case .friends:
      return (.GET, "v1/users/self/friends/find", EmptyQueryParams(), nil)

    case .friendStats:
      return (.GET, "v1/users/self/friends/find", FriendStatsQueryParams(), nil)

    case .followAllFriends:
      return (.PUT, "v1/users/self/friends/follow_all", EmptyQueryParams(), nil)

    case let .followFriend(userId):
      return (.POST, "v1/users/self/friends", FollowFriendQueryParams(followedId: userId), nil)

    case let .incrementVideoCompletion(project):
      let statsURL = URL(string: project.projectWebURL)?.appendingPathComponent("video/plays")
      return (.POST, statsURL?.absoluteString ?? "", VideoPlayEventQueryParams(eventType: .complete), nil)

    case let .incrementVideoStart(project):
      let statsURL = URL(string: project.projectWebURL)?.appendingPathComponent("video/plays")
      return (.POST, statsURL?.absoluteString ?? "", VideoPlayEventQueryParams(eventType: .start), nil)

    case let .login(email, password, code):
      return (.POST, "/xauth/access_token", LoginQueryParams(email: email, password: password, code: code), nil)

    case let .markAsRead(messageThread):
      return (.PUT, "/v1/message_threads/\(messageThread.id)/read", EmptyQueryParams(), nil)

    case let .messagesForThread(messageThreadId):
      return (.GET, "/v1/message_threads/\(messageThreadId)/messages", EmptyQueryParams(), nil)

    case let .messagesForBacking(backing):
      return (.GET, "/v1/projects/\(backing.projectId)/backers/\(backing.backerId)/messages", EmptyQueryParams(), nil)

    case let .messageThreads(mailbox, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/\(mailbox.rawValue)", EmptyQueryParams(), nil)
      }
      return (.GET, "/v1/message_threads/\(mailbox.rawValue)", EmptyQueryParams(), nil)

    case let .project(param):
      return (.GET, "/v1/projects/\(param.escapedUrlComponent)", EmptyQueryParams(), nil)

    case let .projectActivities(project):
      return (.GET, "/v1/projects/\(project.id)/activities", EmptyQueryParams(), nil)

    case .projectNotifications:
      return (.GET, "/v1/users/self/notifications", EmptyQueryParams(), nil)

    case let .projects(member):
      return (.GET, "/v1/users/self/projects", MemberProjectsQueryParams(member: member), nil)

    case let .projectStats(projectId):
      return (.GET, "/v1/projects/\(projectId)/stats", EmptyQueryParams(), nil)

    case let .publishUpdateDraft(d):
      return (.POST, "/v1/projects/\(d.update.projectId)/updates/draft/publish", EmptyQueryParams(), nil)

    case let .registerPushToken(token):
      return (.POST, "v1/users/self/ios/push_tokens", RegisterPushTokenQueryParams(token: token), nil)

    case let .resetPassword(email):
      return (.POST, "/v1/users/reset", ResetPasswordQueryParams(email: email), nil)

    case let .searchMessages(query, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/search", SearchMessagesQueryParams(query: query), nil)
      }
      return (.GET, "/v1/message_threads/search", SearchMessagesQueryParams(query: query), nil)

    case let .sendMessage(body, messageSubject):
      switch messageSubject {
      case let .messageThread(messageThread):
        return (.POST, "/v1/message_threads/\(messageThread.id)/messages", SendMessageQueryParams(body: body), nil)

      case let .project(projectId, _):
        return (.POST, "v1/projects/\(projectId)/messages", SendMessageQueryParams(body: body), nil)
      }

    case let .shippingRules(projectId, rewardId):
      return (.GET, "/v1/projects/\(projectId)/rewards/\(rewardId)/shipping_rules", EmptyQueryParams(), nil)

    case let .surveyResponse(surveyResponseId):
      return (.GET, "/v1/users/self/surveys/\(surveyResponseId)", EmptyQueryParams(), nil)

    case .unansweredSurveyResponses:
      return (.GET, "/v1/users/self/surveys/unanswered", EmptyQueryParams(), nil)

    case let .unfollowFriend(userId):
      return (.DELETE, "v1/users/self/friends/\(userId)", EmptyQueryParams(), nil)

    case let .update(id, projectParam):
      return (.GET, "v1/projects/\(projectParam.escapedUrlComponent)/updates/\(id)", EmptyQueryParams(), nil)

    case let .updateUpdateDraft(d, title, body, isPublic):
      return (
        .PUT,
        "/v1/projects/\(d.update.projectId)/updates/draft",
        UpdateDraftQueryParams(title: title, body: body, isPublic: isPublic),
        nil
      )

    case let .updateProjectNotification(notification):
      return (
        .PUT,
        "/v1/users/self/notifications/\(notification.id)",
        ProjectNotificationQueryParams(email: notification.email, mobile: notification.mobile),
        nil
      )

    case let .updateUserSelf(user):
      return (.PUT, "/v1/users/self", UpdateUserSelfQueryParams(user: user), nil)

    case .userSelf:
      return (.GET, "/v1/users/self", EmptyQueryParams(), nil)

    case let .user(userId):
      return (.GET, "/v1/users/\(userId)", EmptyQueryParams(), nil)

    case let .verifyEmail(accessToken):
      return (.POST, "/v1/users/self/verify_email", VerifyEmailQueryParams(emailAccessToken: accessToken), nil)
    }
  }
}
