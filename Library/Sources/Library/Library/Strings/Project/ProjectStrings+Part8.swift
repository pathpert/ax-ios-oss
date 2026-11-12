// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "No comments"
  ///
  /// - **en**: "No comments"
  /// - **de**: "Keine Kommentare"
  /// - **es**: "No hay comentarios"
  /// - **fr**: "Pas de commentaires"
  /// - **ja**: "コメントなし"
  public static func project_comments_empty_state_logged_out_title() -> String {
    return localizedString(
      key: "project.comments.empty_state.logged_out.title",
      defaultValue: "No comments",
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
  public static func project_comments_empty_state_non_backer_title() -> String {
    return localizedString(
      key: "project.comments.empty_state.non_backer.title",
      defaultValue: "No comments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sorry, your comment could not be posted."
  ///
  /// - **en**: "Sorry, your comment could not be posted."
  /// - **de**: "Dein Kommentar konnte leider nicht gepostet werden."
  /// - **es**: "Lo sentimos, no se pudo publicar tu comentario."
  /// - **fr**: "Désolé, votre commentaire n'a pas pu être publié."
  /// - **ja**: "申し訳ございません。コメントできませんでした。"
  public static func project_comments_error_posting() -> String {
    return localizedString(
      key: "project.comments.error_posting",
      defaultValue: "Sorry, your comment could not be posted.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Comment posted!"
  ///
  /// - **en**: "Comment posted!"
  /// - **de**: "Kommentar veröffentlicht!"
  /// - **es**: "¡Comentario fue publicado!"
  /// - **fr**: "Commentaire publié !"
  /// - **ja**: "コメント投稿完了!"
  public static func project_comments_posted() -> String {
    return localizedString(
      key: "project.comments.posted",
      defaultValue: "Comment posted!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "by %{creator_name}"
  ///
  /// - **en**: "by %{creator_name}"
  /// - **de**: "von %{creator_name}"
  /// - **es**: "por %{creator_name}"
  /// - **fr**: "par %{creator_name}"
  /// - **ja**: "by %{creator_name}"
  public static func project_creator_by_creator(creator_name: String) -> String {
    return localizedString(
      key: "project.creator.by_creator",
      defaultValue: "by %{creator_name}",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "by <u>%{creator_name}</u>"
  ///
  /// - **en**: "by <u>%{creator_name}</u>"
  /// - **de**: "von %{creator_name}"
  /// - **es**: "de %{creator_name}"
  /// - **fr**: "par %{creator_name}"
  /// - **ja**: "by <u>%{creator_name}</u>"
  public static func project_creator_by_creator_html(creator_name: String) -> String {
    return localizedString(
      key: "project.creator.by_creator_html",
      defaultValue: "by <u>%{creator_name}</u>",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// " • You're a backer"
  ///
  /// - **en**: " • You're a backer"
  /// - **de**: " • Du unterstützt das Projekt"
  /// - **es**: " • Tú eres un patrocinador"
  /// - **fr**: " • Vous êtes contributeur"
  /// - **ja**: " • あなたはバッカーです"
  public static func project_creator_youre_a_backer() -> String {
    return localizedString(
      key: "project.creator.youre_a_backer",
      defaultValue: " • You're a backer",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This project will only be funded if at least %{goal_currency} is pledged by %{deadline}."
  ///
  /// - **en**: "This project will only be funded if at least %{goal_currency} is pledged by %{deadline}."
  /// - **de**: "Dieses Projekt wird nur finanziert, wenn bis %{deadline} mindestens %{goal_currency} zusammenkommen."
  /// - **es**: "Este proyecto será financiado únicamente si se contribuye por lo menos %{goal_currency} hasta %{deadline}."
  /// - **fr**: "Ce projet ne sera financé que si au moins %{goal_currency} sont engagés avant le %{deadline}."
  /// - **ja**: "%{deadline} までに %{goal_currency} 以上のプレッジが集まれば、このプロジェクトは資金を得ることができます。"
  public static func project_disclaimer_goal_not_reached(goal_currency: String, deadline: String) -> String {
    return localizedString(
      key: "project.disclaimer.goal_not_reached",
      defaultValue: "This project will only be funded if at least %{goal_currency} is pledged by %{deadline}.",
      count: nil,
      substitutions: ["goal_currency": goal_currency, "deadline": deadline]
    )
  }
  /// "This project will be funded on %{deadline}."
  ///
  /// - **en**: "This project will be funded on %{deadline}."
  /// - **de**: "Dieses Projekt wird am %{deadline} finanziert."
  /// - **es**: "Este proyecto será financiado el %{deadline}."
  /// - **fr**: "Ce projet sera financé le %{deadline}."
  /// - **ja**: "%{deadline} までにファンド達成できるでしょう。"
  public static func project_disclaimer_goal_reached(deadline: String) -> String {
    return localizedString(
      key: "project.disclaimer.goal_reached",
      defaultValue: "This project will be funded on %{deadline}.",
      count: nil,
      substitutions: ["deadline": deadline]
    )
  }
  /// "Manage pledge"
  ///
  /// - **en**: "Manage pledge"
  /// - **de**: "Finanzierungsbeitrag verwalten"
  /// - **es**: "Administrar contribución"
  /// - **fr**: "Gérer"
  /// - **ja**: "プレッジを管理"
  public static func project_manage_button() -> String {
    return localizedString(
      key: "project.manage_button",
      defaultValue: "Manage pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Campaign"
  ///
  /// - **en**: "Campaign"
  /// - **de**: "Kampagne"
  /// - **es**: "Campaña"
  /// - **fr**: "Campagne"
  /// - **ja**: "キャンペーン"
  public static func project_menu_buttons_campaign() -> String {
    return localizedString(
      key: "project.menu.buttons.campaign",
      defaultValue: "Campaign",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Comments"
  ///
  /// - **en**: "Comments"
  /// - **de**: "Kommentare"
  /// - **es**: "Comentarios"
  /// - **fr**: "Commentaires"
  /// - **ja**: "コメント"
  public static func project_menu_buttons_comments() -> String {
    return localizedString(
      key: "project.menu.buttons.comments",
      defaultValue: "Comments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Updates"
  ///
  /// - **en**: "Updates"
  /// - **de**: "Updates"
  /// - **es**: "Actualizaciones"
  /// - **fr**: "Actus"
  /// - **ja**: "アップデート"
  public static func project_menu_buttons_updates() -> String {
    return localizedString(
      key: "project.menu.buttons.updates",
      defaultValue: "Updates",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Created by"
  ///
  /// - **en**: "Created by"
  /// - **de**: "Erstellt von"
  /// - **es**: "Creado por"
  /// - **fr**: "Créé par"
  /// - **ja**: "製作者"
  public static func project_menu_created_by() -> String {
    return localizedString(
      key: "project.menu.created_by",
      defaultValue: "Created by",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Kickstarter has restricted this creator"
  ///
  /// - **en**: "Kickstarter has restricted this creator"
  /// - **de**: "Kickstarter hat diesen Projektgründer eingeschränkt"
  /// - **es**: "Creador restringido por Kickstarter"
  /// - **fr**: "Créateur restreint par Kickstarter"
  /// - **ja**: "このクリエイターは Kickstarter によってアクセス制限されています"
  public static func project_project_notices_header() -> String {
    return localizedString(
      key: "project.project_notices.header",
      defaultValue: "Kickstarter has restricted this creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Learn more"
  ///
  /// - **en**: "Learn more"
  /// - **de**: "Weitere Info"
  /// - **es**: "Más información"
  /// - **fr**: "En savoir plus"
  /// - **ja**: "もっとくわしく"
  public static func project_project_notices_notice_cta() -> String {
    return localizedString(
      key: "project.project_notices.notice_cta",
      defaultValue: "Learn more",
      count: nil,
      substitutions: [:]
    )
  }
}
