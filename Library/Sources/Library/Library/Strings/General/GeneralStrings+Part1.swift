// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "A little extra to help bring this project to life."
  ///
  /// - **en**: "A little extra to help bring this project to life."
  /// - **de**: "Ein kleines Extra, um dieses Projekt zu veröffentlichen."
  /// - **es**: "Algo extra para ayudar a que este proyecto se pueda realizar."
  /// - **fr**: "Du soutien supplémentaire pour faire vivre ce projet."
  /// - **ja**: "プロジェクトを実現させるための追加支援。"
  public static func A_little_extra_to_help() -> String {
    return localizedString(
      key: "A_little_extra_to_help",
      defaultValue: "A little extra to help bring this project to life.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "A weekly mix of handpicked projects, plus occasional Kickstarter news"
  ///
  /// - **en**: "A weekly mix of handpicked projects, plus occasional Kickstarter news"
  /// - **de**: "Ein wöchentlicher Mix handverlesener Projekte plus gelegentliche Nachrichten von Kickstarter"
  /// - **es**: "Una combinación semanal de proyectos seleccionados exclusivamente para mí, además de noticias ocasionales de Kickstarter"
  /// - **fr**: "Une sélection de projets hebdomadaire, et de temps en temps des actualités de Kickstarter"
  /// - **ja**: "Kickstarter イチオシのプロジェクトを毎週紹介するニュースレター (Kickstarter ニュースも随時送信)"
  public static func A_weekly_mix_of_handpicked_projects() -> String {
    return localizedString(
      key: "A_weekly_mix_of_handpicked_projects",
      defaultValue: "A weekly mix of handpicked projects, plus occasional Kickstarter news",
      count: nil,
      substitutions: [:]
    )
  }
  /// "A weekly roundup of the best and brightest projects on Kickstarter, handpicked by our team."
  ///
  /// - **en**: "A weekly roundup of the best and brightest projects on Kickstarter, handpicked by our team."
  /// - **de**: "Eine wöchentliche Zusammenfassung der besten und cleversten Projekte auf Kickstarter, handverlesen von unserem Team."
  /// - **es**: "Un resumen semanal de los mejores y más brillantes proyectos de Kickstarter, seleccionados por nuestro equipo."
  /// - **fr**: "Un tour d'horizon hebdomadaire des meilleurs projets Kickstarter, triés sur le volet par nos soins."
  /// - **ja**: "Kickstarter スタッフがセレクトした今週のおすすめプロジェクト総まとめ。"
  public static func A_weekly_roundup_of_the_best_and_brightest() -> String {
    return localizedString(
      key: "A_weekly_roundup_of_the_best_and_brightest",
      defaultValue: "A weekly roundup of the best and brightest projects on Kickstarter, handpicked by our team.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Abuse"
  ///
  /// - **en**: "Abuse"
  /// - **de**: "Missbrauch"
  /// - **es**: "Acoso, violencia y abuso"
  /// - **fr**: "Harcèlement, violence et abus"
  /// - **ja**: "嫌がらせ・不正行為"
  public static func Abuse() -> String {
    return localizedString(
      key: "Abuse",
      defaultValue: "Abuse",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Add"
  ///
  /// - **en**: "Add"
  /// - **de**: "Hinzufügen"
  /// - **es**: "Añadir"
  /// - **fr**: "Ajouter"
  /// - **ja**: "追加"
  public static func Add() -> String {
    return localizedString(
      key: "Add",
      defaultValue: "Add",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Add attachments…"
  ///
  /// - **en**: "Add attachments…"
  /// - **de**: "Anhänge hinzufügen ..."
  /// - **es**: "Agregar anexos …"
  /// - **fr**: "Ajouter des pièces jointes..."
  /// - **ja**: "添付ファイルを追加..."
  public static func Add_attachments() -> String {
    return localizedString(
      key: "Add_attachments",
      defaultValue: "Add attachments…",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Address confirmed! Need to change your address before it locks? Visit your backing details on our website."
  ///
  /// - **en**: "Address confirmed! Need to change your address before it locks? Visit your backing details on our website."
  /// - **de**: "Adresse bestätigt! Du möchtest deine Adresse ändern, bevor sie gesperrt wird? Ruf deine Unterstützungsdetails auf unserer Website auf."
  /// - **es**: "Dirección confirmada. ¿Necesitas cambiarla antes de que se bloquee? Visita los detalles de tu contribución en nuestro sitio web."
  /// - **fr**: "Adresse confirmée ! Besoin d'en changer avant quelle ne soit verrouillée ? Rendez-vous sur notre site Web, sous le détail de votre engagement."
  /// - **ja**: "住所が確認されました。住所がロックされる前に変更する必要がある場合は、Kickstarter ウェブサイトのバック (支援) 詳細にアクセスしてください。"
  public static func Address_confirmed_need_to_change_your_address_before_it_locks() -> String {
    return localizedString(
      key: "Address_confirmed_need_to_change_your_address_before_it_locks",
      defaultValue: "Address confirmed! Need to change your address before it locks? Visit your backing details on our website.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Alert"
  ///
  /// - **en**: "Alert"
  /// - **de**: "Hinweis"
  /// - **es**: "Alerta"
  /// - **fr**: "Alerte"
  /// - **ja**: "個の警告"
  public static func Alert() -> String {
    return localizedString(
      key: "Alert",
      defaultValue: "Alert",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Alerts (%{count})"
  ///
  /// - **en**: "Alerts (%{count})"
  /// - **de**: "Wichtige Hinweise (%{count})"
  /// - **es**: "Alertas (%{count})"
  /// - **fr**: "Alertes (%{count})"
  /// - **ja**: "アラート（%{count}）"
  public static func Alerts_count(count: String) -> String {
    return localizedString(
      key: "Alerts_count",
      defaultValue: "Alerts (%{count})",
      count: nil,
      substitutions: ["count": count]
    )
  }
  /// "All gone"
  ///
  /// - **en**: "All gone"
  /// - **de**: "Alle weg"
  /// - **es**: "¡Recompensas agotadas!"
  /// - **fr**: "Épuisé"
  /// - **ja**: "終了"
  public static func All_gone() -> String {
    return localizedString(
      key: "All_gone",
      defaultValue: "All gone",
      count: nil,
      substitutions: [:]
    )
  }
  /// "All-or-nothing"
  ///
  /// - **en**: "All-or-nothing"
  /// - **de**: "Alles oder nichts"
  /// - **es**: "Todo o nada"
  /// - **fr**: "Tout ou rien"
  /// - **ja**: "All-or-nothing 方式"
  public static func All_or_nothing() -> String {
    return localizedString(
      key: "All_or_nothing",
      defaultValue: "All-or-nothing",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Allow"
  ///
  /// - **en**: "Allow"
  /// - **de**: "Erlauben"
  /// - **es**: "Permitir"
  /// - **fr**: "Autoriser"
  /// - **ja**: "許可する"
  public static func Allow() -> String {
    return localizedString(
      key: "Allow",
      defaultValue: "Allow",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Allow app to track?"
  ///
  /// - **en**: "Allow app to track?"
  /// - **de**: "App-Tracking erlauben?"
  /// - **es**: "¿Permitir que la aplicación realice un seguimiento de mis actividades?"
  /// - **fr**: "Autoriser cette application à suivre mes activités ?"
  /// - **ja**: "アプリによる追跡を許可しますか？"
  public static func Allow_app_to_track() -> String {
    return localizedString(
      key: "Allow_app_to_track",
      defaultValue: "Allow app to track?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Allow tracking"
  ///
  /// - **en**: "Allow tracking"
  /// - **de**: "Tracking erlauben"
  /// - **es**: "Permitir seguimiento"
  /// - **fr**: "Autoriser le suivi"
  /// - **ja**: "追跡を許可"
  public static func Allow_tracking() -> String {
    return localizedString(
      key: "Allow_tracking",
      defaultValue: "Allow tracking",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Almost there!"
  ///
  /// - **en**: "Almost there!"
  /// - **de**: "Fast geschafft!"
  /// - **es**: "Cerca de la meta!"
  /// - **fr**: "Vous y êtes presque!"
  /// - **ja**: "もう少しです!"
  public static func Almost_there() -> String {
    return localizedString(
      key: "Almost_there",
      defaultValue: "Almost there!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Amount: %{amount}, previous amount: %{previous_amount}"
  ///
  /// - **en**: "Amount: %{amount}, previous amount: %{previous_amount}"
  /// - **de**: "Jetziger Betrag: %{amount}, vorheriger Betrag: %{previous_amount}"
  /// - **es**: "Monto actual: %{amount}, monto previo: %{previous_amount}"
  /// - **fr**: "Montant : %{amount}, montant précédant : %{previous_amount}"
  /// - **ja**: "金額: %{amount}, 以前の金額: %{previous_amount}"
  public static func Amount_previous_amount(amount: String, previous_amount: String) -> String {
    return localizedString(
      key: "Amount_previous_amount",
      defaultValue: "Amount: %{amount}, previous amount: %{previous_amount}",
      count: nil,
      substitutions: ["amount": amount, "previous_amount": previous_amount]
    )
  }
}
