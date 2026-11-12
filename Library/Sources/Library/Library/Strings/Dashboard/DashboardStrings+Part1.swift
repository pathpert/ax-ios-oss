// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "After September 5, 2023, this Dashboard feature will only be available on our website."
  ///
  /// - **en**: "After September 5, 2023, this Dashboard feature will only be available on our website."
  /// - **de**: "Nach dem 5. September 2023 ist das Dashboard nur noch auf unserer Website verfügbar."
  /// - **es**: "Después del 5 de septiembre de 2023, este panel solo estará disponible en nuestro sitio web."
  /// - **fr**: "À compter du 5 septembre 2023, ce tableau de bord ne sera disponible que sur notre site Web."
  /// - **ja**: "2023年9月5日以降、このダッシュボード機能は Kickstarter ウェブサイトでのみご利用いただけます。"
  public static func After_September_5_2023_this_Dashboard_feature_will_only_be_available_on_our_website() -> String {
    return localizedString(
      key: "After_September_5_2023_this_Dashboard_feature_will_only_be_available_on_our_website",
      defaultValue: "After September 5, 2023, this Dashboard feature will only be available on our website.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "After %{expiration_date}, the Dashboard and Post Update features will only be available on our website."
  ///
  /// - **en**: "After %{expiration_date}, the Dashboard and Post Update features will only be available on our website."
  /// - **de**: "Nach dem %{expiration_date} sind das Dashboard und die Funktion „Update veröffentlichen“ nur noch auf unserer Website verfügbar."
  /// - **es**: "Después del %{expiration_date}, el panel y la funcionalidad para publicar actualizaciones solo estarán disponibles en nuestro sitio web."
  /// - **fr**: "Après le %{expiration_date}, le tableau de bord et la fonctionnalité de publication d'actus ne seront accessibles que depuis le site Web."
  /// - **ja**: "%{expiration_date}以降、ダッシュボード機能とアップデート投稿機能は Kickstarter ウェブサイトでのみご利用いただけます。"
  public static func Creator_dashboard_removal_warning(expiration_date: String) -> String {
    return localizedString(
      key: "Creator_dashboard_removal_warning",
      defaultValue: "After %{expiration_date}, the Dashboard and Post Update features will only be available on our website.",
      count: nil,
      substitutions: ["expiration_date": expiration_date]
    )
  }
  /// "We can’t process your pledge. Visit the Project Alerts dashboard to authenticate your card."
  ///
  /// - **en**: "We can’t process your pledge. Visit the Project Alerts dashboard to authenticate your card."
  /// - **de**: "Wir können deinen Beitrag nicht verarbeiten. Besuche das Dashboard für Projekthinweise, um deine Karte zu authentifizieren."
  /// - **es**: "No podemos procesar tu contribución. Visita el panel de alertas del proyecto para autenticar tu tarjeta."
  /// - **fr**: "Impossible de traiter votre engagement. Veuillez authentifier votre carte dans le tableau de bord des alertes de projet."
  /// - **ja**: "プレッジを処理できません。プロジェクト通知のダッシュボードにアクセスしてカードを認証してください。"
  public static func We_cant_process_your_pledge_visit_the_project_alerts_dashboard_to_authenticate() -> String {
    return localizedString(
      key: "We_cant_process_your_pledge_visit_the_project_alerts_dashboard_to_authenticate",
      defaultValue: "We can’t process your pledge. Visit the Project Alerts dashboard to authenticate your card.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<p>You have successfully pledged to <b>%{project_name}</b>. Your pledge of <b>%{pledge_total}</b> has been collected.</p>
  /// >You’ll receive a confirmation email at %{user_email} when your rewards are ready to fulfill so that you can finalize and pay shipping and tax.</p>
  /// >This project is now one step closer to a reality, thanks to you. Spread the word!</p>"
  ///
  /// - **en**: "<p>You have successfully pledged to <b>%{project_name}</b>. Your pledge of <b>%{pledge_total}</b> has been collected.</p>
  /// >You’ll receive a confirmation email at %{user_email} when your rewards are ready to fulfill so that you can finalize and pay shipping and tax.</p>
  /// >This project is now one step closer to a reality, thanks to you. Spread the word!</p>"
  /// - **de**: "<p>Du hast <b>%{project_name}</b> mit deinem Beitrag erfolgreich unterstützt. Dein Beitrag in Höhe von <b>%{pledge_total}</b> wurde eingezogen.</p>
  /// >Du erhältst eine E-Mail an %{user_email}, wenn deine Belohnungen zur Erfüllung bereit sind, damit du alles finalisieren und für Versand und Steuern zahlen kannst.</p>
  /// >Dank dir ist dieses Projekt seiner Realisierung einen Schritt nähergekommen. Erzähl auch deinen Freunden und Bekannten davon!</p>"
  /// - **es**: "<p>Has patrocinado <b>%{project_name}</b> con éxito y tu contribución por <b>%{pledge_total}</b> se ha recaudado.</p>
  /// >Recibirás la confirmación en %{user_email} cuando estemos por entregarte las recompensas para que puedas pagar los costos de envío e impuestos.</p>
  /// >Gracias a ti, este proyecto está ahora un paso más cerca de hacerse realidad. ¡Ayuda a correr la voz!</p>"
  /// - **fr**: "<p>Vous venez de vous engager à soutenir le projet <b>%{project_name}</b>. Votre contribution de <b>%{pledge_total}</b> a bien été prélevée.</p>
  /// >Vous recevrez une confirmation à l'adresse %{user_email} dès que votre récompense sera prête à être expédiée. Il vous sera alors demandé de régler les taxes et frais de port.</p>
  /// >Grâce à vous, ce projet se concrétise. Parlez-en autour de vous !</p>"
  /// - **ja**: "<p><b>%{project_name}</b>にプレッジしました。これに伴い、<b>%{pledge_total}</b>のプレッジが収集されました。</p>
  /// >リワード配送の準備が整い次第、%{user_email} 宛てに確認メールが届き、配送料と税金の最終確認とお支払いを行うことができます。</p>
  /// >あなたのプレッジのおかげで、このプロジェクトが実現へと一歩近づきました。ありがとうございます。ぜひこのプロジェクトを沢山の人に知ってもらいましょう！</p>"
  public static func You_have_successfully_pledged_to_project_post_campaign_html(project_name: String, pledge_total: String, user_email: String) -> String {
    return localizedString(
      key: "You_have_successfully_pledged_to_project_post_campaign_html",
      defaultValue: "<p>You have successfully pledged to <b>%{project_name}</b>. Your pledge of <b>%{pledge_total}</b> has been collected.</p>\n<p>You’ll receive a confirmation email at %{user_email} when your rewards are ready to fulfill so that you can finalize and pay shipping and tax.</p>\n<p>This project is now one step closer to a reality, thanks to you. Spread the word!</p>",
      count: nil,
      substitutions: ["project_name": project_name, "pledge_total": pledge_total, "user_email": user_email]
    )
  }
  /// "Your <b>%{pledge_total}</b> pledge will help in bringing this project to life. Check your email for more details."
  ///
  /// - **en**: "Your <b>%{pledge_total}</b> pledge will help in bringing this project to life. Check your email for more details."
  /// - **de**: "Dein Beitrag in Höhe von <b>%{pledge_total}</b> wird dabei helfen, dieses Projekt Wirklichkeit werden zu lassen. Weitere Details findest du in der E-Mail, die du von uns erhalten hast."
  /// - **es**: "Tu contribución de <b>%{pledge_total}</b> ayudará a que este proyecto cobre vida. Revisa tu correo electrónico para más detalles."
  /// - **fr**: "Votre engagement de <b>%{pledge_total}</b> contribue à faire vivre ce projet. Consultez votre messagerie pour plus de détails."
  /// - **ja**: "あなたの <b>%{pledge_total}</b> のプレッジがこのプロジェクトの実現をサポートします。詳しくはメールをご確認ください。"
  public static func You_have_successfully_pledged_to_project_post_campaign_html_short(pledge_total: String) -> String {
    return localizedString(
      key: "You_have_successfully_pledged_to_project_post_campaign_html_short",
      defaultValue: "Your <b>%{pledge_total}</b> pledge will help in bringing this project to life. Check your email for more details.",
      count: nil,
      substitutions: ["pledge_total": pledge_total]
    )
  }
  /// "Backing info"
  ///
  /// - **en**: "Backing info"
  /// - **de**: "Infos zur Unterstützung"
  /// - **es**: "Info sobre patrocinamiento"
  /// - **fr**: "Infos sur la contribution"
  /// - **ja**: "バック情報"
  public static func dashboard_activity_backing_info() -> String {
    return localizedString(
      key: "dashboard.activity.backing_info",
      defaultValue: "Backing info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No reward selected"
  ///
  /// - **en**: "No reward selected"
  /// - **de**: "Keine Belohnung ausgewählt"
  /// - **es**: "No se seleccionó ninguna recompensa"
  /// - **fr**: "Pas de récompense sélectionnée"
  /// - **ja**: "選択中のリワードはありません"
  public static func dashboard_activity_no_reward_selected() -> String {
    return localizedString(
      key: "dashboard.activity.no_reward_selected",
      defaultValue: "No reward selected",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge info"
  ///
  /// - **en**: "Pledge info"
  /// - **de**: "Info zu Finanzierungsbeitrag"
  /// - **es**: "Info sobre contribución"
  /// - **fr**: "Infos sur mon engagement"
  /// - **ja**: "プレッジ情報"
  public static func dashboard_activity_pledge_info() -> String {
    return localizedString(
      key: "dashboard.activity.pledge_info",
      defaultValue: "Pledge info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>%{project_name}</b> launched on %{launch_date} with a goal of raising <b>%{goal}</b>"
  ///
  /// - **en**: "<b>%{project_name}</b> launched on %{launch_date} with a goal of raising <b>%{goal}</b>"
  /// - **de**: "<b>%{project_name}</b> veröffentlicht am %{launch_date}, Finanzierungsziel: <b>%{goal}</b>"
  /// - **es**: "<b>%{project_name}</b>, publicado el %{launch_date}, meta de financiamiento: <b>%{goal}</b>"
  /// - **fr**: "<b>%{project_name}</b> lancé le %{launch_date} avec un objectif de <b>%{goal}</b>"
  /// - **ja**: "%{launch_date} に<b>%{project_name}</b> が<b>%{goal}</b> を目標として発表されました。"
  public static func dashboard_activity_project_name_launched(project_name: String, launch_date: String, goal: String) -> String {
    return localizedString(
      key: "dashboard.activity.project_name_launched",
      defaultValue: "<b>%{project_name}</b> launched on %{launch_date} with a goal of raising <b>%{goal}</b>",
      count: nil,
      substitutions: ["project_name": project_name, "launch_date": launch_date, "goal": goal]
    )
  }
  /// "<b>%{project_name}</b> was canceled on %{cancellation_date}"
  ///
  /// - **en**: "<b>%{project_name}</b> was canceled on %{cancellation_date}"
  /// - **de**: "<b>%{project_name}</b> wurde am %{cancellation_date} abgebrochen"
  /// - **es**: "<b>%{project_name}</b> fue cancelado el %{cancellation_date}"
  /// - **fr**: "<b>%{project_name}</b> a été annulé le %{cancellation_date}"
  /// - **ja**: "%{cancellation_date} に<b>%{project_name}</b> はキャンセルされました"
  public static func dashboard_activity_project_name_was_canceled(project_name: String, cancellation_date: String) -> String {
    return localizedString(
      key: "dashboard.activity.project_name_was_canceled",
      defaultValue: "<b>%{project_name}</b> was canceled on %{cancellation_date}",
      count: nil,
      substitutions: ["project_name": project_name, "cancellation_date": cancellation_date]
    )
  }
  /// "<b>%{project_name}</b> was suspended on %{suspension_date}"
  ///
  /// - **en**: "<b>%{project_name}</b> was suspended on %{suspension_date}"
  /// - **de**: "<b>%{project_name}</b> wurde am %{suspension_date} ausgesetzt"
  /// - **es**: "<b>%{project_name}</b> fue suspendido el %{suspension_date}"
  /// - **fr**: "<b>%{project_name}</b> a été suspendu le %{suspension_date}"
  /// - **ja**: "%{suspension_date} に<b>%{project_name}</b> は停止されました"
  public static func dashboard_activity_project_name_was_suspended(project_name: String, suspension_date: String) -> String {
    return localizedString(
      key: "dashboard.activity.project_name_was_suspended",
      defaultValue: "<b>%{project_name}</b> was suspended on %{suspension_date}",
      count: nil,
      substitutions: ["project_name": project_name, "suspension_date": suspension_date]
    )
  }
  /// "<b>%{project_name}</b> was unsuccessful on %{unsuccessful_date}"
  ///
  /// - **en**: "<b>%{project_name}</b> was unsuccessful on %{unsuccessful_date}"
  /// - **de**: "<b>%{project_name}</b> hat das Finanzierungsziel nicht erreicht. Stand: %{unsuccessful_date}"
  /// - **es**: "<b>%{project_name}</b> terminó sin éxito el %{unsuccessful_date}"
  /// - **fr**: "<b>%{project_name}</b> n'a pas atteint son objectif de financement avant le %{unsuccessful_date}"
  /// - **ja**: "%{unsuccessful_date} に<b>%{project_name}</b> は失敗しました"
  public static func dashboard_activity_project_name_was_unsuccessful(project_name: String, unsuccessful_date: String) -> String {
    return localizedString(
      key: "dashboard.activity.project_name_was_unsuccessful",
      defaultValue: "<b>%{project_name}</b> was unsuccessful on %{unsuccessful_date}",
      count: nil,
      substitutions: ["project_name": project_name, "unsuccessful_date": unsuccessful_date]
    )
  }
  /// "Reply"
  ///
  /// - **en**: "Reply"
  /// - **de**: "Antworten"
  /// - **es**: "Responder"
  /// - **fr**: "Répondre"
  /// - **ja**: "返信"
  public static func dashboard_activity_reply() -> String {
    return localizedString(
      key: "dashboard.activity.reply",
      defaultValue: "Reply",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>Reward:</b> %{reward_name}"
  ///
  /// - **en**: "<b>Reward:</b> %{reward_name}"
  /// - **de**: "<b>Belohnung:</b> %{reward_name}"
  /// - **es**: "<b>Recompensa:</b> %{reward_name}"
  /// - **fr**: "<b>Récompense :<b> %{reward_name}"
  /// - **ja**: "<b>リワード</b>%{reward_name}"
  public static func dashboard_activity_reward_name(reward_name: String) -> String {
    return localizedString(
      key: "dashboard.activity.reward_name",
      defaultValue: "<b>Reward:</b> %{reward_name}",
      count: nil,
      substitutions: ["reward_name": reward_name]
    )
  }
  /// "Send message"
  ///
  /// - **en**: "Send message"
  /// - **de**: "Nachricht senden"
  /// - **es**: "Enviar mensaje"
  /// - **fr**: "Envoyer un message"
  /// - **ja**: "メッセージを送る"
  public static func dashboard_activity_send_message() -> String {
    return localizedString(
      key: "dashboard.activity.send_message",
      defaultValue: "Send message",
      count: nil,
      substitutions: [:]
    )
  }
}
