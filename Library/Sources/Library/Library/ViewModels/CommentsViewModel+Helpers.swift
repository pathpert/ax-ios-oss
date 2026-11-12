import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Helper definitions for `makeCommentComposerViewData` in `CommentsViewModel+Helpers.swift`.
internal func makeCommentComposerViewData(
  project: Project,
  currentUser: User?
) -> CommentComposerViewData {
  let isBacker = userIsBackingProject(project)
  let isCreatorOrCollaborator = !project.memberData.permissions.isEmpty && !isBacker
  let canPostComment = isBacker || isCreatorOrCollaborator

  guard let user = currentUser else {
    return CommentComposerViewData(
      avatarURL: nil,
      canPostComment: false,
      hidden: true,
      becomeFirstResponder: false
    )
  }

  return CommentComposerViewData(
    avatarURL: URL(string: user.avatar.medium),
    canPostComment: canPostComment,
    hidden: false,
    becomeFirstResponder: false
  )
}

internal func commentsReplacingCommentById(
  _ comments: [Comment],
  replacingComment: Comment,
  withId id: String
) -> [Comment] {
  guard let commentIndex = comments.firstIndex(where: { $0.id == id }) else {
    return [replacingComment] + comments
  }

  var mutableComments = comments
  mutableComments[commentIndex] = replacingComment
  return mutableComments
}

internal func commentsFirstPage(from projectOrUpdate: Either<Project, Update>)
  -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
  return projectOrUpdate.ifLeft { project in
    AppEnvironment.current.apiService.fetchProjectComments(
      slug: project.slug,
      cursor: nil,
      limit: nil
    )
  } ifRight: {
    AppEnvironment.current.apiService.fetchUpdateComments(
      id: $0.id.description,
      cursor: nil,
      limit: nil
    )
  }
}

internal func commentsNextPage(
  from projectSlug: String?,
  cursor: String?,
  updateID: String?
) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
  if let projectSlug = projectSlug {
    return AppEnvironment.current.apiService
      .fetchProjectComments(slug: projectSlug, cursor: cursor, limit: nil)
  } else {
    guard let id = updateID else { return .empty }
    return AppEnvironment.current.apiService
      .fetchUpdateComments(id: id, cursor: cursor, limit: nil)
  }
}

internal func bindCommentsBlockingAnalytics(
  blockUserSignal: Signal<String, Never>,
  initialProject: Signal<Project, Never>,
  blockUserSuccessSignal: Signal<Void, Never>
) {
  blockUserSignal
    .combineLatest(with: initialProject)
    .observeValues { blockedUserId, project in
      AppEnvironment.current.ksrAnalytics.trackBlockedUser(
        project,
        page: .project,
        sectionContext: .comments,
        typeContext: .initiate,
        targetUserId: "\(blockedUserId)"
      )
    }

  blockUserSignal
    .combineLatest(with: initialProject)
    .takeWhen(blockUserSuccessSignal)
    .observeValues { blockedUserId, project in
      AppEnvironment.current.ksrAnalytics.trackBlockedUser(
        project,
        page: .project,
        sectionContext: .comments,
        typeContext: .confirm,
        targetUserId: "\(blockedUserId)"
      )
    }
}

extension CommentsViewModel {
  // MARK: Properties

  static let concurrentCommentLimit: UInt = 5

  // MARK: Helpers

  static func retryCommentProducer(
    erroredComment comment: Comment,
    commentableId: String,
    parentId: String?
  ) -> SignalProducer<(Comment, String), Never> {
    AppEnvironment.current.apiService.postComment(
      input: .init(body: comment.body, commentableId: commentableId, parentId: parentId)
    )
    .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    .flatMap { successfulComment -> SignalProducer<Comment, ErrorEnvelope> in
      let retrySuccessComment = successfulComment.updatingStatus(to: .retrySuccess)
        |> \.id .~ comment.id

      return SignalProducer(value: successfulComment)
        .ksr_delay(.seconds(3), on: AppEnvironment.current.scheduler)
        .prefix(value: retrySuccessComment)
    }
    .prefix(
      SignalProducer(value: comment.updatingStatus(to: .retrying))
        .ksr_delay(.seconds(1), on: AppEnvironment.current.scheduler)
        .prefix(value: comment.updatingStatus(to: .retrying))
    )
    .demoteErrors(replaceErrorWith: comment)
    .map { replacementComment in (replacementComment, comment.id) }
  }

  static func postCommentProducer(
    project: Project,
    commentableId: String,
    parentId: String?,
    user: User,
    body: String
  ) -> SignalProducer<(Comment, String), Never> {
    let failableComment = Comment.failableComment(
      withId: AppEnvironment.current.uuidType.init().uuidString,
      date: AppEnvironment.current.dateType.init().date,
      project: project,
      parentId: parentId,
      user: user,
      body: body
    )

    return AppEnvironment.current.apiService.postComment(
      input: .init(body: body, commentableId: commentableId, parentId: parentId)
    )
    .ksr_delay(.seconds(1), on: AppEnvironment.current.scheduler)
    .prefix(value: failableComment)
    .flatMapError { _ in
      SignalProducer(value: failableComment.updatingStatus(to: .failed))
        .ksr_delay(.seconds(1), on: AppEnvironment.current.scheduler)
    }
    .map { commentOrFailable in (commentOrFailable, failableComment.id) }
  }
}

