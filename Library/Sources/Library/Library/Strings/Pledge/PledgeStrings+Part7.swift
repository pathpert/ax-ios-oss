// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Pledge"
  ///
  /// - **en**: "Pledge"
  /// - **de**: "Finanzierungsbeitrag"
  /// - **es**: "Contribución"
  /// - **fr**: "Contribution"
  /// - **ja**: "プレッジ"
  public static func Pledge_label() -> String {
    return localizedString(
      key: "Pledge_label",
      defaultValue: "Pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge management"
  ///
  /// - **en**: "Pledge management"
  /// - **de**: "Beitragsverwaltung"
  /// - **es**: "Gestión de contribución"
  /// - **fr**: "Gestion des engagements"
  /// - **ja**: "プレッジ管理"
  public static func Pledge_management() -> String {
    return localizedString(
      key: "Pledge_management",
      defaultValue: "Pledge management",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge Manager"
  ///
  /// - **en**: "Pledge Manager"
  /// - **de**: "Beitragsverwaltung"
  /// - **es**: "Gestor de contribuciones"
  /// - **fr**: "Gestionnaire d'engagements"
  /// - **ja**: "プレッジマネージャー"
  public static func Pledge_manager() -> String {
    return localizedString(
      key: "Pledge_manager",
      defaultValue: "Pledge Manager",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge to projects and view all your saved and backed projects in one place."
  ///
  /// - **en**: "Pledge to projects and view all your saved and backed projects in one place."
  /// - **de**: "Unterstütze Projekte und sehe alle deine Projekte auf einen Blick."
  /// - **es**: "Haz contribuciones a proyectos y revisa todos tus proyectos guardados y patrocinados - todo en un mismo lugar."
  /// - **fr**: "Soutenez des projets et consultez la liste de vos projets enregistrés et soutenus."
  /// - **ja**: "プロジェクトを探す、プロジェクトにプレッジする、プロジェクトを保存する、全て一つの場所で。"
  public static func Pledge_to_projects_and_view_all_your_saved_and_backed_projects_in_one_place() -> String {
    return localizedString(
      key: "Pledge_to_projects_and_view_all_your_saved_and_backed_projects_in_one_place",
      defaultValue: "Pledge to projects and view all your saved and backed projects in one place.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge to your favorites, then view all the projects you’ve backed here."
  ///
  /// - **en**: "Pledge to your favorites, then view all the projects you’ve backed here."
  /// - **de**: "Unterstütze deine Favoriten - alle von dir unterstützten Projekte werden hier angezeigt."
  /// - **es**: "Patrocina tus favoritos y ve todos tus proyectos en un solo lugar."
  /// - **fr**: "Engagez-vous à soutenir vos préférés, puis redécouvrez-les tous ici."
  /// - **ja**: "ここにバックした全プロジェクトが表示されます。"
  public static func Pledge_to_your_favorites_then_view_all_the_projects() -> String {
    return localizedString(
      key: "Pledge_to_your_favorites_then_view_all_the_projects",
      defaultValue: "Pledge to your favorites, then view all the projects you’ve backed here.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge was dropped."
  ///
  /// - **en**: "Pledge was dropped."
  /// - **de**: "Finanzierungsbeitrag wurde nicht übernommen."
  /// - **es**: "Contribución fue descartada."
  /// - **fr**: "Engagement abandonné."
  /// - **ja**: "プレッジは取り消されました"
  public static func Pledge_was_dropped() -> String {
    return localizedString(
      key: "Pledge_was_dropped",
      defaultValue: "Pledge was dropped.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge without a reward"
  ///
  /// - **en**: "Pledge without a reward"
  /// - **de**: "Ohne Belohnung unterstützen"
  /// - **es**: "Contribuir sin recompensa"
  /// - **fr**: "Engagement sans récompense"
  /// - **ja**: "リワードなしでプレッジ"
  public static func Pledge_without_a_reward() -> String {
    return localizedString(
      key: "Pledge_without_a_reward",
      defaultValue: "Pledge without a reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>Pledged</b> on %{pledge_date}"
  ///
  /// - **en**: "<b>Pledged</b> on %{pledge_date}"
  /// - **de**: "<b>Beitrag geleistet</b> am %{pledge_date}"
  /// - **es**: "<b>Contribuido</b> el %{pledge_date}"
  /// - **fr**: "<b>Engagement</b> du %{pledge_date}"
  /// - **ja**: "%{pledge_date} に<b>プレッジ</b>"
  public static func Pledged_on_date(pledge_date: String) -> String {
    return localizedString(
      key: "Pledged_on_date",
      defaultValue: "<b>Pledged</b> on %{pledge_date}",
      count: nil,
      substitutions: ["pledge_date": pledge_date]
    )
  }
  /// "Project goal and pledge amounts will be shown in approximate conversions. A successfully funded project will collect your pledge in its native currency."
  ///
  /// - **en**: "Project goal and pledge amounts will be shown in approximate conversions. A successfully funded project will collect your pledge in its native currency."
  /// - **de**: "Es wird eine ungefähre Umrechnung des Finanzierungsziels und der Finanzierungsbeiträge angezeigt. Nach erfolgreicher Finanzierung des Projekts wird dein Finanzierungsbeitrag in der Währung des Erstellungslandes abgebucht."
  /// - **es**: "La meta del proyecto y los montos de contribución se mostrarán en conversiones aproximadas. Un proyecto financiado con éxito cobrará tu contribución en su moneda nativa."
  /// - **fr**: "La valeur de l'objectif de financement et des montants engagés sera convertie (approximativement). Si le projet est intégralement financé, votre engagement vous sera débité dans la devise d'origine du projet."
  /// - **ja**: "プロジェクトのゴール額とプレッジ額はおおよその換算金額で表示されます。プロジェクトが成功した場合、プレッジはプロジェクトをローンチした国の通貨で集められます。"
  public static func Project_goal_and_pledge() -> String {
    return localizedString(
      key: "Project_goal_and_pledge",
      defaultValue: "Project goal and pledge amounts will be shown in approximate conversions. A successfully funded project will collect your pledge in its native currency.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Late pledge"
  ///
  /// - **en**: "Late pledge"
  /// - **de**: "Nachträglicher Beitrag"
  /// - **es**: "Contribución tardía"
  /// - **fr**: "Contribution tardive"
  /// - **ja**: "遅延プレッジ"
  public static func Project_status_late_pledge() -> String {
    return localizedString(
      key: "Project_status_late_pledge",
      defaultValue: "Late pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Remember this card"
  ///
  /// - **en**: "Remember this card"
  /// - **de**: "Karte speichern"
  /// - **es**: "Guarda esta tarjeta"
  /// - **fr**: "Enregistrer cette carte"
  /// - **ja**: "このカードを保存する"
  public static func Remember_this_card() -> String {
    return localizedString(
      key: "Remember_this_card",
      defaultValue: "Remember this card",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Remove this card"
  ///
  /// - **en**: "Remove this card"
  /// - **de**: "Karte entfernen"
  /// - **es**: "Eliminar esta tarjeta"
  /// - **fr**: "Supprimer cette carte"
  /// - **ja**: "このカードを削除"
  public static func Remove_this_card() -> String {
    return localizedString(
      key: "Remove_this_card",
      defaultValue: "Remove this card",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{reward_survey_count} Reward Surveys"
  ///
  /// - **en**: "%{reward_survey_count} Reward Surveys"
  /// - **de**: "%{reward_survey_count} Befragungen"
  /// - **es**: "%{reward_survey_count} cuestionarios"
  /// - **fr**: "%{reward_survey_count} questionnaires"
  /// - **ja**: "%{reward_survey_count} リワードのサーベイ"
  public static func Reward_Surveys(reward_survey_count: Int) -> String {
    return localizedString(
      key: "Reward_Surveys",
      defaultValue: "%{reward_survey_count} Reward Surveys",
      count: reward_survey_count,
      substitutions: ["reward_survey_count": Format.wholeNumber(reward_survey_count)]
    )
  }
  /// "%{reward_survey_count} Reward Surveys"
  ///
  /// - **en**: "%{reward_survey_count} Reward Surveys"
  /// - **de**: "%{reward_survey_count} Befragungen"
  /// - **es**: "%{reward_survey_count} cuestionarios"
  /// - **fr**: "%{reward_survey_count} questionnaires"
  /// - **ja**: "%{reward_survey_count} リワードのサーベイ"
  public static func Reward_Surveys_other(reward_survey_count: String) -> String {
    return localizedString(
      key: "Reward_Surveys.other",
      defaultValue: "%{reward_survey_count} Reward Surveys",
      count: nil,
      substitutions: ["reward_survey_count": reward_survey_count]
    )
  }
  /// "Reward delivered?"
  ///
  /// - **en**: "Reward delivered?"
  /// - **de**: "Belohnung versandt?"
  /// - **es**: "¿Recompensa entregada?"
  /// - **fr**: "Récompense livrée ?"
  /// - **ja**: "リワードを受け取りましたか？"
  public static func Reward_delivered() -> String {
    return localizedString(
      key: "Reward_delivered",
      defaultValue: "Reward delivered?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>Reward</b> estimated for delivery in %{delivery_date}"
  ///
  /// - **en**: "<b>Reward</b> estimated for delivery in %{delivery_date}"
  /// - **de**: "Voraussichtliche Lieferung der <b>Belohnung</b> im %{delivery_date}"
  /// - **es**: "<b>Recompensa</b> estimada para entregarse en %{delivery_date}"
  /// - **fr**: "<b>Récompense</b> prévue pour %{delivery_date}"
  /// - **ja**: "<b>リワード</b>の配達予定日は%{delivery_date}"
  public static func Reward_estimated_for_delivery_in_date(delivery_date: String) -> String {
    return localizedString(
      key: "Reward_estimated_for_delivery_in_date",
      defaultValue: "<b>Reward</b> estimated for delivery in %{delivery_date}",
      count: nil,
      substitutions: ["delivery_date": delivery_date]
    )
  }
}
