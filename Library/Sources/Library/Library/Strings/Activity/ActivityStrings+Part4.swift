// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "You"
  ///
  /// - **en**: "You"
  /// - **de**: "Du"
  /// - **es**: "Tú"
  /// - **fr**: "Vous"
  /// - **ja**: "あなたは"
  public static func activity_creator_actions_you_commented_on_your_project_pronoun() -> String {
    return localizedString(
      key: "activity.creator.actions.you_commented_on_your_project_pronoun",
      defaultValue: "You",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You posted Update #%{update_number}:"
  ///
  /// - **en**: "You posted Update #%{update_number}:"
  /// - **de**: "Du hast Aktualisierung Nr. %{update_number} veröffentlicht:"
  /// - **es**: "Publicaste actualización n° %{update_number}:"
  /// - **fr**: "Vous avez publié l'actu no. %{update_number}"
  /// - **ja**: "アップデート＃%{update_number} ："
  public static func activity_creator_actions_you_posted_update_number(update_number: String) -> String {
    return localizedString(
      key: "activity.creator.actions.you_posted_update_number",
      defaultValue: "You posted Update #%{update_number}:",
      count: nil,
      substitutions: ["update_number": update_number]
    )
  }
  /// "You"
  ///
  /// - **en**: "You"
  /// - **de**: "Du"
  /// - **es**: "Tú"
  /// - **fr**: "Vous"
  /// - **ja**: "あなた"
  public static func activity_creator_actions_you_posted_update_number_pronoun() -> String {
    return localizedString(
      key: "activity.creator.actions.you_posted_update_number_pronoun",
      defaultValue: "You",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Comment"
  ///
  /// - **en**: "Comment"
  /// - **de**: "Kommentar"
  /// - **es**: "Comentario"
  /// - **fr**: "Commentaire"
  /// - **ja**: "コメント"
  public static func activity_creator_buttons_comment() -> String {
    return localizedString(
      key: "activity.creator.buttons.comment",
      defaultValue: "Comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Couldn't load activity"
  ///
  /// - **en**: "Couldn't load activity"
  /// - **de**: "Aktivität konnte nicht geladen werden"
  /// - **es**: "No se pudo cargar actividad"
  /// - **fr**: "Chargement impossible"
  /// - **ja**: "アクティビティの読込失敗"
  public static func activity_creator_error_could_not_load_activity() -> String {
    return localizedString(
      key: "activity.creator.error_could_not_load_activity",
      defaultValue: "Couldn't load activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Activity"
  ///
  /// - **en**: "Activity"
  /// - **de**: "Aktivitäten"
  /// - **es**: "Actividad"
  /// - **fr**: "Activité"
  /// - **ja**: "アクティビティ"
  public static func activity_creator_navigation_header_activity() -> String {
    return localizedString(
      key: "activity.creator.navigation.header.activity",
      defaultValue: "Activity",
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
  public static func activity_creator_you() -> String {
    return localizedString(
      key: "activity.creator.you",
      defaultValue: "You",
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
  public static func activity_empty_state_logged_in_button() -> String {
    return localizedString(
      key: "activity.empty_state.logged_in.button",
      defaultValue: "Discover projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Activity empty"
  ///
  /// - **en**: "Activity empty"
  /// - **de**: "Noch keine Aktivitäten"
  /// - **es**: "Aún no hay actividades"
  /// - **fr**: "Activité vide"
  /// - **ja**: "アクティビティ無"
  public static func activity_empty_state_logged_in_title() -> String {
    return localizedString(
      key: "activity.empty_state.logged_in.title",
      defaultValue: "Activity empty",
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
  public static func activity_empty_state_logged_out_button() -> String {
    return localizedString(
      key: "activity.empty_state.logged_out.button",
      defaultValue: "Discover projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Activity empty"
  ///
  /// - **en**: "Activity empty"
  /// - **de**: "Noch keine Aktivitäten"
  /// - **es**: "Aún no hay actividades"
  /// - **fr**: "Activité vide"
  /// - **ja**: "アクティビティ無"
  public static func activity_empty_state_logged_out_title() -> String {
    return localizedString(
      key: "activity.empty_state.logged_out.title",
      defaultValue: "Activity empty",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow back?"
  ///
  /// - **en**: "Follow back?"
  /// - **de**: "Auch folgen?"
  /// - **es**: "¿Le quieres seguir también?"
  /// - **fr**: "Suivre cette personne ?"
  /// - **ja**: "フォローバックしますか？"
  public static func activity_follow_back() -> String {
    return localizedString(
      key: "activity.follow_back",
      defaultValue: "Follow back?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{number_of_followers} followers"
  ///
  /// - **en**: "%{number_of_followers} followers"
  /// - **de**: "%{number_of_followers} Follower"
  /// - **es**: "%{number_of_followers} seguidores"
  /// - **fr**: "%{number_of_followers} abonnés"
  /// - **ja**: "%{number_of_followers} 人のフォロワー"
  public static func activity_followers(number_of_followers: String) -> String {
    return localizedString(
      key: "activity.followers",
      defaultValue: "%{number_of_followers} followers",
      count: nil,
      substitutions: ["number_of_followers": number_of_followers]
    )
  }
  /// "%{friend_name} backed an Art project."
  ///
  /// - **en**: "%{friend_name} backed an Art project."
  /// - **de**: "%{friend_name} hat ein Kunst-Projekt unterstützt."
  /// - **es**: "%{friend_name} patrocinó un proyecto de Arte."
  /// - **fr**: "%{friend_name} a soutenu un projet artistique."
  /// - **ja**: "%{friend_name} はアートプロジェクトにバック。"
  public static func activity_friend_backed_art_project(friend_name: String) -> String {
    return localizedString(
      key: "activity.friend_backed_art_project",
      defaultValue: "%{friend_name} backed an Art project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "%{friend_name} backed a Comics project."
  ///
  /// - **en**: "%{friend_name} backed a Comics project."
  /// - **de**: "%{friend_name} hat ein Comics-Projekt unterstützt."
  /// - **es**: "%{friend_name} patrocinó un proyecto de Comics."
  /// - **fr**: "%{friend_name} a soutenu un projet de BD."
  /// - **ja**: "%{friend_name} がコミックプロジェクトにバック"
  public static func activity_friend_backed_comics_project(friend_name: String) -> String {
    return localizedString(
      key: "activity.friend_backed_comics_project",
      defaultValue: "%{friend_name} backed a Comics project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "%{friend_name} backed a Crafts project."
  ///
  /// - **en**: "%{friend_name} backed a Crafts project."
  /// - **de**: "%{friend_name} hat ein Kunsthandwerk-Projekt unterstützt."
  /// - **es**: "%{friend_name} patrocinó un proyecto de Artesanías."
  /// - **fr**: "%{friend_name} a soutenu un projet d'artisanat."
  /// - **ja**: "%{friend_name} がクラフトプロジェクトにバック"
  public static func activity_friend_backed_crafts_project(friend_name: String) -> String {
    return localizedString(
      key: "activity.friend_backed_crafts_project",
      defaultValue: "%{friend_name} backed a Crafts project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
}
