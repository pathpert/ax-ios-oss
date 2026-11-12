import Foundation

/// @deprecated Legacy untyped `[String: Any]` GraphQL mutation input protocol.
/// New AX modules in `KsApi/modules/{feature}` use strongly-typed `Codable` request schemas
/// with Poka-Yoke boundary validation (`validate() -> Result<Contract, AXProblemDetails>`).
public protocol GraphMutationInput {
  func toInputDictionary() -> [String: Any]
}

protocol GraphMutation: CustomStringConvertible {
  associatedtype Input: GraphMutationInput

  var input: Input { get }
}

/// Decodable placeholder response for GraphQL mutations that return no domain payload fields.
public struct EmptyResponseEnvelope: Decodable {}

extension GraphMutationInput where Self: Encodable {
  /// Converts this `Encodable` input into a `[String: Any]` GraphQL variable dictionary.
  ///
  /// Negative Constraint: Prefer typed Apollo-generated `GraphQLNullable` inputs for new mutations.
  public func toInputDictionary() -> [String: Any] {
    return self.dictionaryRepresentation ?? [:]
  }
}
