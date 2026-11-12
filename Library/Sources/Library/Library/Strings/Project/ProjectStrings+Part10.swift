// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "Updates"
  ///
  /// - **en**: "Updates"
  /// - **de**: "Updates"
  /// - **es**: "Actualizaciones"
  /// - **fr**: "Actus"
  /// - **ja**: "アップデート"
  public static func project_subpages_menu_buttons_updates() -> String {
    return localizedString(
      key: "project.subpages.menu.buttons.updates",
      defaultValue: "Updates",
      count: nil,
      substitutions: [:]
    )
  }
  /// "View pledge"
  ///
  /// - **en**: "View pledge"
  /// - **de**: "Finanzierungsbeitrag anzeigen"
  /// - **es**: "Ver contribución"
  /// - **fr**: "Afficher mon engagement"
  /// - **ja**: "プレッジ内容を見る"
  public static func project_view_button() -> String {
    return localizedString(
      key: "project.view_button",
      defaultValue: "View pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{project_count} project"
  ///
  /// - **en**: "%{project_count} project"
  /// - **de**: "%{project_count} Projekt"
  /// - **es**: "%{project_count} proyecto"
  /// - **fr**: "%{project_count} projet"
  /// - **ja**: "%{project_count} 件のプロジェクト"
  public static func project_count_projects(project_count: Int) -> String {
    return localizedString(
      key: "project_count_projects",
      defaultValue: "%{project_count} project",
      count: project_count,
      substitutions: ["project_count": Format.wholeNumber(project_count)]
    )
  }
  /// "%{project_count} projects"
  ///
  /// - **en**: "%{project_count} projects"
  /// - **de**: "%{project_count} Projekte"
  /// - **es**: "%{project_count} proyectos"
  /// - **fr**: "%{project_count} projets"
  /// - **ja**: "%{project_count} 件のプロジェクト"
  public static func project_count_projects_other(project_count: String) -> String {
    return localizedString(
      key: "project_count_projects.other",
      defaultValue: "%{project_count} projects",
      count: nil,
      substitutions: ["project_count": project_count]
    )
  }
  /// "Creator"
  ///
  /// - **en**: "Creator"
  /// - **de**: "Projektgründer"
  /// - **es**: "Creador"
  /// - **fr**: "Créateur"
  /// - **ja**: "クリエイター"
  public static func update_comments_creator() -> String {
    return localizedString(
      key: "update.comments.creator",
      defaultValue: "Creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Leave a comment"
  ///
  /// - **en**: "Leave a comment"
  /// - **de**: "Kommentar verfassen"
  /// - **es**: "Deja un comentario"
  /// - **fr**: "Laisser un commentaire"
  /// - **ja**: "コメントを残す"
  public static func update_comments_empty_state_backer_button() -> String {
    return localizedString(
      key: "update.comments.empty_state.backer.button",
      defaultValue: "Leave a comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No comments"
  ///
  /// - **en**: "No comments"
  /// - **de**: "Keine Kommentare"
  /// - **es**: "No hay comentarios"
  /// - **fr**: "Pas de commentaires"
  /// - **ja**: "コメントなし"
  public static func update_comments_empty_state_backer_title() -> String {
    return localizedString(
      key: "update.comments.empty_state.backer.title",
      defaultValue: "No comments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Leave a comment"
  ///
  /// - **en**: "Leave a comment"
  /// - **de**: "Kommentar verfassen"
  /// - **es**: "Deja un comentario"
  /// - **fr**: "Laisser un commentaire"
  /// - **ja**: "コメントを残す"
  public static func update_comments_empty_state_logged_out_button() -> String {
    return localizedString(
      key: "update.comments.empty_state.logged_out.button",
      defaultValue: "Leave a comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No comments"
  ///
  /// - **en**: "No comments"
  /// - **de**: "Keine Kommentare"
  /// - **es**: "No hay comentarios"
  /// - **fr**: "Pas de commentaires"
  /// - **ja**: "コメントなし"
  public static func update_comments_empty_state_logged_out_title() -> String {
    return localizedString(
      key: "update.comments.empty_state.logged_out.title",
      defaultValue: "No comments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Leave a comment"
  ///
  /// - **en**: "Leave a comment"
  /// - **de**: "Kommentar verfassen"
  /// - **es**: "Deja un comentario"
  /// - **fr**: "Laisser un commentaire"
  /// - **ja**: "コメントを残す"
  public static func update_comments_empty_state_non_backer_button() -> String {
    return localizedString(
      key: "update.comments.empty_state.non_backer.button",
      defaultValue: "Leave a comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No comments"
  ///
  /// - **en**: "No comments"
  /// - **de**: "Keine Kommentare"
  /// - **es**: "No hay comentarios"
  /// - **fr**: "Pas de commentaires"
  /// - **ja**: "コメントなし"
  public static func update_comments_empty_state_non_backer_title() -> String {
    return localizedString(
      key: "update.comments.empty_state.non_backer.title",
      defaultValue: "No comments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You"
  ///
  /// - **en**: "You"
  /// - **de**: "Du"
  /// - **es**: "Tú"
  /// - **fr**: "Vous"
  /// - **ja**: "あなた"
  public static func update_comments_you() -> String {
    return localizedString(
      key: "update.comments.you",
      defaultValue: "You",
      count: nil,
      substitutions: [:]
    )
  }
}
