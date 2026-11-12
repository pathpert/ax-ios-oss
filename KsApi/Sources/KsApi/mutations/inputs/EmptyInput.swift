import Foundation

/// Empty GraphQL mutation input payload for parameterless mutations.
///
/// - Negative constraint: Do not add dynamic properties to this struct; define a dedicated typed input struct instead.
public struct EmptyInput: GraphMutationInput, Encodable {
  /// Creates an empty mutation input.
  public init() {}
}
