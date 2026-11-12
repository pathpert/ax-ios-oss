// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Help"
  ///
  /// - **en**: "Help"
  /// - **de**: "Hilfe"
  /// - **es**: "Ayuda"
  /// - **fr**: "Aide"
  /// - **ja**: "ヘルプ"
  public static func general_navigation_buttons_help() -> String {
    return localizedString(
      key: "general.navigation.buttons.help",
      defaultValue: "Help",
      count: nil,
      substitutions: [:]
    )
  }
  /// "OK"
  ///
  /// - **en**: "OK"
  /// - **de**: "OK"
  /// - **es**: "OK"
  /// - **fr**: "OK"
  /// - **ja**: "OK"
  public static func general_navigation_buttons_ok() -> String {
    return localizedString(
      key: "general.navigation.buttons.ok",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Preview"
  ///
  /// - **en**: "Preview"
  /// - **de**: "Vorschau"
  /// - **es**: "Vista previa"
  /// - **fr**: "Aperçu"
  /// - **ja**: "プレビュー"
  public static func general_navigation_buttons_preview() -> String {
    return localizedString(
      key: "general.navigation.buttons.preview",
      defaultValue: "Preview",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Publish!"
  ///
  /// - **en**: "Publish!"
  /// - **de**: "Jetzt veröffentlichen!"
  /// - **es**: "¡Publicar!"
  /// - **fr**: "Publier !"
  /// - **ja**: "公開！"
  public static func general_navigation_buttons_publish() -> String {
    return localizedString(
      key: "general.navigation.buttons.publish",
      defaultValue: "Publish!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Skip"
  ///
  /// - **en**: "Skip"
  /// - **de**: "Überspringen"
  /// - **es**: "Saltar"
  /// - **fr**: "Ignorer"
  /// - **ja**: "スキップ"
  public static func general_navigation_buttons_skip() -> String {
    return localizedString(
      key: "general.navigation.buttons.skip",
      defaultValue: "Skip",
      count: nil,
      substitutions: [:]
    )
  }
  /// "OFF"
  ///
  /// - **en**: "OFF"
  /// - **de**: "NEIN"
  /// - **es**: "NO"
  /// - **fr**: "OFF"
  /// - **ja**: "OFF"
  public static func general_switch_toggle_off() -> String {
    return localizedString(
      key: "general.switch_toggle_off",
      defaultValue: "OFF",
      count: nil,
      substitutions: [:]
    )
  }
  /// "ON"
  ///
  /// - **en**: "ON"
  /// - **de**: "JA"
  /// - **es**: "SÍ"
  /// - **fr**: "ON"
  /// - **ja**: "ON"
  public static func general_switch_toggle_on() -> String {
    return localizedString(
      key: "general.switch_toggle_on",
      defaultValue: "ON",
      count: nil,
      substitutions: [:]
    )
  }
  /// "hours"
  ///
  /// - **en**: "hours"
  /// - **de**: "Stunden"
  /// - **es**: "horas"
  /// - **fr**: "heures"
  /// - **ja**: "時間"
  public static func hours_other() -> String {
    return localizedString(
      key: "hours.other",
      defaultValue: "hours",
      count: nil,
      substitutions: [:]
    )
  }
  /// "hours"
  ///
  /// - **en**: "hours"
  /// - **de**: "Std"
  /// - **es**: "horas"
  /// - **fr**: "heures"
  /// - **ja**: "時間"
  public static func hours_plural() -> String {
    return localizedString(
      key: "hours_plural",
      defaultValue: "hours",
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
  public static func invalid_api_client_alert_cancel() -> String {
    return localizedString(
      key: "invalid_api_client_alert.cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Please Upgrade"
  ///
  /// - **en**: "Please Upgrade"
  /// - **de**: "Bitte aktualisieren"
  /// - **es**: "Por favor actualizar"
  /// - **fr**: "Veuillez mettre à jour"
  /// - **ja**: "アップグレードしてください"
  public static func invalid_api_client_alert_title() -> String {
    return localizedString(
      key: "invalid_api_client_alert.title",
      defaultValue: "Please Upgrade",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Upgrade"
  ///
  /// - **en**: "Upgrade"
  /// - **de**: "Aktualisierung"
  /// - **es**: "Actualizar"
  /// - **fr**: "Mise à jour"
  /// - **ja**: "アップグレード"
  public static func invalid_api_client_alert_upgrade() -> String {
    return localizedString(
      key: "invalid_api_client_alert.upgrade",
      defaultValue: "Upgrade",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{likes_count} like"
  ///
  /// - **en**: "%{likes_count} like"
  /// - **de**: "%{likes_count} Person gefällt das"
  /// - **es**: "A %{likes_count} persona le gusta"
  /// - **fr**: "%{likes_count} mention J'aime"
  /// - **ja**: "いいね！%{likes_count}件"
  public static func likes_count_likes(likes_count: Int) -> String {
    return localizedString(
      key: "likes_count_likes",
      defaultValue: "%{likes_count} like",
      count: likes_count,
      substitutions: ["likes_count": Format.wholeNumber(likes_count)]
    )
  }
  /// "%{likes_count} likes"
  ///
  /// - **en**: "%{likes_count} likes"
  /// - **de**: "%{likes_count} Personen gefällt das"
  /// - **es**: "A %{likes_count} personas les gusta"
  /// - **fr**: "%{likes_count} mentions J'aime"
  /// - **ja**: "いいね！%{likes_count}件"
  public static func likes_count_likes_other(likes_count: String) -> String {
    return localizedString(
      key: "likes_count_likes.other",
      defaultValue: "%{likes_count} likes",
      count: nil,
      substitutions: ["likes_count": likes_count]
    )
  }
  /// "Limit %{limit_per_backer}"
  ///
  /// - **en**: "Limit %{limit_per_backer}"
  /// - **de**: "Max. %{limit_per_backer}"
  /// - **es**: "Límite %{limit_per_backer}"
  /// - **fr**: "Limite de %{limit_per_backer}"
  /// - **ja**: "1人限定%{limit_per_backer}個"
  public static func limit_limit_per_backer(limit_per_backer: String) -> String {
    return localizedString(
      key: "limit_limit_per_backer",
      defaultValue: "Limit %{limit_per_backer}",
      count: nil,
      substitutions: ["limit_per_backer": limit_per_backer]
    )
  }
  /// "%{location_name} only"
  ///
  /// - **en**: "%{location_name} only"
  /// - **de**: "Nur %{location_name}"
  /// - **es**: "Sólo %{location_name}"
  /// - **fr**: "%{location_name} seulement"
  /// - **ja**: "%{location_name} のみ"
  public static func location_name_only(location_name: String) -> String {
    return localizedString(
      key: "location_name_only",
      defaultValue: "%{location_name} only",
      count: nil,
      substitutions: ["location_name": location_name]
    )
  }
}
