// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "If the project reaches its funding goal, you will be charged on %{project_deadline}."
  ///
  /// - **en**: "If the project reaches its funding goal, you will be charged on %{project_deadline}."
  /// - **de**: "Wenn das Projekt erfolgreich finanziert wird, wird deine Karte am %{project_deadline} belastet."
  /// - **es**: "Si el proyecto alcanza su meta de financiamiento, se te cobrará el %{project_deadline}."
  /// - **fr**: "Si l'objectif de financement est atteint, vous serez débité le %{project_deadline}."
  /// - **ja**: "プロジェクトがファンディングゴールに到達すると、%{project_deadline} に請求されます。"
  public static func If_the_project_reaches_its_funding_goal_you_will_be_charged_on_project_deadline(project_deadline: String) -> String {
    return localizedString(
      key: "If_the_project_reaches_its_funding_goal_you_will_be_charged_on_project_deadline",
      defaultValue: "If the project reaches its funding goal, you will be charged on %{project_deadline}.",
      count: nil,
      substitutions: ["project_deadline": project_deadline]
    )
  }
  /// "If the project reaches its funding goal, you will be charged %{total} on %{project_deadline}."
  ///
  /// - **en**: "If the project reaches its funding goal, you will be charged %{total} on %{project_deadline}."
  /// - **de**: "Wenn dieses Projekt das Finanzierungsziel erreicht, wird deine Karte am %{project_deadline} mit %{total} belastet."
  /// - **es**: "Si el proyecto alcanza su meta de financiamiento, se te cobrará %{total} el %{project_deadline}."
  /// - **fr**: "Si l'objectif de financement est atteint, vous serez débité de %{total} le %{project_deadline}."
  /// - **ja**: "プロジェクトがファンディングゴールに到達すると、%{project_deadline} に %{total} の請求が行われます。"
  public static func If_the_project_reaches_its_funding_goal_you_will_be_charged_total_on_project_deadline(total: String, project_deadline: String) -> String {
    return localizedString(
      key: "If_the_project_reaches_its_funding_goal_you_will_be_charged_total_on_project_deadline",
      defaultValue: "If the project reaches its funding goal, you will be charged %{total} on %{project_deadline}.",
      count: nil,
      substitutions: ["total": total, "project_deadline": project_deadline]
    )
  }
  /// "If your project reaches its funding goal, the backer will be charged on %{project_deadline}."
  ///
  /// - **en**: "If your project reaches its funding goal, the backer will be charged on %{project_deadline}."
  /// - **de**: "Wenn dein Projekt das Finanzierungsziel erreicht, wird der Finanzierungsbeitrag des Unterstützers am %{project_deadline} abgebucht."
  /// - **es**: "Si el proyecto alcanza su meta de financiamiento, al patrocinador se le cobrará el %{project_deadline}."
  /// - **fr**: "Si vous atteignez votre objectif de financement, le contributeur sera débité le %{project_deadline}."
  /// - **ja**: "プロジェクトがファンディングゴールに到達すると、バッカーは %{project_deadline} に請求されます。"
  public static func If_your_project_reaches_its_funding_goal_the_backer_will_be_charged_on_project_deadline(project_deadline: String) -> String {
    return localizedString(
      key: "If_your_project_reaches_its_funding_goal_the_backer_will_be_charged_on_project_deadline",
      defaultValue: "If your project reaches its funding goal, the backer will be charged on %{project_deadline}.",
      count: nil,
      substitutions: ["project_deadline": project_deadline]
    )
  }
  /// "If your project reaches its funding goal, the backer will be charged %{total} on %{project_deadline}."
  ///
  /// - **en**: "If your project reaches its funding goal, the backer will be charged %{total} on %{project_deadline}."
  /// - **de**: "Wenn dein Projekt das Finanzierungsziel erreicht, wird die Karte des Unterstützers am %{project_deadline} mit %{total} belastet."
  /// - **es**: "Si el proyecto alcanza su meta de financiamiento, al patrocinador se le cobrará %{total} el %{project_deadline}."
  /// - **fr**: "Si vous atteignez votre objectif de financement, le contributeur sera débité de %{total} le %{project_deadline}."
  /// - **ja**: "プロジェクトがファンディングゴールに到達すると、%{project_deadline} にバッカーへ %{total} が請求されます。"
  public static func If_your_project_reaches_its_funding_goal_the_backer_will_be_charged_total_on_project_deadline(total: String, project_deadline: String) -> String {
    return localizedString(
      key: "If_your_project_reaches_its_funding_goal_the_backer_will_be_charged_total_on_project_deadline",
      defaultValue: "If your project reaches its funding goal, the backer will be charged %{total} on %{project_deadline}.",
      count: nil,
      substitutions: ["total": total, "project_deadline": project_deadline]
    )
  }
  /// "Important project alerts"
  ///
  /// - **en**: "Important project alerts"
  /// - **de**: "Wichtige Projektbenachrichtigungen"
  /// - **es**: "Alertas de proyecto importantes"
  /// - **fr**: "Alertes de projet importantes"
  /// - **ja**: "プロジェクトに関する重要なアラート"
  public static func Important_project_alerts() -> String {
    return localizedString(
      key: "Important_project_alerts",
      defaultValue: "Important project alerts",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Keep in touch after your campaign and plan your next project."
  ///
  /// - **en**: "Keep in touch after your campaign and plan your next project."
  /// - **de**: "Bleibe auch nach deiner Kampagne in Verbindung und plane dein nächstes Projekt."
  /// - **es**: "Mantente en contacto después de tu campaña y planifica tu próximo proyecto."
  /// - **fr**: "Une façon de garder le contact après votre campagne et de prévoir votre prochain projet."
  /// - **ja**: "キャンペーン終了後もニュースレターで最新情報をチェックし、次のプロジェクトに備えましょう。"
  public static func Keep_in_touch_after_your_campaign() -> String {
    return localizedString(
      key: "Keep_in_touch_after_your_campaign",
      defaultValue: "Keep in touch after your campaign and plan your next project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<a href="%{community_link}">Learn more about comment guidelines</a>"
  ///
  /// - **en**: "<a href="%{community_link}">Learn more about comment guidelines</a>"
  /// - **de**: "<a href="%{community_link}">Mehr Info zu Kommentar-Richtlinien</a>"
  /// - **es**: "<a href="%{community_link}">Más información sobre las reglas de los comentarios</a>"
  /// - **fr**: "<a href="%{community_link}">En savoir plus sur les directives applicables aux commentaires</a>"
  /// - **ja**: "<a href="%{community_link}">コメントのガイドラインについてもっと詳しく</a>"
  public static func Learn_more_about_comment_guidelines(community_link: String) -> String {
    return localizedString(
      key: "Learn_more_about_comment_guidelines",
      defaultValue: "<a href=\"%{community_link}\">Learn more about comment guidelines</a>",
      count: nil,
      substitutions: ["community_link": community_link]
    )
  }
  /// "Live now: %{live_stream_event_name} by %{creator_name}"
  ///
  /// - **en**: "Live now: %{live_stream_event_name} by %{creator_name}"
  /// - **de**: "Jetzt live: %{live_stream_event_name} von %{creator_name}"
  /// - **es**: "Ahora en vivo: %{live_stream_event_name} de %{creator_name}"
  /// - **fr**: "En direct : %{live_stream_event_name} par %{creator_name}"
  /// - **ja**: "%{creator_name} が%{live_stream_event_name} をライブ配信中"
  public static func Live_now_live_stream_event_name_by_creator_name(live_stream_event_name: String, creator_name: String) -> String {
    return localizedString(
      key: "Live_now_live_stream_event_name_by_creator_name",
      defaultValue: "Live now: %{live_stream_event_name} by %{creator_name}",
      count: nil,
      substitutions: ["live_stream_event_name": live_stream_event_name, "creator_name": creator_name]
    )
  }
  /// "Live with <b>%{creator_name}</b>"
  ///
  /// - **en**: "Live with <b>%{creator_name}</b>"
  /// - **de**: "Live mit <b>%{creator_name}</b>"
  /// - **es**: "En vivo con <b>%{creator_name}</b>"
  /// - **fr**: "En direct avec <b>%{creator_name}</b>"
  /// - **ja**: "<b>%{creator_name}</b>のライブ配信"
  public static func Live_with_creator_name(creator_name: String) -> String {
    return localizedString(
      key: "Live_with_creator_name",
      defaultValue: "Live with <b>%{creator_name}</b>",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "My project seeks funding for AI technology."
  ///
  /// - **en**: "My project seeks funding for AI technology."
  /// - **de**: "Mit meinem Projekt soll KI-Technologie finanziert werden."
  /// - **es**: "Mi proyecto busca financiamiento para la tecnología de IA."
  /// - **fr**: "Le but de mon projet est de financer une technologie d'IA."
  /// - **ja**: "私のプロジェクトの目的は、AI テクノロジーのための資金調達です。"
  public static func My_project_seeks_funding_for_AI_technology() -> String {
    return localizedString(
      key: "My_project_seeks_funding_for_AI_technology",
      defaultValue: "My project seeks funding for AI technology.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No comments yet."
  ///
  /// - **en**: "No comments yet."
  /// - **de**: "Bisher noch keine Kommentare."
  /// - **es**: "No hay comentarios todavia."
  /// - **fr**: "Pas de commentaires."
  /// - **ja**: "まだコメントはありません。"
  public static func No_comments_yet() -> String {
    return localizedString(
      key: "No_comments_yet",
      defaultValue: "No comments yet.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No one has posted an update yet."
  ///
  /// - **en**: "No one has posted an update yet."
  /// - **de**: "Es wurden noch keine Updates gepostet."
  /// - **es**: "Todavía no se han publicado actualizaciones."
  /// - **fr**: "Pas d'actus publiées pour le moment."
  /// - **ja**: "まだアップデートの投稿はありません。"
  public static func No_one_has_posted_an_update_yet() -> String {
    return localizedString(
      key: "No_one_has_posted_an_update_yet",
      defaultValue: "No one has posted an update yet.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Once you back a project, we’ll share personalized recommendations in this space."
  ///
  /// - **en**: "Once you back a project, we’ll share personalized recommendations in this space."
  /// - **de**: "Wenn du ein Projekt unterstützt, werden wir dir hier maßgeschneiderte Empfehlungen machen."
  /// - **es**: "Tu patrocinio de un proyecto nos ayuda a hacerte recomendaciones personalizadas."
  /// - **fr**: "Une fois que vous aurez soutenu un projet, des recommandations personnalisées s'afficheront ici."
  /// - **ja**: "プロジェクトをバックするとこのスペースにあなたへのオススメを表示します"
  public static func Once_you_back_a_project_well_share() -> String {
    return localizedString(
      key: "Once_you_back_a_project_well_share",
      defaultValue: "Once you back a project, we’ll share personalized recommendations in this space.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Only backers can post comments."
  ///
  /// - **en**: "Only backers can post comments."
  /// - **de**: "Kommentare können nur von Unterstützern hinterlassen werden."
  /// - **es**: "Sólo los patrocinadores pueden publicar comentarios."
  /// - **fr**: "Seuls les contributeurs peuvent commenter."
  /// - **ja**: "バッカーのみコメントできます。"
  public static func Only_backers_can_post_comments() -> String {
    return localizedString(
      key: "Only_backers_can_post_comments",
      defaultValue: "Only backers can post comments.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens comments."
  ///
  /// - **en**: "Opens comments."
  /// - **de**: "Öffnet Kommentare."
  /// - **es**: "Abre comentarios."
  /// - **fr**: "Ouvre les commentaires."
  /// - **ja**: "コメントをみる"
  public static func Opens_comments() -> String {
    return localizedString(
      key: "Opens_comments",
      defaultValue: "Opens comments.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens creator profile."
  ///
  /// - **en**: "Opens creator profile."
  /// - **de**: "Öffnet das Profil des Projektgründers."
  /// - **es**: "Abre el perfil del creador."
  /// - **fr**: "Ouvre le profil du créateur."
  /// - **ja**: "クリエイタープロフィールをみる"
  public static func Opens_creator_profile() -> String {
    return localizedString(
      key: "Opens_creator_profile",
      defaultValue: "Opens creator profile.",
      count: nil,
      substitutions: [:]
    )
  }
}
