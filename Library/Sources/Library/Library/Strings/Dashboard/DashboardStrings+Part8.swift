// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "Last updated on %{date}."
  ///
  /// - **en**: "Last updated on %{date}."
  /// - **de**: "Zuletzt aktualisiert am %{date}."
  /// - **es**: "Última actualización el %{date}."
  /// - **fr**: "Dernière actu le %{date}."
  /// - **ja**: "最終更新：%{date}"
  public static func dashboard_post_update_button_subtitle_last_updated_on_date(date: String) -> String {
    return localizedString(
      key: "dashboard.post_update_button.subtitle.last_updated_on_date",
      defaultValue: "Last updated on %{date}.",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "Last updated on %{date} (%{relative_date})."
  ///
  /// - **en**: "Last updated on %{date} (%{relative_date})."
  /// - **de**: "Zuletzt aktualisiert am %{date}%(%{relative_date})."
  /// - **es**: "Última actualización el %{date} (%{relative_date})."
  /// - **fr**: "Dernière actu le %{date} (%{relative_date})."
  /// - **ja**: "最終更新：%{date}（%{relative_date}）"
  public static func dashboard_post_update_button_subtitle_last_updated_on_date_relative_date(date: String, relative_date: String) -> String {
    return localizedString(
      key: "dashboard.post_update_button.subtitle.last_updated_on_date_relative_date",
      defaultValue: "Last updated on %{date} (%{relative_date}).",
      count: nil,
      substitutions: ["date": date, "relative_date": relative_date]
    )
  }
  /// "You haven’t posted an update yet."
  ///
  /// - **en**: "You haven’t posted an update yet."
  /// - **de**: "Du hast noch kein Update veröffentlicht."
  /// - **es**: "Aún no has publicado ninguna actualización."
  /// - **fr**: "Vous n'avez pas encore publié d'actus."
  /// - **ja**: "アップデート未投稿"
  public static func dashboard_post_update_button_subtitle_you_have_not_posted_an_update_yet() -> String {
    return localizedString(
      key: "dashboard.post_update_button.subtitle.you_have_not_posted_an_update_yet",
      defaultValue: "You haven’t posted an update yet.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Project #%{current_project_index}"
  ///
  /// - **en**: "Project #%{current_project_index}"
  /// - **de**: "Projekt Nr. %{current_project_index}"
  /// - **es**: "Proyecto n° %{current_project_index}"
  /// - **fr**: "Projet no. %{current_project_index}"
  /// - **ja**: "プロジェクト #%{current_project_index}"
  public static func dashboard_switcher_project_number(current_project_index: String) -> String {
    return localizedString(
      key: "dashboard.switcher.project_number",
      defaultValue: "Project #%{current_project_index}",
      count: nil,
      substitutions: ["current_project_index": current_project_index]
    )
  }
  /// "backers"
  ///
  /// - **en**: "backers"
  /// - **de**: "Unterstützer"
  /// - **es**: "patrocinadores"
  /// - **fr**: "contributeurs"
  /// - **ja**: "バッカー"
  public static func dashboard_tout_backers() -> String {
    return localizedString(
      key: "dashboard.tout.backers",
      defaultValue: "backers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "pledged"
  ///
  /// - **en**: "pledged"
  /// - **de**: "beigetragen"
  /// - **es**: "contribuido"
  /// - **fr**: "engagés"
  /// - **ja**: "プレッジ"
  public static func dashboard_tout_pledged() -> String {
    return localizedString(
      key: "dashboard.tout.pledged",
      defaultValue: "pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "remaining"
  ///
  /// - **en**: "remaining"
  /// - **de**: "zum Ziel"
  /// - **es**: "restante"
  /// - **fr**: "restants"
  /// - **ja**: "で締切"
  public static func dashboard_tout_remaining() -> String {
    return localizedString(
      key: "dashboard.tout.remaining",
      defaultValue: "remaining",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Swipe through a video feed, tuning your recommendations along the way."
  ///
  /// - **en**: "Swipe through a video feed, tuning your recommendations along the way."
  /// - **de**: "Wische durch einen Videofeed und passe dabei deine Empfehlungen an."
  /// - **es**: "Desliza el dedo por una selección de videos para personalizar las recomendaciones sobre la marcha."
  /// - **fr**: "À découvrir : un flux de vidéos qui affinera vos recommandations au fur et à mesure."
  /// - **ja**: "動画フィードをスワイプしながら、おすすめを自分好みに調整できます。"
  public static func swipe_through_a_video_feed_tuning_your_recommendations_along_the_way() -> String {
    return localizedString(
      key: "swipe_through_a_video_feed_tuning_your_recommendations_along_the_way",
      defaultValue: "Swipe through a video feed, tuning your recommendations along the way.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{pledged} pledged • Join %{backers} backers"
  ///
  /// - **en**: "%{pledged} pledged • Join %{backers} backers"
  /// - **de**: "%{pledged} finanziert • Von %{backers} Unterstützern unterstützt"
  /// - **es**: "%{pledged} recaudado • Únete a %{backers} patrocinadores"
  /// - **fr**: "%{pledged} engagés • Rejoignez les %{backers} contributeurs"
  /// - **ja**: "プレッジ総額: %{pledged} • 現在のバッカー数: %{backers}"
  public static func video_feed_campaign_subtitle(pledged: String, backers: String) -> String {
    return localizedString(
      key: "video_feed_campaign_subtitle",
      defaultValue: "%{pledged} pledged • Join %{backers} backers",
      count: nil,
      substitutions: ["pledged": pledged, "backers": backers]
    )
  }
}
