import KsApi

/// Surface from which a Kickstarter share sheet workflow was initiated.
/// - `discovery`: Sharing a project from the discovery page.
/// - `project`: Sharing a project from the project screen.
/// - `thanks`: Sharing a project from the checkout-thanks screen.
/// - `update`: Sharing an update from the update screen.
/// - Negative Constraint: Do not extract `.update` directly without checking `isUpdateContext`; `update` is `nil` for other cases.
public enum ShareContext {
  case discovery(Project)
  case project(Project)
  case thanks(Project)
  case update(Project, Update)

  /// `true` when sharing a specific creator update (`.update`).
  public var isUpdateContext: Bool {
    if case .update = self {
      return true
    }
    return false
  }

  /// `true` when sharing immediately after backing on the checkout thanks screen.
  public var isThanksContext: Bool {
    if case .thanks = self {
      return true
    }
    return false
  }

  /// Associated `Project` across every `ShareContext` case.
  public var project: Project {
    switch self {
    case let .discovery(project): return project
    case let .project(project): return project
    case let .thanks(project): return project
    case let .update(project, _): return project
    }
  }

  /// Associated creator `Update` when `self` is `.update`, otherwise `nil`.
  public var update: Update? {
    switch self {
    case let .update(_, update): return update
    default: return nil
    }
  }
}

extension ShareContext: Equatable {
  /// Compares two `ShareContext` values by case, project, and optional update.
  public static func == (lhs: ShareContext, rhs: ShareContext) -> Bool {
    switch (lhs, rhs) {
    case let (.discovery(lhs), .discovery(rhs)):
      return lhs == rhs
    case let (.project(lhs), .project(rhs)):
      return lhs == rhs
    case let (.thanks(lhs), .thanks(rhs)):
      return lhs == rhs
    case let (.update(lhsProject, lhsUpdate), .update(rhsProject, rhsUpdate)):
      return lhsProject == rhsProject && lhsUpdate == rhsUpdate
    case (.discovery, _), (.project, _), (.thanks, _), (.update, _):
      return false
    }
  }
}
