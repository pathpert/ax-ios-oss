import Prelude

extension FindFriendsEnvelope {
  /// Functional lenses for `FindFriendsEnvelope`.
  public enum lens {
    /// Lens focusing on whether device contacts have been imported.
    public static let contactsImported = Lens<FindFriendsEnvelope, Bool>(
      view: { $0.contactsImported },
      set: { FindFriendsEnvelope(contactsImported: $0, urls: $1.urls, users: $1.users) }
    )

    /// Lens focusing on pagination URLs for friend discovery.
    public static let urls = Lens<FindFriendsEnvelope, UrlsEnvelope>(
      view: { $0.urls },
      set: { FindFriendsEnvelope(contactsImported: $1.contactsImported, urls: $0, users: $1.users) }
    )

    /// Lens focusing on matched `User` friends in the current page.
    public static let users = Lens<FindFriendsEnvelope, [User]>(
      view: { $0.users },
      set: { FindFriendsEnvelope(contactsImported: $1.contactsImported, urls: $1.urls, users: $0) }
    )
  }
}

extension FindFriendsEnvelope.UrlsEnvelope {
  /// Functional lenses for `FindFriendsEnvelope.UrlsEnvelope`.
  public enum lens {
    /// Lens focusing on nested API pagination URLs.
    public static let api = Lens<FindFriendsEnvelope.UrlsEnvelope, ApiEnvelope>(
      view: { $0.api },
      set: { part, _ in FindFriendsEnvelope.UrlsEnvelope(api: part) }
    )
  }
}

extension FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope {
  /// Functional lenses for `FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope`.
  public enum lens {
    /// Lens focusing on the optional `moreUsers` cursor pagination URL.
    public static let moreProjects = Lens<FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope, String?>(
      view: { $0.moreUsers },
      set: { part, _ in FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope(moreUsers: part) }
    )
  }
}
