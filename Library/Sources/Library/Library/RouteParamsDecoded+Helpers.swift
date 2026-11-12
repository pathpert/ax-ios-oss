import Foundation
import KsApi
import Prelude

/// String-keyed dictionary of path tokens and query parameters decoded from a matched route URL.
public typealias RouteParamsDecoded = [String: String]

internal func parsedParams(url: URL, fromTemplate template: String) -> RouteParamsDecoded? {
  let recognizedEmailHosts = [
    "clicks.kickstarter.com",
    "emails.kickstarter.com"
  ]

  let hostRecognizer = { accum, host in
    accum || url.host.map { $0.hasPrefix(host) } == .some(true)
  }

  let isRecognizedEmailHost = recognizedEmailHosts.reduce(false, hostRecognizer)

  let recognizedHosts = [
    AppEnvironment.current.apiService.serverConfig.apiBaseUrl.host,
    AppEnvironment.current.apiService.serverConfig.webBaseUrl.host,
    AppEnvironment.current.apiService.serverConfig.webBaseUrl.host?
      .replacingOccurrences(of: "www.", with: "")
  ].compact()

  let isRecognizedHost = recognizedHosts.reduce(false, hostRecognizer)

  guard isRecognizedHost || isRecognizedEmailHost else { return nil }

  let templateComponents = template
    .components(separatedBy: "/")
    .filter { $0 != "" }
  let urlComponents = url
    .path
    .components(separatedBy: "/")
    .filter { $0 != "" && !$0.hasPrefix("?") }

  // if we're parsing against the '/' emailClick template and this is a recognized email host
  // return the expected params for that route to be resolved
  if templateComponents.isEmpty, isRecognizedEmailHost {
    return [:]
  }

  guard templateComponents.count == urlComponents.count else { return nil }

  var params: [String: String] = [:]

  for (templateComponent, urlComponent) in zip(templateComponents, urlComponents) {
    if templateComponent.hasPrefix(":") {
      let paramName = String(templateComponent.dropFirst())
      params[paramName] = urlComponent
    } else if templateComponent != urlComponent {
      return nil
    }
  }

  URLComponents(url: url, resolvingAgainstBaseURL: false)?
    .queryItems?
    .forEach { item in
      params[item.name] = item.value
    }

  var object: RouteParamsDecoded = [:]
  params.forEach { key, value in
    object[key] = value
  }

  // If the deeplink opens the project page, track the url.
  if urlComponents.first == "projects" {
    object[RouteParamsDecoded.CodingKeys.deeplinkUrl.rawValue] = url.absoluteString
    object[RouteParamsDecoded.CodingKeys.path.rawValue] = url.path
  }

  return object
}

internal func refInfoFromParams(_ params: RouteParamsDecoded) -> RefInfo? {
  let refTag = params.refTag()
  let url = params.deeplinkUrl()
  if refTag != nil || url != nil {
    return RefInfo(refTag, deeplinkUrl: url)
  }
  return nil
}

extension RouteParamsDecoded {
  internal enum CodingKeys: String, CodingKey {
    case comment
    case deeplinkUrl = "deeplink_url"
    case messageThreadId = "message_thread_id"
    case notificationParam = "notification_param"
    case checkoutParam = "checkout_param"
    case enabledParam = "enabled_param"
    case path
    case payload
    case projectParam = "project_param"
    case ref
    case token
    case racing
    case reply
    case secretRewardToken = "secret_reward_token"
    case updateParam = "update_param"
    case surveyParam = "survey_param"
    case userParam = "user_param"
    case surveyResponseId = "survey_response_id"
    case orderEditId = "order_edit_id"
  }

  /// Extracts the `"comment"` identifier parameter if present.
  public func comment() -> String? {
    let key = CodingKeys.comment.rawValue
    return self[key].flatMap { String($0) }
  }

  /// Extracts the full matched `"deeplink_url"` string captured for project links.
  public func deeplinkUrl() -> String? {
    let key = CodingKeys.deeplinkUrl.rawValue
    return self[key]
  }

  /// Extracts the boolean `"enabled_param"` flag from notification settings routes.
  public func enabledParam() -> Bool? {
    let key = CodingKeys.enabledParam.rawValue
    return self[key].flatMap(Bool.init)
  }

  /// Extracts the URL `"path"` component recorded for matched project links.
  public func path() -> String? {
    let key = CodingKeys.path.rawValue
    return self[key]
  }

  /// Extracts a typed `RefTag` from the `"ref"` query parameter.
  public func refTag() -> RefTag? {
    let key = CodingKeys.ref.rawValue
    return self[key].flatMap { RefTag.init(code: $0) }
  }

  /// Extracts the `"reply"` comment identifier parameter if present.
  public func reply() -> String? {
    let key = CodingKeys.reply.rawValue
    return self[key].flatMap { String($0) }
  }

  /// Extracts the project preview `"token"` query parameter if present.
  public func token() -> String? {
    let key = CodingKeys.token.rawValue
    return self[key]
  }

  /// Extracts the `Param.slug` value for `:project_param`.
  public func projectParam() -> Param? {
    let key = CodingKeys.projectParam.rawValue
    return self[key].flatMap { .slug($0) }
  }

  /// Extracts the `Param.slug` value for `:user_param`.
  public func userParam() -> Param? {
    let key = CodingKeys.userParam.rawValue
    return self[key].flatMap { .slug($0) }
  }

  /// Extracts the `"secret_reward_token"` query parameter for secret rewards.
  public func secretRewardToken() -> String? {
    let key = CodingKeys.secretRewardToken.rawValue
    return self[key]
  }

  /// Extracts the integer identifier for `:survey_param`.
  public func surveyParam() -> Int? {
    let key = CodingKeys.surveyParam.rawValue
    return self[key].flatMap { Int($0) }
  }

  /// Extracts the integer update identifier for `:update_param`.
  public func updateParam() -> Int? {
    let key = CodingKeys.updateParam.rawValue
    return self[key].flatMap { Int($0) }
  }

  /// Extracts the integer message thread identifier for `:message_thread_id`.
  public func messageThreadId() -> Int? {
    let key = CodingKeys.messageThreadId.rawValue
    return self[key].flatMap { Int($0) }
  }

  /// Extracts the notification key name for `:notification_param`.
  public func notificationParam() -> String? {
    let key = CodingKeys.notificationParam.rawValue
    return self[key]
  }

  /// Extracts the integer checkout identifier for `:checkout_param`.
  public func checkoutParam() -> Int? {
    let key = CodingKeys.checkoutParam.rawValue
    return self[key].flatMap { Int($0) }
  }

  /// Extracts the serialized Apple Pay `"payload"` parameter.
  public func payload() -> String? {
    let key = CodingKeys.payload.rawValue
    return self[key]
  }

  /// Extracts whether `"racing"` equals `"1"` on checkout thanks links.
  public func racing() -> Bool? {
    let key = CodingKeys.racing.rawValue
    return self[key].flatMap { Int($0) }.map { $0 == 1 }
  }

  /// Extracts the integer survey response identifier for `:survey_response_id`.
  public func surveyResponseId() -> Int? {
    let key = CodingKeys.surveyResponseId.rawValue
    return self[key].flatMap { Int($0) }
  }

  /// Extracts the integer order edit identifier for `:order_edit_id`.
  public func orderEditParam() -> Int? {
    let key = CodingKeys.orderEditId.rawValue
    return self[key].flatMap { Int($0) }
  }
}

