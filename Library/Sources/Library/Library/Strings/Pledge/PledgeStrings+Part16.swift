// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Your payment method will not be charged at this time. If the project is successfully funded, your card will be charged %{charge_amount} when the project ends."
  ///
  /// - **en**: "Your payment method will not be charged at this time. If the project is successfully funded, your card will be charged %{charge_amount} when the project ends."
  /// - **de**: "Deine Zahlungsmethode wird jetzt noch nicht belastet. Erst nachdem das Projekt erfolgreich finanziert wurde, wird sie nach Ablauf desselben mit %{charge_amount} belastet."
  /// - **es**: "Todavía no se le hará ningún cargo a tu método de pago. Se efectuará un cargo de %{charge_amount} una vez que el proyecto haya sido financiado exitosamente."
  /// - **fr**: "Votre moyen de paiement ne sera pas débité tout de suite. Si le projet est intégralement financé, votre carte sera débitée de %{charge_amount} en fin de campagne."
  /// - **ja**: "現時点で請求が発生することはありません。目標額を達成した場合のみ、カードに %{charge_amount} が請求されます。"
  public static func project_checkout_android_pay_pledged_disclaimer(charge_amount: String) -> String {
    return localizedString(
      key: "project.checkout.android_pay.pledged_disclaimer",
      defaultValue: "Your payment method will not be charged at this time. If the project is successfully funded, your card will be charged %{charge_amount} when the project ends.",
      count: nil,
      substitutions: ["charge_amount": charge_amount]
    )
  }
  /// "By pledging you agree to Kickstarter's <u>terms of use</u> and <u>privacy policy</u>."
  ///
  /// - **en**: "By pledging you agree to Kickstarter's <u>terms of use</u> and <u>privacy policy</u>."
  /// - **de**: "Durch Leistung deines Beitrags erklärst du dich mit Kickstarters <u>terms of use</u> und <u>privacy policy</u> einverstanden."
  /// - **es**: "Al contribuir, aceptas los <u>terms of use</u> y la <u>privacy policy</u> de Kickstarter."
  /// - **fr**: "En vous engageant, vous acceptez les <u>conditions d'utilisation</u> et la <u>politique de confidentialité</u> de Kickstarter."
  /// - **ja**: "プレッジはKickstarterの<u>terms of use</u>と<u>プライバシーポリシー</u>に同意したことになります。"
  public static func project_checkout_android_pay_terms_and_privacy() -> String {
    return localizedString(
      key: "project.checkout.android_pay.terms_and_privacy",
      defaultValue: "By pledging you agree to Kickstarter's <u>terms of use</u> and <u>privacy policy</u>.",
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
  public static func project_checkout_apple_pay_alert_button_ok() -> String {
    return localizedString(
      key: "project.checkout.apple_pay.alert.button.ok",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Error"
  ///
  /// - **en**: "Error"
  /// - **de**: "Fehler"
  /// - **es**: "Error"
  /// - **fr**: "Erreur"
  /// - **ja**: "エラー"
  public static func project_checkout_apple_pay_alert_error() -> String {
    return localizedString(
      key: "project.checkout.apple_pay.alert.error",
      defaultValue: "Error",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Back this project"
  ///
  /// - **en**: "Back this project"
  /// - **de**: "Dieses Projekt unterstützen"
  /// - **es**: "Patrocinar este proyecto"
  /// - **fr**: "Je soutiens ce projet"
  /// - **ja**: "バックする"
  public static func project_checkout_backing_navbar_title() -> String {
    return localizedString(
      key: "project.checkout.backing.navbar_title",
      defaultValue: "Back this project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Return to project"
  ///
  /// - **en**: "Return to project"
  /// - **de**: "Zurück zum Projekt"
  /// - **es**: "Volver al proyecto"
  /// - **fr**: "Revenir au projet"
  /// - **ja**: "プロジェクトに戻る"
  public static func project_checkout_finalizing_failed_button() -> String {
    return localizedString(
      key: "project.checkout.finalizing.failed.button",
      defaultValue: "Return to project",
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
  public static func project_checkout_finalizing_timeout_button() -> String {
    return localizedString(
      key: "project.checkout.finalizing.timeout.button",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "How embarrassing. This appears to be taking longer than usual. We will email you once your pledge is finalized."
  ///
  /// - **en**: "How embarrassing. This appears to be taking longer than usual. We will email you once your pledge is finalized."
  /// - **de**: "Wie peinlich! Dieser Vorgang scheint länger zu dauern als üblich. Wir schicken dir eine E-Mail, sobald dein Finanzierungsbeitrag bearbeitet ist."
  /// - **es**: "¡Qué pena! Parece que está tardando más de lo normal. Te enviaremos un correo electrónico una vez que haya finalizado tu contribución."
  /// - **fr**: "Nous sommes désolés. On dirait que cette opération prend plus de temps que d'habitude. Nous vous enverrons un e-mail une fois votre engagement finalisé."
  /// - **ja**: "申し訳ございまません。通常より処理に時間がかかっています。プレッジが確定しましたら、メールを送信します。"
  public static func project_checkout_finalizing_timeout_message() -> String {
    return localizedString(
      key: "project.checkout.finalizing.timeout.message",
      defaultValue: "How embarrassing. This appears to be taking longer than usual. We will email you once your pledge is finalized.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Processing"
  ///
  /// - **en**: "Processing"
  /// - **de**: "Verarbeitung läuft"
  /// - **es**: "Procesando"
  /// - **fr**: "Traitement en cours"
  /// - **ja**: "処理中"
  public static func project_checkout_finalizing_title() -> String {
    return localizedString(
      key: "project.checkout.finalizing.title",
      defaultValue: "Processing",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We’re finalizing your pledge to %{project_name}. It’ll be just a moment!"
  ///
  /// - **en**: "We’re finalizing your pledge to %{project_name}. It’ll be just a moment!"
  /// - **de**: "Dein Finanzierungsbeitrag für %{project_name} wird gerade bearbeitet. Das dauert nur einen kurzen Moment!"
  /// - **es**: "Estamos finalizando tu contribución para %{project_name}. ¡Sólo nos tomará un momento!"
  /// - **fr**: "Nous sommes en train de finaliser votre engagement pour le projet %{project_name}. Merci de patienter quelques instants !"
  /// - **ja**: "%{project_name} へのプレッジを処理中です。"
  public static func project_checkout_finalizing_we_are_finalizing_your_pledge_to_project(project_name: String) -> String {
    return localizedString(
      key: "project.checkout.finalizing.we_are_finalizing_your_pledge_to_project",
      defaultValue: "We’re finalizing your pledge to %{project_name}. It’ll be just a moment!",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "No thanks."
  ///
  /// - **en**: "No thanks."
  /// - **de**: "Nein, danke."
  /// - **es**: "No, gracias."
  /// - **fr**: "Non merci."
  /// - **ja**: "いいえ"
  public static func project_checkout_games_alert_no_thanks() -> String {
    return localizedString(
      key: "project.checkout.games_alert.no_thanks",
      defaultValue: "No thanks.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Want the coolest games delivered to your inbox? Our Games team has a newsletter just for you."
  ///
  /// - **en**: "Want the coolest games delivered to your inbox? Our Games team has a newsletter just for you."
  /// - **de**: "Wie wäre es, wenn du die coolsten Games direkt in deine Inbox geliefert bekämst? Kein Problem - unser Games-Team hat einen Newsletter für dich!"
  /// - **es**: "¿Qué tal si pudieras recibir automáticamente lo último acerca de videojuegos por correo electrónico? ¡Trato hecho - nuestro equipo de juegos tienen un boletín hecho a tu medida!"
  /// - **fr**: "Envie de tout savoir sur les jeux les plus cools ? La lettre d'information de notre équipe Jeux est faite pour vous."
  /// - **ja**: "ゲームチームのニュースレターを購読し、最新でクールな情報を手に入れましょう！"
  public static func project_checkout_games_alert_want_the_coolest_games_delivered_to_your_inbox() -> String {
    return localizedString(
      key: "project.checkout.games_alert.want_the_coolest_games_delivered_to_your_inbox",
      defaultValue: "Want the coolest games delivered to your inbox? Our Games team has a newsletter just for you.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Yes please!"
  ///
  /// - **en**: "Yes please!"
  /// - **de**: "Gerne!"
  /// - **es**: "¡Claro que sí!"
  /// - **fr**: "Oui !"
  /// - **ja**: "はい、お願いします！"
  public static func project_checkout_games_alert_yes_please() -> String {
    return localizedString(
      key: "project.checkout.games_alert.yes_please",
      defaultValue: "Yes please!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Looking for more projects? Check these out."
  ///
  /// - **en**: "Looking for more projects? Check these out."
  /// - **de**: "Du suchst weitere Projekte? Schau dir diese doch mal näher an."
  /// - **es**: "¿Estás buscando nuevos proyectos? Échales un vistazo a éstos."
  /// - **fr**: "Vous recherchez plus de projets ? En voici quelques uns."
  /// - **ja**: "まだお探しですか？ こちらもチェックしよう。"
  public static func project_checkout_looking_for_more_projects_check_these_out() -> String {
    return localizedString(
      key: "project.checkout.looking_for_more_projects_check_these_out",
      defaultValue: "Looking for more projects? Check these out.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Manage pledge"
  ///
  /// - **en**: "Manage pledge"
  /// - **de**: "Finanzierungsbeitrag verwalten"
  /// - **es**: "Administrar contribución"
  /// - **fr**: "Gérer"
  /// - **ja**: "プレッジ管理"
  public static func project_checkout_manage_navbar_title() -> String {
    return localizedString(
      key: "project.checkout.manage.navbar_title",
      defaultValue: "Manage pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Next"
  ///
  /// - **en**: "Next"
  /// - **de**: "Weiter"
  /// - **es**: "Siguiente"
  /// - **fr**: "Suivant"
  /// - **ja**: "次へ"
  public static func project_checkout_navigation_next() -> String {
    return localizedString(
      key: "project.checkout.navigation.next",
      defaultValue: "Next",
      count: nil,
      substitutions: [:]
    )
  }
}
