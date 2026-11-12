@testable import KsApi
@testable import KsApiTestHelpers
import Prelude
import XCTest

/// Unit tests covering `ShippingModuleSpec` behavior and contracts.
final class ShippingModuleSpec: XCTestCase {
  func testFetchShippingRulesAndSurveyResponse_ConvertsDoubleCostToIntegerCents() {
    let customRule = ShippingRule.template |> ShippingRule.lens.cost .~ 12.50
    let mockService = MockService(
      fetchShippingRulesResult: .success([customRule]),
      fetchSurveyResponseResponse: SurveyResponse.template
    )
    let controller = ShippingController(
      service: ShippingModuleService(legacyService: mockService, rateLimitMax: 10)
    )

    let rulesResp = try? controller.handleFetchShippingRules(
      query: FetchShippingRulesRequestSchema(projectId: 100, rewardId: 200)
    ).get()
    XCTAssertEqual(rulesResp?.statusCode, 200)
    XCTAssertEqual(rulesResp?.body.rules.first?.costInCents, 1250)

    let surveyResp = try? controller.handleFetchSurveyResponse(
      query: FetchSurveyResponseRequestSchema(surveyResponseId: 55)
    ).get()
    XCTAssertEqual(surveyResp?.statusCode, 200)
    XCTAssertEqual(surveyResp?.body.surveyResponseId, SurveyResponse.template.id)
  }

  func testShipping_BoundaryRejections() {
    let controller = ShippingController(
      service: ShippingModuleService(legacyService: MockService())
    )

    let badRules = controller.handleFetchShippingRules(
      query: FetchShippingRulesRequestSchema(projectId: 0, rewardId: 0)
    )
    guard case let .failure(rulesProblem) = badRules else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(rulesProblem.status, 400)
    XCTAssertEqual(rulesProblem.invalidParams.count, 2)

    let badSurvey = controller.handleFetchSurveyResponse(
      query: FetchSurveyResponseRequestSchema(surveyResponseId: -5)
    )
    guard case let .failure(surveyProblem) = badSurvey else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(surveyProblem.status, 400)
    XCTAssertEqual(surveyProblem.invalidParams.first?.name, "surveyResponseId")
  }
}
