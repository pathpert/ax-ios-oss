// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "Project"
  ///
  /// - **en**: "Project"
  /// - **de**: "Projekt"
  /// - **es**: "Proyecto"
  /// - **fr**: "Projet"
  /// - **ja**: "プロジェクト"
  public static func dashboard_buttons_project() -> String {
    return localizedString(
      key: "dashboard.buttons.project",
      defaultValue: "Project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Share"
  ///
  /// - **en**: "Share"
  /// - **de**: "Teilen"
  /// - **es**: "Compartir"
  /// - **fr**: "Partager"
  /// - **ja**: "シェア"
  public static func dashboard_buttons_share() -> String {
    return localizedString(
      key: "dashboard.buttons.share",
      defaultValue: "Share",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Currently live"
  ///
  /// - **en**: "Currently live"
  /// - **de**: "Jetzt live"
  /// - **es**: "Actualmente activos"
  /// - **fr**: "En cours"
  /// - **ja**: "現在のライブ"
  public static func dashboard_creator_project_currently_live() -> String {
    return localizedString(
      key: "dashboard.creator_project.currently_live",
      defaultValue: "Currently live",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funded on %{deadline}"
  ///
  /// - **en**: "Funded on %{deadline}"
  /// - **de**: "Finanziert am %{deadline}"
  /// - **es**: "Financiado el %{deadline}"
  /// - **fr**: "Financé le %{deadline}"
  /// - **ja**: "%{deadline} に達成"
  public static func dashboard_creator_project_funded_on_deadline(deadline: String) -> String {
    return localizedString(
      key: "dashboard.creator_project.funded_on_deadline",
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
  /// - **ja**: "キャンセル"
  public static func dashboard_creator_project_funding_canceled() -> String {
    return localizedString(
      key: "dashboard.creator_project.funding_canceled",
      defaultValue: "Funding canceled",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding suspended"
  ///
  /// - **en**: "Funding suspended"
  /// - **de**: "Finanzierung ausgesetzt"
  /// - **es**: "Financiamiento suspendido"
  /// - **fr**: "Financement suspendu"
  /// - **ja**: "ファンディング停止済み"
  public static func dashboard_creator_project_funding_suspended() -> String {
    return localizedString(
      key: "dashboard.creator_project.funding_suspended",
      defaultValue: "Funding suspended",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding unsuccessful"
  ///
  /// - **en**: "Funding unsuccessful"
  /// - **de**: "Finanzierung fehlgeschlagen"
  /// - **es**: "Financiamiento sin éxito"
  /// - **fr**: "Financement non réussi"
  /// - **ja**: "失敗"
  public static func dashboard_creator_project_funding_unsuccessful() -> String {
    return localizedString(
      key: "dashboard.creator_project.funding_unsuccessful",
      defaultValue: "Funding unsuccessful",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Couldn't load projects"
  ///
  /// - **en**: "Couldn't load projects"
  /// - **de**: "Projekte konnten nicht geladen werden"
  /// - **es**: "No se pudieron cargar projectos"
  /// - **fr**: "Impossible de charger les projets"
  /// - **ja**: "プロジェクトを読み込めません"
  public static func dashboard_error_could_not_load_projects() -> String {
    return localizedString(
      key: "dashboard.error.could_not_load_projects",
      defaultValue: "Couldn't load projects",
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
  public static func dashboard_graphs_funding_backers() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.backers",
      defaultValue: "Backers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal"
  ///
  /// - **en**: "Goal"
  /// - **de**: "Finanzierungsziel"
  /// - **es**: "Meta"
  /// - **fr**: "Objectif"
  /// - **ja**: "目標"
  public static func dashboard_graphs_funding_goal() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.goal",
      defaultValue: "Goal",
      count: nil,
      substitutions: [:]
    )
  }
  /// "100%"
  ///
  /// - **en**: "100%"
  /// - **de**: "100%"
  /// - **es**: "100%"
  /// - **fr**: "100 %"
  /// - **ja**: "100%"
  public static func dashboard_graphs_funding_one_hundred_percent() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.one_hundred_percent",
      defaultValue: "100%",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledged"
  ///
  /// - **en**: "Pledged"
  /// - **de**: "Beiträge"
  /// - **es**: "Contribuido"
  /// - **fr**: "Engagements"
  /// - **ja**: "プレッジ"
  public static func dashboard_graphs_funding_pledged() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.pledged",
      defaultValue: "Pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "FUNDING PROGRESS"
  ///
  /// - **en**: "FUNDING PROGRESS"
  /// - **de**: "FINANZIERUNGS-VERLAUF"
  /// - **es**: "PROGRESO DEL FINANCIAMIENTO"
  /// - **fr**: "PROGRESSION DU FINANCEMENT"
  /// - **ja**: "動向"
  public static func dashboard_graphs_funding_title() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.title",
      defaultValue: "FUNDING PROGRESS",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding Progress"
  ///
  /// - **en**: "Funding Progress"
  /// - **de**: "Finanzierungsfortschritt"
  /// - **es**: "Progreso del financiamiento"
  /// - **fr**: "Évolution du financement"
  /// - **ja**: "ファンディングの進捗"
  public static func dashboard_graphs_funding_title_funding_progress() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.title_funding_progress",
      defaultValue: "Funding Progress",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Total"
  ///
  /// - **en**: "Total"
  /// - **de**: "Gesamtbetrag"
  /// - **es**: "Total"
  /// - **fr**: "Total"
  /// - **ja**: "合計"
  public static func dashboard_graphs_funding_total() -> String {
    return localizedString(
      key: "dashboard.graphs.funding.total",
      defaultValue: "Total",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Average pledge amount"
  ///
  /// - **en**: "Average pledge amount"
  /// - **de**: "Durchschnittlicher Beitrag"
  /// - **es**: "Importe de contribución medio"
  /// - **fr**: "Engagement moyen"
  /// - **ja**: "平均プレッジ額"
  public static func dashboard_graphs_referrers_average_pledge_amount() -> String {
    return localizedString(
      key: "dashboard.graphs.referrers.average_pledge_amount",
      defaultValue: "Average pledge amount",
      count: nil,
      substitutions: [:]
    )
  }
}
