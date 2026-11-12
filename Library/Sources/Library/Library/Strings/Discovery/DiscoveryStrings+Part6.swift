// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "Funding canceled %{date}"
  ///
  /// - **en**: "Funding canceled %{date}"
  /// - **de**: "Finanzierung abgebrochen am %{date}"
  /// - **es**: "Financiamiento cancelado el %{date}"
  /// - **fr**: "Campagne annulée le %{date}"
  /// - **ja**: "%{date} に募集キャンセル"
  public static func discovery_baseball_card_status_banner_canceled_date(date: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.canceled_date",
      defaultValue: "Funding canceled %{date}",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "Funding unsuccessful %{date}"
  ///
  /// - **en**: "Funding unsuccessful %{date}"
  /// - **de**: "Finanzierung fehlgeschlagen %{date}"
  /// - **es**: "Financiamiento fallido %{date}"
  /// - **fr**: "Non financé %{date}"
  /// - **ja**: "%{date} にファンディング失敗"
  public static func discovery_baseball_card_status_banner_funding_unsuccessful_date(date: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.funding_unsuccessful_date",
      defaultValue: "Funding unsuccessful %{date}",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "Successfully funded!"
  ///
  /// - **en**: "Successfully funded!"
  /// - **de**: "Finanziert"
  /// - **es**: "¡Financiado!"
  /// - **fr**: "Financé !"
  /// - **ja**: "資金調達に成功"
  public static func discovery_baseball_card_status_banner_successful() -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.successful",
      defaultValue: "Successfully funded!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Successfully funded %{date}"
  ///
  /// - **en**: "Successfully funded %{date}"
  /// - **de**: "Erfolgreich finanziert am %{date}"
  /// - **es**: "Financiado con éxito el %{date}"
  /// - **fr**: "Intégralement financé le %{date}"
  /// - **ja**: "%{date} に目標達成"
  public static func discovery_baseball_card_status_banner_successful_date(date: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.successful_date",
      defaultValue: "Successfully funded %{date}",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "Funding suspended %{date}"
  ///
  /// - **en**: "Funding suspended %{date}"
  /// - **de**: "Finanzierung ausgesetzt %{date}"
  /// - **es**: "Financiamiento suspendido %{date}"
  /// - **fr**: "Financement suspendu %{date}"
  /// - **ja**: "%{date} にファンディング停止済み"
  public static func discovery_baseball_card_status_banner_suspended(date: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.suspended",
      defaultValue: "Funding suspended %{date}",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "Funding suspended %{date}"
  ///
  /// - **en**: "Funding suspended %{date}"
  /// - **de**: "Finanzierung ausgesetzt am %{date}"
  /// - **es**: "Financiamiento suspendido el %{date}"
  /// - **fr**: "Campagne suspendue le %{date}"
  /// - **ja**: "%{date} にファンディング停止済み"
  public static func discovery_baseball_card_status_banner_suspended_date(date: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.status_banner.suspended_date",
      defaultValue: "Funding suspended %{date}",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "%{time_left} to go"
  ///
  /// - **en**: "%{time_left} to go"
  /// - **de**: "%{time_left} zum Ziel"
  /// - **es**: "%{time_left} más"
  /// - **fr**: "Plus que %{time_left}"
  /// - **ja**: "%{time_left} で締切"
  public static func discovery_baseball_card_time_left_to_go(time_left: String) -> String {
    return localizedString(
      key: "discovery.baseball_card.time_left_to_go",
      defaultValue: "%{time_left} to go",
      count: nil,
      substitutions: ["time_left": time_left]
    )
  }
  /// "Category"
  ///
  /// - **en**: "Category"
  /// - **de**: "Kategorie"
  /// - **es**: "Categoría"
  /// - **fr**: "Catégorie"
  /// - **ja**: "カテゴリー"
  public static func discovery_category() -> String {
    return localizedString(
      key: "discovery.category",
      defaultValue: "Category",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover projects"
  ///
  /// - **en**: "Discover projects"
  /// - **de**: "Projekte entdecken"
  /// - **es**: "Descubre proyectos"
  /// - **fr**: "Découvrir des projets"
  /// - **ja**: "さがす"
  public static func discovery_empty_states_saved_logged_in_button() -> String {
    return localizedString(
      key: "discovery.empty_states.saved.logged_in.button",
      defaultValue: "Discover projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When you star a project we’ll send you a reminder email 48 hours before it ends."
  ///
  /// - **en**: "When you star a project we’ll send you a reminder email 48 hours before it ends."
  /// - **de**: "Wenn du ein Projekt zu deinen Favoriten hinzufügst, senden wir dir 48 Stunden vor Ablauf eine Erinnerungs-E-Mail."
  /// - **es**: "Cuando agregues un proyecto a tus más destacados, te enviaremos un recordatorio 48 horas antes de que éste finalice."
  /// - **fr**: "Si vous ajoutez un projet à vos projets préférés, nous vous enverrons un rappel par e-mail 48 heures avant la fin de sa campagne."
  /// - **ja**: "お気に入り登録で、終了４８時間前に通知が届きます。"
  public static func discovery_empty_states_saved_logged_in_message() -> String {
    return localizedString(
      key: "discovery.empty_states.saved.logged_in.message",
      defaultValue: "When you star a project we’ll send you a reminder email 48 hours before it ends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Starred Projects"
  ///
  /// - **en**: "Starred Projects"
  /// - **de**: "Meine Favoriten"
  /// - **es**: "Mis favoritos"
  /// - **fr**: "Mes projets préférés"
  /// - **ja**: "お気に入り"
  public static func discovery_empty_states_saved_logged_in_title() -> String {
    return localizedString(
      key: "discovery.empty_states.saved.logged_in.title",
      defaultValue: "Starred Projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Log in"
  ///
  /// - **en**: "Log in"
  /// - **de**: "Anmelden"
  /// - **es**: "Iniciar sesión"
  /// - **fr**: "Connexion"
  /// - **ja**: "ログイン"
  public static func discovery_empty_states_saved_logged_out_button() -> String {
    return localizedString(
      key: "discovery.empty_states.saved.logged_out.button",
      defaultValue: "Log in",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When you star a project we’ll send you a reminder email 48 hours before it ends."
  ///
  /// - **en**: "When you star a project we’ll send you a reminder email 48 hours before it ends."
  /// - **de**: "Wenn du ein Projekt zu deinen Favoriten hinzufügst, senden wir dir 48 Stunden vor Ablauf eine Erinnerungs-E-Mail."
  /// - **es**: "Cuando agregues un proyecto a tus más destacados, te enviaremos un recordatorio 48 horas antes de que éste finalice."
  /// - **fr**: "Si vous ajoutez un projet à vos projets préférés, nous vous enverrons un rappel par e-mail 48 heures avant la fin de sa campagne."
  /// - **ja**: "お気に入り登録で、終了４８時間前に通知が届きます。"
  public static func discovery_empty_states_saved_logged_out_message() -> String {
    return localizedString(
      key: "discovery.empty_states.saved.logged_out.message",
      defaultValue: "When you star a project we’ll send you a reminder email 48 hours before it ends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Starred Projects"
  ///
  /// - **en**: "Starred Projects"
  /// - **de**: "Meine Favoriten"
  /// - **es**: "Mis proyectos favoritos"
  /// - **fr**: "Mes projets préférés"
  /// - **ja**: "お気に入り"
  public static func discovery_empty_states_saved_logged_out_title() -> String {
    return localizedString(
      key: "discovery.empty_states.saved.logged_out.title",
      defaultValue: "Starred Projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Everything"
  ///
  /// - **en**: "Everything"
  /// - **de**: "Alle"
  /// - **es**: "Todos"
  /// - **fr**: "Tous les projets"
  /// - **ja**: "すべて"
  public static func discovery_everything() -> String {
    return localizedString(
      key: "discovery.everything",
      defaultValue: "Everything",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover more projects."
  ///
  /// - **en**: "Discover more projects."
  /// - **de**: "Noch mehr Projekte erkunden."
  /// - **es**: "Descubre más proyectos."
  /// - **fr**: "Découvrez plus de projets."
  /// - **ja**: "さらにさがす"
  public static func discovery_facebook_connect_hero_get_social_to_discover_more_projects() -> String {
    return localizedString(
      key: "discovery.facebook_connect_hero.get_social_to_discover_more_projects",
      defaultValue: "Discover more projects.",
      count: nil,
      substitutions: [:]
    )
  }
}
