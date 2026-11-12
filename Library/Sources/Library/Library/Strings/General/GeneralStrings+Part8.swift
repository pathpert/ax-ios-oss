// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Estimated delivery"
  ///
  /// - **en**: "Estimated delivery"
  /// - **de**: "Voraussichtliche Lieferung:"
  /// - **es**: "Entrega estimada:"
  /// - **fr**: "Livraison prévue :"
  /// - **ja**: "配達予定"
  public static func Estimated_delivery() -> String {
    return localizedString(
      key: "Estimated_delivery",
      defaultValue: "Estimated delivery",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Estimated delivery:"
  ///
  /// - **en**: "Estimated delivery:"
  /// - **de**: "Voraussichtliche Lieferung:"
  /// - **es**: "Entrega estimada:"
  /// - **fr**: "Livraison prévue :"
  /// - **ja**: "配達予定:"
  public static func Estimated_delivery_colon() -> String {
    return localizedString(
      key: "Estimated_delivery_colon",
      defaultValue: "Estimated delivery:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Estimated delivery of"
  ///
  /// - **en**: "Estimated delivery of"
  /// - **de**: "Voraussichtliches Lieferdatum"
  /// - **es**: "Entrega estimada de"
  /// - **fr**: "Livraison prévue le"
  /// - **ja**: "配送予定日"
  public static func Estimated_delivery_of() -> String {
    return localizedString(
      key: "Estimated_delivery_of",
      defaultValue: "Estimated delivery of",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Ex: Posting obscene or hateful comments, doxxing or posting personal information in comments or updates."
  ///
  /// - **en**: "Ex: Posting obscene or hateful comments, doxxing or posting personal information in comments or updates."
  /// - **de**: "Beispiel: Das Posten obszöner Kommentare oder Hassreden, Doxxing oder Posten personenbezogener Daten in Kommentaren oder Aktualisierungen."
  /// - **es**: "Ej.: Publicar comentarios obscenos u odiosos, obtener información personal de personas (doxxing) o publicar información personal en comentarios o actualizaciones."
  /// - **fr**: "P. ex. : commentaires obscènes ou haineux, doxxing, données personnelles publiées dans les commentaires ou les actus."
  /// - **ja**: "例: ひわいなコメントや攻撃的なコメントを投稿したり、コメントや更新情報内で他人の個人情報を投稿 (ドキシング) したりなど。"
  public static func Ex_posting() -> String {
    return localizedString(
      key: "Ex_posting",
      defaultValue: "Ex: Posting obscene or hateful comments, doxxing or posting personal information in comments or updates.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Ex: Using email lists from outside sources, promoting a project where it shouldn't be promoted, link bombing."
  ///
  /// - **en**: "Ex: Using email lists from outside sources, promoting a project where it shouldn't be promoted, link bombing."
  /// - **de**: "Beispiele: Benutzung von E-Mail-Listen Dritter, Bewerben eines Projekts an unangebrachten Stellen, massenweises Versenden von Links."
  /// - **es**: "Ej.: usar listas de correos electrónicos de fuentes externas, promocionar un proyecto en un lugar indebido, bombardeos de enlaces."
  /// - **fr**: "Par exemple : listes de distribution externes, méthodes de promotion inacceptables, bombardement de liens."
  /// - **ja**: "例: 外部ソースからのメールリストを使用したり、宣伝してはいけない場所でプロジェクトの宣伝を行ったり、リンク爆弾を用いたりなど。"
  public static func Ex_using() -> String {
    return localizedString(
      key: "Ex_using",
      defaultValue: "Ex: Using email lists from outside sources, promoting a project where it shouldn't be promoted, link bombing.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Expands subcategories."
  ///
  /// - **en**: "Expands subcategories."
  /// - **de**: "Erweitert die Anzeige der Unterkategorien."
  /// - **es**: "Muestra más subcategorías."
  /// - **fr**: "Développe les sous-catégories."
  /// - **ja**: "サブカテゴリーを表示"
  public static func Expands_subcategories() -> String {
    return localizedString(
      key: "Expands_subcategories",
      defaultValue: "Expands subcategories.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Expiration"
  ///
  /// - **en**: "Expiration"
  /// - **de**: "Verfallsdatum"
  /// - **es**: "Vencimiento"
  /// - **fr**: "Expiration"
  /// - **ja**: "有効期限"
  public static func Expiration() -> String {
    return localizedString(
      key: "Expiration",
      defaultValue: "Expiration",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Expired %{date} at %{time}"
  ///
  /// - **en**: "Expired %{date} at %{time}"
  /// - **de**: "Abgelaufen am %{date} um %{time}"
  /// - **es**: "Venció el %{date} a la(s) %{time}"
  /// - **fr**: "Expirées depuis le %{date} à %{time}"
  /// - **ja**: "有効期限: %{date} %{time}"
  public static func Expired_date_at_time(date: String, time: String) -> String {
    return localizedString(
      key: "Expired_date_at_time",
      defaultValue: "Expired %{date} at %{time}",
      count: nil,
      substitutions: ["date": date, "time": time]
    )
  }
  /// "Expires %{date} at %{time}"
  ///
  /// - **en**: "Expires %{date} at %{time}"
  /// - **de**: "Läuft am %{date} um %{time} ab"
  /// - **es**: "Vence el %{date} a la(s) %{time}"
  /// - **fr**: "Expiration le %{date} à %{time}"
  /// - **ja**: "有効期限: %{date} %{time}"
  public static func Expires_date_at_time(date: String, time: String) -> String {
    return localizedString(
      key: "Expires_date_at_time",
      defaultValue: "Expires %{date} at %{time}",
      count: nil,
      substitutions: ["date": date, "time": time]
    )
  }
  /// "Explore"
  ///
  /// - **en**: "Explore"
  /// - **de**: "Erkunden"
  /// - **es**: "Explora"
  /// - **fr**: "Explorer"
  /// - **ja**: "さがす"
  public static func Explore() -> String {
    return localizedString(
      key: "Explore",
      defaultValue: "Explore",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Failed to retrieve live stream event details"
  ///
  /// - **en**: "Failed to retrieve live stream event details"
  /// - **de**: "Details zu Live-Stream-Event konnten nicht geladen werden"
  /// - **es**: "No se pudo cargar la información acerca del evento en vivo"
  /// - **fr**: "Impossible de récupérer les détails de la diffusion en direct"
  /// - **ja**: "ライブ配信の詳細を取得できませんでした"
  public static func Failed_to_retrieve_live_stream_event_details() -> String {
    return localizedString(
      key: "Failed_to_retrieve_live_stream_event_details",
      defaultValue: "Failed to retrieve live stream event details",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Featured"
  ///
  /// - **en**: "Featured"
  /// - **de**: "Highlights"
  /// - **es**: "Destacados"
  /// - **fr**: "En vedette"
  /// - **ja**: "注目"
  public static func Featured() -> String {
    return localizedString(
      key: "Featured",
      defaultValue: "Featured",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Feed"
  ///
  /// - **en**: "Feed"
  /// - **de**: "Feed"
  /// - **es**: "Feed"
  /// - **fr**: "Flux"
  /// - **ja**: "フィード"
  public static func Feed() -> String {
    return localizedString(
      key: "Feed",
      defaultValue: "Feed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Find projects that speak to you ▸"
  ///
  /// - **en**: "Find projects that speak to you ▸"
  /// - **de**: "Finde Projekte, die dich ansprechen"
  /// - **es**: "Descubre proyectos que te resulten interesantes"
  /// - **fr**: "Des projets qui vous parlent"
  /// - **ja**: "あなたの心に訴えかけるプロジェクトを見つけよう"
  public static func Find_projects_that_speak_to_you() -> String {
    return localizedString(
      key: "Find_projects_that_speak_to_you",
      defaultValue: "Find projects that speak to you ▸",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Find projects you’ll love and help bring creative ideas to life."
  ///
  /// - **en**: "Find projects you’ll love and help bring creative ideas to life."
  /// - **de**: "Finde Projekte, die zu dir passen und hilf mit bei der Umsetzung neuer, kreativer Ideen."
  /// - **es**: "Aquí encuentras proyectos a tu gusto - ¡tu contribución ayudará a hacerlos realidad!"
  /// - **fr**: "Découvrez de beaux projets et participez à la concrétisation d'idées créatives."
  /// - **ja**: "お気に入りを見つけて、クリエイティブなプロジェクトに生命を吹き込もう。"
  public static func Find_projects_youll_love_and_help_bring() -> String {
    return localizedString(
      key: "Find_projects_youll_love_and_help_bring",
      defaultValue: "Find projects you’ll love and help bring creative ideas to life.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Find projects you’ll love in art, design, film, games, music, and more. Once you back a project, you’ll see all your activity here."
  ///
  /// - **en**: "Find projects you’ll love in art, design, film, games, music, and more. Once you back a project, you’ll see all your activity here."
  /// - **de**: "Finde Projekte nach deinem Geschmack - in Kunst, Design, Film, Spiele, Musik und vielen anderen Kategorien. Wenn du ein Projekt unterstützt hast, wird deren Aktivität hier angezeigt."
  /// - **es**: "Proyectos a tu gusto - en arte, diseño, cine, juegos, música y otras categorías. Una vez que hayas patrocinado un proyecto, verás todas las actividades pertinentes aquí."
  /// - **fr**: "Découvrez des projets que vous allez adorer : art, design, cinéma, jeux, musique et plus encore. L'activité des projets que vous soutenez s'affichera ici."
  /// - **ja**: "お気に入りを見つけて、クリエイティブなプロジェクトに生命を吹き込もう。"
  public static func Find_projects_youll_love_in_art_design_film() -> String {
    return localizedString(
      key: "Find_projects_youll_love_in_art_design_film",
      defaultValue: "Find projects you’ll love in art, design, film, games, music, and more. Once you back a project, you’ll see all your activity here.",
      count: nil,
      substitutions: [:]
    )
  }
}
