// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProfileStrings {
  /// "Remind Me Later"
  ///
  /// - **en**: "Remind Me Later"
  /// - **de**: "Später"
  /// - **es**: "Recordarme más tarde"
  /// - **fr**: "Rappelez-moi plus tard"
  /// - **ja**: "あとでする"
  public static func profile_settings_rating_option_remind_later() -> String {
    return localizedString(
      key: "profile.settings.rating.option.remind_later",
      defaultValue: "Remind Me Later",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Show us some love"
  ///
  /// - **en**: "Show us some love"
  /// - **de**: "Dir gefällt die App?"
  /// - **es**: "¿Te gusta la app de Kickstarter?"
  /// - **fr**: "Parlez de nous autour de vous"
  /// - **ja**: "愛を見せて"
  public static func profile_settings_rating_option_title_show_us_some_love() -> String {
    return localizedString(
      key: "profile.settings.rating.option.title_show_us_some_love",
      defaultValue: "Show us some love",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rate us in the App Store!"
  ///
  /// - **en**: "Rate us in the App Store!"
  /// - **de**: "Bewerte uns im App Store!"
  /// - **es**: "¡Califícanos en la App Store!"
  /// - **fr**: "Évaluez-nous dans l'App Store !"
  /// - **ja**: "App Storeで評価してください！"
  public static func profile_settings_rating_rate_us() -> String {
    return localizedString(
      key: "profile.settings.rating.rate_us",
      defaultValue: "Rate us in the App Store!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rate us in the Play Store!"
  ///
  /// - **en**: "Rate us in the Play Store!"
  /// - **de**: "Bewerte uns im Play Store!"
  /// - **es**: "¡Califícanos en el Play Store!"
  /// - **fr**: "Évaluez-nous dans le Play Store !"
  /// - **ja**: "Play Storeで評価してください！"
  public static func profile_settings_rating_rate_us_play_store() -> String {
    return localizedString(
      key: "profile.settings.rating.rate_us_play_store",
      defaultValue: "Rate us in the Play Store!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We’re all ears!"
  ///
  /// - **en**: "We’re all ears!"
  /// - **de**: "Wir sind ganz Ohr!"
  /// - **es**: "¡Somos todo oídos!"
  /// - **fr**: "Nous sommes tout ouïe !"
  /// - **ja**: "ありがとうございます！"
  public static func profile_settings_rating_title() -> String {
    return localizedString(
      key: "profile.settings.rating.title",
      defaultValue: "We’re all ears!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Version %{version_number}"
  ///
  /// - **en**: "Version %{version_number}"
  /// - **de**: "Version %{version_number}"
  /// - **es**: "Versión %{version_number}"
  /// - **fr**: "Version %{version_number}"
  /// - **ja**: "Ver.%{version_number}"
  public static func profile_settings_version_number(version_number: String) -> String {
    return localizedString(
      key: "profile.settings.version_number",
      defaultValue: "Version %{version_number}",
      count: nil,
      substitutions: ["version_number": version_number]
    )
  }
}
