import Foundation
import GraphAPI
import ReactiveSwift

/// Paginated GraphQL envelope containing comments for a project or creator update.
public struct CommentsEnvelope: Decodable {
  /// Comments in the fetched page.
  public var comments: [Comment]
  /// GraphQL end cursor for loading older comments.
  public var cursor: String?
  /// Whether additional pages of comments exist beyond `cursor`.
  public var hasNextPage: Bool
  /// Associated project slug, when querying project comments.
  public var slug: String?
  /// Total comment count reported by the backend.
  public var totalCount: Int
  /// Associated update ID, when querying update comments.
  public var updateID: String?
}

extension CommentsEnvelope {
  static func envelopeProducer(from data: GraphAPI.FetchProjectCommentsQuery.Data)
    -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    guard let envelope = CommentsEnvelope.commentsEnvelope(from: data) else { return .empty }
    return SignalProducer(value: envelope)
  }

  static func envelopeProducer(from data: GraphAPI.FetchUpdateCommentsQuery.Data)
    -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    guard let envelope = CommentsEnvelope.commentsEnvelope(from: data) else { return .empty }
    return SignalProducer(value: envelope)
  }
}
