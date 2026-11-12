// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "You have successfully backed <b>%{project_name}</b>. This project is now one step closer to a reality, thanks to you. Spread the word!"
  ///
  /// - **en**: "You have successfully backed <b>%{project_name}</b>. This project is now one step closer to a reality, thanks to you. Spread the word!"
  /// - **de**: "Dank deiner Unterstützung ist <b>%{project_name}</b> seiner Verwirklichung einen Schritt näher. Sag es weiter!"
  /// - **es**: "Has patrocinado <b>%{project_name}</b> con éxito. Gracias a ti, este proyecto está ahora un paso más cerca de hacerse realidad. ¡Corre la voz!"
  /// - **fr**: "Vous vous êtes engagé à soutenir le projet <b>%{project_name}</b>. Ce projet se rapproche tout doucement de son objectif grâce à vous. Parlez-en à votre entourage !"
  /// - **ja**: "<b>%{project_name}</b>へのバックが完了しました。このプロジェクトは、成功に一歩近づきました！ありがとうございます。"
  public static func You_have_successfully_backed_project_html(project_name: String) -> String {
    return localizedString(
      key: "You_have_successfully_backed_project_html",
      defaultValue: "You have successfully backed <b>%{project_name}</b>. This project is now one step closer to a reality, thanks to you. Spread the word!",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "You launched this project on %{launch_date}. For creator tools, head to our website!"
  ///
  /// - **en**: "You launched this project on %{launch_date}. For creator tools, head to our website!"
  /// - **de**: "Du hast dieses Projekt am %{launch_date} veröffentlicht. Tools für Projektgründer findest du auf unserer Website."
  /// - **es**: "Publicaste el proyecto el %{launch_date}. Encuentra las herramientas para creadores en nuestro sitio web."
  /// - **fr**: "Vous avez lancé ce projet le %{launch_date}. Rendez-vous sur notre site Web pour accéder aux outils du créateur !"
  /// - **ja**: "%{launch_date} にこのプロジェクトをローンチしました。クリエイター向けツールにアクセスするには、Kickstarter ウェブサイトにアクセスしてください！"
  public static func You_launched_this_project_on_launch_date(launch_date: String) -> String {
    return localizedString(
      key: "You_launched_this_project_on_launch_date",
      defaultValue: "You launched this project on %{launch_date}. For creator tools, head to our website!",
      count: nil,
      substitutions: ["launch_date": launch_date]
    )
  }
  /// "You’ll lose the comment if you leave this page."
  ///
  /// - **en**: "You’ll lose the comment if you leave this page."
  /// - **de**: "Wenn du diese Seite verlässt, wird dein Kommentar gelöscht."
  /// - **es**: "Perderás el comentario si sales de esta página."
  /// - **fr**: "Si vous quittez cette page, votre commentaire sera perdu."
  /// - **ja**: "このページから移動するとコメントは破棄されます。"
  public static func You_will_lose_the_comment_if_you_leave_this_page() -> String {
    return localizedString(
      key: "You_will_lose_the_comment_if_you_leave_this_page",
      defaultValue: "You’ll lose the comment if you leave this page.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’ll be the first to receive project launch and creator update emails."
  ///
  /// - **en**: "You’ll be the first to receive project launch and creator update emails."
  /// - **de**: "Du gehörst dann zu den Ersten, die E-Mails zur Projektveröffentlichung und Updates des Projektgründers erhalten."
  /// - **es**: "Serás el primero en recibir correos electrónicos sobre el lanzamiento del proyecto y actualizaciones del creador."
  /// - **fr**: "Vous serez le premier à recevoir les e-mails annonçant un lancement ou une actu de ce créateur."
  /// - **ja**: "プロジェクトのローンチやクリエイターからの最新情報に関するメールがまっさきに届きます。"
  public static func Youll_be_the_first_to_receive_project_launch() -> String {
    return localizedString(
      key: "Youll_be_the_first_to_receive_project_launch",
      defaultValue: "You’ll be the first to receive project launch and creator update emails.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your comment wasn't posted"
  ///
  /// - **en**: "Your comment wasn't posted"
  /// - **de**: "Dein Kommentar wurde nicht gepostet"
  /// - **es**: "Tu comentario no se publicó"
  /// - **fr**: "Votre commentaire n'a pas été publié."
  /// - **ja**: "コメントは投稿されませんでした"
  public static func Your_comment_wasnt_posted() -> String {
    return localizedString(
      key: "Your_comment_wasnt_posted",
      defaultValue: "Your comment wasn't posted",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{comments_count} comment"
  ///
  /// - **en**: "%{comments_count} comment"
  /// - **de**: "%{comments_count} Kommentar"
  /// - **es**: "%{comments_count} commentario"
  /// - **fr**: "%{comments_count} commentaire"
  /// - **ja**: "%{comments_count} のコメント"
  public static func comments_count_comments(comments_count: Int) -> String {
    return localizedString(
      key: "comments_count_comments",
      defaultValue: "%{comments_count} comment",
      count: comments_count,
      substitutions: ["comments_count": Format.wholeNumber(comments_count)]
    )
  }
  /// "%{comments_count} comments"
  ///
  /// - **en**: "%{comments_count} comments"
  /// - **de**: "%{comments_count} Kommentare"
  /// - **es**: "%{comments_count} commentarios"
  /// - **fr**: "%{comments_count} commentaires"
  /// - **ja**: "%{comments_count} のコメント"
  public static func comments_count_comments_other(comments_count: String) -> String {
    return localizedString(
      key: "comments_count_comments.other",
      defaultValue: "%{comments_count} comments",
      count: nil,
      substitutions: ["comments_count": comments_count]
    )
  }
  /// "Funded on %{deadline}"
  ///
  /// - **en**: "Funded on %{deadline}"
  /// - **de**: "Finanziert am %{deadline}"
  /// - **es**: "Financiado el %{deadline}"
  /// - **fr**: "Financé le %{deadline}"
  /// - **ja**: "%{deadline} に達成　"
  public static func creator_project_preview_subtitle_funded_on_deadline(deadline: String) -> String {
    return localizedString(
      key: "creator_project_preview.subtitle.funded_on_deadline",
      defaultValue: "Funded on %{deadline}",
      count: nil,
      substitutions: ["deadline": deadline]
    )
  }
  /// "Funding canceled"
  ///
  /// - **en**: "Funding canceled"
  /// - **de**: "Finanzierung abgebrochen"
  /// - **es**: "Financiamiento cancelado"
  /// - **fr**: "Financement annulé"
  /// - **ja**: "募集をキャンセル"
  public static func creator_project_preview_subtitle_funding_canceled() -> String {
    return localizedString(
      key: "creator_project_preview.subtitle.funding_canceled",
      defaultValue: "Funding canceled",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding unsuccessful on %{deadline}"
  ///
  /// - **en**: "Funding unsuccessful on %{deadline}"
  /// - **de**: "Finanzierung fehlgeschlagen am %{deadline}"
  /// - **es**: "Financiamiento sin éxito el %{deadline}"
  /// - **fr**: "L'objectif de financement n'a pas été atteint avant le %{deadline}"
  /// - **ja**: "%{deadline} までに失敗"
  public static func creator_project_preview_subtitle_funding_unsuccessful_on_deadline(deadline: String) -> String {
    return localizedString(
      key: "creator_project_preview.subtitle.funding_unsuccessful_on_deadline",
      defaultValue: "Funding unsuccessful on %{deadline}",
      count: nil,
      substitutions: ["deadline": deadline]
    )
  }
  /// "Project suspended"
  ///
  /// - **en**: "Project suspended"
  /// - **de**: "Projekt ausgesetzt"
  /// - **es**: "Proyecto suspendido"
  /// - **fr**: "Projet suspendu"
  /// - **ja**: "プロジェクト停止済み"
  public static func creator_project_preview_subtitle_project_suspended() -> String {
    return localizedString(
      key: "creator_project_preview.subtitle.project_suspended",
      defaultValue: "Project suspended",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Comment"
  ///
  /// - **en**: "Comment"
  /// - **de**: "Kommentar"
  /// - **es**: "Comentar"
  /// - **fr**: "Commenter"
  /// - **ja**: "コメント"
  public static func general_navigation_buttons_comment() -> String {
    return localizedString(
      key: "general.navigation.buttons.comment",
      defaultValue: "Comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Back this project"
  ///
  /// - **en**: "Back this project"
  /// - **de**: "Dieses Projekt unterstützen"
  /// - **es**: "Patrocinar este proyecto"
  /// - **fr**: "Je soutiens ce projet"
  /// - **ja**: "バッカーになる"
  public static func project_back_button() -> String {
    return localizedString(
      key: "project.back_button",
      defaultValue: "Back this project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’re a backer!"
  ///
  /// - **en**: "You’re a backer!"
  /// - **de**: "Du gehörst jetzt zu den Unterstützern!"
  /// - **es**: "¡Eres un patrocinador!"
  /// - **fr**: "Vous êtes contributeur !"
  /// - **ja**: "バッカーになりました！"
  public static func project_backer_title() -> String {
    return localizedString(
      key: "project.backer_title",
      defaultValue: "You’re a backer!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Leave a comment"
  ///
  /// - **en**: "Leave a comment"
  /// - **de**: "Kommentar hinterlassen"
  /// - **es**: "Deja un comentario"
  /// - **fr**: "Laisser un commentaire"
  /// - **ja**: "コメントする"
  public static func project_comments_empty_state_backer_button() -> String {
    return localizedString(
      key: "project.comments.empty_state.backer.button",
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
  /// - **ja**: "コメント無し"
  public static func project_comments_empty_state_backer_title() -> String {
    return localizedString(
      key: "project.comments.empty_state.backer.title",
      defaultValue: "No comments",
      count: nil,
      substitutions: [:]
    )
  }
}
