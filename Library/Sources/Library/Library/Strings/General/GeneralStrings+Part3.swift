// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Ask me anything"
  ///
  /// - **en**: "Ask me anything"
  /// - **de**: "Frage stellen"
  /// - **es**: "¡Pregúntame!"
  /// - **fr**: "Posez-moi une question !"
  /// - **ja**: "お問い合わせ"
  public static func Ask_me_anything() -> String {
    return localizedString(
      key: "Ask_me_anything",
      defaultValue: "Ask me anything",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Authentication failed. Please try again."
  ///
  /// - **en**: "Authentication failed. Please try again."
  /// - **de**: "Authentifizierung fehlgeschlagen. Bitte versuch es noch einmal."
  /// - **es**: "Autenticación fallida. Intenta de nuevo."
  /// - **fr**: "Authentification échouée. Veuillez réessayer."
  /// - **ja**: "認証に失敗しました。もう一度お試しください。"
  public static func Authentication_failed_please_try_again() -> String {
    return localizedString(
      key: "Authentication_failed_please_try_again",
      defaultValue: "Authentication failed. Please try again.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Authentication required"
  ///
  /// - **en**: "Authentication required"
  /// - **de**: "Authentifizierung erforderlich"
  /// - **es**: "Autenticación necesaria"
  /// - **fr**: "Authentification nécessaire"
  /// - **ja**: "認証手続きが必要です"
  public static func Authentication_required() -> String {
    return localizedString(
      key: "Authentication_required",
      defaultValue: "Authentication required",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Authentication success. Please pull to refresh."
  ///
  /// - **en**: "Authentication success. Please pull to refresh."
  /// - **de**: "Authentifizierung erfolgreich. Bitte ziehe, um die Seite zu aktualisieren."
  /// - **es**: "Autenticación exitosa. Desliza para actualizar."
  /// - **fr**: "Authentification réussie. Veuillez tirer la page vers le bas pour l'actualiser."
  /// - **ja**: "認証が成功しました。画面をプルダウンして、更新してください。"
  public static func Authentication_success_please_pull_to_refresh() -> String {
    return localizedString(
      key: "Authentication_success_please_pull_to_refresh",
      defaultValue: "Authentication success. Please pull to refresh.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Available to watch for %{time} more %{units}"
  ///
  /// - **en**: "Available to watch for %{time} more %{units}"
  /// - **de**: "Kann noch %{time} %{units} angesehen werden"
  /// - **es**: "Disponible para reproducción %{time} %{units} más"
  /// - **fr**: "Plus que %{time}%{units} pour regarder cette diffusion"
  /// - **ja**: "さらに%{time} の%{units} を見ることができます"
  public static func Available_to_watch_for_time_more_units(time: String, units: String) -> String {
    return localizedString(
      key: "Available_to_watch_for_time_more_units",
      defaultValue: "Available to watch for %{time} more %{units}",
      count: nil,
      substitutions: ["time": time, "units": units]
    )
  }
  /// "Back"
  ///
  /// - **en**: "Back"
  /// - **de**: "Zurück"
  /// - **es**: "Atrás"
  /// - **fr**: "Retour"
  /// - **ja**: "バック"
  public static func Back() -> String {
    return localizedString(
      key: "Back",
      defaultValue: "Back",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Back it because you believe in it."
  ///
  /// - **en**: "Back it because you believe in it."
  /// - **de**: "Du glaubst an dieses Projekt. Unterstütze es."
  /// - **es**: "Apóyalo porque crees en él."
  /// - **fr**: "Ce projet ne décollera pas sans vous."
  /// - **ja**: "このプロジェクトの可能性を信じてバックしよう。"
  public static func Back_it_because_you_believe_in_it() -> String {
    return localizedString(
      key: "Back_it_because_you_believe_in_it",
      defaultValue: "Back it because you believe in it.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Back this project"
  ///
  /// - **en**: "Back this project"
  /// - **de**: "Projekt unterstützen"
  /// - **es**: "Patrocinar este proyecto"
  /// - **fr**: "Je soutiens ce projet"
  /// - **ja**: "このプロジェクトをバックする"
  public static func Back_this_project() -> String {
    return localizedString(
      key: "Back_this_project",
      defaultValue: "Back this project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backed projects %{project_count}"
  ///
  /// - **en**: "Backed projects %{project_count}"
  /// - **de**: "Unterstützte Projekte: %{project_count}"
  /// - **es**: "Proyectos patrocinados: %{project_count}"
  /// - **fr**: "Projets soutenus : %{project_count}"
  /// - **ja**: "%{project_count} 件のバック済プロジェクト"
  public static func Backed_projects_projects_count(project_count: String) -> String {
    return localizedString(
      key: "Backed_projects_projects_count",
      defaultValue: "Backed projects %{project_count}",
      count: nil,
      substitutions: ["project_count": project_count]
    )
  }
  /// "%{backers_count}
  /// cker"
  ///
  /// - **en**: "%{backers_count}
  /// cker"
  /// - **de**: "%{backers_count}
  /// terstützer"
  /// - **es**: "%{backers_count}
  /// trocinador"
  /// - **fr**: "%{backers_count}
  /// ntributeur"
  /// - **ja**: "%{backers_count}
  /// カー"
  public static func Backers_count_separator_backers(backers_count: Int) -> String {
    return localizedString(
      key: "Backers_count_separator_backers",
      defaultValue: "%{backers_count}\nbacker",
      count: backers_count,
      substitutions: ["backers_count": Format.wholeNumber(backers_count)]
    )
  }
  /// "%{backers_count}
  /// ckers"
  ///
  /// - **en**: "%{backers_count}
  /// ckers"
  /// - **de**: "%{backers_count}
  /// terstützer"
  /// - **es**: "%{backers_count}
  /// trocinadores"
  /// - **fr**: "%{backers_count}
  /// ntributeurs"
  /// - **ja**: "%{backers_count} バッカー"
  public static func Backers_count_separator_backers_other(backers_count: String) -> String {
    return localizedString(
      key: "Backers_count_separator_backers.other",
      defaultValue: "%{backers_count}\nbackers",
      count: nil,
      substitutions: ["backers_count": backers_count]
    )
  }
  /// "Big Kickstarter news and events near you, delivered just a few times a year."
  ///
  /// - **en**: "Big Kickstarter news and events near you, delivered just a few times a year."
  /// - **de**: "Ein paar Mal pro Jahr: Kickstarter-Neuigkeiten und Events in deiner Nähe."
  /// - **es**: "Unas cuantas veces al año: Noticias sobresalientes de Kickstarter y eventos cerca de ti."
  /// - **fr**: "Les grandes nouvelles et les événements près de chez vous, quelques fois par an."
  /// - **ja**: "Kickstarter に関するビッグニュースやお近くのイベントについて、年に数回お届け。"
  public static func Big_Kickstarter_news_and_events_near_you() -> String {
    return localizedString(
      key: "Big_Kickstarter_news_and_events_near_you",
      defaultValue: "Big Kickstarter news and events near you, delivered just a few times a year.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Big Kickstarter news, plus occasional projects and events chosen just for you."
  ///
  /// - **en**: "Big Kickstarter news, plus occasional projects and events chosen just for you."
  /// - **de**: "Das Neueste von Kickstarter plus gelegentlich für dich ausgewählte Projekte und Events."
  /// - **es**: "Importantes novedades de Kickstarter, además de proyectos y eventos ocasionales elegidos especialmente para ti."
  /// - **fr**: "Les grandes actualités Kickstarter et quelques projets et événements de temps et temps, rien que pour vous."
  /// - **ja**: "Kickstarter のニュースに加え、あなたにピッタリのおすすめプロジェクトやイベントを随時お送りします."
  public static func Big_Kickstarter_news_plus_occasional_projects_and_events_chosen_just_for_you() -> String {
    return localizedString(
      key: "Big_Kickstarter_news_plus_occasional_projects_and_events_chosen_just_for_you",
      defaultValue: "Big Kickstarter news, plus occasional projects and events chosen just for you.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Block"
  ///
  /// - **en**: "Block"
  /// - **de**: "Blockieren"
  /// - **es**: "Bloquear"
  /// - **fr**: "Bloquer"
  /// - **ja**: "ブロック"
  public static func Block() -> String {
    return localizedString(
      key: "Block",
      defaultValue: "Block",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Block this user"
  ///
  /// - **en**: "Block this user"
  /// - **de**: "Diesen Nutzer blockieren"
  /// - **es**: "Bloquear a este usuario"
  /// - **fr**: "Bloquer cet utilisateur"
  /// - **ja**: "このユーザーをブロックする"
  public static func Block_this_user() -> String {
    return localizedString(
      key: "Block_this_user",
      defaultValue: "Block this user",
      count: nil,
      substitutions: [:]
    )
  }
}
