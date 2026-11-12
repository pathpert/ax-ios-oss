import Prelude

extension User.NewsletterSubscriptions {
  /// Functional lenses for `User.NewsletterSubscriptions`.
  public enum lens {
    private static func copy(
      _ subs: User.NewsletterSubscriptions,
      arts: Bool?? = nil,
      games: Bool?? = nil,
      happening: Bool?? = nil,
      invent: Bool?? = nil,
      promo: Bool?? = nil,
      weekly: Bool?? = nil,
      films: Bool?? = nil,
      publishing: Bool?? = nil,
      alumni: Bool?? = nil,
      music: Bool?? = nil
    ) -> User.NewsletterSubscriptions {
      User.NewsletterSubscriptions(
        arts: arts ?? subs.arts,
        games: games ?? subs.games,
        happening: happening ?? subs.happening,
        invent: invent ?? subs.invent,
        promo: promo ?? subs.promo,
        weekly: weekly ?? subs.weekly,
        films: films ?? subs.films,
        publishing: publishing ?? subs.publishing,
        alumni: alumni ?? subs.alumni,
        music: music ?? subs.music
      )
    }

    /// Lens focusing on the Kickstarter Arts newsletter subscription flag.
    public static let arts = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.arts },
      set: { copy($1, arts: .some($0)) }
    )

    /// Lens focusing on the Kickstarter Games newsletter subscription flag.
    public static let games = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.games },
      set: { copy($1, games: .some($0)) }
    )

    /// Lens focusing on the Happening newsletter subscription flag.
    public static let happening = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.happening },
      set: { copy($1, happening: .some($0)) }
    )

    /// Lens focusing on the Invent (Design & Tech) newsletter subscription flag.
    public static let invent = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.invent },
      set: { copy($1, invent: .some($0)) }
    )

    /// Lens focusing on Kickstarter promotional announcements subscription flag.
    public static let promo = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.promo },
      set: { copy($1, promo: .some($0)) }
    )

    /// Lens focusing on the Kickstarter Weekly Projects We Love newsletter flag.
    public static let weekly = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.weekly },
      set: { copy($1, weekly: .some($0)) }
    )

    /// Lens focusing on the Kickstarter Film newsletter subscription flag.
    public static let films = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.films },
      set: { copy($1, films: .some($0)) }
    )

    /// Lens focusing on the Kickstarter Publishing newsletter subscription flag.
    public static let publishing = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.publishing },
      set: { copy($1, publishing: .some($0)) }
    )

    /// Lens focusing on the Kickstarter Creator Alumni newsletter subscription flag.
    public static let alumni = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.alumni },
      set: { copy($1, alumni: .some($0)) }
    )

    /// Lens focusing on the Kickstarter Music newsletter subscription flag.
    public static let music = Lens<User.NewsletterSubscriptions, Bool?>(
      view: { $0.music },
      set: { copy($1, music: .some($0)) }
    )
  }
}
