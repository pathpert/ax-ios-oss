// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "Pledged"
  ///
  /// - **en**: "Pledged"
  /// - **de**: "Beiträge gesamt"
  /// - **es**: "Contribuido"
  /// - **fr**: "Engagements"
  /// - **ja**: "プレッジ"
  public static func dashboard_graphs_rewards_pledged() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.pledged",
      defaultValue: "Pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "See all reward tiers"
  ///
  /// - **en**: "See all reward tiers"
  /// - **de**: "Alle Belohnungsstufen anzeigen"
  /// - **es**: "Ver todos los niveles de recompensas"
  /// - **fr**: "Tous les niveaux de récompense"
  /// - **ja**: "全てみる"
  public static func dashboard_graphs_rewards_see_all() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.see_all",
      defaultValue: "See all reward tiers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "REWARDS"
  ///
  /// - **en**: "REWARDS"
  /// - **de**: "BELOHNUNGEN"
  /// - **es**: "RECOMPENSAS"
  /// - **fr**: "RÉCOMPENSES"
  /// - **ja**: "リワード"
  public static func dashboard_graphs_rewards_title() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.title",
      defaultValue: "REWARDS",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rewards"
  ///
  /// - **en**: "Rewards"
  /// - **de**: "Belohnungen"
  /// - **es**: "Recompensas"
  /// - **fr**: "Récompenses"
  /// - **ja**: "リワード"
  public static func dashboard_graphs_rewards_title_rewards() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.title_rewards",
      defaultValue: "Rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Top Rewards"
  ///
  /// - **en**: "Top Rewards"
  /// - **de**: "Top-Belohnungen"
  /// - **es**: "Las mejores recompensas"
  /// - **fr**: "Récompenses les plus populaires"
  /// - **ja**: "トップリワード"
  public static func dashboard_graphs_rewards_top_rewards() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.top_rewards",
      defaultValue: "Top Rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "View more reward stats"
  ///
  /// - **en**: "View more reward stats"
  /// - **de**: "Mehr ansehen"
  /// - **es**: "Mostrar más"
  /// - **fr**: "Plus de statistiques sur les récompenses"
  /// - **ja**: "詳細をみる"
  public static func dashboard_graphs_rewards_view_more_reward_stats() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.view_more_reward_stats",
      defaultValue: "View more reward stats",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{external_start_count} off-site"
  ///
  /// - **en**: "%{external_start_count} off-site"
  /// - **de**: "%{external_start_count} extern"
  /// - **es**: "%{external_start_count} en sitios externos"
  /// - **fr**: "%{external_start_count} en externe"
  /// - **ja**: "外部の%{external_start_count} 人"
  public static func dashboard_graphs_video_stats_external_start_count_off_site(external_start_count: String) -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.external_start_count_off_site",
      defaultValue: "%{external_start_count} off-site",
      count: nil,
      substitutions: ["external_start_count": external_start_count]
    )
  }
  /// "%{internal_start_count} on Kickstarter"
  ///
  /// - **en**: "%{internal_start_count} on Kickstarter"
  /// - **de**: "%{internal_start_count} auf Kickstarter"
  /// - **es**: "%{internal_start_count} en Kickstarter"
  /// - **fr**: "%{internal_start_count} sur Kickstarter"
  /// - **ja**: "Kickstarterの%{internal_start_count} 人"
  public static func dashboard_graphs_video_stats_internal_start_count_on_kickstarter(internal_start_count: String) -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.internal_start_count_on_kickstarter",
      defaultValue: "%{internal_start_count} on Kickstarter",
      count: nil,
      substitutions: ["internal_start_count": internal_start_count]
    )
  }
  /// "off-site"
  ///
  /// - **en**: "off-site"
  /// - **de**: "außerhalb Kickstarters"
  /// - **es**: "en otro lugar"
  /// - **fr**: "hors site"
  /// - **ja**: "オフサイト"
  public static func dashboard_graphs_video_stats_off_site() -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.off_site",
      defaultValue: "off-site",
      count: nil,
      substitutions: [:]
    )
  }
  /// "on Kickstarter"
  ///
  /// - **en**: "on Kickstarter"
  /// - **de**: "auf Kickstarter"
  /// - **es**: "en Kickstarter"
  /// - **fr**: "sur Kickstarter"
  /// - **ja**: "kickstarter上"
  public static func dashboard_graphs_video_stats_on_kickstarter() -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.on_kickstarter",
      defaultValue: "on Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{percent_plays_completed} of plays completed"
  ///
  /// - **en**: "%{percent_plays_completed} of plays completed"
  /// - **de**: "%{percent_plays_completed} aller Aufrufe wurden bis zum Ende wiedergegeben"
  /// - **es**: "%{percent_plays_completed} de reproducciones completadas"
  /// - **fr**: "%{percent_plays_completed} des personnes qui ont vu la vidéo l'ont regardée jusqu'à la fin"
  /// - **ja**: "%{percent_plays_completed}％完遂"
  public static func dashboard_graphs_video_stats_percent_plays_completed(percent_plays_completed: String) -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.percent_plays_completed",
      defaultValue: "%{percent_plays_completed} of plays completed",
      count: nil,
      substitutions: ["percent_plays_completed": percent_plays_completed]
    )
  }
  /// "%{total_start_count} plays"
  ///
  /// - **en**: "%{total_start_count} plays"
  /// - **de**: "%{total_start_count} Aufrufe"
  /// - **es**: "%{total_start_count} reproducciones"
  /// - **fr**: "%{total_start_count} vues"
  /// - **ja**: "%{total_start_count} 人がプレイ"
  public static func dashboard_graphs_video_stats_total_plays(total_start_count: String) -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.total_plays",
      defaultValue: "%{total_start_count} plays",
      count: nil,
      substitutions: ["total_start_count": total_start_count]
    )
  }
  /// "<b>%{total_start_count}</b> total plays"
  ///
  /// - **en**: "<b>%{total_start_count}</b> total plays"
  /// - **de**: "<b>%{total_start_count}</b> Aufrufe"
  /// - **es**: "<b>%{total_start_count}</b> reproducciones"
  /// - **fr**: "<b>%{total_start_count}</b> lectures (total)"
  /// - **ja**: "<b>%{total_start_count}</b>人がプレイ"
  public static func dashboard_graphs_video_stats_total_plays_count(total_start_count: Int) -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.total_plays_count",
      defaultValue: "<b>%{total_start_count}</b> total plays",
      count: total_start_count,
      substitutions: ["total_start_count": Format.wholeNumber(total_start_count)]
    )
  }
  /// "<b>%{total_start_count}</b> total plays"
  ///
  /// - **en**: "<b>%{total_start_count}</b> total plays"
  /// - **de**: "<b>%{total_start_count}</b> Aufrufe"
  /// - **es**: "<b>%{total_start_count}</b> reproducciones"
  /// - **fr**: "<b>%{total_start_count}</b> lectures (total)"
  /// - **ja**: "<b>%{total_start_count}</b>人がプレイ"
  public static func dashboard_graphs_video_stats_total_plays_count_other(total_start_count: String) -> String {
    return localizedString(
      key: "dashboard.graphs.video.stats.total_plays_count.other",
      defaultValue: "<b>%{total_start_count}</b> total plays",
      count: nil,
      substitutions: ["total_start_count": total_start_count]
    )
  }
  /// "VIDEO PLAYS"
  ///
  /// - **en**: "VIDEO PLAYS"
  /// - **de**: "Videoaufrufe"
  /// - **es**: "REPRODUCCIONES DEL VÍDEO"
  /// - **fr**: "LECTURES DE LA VIDÉO"
  /// - **ja**: "ビデオ再生"
  public static func dashboard_graphs_video_title() -> String {
    return localizedString(
      key: "dashboard.graphs.video.title",
      defaultValue: "VIDEO PLAYS",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Video Plays"
  ///
  /// - **en**: "Video Plays"
  /// - **de**: "Video/Aufrufe"
  /// - **es**: "Reproducciones de video"
  /// - **fr**: "Lectures vidéo"
  /// - **ja**: "ビデオ再生"
  public static func dashboard_graphs_video_title_video_plays() -> String {
    return localizedString(
      key: "dashboard.graphs.video.title_video_plays",
      defaultValue: "Video Plays",
      count: nil,
      substitutions: [:]
    )
  }
}
