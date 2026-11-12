// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension MessagesStrings {
  /// "Your chat message wasn't sent successfully."
  ///
  /// - **en**: "Your chat message wasn't sent successfully."
  /// - **de**: "Deine Chat-Nachricht konnte leider nicht gesendet werden."
  /// - **es**: "Tu mensaje no fue enviado."
  /// - **fr**: "Votre message n'a pas été envoyé."
  /// - **ja**: "メッセージの送信に失敗。"
  public static func Your_chat_message_wasnt_sent_successfully() -> String {
    return localizedString(
      key: "Your_chat_message_wasnt_sent_successfully",
      defaultValue: "Your chat message wasn't sent successfully.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your message has been sent!"
  ///
  /// - **en**: "Your message has been sent!"
  /// - **de**: "Deine Nachricht wurde versandt!"
  /// - **es**: "Se envió tu mensaje."
  /// - **fr**: "Votre message a été envoyé."
  /// - **ja**: "メッセージが送信されました！"
  public static func Your_message_has_been_sent() -> String {
    return localizedString(
      key: "Your_message_has_been_sent",
      defaultValue: "Your message has been sent!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Send message"
  ///
  /// - **en**: "Send message"
  /// - **de**: "Nachricht senden"
  /// - **es**: "Enviar mensaje"
  /// - **fr**: "Envoyer un message"
  /// - **ja**: "メッセージを送る"
  public static func activity_creator_buttons_send_message() -> String {
    return localizedString(
      key: "activity.creator.buttons.send_message",
      defaultValue: "Send message",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When you back a project or follow a friend, their activity will show up here."
  ///
  /// - **en**: "When you back a project or follow a friend, their activity will show up here."
  /// - **de**: "Wenn du ein Projekt unterstützt oder einem Freund folgst, werden deren Aktivitäten hier angezeigt."
  /// - **es**: "Cuando patrocines un proyecto o sigas a un amigo, esta actividad se mostrará aquí."
  /// - **fr**: "L'activité des projets que vous soutenez ou des amis que vous suivez sera affichée ici."
  /// - **ja**: "バックしたり友人をフォローした際は、ここに表示されます。"
  public static func activity_empty_state_logged_in_message() -> String {
    return localizedString(
      key: "activity.empty_state.logged_in.message",
      defaultValue: "When you back a project or follow a friend, their activity will show up here.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When you back a project or follow a friend, their activity will show up here."
  ///
  /// - **en**: "When you back a project or follow a friend, their activity will show up here."
  /// - **de**: "Wenn du ein Projekt unterstützt oder einem Freund folgst, werden diese Aktivitäten hier angezeigt."
  /// - **es**: "Cuando patrocines un proyecto o sigas a un amigo, su actividad se verá aquí."
  /// - **fr**: "L'activité des projets que vous soutenez ou des amis que vous suivez sera affichée ici."
  /// - **ja**: "バックしたり友人をフォローした際、こちらに表示されます。"
  public static func activity_empty_state_logged_out_message() -> String {
    return localizedString(
      key: "activity.empty_state.logged_out.message",
      defaultValue: "When you back a project or follow a friend, their activity will show up here.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Send message"
  ///
  /// - **en**: "Send message"
  /// - **de**: "Nachricht senden"
  /// - **es**: "Enviar mensaje"
  /// - **fr**: "Envoyer un message"
  /// - **ja**: "メッセージを送る"
  public static func backer_modal_send_backer_message_button() -> String {
    return localizedString(
      key: "backer_modal.send_backer_message_button",
      defaultValue: "Send message",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Message creator"
  ///
  /// - **en**: "Message creator"
  /// - **de**: "Nachricht an Projektgründer senden"
  /// - **es**: "Enviar mensaje al creador"
  /// - **fr**: "Message au créateur"
  /// - **ja**: "クリエイターに連絡"
  public static func backer_modal_send_creator_message_button() -> String {
    return localizedString(
      key: "backer_modal.send_creator_message_button",
      defaultValue: "Message creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "View messages"
  ///
  /// - **en**: "View messages"
  /// - **de**: "Nachrichten anzeigen"
  /// - **es**: "Ver mensajes"
  /// - **fr**: "Afficher les messages"
  /// - **ja**: "メッセージをみる"
  public static func backer_modal_view_messages() -> String {
    return localizedString(
      key: "backer_modal.view_messages",
      defaultValue: "View messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reply"
  ///
  /// - **en**: "Reply"
  /// - **de**: "Antworten"
  /// - **es**: "Responder"
  /// - **fr**: "Répondre"
  /// - **ja**: "返信"
  public static func general_navigation_buttons_reply() -> String {
    return localizedString(
      key: "general.navigation.buttons.reply",
      defaultValue: "Reply",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You seem to be using a really old version of the app. Please upgrade from the App Store to continue using."
  ///
  /// - **en**: "You seem to be using a really old version of the app. Please upgrade from the App Store to continue using."
  /// - **de**: "Du scheinst eine sehr alte Version der App zu benutzen. Um fortzufahren, installiere bitte die neueste Version aus dem App Store."
  /// - **es**: "Parece que estás usando una versión muy antigua de esta aplicación. Por favor descarga la última versión en la App Store para continuar usándola."
  /// - **fr**: "On dirait que vous utilisez une ancienne version de l'application. Veuillez la mettre à jour depuis l'App Store pour continuer à l'utiliser."
  /// - **ja**: "引き続き利用するにはApp Storeからアプリのバージョンを更新してください。"
  public static func invalid_api_client_alert_message() -> String {
    return localizedString(
      key: "invalid_api_client_alert.message",
      defaultValue: "You seem to be using a really old version of the app. Please upgrade from the App Store to continue using.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Couldn't load messages"
  ///
  /// - **en**: "Couldn't load messages"
  /// - **de**: "Nachrichten konnten nicht geladen werden"
  /// - **es**: "No se pudieron cargar mensajes"
  /// - **fr**: "Impossible de charger les messages"
  /// - **ja**: "メッセージの読み込み失敗"
  public static func messages_could_not_load_messages() -> String {
    return localizedString(
      key: "messages.could_not_load_messages",
      defaultValue: "Couldn't load messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sorry, your message could not be posted."
  ///
  /// - **en**: "Sorry, your message could not be posted."
  /// - **de**: "Deine Nachricht konnte leider nicht gepostet werden."
  /// - **es**: "Lo sentimos, no se pudo publicar tu mensaje."
  /// - **fr**: "Désolé, votre message n'a pas pu être publié."
  /// - **ja**: "申し訳ありません。メッセージを配信できませんでした。"
  public static func messages_dialog_generic_error() -> String {
    return localizedString(
      key: "messages.dialog.generic_error",
      defaultValue: "Sorry, your message could not be posted.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You have not sent a message to the creator."
  ///
  /// - **en**: "You have not sent a message to the creator."
  /// - **de**: "Du hast dem Projektgründer keine Nachricht gesendet."
  /// - **es**: "No le has enviado un mensaje al creador."
  /// - **fr**: "Vous n'avez pas envoyé de messages à ce créateur."
  /// - **ja**: "クリエーターにメッセージを送っていません。"
  public static func messages_empty_state_message_backer() -> String {
    return localizedString(
      key: "messages.empty_state.message_backer",
      defaultValue: "You have not sent a message to the creator.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You have not sent a message to this backer."
  ///
  /// - **en**: "You have not sent a message to this backer."
  /// - **de**: "Du hast diesem Unterstützer keine Nachricht gesendet."
  /// - **es**: "No le has enviado un mensaje a este patrocinador."
  /// - **fr**: "Vous n'avez pas envoyé de messages à ce contributeur."
  /// - **ja**: "このバッカーにメッセージを送っていません"
  public static func messages_empty_state_message_creator() -> String {
    return localizedString(
      key: "messages.empty_state.message_creator",
      defaultValue: "You have not sent a message to this backer.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No messages"
  ///
  /// - **en**: "No messages"
  /// - **de**: "Keine Nachrichten"
  /// - **es**: "No hay mensajes"
  /// - **fr**: "Pas de messages"
  /// - **ja**: "メッセージがありません。"
  public static func messages_empty_state_title() -> String {
    return localizedString(
      key: "messages.empty_state.title",
      defaultValue: "No messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Loading more messages"
  ///
  /// - **en**: "Loading more messages"
  /// - **de**: "Ältere Nachrichten werden geladen"
  /// - **es**: "Cargando más mensajes"
  /// - **fr**: "Chargement des messages"
  /// - **ja**: "メッセージをロード"
  public static func messages_loading_more_messages() -> String {
    return localizedString(
      key: "messages.loading_more_messages",
      defaultValue: "Loading more messages",
      count: nil,
      substitutions: [:]
    )
  }
}
