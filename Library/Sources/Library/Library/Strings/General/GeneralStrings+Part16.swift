// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Not raising funds for a creative project"
  ///
  /// - **en**: "Not raising funds for a creative project"
  /// - **de**: "Gelder werden nicht für ein kreatives Projekt gesammelt"
  /// - **es**: "No recauda fondos para un proyecto creativo"
  /// - **fr**: "Financement destiné à un projet non créatif"
  /// - **ja**: "クリエイティブなプロジェクトのためのファンディングではない"
  public static func Not_raising_funds() -> String {
    return localizedString(
      key: "Not_raising_funds",
      defaultValue: "Not raising funds for a creative project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Notify me on launch"
  ///
  /// - **en**: "Notify me on launch"
  /// - **de**: "Benachrichtige mich, wenn das Projekt live geht"
  /// - **es**: "Notificarme cuando se publique"
  /// - **fr**: "Me prévenir du lancement"
  /// - **ja**: "ローンチ通知を受け取る"
  public static func Notify_me_on_launch() -> String {
    return localizedString(
      key: "Notify_me_on_launch",
      defaultValue: "Notify me on launch",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Only %{amount_of_time} left to watch this."
  ///
  /// - **en**: "Only %{amount_of_time} left to watch this."
  /// - **de**: "Nur noch %{amount_of_time} live!"
  /// - **es**: "Queda poco tiempo para verlo (%{amount_of_time})."
  /// - **fr**: "Plus que %{amount_of_time} pour regarder cette diffusion."
  /// - **ja**: "あと%{amount_of_time} のみ視聴可能"
  public static func Only_amount_of_time_left_to_watch_this(amount_of_time: String) -> String {
    return localizedString(
      key: "Only_amount_of_time_left_to_watch_this",
      defaultValue: "Only %{amount_of_time} left to watch this.",
      count: nil,
      substitutions: ["amount_of_time": amount_of_time]
    )
  }
  /// "Opens email composer."
  ///
  /// - **en**: "Opens email composer."
  /// - **de**: "Öffnet E-Mail-Vorlage."
  /// - **es**: "Abre plantilla de correo."
  /// - **fr**: "Ouvre l'éditeur d'e-mail."
  /// - **ja**: "メールの送受信者をみる"
  public static func Opens_email_composer() -> String {
    return localizedString(
      key: "Opens_email_composer",
      defaultValue: "Opens email composer.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens help sheet."
  ///
  /// - **en**: "Opens help sheet."
  /// - **de**: "Öffnet die Hilfe-Seite."
  /// - **es**: "Abre hoja de ayuda."
  /// - **fr**: "Ouvre la page d'aide."
  /// - **ja**: "ヘルプシートを開く"
  public static func Opens_help_sheet() -> String {
    return localizedString(
      key: "Opens_help_sheet",
      defaultValue: "Opens help sheet.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens project."
  ///
  /// - **en**: "Opens project."
  /// - **de**: "Öffnet Projektseite."
  /// - **es**: "Abre proyecto."
  /// - **fr**: "Ouvre le projet."
  /// - **ja**: "プロジェクトをみる"
  public static func Opens_project() -> String {
    return localizedString(
      key: "Opens_project",
      defaultValue: "Opens project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens update."
  ///
  /// - **en**: "Opens update."
  /// - **de**: "Öffnet Update."
  /// - **es**: "Abre actualización."
  /// - **fr**: "Ouvre l'actu."
  /// - **ja**: "アップデートをみる"
  public static func Opens_update() -> String {
    return localizedString(
      key: "Opens_update",
      defaultValue: "Opens update.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens user menu."
  ///
  /// - **en**: "Opens user menu."
  /// - **de**: "Öffnet das Nutzermenü."
  /// - **es**: "Abre el menú del usuario."
  /// - **fr**: "Ouvre le menu utilisateur."
  /// - **ja**: "ユーザーメニューが開きます。"
  public static func Opens_user_menu() -> String {
    return localizedString(
      key: "Opens_user_menu",
      defaultValue: "Opens user menu.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Other projects you might like."
  ///
  /// - **en**: "Other projects you might like."
  /// - **de**: "Ähnliche Projekte:"
  /// - **es**: "Otros proyectos que te pueden gustar."
  /// - **fr**: "Autre projets qui pourraient vous intéresser"
  /// - **ja**: "おすすめをさらに見る"
  public static func Other_projects_you_might_like() -> String {
    return localizedString(
      key: "Other_projects_you_might_like",
      defaultValue: "Other projects you might like.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Our <a href="%{community_guidelines}">Community Guidelines</a> prohibit spam and abusive behavior by both creators and backers."
  ///
  /// - **en**: "Our <a href="%{community_guidelines}">Community Guidelines</a> prohibit spam and abusive behavior by both creators and backers."
  /// - **de**: "Unsere <a href="%{community_guidelines}">Community-Richtlinien</a> verbieten Spam und missbräuchliches Verhalten seitens der Projektgründer und der Unterstützer."
  /// - **es**: "Nuestras <a href="%{community_guidelines}">Reglas de la comunidad</a> prohíben el correo no deseado y el comportamiento abusivo por parte de creadores y patrocinadores."
  /// - **fr**: "Nos <a href="%{community_guidelines}">règles de bonne conduite</a> interdisent le spam et les comportements abusifs, du côté des créateurs comme des contributeurs."
  /// - **ja**: "Kickstarter の<a href="%{community_guidelines}">コミュニティガイドライン</a>では、クリエイターとバッカーの両者によるスパムや不正行為が禁止されています。"
  public static func Our(community_guidelines: String) -> String {
    return localizedString(
      key: "Our",
      defaultValue: "Our <a href=\"%{community_guidelines}\">Community Guidelines</a> prohibit spam and abusive behavior by both creators and backers.",
      count: nil,
      substitutions: ["community_guidelines": community_guidelines]
    )
  }
  /// "Overview"
  ///
  /// - **en**: "Overview"
  /// - **de**: "Übersicht"
  /// - **es**: "Descripción general"
  /// - **fr**: "Vue d'ensemble"
  /// - **ja**: "概要"
  public static func Overview() -> String {
    return localizedString(
      key: "Overview",
      defaultValue: "Overview",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Past live stream"
  ///
  /// - **en**: "Past live stream"
  /// - **de**: "Früherer Live-Stream"
  /// - **es**: "Live Stream pasado"
  /// - **fr**: "Diffusion en direct passée"
  /// - **ja**: "過去のプロジェクト"
  public static func Past_live_stream() -> String {
    return localizedString(
      key: "Past_live_stream",
      defaultValue: "Past live stream",
      count: nil,
      substitutions: [:]
    )
  }
  /// "% raised"
  ///
  /// - **en**: "% raised"
  /// - **de**: "% finanziert"
  /// - **es**: "% recaudado"
  /// - **fr**: "% de financement"
  /// - **ja**: "％ 達成"
  public static func Percentage_raised() -> String {
    return localizedString(
      key: "Percentage_raised",
      defaultValue: "% raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Under 75%"
  ///
  /// - **en**: "Under 75%"
  /// - **de**: "Unter 75 %"
  /// - **es**: "Menos del 75 %"
  /// - **fr**: "Inférieur à 75 %"
  /// - **ja**: "75%未満"
  public static func Percentage_raised_bucket_0() -> String {
    return localizedString(
      key: "Percentage_raised_bucket_0",
      defaultValue: "Under 75%",
      count: nil,
      substitutions: [:]
    )
  }
  /// "75% to 100%"
  ///
  /// - **en**: "75% to 100%"
  /// - **de**: "75–100 %"
  /// - **es**: "Del 75 % al 100 %"
  /// - **fr**: "Entre 75 % et 100 %"
  /// - **ja**: "75%から100%"
  public static func Percentage_raised_bucket_1() -> String {
    return localizedString(
      key: "Percentage_raised_bucket_1",
      defaultValue: "75% to 100%",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More than 100%"
  ///
  /// - **en**: "More than 100%"
  /// - **de**: "Mehr als 100 %"
  /// - **es**: "Más del 100 %"
  /// - **fr**: "Supérieur à 100 %"
  /// - **ja**: "100%以上"
  public static func Percentage_raised_bucket_2() -> String {
    return localizedString(
      key: "Percentage_raised_bucket_2",
      defaultValue: "More than 100%",
      count: nil,
      substitutions: [:]
    )
  }
}
