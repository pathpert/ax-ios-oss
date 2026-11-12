// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "%{filter_name}: %{project_count} live project"
  ///
  /// - **en**: "%{filter_name}: %{project_count} live project"
  /// - **de**: "%{filter_name}: %{project_count} Live-Projekt"
  /// - **es**: "%{filter_name}: %{project_count} proyecto activo"
  /// - **fr**: "%{filter_name} : %{project_count} projet en cours"
  /// - **ja**: "%{filter_name}：%{project_count} の進行中プロジェクト"
  public static func Filter_name_project_count_live_projects(filter_name: String, project_count: Int) -> String {
    return localizedString(
      key: "Filter_name_project_count_live_projects",
      defaultValue: "%{filter_name}: %{project_count} live project",
      count: project_count,
      substitutions: ["filter_name": filter_name, "project_count": Format.wholeNumber(project_count)]
    )
  }
  /// "%{filter_name}: %{project_count} live projects"
  ///
  /// - **en**: "%{filter_name}: %{project_count} live projects"
  /// - **de**: "%{filter_name}: %{project_count} Live-Projekte"
  /// - **es**: "%{filter_name}: %{project_count} proyectos activos"
  /// - **fr**: "%{filter_name} : %{project_count} projets en cours"
  /// - **ja**: "%{filter_name}：%{project_count} の進行中プロジェクト"
  public static func Filter_name_project_count_live_projects_other(filter_name: String, project_count: String) -> String {
    return localizedString(
      key: "Filter_name_project_count_live_projects.other",
      defaultValue: "%{filter_name}: %{project_count} live projects",
      count: nil,
      substitutions: ["filter_name": filter_name, "project_count": project_count]
    )
  }
  /// "Filters by projects with upcoming and past live streams."
  ///
  /// - **en**: "Filters by projects with upcoming and past live streams."
  /// - **de**: "Filtert nach zukünftigen und vergangenen Live-Streams."
  /// - **es**: "Ordenar por proyectos con live streams futuros/pasados."
  /// - **fr**: "Filtrage des projets ayant des diffusions en direct à venir et passées."
  /// - **ja**: "近日公開予定、または過去のライブ配信含むプロジェクトに絞る"
  public static func Filters_by_projects_with_upcoming_and_past_live_streams() -> String {
    return localizedString(
      key: "Filters_by_projects_with_upcoming_and_past_live_streams",
      defaultValue: "Filters by projects with upcoming and past live streams.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens filters."
  ///
  /// - **en**: "Opens filters."
  /// - **de**: "Öffnet Filter."
  /// - **es**: "Abre filtros."
  /// - **fr**: "Ouvre les filtres."
  /// - **ja**: "フィルターをみる"
  public static func Opens_filters() -> String {
    return localizedString(
      key: "Opens_filters",
      defaultValue: "Opens filters.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recommended"
  ///
  /// - **en**: "Recommended"
  /// - **de**: "Empfehlungen"
  /// - **es**: "Recomendados"
  /// - **fr**: "Rien que pour vous"
  /// - **ja**: "おすすめ"
  public static func Recommended() -> String {
    return localizedString(
      key: "Recommended",
      defaultValue: "Recommended",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recommended For You"
  ///
  /// - **en**: "Recommended For You"
  /// - **de**: "Empfehlungen für dich"
  /// - **es**: "Recomendaciones para ti"
  /// - **fr**: "Rien que pour vous"
  /// - **ja**: "あなたへのおすすめ"
  public static func Recommended_For_You() -> String {
    return localizedString(
      key: "Recommended_For_You",
      defaultValue: "Recommended For You",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recommended for you"
  ///
  /// - **en**: "Recommended for you"
  /// - **de**: "Empfehlungen für dich"
  /// - **es**: "Recomendaciones para ti"
  /// - **fr**: "Rien que pour vous"
  /// - **ja**: "あなたにおすすめ"
  public static func Recommended_for_you() -> String {
    return localizedString(
      key: "Recommended_for_you",
      defaultValue: "Recommended for you",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Remove all filters"
  ///
  /// - **en**: "Remove all filters"
  /// - **de**: "Alle Filter entfernen"
  /// - **es**: "Eliminar todos los filtros"
  /// - **fr**: "Supprimer tous les filtres"
  /// - **ja**: "すべてのフィルタを外す"
  public static func Remove_all_filters() -> String {
    return localizedString(
      key: "Remove_all_filters",
      defaultValue: "Remove all filters",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reset all"
  ///
  /// - **en**: "Reset all"
  /// - **de**: "Alle zurücksetzen"
  /// - **es**: "Restablecer todo"
  /// - **fr**: "Tout réinitialiser"
  /// - **ja**: "すべてをリセット"
  public static func Reset_all_filters() -> String {
    return localizedString(
      key: "Reset_all_filters",
      defaultValue: "Reset all",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reset"
  ///
  /// - **en**: "Reset"
  /// - **de**: "Zurücksetzen"
  /// - **es**: "Restablecer"
  /// - **fr**: "Réinitialiser"
  /// - **ja**: "リセット"
  public static func Reset_filters() -> String {
    return localizedString(
      key: "Reset_filters",
      defaultValue: "Reset",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{search_results_count} result"
  ///
  /// - **en**: "%{search_results_count} result"
  /// - **de**: "%{search_results_count} Ergebnis"
  /// - **es**: "%{search_results_count} resultado"
  /// - **fr**: "%{search_results_count} résultat"
  /// - **ja**: "%{search_results_count} 件の結果"
  public static func Search_results(search_results_count: Int) -> String {
    return localizedString(
      key: "Search_results",
      defaultValue: "%{search_results_count} result",
      count: search_results_count,
      substitutions: ["search_results_count": Format.wholeNumber(search_results_count)]
    )
  }
  /// "%{search_results_count} results"
  ///
  /// - **en**: "%{search_results_count} results"
  /// - **de**: "%{search_results_count} Ergebnisse"
  /// - **es**: "%{search_results_count} resultados"
  /// - **fr**: "%{search_results_count} résultats"
  /// - **ja**: "%{search_results_count} 件の結果"
  public static func Search_results_other(search_results_count: String) -> String {
    return localizedString(
      key: "Search_results.other",
      defaultValue: "%{search_results_count} results",
      count: nil,
      substitutions: ["search_results_count": search_results_count]
    )
  }
  /// "Recommended for you"
  ///
  /// - **en**: "Recommended for you"
  /// - **de**: "Empfehlungen für dich"
  /// - **es**: "Recomendaciones"
  /// - **fr**: "Rien que pour vous"
  /// - **ja**: "あなたにおすすめ"
  public static func Show_only_recommended_for_you() -> String {
    return localizedString(
      key: "Show_only_recommended_for_you",
      defaultValue: "Recommended for you",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sort by"
  ///
  /// - **en**: "Sort by"
  /// - **de**: "Sortieren nach"
  /// - **es**: "Ordenar por"
  /// - **fr**: "Trier par"
  /// - **ja**: "並べ替える"
  public static func Sort_by() -> String {
    return localizedString(
      key: "Sort_by",
      defaultValue: "Sort by",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sorting and filtering"
  ///
  /// - **en**: "Sorting and filtering"
  /// - **de**: "Sortieren und filtern"
  /// - **es**: "Clasificación y filtros"
  /// - **fr**: "Tri et filtrage"
  /// - **ja**: "並べ替えとフィルタリング"
  public static func Sorting_and_filtering() -> String {
    return localizedString(
      key: "Sorting_and_filtering",
      defaultValue: "Sorting and filtering",
      count: nil,
      substitutions: [:]
    )
  }
  /// "To access all your favorite categories, tap the explore dropdown at the top of the app."
  ///
  /// - **en**: "To access all your favorite categories, tap the explore dropdown at the top of the app."
  /// - **de**: "Für schnellen Zugriff auf deine meist besuchten Kategorien, tippe auf das Dropdown-Menü oben."
  /// - **es**: "Accede a tus categorías favoritas en el menú en la parte superior de la app."
  /// - **fr**: "Pour retrouver toutes vos catégories préférées, cliquez sur le menu déroulant Découvrir dans l'application."
  /// - **ja**: "上部の「さがす」をタップし、お気に入りカテゴリにアクセス。"
  public static func To_access_all_your_favorite_categories_tap_the_explore_dropdown() -> String {
    return localizedString(
      key: "To_access_all_your_favorite_categories_tap_the_explore_dropdown",
      defaultValue: "To access all your favorite categories, tap the explore dropdown at the top of the app.",
      count: nil,
      substitutions: [:]
    )
  }
}
