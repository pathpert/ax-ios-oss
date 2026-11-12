import FirebaseCrashlytics
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Resolves a stream of `Navigation` values (deep links) into concrete UI actions. Pulled out of
/// `AppDelegateViewModel` so the navigation-resolution logic can be shared: an upcoming
/// `SceneDelegateViewModel` will feed it from URL / continue-user-activity / shortcut-item deep
/// links, alongside `AppDelegateViewModel`'s own push-notification and Braze deep links.
internal struct DeepLinkNavigationRouter {
  internal let goToActivity: Signal<(), Never>
  internal let goToDiscovery: Signal<DiscoveryParams?, Never>
  internal let goToLoginWithIntent: Signal<LoginIntent, Never>
  internal let goToMessageThread: Signal<MessageThread, Never>
  internal let goToProfile: Signal<(), Never>
  internal let goToSearch: Signal<(), Never>
  internal let presentViewController: Signal<UIViewController, Never>
  internal let updateCurrentUserInEnvironment: Signal<User, Never>

  internal init(deepLink: Signal<Navigation, Never>) {
    let fixErroredPledgeLinkAndNeedsToLogin = deepLink
      .filter { link in
        guard case let .project(_, subpage, _, _) = link else { return false }
        guard case .pledge(.manage) = subpage else { return false }
        return AppEnvironment.current.currentUser == nil
      }

    let goToActivity = deepLink.filter { $0 == .tab(.activity) }.ignoreValues()
    let goToSearch = deepLink.filter { $0 == .tab(.search) }.ignoreValues()
    let goToLogin = deepLink.filter { $0 == .tab(.login) }.ignoreValues()

    let goToLoginWithIntent: Signal<LoginIntent, Never> = Signal.merge(
      fixErroredPledgeLinkAndNeedsToLogin.mapConst(.erroredPledge),
      goToLogin.mapConst(.generic)
    )

    let goToProfile = deepLink.filter { $0 == .tab(.me) }.ignoreValues()

    let goToDiscovery = deepLink
      .map { link -> [String: String]?? in
        guard case let .tab(.discovery(rawParams)) = link else { return nil }
        return .some(rawParams)
      }
      .skipNil()
      .switchMap { rawParams -> SignalProducer<DiscoveryParams?, Never> in
        guard
          let rawParams = rawParams,
          let params = DiscoveryParams.decodeJSONDictionary(rawParams)
        else {
          return .init(value: nil)
        }

        let categories = deepLinkCategories(rawParams: rawParams)
        guard let categoryParam = categories.0 else {
          return .init(value: params)
        }

        return AppEnvironment.current.apiService.fetchGraphCategories()
          .map { envelope in
            findCategoryFromRootCategories(
              envelope: envelope,
              categoryParam: categoryParam,
              subcategoryParam: categories.1
            )
          }
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .demoteErrors()
          .map { params |> DiscoveryParams.lens.category .~ $0 }
      }

    let goToMessageThread = deepLink
      .map { navigation -> Int? in
        guard case let .messages(messageThreadId) = navigation else { return nil }
        return .some(messageThreadId)
      }
      .skipNil()
      .switchMap {
        AppEnvironment.current.apiService.fetchMessageThread(messageThreadId: $0)
          .demoteErrors()
          .map { $0.messageThread }
      }

    let updatedUserNotificationSettings = deepLink.filter { nav in
      guard case .settings(.notifications) = nav else { return false }
      return true
    }
    .flatMap(updateUserNotificationSetting)

    let surveyUrlFromUserLink = deepLink
      .map { link -> Int? in
        if case let .user(_, .survey(surveyResponseId)) = link { return surveyResponseId }
        return nil
      }
      .skipNil()
      .switchMap { surveyResponseId in
        AppEnvironment.current.apiService.fetchSurveyResponse(surveyResponseId: surveyResponseId)
          .demoteErrors()
          .map { $0.urls.web.survey }
      }

    let surveyUrlFromProjectLink = deepLink
      .map { link -> String? in
        if case let .project(_, .pledgeManagerWebview(surveyUrl), _, _) = link {
          return surveyUrl
        }
        return nil
      }
      .skipNil()

    let pledgeManagerLink = Signal.merge(surveyUrlFromProjectLink, surveyUrlFromUserLink)
      .observeForUI()
      .map { url -> UINavigationController in
        let pm = PledgeManagerWebViewController.configuredWith(url: url)
        let nav = UINavigationController(rootViewController: pm)
        // See PR #2650 for additional context. This used to be added in the view controller.
        nav.modalPresentationStyle = .pageSheet
        return nav
      }

    let projectLinks = ProjectDeepLink.projectViewControllers(fromDeepLink: deepLink)
    let presentViewController = Signal.merge(projectLinks, pledgeManagerLink)
      .map { $0 as UIViewController }

    self.goToActivity = goToActivity
    self.goToDiscovery = goToDiscovery
    self.goToLoginWithIntent = goToLoginWithIntent
    self.goToMessageThread = goToMessageThread
    self.goToProfile = goToProfile
    self.goToSearch = goToSearch
    self.presentViewController = presentViewController
    self.updateCurrentUserInEnvironment = updatedUserNotificationSettings
  }
}

/// If a URL doesn't match a deep link, whether it should be opened in the browser instead.
internal func shouldOpenUrlInBrowser(_ url: URL) -> Bool {
  // If url has a deeplink match, never attempt to open the url in the browser.
  if Navigation.deepLinkMatch(url) != nil {
    return false
  }
  // Never attempt to open `ksr` urls in the browser; they'll redirect straight back to our app.
  if let scheme = url.scheme, scheme == "ksr" {
    print(
      "Error: Unable to open 'ksr' deeplink. Please doublecheck that the url "
        + "is included in the list of deeplinks and that you're not trying to "
        + "use a staging url in prod (or vice versa)."
    )
    let error = NSError(domain: "Kickstarter.Deeplink", code: 0, userInfo: [
      NSLocalizedDescriptionKey: "Unable to open unsupported ksr deeplink."
    ])
    Crashlytics.crashlytics().record(error: error)
    return false
  }
  // Otherwise, open url in browser.
  return true
}

/// Handles the deeplink route with both an id and text based name for a deeplink to categories.
private func deepLinkCategories(rawParams: [String: String]) -> (Param?, Param?) {
  let parentCategoryParams = rawParams["parent_category_id"]
  let subCategoryParams = rawParams["category_id"]
  var categoryParam: Param?
  var subcategoryParam: Param?

  let parseParam: (String?) -> Param? = { rawValue in
    guard let rawValue else { return nil }
    if let numericId = Int(rawValue) { return .id(numericId) }
    return .slug(rawValue)
  }

  categoryParam = parseParam(parentCategoryParams)
  subcategoryParam = parseParam(subCategoryParams)

  let subCategoryWithNoParentCategory = categoryParam == nil && subcategoryParam != nil
  categoryParam = subCategoryWithNoParentCategory ? subcategoryParam : categoryParam
  subcategoryParam = subCategoryWithNoParentCategory ? nil : subcategoryParam

  return (categoryParam, subcategoryParam)
}

/// Will check id and name of category and subcategory against all available categories and subcategories inside envelope
private func findCategoryFromRootCategories(
  envelope: RootCategoriesEnvelope,
  categoryParam: Param,
  subcategoryParam: Param?
) -> KsApi.Category? {
  let allRootCategoryIdsAndNames = envelope.rootCategories.compactMap { $0 }
  let allSubcategoryIdsAndNames = envelope.rootCategories.compactMap { $0.subcategories?.nodes }.flatMap { $0 }
  let allCategoryIdsAndNames = allRootCategoryIdsAndNames + allSubcategoryIdsAndNames

  let routableCategory = allCategoryIdsAndNames.first { category in
    category.intID == categoryParam.id || category.name.lowercased() == categoryParam.slug?.lowercased()
  }

  let routableSubcategory = routableCategory != nil ? allCategoryIdsAndNames.first { category in
    category.intID == subcategoryParam?.id || category.name.lowercased() == subcategoryParam?.slug?.lowercased()
  } : nil

  return routableSubcategory ?? routableCategory
}

private func updateUserNotificationSetting(navigation: Navigation) -> SignalProducer<User, Never> {
  guard
    case let .settings(.notifications(notification, enabled)) = navigation,
    let currentUser = AppEnvironment.current.currentUser
  else { return .empty }

  var userNotifications = currentUser.notifications
  guard userNotifications.setNotification(apiKey: notification, enabled: enabled) else {
    return .empty
  }

  let updatedUser = currentUser |> User.lens.notifications .~ userNotifications

  return AppEnvironment.current.apiService.updateUserSelf(updatedUser)
    .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    .demoteErrors()
}
