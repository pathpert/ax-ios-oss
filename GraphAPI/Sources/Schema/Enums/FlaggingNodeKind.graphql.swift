// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// GraphQL node classification for flaggable community and project content.
/// - Negative Constraint: Do not pass unsupported raw strings outside `FlaggingNodeKind` cases.
public enum FlaggingNodeKind: String, EnumType {
  /// Represents a container group of flagging options.
  case group = "GROUP"
  /// Represents a selectable flagging reason option.
  case option = "OPTION"
}
