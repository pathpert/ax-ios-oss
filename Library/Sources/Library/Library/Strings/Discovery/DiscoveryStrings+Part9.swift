// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "Most Funded"
  ///
  /// - **en**: "Most Funded"
  /// - **de**: "Meist finanziert"
  /// - **es**: "Más financiados"
  /// - **fr**: "Financement"
  /// - **ja**: "達成額順"
  public static func discovery_sort_types_most_funded() -> String {
    return localizedString(
      key: "discovery.sort_types.most_funded",
      defaultValue: "Most Funded",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Newest"
  ///
  /// - **en**: "Newest"
  /// - **de**: "Neueste"
  /// - **es**: "Más recientes"
  /// - **fr**: "Ancienneté"
  /// - **ja**: "最新"
  public static func discovery_sort_types_newest() -> String {
    return localizedString(
      key: "discovery.sort_types.newest",
      defaultValue: "Newest",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Popularity"
  ///
  /// - **en**: "Popularity"
  /// - **de**: "Beliebtheit"
  /// - **es**: "Popularidad"
  /// - **fr**: "Tendances"
  /// - **ja**: "人気"
  public static func discovery_sort_types_popularity() -> String {
    return localizedString(
      key: "discovery.sort_types.popularity",
      defaultValue: "Popularity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "sorted by"
  ///
  /// - **en**: "sorted by"
  /// - **de**: "sortiert nach"
  /// - **es**: "ordenados por"
  /// - **fr**: "triés par"
  /// - **ja**: "並び順"
  public static func discovery_sorted_by() -> String {
    return localizedString(
      key: "discovery.sorted_by",
      defaultValue: "sorted by",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Respond now"
  ///
  /// - **en**: "Respond now"
  /// - **de**: "Jetzt antworten"
  /// - **es**: "Responder ahora"
  /// - **fr**: "Répondre"
  /// - **ja**: "返信"
  public static func discovery_survey_button_respond_now() -> String {
    return localizedString(
      key: "discovery.survey.button.respond_now",
      defaultValue: "Respond now",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{creator_name} needs some info to deliver your reward for %{project_name}."
  ///
  /// - **en**: "%{creator_name} needs some info to deliver your reward for %{project_name}."
  /// - **de**: "%{creator_name} benötigt einige Angaben, um dir deine Belohnung für %{project_name} zustellen zu können."
  /// - **es**: "%{creator_name} necesita un par de datos para entregarte tu recompensa de %{project_name}."
  /// - **fr**: "%{creator_name} a besoin de quelques informations pour vous envoyer votre récompense pour le projet %{project_name}."
  /// - **ja**: "%{creator_name} は%{project_name} のリワードの情報が必要です。"
  public static func discovery_survey_creator_needs_some_info_to_deliver_reward_for_project(creator_name: String, project_name: String) -> String {
    return localizedString(
      key: "discovery.survey.creator_needs_some_info_to_deliver_reward_for_project",
      defaultValue: "%{creator_name} needs some info to deliver your reward for %{project_name}.",
      count: nil,
      substitutions: ["creator_name": creator_name, "project_name": project_name]
    )
  }
  /// "Reward Survey!"
  ///
  /// - **en**: "Reward Survey!"
  /// - **de**: "Befragung zur Belohnung!"
  /// - **es**: "¡Encuesta sobre recompensas!"
  /// - **fr**: "Le questionnaire des récompenses !"
  /// - **ja**: "リワードサーベイ"
  public static func discovery_survey_reward_survey() -> String {
    return localizedString(
      key: "discovery.survey.reward_survey",
      defaultValue: "Reward Survey!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discovery mode preview"
  ///
  /// - **en**: "Discovery mode preview"
  /// - **de**: "Erkundungsmodus-Vorschau"
  /// - **es**: "Vista previa del modo descubrimiento"
  /// - **fr**: "Aperçu du mode découverte"
  /// - **ja**: "Discovery Mode プレビュー"
  public static func discovery_banner_image_content_description() -> String {
    return localizedString(
      key: "discovery_banner_image_content_description",
      defaultValue: "Discovery mode preview",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Search messages"
  ///
  /// - **en**: "Search messages"
  /// - **de**: "Nachrichten suchen"
  /// - **es**: "Buscar mensajes"
  /// - **fr**: "Rechercher"
  /// - **ja**: "メッセージをさがす"
  public static func messages_search_placeholder_search_messages() -> String {
    return localizedString(
      key: "messages.search.placeholder_search_messages",
      defaultValue: "Search messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore new projects"
  ///
  /// - **en**: "Explore new projects"
  /// - **de**: "Erkunde neue Projekte"
  /// - **es**: "Explora proyectos nuevos"
  /// - **fr**: "Découvrir de nouveaux projets"
  /// - **ja**: "新プロジェクトをさがす"
  public static func profile_projects_empty_state_button_explore_new_projects() -> String {
    return localizedString(
      key: "profile.projects.empty_state.button_explore_new_projects",
      defaultValue: "Explore new projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Explore this project"
  ///
  /// - **en**: "Explore this project"
  /// - **de**: "Projekt erkunden"
  /// - **es**: "Explorar este proyecto"
  /// - **fr**: "Découvrir ce projet"
  /// - **ja**: "このプロジェクトをさらに知る"
  public static func project_menu_explore_this_project() -> String {
    return localizedString(
      key: "project.menu.explore_this_project",
      defaultValue: "Explore this project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "by %{creator_name}"
  ///
  /// - **en**: "by %{creator_name}"
  /// - **de**: "von %{creator_name}"
  /// - **es**: "de %{creator_name}"
  /// - **fr**: "par %{creator_name}"
  /// - **ja**: "by%{creator_name}"
  public static func search_by_creator(creator_name: String) -> String {
    return localizedString(
      key: "search.by_creator",
      defaultValue: "by %{creator_name}",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "Most Popular"
  ///
  /// - **en**: "Most Popular"
  /// - **de**: "Publikumslieblinge"
  /// - **es**: "Los más populares"
  /// - **fr**: "Les tendances"
  /// - **ja**: "最も人気"
  public static func search_most_popular() -> String {
    return localizedString(
      key: "search.most_popular",
      defaultValue: "Most Popular",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Search projects"
  ///
  /// - **en**: "Search projects"
  /// - **de**: "Projekte suchen"
  /// - **es**: "Buscar proyectos"
  /// - **fr**: "Rechercher des projets"
  /// - **ja**: "プロジェクトを探す"
  public static func tabbar_search_projects() -> String {
    return localizedString(
      key: "tabbar.search_projects",
      defaultValue: "Search projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Try our new discovery mode"
  ///
  /// - **en**: "Try our new discovery mode"
  /// - **de**: "Neuen Erkundungsmodus ausprobieren"
  /// - **es**: "Prueba nuestro nuevo modo de descubrimiento"
  /// - **fr**: "Essayez notre nouveau mode découverte"
  /// - **ja**: "新しいディスカバリーモードを試す"
  public static func try_our_new_discovery_mode() -> String {
    return localizedString(
      key: "try_our_new_discovery_mode",
      defaultValue: "Try our new discovery mode",
      count: nil,
      substitutions: [:]
    )
  }
}
