/// GraphQL response envelope wrapping a single `Category` node.
public struct CategoryEnvelope: Decodable {
  /// Decoded category node returned by the query.
  public let node: Category
}
