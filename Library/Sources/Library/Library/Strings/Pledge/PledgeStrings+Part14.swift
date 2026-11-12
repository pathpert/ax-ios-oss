// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "You’ve pledged to support this project and it’s currently still funding."
  ///
  /// - **en**: "You’ve pledged to support this project and it’s currently still funding."
  /// - **de**: "Du hast einen Finazierungsbeitrag zu diesem Projekt geleistet. Die Frist für die Finanzierung ist noch nicht abgelaufen."
  /// - **es**: "Hiciste una contribución a este proyecto. El plazo de financiamiento todavía no ha terminado."
  /// - **fr**: "Vous vous êtes engagé à soutenir ce projet et sa campagne de financement n'est pas terminée."
  /// - **ja**: "このプレッジ済のプロジェクトは、現在もファンド中"
  public static func Youve_pledged_to_support_this_project() -> String {
    return localizedString(
      key: "Youve_pledged_to_support_this_project",
      defaultValue: "You’ve pledged to support this project and it’s currently still funding.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’ve successfully updated your pledge to %{amount} for %{project_name}. If the project reaches its funding goal, your card will be charged on %{project_deadline}. Check your email for details."
  ///
  /// - **en**: "You’ve successfully updated your pledge to %{amount} for %{project_name}. If the project reaches its funding goal, your card will be charged on %{project_deadline}. Check your email for details."
  /// - **de**: "Dein Finanzierungsbeitrag für or %{project_name} wurde erfolgreich auf %{amount} geändert. Wenn das Projekt sein Finanzierungsziel erreicht, wird deine Karte am %{project_deadline} belastet. Wir haben dir eine E-Mail mit genaueren Angaben gesendet."
  /// - **es**: "Has actualizado con éxito tu contribución a %{amount} para %{project_name}. Si el proyecto alcanza su meta de financiamiento, se efectuará un cargo en tu tarjeta el %{project_deadline}. Consulta tu correo electrónico para obtener más detalles."
  /// - **fr**: "Votre engagement de %{amount} en soutien du projet %{project_name} a bien été mis à jour. Si le créateur atteint son objectif de financement, votre carte sera débitée le %{project_deadline}. Veuillez consulter votre messagerie pour plus d'informations."
  /// - **ja**: "%{project_name} へのプレッジを %{amount} に更新しました。プロジェクトがファンディングゴールに達成した場合には、%{project_deadline} 付けでご登録いただいたクレジットカードに請求されます。"
  public static func Youve_successfully_updated_your_pledge_to_amount_for_project_name(amount: String, project_name: String, project_deadline: String) -> String {
    return localizedString(
      key: "Youve_successfully_updated_your_pledge_to_amount_for_project_name",
      defaultValue: "You’ve successfully updated your pledge to %{amount} for %{project_name}. If the project reaches its funding goal, your card will be charged on %{project_deadline}. Check your email for details.",
      count: nil,
      substitutions: ["amount": amount, "project_name": project_name, "project_deadline": project_deadline]
    )
  }
  /// "%{user_name} adjusted their pledge:"
  ///
  /// - **en**: "%{user_name} adjusted their pledge:"
  /// - **de**: "Beitrag von %{user_name} wurde geändert:"
  /// - **es**: "%{user_name} ajustó su contribución:"
  /// - **fr**: "%{user_name} a ajusté son engagement"
  /// - **ja**: "%{user_name} はプレッジを変更済："
  public static func activity_creator_actions_user_name_adjusted_their_pledge(user_name: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_adjusted_their_pledge",
      defaultValue: "%{user_name} adjusted their pledge:",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "%{user_name} canceled their pledge:"
  ///
  /// - **en**: "%{user_name} canceled their pledge:"
  /// - **de**: "Beitrag von %{user_name} wurde storniert:"
  /// - **es**: "%{user_name} canceló su contribución:"
  /// - **fr**: "%{user_name} a annulé son engagement"
  /// - **ja**: "%{user_name} がプレッジをキャンセル："
  public static func activity_creator_actions_user_name_canceled_their_pledge(user_name: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_canceled_their_pledge",
      defaultValue: "%{user_name} canceled their pledge:",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "%{user_name} changed their reward:"
  ///
  /// - **en**: "%{user_name} changed their reward:"
  /// - **de**: "Belohnung von %{user_name} wurde geändert:"
  /// - **es**: "%{user_name} cambió su recompensa:"
  /// - **fr**: "%{user_name} a changé de récompense"
  /// - **ja**: "%{user_name} がプレッジの変更をしました："
  public static func activity_creator_actions_user_name_changed_their_reward(user_name: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_changed_their_reward",
      defaultValue: "%{user_name} changed their reward:",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "%{user_name} pledged:"
  ///
  /// - **en**: "%{user_name} pledged:"
  /// - **de**: "Beitrag von %{user_name}:"
  /// - **es**: "%{user_name} contribuyó:"
  /// - **fr**: "L'engagement de %{user_name} :"
  /// - **ja**: "%{user_name} のプレッジ："
  public static func activity_creator_actions_user_name_pledged(user_name: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_pledged",
      defaultValue: "%{user_name} pledged:",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "You adjusted your pledge:"
  ///
  /// - **en**: "You adjusted your pledge:"
  /// - **de**: "Du hast folgenden Beitrag angepasst:"
  /// - **es**: "Has cambiado la siguiente contribución:"
  /// - **fr**: "Vous avez ajusté votre engagement :"
  /// - **ja**: "プレッジを変更しました："
  public static func activity_creator_actions_you_adjusted_your_pledge() -> String {
    return localizedString(
      key: "activity.creator.actions.you_adjusted_your_pledge",
      defaultValue: "You adjusted your pledge:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You canceled your pledge:"
  ///
  /// - **en**: "You canceled your pledge:"
  /// - **de**: "Du hast folgenden Beitrag zurückgezogen:"
  /// - **es**: "Has cancelado la siguiente contribución:"
  /// - **fr**: "Vous avez annulé votre engagement :"
  /// - **ja**: "プレッジをキャンセルしました："
  public static func activity_creator_actions_you_canceled_your_pledge() -> String {
    return localizedString(
      key: "activity.creator.actions.you_canceled_your_pledge",
      defaultValue: "You canceled your pledge:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You changed your reward:"
  ///
  /// - **en**: "You changed your reward:"
  /// - **de**: "Du hast folgende Belohnung geändert:"
  /// - **es**: "Has cambiado la siguiente recompensa:"
  /// - **fr**: "Vous avez changé de récompense :"
  /// - **ja**: "リワードを変更："
  public static func activity_creator_actions_you_changed_your_reward() -> String {
    return localizedString(
      key: "activity.creator.actions.you_changed_your_reward",
      defaultValue: "You changed your reward:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You pledged:"
  ///
  /// - **en**: "You pledged:"
  /// - **de**: "Dein Beitrag:"
  /// - **es**: "Tu contribución:"
  /// - **fr**: "Votre engagement :"
  /// - **ja**: "プレッジ："
  public static func activity_creator_actions_you_pledged() -> String {
    return localizedString(
      key: "activity.creator.actions.you_pledged",
      defaultValue: "You pledged:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backing info"
  ///
  /// - **en**: "Backing info"
  /// - **de**: "Info zur Unterstützung"
  /// - **es**: "Info sobre contribución"
  /// - **fr**: "Infos sur la contribution"
  /// - **ja**: "バック（支援）情報"
  public static func activity_creator_buttons_backing_info() -> String {
    return localizedString(
      key: "activity.creator.buttons.backing_info",
      defaultValue: "Backing info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reward"
  ///
  /// - **en**: "Reward"
  /// - **de**: "Belohnung"
  /// - **es**: "Recompensa"
  /// - **fr**: "Récompense"
  /// - **ja**: "リワード"
  public static func activity_creator_reward() -> String {
    return localizedString(
      key: "activity.creator.reward",
      defaultValue: "Reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "pledged of %{goal}"
  ///
  /// - **en**: "pledged of %{goal}"
  /// - **de**: "von %{goal}"
  /// - **es**: "de %{goal}"
  /// - **fr**: "sur %{goal}"
  /// - **ja**: "の達成額 (%{goal} 中)"
  public static func activity_project_state_change_pledged_of_goal(goal: String) -> String {
    return localizedString(
      key: "activity.project_state_change.pledged_of_goal",
      defaultValue: "pledged of %{goal}",
      count: nil,
      substitutions: ["goal": goal]
    )
  }
  /// "%{pledge_amount} on %{pledge_date}"
  ///
  /// - **en**: "%{pledge_amount} on %{pledge_date}"
  /// - **de**: "%{pledge_amount} am %{pledge_date}"
  /// - **es**: "%{pledge_amount} el %{pledge_date}"
  /// - **fr**: "%{pledge_amount} le %{pledge_date}"
  /// - **ja**: "%{pledge_date} に%{pledge_amount}"
  public static func backer_modal_pledge_amount_on_pledge_date(pledge_amount: String, pledge_date: String) -> String {
    return localizedString(
      key: "backer_modal.pledge_amount_on_pledge_date",
      defaultValue: "%{pledge_amount} on %{pledge_date}",
      count: nil,
      substitutions: ["pledge_amount": pledge_amount, "pledge_date": pledge_date]
    )
  }
  /// "Pledged"
  ///
  /// - **en**: "Pledged"
  /// - **de**: "Beigetragen"
  /// - **es**: "Contribuido"
  /// - **fr**: "Engagement"
  /// - **ja**: "プレッジ"
  public static func backer_modal_pledged_title() -> String {
    return localizedString(
      key: "backer_modal.pledged_title",
      defaultValue: "Pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{reward_amount} - %{reward_description}"
  ///
  /// - **en**: "%{reward_amount} - %{reward_description}"
  /// - **de**: "%{reward_amount} - %{reward_description}"
  /// - **es**: "%{reward_amount} - %{reward_description}"
  /// - **fr**: "%{reward_amount} - %{reward_description}"
  /// - **ja**: "%{reward_amount} - %{reward_description}"
  public static func backer_modal_reward_amount_reward_description(reward_amount: String, reward_description: String) -> String {
    return localizedString(
      key: "backer_modal.reward_amount_reward_description",
      defaultValue: "%{reward_amount} - %{reward_description}",
      count: nil,
      substitutions: ["reward_amount": reward_amount, "reward_description": reward_description]
    )
  }
}
