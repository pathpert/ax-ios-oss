// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "Funding canceled."
  ///
  /// - **en**: "Funding canceled."
  /// - **de**: "Finanzierung abgebrochen."
  /// - **es**: "Financiamiento cancelado."
  /// - **fr**: "Financement annulé."
  /// - **ja**: "募集キャンセル"
  public static func activity_funding_canceled() -> String {
    return localizedString(
      key: "activity.funding_canceled",
      defaultValue: "Funding canceled.",
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
  public static func activity_navigation_title_activity() -> String {
    return localizedString(
      key: "activity.navigation.title.activity",
      defaultValue: "Activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Posted update #%{update_number}: %{update_title}"
  ///
  /// - **en**: "Posted update #%{update_number}: %{update_title}"
  /// - **de**: "Update Nr. %{update_number}: %{update_title}"
  /// - **es**: "Publicó actualización n° %{update_number}: %{update_title}"
  /// - **fr**: "Actu no. %{update_number} publiée : %{update_title}"
  /// - **ja**: "アップデート投稿済＃%{update_number}：%{update_title}"
  public static func activity_posted_update_number_title(update_number: String, update_title: String) -> String {
    return localizedString(
      key: "activity.posted_update_number_title",
      defaultValue: "Posted update #%{update_number}: %{update_title}",
      count: nil,
      substitutions: ["update_number": update_number, "update_title": update_title]
    )
  }
  /// "%{project_name} by %{creator_name}"
  ///
  /// - **en**: "%{project_name} by %{creator_name}"
  /// - **de**: "%{project_name} von %{creator_name}"
  /// - **es**: "%{project_name} por %{creator_name}"
  /// - **fr**: "%{project_name} par %{creator_name}"
  /// - **ja**: "%{project_name} by %{creator_name}"
  public static func activity_project_name_by_creator_name(project_name: String, creator_name: String) -> String {
    return localizedString(
      key: "activity.project_name_by_creator_name",
      defaultValue: "%{project_name} by %{creator_name}",
      count: nil,
      substitutions: ["project_name": project_name, "creator_name": creator_name]
    )
  }
  /// "%{creator_name} launched a project: %{project_name}"
  ///
  /// - **en**: "%{creator_name} launched a project: %{project_name}"
  /// - **de**: "%{creator_name} hat ein Projekt live gestellt: %{project_name}"
  /// - **es**: "%{creator_name} ha publicado el proyecto: %{project_name}"
  /// - **fr**: "%{creator_name} a lancé un projet : %{project_name}"
  /// - **ja**: "%{creator_name} さんは%{project_name} を発表しました"
  public static func activity_project_state_change_creator_launched_a_project(creator_name: String, project_name: String) -> String {
    return localizedString(
      key: "activity.project_state_change.creator_launched_a_project",
      defaultValue: "%{creator_name} launched a project: %{project_name}",
      count: nil,
      substitutions: ["creator_name": creator_name, "project_name": project_name]
    )
  }
  /// "Funded"
  ///
  /// - **en**: "Funded"
  /// - **de**: "Finanziert"
  /// - **es**: "Financiado"
  /// - **fr**: "Financé"
  /// - **ja**: "達成"
  public static func activity_project_state_change_funded() -> String {
    return localizedString(
      key: "activity.project_state_change.funded",
      defaultValue: "Funded",
      count: nil,
      substitutions: [:]
    )
  }
  /// "goal"
  ///
  /// - **en**: "goal"
  /// - **de**: "Ziel"
  /// - **es**: "meta"
  /// - **fr**: "objectif"
  /// - **ja**: "目標金額"
  public static func activity_project_state_change_goal() -> String {
    return localizedString(
      key: "activity.project_state_change.goal",
      defaultValue: "goal",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Launched"
  ///
  /// - **en**: "Launched"
  /// - **de**: "Live"
  /// - **es**: "Publicado"
  /// - **fr**: "Lancé"
  /// - **ja**: "発表済み"
  public static func activity_project_state_change_launched() -> String {
    return localizedString(
      key: "activity.project_state_change.launched",
      defaultValue: "Launched",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{project_name} was cancelled by the creator."
  ///
  /// - **en**: "%{project_name} was cancelled by the creator."
  /// - **de**: "%{project_name} wurde vom Projektgründer abgebrochen."
  /// - **es**: "%{project_name} ha sido cancelado por su creador."
  /// - **fr**: "%{project_name} a été annulé par son créateur."
  /// - **ja**: "%{project_name} はクリエーターによりキャンセルされました。"
  public static func activity_project_state_change_project_was_cancelled_by_creator(project_name: String) -> String {
    return localizedString(
      key: "activity.project_state_change.project_was_cancelled_by_creator",
      defaultValue: "%{project_name} was cancelled by the creator.",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "%{project_name} was not successfully funded."
  ///
  /// - **en**: "%{project_name} was not successfully funded."
  /// - **de**: "%{project_name} wurde nicht erfolgreich finanziert."
  /// - **es**: "%{project_name} no ha sido financiado exitosamente."
  /// - **fr**: "%{project_name} n'a pas été intégralement financé."
  /// - **ja**: "%{project_name} はファンドを達成できませんでした。"
  public static func activity_project_state_change_project_was_not_successfully_funded(project_name: String) -> String {
    return localizedString(
      key: "activity.project_state_change.project_was_not_successfully_funded",
      defaultValue: "%{project_name} was not successfully funded.",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "%{project_name} was successfully funded!"
  ///
  /// - **en**: "%{project_name} was successfully funded!"
  /// - **de**: "%{project_name} wurde erfolgreich finanziert!"
  /// - **es**: "¡%{project_name} fue financiado con éxito!"
  /// - **fr**: "%{project_name} a été intégralement financé !"
  /// - **ja**: "%{project_name} はファンドを達成しました"
  public static func activity_project_state_change_project_was_successfully_funded(project_name: String) -> String {
    return localizedString(
      key: "activity.project_state_change.project_was_successfully_funded",
      defaultValue: "%{project_name} was successfully funded!",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "%{project_name} was suspended."
  ///
  /// - **en**: "%{project_name} was suspended."
  /// - **de**: "%{project_name} wurde ausgesetzt."
  /// - **es**: "%{project_name} ha sido suspendido."
  /// - **fr**: "%{project_name} a été suspendu."
  /// - **ja**: "%{project_name} は停止されました。"
  public static func activity_project_state_change_project_was_suspended(project_name: String) -> String {
    return localizedString(
      key: "activity.project_state_change.project_was_suspended",
      defaultValue: "%{project_name} was suspended.",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "You launched a project: %{project_name}"
  ///
  /// - **en**: "You launched a project: %{project_name}"
  /// - **de**: "Du hast ein Projekt live gestellt: %{project_name}"
  /// - **es**: "Has publicado el proyecto: %{project_name}"
  /// - **fr**: "Vous avez lancé un projet : %{project_name}"
  /// - **ja**: "あなたは%{project_name} を発表しました"
  public static func activity_project_state_change_you_launched_a_project(project_name: String) -> String {
    return localizedString(
      key: "activity.project_state_change.you_launched_a_project",
      defaultValue: "You launched a project: %{project_name}",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "Update #%{update_count}"
  ///
  /// - **en**: "Update #%{update_count}"
  /// - **de**: "Update Nr. %{update_count}"
  /// - **es**: "Actualización n° %{update_count}"
  /// - **fr**: "Actu no. %{update_count}"
  /// - **ja**: "アップデート #%{update_count}"
  public static func activity_project_update_update_count(update_count: String) -> String {
    return localizedString(
      key: "activity.project_update.update_count",
      defaultValue: "Update #%{update_count}",
      count: nil,
      substitutions: ["update_count": update_count]
    )
  }
  /// "#%{update_count} – Backer only"
  ///
  /// - **en**: "#%{update_count} – Backer only"
  /// - **de**: "Nr. %{update_count} – Nur für Unterstützer"
  /// - **es**: "#%{update_count} – Únicamente para patrocinadores"
  /// - **fr**: "No. %{update_count} – Contributeurs seulement"
  /// - **ja**: "#%{update_count} - バッカーのみ"
  public static func activity_project_update_update_count_backer_only(update_count: String) -> String {
    return localizedString(
      key: "activity.project_update.update_count_backer_only",
      defaultValue: "#%{update_count} – Backer only",
      count: nil,
      substitutions: ["update_count": update_count]
    )
  }
  /// "Was not successfully funded."
  ///
  /// - **en**: "Was not successfully funded."
  /// - **de**: "Wurde nicht erfolgreich finanziert."
  /// - **es**: "No se financió con éxito."
  /// - **fr**: "Non financé."
  /// - **ja**: "ファンディング失敗"
  public static func activity_project_was_not_successfully_funded() -> String {
    return localizedString(
      key: "activity.project_was_not_successfully_funded",
      defaultValue: "Was not successfully funded.",
      count: nil,
      substitutions: [:]
    )
  }
}
