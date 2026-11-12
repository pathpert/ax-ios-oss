

/// Response envelope for paginated friend discovery and contact-import status.
public struct FindFriendsEnvelope {
  /// Whether the user's contacts have previously been imported for friend matching.
  public let contactsImported: Bool
  /// Pagination links for loading additional friend suggestions.
  public let urls: UrlsEnvelope
  /// Matched friend `User` records in the current page.
  public let users: [User]

  /// Pagination URL container.
  public struct UrlsEnvelope {
    /// REST API pagination links.
    public let api: ApiEnvelope

    /// Nested API pagination URLs.
    public struct ApiEnvelope {
      /// Optional cursor URL for the next page of matched users.
      public let moreUsers: String?
    }
  }
}

extension FindFriendsEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case contactsImported = "contacts_imported"
    case urls
    case users
  }
}

extension FindFriendsEnvelope.UrlsEnvelope: Decodable {}

extension FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case moreUsers = "more_users"
  }
}
