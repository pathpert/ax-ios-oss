// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "OK"
  ///
  /// - **en**: "OK"
  /// - **de**: "OK"
  /// - **es**: "Ok"
  /// - **fr**: "OK"
  /// - **ja**: "OK"
  public static func project_checkout_share_alert_button_ok() -> String {
    return localizedString(
      key: "project.checkout.share.alert.button.ok",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This device is not capable of sending email."
  ///
  /// - **en**: "This device is not capable of sending email."
  /// - **de**: "Dieses Gerät kann keine E-Mails versenden."
  /// - **es**: "Este dispositivo no puede enviar correos."
  /// - **fr**: "Impossible d'envoyer un e-mail à partir de cet appareil."
  /// - **ja**: "お使いの端末ではメールを送信できません。"
  public static func project_checkout_share_alert_this_device_not_capable_of_sending_email() -> String {
    return localizedString(
      key: "project.checkout.share.alert.this_device_not_capable_of_sending_email",
      defaultValue: "This device is not capable of sending email.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More"
  ///
  /// - **en**: "More"
  /// - **de**: "Mehr"
  /// - **es**: "Más"
  /// - **fr**: "Plus"
  /// - **ja**: "More"
  public static func project_checkout_share_buttons_more() -> String {
    return localizedString(
      key: "project.checkout.share.buttons.more",
      defaultValue: "More",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More share options"
  ///
  /// - **en**: "More share options"
  /// - **de**: "Weitere Optionen"
  /// - **es**: "Más opciones para compartir"
  /// - **fr**: "Plus de fonctions de partage"
  /// - **ja**: "他のシェアを選択"
  public static func project_checkout_share_buttons_more_share_options() -> String {
    return localizedString(
      key: "project.checkout.share.buttons.more_share_options",
      defaultValue: "More share options",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Share"
  ///
  /// - **en**: "Share"
  /// - **de**: "Teilen"
  /// - **es**: "Compartir"
  /// - **fr**: "Partager"
  /// - **ja**: "シェア"
  public static func project_checkout_share_buttons_share() -> String {
    return localizedString(
      key: "project.checkout.share.buttons.share",
      defaultValue: "Share",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tweet"
  ///
  /// - **en**: "Tweet"
  /// - **de**: "Twittern"
  /// - **es**: "Tweet"
  /// - **fr**: "Twitter"
  /// - **ja**: "ツイート"
  public static func project_checkout_share_buttons_tweet() -> String {
    return localizedString(
      key: "project.checkout.share.buttons.tweet",
      defaultValue: "Tweet",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Woo-hoo!"
  ///
  /// - **en**: "Woo-hoo!"
  /// - **de**: "Super!"
  /// - **es**: "Yu-Juu!"
  /// - **fr**: "Félicitations !"
  /// - **ja**: "ありがとうございます。"
  public static func project_checkout_share_exclamation() -> String {
    return localizedString(
      key: "project.checkout.share.exclamation",
      defaultValue: "Woo-hoo!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "OK"
  ///
  /// - **en**: "OK"
  /// - **de**: "OK"
  /// - **es**: "Ok"
  /// - **fr**: "OK"
  /// - **ja**: "OK"
  public static func project_checkout_share_link_OK() -> String {
    return localizedString(
      key: "project.checkout.share.link.OK",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The project’s URL has been copied to your clipboard:
  ///
  /// project_url}"
  ///
  /// - **en**: "The project’s URL has been copied to your clipboard:
  ///
  /// project_url}"
  /// - **de**: "Die URL des Projekts wure in die Zwischenablage kopiert:
  ///
  /// project_url}"
  /// - **es**: "El URL del proyecto ha sido copiado en tu portapapeles:
  ///
  /// project_url}"
  /// - **fr**: "L'URL du projet a été copiée dans votre presse-papier :
  ///
  /// project_url}"
  /// - **ja**: "プロジェクトのURLをコピーしました：
  ///
  /// project_url}"
  public static func project_checkout_share_link_the_project_url_has_been_copied_to_your_clipboard(project_url: String) -> String {
    return localizedString(
      key: "project.checkout.share.link.the_project_url_has_been_copied_to_your_clipboard",
      defaultValue: "The project’s URL has been copied to your clipboard:\n\n%{project_url}",
      count: nil,
      substitutions: ["project_url": project_url]
    )
  }
  /// "The update’s URL has been copied to your clipboard:
  ///
  /// update_url}"
  ///
  /// - **en**: "The update’s URL has been copied to your clipboard:
  ///
  /// update_url}"
  /// - **de**: "Die URL des Updates wurde in die Zwischenablage kopiert:
  ///
  /// update_url}"
  /// - **es**: "El URL de la actualización ha sido copiado en tu portapapeles:
  ///
  /// update_url}"
  /// - **fr**: "L'URL de l'actu a été copiée dans votre presse-papier :
  /// update_url}"
  /// - **ja**: "更新したURLをコピーしました：
  ///
  /// update_url}"
  public static func project_checkout_share_link_the_update_url_has_been_copied_to_your_clipboard(update_url: String) -> String {
    return localizedString(
      key: "project.checkout.share.link.the_update_url_has_been_copied_to_your_clipboard",
      defaultValue: "The update’s URL has been copied to your clipboard:\n\n%{update_url}",
      count: nil,
      substitutions: ["update_url": update_url]
    )
  }
  /// "%{project_or_update_title}, via Kickstarter"
  ///
  /// - **en**: "%{project_or_update_title}, via Kickstarter"
  /// - **de**: "%{project_or_update_title}, über Kickstarter"
  /// - **es**: "%{project_or_update_title}, vía Kickstarter"
  /// - **fr**: "%{project_or_update_title}, via Kickstarter"
  /// - **ja**: "Kickstarterの%{project_or_update_title}"
  public static func project_checkout_share_title_via_kickstarter(project_or_update_title: String) -> String {
    return localizedString(
      key: "project.checkout.share.title_via_kickstarter",
      defaultValue: "%{project_or_update_title}, via Kickstarter",
      count: nil,
      substitutions: ["project_or_update_title": project_or_update_title]
    )
  }
  /// "I just backed %{project_name} on @Kickstarter"
  ///
  /// - **en**: "I just backed %{project_name} on @Kickstarter"
  /// - **de**: "Ich unterstütze jetzt %{project_name} auf @Kickstarter"
  /// - **es**: "Acabo de patrocinar %{project_name} en @Kickstarter"
  /// - **fr**: "Je viens de soutenir le projet %{project_name} sur @Kickstarter"
  /// - **ja**: "%{project_name} を @Kickstarter_JP でバックしました"
  public static func project_checkout_share_twitter_I_just_backed_project_on_kickstarter(project_name: String) -> String {
    return localizedString(
      key: "project.checkout.share.twitter.I_just_backed_project_on_kickstarter",
      defaultValue: "I just backed %{project_name} on @Kickstarter",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "%{project_or_update_title}, via Kickstarter"
  ///
  /// - **en**: "%{project_or_update_title}, via Kickstarter"
  /// - **de**: "%{project_or_update_title}, über Kickstarter"
  /// - **es**: "%{project_or_update_title}, via Kickstarter"
  /// - **fr**: "%{project_or_update_title}, via Kickstarter"
  /// - **ja**: "Kickstarterの%{project_or_update_title}"
  public static func project_checkout_share_twitter_via_kickstarter(project_or_update_title: String) -> String {
    return localizedString(
      key: "project.checkout.share.twitter_via_kickstarter",
      defaultValue: "%{project_or_update_title}, via Kickstarter",
      count: nil,
      substitutions: ["project_or_update_title": project_or_update_title]
    )
  }
  /// "You just backed %{project_name}. Share this project with friends to help it along!"
  ///
  /// - **en**: "You just backed %{project_name}. Share this project with friends to help it along!"
  /// - **de**: "Du hast gerade %{project_name} unterstützt. Erzähle deinen Freunden von diesem Projekt, um es weiter zu fördern!"
  /// - **es**: "Acabas de patrocinar a %{project_name}. ¡Comparte este proyecto con amigos para echarle una mano!"
  /// - **fr**: "Vous venez de soutenir le projet %{project_name}. Partagez-le avec vos amis pour l'aider à avancer !"
  /// - **ja**: "%{project_name} をバックしました。プロジェクトをシェアして友達に伝えよう！"
  public static func project_checkout_share_you_just_backed_project_share_this_project(project_name: String) -> String {
    return localizedString(
      key: "project.checkout.share.you_just_backed_project_share_this_project",
      defaultValue: "You just backed %{project_name}. Share this project with friends to help it along!",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
}
