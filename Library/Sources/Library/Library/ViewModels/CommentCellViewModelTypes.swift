import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Input methods accepted by `CommentCellViewModel`.
public protocol CommentCellViewModelInputs {
  /// Call when bindStyles is called.
  func bindStyles()

  /// Call to configure with a Comment and Project.
  func configureWith(comment: Comment, project: Project?)

  /// Call when the textView delegate method for shouldInteractWith url is called.
  func linkTapped(url: URL)

  /// Call when the comment header is tapped.
  func cellHeaderTapped()

  /// Call when the reply button is tapped.
  func replyButtonTapped()

  /// Call when the view replies button is tapped.
  func viewRepliesButtonTapped()
}

/// Output signals emitted by `CommentCellViewModel`.
public protocol CommentCellViewModelOutputs {
  /// Emits author's badge for a comment.
  var authorBadge: Signal<Comment.AuthorBadge, Never> { get }

  /// Emits a url to the comment author's image.
  var authorImageURL: Signal<URL?, Never> { get }

  /// Emits text containing author's fullname or username.
  var authorName: Signal<String, Never> { get }

  /// Emits text containing comment body.
  var body: Signal<String, Never> { get }

  /// Emits a Bool determining if the bottomRowStackView is hidden.
  var bottomRowStackViewIsHidden: Signal<Bool, Never> { get }

  /// Emits the `Author` for the tapped cell.
  var cellAuthor: Signal<Comment.Author, Never> { get }

  /// Emits the current status of a comment.
  var commentStatus: Signal<Comment.Status, Never> { get }

  /// Emits a Bool determining if the flag button in the bottomRowStackView is hidden.
  var flagButtonIsHidden: Signal<Bool, Never> { get }

  /// Emits an URL for the CommentRemovedCellDelegate to use as an argument.
  var notifyDelegateLinkTappedWithURL: Signal<URL, Never> { get }

  /// Emits text relative time the comment was posted.
  var postTime: Signal<String, Never> { get }

  /// Emits a Bool determining if the posted button is hidden.
  var postedButtonIsHidden: Signal<Bool, Never> { get }

  /// Emits a Bool determining if the reply button in the bottomRowStackView are hidden.
  var replyButtonIsHidden: Signal<Bool, Never> { get }

  /// Emits a `Comment` for the cell that reply button is clicked for.
  var replyCommentTapped: Signal<Comment, Never> { get }

  /// Emits whether the content of the cell should be indented.
  var shouldIndentContent: Signal<Bool, Never> { get }

  /// Emits a `Comment` for the cell that view replies button is clicked for.
  var viewCommentReplies: Signal<Comment, Never> { get }

  /// Emits whether or not the view replies stack view is hidden.
  var viewRepliesViewHidden: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `CommentCellViewModel`.
public protocol CommentCellViewModelType {
  /// Input receiver for comment cell interactions.
  var inputs: CommentCellViewModelInputs { get }
  /// Output signals observed by `CommentCell`.
  var outputs: CommentCellViewModelOutputs { get }
}

// MARK: - Helpers

internal func commentUserIsBackingCreatorOrCollaborator(_ project: Project) -> Bool {
  return (project.personalization.backing != nil || project.personalization.isBacking == .some(true)) ||
    !project.memberData.permissions.isEmpty
}

internal func commentReplyButtonHidden(isLoggedOut: Bool, isNotABackerCreatorOrCollaborator: Bool) -> Bool {
  return isLoggedOut || isNotABackerCreatorOrCollaborator
}

internal func commentViewRepliesStackViewHidden(_ replyCount: Int?) -> Bool {
  return replyCount == 0
}

internal func commentDisplayBody(_ comment: Comment) -> String {
  switch true {
  case comment.author.isBlocked:
    return Strings.This_user_has_been_blocked()
  case comment.removedPerGuidelines:
    return commentRemovedPerGuidelinesText()
  case comment.isDeleted:
    return commentDeletedText()
  case comment.isFlagged:
    return commentFlaggedText()
  default:
    return comment.body
  }
}

private func commentRemovedPerGuidelinesText() -> String {
  guard let communityGuidelinesLink = HelpType.community
    .url(withBaseUrl: AppEnvironment.current.apiService.serverConfig.webBaseUrl)?.absoluteString else {
    return ""
  }

  return Strings
    .This_comment_has_been_removed_for_violating_kickstarters_community_guidelines(
      community_guidelines: communityGuidelinesLink
    )
}

private func commentDeletedText() -> String {
  guard let communityGuidelinesLink = HelpType.community
    .url(withBaseUrl: AppEnvironment.current.apiService.serverConfig.webBaseUrl)?.absoluteString else {
    return ""
  }

  return Strings.This_comment_has_been_removed_by_Kickstarter() + " " + Strings
    .Learn_more_about_comment_guidelines(community_link: communityGuidelinesLink)
}

private func commentFlaggedText() -> String {
  guard let communityGuidelinesLink = HelpType.community
    .url(withBaseUrl: AppEnvironment.current.apiService.serverConfig.webBaseUrl)?.absoluteString else {
    return ""
  }

  return Strings
    .This_comment_is_under_review_for_potentially_violating_kickstarters_community_guidelines(
      community_guidelines: communityGuidelinesLink
    )
}

