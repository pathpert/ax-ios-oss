// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "Successfully raised <b>%{pledged}</b> with <b>%{backers}</b> on %{deadline}"
  ///
  /// - **en**: "Successfully raised <b>%{pledged}</b> with <b>%{backers}</b> on %{deadline}"
  /// - **de**: "Wurde erfoglreich abgeschlossen: <b>%{pledged}</b> erreicht am %{deadline} dank <b>%{backers}</b>"
  /// - **es**: "Financiamiento exitoso: Se recaudaron <b>%{pledged}</b> gracias a <b>%{backers}</b> el %{deadline}"
  /// - **fr**: "Financement de <b>%{pledged}</b> réussi le %{deadline} grâce à <b>%{backers}</b>"
  /// - **ja**: "%{deadline} までに<b>%{backers}</b>から<b>%{pledged}</b>のプレッジ達成"
  public static func dashboard_activity_successfully_raised_pledged(pledged: String, backers: String, deadline: String) -> String {
    return localizedString(
      key: "dashboard.activity.successfully_raised_pledged",
      defaultValue: "Successfully raised <b>%{pledged}</b> with <b>%{backers}</b> on %{deadline}",
      count: nil,
      substitutions: ["pledged": pledged, "backers": backers, "deadline": deadline]
    )
  }
  /// "<b>%{user_name}</b> adjusted their pledge"
  ///
  /// - **en**: "<b>%{user_name}</b> adjusted their pledge"
  /// - **de**: "Der Finanzierungsbeitrag von <b>%{user_name}</b> wurde geändert"
  /// - **es**: "<b>%{user_name}</b> ajustó su contribución"
  /// - **fr**: "<b>%{user_name}</b> a ajusté son engagement"
  /// - **ja**: "<b>%{user_name}</b> はプレッジの調整をしました"
  public static func dashboard_activity_user_name_adjusted_their_pledge(user_name: String) -> String {
    return localizedString(
      key: "dashboard.activity.user_name_adjusted_their_pledge",
      defaultValue: "<b>%{user_name}</b> adjusted their pledge",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "<b>%{user_name}</b> canceled their pledge"
  ///
  /// - **en**: "<b>%{user_name}</b> canceled their pledge"
  /// - **de**: "Der Finanzierungsbeitrag von <b>%{user_name}</b> wurde zurückgezogen"
  /// - **es**: "<b>%{user_name}</b> canceló su contribución"
  /// - **fr**: "<b>%{user_name}</b> a annulé son engagement"
  /// - **ja**: "<b>%{user_name}</b> はプレッジのキャンセルをしました"
  public static func dashboard_activity_user_name_canceled_their_pledge(user_name: String) -> String {
    return localizedString(
      key: "dashboard.activity.user_name_canceled_their_pledge",
      defaultValue: "<b>%{user_name}</b> canceled their pledge",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "<b>%{user_name}</b> changed their reward"
  ///
  /// - **en**: "<b>%{user_name}</b> changed their reward"
  /// - **de**: "Die Belohnung von <b>%{user_name}</b> wurde geändert"
  /// - **es**: "<b>%{user_name}</b> cambió su recompensa"
  /// - **fr**: "<b>%{user_name}</b> a changé de récompense"
  /// - **ja**: "<b>%{user_name}</b> はプレッジの変更をしました"
  public static func dashboard_activity_user_name_changed_their_reward(user_name: String) -> String {
    return localizedString(
      key: "dashboard.activity.user_name_changed_their_reward",
      defaultValue: "<b>%{user_name}</b> changed their reward",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "<b>%{user_name}</b> commented on <b>Update%{space}#%{update_number}</b>"
  ///
  /// - **en**: "<b>%{user_name}</b> commented on <b>Update%{space}#%{update_number}</b>"
  /// - **de**: "<b>%{user_name}</b> hat Update %{update_number} kommentiert"
  /// - **es**: "<b>%{user_name}</b> hizo un comentario sobre la actualización n° %{update_number}"
  /// - **fr**: "<b>%{user_name}</b> a commenté l'Actu no. %{update_number}"
  /// - **ja**: "<b>%{user_name}</b>が<b>アップデート%{space}#%{update_number}</b>にコメントしました"
  public static func dashboard_activity_user_name_commented_on_update_number(user_name: String, space: String, update_number: String) -> String {
    return localizedString(
      key: "dashboard.activity.user_name_commented_on_update_number",
      defaultValue: "<b>%{user_name}</b> commented on <b>Update%{space}#%{update_number}</b>",
      count: nil,
      substitutions: ["user_name": user_name, "space": space, "update_number": update_number]
    )
  }
  /// "<b>%{user_name}</b> commented on your project"
  ///
  /// - **en**: "<b>%{user_name}</b> commented on your project"
  /// - **de**: "<b>%{user_name}</b> hat dein Projekt kommentiert"
  /// - **es**: "<b>%{user_name}</b> hizo un comentario sobre tu proyecto"
  /// - **fr**: "<b>%{user_name}</b> a commenté votre projet"
  /// - **ja**: "<b>%{user_name}</b> があなたのプロジェクトにコメントしました"
  public static func dashboard_activity_user_name_commented_on_your_project(user_name: String) -> String {
    return localizedString(
      key: "dashboard.activity.user_name_commented_on_your_project",
      defaultValue: "<b>%{user_name}</b> commented on your project",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "<b>%{user_name}</b> pledged"
  ///
  /// - **en**: "<b>%{user_name}</b> pledged"
  /// - **de**: "<b>%{user_name}</b> hat einen Finanzierungsbeitrag geleistet"
  /// - **es**: "<b>%{user_name}</b> hizo una contribución"
  /// - **fr**: "<b>%{user_name}</b> s'est engagé(e)"
  /// - **ja**: "<b>%{user_name}</b> がプレッジしました"
  public static func dashboard_activity_user_name_pledged(user_name: String) -> String {
    return localizedString(
      key: "dashboard.activity.user_name_pledged",
      defaultValue: "<b>%{user_name}</b> pledged",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "<b>You</b> adjusted your pledge"
  ///
  /// - **en**: "<b>You</b> adjusted your pledge"
  /// - **de**: "<b>Du</b> hast deinen Finanzierungsbeitrag geändert"
  /// - **es**: "<b>Has</b> cambiado tu contribución"
  /// - **fr**: "<b>Vous</b> avez ajusté votre engagement"
  /// - **ja**: "<b>あなたは</b>プレッジの調整をしました"
  public static func dashboard_activity_you_adjusted_your_pledge() -> String {
    return localizedString(
      key: "dashboard.activity.you_adjusted_your_pledge",
      defaultValue: "<b>You</b> adjusted your pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>You</b> canceled your pledge"
  ///
  /// - **en**: "<b>You</b> canceled your pledge"
  /// - **de**: "<b>Du</b> hast deinen Finanzierungsbeitrag zurückgezogen"
  /// - **es**: "<b>Has</b> cancelado tu contribución"
  /// - **fr**: "<b>Vous</b> avez annulé votre engagement"
  /// - **ja**: "<b>あなたは</b>プレッジのキャンセルをしました"
  public static func dashboard_activity_you_canceled_your_pledge() -> String {
    return localizedString(
      key: "dashboard.activity.you_canceled_your_pledge",
      defaultValue: "<b>You</b> canceled your pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>You</b> changed your reward"
  ///
  /// - **en**: "<b>You</b> changed your reward"
  /// - **de**: "<b>Du</b> hast deine Belohnung geändert"
  /// - **es**: "<b>Has</b> cambiado tu recompensa"
  /// - **fr**: "<b>Vous</b> avez changé de récompense"
  /// - **ja**: "<b>リワード</b>の変更をしました"
  public static func dashboard_activity_you_changed_your_reward() -> String {
    return localizedString(
      key: "dashboard.activity.you_changed_your_reward",
      defaultValue: "<b>You</b> changed your reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>You</b> commented on <b>Update%{space}#%{update_number}</b>"
  ///
  /// - **en**: "<b>You</b> commented on <b>Update%{space}#%{update_number}</b>"
  /// - **de**: "<b>Du</b> hast Update %{update_number} kommentiert"
  /// - **es**: "<b>Has</b> hecho un comentario sobre la actualización n° %{update_number}"
  /// - **fr**: "<b>Vous</b> avez commenté l'Actu no. %{update_number}"
  /// - **ja**: "<b>アップデート%{space}#%{update_number}</b>にコメント済"
  public static func dashboard_activity_you_commented_on_update_number(space: String, update_number: String) -> String {
    return localizedString(
      key: "dashboard.activity.you_commented_on_update_number",
      defaultValue: "<b>You</b> commented on <b>Update%{space}#%{update_number}</b>",
      count: nil,
      substitutions: ["space": space, "update_number": update_number]
    )
  }
  /// "<b>You</b> commented on your project"
  ///
  /// - **en**: "<b>You</b> commented on your project"
  /// - **de**: "<b>Du</b> hast dein Projekt kommentiert"
  /// - **es**: "<b>Has</b> hecho un comentario sobre tu proyecto"
  /// - **fr**: "<b>Vous</b> avez commenté votre projet"
  /// - **ja**: "<b>あなた</b> が自身のプロジェクトにコメントしました"
  public static func dashboard_activity_you_commented_on_your_project() -> String {
    return localizedString(
      key: "dashboard.activity.you_commented_on_your_project",
      defaultValue: "<b>You</b> commented on your project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>You</b> pledged"
  ///
  /// - **en**: "<b>You</b> pledged"
  /// - **de**: "<b>Du</b> hast einen Finanzierungsbeitrag geleistet"
  /// - **es**: "<b>Has</b> hecho una contribución"
  /// - **fr**: "<b>Vous</b> vous êtes engagé(e)"
  /// - **ja**: "<b>あなたが</b>プレッジしました"
  public static func dashboard_activity_you_pledged() -> String {
    return localizedString(
      key: "dashboard.activity.you_pledged",
      defaultValue: "<b>You</b> pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Activity"
  ///
  /// - **en**: "Activity"
  /// - **de**: "Aktivität"
  /// - **es**: "Actividad"
  /// - **fr**: "Activité"
  /// - **ja**: "アクティビティ"
  public static func dashboard_buttons_activity() -> String {
    return localizedString(
      key: "dashboard.buttons.activity",
      defaultValue: "Activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Messages"
  ///
  /// - **en**: "Messages"
  /// - **de**: "Nachrichten"
  /// - **es**: "Mensajes"
  /// - **fr**: "Messages"
  /// - **ja**: "メッセージ"
  public static func dashboard_buttons_messages() -> String {
    return localizedString(
      key: "dashboard.buttons.messages",
      defaultValue: "Messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Post update"
  ///
  /// - **en**: "Post update"
  /// - **de**: "Update posten"
  /// - **es**: "Publicar actualización"
  /// - **fr**: "Publier une actu"
  /// - **ja**: "アップデートを投稿"
  public static func dashboard_buttons_post_update() -> String {
    return localizedString(
      key: "dashboard.buttons.post_update",
      defaultValue: "Post update",
      count: nil,
      substitutions: [:]
    )
  }
}
