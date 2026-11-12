// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension MessagesStrings {
  /// "Me"
  ///
  /// - **en**: "Me"
  /// - **de**: "Ich"
  /// - **es**: "Mi cuenta"
  /// - **fr**: "Mon compte"
  /// - **ja**: "Me"
  public static func messages_me() -> String {
    return localizedString(
      key: "messages.me",
      defaultValue: "Me",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Inbox"
  ///
  /// - **en**: "Inbox"
  /// - **de**: "Posteingang"
  /// - **es**: "Bandeja de entrada"
  /// - **fr**: "Boîte de réception"
  /// - **ja**: "メッセージボックス"
  public static func messages_navigation_inbox() -> String {
    return localizedString(
      key: "messages.navigation.inbox",
      defaultValue: "Inbox",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Search"
  ///
  /// - **en**: "Search"
  /// - **de**: "Suche"
  /// - **es**: "Buscar"
  /// - **fr**: "Recherche"
  /// - **ja**: "探す"
  public static func messages_navigation_search() -> String {
    return localizedString(
      key: "messages.navigation.search",
      defaultValue: "Search",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sent"
  ///
  /// - **en**: "Sent"
  /// - **de**: "Gesendet"
  /// - **es**: "Enviados"
  /// - **fr**: "Envoyé"
  /// - **ja**: "送信済み"
  public static func messages_navigation_sent() -> String {
    return localizedString(
      key: "messages.navigation.sent",
      defaultValue: "Sent",
      count: nil,
      substitutions: [:]
    )
  }
  /// "sent %{sent_date}"
  ///
  /// - **en**: "sent %{sent_date}"
  /// - **de**: "gesendet %{sent_date}"
  /// - **es**: "enviado %{sent_date}"
  /// - **fr**: "envoyé le %{sent_date}"
  /// - **ja**: "%{sent_date} に送信"
  public static func messages_sent_date(sent_date: String) -> String {
    return localizedString(
      key: "messages.sent_date",
      defaultValue: "sent %{sent_date}",
      count: nil,
      substitutions: ["sent_date": sent_date]
    )
  }
  /// "Messages"
  ///
  /// - **en**: "Messages"
  /// - **de**: "Nachrichten"
  /// - **es**: "Mensajes"
  /// - **fr**: "Messages"
  /// - **ja**: "メッセージ"
  public static func profile_buttons_messages() -> String {
    return localizedString(
      key: "profile.buttons.messages",
      defaultValue: "Messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You haven't backed any projects yet.
  /// t's change that!"
  ///
  /// - **en**: "You haven't backed any projects yet.
  /// t's change that!"
  /// - **de**: "Du hast noch keine Projekte unterstützt. Das sollten wir ändern!"
  /// - **es**: "Aún no has patrocinado ningún proyecto.
  /// s hora de cambiar esto!"
  /// - **fr**: "Vous n'avez pas encore soutenu de projets. On change ça ?"
  /// - **ja**: "まだバックしてません。
  /// クしてみよう！"
  public static func profile_projects_empty_state_message() -> String {
    return localizedString(
      key: "profile.projects.empty_state.message",
      defaultValue: "You haven't backed any projects yet.\nLet's change that!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No backed projects yet"
  ///
  /// - **en**: "No backed projects yet"
  /// - **de**: "Keine unterstützten Projekte"
  /// - **es**: "Todavía no ha contribuido a ningún proyecto"
  /// - **fr**: "Pas de projets soutenus"
  /// - **ja**: "まだバックしていません"
  public static func profile_projects_empty_state_message_no_backed_projects_yet() -> String {
    return localizedString(
      key: "profile.projects.empty_state.message_no_backed_projects_yet",
      defaultValue: "No backed projects yet",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Are you sure you want to log out?"
  ///
  /// - **en**: "Are you sure you want to log out?"
  /// - **de**: "Bist du sicher, dass du dich abmelden willst?"
  /// - **es**: "¿Estás seguro de que quieres cerrar sesión?"
  /// - **fr**: "Êtes-vous sûr de vouloir vous déconnecter ?"
  /// - **ja**: "ログアウトしますか？"
  public static func profile_settings_logout_alert_message() -> String {
    return localizedString(
      key: "profile.settings.logout_alert.message",
      defaultValue: "Are you sure you want to log out?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We've sent a confirmation email to the address associated with your account! Please check your email in order to confirm that you'd like to subscribe to %{newsletter}."
  ///
  /// - **en**: "We've sent a confirmation email to the address associated with your account! Please check your email in order to confirm that you'd like to subscribe to %{newsletter}."
  /// - **de**: "Wir haben eine Bestätigung an die mit deinem Konto verbundene E-Mail-Adresse geschickt! Bitte sieh in deinem Posteingang nach und bestätige dein Abo von %{newsletter}."
  /// - **es**: "Hemos enviado una confirmación a la dirección de correo electrónico asociada con tu cuenta. Por favor checa tu bandeja de entrada y confirma la subscripción a %{newsletter}."
  /// - **fr**: "Nous vous avons envoyé un e-mail de confirmation à l'adresse associée à votre compte ! Veuillez ouvrir votre boîte de réception et confirmer votre abonnement à %{newsletter}."
  /// - **ja**: "登録されているアドレス宛に認証メールを送信しました！%{newsletter} を購読するには、メールを確認してください。"
  public static func profile_settings_newsletter_opt_in_message(newsletter: String) -> String {
    return localizedString(
      key: "profile.settings.newsletter.opt_in.message",
      defaultValue: "We've sent a confirmation email to the address associated with your account! Please check your email in order to confirm that you'd like to subscribe to %{newsletter}.",
      count: nil,
      substitutions: ["newsletter": newsletter]
    )
  }
  /// "Thanks for using the Kickstarter app.
  /// you have a moment, would you mind rating your experience?
  /// 'd appreciate it!"
  ///
  /// - **en**: "Thanks for using the Kickstarter app.
  /// you have a moment, would you mind rating your experience?
  /// 'd appreciate it!"
  /// - **de**: "Danke für die Nutzung der Kickstarter App.
  /// lls du einen Moment Zeit hast, könntest du deine Erfahrung bewerten?
  /// r würden uns sehr darüber freuen!"
  /// - **es**: "Gracias por usar la aplicación de Kickstarter.
  /// tienes un momento, ¿podrías calificar tu experiencia?
  /// e lo agradeceríamos!"
  /// - **fr**: "Merci d'utiliser l'application Kickstarter.
  /// riez-vous une minute pour évaluer votre expérience ?
  /// us vous en serions très reconnaissants !"
  /// - **ja**: "Kickstarterアプリの使い心地はいかがですか？
  /// 評価をお聞かせください！"
  public static func profile_settings_rating_message() -> String {
    return localizedString(
      key: "profile.settings.rating.message",
      defaultValue: "Thanks for using the Kickstarter app.\nIf you have a moment, would you mind rating your experience?\nWe'd appreciate it!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "If you enjoy using the Kickstarter app, would you mind taking a moment to rate it in the Play store?
  ///
  /// ank you for your support!"
  ///
  /// - **en**: "If you enjoy using the Kickstarter app, would you mind taking a moment to rate it in the Play store?
  ///
  /// ank you for your support!"
  /// - **de**: "Hättest du einen Moment Zeit, die App im Play Store zu bewerten?"
  /// - **es**: "Si es así, ¿tendrías un momento para calificarla en Play Store?"
  /// - **fr**: "Si l'application Kickstarter vous plaît, pourquoi ne pas prendre le temps de la noter dans le Play Store ?
  ///
  /// rci pour votre soutien !"
  /// - **ja**: "Play storeでぜひ評価してください！"
  public static func profile_settings_rating_option_message_if_you_enjoy_using_Kickstarter() -> String {
    return localizedString(
      key: "profile.settings.rating.option.message_if_you_enjoy_using_Kickstarter",
      defaultValue: "If you enjoy using the Kickstarter app, would you mind taking a moment to rate it in the Play store?\n\nThank you for your support!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Aw, how sad. Be the first backer to leave a comment on this project."
  ///
  /// - **en**: "Aw, how sad. Be the first backer to leave a comment on this project."
  /// - **de**: "Oh wie schade. Du könntest der erste Unterstützer sein, der dieses Projekt kommentiert!"
  /// - **es**: "Ay, ¡qué pena! Pero - ¡tú podrías ser el primer patrocinador que deja un comentario en este proyecto!"
  /// - **fr**: "Oh, quel dommage. Soyez le premier contributeur à laisser un commentaire sur ce projet."
  /// - **ja**: "初めてのコメントを残しましょう。"
  public static func project_comments_empty_state_backer_message() -> String {
    return localizedString(
      key: "project.comments.empty_state.backer.message",
      defaultValue: "Aw, how sad. Be the first backer to leave a comment on this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Aw, how sad. Become a backer to leave a comment."
  ///
  /// - **en**: "Aw, how sad. Become a backer to leave a comment."
  /// - **de**: "Oh wie schade. Werde Unterstützer um einen Kommentar zu hinterlassen."
  /// - **es**: "Ay, ¡qué pena! Hazte patrocinador para dejar un comentario."
  /// - **fr**: "Oh, quel dommage. Soutenez ce projet afin de pouvoir laisser un commentaire."
  /// - **ja**: "コメントするためにバッカーになる。"
  public static func project_comments_empty_state_logged_out_message() -> String {
    return localizedString(
      key: "project.comments.empty_state.logged_out.message",
      defaultValue: "Aw, how sad. Become a backer to leave a comment.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Aw, how sad. Become a backer to leave a comment."
  ///
  /// - **en**: "Aw, how sad. Become a backer to leave a comment."
  /// - **de**: "Oh wie schade. Werde Unterstützer um einen Kommentar zu verfassen."
  /// - **es**: "Ay, ¡qué pena! Hazte patrocinador para dejar un comentario."
  /// - **fr**: "Oh, quel dommage. Soutenez ce projet afin de pouvoir laisser un commentaire."
  /// - **ja**: "コメントするためにバッカーになる。"
  public static func project_comments_empty_state_non_backer_message() -> String {
    return localizedString(
      key: "project.comments.empty_state.non_backer.message",
      defaultValue: "Aw, how sad. Become a backer to leave a comment.",
      count: nil,
      substitutions: [:]
    )
  }
}
