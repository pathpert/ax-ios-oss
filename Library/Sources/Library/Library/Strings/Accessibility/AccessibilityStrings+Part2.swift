// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension AccessibilityStrings {
  /// "Bank account"
  ///
  /// - **en**: "Bank account"
  /// - **de**: "Bankkonto"
  /// - **es**: "Cuenta bancaria"
  /// - **fr**: "Compte bancaire"
  /// - **ja**: "銀行口座"
  public static func accessibility_payment_types_bank_account() -> String {
    return localizedString(
      key: "accessibility.payment_types.bank_account",
      defaultValue: "Bank account",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Google Pay"
  ///
  /// - **en**: "Google Pay"
  /// - **de**: "Google Pay"
  /// - **es**: "Google Pay"
  /// - **fr**: "Google Pay"
  /// - **ja**: "Google Pay"
  public static func accessibility_payment_types_google_pay() -> String {
    return localizedString(
      key: "accessibility.payment_types.google_pay",
      defaultValue: "Google Pay",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Close"
  ///
  /// - **en**: "Close"
  /// - **de**: "Schließen"
  /// - **es**: "Cerrar"
  /// - **fr**: "Fermer"
  /// - **ja**: "閉じる"
  public static func accessibility_projects_buttons_close() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.close",
      defaultValue: "Close",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Close video player"
  ///
  /// - **en**: "Close video player"
  /// - **de**: "Video-Player schließen"
  /// - **es**: "Cerrar reproductor de video"
  /// - **fr**: "Fermer le lecteur vidéo"
  /// - **ja**: "閉じる"
  public static func accessibility_projects_buttons_close_video_player() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.close_video_player",
      defaultValue: "Close video player",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pause video"
  ///
  /// - **en**: "Pause video"
  /// - **de**: "Video anhalten"
  /// - **es**: "Pausar video"
  /// - **fr**: "Pause"
  /// - **ja**: "一時停止"
  public static func accessibility_projects_buttons_pause_video() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.pause_video",
      defaultValue: "Pause video",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Play video"
  ///
  /// - **en**: "Play video"
  /// - **de**: "Video abspielen"
  /// - **es**: "Reproducir video"
  /// - **fr**: "Lecture"
  /// - **ja**: "再生"
  public static func accessibility_projects_buttons_play_video() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.play_video",
      defaultValue: "Play video",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Star"
  ///
  /// - **en**: "Star"
  /// - **de**: "Favoriten"
  /// - **es**: "Favoritos"
  /// - **fr**: "Projets préférés"
  /// - **ja**: "お気に入り"
  public static func accessibility_projects_buttons_star() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.star",
      defaultValue: "Star",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Favorites this project."
  ///
  /// - **en**: "Favorites this project."
  /// - **de**: "Fügt Projekt zu Favoriten hinzu."
  /// - **es**: "Añade este proyecto a tus favoritos."
  /// - **fr**: "Ce projet sera ajouté à ma liste de projets préférés."
  /// - **ja**: "このプロジェクトをお気に入り"
  public static func accessibility_projects_buttons_star_hint_favorites_this_project() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.star_hint_favorites_this_project",
      defaultValue: "Favorites this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reminds you 48 hours before this project ends."
  ///
  /// - **en**: "Reminds you 48 hours before this project ends."
  /// - **de**: "Sendet dir eine Benachrichtigung 48 Stunden vor Ablauf des Projekts."
  /// - **es**: "Recibirás una notificación 48 horas antes de que finalice el proyecto."
  /// - **fr**: "Vous recevrez un rappel 48 heures avant la fin de cette campagne."
  /// - **ja**: "プロジェクトが終了する48時間前に知らせる"
  public static func accessibility_projects_buttons_star_hint_reminds_you() -> String {
    return localizedString(
      key: "accessibility.projects.buttons.star_hint_reminds_you",
      defaultValue: "Reminds you 48 hours before this project ends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Share project"
  ///
  /// - **en**: "Share project"
  /// - **de**: "Projekt teilen"
  /// - **es**: "Compartir proyecto"
  /// - **fr**: "Partager ce projet"
  /// - **ja**: "プロジェクトをシェア"
  public static func dashboard_accessibility_label_share_project() -> String {
    return localizedString(
      key: "dashboard.accessibility_label_share_project",
      defaultValue: "Share project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{pledged} of %{goal} goal, %{backers_count} backers so far, %{time_left} to go"
  ///
  /// - **en**: "%{pledged} of %{goal} goal, %{backers_count} backers so far, %{time_left} to go"
  /// - **de**: "%{pledged} von %{goal} erreicht, bisher %{backers_count} Unterstützer, noch %{time_left}"
  /// - **es**: "%{pledged} de %{goal} recaudado, %{backers_count} patrocinadores hasta ahora, tiempo restante: %{time_left}"
  /// - **fr**: "%{pledged} engagés sur %{goal}, %{backers_count} contributeurs pour le moment, plus que %{time_left}"
  /// - **ja**: "%{goal} のゴール中%{pledged} 、%{backers_count} 人のバッカー、 %{time_left} 日に締切"
  public static func dashboard_graphs_funding_accessibility_live_stat_value(pledged: String, goal: String, backers_count: Int, time_left: String) -> String {
    return localizedString(
      key: "dashboard.graphs.funding.accessibility.live_stat_value",
      defaultValue: "%{pledged} of %{goal} goal, %{backers_count} backers so far, %{time_left} to go",
      count: backers_count,
      substitutions: ["pledged": pledged, "goal": goal, "backers_count": Format.wholeNumber(backers_count), "time_left": time_left]
    )
  }
  /// "%{pledged} of %{goal} goal, %{backers_count} backers so far, %{time_left} to go"
  ///
  /// - **en**: "%{pledged} of %{goal} goal, %{backers_count} backers so far, %{time_left} to go"
  /// - **de**: "%{pledged} von %{goal} erreicht, bisher %{backers_count} Unterstützer, noch %{time_left}"
  /// - **es**: "%{pledged} de %{goal} recaudado, %{backers_count} patrocinadores hasta ahora, tiempo restante: %{time_left}"
  /// - **fr**: "%{pledged} engagés sur %{goal}, %{backers_count} contributeurs pour le moment, plus que %{time_left}"
  /// - **ja**: "%{goal} のゴール中%{pledged} 、%{backers_count} 人のバッカー、 %{time_left} 日に締切"
  public static func dashboard_graphs_funding_accessibility_live_stat_value_other(pledged: String, goal: String, backers_count: String, time_left: String) -> String {
    return localizedString(
      key: "dashboard.graphs.funding.accessibility.live_stat_value.other",
      defaultValue: "%{pledged} of %{goal} goal, %{backers_count} backers so far, %{time_left} to go",
      count: nil,
      substitutions: ["pledged": pledged, "goal": goal, "backers_count": backers_count, "time_left": time_left]
    )
  }
  /// "%{pledged} of %{goal} goal, %{backers_count} backers total, %{time_left} to go"
  ///
  /// - **en**: "%{pledged} of %{goal} goal, %{backers_count} backers total, %{time_left} to go"
  /// - **de**: "%{pledged} von %{goal} erreicht, bisher %{backers_count} Unterstützer, noch %{time_left}"
  /// - **es**: "%{pledged} de %{goal} recaudado, %{backers_count} patrocinadores hasta ahora, tiempo restante: %{time_left}"
  /// - **fr**: "%{pledged} engagés sur %{goal}, %{backers_count} contributeurs, plus que %{time_left}"
  /// - **ja**: "%{goal} のゴール中%{pledged} 、%{backers_count} 人のバッカー、 %{time_left} 日に締切"
  public static func dashboard_graphs_funding_accessibility_non_live_stat_value(pledged: String, goal: String, backers_count: Int, time_left: String) -> String {
    return localizedString(
      key: "dashboard.graphs.funding.accessibility.non_live_stat_value",
      defaultValue: "%{pledged} of %{goal} goal, %{backers_count} backers total, %{time_left} to go",
      count: backers_count,
      substitutions: ["pledged": pledged, "goal": goal, "backers_count": Format.wholeNumber(backers_count), "time_left": time_left]
    )
  }
  /// "%{pledged} of %{goal} goal, %{backers_count} backers total, %{time_left} to go"
  ///
  /// - **en**: "%{pledged} of %{goal} goal, %{backers_count} backers total, %{time_left} to go"
  /// - **de**: "%{pledged} von %{goal} erreicht, bisher %{backers_count} Unterstützer, noch %{time_left}"
  /// - **es**: "%{pledged} de %{goal} recaudado, %{backers_count} patrocinadores hasta ahora, tiempo restante: %{time_left}"
  /// - **fr**: "%{pledged} engagés sur %{goal}, %{backers_count} contributeurs, plus que %{time_left}"
  /// - **ja**: "%{goal} のゴール中%{pledged} 、%{backers_count} 人のバッカー、 %{time_left} 日に締切"
  public static func dashboard_graphs_funding_accessibility_non_live_stat_value_other(pledged: String, goal: String, backers_count: String, time_left: String) -> String {
    return localizedString(
      key: "dashboard.graphs.funding.accessibility.non_live_stat_value.other",
      defaultValue: "%{pledged} of %{goal} goal, %{backers_count} backers total, %{time_left} to go",
      count: nil,
      substitutions: ["pledged": pledged, "goal": goal, "backers_count": backers_count, "time_left": time_left]
    )
  }
  /// "Closes list of projects."
  ///
  /// - **en**: "Closes list of projects."
  /// - **de**: "Schließt Projekt-Liste."
  /// - **es**: "Cierra la lista de proyectos."
  /// - **fr**: "Ferme la liste de projets."
  /// - **ja**: "リストを閉じる"
  public static func dashboard_switcher_accessibility_label_closes_list_of_projects() -> String {
    return localizedString(
      key: "dashboard.switcher.accessibility_label_closes_list_of_projects",
      defaultValue: "Closes list of projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens list of projects."
  ///
  /// - **en**: "Opens list of projects."
  /// - **de**: "Öffnet eine Liste von Projekten."
  /// - **es**: "Abre una lista de proyectos."
  /// - **fr**: "Ouvre une liste de projets."
  /// - **ja**: "リストを開く"
  public static func dashboard_switcher_accessibility_label_opens_list_of_projects() -> String {
    return localizedString(
      key: "dashboard.switcher.accessibility_label_opens_list_of_projects",
      defaultValue: "Opens list of projects.",
      count: nil,
      substitutions: [:]
    )
  }
}
