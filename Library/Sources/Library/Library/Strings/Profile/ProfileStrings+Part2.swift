// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProfileStrings {
  /// "Survey"
  ///
  /// - **en**: "Survey"
  /// - **de**: "Befragung"
  /// - **es**: "Cuestionario"
  /// - **fr**: "Questionnaire"
  /// - **ja**: "サーベイ"
  public static func Survey() -> String {
    return localizedString(
      key: "Survey",
      defaultValue: "Survey",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Take Survey"
  ///
  /// - **en**: "Take Survey"
  /// - **de**: "Befragung ausfüllen"
  /// - **es**: "Completar cuestionario"
  /// - **fr**: "Répondre au questionnaire"
  /// - **ja**: "サーベイに回答する"
  public static func Take_survey() -> String {
    return localizedString(
      key: "Take_survey",
      defaultValue: "Take Survey",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backer #%{backer_number}"
  ///
  /// - **en**: "Backer #%{backer_number}"
  /// - **de**: "Unterstützer Nr. %{backer_number}"
  /// - **es**: "Patrocinador n° %{backer_number}"
  /// - **fr**: "Contributeur no. %{backer_number}"
  /// - **ja**: "バッカーナンバー %{backer_number}"
  public static func backer_modal_backer_number(backer_number: String) -> String {
    return localizedString(
      key: "backer_modal.backer_number",
      defaultValue: "Backer #%{backer_number}",
      count: nil,
      substitutions: ["backer_number": backer_number]
    )
  }
  /// "Domestic"
  ///
  /// - **en**: "Domestic"
  /// - **de**: "National"
  /// - **es**: "Nacional"
  /// - **fr**: "National"
  /// - **ja**: "国内"
  public static func backer_modal_domestic() -> String {
    return localizedString(
      key: "backer_modal.domestic",
      defaultValue: "Domestic",
      count: nil,
      substitutions: [:]
    )
  }
  /// "International"
  ///
  /// - **en**: "International"
  /// - **de**: "International"
  /// - **es**: "Internacional"
  /// - **fr**: "International"
  /// - **ja**: "全世界"
  public static func backer_modal_international() -> String {
    return localizedString(
      key: "backer_modal.international",
      defaultValue: "International",
      count: nil,
      substitutions: [:]
    )
  }
  /// "N/A"
  ///
  /// - **en**: "N/A"
  /// - **de**: "n. z."
  /// - **es**: "ND"
  /// - **fr**: "Sans objet"
  /// - **ja**: "N/A"
  public static func backer_modal_missing_location_name() -> String {
    return localizedString(
      key: "backer_modal.missing_location_name",
      defaultValue: "N/A",
      count: nil,
      substitutions: [:]
    )
  }
  /// "N/A"
  ///
  /// - **en**: "N/A"
  /// - **de**: "Nicht verfügbar"
  /// - **es**: "ND"
  /// - **fr**: "Indisponible"
  /// - **ja**: "N/A"
  public static func backer_modal_not_available() -> String {
    return localizedString(
      key: "backer_modal.not_available",
      defaultValue: "N/A",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Settings"
  ///
  /// - **en**: "Settings"
  /// - **de**: "Einstellungen"
  /// - **es**: "Configuración"
  /// - **fr**: "Paramètres"
  /// - **ja**: "設定"
  public static func profile_buttons_settings() -> String {
    return localizedString(
      key: "profile.buttons.settings",
      defaultValue: "Settings",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{category_count} categories backed"
  ///
  /// - **en**: "%{category_count} categories backed"
  /// - **de**: "In %{category_count} Kategorien"
  /// - **es**: "en %{category_count} categorías"
  /// - **fr**: "%{category_count} catégories soutenues"
  /// - **ja**: "%{category_count} カテゴリーへバック"
  public static func profile_category_count_categories_backed(category_count: Int) -> String {
    return localizedString(
      key: "profile.category_count_categories_backed",
      defaultValue: "%{category_count} categories backed",
      count: category_count,
      substitutions: ["category_count": Format.wholeNumber(category_count)]
    )
  }
  /// "%{category_count} categories backed"
  ///
  /// - **en**: "%{category_count} categories backed"
  /// - **de**: "In %{category_count} Kategorien"
  /// - **es**: "en %{category_count} categorías"
  /// - **fr**: "%{category_count} catégories soutenues"
  /// - **ja**: "%{category_count} カテゴリーへバック"
  public static func profile_category_count_categories_backed_other(category_count: String) -> String {
    return localizedString(
      key: "profile.category_count_categories_backed.other",
      defaultValue: "%{category_count} categories backed",
      count: nil,
      substitutions: ["category_count": category_count]
    )
  }
  /// "%{category_name} (%{backed_projects_count})"
  ///
  /// - **en**: "%{category_name} (%{backed_projects_count})"
  /// - **de**: "%{category_name} (%{backed_projects_count})"
  /// - **es**: "%{category_name} (%{backed_projects_count})"
  /// - **fr**: "%{category_name} (%{backed_projects_count})"
  /// - **ja**: "%{category_name}（%{backed_projects_count}）"
  public static func profile_pie_slice_category_name_backed_projects_count(category_name: String, backed_projects_count: String) -> String {
    return localizedString(
      key: "profile.pie.slice.category_name_backed_projects_count",
      defaultValue: "%{category_name} (%{backed_projects_count})",
      count: nil,
      substitutions: ["category_name": category_name, "backed_projects_count": backed_projects_count]
    )
  }
  /// "BACKED %{project_count} PROJECTS"
  ///
  /// - **en**: "BACKED %{project_count} PROJECTS"
  /// - **de**: "HAT %{project_count} PROJEKTE UNTERSTÜTZT"
  /// - **es**: "%{project_count} PROYECTOS APOYADOS"
  /// - **fr**: "%{project_count} PROJETS SOUTENUS"
  /// - **ja**: "%{project_count} プロジェクトへバック済"
  public static func profile_projects_backed_project_count_projects(project_count: Int) -> String {
    return localizedString(
      key: "profile.projects.backed_project_count_projects",
      defaultValue: "BACKED %{project_count} PROJECTS",
      count: project_count,
      substitutions: ["project_count": Format.wholeNumber(project_count)]
    )
  }
  /// "BACKED %{project_count} PROJECTS"
  ///
  /// - **en**: "BACKED %{project_count} PROJECTS"
  /// - **de**: "HAT %{project_count} PROJEKTE UNTERSTÜTZT"
  /// - **es**: "%{project_count} PROYECTOS APOYADOS"
  /// - **fr**: "%{project_count} PROJETS SOUTENUS"
  /// - **ja**: "%{project_count} プロジェクトへバック済"
  public static func profile_projects_backed_project_count_projects_other(project_count: String) -> String {
    return localizedString(
      key: "profile.projects.backed_project_count_projects.other",
      defaultValue: "BACKED %{project_count} PROJECTS",
      count: nil,
      substitutions: ["project_count": project_count]
    )
  }
  /// "Backed projects"
  ///
  /// - **en**: "Backed projects"
  /// - **de**: "Unterstützte Projekte"
  /// - **es**: "Proyectos patrocinados"
  /// - **fr**: "Projets soutenus"
  /// - **ja**: "バック済プロジェクト"
  public static func profile_projects_backed_projects() -> String {
    return localizedString(
      key: "profile.projects.backed_projects",
      defaultValue: "Backed projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Created projects"
  ///
  /// - **en**: "Created projects"
  /// - **de**: "Erstellte Projekte"
  /// - **es**: "Proyectos creados"
  /// - **fr**: "Mes projets"
  /// - **ja**: "作成したプロジェクト"
  public static func profile_projects_created_projects() -> String {
    return localizedString(
      key: "profile.projects.created_projects",
      defaultValue: "Created projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover projects"
  ///
  /// - **en**: "Discover projects"
  /// - **de**: "Projekte entdecken"
  /// - **es**: "Descubre proyectos"
  /// - **fr**: "Découvrir des projets"
  /// - **ja**: "プロジェクトを探す"
  public static func profile_projects_empty_state_button() -> String {
    return localizedString(
      key: "profile.projects.empty_state.button",
      defaultValue: "Discover projects",
      count: nil,
      substitutions: [:]
    )
  }
}
