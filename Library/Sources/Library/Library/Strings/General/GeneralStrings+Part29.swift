// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "You’re offline. Once your device reconnects, navigate around the app to refresh."
  ///
  /// - **en**: "You’re offline. Once your device reconnects, navigate around the app to refresh."
  /// - **de**: "Du bist Offline. Sobald du wieder Online bist, navigiere in der App, um sie zu aktualisieren."
  /// - **es**: "Estás desconectado. Cuando tu dispositivo se vuelva a conectar, ve a la aplicación para actualizarla."
  /// - **fr**: "Vous êtes hors ligne. Dès que votre appareil se sera reconnecté, naviguez dans l'application pour la rafraîchir."
  /// - **ja**: "現在オフライン中です。デバイスが再接続し次第、アプリをリフレッシュしてください。"
  public static func Youre_offline() -> String {
    return localizedString(
      key: "Youre_offline",
      defaultValue: "You’re offline. Once your device reconnects, navigate around the app to refresh.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’ve been authenticated successfully! Pull to refresh."
  ///
  /// - **en**: "You’ve been authenticated successfully! Pull to refresh."
  /// - **de**: "Du wurdest erfolgreich authentifiziert! Ziehe, um die Seite zu aktualisieren."
  /// - **es**: "La autenticación se completó con éxito. Desliza para actualizar."
  /// - **fr**: "Vous avez été authentifié ! Veuillez tirer l'écran vers le bas pour l'actualiser."
  /// - **ja**: "認証が成功しました！画面をプルダウンして更新してください。"
  public static func Youve_been_authenticated_successfully_pull_to_refresh() -> String {
    return localizedString(
      key: "Youve_been_authenticated_successfully_pull_to_refresh",
      defaultValue: "You’ve been authenticated successfully! Pull to refresh.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Zip code"
  ///
  /// - **en**: "Zip code"
  /// - **de**: "Postleitzahl"
  /// - **es**: "Código postal"
  /// - **fr**: "Code postal"
  /// - **ja**: "郵便番号"
  public static func Zip_code() -> String {
    return localizedString(
      key: "Zip_code",
      defaultValue: "Zip code",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{activities_badge_value}+"
  ///
  /// - **en**: "%{activities_badge_value}+"
  /// - **de**: "%{activities_badge_value}+"
  /// - **es**: "%{activities_badge_value}+"
  /// - **fr**: "%{activities_badge_value}+"
  /// - **ja**: "%{activities_badge_value}+"
  public static func activities_badge_value_plus(activities_badge_value: String) -> String {
    return localizedString(
      key: "activities_badge_value_plus",
      defaultValue: "%{activities_badge_value}+",
      count: nil,
      substitutions: ["activities_badge_value": activities_badge_value]
    )
  }
  /// "days"
  ///
  /// - **en**: "days"
  /// - **de**: "Tg"
  /// - **es**: "días"
  /// - **fr**: "jours"
  /// - **ja**: "日"
  public static func days_other() -> String {
    return localizedString(
      key: "days.other",
      defaultValue: "days",
      count: nil,
      substitutions: [:]
    )
  }
  /// "days"
  ///
  /// - **en**: "days"
  /// - **de**: "Tg"
  /// - **es**: "días"
  /// - **fr**: "jours"
  /// - **ja**: "日"
  public static func days_plural() -> String {
    return localizedString(
      key: "days_plural",
      defaultValue: "days",
      count: nil,
      substitutions: [:]
    )
  }
  /// "…more"
  ///
  /// - **en**: "…more"
  /// - **de**: "... weiterlesen"
  /// - **es**: "... leer más"
  /// - **fr**: "... plus"
  /// - **ja**: "さらに表示"
  public static func ellipsis_more() -> String {
    return localizedString(
      key: "ellipsis_more",
      defaultValue: "…more",
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
  public static func general_alert_buttons_ok() -> String {
    return localizedString(
      key: "general.alert.buttons.ok",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{backer_count} backers"
  ///
  /// - **en**: "%{backer_count} backers"
  /// - **de**: "%{backer_count} Unterstützer"
  /// - **es**: "%{backer_count} patrocinadores"
  /// - **fr**: "%{backer_count} contributeurs"
  /// - **ja**: "%{backer_count} バッカー"
  public static func general_backer_count_backers(backer_count: Int) -> String {
    return localizedString(
      key: "general.backer_count_backers",
      defaultValue: "%{backer_count} backers",
      count: backer_count,
      substitutions: ["backer_count": Format.wholeNumber(backer_count)]
    )
  }
  /// "%{backer_count} backers"
  ///
  /// - **en**: "%{backer_count} backers"
  /// - **de**: "%{backer_count} Unterstützer"
  /// - **es**: "%{backer_count} patrocinadores"
  /// - **fr**: "%{backer_count} contributeurs"
  /// - **ja**: "%{backer_count} バッカー"
  public static func general_backer_count_backers_other(backer_count: String) -> String {
    return localizedString(
      key: "general.backer_count_backers.other",
      defaultValue: "%{backer_count} backers",
      count: nil,
      substitutions: ["backer_count": backer_count]
    )
  }
  /// "Oops!"
  ///
  /// - **en**: "Oops!"
  /// - **de**: "Huch!"
  /// - **es**: "¡Vaya!"
  /// - **fr**: "Oups !"
  /// - **ja**: "おっと！"
  public static func general_error_oops() -> String {
    return localizedString(
      key: "general.error.oops",
      defaultValue: "Oops!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Something went wrong."
  ///
  /// - **en**: "Something went wrong."
  /// - **de**: "Da hat etwas nicht geklappt."
  /// - **es**: "Algo pasó aquí."
  /// - **fr**: "Un erreur s'est produite."
  /// - **ja**: "問題が発生しました。"
  public static func general_error_something_wrong() -> String {
    return localizedString(
      key: "general.error.something_wrong",
      defaultValue: "Something went wrong.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Loading..."
  ///
  /// - **en**: "Loading..."
  /// - **de**: "Wird geladen ..."
  /// - **es**: "Cargando..."
  /// - **fr**: "Chargement en cours..."
  /// - **ja**: "読み込み中"
  public static func general_loading() -> String {
    return localizedString(
      key: "general.loading",
      defaultValue: "Loading...",
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
  public static func general_navigation_buttons_cancel() -> String {
    return localizedString(
      key: "general.navigation.buttons.cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Close"
  ///
  /// - **en**: "Close"
  /// - **de**: "Schließen"
  /// - **es**: "Cerrar"
  /// - **fr**: "Fermer"
  /// - **ja**: "閉じる"
  public static func general_navigation_buttons_close() -> String {
    return localizedString(
      key: "general.navigation.buttons.close",
      defaultValue: "Close",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Done"
  ///
  /// - **en**: "Done"
  /// - **de**: "Fertig"
  /// - **es**: "Listo"
  /// - **fr**: "Terminé"
  /// - **ja**: "完了"
  public static func general_navigation_buttons_done() -> String {
    return localizedString(
      key: "general.navigation.buttons.done",
      defaultValue: "Done",
      count: nil,
      substitutions: [:]
    )
  }
}
