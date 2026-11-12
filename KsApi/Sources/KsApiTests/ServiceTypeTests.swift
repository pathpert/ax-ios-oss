@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

final class ServiceTypeTests: XCTestCase {
  private let service = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: URL(string: "http://api.ksr.com")!,
      webBaseUrl: URL(string: "http://www.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: BasicHTTPAuth(
        username: "username",
        password: "password"
      ),
      graphQLEndpointUrl: URL(string: "http://www.ksr.com")!
    ),
    oauthToken: OauthToken(
      token: "cafebeef"
    ),
    language: "ksr",
    buildVersion: "1234567890",
    deviceIdentifier: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
  )

  private let anonAdHocService = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: URL(string: "http://api-hq.dev.ksr.com")!,
      webBaseUrl: URL(string: "http://hq.dev.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: BasicHTTPAuth(
        username: "username",
        password: "password"
      ),
      graphQLEndpointUrl: URL(string: "http://ksr.dev/graph")!
    ),
    deviceIdentifier: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
  )

  private let anonService = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: URL(string: "http://api.ksr.com")!,
      webBaseUrl: URL(string: "http://hq.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: nil,
      graphQLEndpointUrl: URL(string: "http://ksr.dev/graph")!
    ),
    deviceIdentifier: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
  )

  func testEquals() {
    XCTAssertTrue(Service() != MockService())
  }

  func testIsPreparedAdhocWithoutOauthToken() {
    let url = URL(string: "http://api-dev.ksr.com/v1/test?key=value")!
    let request = URLRequest(url: url)
    XCTAssertFalse(self.anonAdHocService.isPrepared(request: request))
    XCTAssertTrue(
      self.anonAdHocService.isPrepared(
        request:
        self.anonAdHocService.preparedRequest(forRequest: request)
      )
    )
  }

  func testIsPreparedWithOauthToken() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = URLRequest(url: url)
    XCTAssertFalse(self.service.isPrepared(request: request))
    XCTAssertTrue(self.service.isPrepared(request: self.service.preparedRequest(forRequest: request)))
  }

  func testIsPreparedWithoutOauthToken() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = URLRequest(url: url)
    XCTAssertFalse(self.anonService.isPrepared(request: request))
    XCTAssertTrue(self.anonService.isPrepared(request: self.anonService.preparedRequest(forRequest: request)))
  }

  func testPreparedRequest() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = self.service.preparedRequest(forRequest: .init(url: url))

    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "1234567890",
        "Authorization": "token cafebeef",
        "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
        "X-Auth": "token cafebeef"
      ],
      request.allHTTPHeaderFields!
    )
  }

  private struct TestExtraQueryParams: EncodableQueryParams {
    let extra: String
  }

  private struct TestAmountQueryParams: EncodableQueryParams {
    let amount: Int
  }

  func testPreparedURL() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = self.service.preparedRequest(forURL: url, params: TestExtraQueryParams(extra: "1"))

    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&extra=1&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "1234567890",
        "Authorization": "token cafebeef",
        "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
        "X-Auth": "token cafebeef"
      ],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("GET", request.httpMethod)
  }

  func testPreparedDeleteURL() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = self.service.preparedRequest(
      forURL: url,
      method: .DELETE,
      params: TestExtraQueryParams(extra: "1")
    )

    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&extra=1&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "1234567890",
        "Authorization": "token cafebeef",
        "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
        "X-Auth": "token cafebeef"
      ],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("DELETE", request.httpMethod)
  }

  func testPreparedPostURL() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = self.service.preparedRequest(
      forURL: url,
      method: .POST,
      params: TestExtraQueryParams(extra: "1")
    )

    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "1234567890",
        "Authorization": "token cafebeef",
        "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "Content-Type": "application/json; charset=utf-8",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
        "X-Auth": "token cafebeef"
      ],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.httpMethod)
    XCTAssertEqual(
      "{\"extra\":\"1\"}",
      String(data: request.httpBody ?? Data(), encoding: .utf8)
    )
  }

  func testPreparedPostURLWithBody() {
    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    var baseRequest = URLRequest(url: url)
    let body = "test".data(using: .utf8, allowLossyConversion: false)
    baseRequest.httpBody = body
    baseRequest.httpMethod = "POST"
    let request = self.service.preparedRequest(forRequest: baseRequest, params: TestExtraQueryParams(extra: "1"))

    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "1234567890",
        "Authorization": "token cafebeef",
        "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF",
        "X-Auth": "token cafebeef"
      ],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.httpMethod)
    XCTAssertEqual(body, request.httpBody, "Body remains unchanged")
  }

  func testPreparedAdHocWithoutOauthToken() {
    let url = URL(string: "http://api-hq.ksr.com/v1/test?key=value")!
    let request = self.anonAdHocService.preparedRequest(forRequest: .init(url: url))

    XCTAssertEqual(
      "http://api-hq.ksr.com/v1/test?client_id=deadbeef&currency=USD&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "\(testToolBuildNumber())",
        "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Accept-Language": "en",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
      ],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedRequestWithoutOauthToken() {
    let anonService = Service(
      appId: "com.kickstarter.test",
      serverConfig: ServerConfig(
        apiBaseUrl: URL(string: "http://api.ksr.com")!,
        webBaseUrl: URL(string: "http://www.ksr.com")!,
        apiClientAuth: ClientAuth(
          clientId: "deadbeef"
        ),
        basicHTTPAuth: BasicHTTPAuth(
          username: "username",
          password: "password"
        ),
        graphQLEndpointUrl: URL(string: "http://ksr.dev/graph")!
      ),
      deviceIdentifier: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
    )

    let url = URL(string: "http://api.ksr.com/v1/test?key=value")!
    let request = anonService.preparedRequest(forRequest: .init(url: url))

    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&key=value",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      [
        "Kickstarter-iOS-App": "\(testToolBuildNumber())",
        "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Accept-Language": "en",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "X-KICKSTARTER-CLIENT": "deadbeef",
        "User-Agent": userAgent(),
        "Kickstarter-iOS-App-UUID": "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
      ],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedGraphRequest() {
    let url = self.service.serverConfig.graphQLEndpointUrl
    let request = try? self.service.preparedGraphRequest(
      forURL: url,
      queryString: "mutation",
      input: ["mutation_input": 123]
    )

    let jsonBody = try? JSONSerialization.jsonObject(
      with: request?.httpBody ?? Data(capacity: 1),
      options: []
    )

    XCTAssertNotNil(request)
    XCTAssertEqual(request?.httpMethod, "POST")
    XCTAssertEqual(request?.allHTTPHeaderFields?["Content-Type"], "application/json; charset=utf-8")
    XCTAssertNotNil(jsonBody)
    XCTAssertEqual(request?.allHTTPHeaderFields?["Accept-Language"], self.service.language)
    XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "token cafebeef")
    XCTAssertEqual(request?.allHTTPHeaderFields?["Kickstarter-App-Id"], self.service.appId)
    XCTAssertEqual(request?.allHTTPHeaderFields?["Kickstarter-iOS-App"], self.service.buildVersion)
    XCTAssertEqual(request?.allHTTPHeaderFields?["X-KICKSTARTER-CLIENT"], "deadbeef")
    XCTAssertEqual(request?.allHTTPHeaderFields?["User-Agent"], userAgent())
    XCTAssertEqual(
      request?.allHTTPHeaderFields?["Kickstarter-iOS-App-UUID"],
      "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFBEEF"
    )
  }

  func testGraphMutationRequestBody() {
    let body = self.service.graphMutationRequestBody(
      mutation: "my_mutation",
      input: ["foo_bar": 123]
    )

    XCTAssertEqual(body.query, "my_mutation")
    XCTAssertEqual(body.variables.input, ["foo_bar": 123])
  }

  func testPreparedRequestWithIdempotencyKeyAndRateLimitParsing() {
    let key = try! IdempotencyKey.validate("550E8400-E29B-41D4-A716-446655440000").get()
    let url = URL(string: "http://api.ksr.com/v1/backings")!
    var baseRequest = URLRequest(url: url)
    baseRequest.httpMethod = "POST"

    let request = self.service.preparedRequest(
      forRequest: baseRequest,
      params: TestAmountQueryParams(amount: 25),
      idempotencyKey: key
    )
    XCTAssertEqual(
      request.allHTTPHeaderFields?["Idempotency-Key"],
      "550e8400-e29b-41d4-a716-446655440000"
    )
    XCTAssertEqual(
      "{\"amount\":25}",
      String(data: request.httpBody ?? Data(), encoding: .utf8)
    )

    let httpResponse = HTTPURLResponse(
      url: url,
      statusCode: 429,
      httpVersion: "HTTP/1.1",
      headerFields: [
        "X-RateLimit-Limit": "100",
        "X-RateLimit-Remaining": "0",
        "Retry-After": "30"
      ]
    )!
    let parsedRateLimit = AXRateLimitHeaders.parse(from: httpResponse)
    XCTAssertEqual(parsedRateLimit, AXRateLimitHeaders(limit: 100, remaining: 0, retryAfterSeconds: 30))
  }

  func testEncodableQueryParamsContracts() {
    let discoverUrl = URL(string: "http://api.ksr.com/v1/discover")!
    var discoveryParams = DiscoveryParams.defaults
    discoveryParams.staffPicks = true
    let discoverRequest = self.service.preparedRequest(
      forURL: discoverUrl,
      params: DiscoveryQueryParams(params: discoveryParams)
    )
    XCTAssertEqual(
      "http://api.ksr.com/v1/discover?client_id=deadbeef&currency=USD&staff_picks=true",
      discoverRequest.url?.absoluteString
    )
  }

  func testUpdateUserSelfQueryParamsAndNestedEncoding() {
    struct NestedParams: EncodableQueryParams {
      let enabled: Bool
      let tags: [String]
      let nested: [String: Int]
    }

    let getURL = URL(string: "http://api.ksr.com/v1/test")!
    let getRequest = self.service.preparedRequest(
      forURL: getURL,
      params: NestedParams(enabled: true, tags: ["ios", "ax"], nested: ["page": 2])
    )
    XCTAssertEqual(
      "http://api.ksr.com/v1/test?client_id=deadbeef&currency=USD&enabled=true&nested%5Bpage%5D=2&tags%5B%5D=ios&tags%5B%5D=ax",
      getRequest.url?.absoluteString
    )

    var putBaseRequest = URLRequest(url: URL(string: "http://api.ksr.com/v1/users/self")!)
    putBaseRequest.httpMethod = "PUT"
    var user = User.template
    user.name = "AX Typed User"
    user.notifications.updates = true

    let putRequest = self.service.preparedRequest(
      forRequest: putBaseRequest,
      params: UpdateUserSelfQueryParams(user: user)
    )
    let bodyData = putRequest.httpBody ?? Data()
    let decodedUser = try? JSONDecoder().decode(User.self, from: bodyData)

    XCTAssertEqual(decodedUser?.id, user.id)
    XCTAssertEqual(decodedUser?.name, "AX Typed User")
    XCTAssertEqual(decodedUser?.notifications.updates, true)
  }
}

// swiftformat:disable wrap
private func userAgent() -> String {
  return """
  xctest/\(testToolBuildNumber()) (\(UIDevice.current.model); iOS \(UIDevice.current.systemVersion) Scale/\(UIScreen.main.scale))
  """
}

// swiftformat:enable wrap

private func testToolBuildNumber() -> String {
  return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
}
