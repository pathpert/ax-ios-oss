// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DatesStrings {
  /// "%{time_count} seconds ago"
  ///
  /// - **en**: "%{time_count} seconds ago"
  /// - **de**: "vor %{time_count} Sekunden"
  /// - **es**: "hace %{time_count} segundos"
  /// - **fr**: "il y a %{time_count} secondes"
  /// - **ja**: "%{time_count} 秒前"
  public static func dates_time_seconds_ago_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_seconds_ago_abbreviated",
      defaultValue: "%{time_count} seconds ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} seconds ago"
  ///
  /// - **en**: "%{time_count} seconds ago"
  /// - **de**: "vor %{time_count} Sekunden"
  /// - **es**: "hace %{time_count} segundos"
  /// - **fr**: "il y a %{time_count} secondes"
  /// - **ja**: "%{time_count} 秒前"
  public static func dates_time_seconds_ago_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_seconds_ago_abbreviated.other",
      defaultValue: "%{time_count} seconds ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "yesterday"
  ///
  /// - **en**: "yesterday"
  /// - **de**: "Gestern"
  /// - **es**: "Ayer"
  /// - **fr**: "hier"
  /// - **ja**: "昨日"
  public static func dates_yesterday() -> String {
    return localizedString(
      key: "dates.yesterday",
      defaultValue: "yesterday",
      count: nil,
      substitutions: [:]
    )
  }
  /// "days"
  ///
  /// - **en**: "days"
  /// - **de**: "Tage"
  /// - **es**: "días"
  /// - **fr**: "jours"
  /// - **ja**: "日"
  public static func discovery_baseball_card_deadline_units_days() -> String {
    return localizedString(
      key: "discovery.baseball_card.deadline_units.days",
      defaultValue: "days",
      count: nil,
      substitutions: [:]
    )
  }
  /// "hours"
  ///
  /// - **en**: "hours"
  /// - **de**: "Std"
  /// - **es**: "hrs"
  /// - **fr**: "heures"
  /// - **ja**: "時間"
  public static func discovery_baseball_card_deadline_units_hours() -> String {
    return localizedString(
      key: "discovery.baseball_card.deadline_units.hours",
      defaultValue: "hours",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backers are notified when there are new project updates."
  ///
  /// - **en**: "Backers are notified when there are new project updates."
  /// - **de**: "Unterstützer werden bei neuen Projekt-Updates benachrichtigt."
  /// - **es**: "Se notificarán a los patrocinadores cuando hay actualizaciones del proyecto."
  /// - **fr**: "Les contributeurs reçoivent une notification quand de nouvelles actus sont publiées."
  /// - **ja**: "プロジェクトが更新されると、バッカーに通知されます。"
  public static func project_updates_empty_state_backer_message() -> String {
    return localizedString(
      key: "project.updates.empty_state.backer.message",
      defaultValue: "Backers are notified when there are new project updates.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No updates"
  ///
  /// - **en**: "No updates"
  /// - **de**: "Keine Updates"
  /// - **es**: "No hay actualizaciones"
  /// - **fr**: "Pas d'actus"
  /// - **ja**: "更新なし"
  public static func project_updates_empty_state_backer_title() -> String {
    return localizedString(
      key: "project.updates.empty_state.backer.title",
      defaultValue: "No updates",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backers are notified when there are new project updates."
  ///
  /// - **en**: "Backers are notified when there are new project updates."
  /// - **de**: "Unterstützer werden bei neuen Projekt-Updates benachrichtigt."
  /// - **es**: "Se notificarán a los patrocinadores cuando hay actualizaciones del proyecto."
  /// - **fr**: "Les contributeurs reçoivent une notification quand de nouvelles actus sont publiées."
  /// - **ja**: "プロジェクトの更新がバッカーに通知されます。"
  public static func project_updates_empty_state_logged_out_message() -> String {
    return localizedString(
      key: "project.updates.empty_state.logged_out.message",
      defaultValue: "Backers are notified when there are new project updates.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No updates"
  ///
  /// - **en**: "No updates"
  /// - **de**: "Keine Updates"
  /// - **es**: "No hay actualizaciones"
  /// - **fr**: "Pas d'actus"
  /// - **ja**: "更新なし"
  public static func project_updates_empty_state_logged_out_title() -> String {
    return localizedString(
      key: "project.updates.empty_state.logged_out.title",
      defaultValue: "No updates",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backers are notified when there are new project updates."
  ///
  /// - **en**: "Backers are notified when there are new project updates."
  /// - **de**: "Unterstützer werden bei neuen Projekt-Updates benachrichtigt."
  /// - **es**: "Se notificarán a los patrocinadores cuando hay actualizaciones del proyecto."
  /// - **fr**: "Les contributeurs reçoivent une notification quand de nouvelles actus sont publiées."
  /// - **ja**: "プロジェクトの更新がバッカーに通知されます。"
  public static func project_updates_empty_state_non_backer_message() -> String {
    return localizedString(
      key: "project.updates.empty_state.non_backer.message",
      defaultValue: "Backers are notified when there are new project updates.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No updates"
  ///
  /// - **en**: "No updates"
  /// - **de**: "Keine Updates"
  /// - **es**: "No hay actualizaciones"
  /// - **fr**: "Pas d'actus"
  /// - **ja**: "更新なし"
  public static func project_updates_empty_state_non_backer_title() -> String {
    return localizedString(
      key: "project.updates.empty_state.non_backer.title",
      defaultValue: "No updates",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{updates_count} update"
  ///
  /// - **en**: "%{updates_count} update"
  /// - **de**: "%{updates_count} Update"
  /// - **es**: "%{updates_count} actualización"
  /// - **fr**: "%{updates_count} actu"
  /// - **ja**: "%{updates_count} 件のアップデート"
  public static func updates_count_updates(updates_count: Int) -> String {
    return localizedString(
      key: "updates_count_updates",
      defaultValue: "%{updates_count} update",
      count: updates_count,
      substitutions: ["updates_count": Format.wholeNumber(updates_count)]
    )
  }
  /// "%{updates_count} updates"
  ///
  /// - **en**: "%{updates_count} updates"
  /// - **de**: "%{updates_count} Updates"
  /// - **es**: "%{updates_count} actualizaciones"
  /// - **fr**: "%{updates_count} actus"
  /// - **ja**: "%{updates_count} 件のアップデート"
  public static func updates_count_updates_other(updates_count: String) -> String {
    return localizedString(
      key: "updates_count_updates.other",
      defaultValue: "%{updates_count} updates",
      count: nil,
      substitutions: ["updates_count": updates_count]
    )
  }
}
