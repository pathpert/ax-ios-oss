// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Created projects %{projects_count}"
  ///
  /// - **en**: "Created projects %{projects_count}"
  /// - **de**: "Erstellte Projekte: %{projects_count}"
  /// - **es**: "Proyectos creados: %{projects_count}"
  /// - **fr**: "Projets créés : %{projects_count}"
  /// - **ja**: "%{projects_count} のプロジェクト作成済"
  public static func Created_projects_projects_count(projects_count: String) -> String {
    return localizedString(
      key: "Created_projects_projects_count",
      defaultValue: "Created projects %{projects_count}",
      count: nil,
      substitutions: ["projects_count": projects_count]
    )
  }
  /// "Current email"
  ///
  /// - **en**: "Current email"
  /// - **de**: "Derzeitige E-Mail"
  /// - **es**: "Correo electrónico actual"
  /// - **fr**: "Adresse e-mail actuelle"
  /// - **ja**: "現在のメールアドレス"
  public static func Current_email() -> String {
    return localizedString(
      key: "Current_email",
      defaultValue: "Current email",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Currently supported:"
  ///
  /// - **en**: "Currently supported:"
  /// - **de**: "Derzeit unterstützt:"
  /// - **es**: "Ya disponible:"
  /// - **fr**: "Pris en charge :"
  /// - **ja**: "すでにサポートされている機能："
  public static func Currently_supported() -> String {
    return localizedString(
      key: "Currently_supported",
      defaultValue: "Currently supported:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Daily digest"
  ///
  /// - **en**: "Daily digest"
  /// - **de**: "Tägliche Zusammenfassung"
  /// - **es**: "Resumen diario"
  /// - **fr**: "Résumé quotidien"
  /// - **ja**: "デイリーダイジェスト"
  public static func Daily_digest() -> String {
    return localizedString(
      key: "Daily_digest",
      defaultValue: "Daily digest",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Daily summary"
  ///
  /// - **en**: "Daily summary"
  /// - **de**: "Übersicht (einmal täglich)"
  /// - **es**: "Resumen diario"
  /// - **fr**: "Une fois par jour"
  /// - **ja**: "1日1回の概要"
  public static func Daily_summary() -> String {
    return localizedString(
      key: "Daily_summary",
      defaultValue: "Daily summary",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Data will appear here once somebody backs your project."
  ///
  /// - **en**: "Data will appear here once somebody backs your project."
  /// - **de**: "Info wird hier angezeigt, sobald jemand dein Projekt unterstützt."
  /// - **es**: "Los datos aparecerán aquí una vez que alguien patrocine tu proyecto."
  /// - **fr**: "Ces données seront visibles dès que vous aurez reçu votre première contribution."
  /// - **ja**: "誰かがプロジェクトをバック（支援）すると、ここにデータが表示されます。"
  public static func Data_will_appear_here_once() -> String {
    return localizedString(
      key: "Data_will_appear_here_once",
      defaultValue: "Data will appear here once somebody backs your project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Decline"
  ///
  /// - **en**: "Decline"
  /// - **de**: "Ablehnen"
  /// - **es**: "Rechazar"
  /// - **fr**: "Refuser"
  /// - **ja**: "拒否する"
  public static func Decline() -> String {
    return localizedString(
      key: "Decline",
      defaultValue: "Decline",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Delays or changes are possible."
  ///
  /// - **en**: "Delays or changes are possible."
  /// - **de**: "Es können sich Verzögerungen oder Änderungen ergeben."
  /// - **es**: "Es posible que haya retrasos o cambios."
  /// - **fr**: "Des retards ou des changements sont possibles."
  /// - **ja**: "遅延や変更が発生することもあります。"
  public static func Delays_or_changes_are_possible() -> String {
    return localizedString(
      key: "Delays_or_changes_are_possible",
      defaultValue: "Delays or changes are possible.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Delete my Kickstarter account"
  ///
  /// - **en**: "Delete my Kickstarter account"
  /// - **de**: "Mein Kickstarter-Konto löschen"
  /// - **es**: "Eliminar mi cuenta de Kickstarter"
  /// - **fr**: "Supprimer mon compte Kickstarter"
  /// - **ja**: "Kickstarter アカウントを削除"
  public static func Delete_my_Kickstarter_Account() -> String {
    return localizedString(
      key: "Delete_my_Kickstarter_Account",
      defaultValue: "Delete my Kickstarter account",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Delivered"
  ///
  /// - **en**: "Delivered"
  /// - **de**: "Verschickt"
  /// - **es**: "Entregado"
  /// - **fr**: "Distribué"
  /// - **ja**: "発送済"
  public static func Delivered() -> String {
    return localizedString(
      key: "Delivered",
      defaultValue: "Delivered",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Description"
  ///
  /// - **en**: "Description"
  /// - **de**: "Beschreibung"
  /// - **es**: "Descripción"
  /// - **fr**: "Description"
  /// - **ja**: "説明"
  public static func Description() -> String {
    return localizedString(
      key: "Description",
      defaultValue: "Description",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Developer"
  ///
  /// - **en**: "Developer"
  /// - **de**: "Entwickler"
  /// - **es**: "Desarrollador"
  /// - **fr**: "Développeur"
  /// - **ja**: "開発者"
  public static func Developer() -> String {
    return localizedString(
      key: "Developer",
      defaultValue: "Developer",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover innovative projects and ideas, handpicked twice a month by Kickstarter's Design & Tech team."
  ///
  /// - **en**: "Discover innovative projects and ideas, handpicked twice a month by Kickstarter's Design & Tech team."
  /// - **de**: "Entdecke innovative Projekte und Ideen, handverlesen zweimal monatlich von Kickstarters Design & Tech Team."
  /// - **es**: "Descubre proyectos e ideas innovadores, seleccionados exclusivamente para ti dos veces al mes por el equipo de Diseño & Tecnología de Kickstarter."
  /// - **fr**: "Des idées et des projets innovants à découvrir, soigneusement sélectionnés deux fois par mois par l'équipe Design et technologie de Kickstarter."
  /// - **ja**: "Kickstarter の「デザイン＆テクノロジー」チーム選りすぐりの革新的なプロジェクトを毎月2回お届けします。"
  public static func Discover_arts_news() -> String {
    return localizedString(
      key: "Discover_arts_news",
      defaultValue: "Discover innovative projects and ideas, handpicked twice a month by Kickstarter's Design & Tech team.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover creative projects"
  ///
  /// - **en**: "Discover creative projects"
  /// - **de**: "Erkunde kreative Projekte"
  /// - **es**: "Descubre proyectos creativos"
  /// - **fr**: "Des projets créatifs à découvrir"
  /// - **ja**: "クリエイティブなプロジェクトをさがそう"
  public static func Discover_creative_projects() -> String {
    return localizedString(
      key: "Discover_creative_projects",
      defaultValue: "Discover creative projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover more projects."
  ///
  /// - **en**: "Discover more projects."
  /// - **de**: "Erkunde mehr Projekte."
  /// - **es**: "Descubre más proyectos."
  /// - **fr**: "Découvrir plus de projets"
  /// - **ja**: "プロジェクトをさがす"
  public static func Discover_more_projects() -> String {
    return localizedString(
      key: "Discover_more_projects",
      defaultValue: "Discover more projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover the future of Design and Tech."
  ///
  /// - **en**: "Discover the future of Design and Tech."
  /// - **de**: "Entdecke das Neueste in Design und Technologie."
  /// - **es**: "Descubre el futuro del diseño y la tecnología."
  /// - **fr**: "Tout sur l'avenir du design et de la technologie."
  /// - **ja**: "デザインとテクノロジーの未来を覗いてみよう。"
  public static func Discover_the_future_of_Design_and_Tech() -> String {
    return localizedString(
      key: "Discover_the_future_of_Design_and_Tech",
      defaultValue: "Discover the future of Design and Tech.",
      count: nil,
      substitutions: [:]
    )
  }
}
