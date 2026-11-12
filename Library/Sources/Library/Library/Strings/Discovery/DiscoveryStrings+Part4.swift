// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "Try adjusting the filters"
  ///
  /// - **en**: "Try adjusting the filters"
  /// - **de**: "Versuche, die Filter anzupassen"
  /// - **es**: "Prueba modificar los filtros"
  /// - **fr**: "Essayez de modifier les filtres"
  /// - **ja**: "フィルターを調整してみてください"
  public static func Try_adjusting_the_filters() -> String {
    return localizedString(
      key: "Try_adjusting_the_filters",
      defaultValue: "Try adjusting the filters",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Try rephrasing your search or adjusting the filters"
  ///
  /// - **en**: "Try rephrasing your search or adjusting the filters"
  /// - **de**: "Versuche, deine Suche anders zu formulieren oder die Filter anzupassen"
  /// - **es**: "Intenta reformular tu búsqueda o ajustar los filtros"
  /// - **fr**: "Essayez de reformuler votre recherche ou de modifier les filtres"
  /// - **ja**: "検索キーワードを変更するか、フィルターを調整してみてください"
  public static func Try_rephrasing_your_search_or_adjusting_the_filters() -> String {
    return localizedString(
      key: "Try_rephrasing_your_search_or_adjusting_the_filters",
      defaultValue: "Try rephrasing your search or adjusting the filters",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We couldn't find anything for “%{search_term}”."
  ///
  /// - **en**: "We couldn't find anything for “%{search_term}”."
  /// - **de**: "Es wurden keine Ergebnisse für die Suche "%{search_term}" gefunden."
  /// - **es**: "La búsqueda "%{search_term}" no dio resultados."
  /// - **fr**: "Pas de résultats pour « %{search_term} »."
  /// - **ja**: "「%{search_term}」に一致するものがありませんでした。"
  public static func We_couldnt_find_anything_for_search_term(search_term: String) -> String {
    return localizedString(
      key: "We_couldnt_find_anything_for_search_term",
      defaultValue: "We couldn't find anything for “%{search_term}”.",
      count: nil,
      substitutions: ["search_term": search_term]
    )
  }
  /// "%{category_name} saved."
  ///
  /// - **en**: "%{category_name} saved."
  /// - **de**: "%{category_name} gespeichert."
  /// - **es**: "%{category_name} guardado."
  /// - **fr**: "Catégorie enregistrée : %{category_name}."
  /// - **ja**: "%{category_name} を保存"
  public static func category_name_saved(category_name: String) -> String {
    return localizedString(
      key: "category_name_saved",
      defaultValue: "%{category_name} saved.",
      count: nil,
      substitutions: ["category_name": category_name]
    )
  }
  /// "Explore %{category_name}"
  ///
  /// - **en**: "Explore %{category_name}"
  /// - **de**: "Erkunde %{category_name}"
  /// - **es**: "Explorar %{category_name}"
  /// - **fr**: "Découvrir la catégorie %{category_name}"
  /// - **ja**: "%{category_name} をさがす"
  public static func category_promo_explore_category(category_name: String) -> String {
    return localizedString(
      key: "category_promo.explore_category",
      defaultValue: "Explore %{category_name}",
      count: nil,
      substitutions: ["category_name": category_name]
    )
  }
  /// "%{project_count} live projects"
  ///
  /// - **en**: "%{project_count} live projects"
  /// - **de**: "%{project_count} Live-Projekte"
  /// - **es**: "%{project_count} proyectos activos"
  /// - **fr**: "%{project_count} projets actifs"
  /// - **ja**: "%{project_count} 件の公開中プロジェクト"
  public static func category_promo_project_count_live_projects(project_count: String) -> String {
    return localizedString(
      key: "category_promo.project_count_live_projects",
      defaultValue: "%{project_count} live projects",
      count: nil,
      substitutions: ["project_count": project_count]
    )
  }
  /// "Cancel"
  ///
  /// - **en**: "Cancel"
  /// - **de**: "Abbrechen"
  /// - **es**: "Cancelar"
  /// - **fr**: "Annuler"
  /// - **ja**: "キャンセル"
  public static func discovery_activity_sample_alert_buttons_cancel() -> String {
    return localizedString(
      key: "discovery.activity_sample.alert.buttons.cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow"
  ///
  /// - **en**: "Follow"
  /// - **de**: "Folgen"
  /// - **es**: "Seguir"
  /// - **fr**: "S'abonner"
  /// - **ja**: "フォロー"
  public static func discovery_activity_sample_alert_buttons_follow() -> String {
    return localizedString(
      key: "discovery.activity_sample.alert.buttons.follow",
      defaultValue: "Follow",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow %{friend_name}?"
  ///
  /// - **en**: "Follow %{friend_name}?"
  /// - **de**: "%{friend_name} folgen?"
  /// - **es**: "Seguir a %{friend_name}?"
  /// - **fr**: "Suivre %{friend_name} ?"
  /// - **ja**: "%{friend_name} をフォローしますか？"
  public static func discovery_activity_sample_alert_follow_friend_name(friend_name: String) -> String {
    return localizedString(
      key: "discovery.activity_sample.alert.follow_friend_name",
      defaultValue: "Follow %{friend_name}?",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "See all activity"
  ///
  /// - **en**: "See all activity"
  /// - **de**: "Alle Aktivitäten anzeigen"
  /// - **es**: "Ver toda la actividad"
  /// - **fr**: "Toutes les activités"
  /// - **ja**: "アクティビティをみる"
  public static func discovery_activity_sample_button_see_all_activity() -> String {
    return localizedString(
      key: "discovery.activity_sample.button.see_all_activity",
      defaultValue: "See all activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Since your last visit"
  ///
  /// - **en**: "Since your last visit"
  /// - **de**: "Seit deinem letzten Besuch"
  /// - **es**: "Desde tu última visita"
  /// - **fr**: "Depuis votre dernière visite"
  /// - **ja**: "最終アクセス"
  public static func discovery_activity_sample_title_Since_your_last_visit() -> String {
    return localizedString(
      key: "discovery.activity_sample.title.Since_your_last_visit",
      defaultValue: "Since your last visit",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Since you've been gone..."
  ///
  /// - **en**: "Since you've been gone..."
  /// - **de**: "Seit deinem letzten Besuch ..."
  /// - **es**: "Lo que ocurrió desde tu última visita:"
  /// - **fr**: "Depuis votre dernière visite..."
  /// - **ja**: "最後のアクセスから"
  public static func discovery_activity_sample_title_since_youve_been_gone() -> String {
    return localizedString(
      key: "discovery.activity_sample.title.since_youve_been_gone",
      defaultValue: "Since you've been gone...",
      count: nil,
      substitutions: [:]
    )
  }
  /// "All of %{scope}"
  ///
  /// - **en**: "All of %{scope}"
  /// - **de**: "Alle in %{scope}"
  /// - **es**: "Todos en %{scope}"
  /// - **fr**: "Toute la catégorie %{scope}"
  /// - **ja**: "%{scope} の全て"
  public static func discovery_all_of_scope(scope: String) -> String {
    return localizedString(
      key: "discovery.all_of_scope",
      defaultValue: "All of %{scope}",
      count: nil,
      substitutions: ["scope": scope]
    )
  }
  /// "Backing"
  ///
  /// - **en**: "Backing"
  /// - **de**: "Unterstützte Projekte"
  /// - **es**: "Proyectos patrocinados"
  /// - **fr**: "Engagements"
  /// - **ja**: "バック"
  public static func discovery_backing() -> String {
    return localizedString(
      key: "discovery.backing",
      defaultValue: "Backing",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{blurb}%{space}<u>Read%{space}more</u>%{space}"
  ///
  /// - **en**: "%{blurb}%{space}<u>Read%{space}more</u>%{space}"
  /// - **de**: "%{blurb}%{space}<u>Mehr%{space}lesen</u>%{space}"
  /// - **es**: "%{blurb}%{space}<u>Leer%{space}más</u>%{space}"
  /// - **fr**: "%{blurb}%{space}<u>Plus</u>%{space}"
  /// - **ja**: "%{blurb}%{space}<u>さらに%{space}読む</u>%{space}"
  public static func discovery_baseball_card_blurb_read_more(blurb: String, space: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.blurb_read_more",
      defaultValue: "%{blurb}%{space}<u>Read%{space}more</u>%{space}",
      count: nil,
      substitutions: ["blurb": blurb, "space": space]
    )
  }
  /// "Share"
  ///
  /// - **en**: "Share"
  /// - **de**: "Teilen"
  /// - **es**: "Compartir"
  /// - **fr**: "Partager"
  /// - **ja**: "シェア"
  public static func discovery_baseball_card_button_share() -> String {
    return localizedString(
      key: "discovery.baseball_card.button.share",
      defaultValue: "Share",
      count: nil,
      substitutions: [:]
    )
  }
}
