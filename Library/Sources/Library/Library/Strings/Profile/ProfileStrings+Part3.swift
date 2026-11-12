// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProfileStrings {
  /// "Canceled"
  ///
  /// - **en**: "Canceled"
  /// - **de**: "Zurückgezogen"
  /// - **es**: "Cancelado"
  /// - **fr**: "Annulé"
  /// - **ja**: "キャンセル済"
  public static func profile_projects_status_canceled() -> String {
    return localizedString(
      key: "profile.projects.status.canceled",
      defaultValue: "Canceled",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Successful"
  ///
  /// - **en**: "Successful"
  /// - **de**: "Erfolgreich"
  /// - **es**: "Exitoso"
  /// - **fr**: "Financé"
  /// - **ja**: "成功"
  public static func profile_projects_status_successful() -> String {
    return localizedString(
      key: "profile.projects.status.successful",
      defaultValue: "Successful",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Suspended"
  ///
  /// - **en**: "Suspended"
  /// - **de**: "Ausgesetzt"
  /// - **es**: "Suspendido"
  /// - **fr**: "Suspendu"
  /// - **ja**: "停止済み"
  public static func profile_projects_status_suspended() -> String {
    return localizedString(
      key: "profile.projects.status.suspended",
      defaultValue: "Suspended",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsuccessful"
  ///
  /// - **en**: "Unsuccessful"
  /// - **de**: "Fehlgeschlagen"
  /// - **es**: "Sin éxito"
  /// - **fr**: "Non financé"
  /// - **ja**: "失敗"
  public static func profile_projects_status_unsuccessful() -> String {
    return localizedString(
      key: "profile.projects.status.unsuccessful",
      defaultValue: "Unsuccessful",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{time_left} to go"
  ///
  /// - **en**: "%{time_left} to go"
  /// - **de**: "%{time_left} verbleibend"
  /// - **es**: "%{time_left} restantes"
  /// - **fr**: "Plus que %{time_left}"
  /// - **ja**: "%{time_left} で締切"
  public static func profile_projects_time_left_to_go(time_left: String) -> String {
    return localizedString(
      key: "profile.projects.time_left_to_go",
      defaultValue: "%{time_left} to go",
      count: nil,
      substitutions: ["time_left": time_left]
    )
  }
  /// "Contact"
  ///
  /// - **en**: "Contact"
  /// - **de**: "Kontakt"
  /// - **es**: "Contacto"
  /// - **fr**: "Contact"
  /// - **ja**: "お問い合わせ"
  public static func profile_settings_about_contact() -> String {
    return localizedString(
      key: "profile.settings.about.contact",
      defaultValue: "Contact",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cookie Policy"
  ///
  /// - **en**: "Cookie Policy"
  /// - **de**: "Cookie-Richtlinien"
  /// - **es**: "Política de cookies"
  /// - **fr**: "Politique en matière de cookies"
  /// - **ja**: "クッキーポリシー"
  public static func profile_settings_about_cookie() -> String {
    return localizedString(
      key: "profile.settings.about.cookie",
      defaultValue: "Cookie Policy",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Frequently Asked Questions"
  ///
  /// - **en**: "Frequently Asked Questions"
  /// - **de**: "Häufig gestellte Fragen"
  /// - **es**: "Preguntas frecuentes"
  /// - **fr**: "Questions fréquentes"
  /// - **ja**: "FAQ"
  public static func profile_settings_about_faq() -> String {
    return localizedString(
      key: "profile.settings.about.faq",
      defaultValue: "Frequently Asked Questions",
      count: nil,
      substitutions: [:]
    )
  }
  /// "FAQ"
  ///
  /// - **en**: "FAQ"
  /// - **de**: "FAQ"
  /// - **es**: "Preguntas frecuentes"
  /// - **fr**: "FAQ"
  /// - **ja**: "FAQ"
  public static func profile_settings_about_faq_short() -> String {
    return localizedString(
      key: "profile.settings.about.faq_short",
      defaultValue: "FAQ",
      count: nil,
      substitutions: [:]
    )
  }
  /// "How Kickstarter Works"
  ///
  /// - **en**: "How Kickstarter Works"
  /// - **de**: "Wie Kickstarter funktioniert"
  /// - **es**: "Cómo funciona Kickstarter"
  /// - **fr**: "Comment fonctionne Kickstarter"
  /// - **ja**: "Kickstarterの仕組"
  public static func profile_settings_about_how_it_works() -> String {
    return localizedString(
      key: "profile.settings.about.how_it_works",
      defaultValue: "How Kickstarter Works",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Privacy Policy"
  ///
  /// - **en**: "Privacy Policy"
  /// - **de**: "Datenschutzrichtlinien"
  /// - **es**: "Política de privacidad"
  /// - **fr**: "Politique de confidentialité"
  /// - **ja**: "プライバシーポリシー"
  public static func profile_settings_about_privacy() -> String {
    return localizedString(
      key: "profile.settings.about.privacy",
      defaultValue: "Privacy Policy",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Terms of Use"
  ///
  /// - **en**: "Terms of Use"
  /// - **de**: "Nutzungsbedingungen"
  /// - **es**: "Condiciones de uso"
  /// - **fr**: "Conditions d'utilisation"
  /// - **ja**: "利用規約"
  public static func profile_settings_about_terms() -> String {
    return localizedString(
      key: "profile.settings.about.terms",
      defaultValue: "Terms of Use",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Help"
  ///
  /// - **en**: "Help"
  /// - **de**: "Über uns"
  /// - **es**: "Acerca de"
  /// - **fr**: "À propos de Kickstarter"
  /// - **ja**: "ヘルプ"
  public static func profile_settings_about_title() -> String {
    return localizedString(
      key: "profile.settings.about.title",
      defaultValue: "Help",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Manage project notifications"
  ///
  /// - **en**: "Manage project notifications"
  /// - **de**: "Projektbenachrichtigungen verwalten"
  /// - **es**: "Administrar notificaciones del proyecto"
  /// - **fr**: "Gérer les notifications de projet"
  /// - **ja**: "プロジェクト通知"
  public static func profile_settings_backer_notifications() -> String {
    return localizedString(
      key: "profile.settings.backer.notifications",
      defaultValue: "Manage project notifications",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Project updates"
  ///
  /// - **en**: "Project updates"
  /// - **de**: "Projekt-Updates"
  /// - **es**: "Actualizaciones del proyecto"
  /// - **fr**: "Actus de projet"
  /// - **ja**: "プロジェクトのアップデート"
  public static func profile_settings_backer_project_updates() -> String {
    return localizedString(
      key: "profile.settings.backer.project_updates",
      defaultValue: "Project updates",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Projects you back"
  ///
  /// - **en**: "Projects you back"
  /// - **de**: "Deine unterstützten Projekte"
  /// - **es**: "Proyectos que patrocinas"
  /// - **fr**: "Les projets que je soutiens"
  /// - **ja**: "バック済みプロジェクト"
  public static func profile_settings_backer_title() -> String {
    return localizedString(
      key: "profile.settings.backer.title",
      defaultValue: "Projects you back",
      count: nil,
      substitutions: [:]
    )
  }
}
