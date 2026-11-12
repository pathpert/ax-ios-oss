

/// Paginated inbox or project message threads envelope.
public struct MessageThreadsEnvelope: Decodable {
  /// Message threads in the current page.
  public let messageThreads: [MessageThread]
  /// Pagination URLs for fetching additional threads.
  public let urls: UrlsEnvelope

  enum CodingKeys: String, CodingKey {
    case messageThreads = "message_threads"
    case urls
  }

  /// Pagination URL container.
  public struct UrlsEnvelope: Decodable {
    /// REST API pagination links.
    public let api: ApiEnvelope

    /// Nested API pagination URLs.
    public struct ApiEnvelope: Decodable {
      /// URL for fetching the next page of message threads.
      public let moreMessageThreads: String

      enum CodingKeys: String, CodingKey {
        case moreMessageThreads = "more_message_threads"
      }
    }
  }
}
