import Prelude

extension DiscoveryEnvelope {
  /// Functional lenses for `DiscoveryEnvelope`.
  public enum lens {
    /// Lens focusing on the paginated array of discovered `Project` items.
    public static let projects = Lens<DiscoveryEnvelope, [Project]>(
      view: { $0.projects },
      set: { DiscoveryEnvelope(projects: $0, urls: $1.urls, stats: $1.stats) }
    )

    /// Lens focusing on pagination URLs inside the discovery envelope.
    public static let urls = Lens<DiscoveryEnvelope, UrlsEnvelope>(
      view: { $0.urls },
      set: { DiscoveryEnvelope(projects: $1.projects, urls: $0, stats: $1.stats) }
    )

    /// Lens focusing on aggregate result `StatsEnvelope` counts.
    public static let stats = Lens<DiscoveryEnvelope, StatsEnvelope>(
      view: { $0.stats },
      set: { DiscoveryEnvelope(projects: $1.projects, urls: $1.urls, stats: $0) }
    )
  }
}

extension DiscoveryEnvelope.UrlsEnvelope {
  /// Functional lenses for `DiscoveryEnvelope.UrlsEnvelope`.
  public enum lens {
    /// Lens focusing on nested API pagination endpoints.
    public static let api = Lens<DiscoveryEnvelope.UrlsEnvelope, ApiEnvelope>(
      view: { $0.api },
      set: { part, _ in DiscoveryEnvelope.UrlsEnvelope(api: part) }
    )
  }
}

extension DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope {
  /// Functional lenses for `DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope`.
  public enum lens {
    /// Lens focusing on the `moreProjects` cursor URL string.
    public static let moreProjects = Lens<DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope, String>(
      view: { $0.moreProjects },
      set: { part, _ in DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope(moreProjects: part) }
    )
  }
}

extension DiscoveryEnvelope.StatsEnvelope {
  /// Functional lenses for `DiscoveryEnvelope.StatsEnvelope`.
  public enum lens {
    /// Lens focusing on total matching project count.
    public static let count = Lens<DiscoveryEnvelope.StatsEnvelope, Int>(
      view: { $0.count },
      set: { part, _ in DiscoveryEnvelope.StatsEnvelope(count: part) }
    )
  }
}

extension Lens where Whole == DiscoveryEnvelope, Part == DiscoveryEnvelope.UrlsEnvelope {
  /// Composed lens focusing from `DiscoveryEnvelope` to `UrlsEnvelope.api`.
  public var api: Lens<DiscoveryEnvelope, DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope> {
    return DiscoveryEnvelope.lens.urls .. DiscoveryEnvelope.UrlsEnvelope.lens.api
  }
}

extension Lens where Whole == DiscoveryEnvelope, Part == DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope {
  /// Composed lens focusing from `DiscoveryEnvelope` directly to `moreProjects` URL.
  public var moreProjects: Lens<DiscoveryEnvelope, String> {
    return DiscoveryEnvelope.lens.urls.api .. DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope.lens.moreProjects
  }
}
