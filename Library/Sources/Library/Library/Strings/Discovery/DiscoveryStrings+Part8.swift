// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "To use this feature, go to your iPhone settings and turn Location Services ON for Kickstarter."
  ///
  /// - **en**: "To use this feature, go to your iPhone settings and turn Location Services ON for Kickstarter."
  /// - **de**: "Um diese Funktion zu nutzen, aktiviere Ortungsdienste für Kickstarter in deinen iPhone Einstellungen."
  /// - **es**: "Para utilizar esta función, ve a la configuración de tu iPhone y activa los Servicios de Ubicación para Kickstarter."
  /// - **fr**: "Pour utiliser cette fonction, veuillez activer le Service de localisation pour Kickstarter dans les Réglages de votre iPhone."
  /// - **ja**: "この機能を使用するには、iPhoneの設定を開き、Kickstarterの位置情報サービスをオンにします"
  public static func discovery_location_disabled_state_message() -> String {
    return localizedString(
      key: "discovery.location.disabled_state.message",
      defaultValue: "To use this feature, go to your iPhone settings and turn Location Services ON for Kickstarter.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Turn on location services"
  ///
  /// - **en**: "Turn on location services"
  /// - **de**: "Ortungsdienste aktivieren"
  /// - **es**: "Activar servicios de ubicación"
  /// - **fr**: "Activer le Service de localisation"
  /// - **ja**: "位置情報サービスをオン"
  public static func discovery_location_disabled_state_title() -> String {
    return localizedString(
      key: "discovery.location.disabled_state.title",
      defaultValue: "Turn on location services",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Nearby"
  ///
  /// - **en**: "Nearby"
  /// - **de**: "Projekte in deiner Nähe"
  /// - **es**: "Cerca de ti"
  /// - **fr**: "Projets à proximité"
  /// - **ja**: "近くにいる人"
  public static func discovery_nearby() -> String {
    return localizedString(
      key: "discovery.nearby",
      defaultValue: "Nearby",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Learn more"
  ///
  /// - **en**: "Learn more"
  /// - **de**: "Weitere Info"
  /// - **es**: "Más información"
  /// - **fr**: "En savoir plus"
  /// - **ja**: "さらにみる"
  public static func discovery_onboarding_buttons_learn_more() -> String {
    return localizedString(
      key: "discovery.onboarding.buttons.learn_more",
      defaultValue: "Learn more",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Login"
  ///
  /// - **en**: "Login"
  /// - **de**: "Anmelden"
  /// - **es**: "Iniciar sesión"
  /// - **fr**: "Connexion"
  /// - **ja**: "ログイン"
  public static func discovery_onboarding_buttons_login() -> String {
    return localizedString(
      key: "discovery.onboarding.buttons.login",
      defaultValue: "Login",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sign up or Log in"
  ///
  /// - **en**: "Sign up or Log in"
  /// - **de**: "Registrieren oder Anmelden"
  /// - **es**: "Regístrate o Inicia sesión"
  /// - **fr**: "Inscription ou connexion"
  /// - **ja**: "サインアップまたはログイン"
  public static func discovery_onboarding_buttons_signup_or_login() -> String {
    return localizedString(
      key: "discovery.onboarding.buttons.signup_or_login",
      defaultValue: "Sign up or Log in",
      count: nil,
      substitutions: [:]
    )
  }
  /// "or"
  ///
  /// - **en**: "or"
  /// - **de**: "oder"
  /// - **es**: "o"
  /// - **fr**: "ou"
  /// - **ja**: "か"
  public static func discovery_onboarding_learn_login_conjunction_or() -> String {
    return localizedString(
      key: "discovery.onboarding.learn_login_conjunction_or",
      defaultValue: "or",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Bring creative projects to life"
  ///
  /// - **en**: "Bring creative projects to life"
  /// - **de**: "Du kannst kreative Projekte ins Leben rufen!"
  /// - **es**: "Dale vida a proyectos creativos"
  /// - **fr**: "Soutenez des projets créatifs"
  /// - **ja**: "クリエイティブなプロジェクトに生命を。"
  public static func discovery_onboarding_title_bring_creative_projects_to_life() -> String {
    return localizedString(
      key: "discovery.onboarding.title.bring_creative_projects_to_life",
      defaultValue: "Bring creative projects to life",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Popular"
  ///
  /// - **en**: "Popular"
  /// - **de**: "Beliebte Projekte"
  /// - **es**: "Popular"
  /// - **fr**: "Tendances"
  /// - **ja**: "人気"
  public static func discovery_popular() -> String {
    return localizedString(
      key: "discovery.popular",
      defaultValue: "Popular",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Staff Picks"
  ///
  /// - **en**: "Staff Picks"
  /// - **de**: "Team-Favoriten"
  /// - **es**: "Nuestros favoritos"
  /// - **fr**: "Nos sélections"
  /// - **ja**: "スタッフ一押し"
  public static func discovery_recommended() -> String {
    return localizedString(
      key: "discovery.recommended",
      defaultValue: "Staff Picks",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recommended for you"
  ///
  /// - **en**: "Recommended for you"
  /// - **de**: "Empfehlungen für dich"
  /// - **es**: "Recomendaciones"
  /// - **fr**: "Rien que pour vous"
  /// - **ja**: "おすすめ"
  public static func discovery_recommended_for_you() -> String {
    return localizedString(
      key: "discovery.recommended_for_you",
      defaultValue: "Recommended for you",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Starred"
  ///
  /// - **en**: "Starred"
  /// - **de**: "Meine Favoriten"
  /// - **es**: "Los más destacados"
  /// - **fr**: "Projets préférés"
  /// - **ja**: "スター"
  public static func discovery_saved() -> String {
    return localizedString(
      key: "discovery.saved",
      defaultValue: "Starred",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cancel"
  ///
  /// - **en**: "Cancel"
  /// - **de**: "Abbrechen"
  /// - **es**: "Cancelar"
  /// - **fr**: "Annuler"
  /// - **ja**: "キャンセル"
  public static func discovery_search_cancel() -> String {
    return localizedString(
      key: "discovery.search_cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "End Date"
  ///
  /// - **en**: "End Date"
  /// - **de**: "Enddatum"
  /// - **es**: "Fecha de terminación"
  /// - **fr**: "Date de fin"
  /// - **ja**: "終了日"
  public static func discovery_sort_types_end_date() -> String {
    return localizedString(
      key: "discovery.sort_types.end_date",
      defaultValue: "End Date",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Magic"
  ///
  /// - **en**: "Magic"
  /// - **de**: "Zufall"
  /// - **es**: "Arte de magia"
  /// - **fr**: "Magie"
  /// - **ja**: "マジック"
  public static func discovery_sort_types_magic() -> String {
    return localizedString(
      key: "discovery.sort_types.magic",
      defaultValue: "Magic",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Most Backed"
  ///
  /// - **en**: "Most Backed"
  /// - **de**: "Meist unterstüzt"
  /// - **es**: "número de patrocinadores"
  /// - **fr**: "Nombre d'engagements"
  /// - **ja**: "バッカー最多数"
  public static func discovery_sort_types_most_backed() -> String {
    return localizedString(
      key: "discovery.sort_types.most_backed",
      defaultValue: "Most Backed",
      count: nil,
      substitutions: [:]
    )
  }
}
