import Combine
import Foundation
import GraphAPI
import ReactiveSwift

extension Service {
  /// Fetches top-level comments for a project by slug.
  ///
  /// - Negative constraint: Pass a valid GraphQL pagination `cursor` returned by a prior response rather than a page number; keep `limit` within server bounds.
  public func fetchProjectComments(
    slug: String,
    cursor: String?,
    limit: Int?
  ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchProjectCommentsQuery(
        slug: slug,
        cursor: GraphQLNullable.someOrNil(cursor),
        limit: GraphQLNullable.someOrNil(limit)
      ))
      .flatMap(CommentsEnvelope.envelopeProducer(from:))
  }

  /// Fetches top-level comments for a creator project update (`FreeformPost`).
  ///
  /// - Negative constraint: Pass the encoded GraphQL post `id`, not a numeric update row ID.
  public func fetchUpdateComments(
    id: String,
    cursor: String?,
    limit: Int?
  ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchUpdateCommentsQuery(
        postId: id,
        cursor: GraphQLNullable.someOrNil(cursor),
        limit: GraphQLNullable.someOrNil(limit)
      ))
      .flatMap(CommentsEnvelope.envelopeProducer(from:))
  }

  /// Fetches paginated replies for a parent comment.
  ///
  /// - Negative constraint: `id` must be a GraphQL `Comment` ID and `limit` must be positive (`> 0`).
  public func fetchCommentReplies(
    id: String,
    cursor: String?,
    limit: Int
  ) -> SignalProducer<CommentRepliesEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.FetchCommentRepliesQuery(
        commentId: id,
        cursor: GraphQLNullable.someOrNil(cursor),
        limit: limit
      ))
      .flatMap(CommentRepliesEnvelope.envelopeProducer(from:))
  }

  /// Posts a new comment or reply via GraphQL mutation.
  ///
  /// - Negative constraint: Requires an authenticated `Service`; validate empty bodies and target IDs before invoking.
  public func postComment(input: PostCommentInput)
    -> SignalProducer<Comment, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .PostCommentMutation(input: GraphAPI.PostCommentInput.from(input))
      )
      .flatMap(PostCommentEnvelope.producer(from:))
  }

  /// Fetches a single message thread and its messages by numeric thread identifier.
  ///
  /// - Negative constraint: Requires an authenticated session authorized to read `messageThreadId`.
  public func fetchMessageThread(messageThreadId: Int)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {
    return request(.messagesForThread(messageThreadId: messageThreadId))
  }

  /// Fetches the message thread associated with a `Backing`, returning `nil` if no thread exists yet.
  public func fetchMessageThread(backing: Backing)
    -> SignalProducer<MessageThreadEnvelope?, ErrorEnvelope> {
    return request(.messagesForBacking(backing))
  }

  /// Fetches message threads for the current user's mailbox, optionally filtered to a project.
  public func fetchMessageThreads(mailbox: Mailbox, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
    return request(.messageThreads(mailbox: mailbox, project: project))
  }

  /// Fetches the next page of message threads from a pagination URL.
  ///
  /// - Negative constraint: Only pass `urls.api.moreMessageThreads` returned by a prior `MessageThreadsEnvelope`.
  public func fetchMessageThreads(paginationUrl: String)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(paginationUrl)
  }

  /// Marks all messages in a thread as read.
  public func markAsRead(messageThread: MessageThread) -> SignalProducer<MessageThread, ErrorEnvelope> {
    return request(.markAsRead(messageThread))
  }

  /// Searches message threads matching `query`, optionally scoped to `project`.
  ///
  /// - Negative constraint: Do not issue requests with empty whitespace-only queries.
  public func searchMessages(query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
    return request(.searchMessages(query: query, project: project))
  }

  /// Sends a plain-text message to a project creator or existing message thread.
  ///
  /// - Negative constraint: Requires an authenticated session and non-empty message `body`.
  public func sendMessage(body: String, toSubject subject: MessageSubject)
    -> SignalProducer<Message, ErrorEnvelope> {
    return request(.sendMessage(body: body, messageSubject: subject))
  }
}

