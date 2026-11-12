// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "All %{category_name} Projects"
  ///
  /// - **en**: "All %{category_name} Projects"
  /// - **de**: "Alle Projekte in %{category_name}"
  /// - **es**: "Todos los proyectos de %{category_name}"
  /// - **fr**: "Tous les projets %{category_name}"
  /// - **ja**: "%{category_name} の全プロジェクト"
  public static func All_category_name_Projects(category_name: String) -> String {
    return localizedString(
      key: "All_category_name_Projects",
      defaultValue: "All %{category_name} Projects",
      count: nil,
      substitutions: ["category_name": category_name]
    )
  }
  /// "Category"
  ///
  /// - **en**: "Category"
  /// - **de**: "Kategorie"
  /// - **es**: "Categoría"
  /// - **fr**: "Catégorie"
  /// - **ja**: "カテゴリー選択"
  public static func Category() -> String {
    return localizedString(
      key: "Category",
      defaultValue: "Category",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Closes filters."
  ///
  /// - **en**: "Closes filters."
  /// - **de**: "Filter schließen."
  /// - **es**: "Cierra filtros."
  /// - **fr**: "Ferme les filtres."
  /// - **ja**: "フィルターを閉じる"
  public static func Closes_filters() -> String {
    return localizedString(
      key: "Closes_filters",
      defaultValue: "Closes filters.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore and support the latest creative ideas created by our vast global community."
  ///
  /// - **en**: "Explore and support the latest creative ideas created by our vast global community."
  /// - **de**: "Erkunde und unterstütze die neuesten kreativen Ideen unserer enormen globalen Community."
  /// - **es**: "Explora y apoya las más recientes ideas creativas de nuestra vasta comunidad global."
  /// - **fr**: "Explorez et participez aux dernières idées créatives de nos créateurs à travers le monde."
  /// - **ja**: "Kickstarter のグローバルなコミュニティが作成した最新のクリエイティブアイデアを閲覧し、サポートしましょう。"
  public static func Explore_and_support_the_latest_creative_ideas() -> String {
    return localizedString(
      key: "Explore_and_support_the_latest_creative_ideas",
      defaultValue: "Explore and support the latest creative ideas created by our vast global community.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore creative projects"
  ///
  /// - **en**: "Explore creative projects"
  /// - **de**: "Erkunde kreative Projekte"
  /// - **es**: "Explora proyectos creativos"
  /// - **fr**: "Découvrez des projets créatifs"
  /// - **ja**: "クリエイティブなプロジェクトをさがす"
  public static func Explore_creative_projects() -> String {
    return localizedString(
      key: "Explore_creative_projects",
      defaultValue: "Explore creative projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore projects"
  ///
  /// - **en**: "Explore projects"
  /// - **de**: "Projekte erkunden"
  /// - **es**: "Explora proyectos"
  /// - **fr**: "Découvrir des projets"
  /// - **ja**: "プロジェクトをさがす"
  public static func Explore_projects() -> String {
    return localizedString(
      key: "Explore_projects",
      defaultValue: "Explore projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore projects we love"
  ///
  /// - **en**: "Explore projects we love"
  /// - **de**: "Team-Favoriten erkunden"
  /// - **es**: "Explorar Nuestros favoritos"
  /// - **fr**: "Découvrir nos coups de cœur"
  /// - **ja**: "Projects We Love を見る"
  public static func Explore_projects_we_love() -> String {
    return localizedString(
      key: "Explore_projects_we_love",
      defaultValue: "Explore projects we love",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore the app"
  ///
  /// - **en**: "Explore the app"
  /// - **de**: "App erkunden"
  /// - **es**: "Explorar la aplicación"
  /// - **fr**: "Découvrir l'application"
  /// - **ja**: "アプリを使ってみる"
  public static func Explore_the_app() -> String {
    return localizedString(
      key: "Explore_the_app",
      defaultValue: "Explore the app",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter"
  ///
  /// - **en**: "Filter"
  /// - **de**: "Filter"
  /// - **es**: "Filtro"
  /// - **fr**: "Filtre"
  /// - **ja**: "絞り込む"
  public static func Filter() -> String {
    return localizedString(
      key: "Filter",
      defaultValue: "Filter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by all projects"
  ///
  /// - **en**: "Filter by all projects"
  /// - **de**: "Filter: Alle Projekte"
  /// - **es**: "Filtro: Todos los proyectos"
  /// - **fr**: "Filtrer : tous les projets"
  /// - **ja**: "全てのプロジェクトに絞る"
  public static func Filter_by_all_projects() -> String {
    return localizedString(
      key: "Filter_by_all_projects",
      defaultValue: "Filter by all projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by %{category_name}"
  ///
  /// - **en**: "Filter by %{category_name}"
  /// - **de**: "Filter: %{category_name}"
  /// - **es**: "Filtro: %{category_name}"
  /// - **fr**: "Filtrer par catégorie : %{category_name}"
  /// - **ja**: "%{category_name} に絞る"
  public static func Filter_by_category_name(category_name: String) -> String {
    return localizedString(
      key: "Filter_by_category_name",
      defaultValue: "Filter by %{category_name}",
      count: nil,
      substitutions: ["category_name": category_name]
    )
  }
  /// "Filter by projects backed by friends"
  ///
  /// - **en**: "Filter by projects backed by friends"
  /// - **de**: "Filter: Von Freunden unterstützte Projekte"
  /// - **es**: "Filtro: Proyectos patrocinados por amigos"
  /// - **fr**: "Filtrer : engagements de mes amis"
  /// - **ja**: "友達がバックしてるプロジェクトに絞る"
  public static func Filter_by_projects_backed_by_friends() -> String {
    return localizedString(
      key: "Filter_by_projects_backed_by_friends",
      defaultValue: "Filter by projects backed by friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by projects recommended for you"
  ///
  /// - **en**: "Filter by projects recommended for you"
  /// - **de**: "Filter: Für dich empfohlene Projekte"
  /// - **es**: "Filtro: Proyectos recomendados"
  /// - **fr**: "Filtrer : recommandations"
  /// - **ja**: "オススメの人気プロジェクトに絞る"
  public static func Filter_by_projects_recommended_for_you() -> String {
    return localizedString(
      key: "Filter_by_projects_recommended_for_you",
      defaultValue: "Filter by projects recommended for you",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by projects we love"
  ///
  /// - **en**: "Filter by projects we love"
  /// - **de**: "Filter: Team-Favoriten"
  /// - **es**: "Filtro: Nuestros favoritos"
  /// - **fr**: "Filtrer : Coups de cœur"
  /// - **ja**: "Project We Love に絞る"
  public static func Filter_by_projects_we_love() -> String {
    return localizedString(
      key: "Filter_by_projects_we_love",
      defaultValue: "Filter by projects we love",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by saved projects"
  ///
  /// - **en**: "Filter by saved projects"
  /// - **de**: "Filter: Gespeicherte Projekte"
  /// - **es**: "Filtro: Proyectos guardados"
  /// - **fr**: "Filtrer : mes projets enregistrés"
  /// - **ja**: "保存済みプロジェクトで絞る"
  public static func Filter_by_saved_projects() -> String {
    return localizedString(
      key: "Filter_by_saved_projects",
      defaultValue: "Filter by saved projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Filter by %{subcategory_name} in %{category_name}"
  ///
  /// - **en**: "Filter by %{subcategory_name} in %{category_name}"
  /// - **de**: "Filter: %{subcategory_name} in %{category_name}"
  /// - **es**: "Filtro: %{subcategory_name} en %{category_name}"
  /// - **fr**: "Filtrer : %{subcategory_name}, sous %{category_name}"
  /// - **ja**: "%{category_name} の%{subcategory_name} で絞る"
  public static func Filter_by_subcategory_name_in_category_name(subcategory_name: String, category_name: String) -> String {
    return localizedString(
      key: "Filter_by_subcategory_name_in_category_name",
      defaultValue: "Filter by %{subcategory_name} in %{category_name}",
      count: nil,
      substitutions: ["subcategory_name": subcategory_name, "category_name": category_name]
    )
  }
}
