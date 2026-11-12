// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Yes, cancel it"
  ///
  /// - **en**: "Yes, cancel it"
  /// - **de**: "Ja, abbrechen"
  /// - **es**: "Sí, cancelar"
  /// - **fr**: "Oui, annuler"
  /// - **ja**: "はい、取り消します"
  public static func Yes_cancel_it() -> String {
    return localizedString(
      key: "Yes_cancel_it",
      defaultValue: "Yes, cancel it",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Yes, continue"
  ///
  /// - **en**: "Yes, continue"
  /// - **de**: "Ja, weiter"
  /// - **es**: "Sí, continuar"
  /// - **fr**: "Oui, continuer"
  /// - **ja**: "はい、続行します"
  public static func Yes_continue() -> String {
    return localizedString(
      key: "Yes_continue",
      defaultValue: "Yes, continue",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Yes, remove"
  ///
  /// - **en**: "Yes, remove"
  /// - **de**: "Ja, entfernen"
  /// - **es**: "Sí, eliminar"
  /// - **fr**: "Oui, supprimer"
  /// - **ja**: "はい、削除します"
  public static func Yes_remove() -> String {
    return localizedString(
      key: "Yes_remove",
      defaultValue: "Yes, remove",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Yes, turn off"
  ///
  /// - **en**: "Yes, turn off"
  /// - **de**: "Ja, deaktivieren"
  /// - **es**: "Sí, desactivar"
  /// - **fr**: "Oui, désactiver"
  /// - **ja**: "はい、オフにします"
  public static func Yes_turn_off() -> String {
    return localizedString(
      key: "Yes_turn_off",
      defaultValue: "Yes, turn off",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You"
  ///
  /// - **en**: "You"
  /// - **de**: "Du"
  /// - **es**: "Tú"
  /// - **fr**: "Vous"
  /// - **ja**: "あなた"
  public static func You() -> String {
    return localizedString(
      key: "You",
      defaultValue: "You",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You Launched!"
  ///
  /// - **en**: "You Launched!"
  /// - **de**: "Dein Projekt ist live!"
  /// - **es**: "¡Tu proyecto fue publicado!"
  /// - **fr**: "Projet lancé !"
  /// - **ja**: "発表されました！"
  public static func You_Launched() -> String {
    return localizedString(
      key: "You_Launched",
      defaultValue: "You Launched!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You backed"
  ///
  /// - **en**: "You backed"
  /// - **de**: "Deine unterstützten Projekte"
  /// - **es**: "Patrocinaste"
  /// - **fr**: "Projet soutenu"
  /// - **ja**: "あなたがバックしたプロジェクト"
  public static func You_backed() -> String {
    return localizedString(
      key: "You_backed",
      defaultValue: "You backed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You backed this project."
  ///
  /// - **en**: "You backed this project."
  /// - **de**: "Du hast dieses Projekt unterstützt."
  /// - **es**: "Patrocinaste este proyecto."
  /// - **fr**: "Vous avez soutenu ce projet."
  /// - **ja**: "バック済"
  public static func You_backed_this_project() -> String {
    return localizedString(
      key: "You_backed_this_project",
      defaultValue: "You backed this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You saved this project."
  ///
  /// - **en**: "You saved this project."
  /// - **de**: "Du hast dieses Projekt gespeichert."
  /// - **es**: "Uno de tus proyectos guardados."
  /// - **fr**: "Vous avez enregistré ce projet."
  /// - **ja**: "保存済みです"
  public static func You_saved_this_project() -> String {
    return localizedString(
      key: "You_saved_this_project",
      defaultValue: "You saved this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You'll receive an email at %{email} when your download is ready."
  ///
  /// - **en**: "You'll receive an email at %{email} when your download is ready."
  /// - **de**: "Du wirst per E-Mail unter %{email} benachrichtigt, sobald dein Download bereit ist."
  /// - **es**: "Recibirás un correo electrónico en %{email} cuando la descarga esté lista."
  /// - **fr**: "Dès que votre téléchargement sera prêt, vous recevrez un e-mail à l'adresse %{email}."
  /// - **ja**: "ダウンロードの準備が整い次第、%{email} にメールが届きます。"
  public static func Youll_receive_an_email_at_email_when_your_download_is_ready(email: String) -> String {
    return localizedString(
      key: "Youll_receive_an_email_at_email_when_your_download_is_ready",
      defaultValue: "You'll receive an email at %{email} when your download is ready.",
      count: nil,
      substitutions: ["email": email]
    )
  }
  /// "Your name is always displayed on your profile."
  ///
  /// - **en**: "Your name is always displayed on your profile."
  /// - **de**: "Dein Name wird auf deinem Profil angezeigt."
  /// - **es**: "Tu nombre siempre se muestra en tu perfil."
  /// - **fr**: "Votre nom s'affichera toujours sur votre profil."
  /// - **ja**: "あなたの名前はプロフィールに常に表示されます。"
  public static func Your_name_displayed() -> String {
    return localizedString(
      key: "Your_name_displayed",
      defaultValue: "Your name is always displayed on your profile.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your selection"
  ///
  /// - **en**: "Your selection"
  /// - **de**: "Deine Auswahl"
  /// - **es**: "Tu selección"
  /// - **fr**: "Votre sélection"
  /// - **ja**: "選択内容"
  public static func Your_selection() -> String {
    return localizedString(
      key: "Your_selection",
      defaultValue: "Your selection",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’re a backer!"
  ///
  /// - **en**: "You’re a backer!"
  /// - **de**: "Du unterstützt das Projekt!"
  /// - **es**: "¡Eres un patrocinador!"
  /// - **fr**: "Vous êtes contributeur !"
  /// - **ja**: "バッカーになりました！"
  public static func Youre_a_backer() -> String {
    return localizedString(
      key: "Youre_a_backer",
      defaultValue: "You’re a backer!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You're a backer"
  ///
  /// - **en**: "You're a backer"
  /// - **de**: "Du bist ein Unterstützer"
  /// - **es**: "Eres patrocinador"
  /// - **fr**: "Vous êtes contributeur"
  /// - **ja**: "バック中"
  public static func Youre_a_backer_no_punctuation() -> String {
    return localizedString(
      key: "Youre_a_backer_no_punctuation",
      defaultValue: "You're a backer",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’re all caught up!"
  ///
  /// - **en**: "You’re all caught up!"
  /// - **de**: "Alles erledigt!"
  /// - **es**: "¡Todo listo!"
  /// - **fr**: "C'est tout bon !"
  /// - **ja**: "アラートは以上です！"
  public static func Youre_all_caught_up() -> String {
    return localizedString(
      key: "Youre_all_caught_up",
      defaultValue: "You’re all caught up!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’re all set"
  ///
  /// - **en**: "You’re all set"
  /// - **de**: "Alles klar"
  /// - **es**: "Ya está todo listo"
  /// - **fr**: "C'est tout bon"
  /// - **ja**: "完了です"
  public static func Youre_all_set() -> String {
    return localizedString(
      key: "Youre_all_set",
      defaultValue: "You’re all set",
      count: nil,
      substitutions: [:]
    )
  }
}
