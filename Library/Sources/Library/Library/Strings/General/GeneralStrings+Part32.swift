// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "%{projects_count}
  /// cked"
  ///
  /// - **en**: "%{projects_count}
  /// cked"
  /// - **de**: "%{project_count}
  /// terstützt"
  /// - **es**: "%{project_count}
  /// trocinados"
  /// - **fr**: "%{project_count}
  /// ojets soutenus"
  /// - **ja**: "%{projects_count} \n件バック済み"
  public static func projects_count_newline_backed_other(projects_count: String) -> String {
    return localizedString(
      key: "projects_count_newline_backed.other",
      defaultValue: "%{projects_count}\nbacked",
      count: nil,
      substitutions: ["projects_count": projects_count]
    )
  }
  /// "%{projects_count}
  /// ved"
  ///
  /// - **en**: "%{projects_count}
  /// ved"
  /// - **de**: "%{projects_count}
  /// speichert"
  /// - **es**: "%{projects_count}
  /// ardados"
  /// - **fr**: "%{projects_count}
  /// ojets enregistrés"
  /// - **ja**: "%{projects_count} 
  /// 済み"
  public static func projects_count_newline_saved(projects_count: Int) -> String {
    return localizedString(
      key: "projects_count_newline_saved",
      defaultValue: "%{projects_count}\nsaved",
      count: projects_count,
      substitutions: ["projects_count": Format.wholeNumber(projects_count)]
    )
  }
  /// "%{projects_count}
  /// ved"
  ///
  /// - **en**: "%{projects_count}
  /// ved"
  /// - **de**: "%{projects_count}
  /// speichert"
  /// - **es**: "%{projects_count}
  /// ardados"
  /// - **fr**: "%{projects_count}
  /// ojets enregistrés"
  /// - **ja**: "%{projects_count} 
  /// 済み"
  public static func projects_count_newline_saved_other(projects_count: String) -> String {
    return localizedString(
      key: "projects_count_newline_saved.other",
      defaultValue: "%{projects_count}\nsaved",
      count: nil,
      substitutions: ["projects_count": projects_count]
    )
  }
  /// "%{projects_launched_count} created • %{projects_backed_count} backed"
  ///
  /// - **en**: "%{projects_launched_count} created • %{projects_backed_count} backed"
  /// - **de**: "%{projects_launched_count} erstellt• %{projects_backed_count} unterstützt"
  /// - **es**: "%{projects_launched_count} creados • %{projects_backed_count} patrocinados"
  /// - **fr**: "%{projects_launched_count} projets créés • %{projects_backed_count} projets soutenus"
  /// - **ja**: "%{projects_launched_count}件作成済み・%{projects_backed_count}件バック済み"
  public static func projects_launched_count_created_projects_backed_count_backed(projects_launched_count: String, projects_backed_count: String) -> String {
    return localizedString(
      key: "projects_launched_count_created_projects_backed_count_backed",
      defaultValue: "%{projects_launched_count} created • %{projects_backed_count} backed",
      count: nil,
      substitutions: ["projects_launched_count": projects_launched_count, "projects_backed_count": projects_backed_count]
    )
  }
  /// "%{remaining_count} left of %{limit_count}"
  ///
  /// - **en**: "%{remaining_count} left of %{limit_count}"
  /// - **de**: "%{remaining_count} übrig von %{limit_count}"
  /// - **es**: "%{remaining_count} restante de %{limit_count}"
  /// - **fr**: "%{remaining_count} sur %{limit_count}"
  /// - **ja**: "%{limit_count} 個中のこり%{remaining_count} 個"
  public static func remaining_count_left_of_limit_count(remaining_count: String, limit_count: String) -> String {
    return localizedString(
      key: "remaining_count_left_of_limit_count",
      defaultValue: "%{remaining_count} left of %{limit_count}",
      count: nil,
      substitutions: ["remaining_count": remaining_count, "limit_count": limit_count]
    )
  }
  /// "seconds"
  ///
  /// - **en**: "seconds"
  /// - **de**: "Sekunden"
  /// - **es**: "segundos"
  /// - **fr**: "secondes"
  /// - **ja**: "秒"
  public static func seconds() -> String {
    return localizedString(
      key: "seconds",
      defaultValue: "seconds",
      count: nil,
      substitutions: [:]
    )
  }
  /// "How can we help you? Please try to be as specific as possible.
  ///
  ///
  ///
  ///
  /// ------
  ///
  /// 
  ///
  /// - **en**: "How can we help you? Please try to be as specific as possible.
  ///
  ///
  ///
  ///
  /// ------
  ///
  /// 
  /// - **de**: "Wie können wir dir helfen? Mache deine Angaben bitte so genau wie möglich.
  /// 
  /// - **es**: "¿Cómo podemos ayudarte? Por favor, trata de ser lo más específico posible.
  ///
  ///
  ///
  ///
  /// ------
  /// 
  /// - **fr**: "Comment pouvons-nous vous aider ? Merci d'être aussi précis que possible.
  ///
  ///
  ///
  ///
  /// ------
  /// 
  /// - **ja**: "どうされましたか？できるだけ詳細をお伝えください。
  public static func support_email_body() -> String {
    return localizedString(
      key: "support_email.body",
      defaultValue: "How can we help you? Please try to be as specific as possible.\n\n\n\n\n--------\n\n",
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
  public static func support_email_button_ok() -> String {
    return localizedString(
      key: "support_email.button.ok",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Select email application:"
  ///
  /// - **en**: "Select email application:"
  /// - **de**: "Auswahl E-Mail-App:"
  /// - **es**: "Escoge la app de correo:"
  /// - **fr**: "Choisissez une application e-mail :"
  /// - **ja**: "メールアプリ選択："
  public static func support_email_chooser() -> String {
    return localizedString(
      key: "support_email.chooser",
      defaultValue: "Select email application:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Support"
  ///
  /// - **en**: "Support"
  /// - **de**: "Support"
  /// - **es**: "Atención al cliente"
  /// - **fr**: "Assistance"
  /// - **ja**: "サポート"
  public static func support_email_noemail_title() -> String {
    return localizedString(
      key: "support_email.noemail.title",
      defaultValue: "Support",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Hello Kickstarter App Support"
  ///
  /// - **en**: "Hello Kickstarter App Support"
  /// - **de**: "Hallo Kickstarter App Support"
  /// - **es**: "Saludos al equipo de atención al cliente de Kickstarter"
  /// - **fr**: "Bonjour, Assistance de l'application Kickstarter"
  /// - **ja**: "ようこそ、Kickstarter App Supportへ"
  public static func support_email_subject() -> String {
    return localizedString(
      key: "support_email.subject",
      defaultValue: "Hello Kickstarter App Support",
      count: nil,
      substitutions: [:]
    )
  }
  /// "app@kickstarter.com"
  ///
  /// - **en**: "app@kickstarter.com"
  /// - **de**: "app@kickstarter.com"
  /// - **es**: "app@kickstarter.com"
  /// - **fr**: "app@kickstarter.com"
  /// - **ja**: "app@kickstarter.com"
  public static func support_email_to() -> String {
    return localizedString(
      key: "support_email.to",
      defaultValue: "app@kickstarter.com",
      count: nil,
      substitutions: [:]
    )
  }
  /// "android@kickstarter.com"
  ///
  /// - **en**: "android@kickstarter.com"
  /// - **de**: "android@kickstarter.com"
  /// - **es**: "android@kickstarter.com"
  /// - **fr**: "android@kickstarter.com"
  /// - **ja**: "android@kickstarter.com"
  public static func support_email_to_android() -> String {
    return localizedString(
      key: "support_email.to_android",
      defaultValue: "android@kickstarter.com",
      count: nil,
      substitutions: [:]
    )
  }
}
