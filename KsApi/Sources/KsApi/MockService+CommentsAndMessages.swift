#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

/// `MockService` extensions declared in `MockService+CommentsAndMessages.swift`.
  extension MockService {
    func fetchProjectComments(
      slug: String,
      cursor: String?,
      limit: Int?
    ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchProjectCommentsQuery = GraphAPI.FetchProjectCommentsQuery(
        slug: slug,
        cursor: GraphQLNullable.someOrNil(cursor),
        limit: GraphQLNullable.someOrNil(limit)
      )

      return client
        .fetchWithResult(query: fetchProjectCommentsQuery, result: self.fetchProjectCommentsEnvelopeResult)
    }

    func fetchUpdateComments(
      id: String,
      cursor: String?,
      limit: Int?
    ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchUpdateCommentsQuery = GraphAPI.FetchUpdateCommentsQuery(
        postId: id,
        cursor: GraphQLNullable.someOrNil(cursor),
        limit: GraphQLNullable.someOrNil(limit)
      )

      return client
        .fetchWithResult(query: fetchUpdateCommentsQuery, result: self.fetchUpdateCommentsEnvelopeResult)
    }

    func fetchCommentReplies(
      id: String,
      cursor: String?,
      limit: Int
    ) -> SignalProducer<CommentRepliesEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchCommentRepliesQuery = GraphAPI.FetchCommentRepliesQuery(
        commentId: id,
        cursor: GraphQLNullable.someOrNil(cursor),
        limit: limit
      )

      return client
        .fetchWithResult(query: fetchCommentRepliesQuery, result: self.fetchCommentRepliesEnvelopeResult)
    }

    func postComment(input: PostCommentInput)
      -> SignalProducer<Comment, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .PostCommentMutation(input: GraphAPI.PostCommentInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.postCommentResult)
    }

    internal func fetchMessageThread(messageThreadId _: Int)
      -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {
      if let error = self.fetchMessageThreadResult?.error {
        return SignalProducer(error: error)
      }

      return SignalProducer(
        value: MessageThreadEnvelope(
          participants: [.template, .template |> \.id .~ 2],
          messages: [
            .template |> Message.lens.id .~ 1,
            .template |> Message.lens.id .~ 2,
            .template |> Message.lens.id .~ 3
          ],
          messageThread: self.fetchMessageThreadResult?.value as? MessageThread ?? .template
        )
      )
    }

    internal func fetchMessageThread(backing _: Backing)
      -> SignalProducer<MessageThreadEnvelope?, ErrorEnvelope> {
      if let error = self.fetchMessageThreadResult?.error {
        return SignalProducer(error: error)
      }

      if let thread = self.fetchMessageThreadResult?.value as? MessageThread {
        return SignalProducer(
          value: MessageThreadEnvelope(
            participants: [.template, .template |> \.id .~ 2],
            messages: [
              .template |> Message.lens.id .~ 1,
              .template |> Message.lens.id .~ 2,
              .template |> Message.lens.id .~ 3
            ],
            messageThread: thread
          )
        )
      } else {
        return SignalProducer(value: nil)
      }
    }

    internal func fetchMessageThreads(mailbox _: Mailbox, project _: Project?)
      -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
      return SignalProducer(
        value:
        MessageThreadsEnvelope(
          messageThreads: self.fetchMessageThreadsResponse,
          urls: MessageThreadsEnvelope.UrlsEnvelope(
            api: MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreMessageThreads: ""
            )
          )
        )
      )
    }

    internal func fetchMessageThreads(paginationUrl _: String)
      -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
      return SignalProducer(
        value:
        MessageThreadsEnvelope(
          messageThreads: self.fetchMessageThreadsResponse,
          urls: MessageThreadsEnvelope.UrlsEnvelope(
            api: MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreMessageThreads: ""
            )
          )
        )
      )
    }

    internal func markAsRead(messageThread: MessageThread)
      -> SignalProducer<MessageThread, ErrorEnvelope> {
      return SignalProducer(value: messageThread)
    }

    internal func searchMessages(query _: String, project _: Project?)
      -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
      return SignalProducer(
        value:
        MessageThreadsEnvelope(
          messageThreads: self.fetchMessageThreadsResponse,
          urls: MessageThreadsEnvelope.UrlsEnvelope(
            api: MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreMessageThreads: ""
            )
          )
        )
      )
    }

    internal func sendMessage(body: String, toSubject _: MessageSubject)
      -> SignalProducer<Message, ErrorEnvelope> {
      return SignalProducer(
        value: .template
          |> Message.lens.id .~ body.hashValue
          |> Message.lens.body .~ body
      )
    }
  }
#endif

