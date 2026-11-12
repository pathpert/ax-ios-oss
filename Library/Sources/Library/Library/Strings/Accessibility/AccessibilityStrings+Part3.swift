// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension AccessibilityStrings {
  /// "Opens project."
  ///
  /// - **en**: "Opens project."
  /// - **de**: "Öffnet die Projektseite."
  /// - **es**: "Abre la página de proyecto."
  /// - **fr**: "Ouvre le projet."
  /// - **ja**: "プロジェクトをみる"
  public static func dashboard_tout_accessibility_hint_opens_project() -> String {
    return localizedString(
      key: "dashboard.tout.accessibility_hint_opens_project",
      defaultValue: "Opens project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Changes sort."
  ///
  /// - **en**: "Changes sort."
  /// - **de**: "Sortiert Änderungen."
  /// - **es**: "Clasif. de cambios."
  /// - **fr**: "Modifie le tri."
  /// - **ja**: "並び変え"
  public static func discovery_accessibility_buttons_sort_hint() -> String {
    return localizedString(
      key: "discovery.accessibility.buttons.sort_hint",
      defaultValue: "Changes sort.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sort by %{sort}"
  ///
  /// - **en**: "Sort by %{sort}"
  /// - **de**: "Sortiert nach %{sort}"
  /// - **es**: "Clasificar por %{sort}"
  /// - **fr**: "Trier par %{sort}"
  /// - **ja**: "%{sort} で表示"
  public static func discovery_accessibility_buttons_sort_label(sort: String) -> String {
    return localizedString(
      key: "discovery.accessibility.buttons.sort_label",
      defaultValue: "Sort by %{sort}",
      count: nil,
      substitutions: ["sort": sort]
    )
  }
  /// "Live projects"
  ///
  /// - **en**: "Live projects"
  /// - **de**: "Live-Projekte"
  /// - **es**: "Proyectos activos"
  /// - **fr**: "Projets en cours"
  /// - **ja**: "進行中プロジェクト"
  public static func discovery_accessibility_live_project_count() -> String {
    return localizedString(
      key: "discovery.accessibility.live_project_count",
      defaultValue: "Live projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Activity feed"
  ///
  /// - **en**: "Activity feed"
  /// - **de**: "Aktivität-Übersicht"
  /// - **es**: "Resumen de actividad"
  /// - **fr**: "Flux d'activité"
  /// - **ja**: "アクティビティ"
  public static func discovery_accessibility_toolbar_buttons_activity_label() -> String {
    return localizedString(
      key: "discovery.accessibility.toolbar.buttons.activity_label",
      defaultValue: "Activity feed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by category"
  ///
  /// - **en**: "Filter by category"
  /// - **de**: "Filter: Kategorie"
  /// - **es**: "Ordenar por categoría"
  /// - **fr**: "Filtrer par catégorie"
  /// - **ja**: "カテゴリーで表示"
  public static func discovery_accessibility_toolbar_buttons_filter_label() -> String {
    return localizedString(
      key: "discovery.accessibility.toolbar.buttons.filter_label",
      defaultValue: "Filter by category",
      count: nil,
      substitutions: [:]
    )
  }
  /// "User menu"
  ///
  /// - **en**: "User menu"
  /// - **de**: "Benutzermenü"
  /// - **es**: "Menú Usuario"
  /// - **fr**: "Menu utilisateur"
  /// - **ja**: "メニュー"
  public static func discovery_accessibility_toolbar_buttons_user_menu() -> String {
    return localizedString(
      key: "discovery.accessibility.toolbar.buttons.user_menu",
      defaultValue: "User menu",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Category"
  ///
  /// - **en**: "Category"
  /// - **de**: "Kategorie"
  /// - **es**: "Categoría"
  /// - **fr**: "Catégorie"
  /// - **ja**: "カテゴリー"
  public static func discovery_baseball_card_accessibility_category_label() -> String {
    return localizedString(
      key: "discovery.baseball_card.accessibility.category.label",
      defaultValue: "Category",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Location"
  ///
  /// - **en**: "Location"
  /// - **de**: "Ort"
  /// - **es**: "Ubicación"
  /// - **fr**: "Lieu"
  /// - **ja**: "地域"
  public static func discovery_baseball_card_accessibility_location_label() -> String {
    return localizedString(
      key: "discovery.baseball_card.accessibility.location.label",
      defaultValue: "Location",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{backers_count} backers so far, %{percent_funded} funded, %{time_left} to go"
  ///
  /// - **en**: "%{backers_count} backers so far, %{percent_funded} funded, %{time_left} to go"
  /// - **de**: "Bisher %{backers_count} Unterstützer, %{percent_funded} finanziert, noch %{time_left}"
  /// - **es**: "De momento tiene %{backers_count} patrocinadores, financiado al %{percent_funded}, tiempo restante: %{time_left}"
  /// - **fr**: "Pour le moment, %{backers_count} contributeurs, projet financé à %{percent_funded}, plus que %{time_left}"
  /// - **ja**: "現在バッカー%{backers_count} 人。%{percent_funded} 達成、%{time_left} で締切"
  public static func discovery_baseball_card_stats_accessibility_live_stat_value(backers_count: Int, percent_funded: String, time_left: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.accessibility.live_stat_value",
      defaultValue: "%{backers_count} backers so far, %{percent_funded} funded, %{time_left} to go",
      count: backers_count,
      substitutions: ["backers_count": Format.wholeNumber(backers_count), "percent_funded": percent_funded, "time_left": time_left]
    )
  }
  /// "%{backers_count} backers so far, %{percent_funded} funded, %{time_left} to go"
  ///
  /// - **en**: "%{backers_count} backers so far, %{percent_funded} funded, %{time_left} to go"
  /// - **de**: "Bisher %{backers_count} Unterstützer, %{percent_funded} finanziert, noch %{time_left}"
  /// - **es**: "De momento tiene %{backers_count} patrocinadores, financiado al %{percent_funded}, tiempo restante: %{time_left}"
  /// - **fr**: "Pour le moment, %{backers_count} contributeurs, projet financé à %{percent_funded}, plus que %{time_left}"
  /// - **ja**: "現在バッカー%{backers_count} 人。%{percent_funded} 達成、%{time_left} で締切"
  public static func discovery_baseball_card_stats_accessibility_live_stat_value_other(backers_count: String, percent_funded: String, time_left: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.accessibility.live_stat_value.other",
      defaultValue: "%{backers_count} backers so far, %{percent_funded} funded, %{time_left} to go",
      count: nil,
      substitutions: ["backers_count": backers_count, "percent_funded": percent_funded, "time_left": time_left]
    )
  }
  /// "%{backers_count} backers total, %{percent_funded} funded, %{time_left} to go"
  ///
  /// - **en**: "%{backers_count} backers total, %{percent_funded} funded, %{time_left} to go"
  /// - **de**: "Gesamt %{backers_count} Unterstützer, %{percent_funded} finanziert, noch %{time_left}"
  /// - **es**: "De momento tiene %{backers_count} patrocinadores, financiado al %{percent_funded}, tiempo restante: %{time_left}"
  /// - **fr**: "%{backers_count} contributeurs, projet financé à %{percent_funded}, plus que %{time_left}"
  /// - **ja**: "バッカー%{backers_count} 人、%{percent_funded} 達成、%{time_left} で締切"
  public static func discovery_baseball_card_stats_accessibility_non_live_stat_value(backers_count: Int, percent_funded: String, time_left: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.accessibility.non_live_stat_value",
      defaultValue: "%{backers_count} backers total, %{percent_funded} funded, %{time_left} to go",
      count: backers_count,
      substitutions: ["backers_count": Format.wholeNumber(backers_count), "percent_funded": percent_funded, "time_left": time_left]
    )
  }
  /// "%{backers_count} backers total, %{percent_funded} funded, %{time_left} to go"
  ///
  /// - **en**: "%{backers_count} backers total, %{percent_funded} funded, %{time_left} to go"
  /// - **de**: "Gesamt %{backers_count} Unterstützer, %{percent_funded} finanziert, noch %{time_left}"
  /// - **es**: "De momento tiene %{backers_count} patrocinadores, financiado al %{percent_funded}, tiempo restante: %{time_left}"
  /// - **fr**: "%{backers_count} contributeurs, projet financé à %{percent_funded}, plus que %{time_left}"
  /// - **ja**: "バッカー%{backers_count} 人、%{percent_funded} 達成、%{time_left} で締切"
  public static func discovery_baseball_card_stats_accessibility_non_live_stat_value_other(backers_count: String, percent_funded: String, time_left: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.accessibility.non_live_stat_value.other",
      defaultValue: "%{backers_count} backers total, %{percent_funded} funded, %{time_left} to go",
      count: nil,
      substitutions: ["backers_count": backers_count, "percent_funded": percent_funded, "time_left": time_left]
    )
  }
  /// "Close Facebook connect hero"
  ///
  /// - **en**: "Close Facebook connect hero"
  /// - **de**: ""Mit Facebook verknüpfen" Banner schließen"
  /// - **es**: "Cerrar banner "Conectar via Facebook""
  /// - **fr**: "Fermer la bannière de connexion Facebook"
  /// - **ja**: "閉じる"
  public static func discovery_facebook_connect_hero_accessibility_button_close_facebook_connect_hero_label() -> String {
    return localizedString(
      key: "discovery.facebook_connect_hero.accessibility.button_close_facebook_connect_hero.label",
      defaultValue: "Close Facebook connect hero",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Close find friends hero"
  ///
  /// - **en**: "Close find friends hero"
  /// - **de**: ""Finde deine Freunde" Banner schließen"
  /// - **es**: "Cerrar banner "Encontrar amigos""
  /// - **fr**: "Fermer la bannière de recherche des amis"
  /// - **ja**: "ヒーローを見つける"
  public static func discovery_find_friends_hero_accessibility_button_close_find_friends_hero_label() -> String {
    return localizedString(
      key: "discovery.find_friends_hero.accessibility.button_close_find_friends_hero.label",
      defaultValue: "Close find friends hero",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Kickstarter"
  ///
  /// - **en**: "Kickstarter"
  /// - **de**: "Kickstarter"
  /// - **es**: "Kickstarter"
  /// - **fr**: "Kickstarter"
  /// - **ja**: "Kickstarter"
  public static func general_accessibility_kickstarter() -> String {
    return localizedString(
      key: "general.accessibility.kickstarter",
      defaultValue: "Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
}
