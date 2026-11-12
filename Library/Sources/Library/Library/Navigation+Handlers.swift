import Foundation
import KsApi

/// Enumeration representing `NavigationRouteConstants` cases.
private enum NavigationRouteConstants {
  static let backingDetailsPath = "backing/details"
  static let fallbackBackingPath = "backing/survey_responses"
}

internal func emailClickRoute(_: RouteParamsDecoded) -> Navigation {
  return Navigation.emailClick
}

internal func activityRoute(_: RouteParamsDecoded) -> Navigation {
  return .tab(.activity)
}

internal func authorizeRoute(_: RouteParamsDecoded) -> Navigation {
  return .tab(.login)
}

internal func messagesRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let messageId = params.messageThreadId() else {
    return nil
  }
  return Navigation.messages(messageThreadId: messageId)
}

internal func paymentsNewRoute(_ params: RouteParamsDecoded) -> Navigation? {
  if let checkoutParam = params.checkoutParam() {
    return Navigation.checkout(checkoutParam, .payments(.new))
  }
  return nil
}

internal func paymentsApplePayRoute(_ params: RouteParamsDecoded) -> Navigation? {
  if let checkoutParam = params.checkoutParam(),
     let payload = params.payload() {
    return Navigation.checkout(checkoutParam, Navigation.Checkout.payments(.applePay(payload: payload)))
  }
  return nil
}

internal func paymentsRootRoute(_ params: RouteParamsDecoded) -> Navigation? {
  if let checkoutParam = params.checkoutParam() {
    return Navigation.checkout(checkoutParam, .payments(.root))
  }
  return nil
}

internal func paymentsUseStoredCardRoute(_ params: RouteParamsDecoded) -> Navigation? {
  if let checkoutParam = params.checkoutParam() {
    return Navigation.checkout(checkoutParam, .payments(.useStoredCard))
  }
  return nil
}

internal func discoveryRoute(_ params: RouteParamsDecoded) -> Navigation {
  guard !params.isEmpty else {
    return .tab(.discovery(nil))
  }

  return .tab(.discovery(params))
}

internal func meRoute(_ params: RouteParamsDecoded) -> Navigation {
  // Avoid ambiguity with :user_param
  if case let .slug(slug) = params.userParam(), slug == "verify_email" {
    return verifyEmailRoute(params)
  }

  return .tab(.me)
}

internal func verifyEmailRoute(_: RouteParamsDecoded) -> Navigation {
  return .profile(.verifyEmail)
}

internal func searchRoute(_: RouteParamsDecoded) -> Navigation {
  return .tab(.search)
}

internal func signupRoute(_: RouteParamsDecoded) -> Navigation {
  return .signup
}

internal func projectRoute(_ params: RouteParamsDecoded) -> Navigation? {
  if params.token() != nil {
    return nil
  } else if let projectParam = params.projectParam() {
    let refInfo = refInfoFromParams(params)
    let secretRewardToken = params.secretRewardToken()
    return Navigation.project(projectParam, .root, refInfo: refInfo, secretRewardToken: secretRewardToken)
  }

  return nil
}

internal func thanksRoute(_ params: RouteParamsDecoded) -> Navigation? {
  if let projectParam = params.projectParam(),
     let checkoutParam = params.checkoutParam() {
    let refInfo = refInfoFromParams(params)
    let thanks = Navigation.Project.Checkout.thanks(racing: params.racing())
    let checkout = Navigation.Project.checkout(checkoutParam, thanks)
    return Navigation.project(projectParam, checkout, refInfo: refInfo)
  }

  return nil
}

internal func projectCommentsRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  let refInfo = refInfoFromParams(params)

  guard let commentId = params.comment() else {
    return .project(projectParam, .comments, refInfo: refInfo)
  }

  return .project(projectParam, .commentThread(commentId, params.reply()), refInfo: refInfo)
}

internal func creatorBioRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .creatorBio, refInfo: refInfoFromParams(params))
}

internal func friendsRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .friends, refInfo: refInfoFromParams(params))
}

internal func messageCreatorRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .messageCreator, refInfo: refInfoFromParams(params))
}

internal func pledgeBigPrintRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .pledge(.bigPrint), refInfo: refInfoFromParams(params))
}

internal func pledgeChangeMethodRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .pledge(.changeMethod), refInfo: refInfoFromParams(params))
}

internal func pledgeDestroyRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .pledge(.destroy), refInfo: refInfoFromParams(params))
}

internal func pledgeEditRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .pledge(.edit), refInfo: refInfoFromParams(params))
}

internal func pledgeNewRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, .pledge(.new), refInfo: refInfoFromParams(params))
}

internal func pledgeRootRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  let refInfo = refInfoFromParams(params)
  let parseRoot = Navigation.project(projectParam, .pledge(.root), refInfo: refInfo)
  guard refInfo?.refTag == .emailBackerFailedTransaction else {
    return parseRoot
  }
  return Navigation.project(projectParam, .pledge(.manage), refInfo: refInfo)
}

internal func postsRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, Navigation.Project.updates, refInfo: refInfoFromParams(params))
}

internal func pledgeManagerWebviewRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard
    let projectParam = params.projectParam(),
    var path = params.path()
  else { return nil }

  // Fallback logic for deeplinks: replace `backing/details` with `backing/survey_responses`
  // to prevent re-authentication prompts in the WebView caused by backend restrictions.
  if path.hasSuffix(NavigationRouteConstants.backingDetailsPath) {
    path = path.replacingOccurrences(
      of: NavigationRouteConstants.backingDetailsPath,
      with: NavigationRouteConstants.fallbackBackingPath
    )
  }

  let url = AppEnvironment.current.apiService.serverConfig.webBaseUrl.absoluteString + path
  let refInfo = refInfoFromParams(params)
  let pmWebview = Navigation.Project.pledgeManagerWebview(url)
  return Navigation.project(projectParam, pmWebview, refInfo: refInfo)
}

internal func updateRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard
    let projectParam = params.projectParam(),
    let updateParam = params.updateParam()
  else { return nil }

  return Navigation.project(projectParam, .update(updateParam, .root), refInfo: refInfoFromParams(params))
}

internal func updateCommentsRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard
    let projectParam = params.projectParam(),
    let updateParam = params.updateParam()
  else { return nil }

  let refInfo = refInfoFromParams(params)
  guard let commentId = params.comment() else {
    return .project(projectParam, .update(updateParam, .comments), refInfo: refInfo)
  }

  return .project(
    projectParam,
    .update(updateParam, .commentThread(commentId, params.reply())),
    refInfo: refInfo
  )
}

internal func updatesRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard let projectParam = params.projectParam() else { return nil }
  return Navigation.project(projectParam, Navigation.Project.updates, refInfo: refInfoFromParams(params))
}

internal func userSurveyRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard
    let userParam = params.userParam(),
    let surveyResponseId = params.surveyResponseId()
  else { return nil }

  return Navigation.user(userParam, Navigation.User.survey(surveyResponseId))
}

internal func settingsNotificationsRoute(_ params: RouteParamsDecoded) -> Navigation? {
  guard
    let notificationsParam = params.notificationParam(),
    let enabled = params.enabledParam()
  else { return nil }

  return Navigation.settings(.notifications(notificationsParam, enabled))
}

