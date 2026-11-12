import Foundation
import KsApi

extension Navigation {
  /// Matches a web or universal link `url` against all registered Kickstarter routes.
  public static func match(_ url: URL) -> Navigation? {
    return allRoutes.reduce(nil) { accum, templateAndRoute in
      let (template, route) = templateAndRoute
      return accum ?? parsedParams(url: url, fromTemplate: template).flatMap(route)
    }
  }

  /// Matches a universal/deep link `url` against the restricted set of external deep link routes.
  public static func deepLinkMatch(_ url: URL) -> Navigation? {
    return deepLinkRoutes.reduce(nil) { accum, templateAndRoute in
      let (template, route) = templateAndRoute
      return accum ?? parsedParams(url: url, fromTemplate: template).flatMap(route)
    }
  }

  /// Matches the `url` of a `URLRequest` using `Navigation.match(_:)`.
  public static func match(_ request: URLRequest) -> Navigation? {
    return request.url.flatMap(self.match)
  }
}

private let allRoutes: [String: (RouteParamsDecoded) -> Navigation?] = [
  "/": emailClickRoute, // Email clicks require a redirect in order to find the actual path.
  "/activity": activityRoute,
  "/authorize": authorizeRoute,
  "/checkouts/:checkout_param/payments": paymentsRootRoute,
  "/checkouts/:checkout_param/payments/new": paymentsNewRoute,
  "/checkouts/:checkout_param/payments/apple-pay": paymentsApplePayRoute,
  "/checkouts/:checkout_param/payments/use_stored_card": paymentsUseStoredCardRoute,
  "/discover": discoveryRoute,
  "/discover/advanced": discoveryRoute,
  "/discover/categories/:category_id": discoveryRoute,
  "/discover/categories/:parent_category_id/:category_id": discoveryRoute,
  "/messages/:message_thread_id": messagesRoute,
  "/profile/:user_param": meRoute,
  "/profile/verify_email": verifyEmailRoute,
  "/search": searchRoute,
  "/signup": signupRoute,
  "/projects/:creator_param/:project_param": projectRoute,
  "/projects/:creator_param/:project_param/backing/:backing_tab": pledgeManagerWebviewRoute,
  "/projects/:creator_param/:project_param/checkouts/:checkout_param/thanks": thanksRoute,
  "/projects/:creator_param/:project_param/comments": projectCommentsRoute,
  "/projects/:creator_param/:project_param/creator_bio": creatorBioRoute,
  "/projects/:creator_param/:project_param/description": projectRoute,
  "/projects/:creator_param/:project_param/faqs": projectRoute,
  "/projects/:creator_param/:project_param/friends": friendsRoute,
  "/projects/:creator_param/:project_param/messages/new": messageCreatorRoute,
  "/projects/:creator_param/:project_param/pledge": pledgeRootRoute,
  "/projects/:creator_param/:project_param/pledge/big_print": pledgeBigPrintRoute,
  "/projects/:creator_param/:project_param/pledge/change_method": pledgeChangeMethodRoute,
  "/projects/:creator_param/:project_param/pledge/destroy": pledgeDestroyRoute,
  "/projects/:creator_param/:project_param/pledge/edit": pledgeEditRoute,
  "/projects/:creator_param/:project_param/pledge/new": pledgeNewRoute,
  "/projects/:creator_param/:project_param/posts": postsRoute,
  "/projects/:creator_param/:project_param/posts/:update_param": updateRoute,
  "/projects/:creator_param/:project_param/updates": updatesRoute,
  "/projects/:creator_param/:project_param/posts/:update_param/comments": updateCommentsRoute,
  "/projects/:creator_param/:project_param/surveys/:survey_param": pledgeManagerWebviewRoute,
  "/projects/:creator_param/:project_param/surveys/:survey_param/edit": pledgeManagerWebviewRoute,
  "/projects/:creator_param/:project_param/surveys/:survey_param/edit_address": pledgeManagerWebviewRoute,
  "/settings/:notification_param/:enabled_param": settingsNotificationsRoute,
  "/users/:user_param/surveys/:survey_response_id": userSurveyRoute,
  "/projects/:creator_param/:project_param/order_edits/:order_edit_id/checkout": pledgeManagerWebviewRoute,
  "/projects/:creator_param/:project_param/order_edits/new": pledgeManagerWebviewRoute
]

private let deepLinkRoutes: [String: (RouteParamsDecoded) -> Navigation?] = allRoutes.restrict(
  keys: [
    "/",
    "/activity",
    "/discover",
    "/discover/advanced",
    "/discover/categories/:category_id",
    "/discover/categories/:parent_category_id/:category_id",
    "/messages/:message_thread_id",
    "/profile/verify_email",
    "/projects/:creator_param/:project_param",
    "/projects/:creator_param/:project_param/backing/:backing_tab",
    "/projects/:creator_param/:project_param/comments",
    "/projects/:creator_param/:project_param/description",
    "/projects/:creator_param/:project_param/faqs",
    "/projects/:creator_param/:project_param/posts",
    "/projects/:creator_param/:project_param/posts/:update_param",
    "/projects/:creator_param/:project_param/posts/:update_param/comments",
    "/projects/:creator_param/:project_param/surveys/:survey_param",
    "/projects/:creator_param/:project_param/surveys/:survey_param/edit",
    "/projects/:creator_param/:project_param/surveys/:survey_param/edit_address",
    "/projects/:creator_param/:project_param/pledge",
    "/settings/:notification_param/:enabled_param",
    "/users/:user_param/surveys/:survey_response_id",
    "/projects/:creator_param/:project_param/order_edits/:order_edit_id/checkout"
  ]
)

extension Dictionary {
  fileprivate func restrict(keys: Set<Key>) -> Dictionary {
    var result = Dictionary()
    self.forEach { key, value in
      if keys.contains(key) {
        result[key] = value
      }
    }
    return result
  }
}

