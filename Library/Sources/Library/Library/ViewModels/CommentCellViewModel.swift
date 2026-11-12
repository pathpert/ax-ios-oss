import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// View model configuring comment cell author details, moderation body copy, reply permissions, and links.
public final class CommentCellViewModel:
  CommentCellViewModelType, CommentCellViewModelInputs, CommentCellViewModelOutputs {
  /// Creates a new `CommentCellViewModel`.
  public init() {
    let comment = self.commentAndProject.signal.skipNil()
      .map { comment, _ in comment }

    self.authorImageURL = comment
      .map {
        if $0.author.isBlocked {
          return "" // Use placeholder avatar instead of URL.
        } else {
          return $0.author.imageUrl
        }
      }
      .map(URL.init)

    self.body = comment.map(commentDisplayBody)

    self.authorName = comment.map {
      if $0.author.isBlocked {
        return Strings.Blocked_user()
      } else {
        return $0.author.name
      }
    }

    let status = comment.map(\.status)

    self.commentStatus = Signal.merge(
      status,
      status.takeWhen(self.bindStylesProperty.signal)
    )

    self.postTime = comment
      .map { $0.createdAt }
      .skipNil()
      .map { createdAt -> String in
        Format.date(secondsInUTC: createdAt, dateStyle: .medium, timeStyle: .short)
      }

    self.postedButtonIsHidden = self.commentStatus.map { $0 != .retrySuccess }

    let badge = self.commentAndProject.signal
      .skipNil()
      .map { comment, _ in
        if comment.author.isBlocked { return Comment.AuthorBadge.backer }
        return comment.author.id == AppEnvironment.current.currentUser?.id.description ? .you : comment
          .authorBadge
      }

    self.authorBadge = Signal.merge(
      badge,
      badge.takeWhen(self.bindStylesProperty.signal)
    )

    self.flagButtonIsHidden = self.commentAndProject.signal
      .ignoreValues()
      .mapConst(true)

    let isLoggedOut = self.commentAndProject.signal
      .ignoreValues()
      .map { _ in AppEnvironment.current.currentUser }
      .map(isNil)

    let isNotABackerCreatorOrCollaborator = self.commentAndProject.signal
      .skipNil()
      .map { _, project in project }
      .skipNil()
      .map(commentUserIsBackingCreatorOrCollaborator)
      .negate()

    let isReply = comment.map { $0.isReply }

    // If the user is either logged out, not backing or the flag is disabled, hide replyButton.
    self.replyButtonIsHidden = Signal.combineLatest(isLoggedOut, isNotABackerCreatorOrCollaborator)
      .map(commentReplyButtonHidden)

    // If both the replyButton and flagButton should be hidden, the entire stackview will be hidden too.
    self.bottomRowStackViewIsHidden = Signal.combineLatest(
      self.flagButtonIsHidden.signal,
      self.replyButtonIsHidden.signal,
      isReply
    ).map { flagButtonIsHidden, replyButtonIsHidden, isReply in
      (flagButtonIsHidden && replyButtonIsHidden) || isReply
    }

    self.notifyDelegateLinkTappedWithURL = self.linkTappedProperty.signal.skipNil()

    // If there are no replies or if the feature flag returns false, hide the stack view.
    self.viewRepliesViewHidden = comment.map(\.replyCount)
      .map(commentViewRepliesStackViewHidden)

    self.cellAuthor = comment
      .takeWhen(self.cellHeaderTappedProperty.signal)
      .map(\.author)
    self.replyCommentTapped = comment.takeWhen(self.replyButtonTappedProperty.signal)
    self.viewCommentReplies = comment.takeWhen(self.viewRepliesButtonTappedProperty.signal)

    self.shouldIndentContent = isReply
      .takeWhen(self.bindStylesProperty.signal)
  }

  private var bindStylesProperty = MutableProperty(())
  /// Re-emits cached status and badge styles when cell styling binds.
  public func bindStyles() {
    self.bindStylesProperty.value = ()
  }

  fileprivate let commentAndProject = MutableProperty<(Comment, Project?)?>(nil)
  /// Configures the cell with the displayed `comment` and optional `project`.
  public func configureWith(comment: Comment, project: Project?) {
    self.commentAndProject.value = (comment, project)
  }

  fileprivate let linkTappedProperty = MutableProperty<URL?>(nil)
  /// Emits tapped comment body URLs for delegate routing.
  public func linkTapped(url: URL) {
    self.linkTappedProperty.value = url
  }

  private var cellHeaderTappedProperty = MutableProperty(())
  /// Emits the comment author when the user taps the cell header.
  public func cellHeaderTapped() {
    self.cellHeaderTappedProperty.value = ()
  }

  private var replyButtonTappedProperty = MutableProperty(())
  /// Triggers reply composition for this comment.
  public func replyButtonTapped() {
    self.replyButtonTappedProperty.value = ()
  }

  fileprivate let viewRepliesButtonTappedProperty = MutableProperty(())
  /// Navigates to the comment replies thread for this comment.
  public func viewRepliesButtonTapped() {
    self.viewRepliesButtonTappedProperty.value = ()
  }

  /// Emits author badge metadata (`you`, creator, superbacker, backer).
  public let authorBadge: Signal<Comment.AuthorBadge, Never>
  /// Emits author avatar image URL, or `nil` when blocked.
  public var authorImageURL: Signal<URL?, Never>
  /// Emits displayed author name or blocked placeholder text.
  public let authorName: Signal<String, Never>
  /// Emits comment body text or moderation replacement copy.
  public let body: Signal<String, Never>
  /// Emits whether the bottom actions stack view is hidden.
  public let bottomRowStackViewIsHidden: Signal<Bool, Never>
  /// Emits tapped comment author for blocking/moderation actions.
  public let cellAuthor: Signal<Comment.Author, Never>
  /// Emits current comment delivery/moderation status.
  public let commentStatus: Signal<Comment.Status, Never>
  /// Emits whether the flag action button is hidden.
  public let flagButtonIsHidden: Signal<Bool, Never>
  /// Emits link URL tapped inside the comment text view.
  public let notifyDelegateLinkTappedWithURL: Signal<URL, Never>
  /// Emits formatted relative creation timestamp.
  public let postTime: Signal<String, Never>
  /// Emits whether the retry-success posted indicator is hidden.
  public let postedButtonIsHidden: Signal<Bool, Never>
  /// Emits whether the reply button is hidden.
  public let replyButtonIsHidden: Signal<Bool, Never>
  /// Emits the parent comment when Reply is tapped.
  public let replyCommentTapped: Signal<Comment, Never>
  /// Emits whether the cell should indent as a reply row.
  public let shouldIndentContent: Signal<Bool, Never>
  /// Emits the comment when View Replies is tapped.
  public let viewCommentReplies: Signal<Comment, Never>
  /// Emits whether the View Replies container is hidden.
  public let viewRepliesViewHidden: Signal<Bool, Never>

  /// Input receiver (`self`).
  public var inputs: CommentCellViewModelInputs { self }
  /// Output provider (`self`).
  public var outputs: CommentCellViewModelOutputs { self }
}
