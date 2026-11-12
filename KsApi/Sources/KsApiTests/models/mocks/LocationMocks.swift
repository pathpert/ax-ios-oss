import ApolloTestSupport
import GraphAPI
import GraphAPITestMocks
@testable import KsApi
@testable import KsApiTestHelpers

/// Unit tests covering `GraphAPITestMocks.Location` behavior and contracts.
extension GraphAPITestMocks.Location {
  static var mock: Mock<GraphAPITestMocks.Location> {
    let loc = Mock<GraphAPITestMocks.Location>()
    loc.country = "USA"
    loc.countryName = "USA"
    loc.displayableName = "USA"
    loc.id = "TG9jYXRpb24tMjM0MjQ3NzU="
    loc.name = "USA"
    return loc
  }
}
