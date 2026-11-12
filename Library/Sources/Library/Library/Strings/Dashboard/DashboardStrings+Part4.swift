// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "Backers"
  ///
  /// - **en**: "Backers"
  /// - **de**: "Unterstützer"
  /// - **es**: "Patrocinadores"
  /// - **fr**: "Contributeurs"
  /// - **ja**: "バッカー"
  public static func dashboard_graphs_referrers_backers() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.backers",
      defaultValue: "Backers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Percent"
  ///
  /// - **en**: "Percent"
  /// - **de**: "Prozent"
  /// - **es**: "Por ciento"
  /// - **fr**: "Pourcentage"
  /// - **ja**: "％"
  public static func dashboard_graphs_referrers_percent() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.percent",
      defaultValue: "Percent",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{percent_external} External"
  ///
  /// - **en**: "%{percent_external} External"
  /// - **de**: "%{percent_external} Extern"
  /// - **es**: "%{percent_external} Externos"
  /// - **fr**: "%{percent_external} de sources externes"
  /// - **ja**: "外部の%{percent_external}%人"
  public static func dashboard_graphs_referrers_percent_external(percent_external: String) -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.percent_external",
      defaultValue: "%{percent_external} External",
      count: nil,
      substitutions: ["percent_external": percent_external]
    )
  }
  /// "%{percent_kickstarter} Kickstarter"
  ///
  /// - **en**: "%{percent_kickstarter} Kickstarter"
  /// - **de**: "%{percent_kickstarter} Kickstarter"
  /// - **es**: "%{percent_kickstarter} Kickstarter"
  /// - **fr**: "%{percent_kickstarter} via Kickstarter"
  /// - **ja**: "%{percent_kickstarter}％はKickstarter"
  public static func dashboard_graphs_referrers_percent_kickstarter(percent_kickstarter: String) -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.percent_kickstarter",
      defaultValue: "%{percent_kickstarter} Kickstarter",
      count: nil,
      substitutions: ["percent_kickstarter": percent_kickstarter]
    )
  }
  /// "Pledged"
  ///
  /// - **en**: "Pledged"
  /// - **de**: "Beiträge gesamt"
  /// - **es**: "Contribuido"
  /// - **fr**: "Engagements"
  /// - **ja**: "プレッジされた金額"
  public static func dashboard_graphs_referrers_pledged() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.pledged",
      defaultValue: "Pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledged via custom"
  ///
  /// - **en**: "Pledged via custom"
  /// - **de**: "Benutzerdefinierte Beiträge"
  /// - **es**: "Contribuciones personalizadas"
  /// - **fr**: "Montant engagé via des sites référents personnalisés"
  /// - **ja**: "カスタム経由"
  public static func dashboard_graphs_referrers_pledged_via_custom() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.pledged_via_custom",
      defaultValue: "Pledged via custom",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledged via external"
  ///
  /// - **en**: "Pledged via external"
  /// - **de**: "Externe Beiträge"
  /// - **es**: "Contribuido a través de externos"
  /// - **fr**: "Engagements externes"
  /// - **ja**: "外部経由"
  public static func dashboard_graphs_referrers_pledged_via_external() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.pledged_via_external",
      defaultValue: "Pledged via external",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledged via Kickstarter"
  ///
  /// - **en**: "Pledged via Kickstarter"
  /// - **de**: "Beiträge über Kickstarter"
  /// - **es**: "Contribuido a través de Kickstarter"
  /// - **fr**: "Montant engagé via Kickstarter"
  /// - **ja**: "Kickstarterでプレッジされた金額"
  public static func dashboard_graphs_referrers_pledged_via_kickstarter() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.pledged_via_kickstarter",
      defaultValue: "Pledged via Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Show more referrers"
  ///
  /// - **en**: "Show more referrers"
  /// - **de**: "Weitere Referrer anzeigen"
  /// - **es**: "Mostrar más referer"
  /// - **fr**: "Afficher plus de référents"
  /// - **ja**: "参照元を表示"
  public static func dashboard_graphs_referrers_show_more() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.show_more",
      defaultValue: "Show more referrers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Source"
  ///
  /// - **en**: "Source"
  /// - **de**: "Quelle"
  /// - **es**: "Fuente"
  /// - **fr**: "Source"
  /// - **ja**: "ソース"
  public static func dashboard_graphs_referrers_source() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.source",
      defaultValue: "Source",
      count: nil,
      substitutions: [:]
    )
  }
  /// "REFERRERS"
  ///
  /// - **en**: "REFERRERS"
  /// - **de**: "Referrer"
  /// - **es**: "REFERER"
  /// - **fr**: "RÉFÉRENTS"
  /// - **ja**: "リファラー"
  public static func dashboard_graphs_referrers_title() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.title",
      defaultValue: "REFERRERS",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Referrers"
  ///
  /// - **en**: "Referrers"
  /// - **de**: "Referrer"
  /// - **es**: "Referencias"
  /// - **fr**: "Référents"
  /// - **ja**: "リファラー"
  public static func dashboard_graphs_referrers_title_referrers() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.title_referrers",
      defaultValue: "Referrers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "View more referrer stats"
  ///
  /// - **en**: "View more referrer stats"
  /// - **de**: "Mehr ansehen"
  /// - **es**: "Mostrar más"
  /// - **fr**: "Plus de statistiques sur les référents"
  /// - **ja**: "リファラーログをもっとみる"
  public static func dashboard_graphs_referrers_view_more_referrer_stats() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.view_more_referrer_stats",
      defaultValue: "View more referrer stats",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backers"
  ///
  /// - **en**: "Backers"
  /// - **de**: "Unterstützer"
  /// - **es**: "Patrocinadores"
  /// - **fr**: "Contributeurs"
  /// - **ja**: "バッカー"
  public static func dashboard_graphs_rewards_backers() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.backers",
      defaultValue: "Backers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No reward"
  ///
  /// - **en**: "No reward"
  /// - **de**: "Keine Belohnung"
  /// - **es**: "Sin recompensa"
  /// - **fr**: "Pas de récompense"
  /// - **ja**: "リワード無"
  public static func dashboard_graphs_rewards_no_reward() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.no_reward",
      defaultValue: "No reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Percent"
  ///
  /// - **en**: "Percent"
  /// - **de**: "Prozent"
  /// - **es**: "Por ciento"
  /// - **fr**: "Pourcentage"
  /// - **ja**: "パーセント"
  public static func dashboard_graphs_rewards_percent() -> String {
    return localizedString(
      key: "dashboard.graphs.rewards.percent",
      defaultValue: "Percent",
      count: nil,
      substitutions: [:]
    )
  }
}
