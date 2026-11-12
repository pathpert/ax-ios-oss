// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Activity"
  ///
  /// - **en**: "Activity"
  /// - **de**: "Aktivität"
  /// - **es**: "Actividad"
  /// - **fr**: "Activité"
  /// - **ja**: "アクティビティ"
  public static func tabbar_activity() -> String {
    return localizedString(
      key: "tabbar.activity",
      defaultValue: "Activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Dashboard"
  ///
  /// - **en**: "Dashboard"
  /// - **de**: "Dashboard"
  /// - **es**: "Panel de control"
  /// - **fr**: "Tableau de bord"
  /// - **ja**: "ダッシュボード"
  public static func tabbar_dashboard() -> String {
    return localizedString(
      key: "tabbar.dashboard",
      defaultValue: "Dashboard",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover"
  ///
  /// - **en**: "Discover"
  /// - **de**: "Entdecken"
  /// - **es**: "Descubrir"
  /// - **fr**: "Découvrir"
  /// - **ja**: "さがす"
  public static func tabbar_discover() -> String {
    return localizedString(
      key: "tabbar.discover",
      defaultValue: "Discover",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Me"
  ///
  /// - **en**: "Me"
  /// - **de**: "Mein Konto"
  /// - **es**: "Mi cuenta"
  /// - **fr**: "Mon compte"
  /// - **ja**: "Me"
  public static func tabbar_me() -> String {
    return localizedString(
      key: "tabbar.me",
      defaultValue: "Me",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Profile"
  ///
  /// - **en**: "Profile"
  /// - **de**: "Profil"
  /// - **es**: "Perfil"
  /// - **fr**: "Profil"
  /// - **ja**: "プロフィール"
  public static func tabbar_profile() -> String {
    return localizedString(
      key: "tabbar.profile",
      defaultValue: "Profile",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Search"
  ///
  /// - **en**: "Search"
  /// - **de**: "Suche"
  /// - **es**: "Búsqueda"
  /// - **fr**: "Recherche"
  /// - **ja**: "さがす"
  public static func tabbar_search() -> String {
    return localizedString(
      key: "tabbar.search",
      defaultValue: "Search",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Try it now"
  ///
  /// - **en**: "Try it now"
  /// - **de**: "Jetzt ausprobieren"
  /// - **es**: "Probarlo ahora"
  /// - **fr**: "J'essaie"
  /// - **ja**: "今すぐ試す"
  public static func try_it_now() -> String {
    return localizedString(
      key: "try_it_now",
      defaultValue: "Try it now",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{unread_count} unread"
  ///
  /// - **en**: "%{unread_count} unread"
  /// - **de**: "%{unread_count} ungelesen"
  /// - **es**: "%{unread_count} sin leer"
  /// - **fr**: "%{unread_count} messages non lus"
  /// - **ja**: "%{unread_count} 件の未読メッセージ"
  public static func unread_count_unread(unread_count: String) -> String {
    return localizedString(
      key: "unread_count_unread",
      defaultValue: "%{unread_count} unread",
      count: nil,
      substitutions: ["unread_count": unread_count]
    )
  }
  /// "via custom"
  ///
  /// - **en**: "via custom"
  /// - **de**: "Benutzerdefiniert"
  /// - **es**: "a través de personalizados"
  /// - **fr**: "sites référents personnalisés"
  /// - **ja**: "リファラー経由"
  public static func via_custom() -> String {
    return localizedString(
      key: "via_custom",
      defaultValue: "via custom",
      count: nil,
      substitutions: [:]
    )
  }
  /// "via external"
  ///
  /// - **en**: "via external"
  /// - **de**: "Extern"
  /// - **es**: "a través de externos"
  /// - **fr**: "sites référents externes"
  /// - **ja**: "外部を経由"
  public static func via_external() -> String {
    return localizedString(
      key: "via_external",
      defaultValue: "via external",
      count: nil,
      substitutions: [:]
    )
  }
  /// "via Kickstarter"
  ///
  /// - **en**: "via Kickstarter"
  /// - **de**: "über Kickstarter"
  /// - **es**: "a través de Kickstarter"
  /// - **fr**: "Kickstarter"
  /// - **ja**: "kickstarterを経由"
  public static func via_kickstarter() -> String {
    return localizedString(
      key: "via_kickstarter",
      defaultValue: "via Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
}
