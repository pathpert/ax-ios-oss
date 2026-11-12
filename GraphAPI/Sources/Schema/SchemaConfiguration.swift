// @generated
// This file was automatically generated and can be edited to
// provide custom configuration for a generated GraphQL schema.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import ApolloAPI

/// Apollo GraphQL cache configuration for normalized cache key resolution.
/// - Negative Constraint: Do not store mutable client session state on this type; keep resolution pure.
public enum SchemaConfiguration: ApolloAPI.SchemaConfiguration {
  /// Returns Apollo normalized cache key info for an object type and raw response data, or `nil` for default caching.
  public static func cacheKeyInfo(for type: ApolloAPI.Object, object: ApolloAPI.ObjectData) -> CacheKeyInfo? {
    // Implement this function to configure cache key resolution for your schema types.
    return nil
  }
}
