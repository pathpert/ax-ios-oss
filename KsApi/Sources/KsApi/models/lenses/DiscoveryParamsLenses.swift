import Prelude

extension DiscoveryParams {
  /// Functional lenses for constructing and updating `DiscoveryParams` queries.
  public enum lens {
    private static func copy(
      _ params: DiscoveryParams,
      backed: Bool?? = nil,
      category: Category?? = nil,
      collaborated: Bool?? = nil,
      created: Bool?? = nil,
      hasVideo: Bool?? = nil,
      includePOTD: Bool?? = nil,
      page: Int?? = nil,
      perPage: Int?? = nil,
      query: String?? = nil,
      recommended: Bool?? = nil,
      seed: Int?? = nil,
      similarTo: Project?? = nil,
      social: Bool?? = nil,
      sort: DiscoveryParams.Sort?? = nil,
      staffPicks: Bool?? = nil,
      starred: Bool?? = nil,
      state: DiscoveryParams.State?? = nil
    ) -> DiscoveryParams {
      DiscoveryParams(
        backed: backed ?? params.backed,
        category: category ?? params.category,
        collaborated: collaborated ?? params.collaborated,
        created: created ?? params.created,
        hasVideo: hasVideo ?? params.hasVideo,
        includePOTD: includePOTD ?? params.includePOTD,
        page: page ?? params.page,
        perPage: perPage ?? params.perPage,
        query: query ?? params.query,
        recommended: recommended ?? params.recommended,
        seed: seed ?? params.seed,
        similarTo: similarTo ?? params.similarTo,
        social: social ?? params.social,
        sort: sort ?? params.sort,
        staffPicks: staffPicks ?? params.staffPicks,
        starred: starred ?? params.starred,
        state: state ?? params.state
      )
    }

    /// Lens filtering to projects backed by the current user.
    public static let backed = Lens<DiscoveryParams, Bool?>(
      view: { $0.backed },
      set: { copy($1, backed: .some($0)) }
    )

    /// Lens filtering to a specific project `Category` or subcategory.
    public static let category = Lens<DiscoveryParams, Category?>(
      view: { $0.category },
      set: { copy($1, category: .some($0)) }
    )

    /// Lens filtering to projects on which the user is a collaborator.
    public static let collaborated = Lens<DiscoveryParams, Bool?>(
      view: { $0.collaborated },
      set: { copy($1, collaborated: .some($0)) }
    )

    /// Lens filtering to projects created by the current user.
    public static let created = Lens<DiscoveryParams, Bool?>(
      view: { $0.created },
      set: { copy($1, created: .some($0)) }
    )

    /// Lens filtering to projects with a campaign video.
    public static let hasVideo = Lens<DiscoveryParams, Bool?>(
      view: { $0.hasVideo },
      set: { copy($1, hasVideo: .some($0)) }
    )

    /// Lens controlling inclusion of the Project of the Day in results.
    public static let includePOTD = Lens<DiscoveryParams, Bool?>(
      view: { $0.includePOTD },
      set: { copy($1, includePOTD: .some($0)) }
    )

    /// Lens focusing on the 1-based pagination page index.
    public static let page = Lens<DiscoveryParams, Int?>(
      view: { $0.page },
      set: { copy($1, page: .some($0)) }
    )

    /// Lens focusing on the requested number of results per page.
    public static let perPage = Lens<DiscoveryParams, Int?>(
      view: { $0.perPage },
      set: { copy($1, perPage: .some($0)) }
    )

    /// Lens focusing on the free-text search query term.
    public static let query = Lens<DiscoveryParams, String?>(
      view: { $0.query },
      set: { copy($1, query: .some($0)) }
    )

    /// Lens filtering to personalized recommended projects.
    public static let recommended = Lens<DiscoveryParams, Bool?>(
      view: { $0.recommended },
      set: { copy($1, recommended: .some($0)) }
    )

    /// Lens focusing on the pagination deterministic sort seed.
    public static let seed = Lens<DiscoveryParams, Int?>(
      view: { $0.seed },
      set: { copy($1, seed: .some($0)) }
    )

    /// Lens filtering to projects similar to a reference `Project`.
    public static let similarTo = Lens<DiscoveryParams, Project?>(
      view: { $0.similarTo },
      set: { copy($1, similarTo: .some($0)) }
    )

    /// Lens filtering to projects backed by friends.
    public static let social = Lens<DiscoveryParams, Bool?>(
      view: { $0.social },
      set: { copy($1, social: .some($0)) }
    )

    /// Lens focusing on the `DiscoveryParams.Sort` ordering criteria.
    public static let sort = Lens<DiscoveryParams, DiscoveryParams.Sort?>(
      view: { $0.sort },
      set: { copy($1, sort: .some($0)) }
    )

    /// Lens filtering to Projects We Love / staff picks.
    public static let staffPicks = Lens<DiscoveryParams, Bool?>(
      view: { $0.staffPicks },
      set: { copy($1, staffPicks: .some($0)) }
    )

    /// Lens filtering to projects saved / starred by the current user.
    public static let starred = Lens<DiscoveryParams, Bool?>(
      view: { $0.starred },
      set: { copy($1, starred: .some($0)) }
    )

    /// Lens filtering by campaign lifecycle `DiscoveryParams.State`.
    public static let state = Lens<DiscoveryParams, DiscoveryParams.State?>(
      view: { $0.state },
      set: { copy($1, state: .some($0)) }
    )
  }
}
