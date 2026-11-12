import Foundation
import KsApi

/// @deprecated Direct URL matching via `Navigation.match(_:)` / `Navigation.deepLinkMatch(_:)` returning silent `nil` on invalid or unmatched URLs.
/// Prefer `ResolveDeepLinkRequestSchema` and `NavigationRouterController` in `Library/modules/navigation_router`.
public enum Navigation: Equatable {
  /// Navigates to checkout payment flows for `checkoutId`.
  case checkout(Int, Navigation.Checkout)
  /// Represents a click-tracking root redirect from email links.
  case emailClick
  /// Opens a direct message thread by numeric `messageThreadId`.
  case messages(messageThreadId: Int)
  /// Navigates to profile account sub-routes.
  case profile(Profile)
  /// Opens the account registration screen.
  case signup
  /// Switches to a top-level root tab destination.
  case tab(Tab)
  /// Opens a Kickstarter project route with optional referral and secret reward tokens.
  case project(Param, Navigation.Project, refInfo: RefInfo?, secretRewardToken: String? = nil)
  /// Opens an authenticated preview of an unpublished project.
  case projectPreview(Param, Navigation.Project, refTag: RefTag?, token: String)
  /// Opens settings actions (such as notification preference updates).
  case settings(Navigation.Settings)
  /// Opens user-scoped sub-routes such as backer surveys.
  case user(Param, Navigation.User)

  /// Sub-routes inside the checkout payment flow.
  public enum Checkout: Equatable {
    case payments(Navigation.Checkout.Payment)

    /// Payment method sub-routes within checkout.
    public enum Payment: Equatable {
      case applePay(payload: String)
      case new
      case root
      case useStoredCard
    }
  }

  /// Top-level tab destinations supported by deep link routing.
  public enum Tab: Equatable {
    case discovery([String: String]?)
    case search
    case activity
    case login
    case me
  }

  /// User profile account sub-routes.
  public enum Profile: Equatable {
    case verifyEmail
  }

  /// Project-scoped navigation destinations.
  public enum Project: Equatable {
    case checkout(Int, Navigation.Project.Checkout)
    case root
    case comments
    case commentThread(String?, String?)
    case creatorBio
    case friends
    case messageCreator
    case pledge(Navigation.Project.Pledge)
    case updates
    case update(Int, Navigation.Project.Update)
    /// Redirects to an authenticated web view which can support pledge manager workflows.
    /// Argument is a fully-qualified URL for the web view.
    case pledgeManagerWebview(String)

    /// Project checkout completion sub-routes.
    public enum Checkout: Equatable {
      case thanks(racing: Bool?)
    }

    /// Pledge management sub-routes for a project.
    public enum Pledge: Equatable {
      case bigPrint
      case changeMethod
      case destroy
      case edit
      case manage
      case new
      case root
    }

    /// Project update detail and comment sub-routes.
    public enum Update: Equatable {
      case root
      case comments
      case commentThread(String?, String?)
    }
  }

  /// App settings sub-routes parsed from links or notifications.
  public enum Settings: Equatable {
    case notifications(String, Bool)
  }

  /// User-scoped destinations such as backer survey responses.
  public enum User: Equatable {
    case survey(Int)
  }
}

extension Navigation.Project.Update {}
/// Compares two `Navigation.Project.Update` routes for value equality.
public func == (lhs: Navigation.Project.Update, rhs: Navigation.Project.Update) -> Bool {
  switch (lhs, rhs) {
  case (.root, .root):
    return true
  case (.comments, .comments):
    return true
  case let (.commentThread(commentId, replyId), .commentThread(otherCommentId, otherReplyId)):
    return commentId == otherCommentId && replyId == otherReplyId
  default:
    return false
  }
}

extension Navigation.Project {
  /// Extracts project identifier and optional referral tag when `request` matches `.project(..., .root, ...)`.
  public static func withRequest(_ request: URLRequest) -> (Param, RefTag?)? {
    guard let nav = Navigation.match(request), case let .project(project, .root, refInfo, _) = nav
    else { return nil }
    return (project, refInfo?.refTag)
  }

  /// Extracts project identifier and update ID when `request` matches a project update screen.
  public static func updateWithRequest(_ request: URLRequest) -> (Param, Int)? {
    guard let nav = Navigation.match(request), case let .project(project, .update(update, .root), _, _) = nav
    else { return nil }
    return (project, update)
  }

  /// Extracts project identifier and update ID when `request` matches a project update comments thread.
  public static func updateCommentsWithRequest(_ request: URLRequest) -> (Param, Int)? {
    guard let nav = Navigation.match(request),
          case let .project(project, .update(update, .comments), _, _) = nav
    else { return nil }
    return (project, update)
  }
}
