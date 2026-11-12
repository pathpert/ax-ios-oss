// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "mins"
  ///
  /// - **en**: "mins"
  /// - **de**: "Min"
  /// - **es**: "mins"
  /// - **fr**: "min"
  /// - **ja**: "分"
  public static func discovery_baseball_card_deadline_units_mins() -> String {
    return localizedString(
      key: "discovery.baseball_card.deadline_units.mins",
      defaultValue: "mins",
      count: nil,
      substitutions: [:]
    )
  }
  /// "secs"
  ///
  /// - **en**: "secs"
  /// - **de**: "Sek"
  /// - **es**: "segs"
  /// - **fr**: "s"
  /// - **ja**: "秒"
  public static func discovery_baseball_card_deadline_units_secs() -> String {
    return localizedString(
      key: "discovery.baseball_card.deadline_units.secs",
      defaultValue: "secs",
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
  public static func discovery_baseball_card_metadata_backer() -> String {
    return localizedString(
      key: "discovery.baseball_card.metadata.backer",
      defaultValue: "You’re a backer!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Featured in %{category_name}"
  ///
  /// - **en**: "Featured in %{category_name}"
  /// - **de**: "Vorgestellt in %{category_name}"
  /// - **es**: "Presentado en %{category_name}"
  /// - **fr**: "Un projet %{category_name} sélectionné"
  /// - **ja**: "%{category_name} を強調する"
  public static func discovery_baseball_card_metadata_featured_project(category_name: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.metadata.featured_project",
      defaultValue: "Featured in %{category_name}",
      count: nil,
      substitutions: ["category_name": category_name]
    )
  }
  /// "Project of the Day!"
  ///
  /// - **en**: "Project of the Day!"
  /// - **de**: "Projekt des Tages!"
  /// - **es**: "¡Proyecto del día!"
  /// - **fr**: "Projet du jour !"
  /// - **ja**: "今日のプロジェクト"
  public static func discovery_baseball_card_metadata_potd() -> String {
    return localizedString(
      key: "discovery.baseball_card.metadata.potd",
      defaultValue: "Project of the Day!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Project of the Day"
  ///
  /// - **en**: "Project of the Day"
  /// - **de**: "Projekt des Tages"
  /// - **es**: "Proyecto del día"
  /// - **fr**: "Projet du jour "
  /// - **ja**: "今日のプロジェクト"
  public static func discovery_baseball_card_metadata_project_of_the_Day() -> String {
    return localizedString(
      key: "discovery.baseball_card.metadata.project_of_the_Day",
      defaultValue: "Project of the Day",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You starred this project."
  ///
  /// - **en**: "You starred this project."
  /// - **de**: "Gehört zu deinen Favoriten."
  /// - **es**: "Entre tus proyectos destacados."
  /// - **fr**: "Mes projets préférés !"
  /// - **ja**: "お気に入り済"
  public static func discovery_baseball_card_metadata_starred() -> String {
    return localizedString(
      key: "discovery.baseball_card.metadata.starred",
      defaultValue: "You starred this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Read%{space}more%{space}"
  ///
  /// - **en**: "Read%{space}more%{space}"
  /// - **de**: "Mehr%{space}Info%{space}"
  /// - **es**: "Leer%{space}más%{space}"
  /// - **fr**: "En savoir%{space}plus%{space}"
  /// - **ja**: "%{space}さらに%{space}読む"
  public static func discovery_baseball_card_read_more(space: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.read_more",
      defaultValue: "Read%{space}more%{space}",
      count: nil,
      substitutions: ["space": space]
    )
  }
  /// "%{friend_name}, %{second_friend_name}, and %{remaining_count} more are backers."
  ///
  /// - **en**: "%{friend_name}, %{second_friend_name}, and %{remaining_count} more are backers."
  /// - **de**: "%{friend_name}, %{second_friend_name}, und %{remaining_count} weitere unterstützen dieses Projekt."
  /// - **es**: "%{friend_name}, %{second_friend_name}, y %{remaining_count} más patrocinan este proyecto."
  /// - **fr**: "%{friend_name}, %{second_friend_name} et %{remaining_count} autres personnes sont contributeurs."
  /// - **ja**: "%{friend_name} 、%{second_friend_name} 、他%{remaining_count} 人がバッカー"
  public static func discovery_baseball_card_social_friends_are_backers(friend_name: String, second_friend_name: String, remaining_count: Int) -> String {
    return localizedString(
      key: "discovery.baseball_card.social.friends_are_backers",
      defaultValue: "%{friend_name}, %{second_friend_name}, and %{remaining_count} more are backers.",
      count: remaining_count,
      substitutions: ["friend_name": friend_name, "second_friend_name": second_friend_name, "remaining_count": Format.wholeNumber(remaining_count)]
    )
  }
  /// "%{friend_name}, %{second_friend_name}, and %{remaining_count} more are backers."
  ///
  /// - **en**: "%{friend_name}, %{second_friend_name}, and %{remaining_count} more are backers."
  /// - **de**: "%{friend_name}, %{second_friend_name}, und %{remaining_count} weitere unterstützen dieses Projekt."
  /// - **es**: "%{friend_name}, %{second_friend_name}, y %{remaining_count} más patrocinan este proyecto."
  /// - **fr**: "%{friend_name}, %{second_friend_name} et %{remaining_count} autres personnes sont contributeurs."
  /// - **ja**: "%{friend_name} 、%{second_friend_name} 、他%{remaining_count} 人がバッカー"
  public static func discovery_baseball_card_social_friends_are_backers_other(friend_name: String, second_friend_name: String, remaining_count: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.social.friends_are_backers.other",
      defaultValue: "%{friend_name}, %{second_friend_name}, and %{remaining_count} more are backers.",
      count: nil,
      substitutions: ["friend_name": friend_name, "second_friend_name": second_friend_name, "remaining_count": remaining_count]
    )
  }
  /// "backers"
  ///
  /// - **en**: "backers"
  /// - **de**: "Unterstützer"
  /// - **es**: "patrocinadores"
  /// - **fr**: "contributeurs"
  /// - **ja**: "バッカー"
  public static func discovery_baseball_card_stats_backers() -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.backers",
      defaultValue: "backers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Converted from %{pledged} pledged of %{goal} goal."
  ///
  /// - **en**: "Converted from %{pledged} pledged of %{goal} goal."
  /// - **de**: "Umgerechneter Betrag: %{pledged} von %{goal} (Finanzierungsziel)."
  /// - **es**: "Conversión: %{pledged} de la meta de %{goal}."
  /// - **fr**: "Conversion de %{pledged} engagés pour un objectif de %{goal}"
  /// - **ja**: "%{goal}のゴールに対し%{pledged}達成"
  public static func discovery_baseball_card_stats_convert_from_pledged_of_goal(pledged: String, goal: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.convert_from_pledged_of_goal",
      defaultValue: "Converted from %{pledged} pledged of %{goal} goal.",
      count: nil,
      substitutions: ["pledged": pledged, "goal": goal]
    )
  }
  /// "funded"
  ///
  /// - **en**: "funded"
  /// - **de**: "finanziert"
  /// - **es**: "financiado"
  /// - **fr**: "financé"
  /// - **ja**: "達成"
  public static func discovery_baseball_card_stats_funded() -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.funded",
      defaultValue: "funded",
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
  /// - **ja**: "%{goal} 達成"
  public static func discovery_baseball_card_stats_pledged_of_goal(goal: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.pledged_of_goal",
      defaultValue: "pledged of %{goal}",
      count: nil,
      substitutions: ["goal": goal]
    )
  }
  /// "of %{goal}"
  ///
  /// - **en**: "of %{goal}"
  /// - **de**: "von %{goal}"
  /// - **es**: "de %{goal}"
  /// - **fr**: "sur %{goal}"
  /// - **ja**: "%{goal} 達成"
  public static func discovery_baseball_card_stats_pledged_of_goal_short(goal: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.stats.pledged_of_goal_short",
      defaultValue: "of %{goal}",
      count: nil,
      substitutions: ["goal": goal]
    )
  }
  /// "Funding canceled"
  ///
  /// - **en**: "Funding canceled"
  /// - **de**: "Finanzierung abgebrochen"
  /// - **es**: "Financiamiento cancelado"
  /// - **fr**: "Financement annulé"
  /// - **ja**: "募集停止"
  public static func discovery_baseball_card_status_banner_canceled() -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.canceled",
      defaultValue: "Funding canceled",
      count: nil,
      substitutions: [:]
    )
  }
}
