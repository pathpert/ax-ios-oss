import Foundation

/// Contract-first GraphQL mutation input protocol serialized via `Swift.Encodable`.
/// New AX modules in `KsApi/modules/{feature}` use strongly-typed `Codable` request schemas
/// with Poka-Yoke boundary validation (`validate() -> Result<Contract, AXProblemDetails>`).
public protocol GraphMutationInput: Encodable {}

protocol GraphMutation: CustomStringConvertible {
  associatedtype Input: GraphMutationInput

  var input: Input { get }
}

/// Decodable placeholder response for GraphQL mutations that return no domain payload fields.
public struct EmptyResponseEnvelope: Decodable {}
