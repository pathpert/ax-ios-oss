// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "Public comment"
  ///
  /// - **en**: "Public comment"
  /// - **de**: "Öffentlicher Kommentar"
  /// - **es**: "Comentario público"
  /// - **fr**: "Commentaire public"
  /// - **ja**: "公開コメント"
  public static func Public_comment() -> String {
    return localizedString(
      key: "Public_comment",
      defaultValue: "Public comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Read more about the campaign"
  ///
  /// - **en**: "Read more about the campaign"
  /// - **de**: "Mehr über diese Kampagne lesen"
  /// - **es**: "Leer más sobre la campaña"
  /// - **fr**: "En savoir plus sur la campagne"
  /// - **ja**: "キャンペーンの詳細をみる"
  public static func Read_more_about_the_campaign() -> String {
    return localizedString(
      key: "Read_more_about_the_campaign",
      defaultValue: "Read more about the campaign",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Read more about the campaign  →"
  ///
  /// - **en**: "Read more about the campaign  →"
  /// - **de**: "Mehr über diese Kampagne lesen  →"
  /// - **es**: "Leer más sobre esta campaña  →"
  /// - **fr**: "En savoir plus sur la campagne →"
  /// - **ja**: "キャンペーンの詳細をみる  →"
  public static func Read_more_about_the_campaign_arrow() -> String {
    return localizedString(
      key: "Read_more_about_the_campaign_arrow",
      defaultValue: "Read more about the campaign  →",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recorded live with <b>%{creator_name}</b>"
  ///
  /// - **en**: "Recorded live with <b>%{creator_name}</b>"
  /// - **de**: "Live aufgenommen von <b>%{creator_name}</b>"
  /// - **es**: "Grabado en vivo por <b>%{creator_name}</b>"
  /// - **fr**: "Enregistré en direct avec <b>%{creator_name}</b>"
  /// - **ja**: "配信された<b>%{creator_name}</b>のライブ"
  public static func Recorded_live_with_creator_name(creator_name: String) -> String {
    return localizedString(
      key: "Recorded_live_with_creator_name",
      defaultValue: "Recorded live with <b>%{creator_name}</b>",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "Replay live stream with<br><b>%{creator_name}</b>"
  ///
  /// - **en**: "Replay live stream with<br><b>%{creator_name}</b>"
  /// - **de**: "Wiedergabe des Live-Streams von<br><b>%{creator_name}</b>"
  /// - **es**: "Repetir live stream de<br><b>%{creator_name}</b>"
  /// - **fr**: "Revoir la diffusion en direct de <br><b>%{creator_name}</b>"
  /// - **ja**: "<b>%{creator_name}</b>のライブ配信を再生"
  public static func Replay_live_stream_with_creator_name(creator_name: String) -> String {
    return localizedString(
      key: "Replay_live_stream_with_creator_name",
      defaultValue: "Replay live stream with<br><b>%{creator_name}</b>",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "Report this project to Kickstarter"
  ///
  /// - **en**: "Report this project to Kickstarter"
  /// - **de**: "Dieses Projekt Kickstarter melden"
  /// - **es**: "Denunciar este proyecto a Kickstarter"
  /// - **fr**: "Signaler ce projet à Kickstarter"
  /// - **ja**: "このプロジェクトを Kickstarter に報告する"
  public static func Report_this_project_to() -> String {
    return localizedString(
      key: "Report_this_project_to",
      defaultValue: "Report this project to Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Risks"
  ///
  /// - **en**: "Risks"
  /// - **de**: "Risiken"
  /// - **es**: "Riesgos"
  /// - **fr**: "Risques"
  /// - **ja**: "リスク"
  public static func Risks() -> String {
    return localizedString(
      key: "Risks",
      defaultValue: "Risks",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Risks and challenges"
  ///
  /// - **en**: "Risks and challenges"
  /// - **de**: "Risiken und Herausforderungen"
  /// - **es**: "Riesgos y desafíos"
  /// - **fr**: "Risques et défis"
  /// - **ja**: "リスクと課題"
  public static func Risks_and_challenges() -> String {
    return localizedString(
      key: "Risks_and_challenges",
      defaultValue: "Risks and challenges",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Share an update about your project…"
  ///
  /// - **en**: "Share an update about your project…"
  /// - **de**: "Teile einen Update zu deinem Projekt …"
  /// - **es**: "Comparte una actualización de tu proyecto …"
  /// - **fr**: "Parlez de votre projet dans une actu."
  /// - **ja**: "アップデートをシェアしよう"
  public static func Share_an_update_about_your_project() -> String {
    return localizedString(
      key: "Share_an_update_about_your_project",
      defaultValue: "Share an update about your project…",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Share this project on Twitter."
  ///
  /// - **en**: "Share this project on Twitter."
  /// - **de**: "Teile dieses Projekt auf Twitter."
  /// - **es**: "Compartir este proyecto en Twitter."
  /// - **fr**: "Partagez ce projet sur Twitter."
  /// - **ja**: "プロジェクトをツイッターでシェアしましょう。"
  public static func Share_this_project_on_Twitter() -> String {
    return localizedString(
      key: "Share_this_project_on_Twitter",
      defaultValue: "Share this project on Twitter.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Show comment"
  ///
  /// - **en**: "Show comment"
  /// - **de**: "Kommentar anzeigen"
  /// - **es**: "Mostrar comentario"
  /// - **fr**: "Afficher le commentaire"
  /// - **ja**: "コメントを表示"
  public static func Show_comment() -> String {
    return localizedString(
      key: "Show_comment",
      defaultValue: "Show comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Suspicious creator behavior or pledging activity"
  ///
  /// - **en**: "Suspicious creator behavior or pledging activity"
  /// - **de**: "Verdächtiges Verhalten des Projektgründers/bei Finanzierungsbeiträgen"
  /// - **es**: "Comportamiento del creador o actividad de contribución sospechosos"
  /// - **fr**: "Comportement douteux de la part du créateur ou engagements suspects"
  /// - **ja**: "不審なクリエイターの言動、または不審なプレッジ行為"
  public static func Suspicious_creator_behavior() -> String {
    return localizedString(
      key: "Suspicious_creator_behavior",
      defaultValue: "Suspicious creator behavior or pledging activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tap the heart icon on a project to get notified 48 hours before it ends."
  ///
  /// - **en**: "Tap the heart icon on a project to get notified 48 hours before it ends."
  /// - **de**: "Tippe auf das Herz neben einem Projekt und wir benachrichtigen dich 48 Stunden, bevor es abläuft."
  /// - **es**: "Haz clic en el icono de corazón de un proyecto para recibir una notificación 48 horas antes de que finalice."
  /// - **fr**: "Cliquez sur l'icône en forme de cœur située à côté du projet pour recevoir une notification 48 avant la fin de la campagne."
  /// - **ja**: "終了48時間前に知らせるにはハートのアイコンをタップ！"
  public static func Tap_the_heart_on_a_project_to_get_notified() -> String {
    return localizedString(
      key: "Tap_the_heart_on_a_project_to_get_notified",
      defaultValue: "Tap the heart icon on a project to get notified 48 hours before it ends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tap the heart on each project page to save it. We’ll remind you 48 hours before the project ends."
  ///
  /// - **en**: "Tap the heart on each project page to save it. We’ll remind you 48 hours before the project ends."
  /// - **de**: "Klicke einfach auf das Herz auf der Projektseite, um dieses Projekt zu speichern. Wir werden dir 48 Stunden vor Ablauf eine Benachrichtigung schicken."
  /// - **es**: "Haz clic en el corazón en la página de cada proyecto para guardarlo. Te recordaremos 48 horas antes de que finalice el proyecto."
  /// - **fr**: "Cliquez sur le cœur qui apparaît sur la page du projet pour l'ajouter à vos favoris. Nous vous enverrons un petit rappel 48 heures avant la fin de la campagne."
  /// - **ja**: "ハートのアイコンを押して保存しましょう。終了48時間前に通知が届きます。"
  public static func Tap_the_heart_on_each_project_page_to_save_it() -> String {
    return localizedString(
      key: "Tap_the_heart_on_each_project_page_to_save_it",
      defaultValue: "Tap the heart on each project page to save it. We’ll remind you 48 hours before the project ends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tap the star icon on a project to get notified 48 hours before it ends."
  ///
  /// - **en**: "Tap the star icon on a project to get notified 48 hours before it ends."
  /// - **de**: "Tippe auf den Stern neben einem Projekt und wir benachrichtigen dich 48 Stunden, bevor es abläuft."
  /// - **es**: "Toca el icono de estrella de un proyecto para recibir una notificación 48 horas antes de que finalice."
  /// - **fr**: "Cliquez sur l'icône en forme d'étoile située à côté du projet pour recevoir une notification 48 avant la fin de sa campagne."
  /// - **ja**: "星のマークを押すと、終了48時間前に通知が届きます。"
  public static func Tap_the_star_on_a_project_to_get_notified() -> String {
    return localizedString(
      key: "Tap_the_star_on_a_project_to_get_notified",
      defaultValue: "Tap the star icon on a project to get notified 48 hours before it ends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tap the star on each project page to save it. We’ll remind you 48 hours before the project ends."
  ///
  /// - **en**: "Tap the star on each project page to save it. We’ll remind you 48 hours before the project ends."
  /// - **de**: "Klicke einfach auf den Stern auf der Projektseite, um ein Projekt zu speichern. Wir werden dir 48 Stunden vor Ablauf eine Benachrichtigung schicken."
  /// - **es**: "Toca la estrella en cada página del proyecto para guardarlo. Te recordaremos 48 horas antes de que finalice el proyecto."
  /// - **fr**: "Cliquez sur l'étoile qui apparaît sur la page du projet pour l'ajouter à vos favoris. Nous vous enverrons un petit rappel 48 heures avant la fin de la campagne."
  /// - **ja**: "プロジェクトにスターを押して保存しましょう。プロジェクト終了４８時間前にリマインドします。"
  public static func Tap_the_star_on_each_project_page_to_save_it() -> String {
    return localizedString(
      key: "Tap_the_star_on_each_project_page_to_save_it",
      defaultValue: "Tap the star on each project page to save it. We’ll remind you 48 hours before the project ends.",
      count: nil,
      substitutions: [:]
    )
  }
}
