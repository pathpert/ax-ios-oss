import Foundation
import Prelude

extension Update {
  /// Functional lenses for `Update`.
  public enum lens {
    private static func copy(
      _ update: Update,
      body: String?? = nil,
      commentsCount: Int?? = nil,
      id: Int? = nil,
      isPublic: Bool? = nil,
      likesCount: Int?? = nil,
      projectId: Int? = nil,
      publishedAt: TimeInterval?? = nil,
      sequence: Int? = nil,
      title: String? = nil,
      urls: Update.UrlsEnvelope? = nil,
      user: User?? = nil
    ) -> Update {
      Update(
        body: body ?? update.body,
        commentsCount: commentsCount ?? update.commentsCount,
        hasLiked: update.hasLiked,
        id: id ?? update.id,
        isPublic: isPublic ?? update.isPublic,
        likesCount: likesCount ?? update.likesCount,
        projectId: projectId ?? update.projectId,
        publishedAt: publishedAt ?? update.publishedAt,
        sequence: sequence ?? update.sequence,
        title: title ?? update.title,
        urls: urls ?? update.urls,
        user: user ?? update.user,
        visible: update.visible
      )
    }

    /// Lens focusing on the HTML/markdown body content of the project update.
    public static let body = Lens<Update, String?>(
      view: { $0.body },
      set: { copy($1, body: .some($0)) }
    )

    /// Lens focusing on the total number of comments on this update.
    public static let commentsCount = Lens<Update, Int?>(
      view: { $0.commentsCount },
      set: { copy($1, commentsCount: .some($0)) }
    )

    /// Lens focusing on the numeric update identifier.
    public static let id = Lens<Update, Int>(
      view: { $0.id },
      set: { copy($1, id: $0) }
    )

    /// Lens focusing on the total like count for the update.
    public static let likesCount = Lens<Update, Int?>(
      view: { $0.likesCount },
      set: { copy($1, likesCount: .some($0)) }
    )

    /// Lens focusing on the owning project's numeric identifier.
    public static let projectId = Lens<Update, Int>(
      view: { $0.projectId },
      set: { copy($1, projectId: $0) }
    )

    /// Lens focusing on the publish timestamp in UTC Unix seconds.
    public static let publishedAt = Lens<Update, TimeInterval?>(
      view: { $0.publishedAt },
      set: { copy($1, publishedAt: .some($0)) }
    )

    /// Lens focusing on the 1-based update sequence number within its project.
    public static let sequence = Lens<Update, Int>(
      view: { $0.sequence },
      set: { copy($1, sequence: $0) }
    )

    /// Lens focusing on the update headline title.
    public static let title = Lens<Update, String>(
      view: { $0.title },
      set: { copy($1, title: $0) }
    )

    /// Lens focusing on the author `User` who posted the update.
    public static let user = Lens<Update, User?>(
      view: { $0.user },
      set: { copy($1, user: .some($0)) }
    )

    /// Lens focusing on whether the update is visible to all viewers (`true`) or backers only (`false`).
    public static let isPublic = Lens<Update, Bool>(
      view: { $0.isPublic },
      set: { copy($1, isPublic: $0) }
    )

    /// Lens focusing on web and API URL endpoints for the update.
    public static let urls = Lens<Update, Update.UrlsEnvelope>(
      view: { $0.urls },
      set: { copy($1, urls: $0) }
    )
  }
}

extension Update.UrlsEnvelope {
  /// Functional lenses for `Update.UrlsEnvelope`.
  public enum lens {
    /// Lens focusing on web URL targets for the update.
    public static let web = Lens<Update.UrlsEnvelope, Update.UrlsEnvelope.WebEnvelope>(
      view: { $0.web },
      set: { part, _ in .init(web: part) }
    )
  }
}

extension Update.UrlsEnvelope.WebEnvelope {
  /// Functional lenses for `Update.UrlsEnvelope.WebEnvelope`.
  public enum lens {
    /// Lens focusing on the canonical web URL string for viewing the update.
    public static let update = Lens<Update.UrlsEnvelope.WebEnvelope, String>(
      view: { $0.update },
      set: { part, _ in .init(update: part) }
    )
  }
}

extension Lens where Whole == Update, Part == Update.UrlsEnvelope {
  /// Composed lens focusing on `Update.UrlsEnvelope.web`.
  public var web: Lens<Whole, Update.UrlsEnvelope.WebEnvelope> {
    return Whole.lens.urls .. Part.lens.web
  }
}

extension Lens where Whole == Update, Part == Update.UrlsEnvelope.WebEnvelope {
  /// Composed lens focusing directly on the canonical web update URL string.
  public var update: Lens<Whole, String> {
    return Whole.lens.urls.web .. Part.lens.update
  }
}
