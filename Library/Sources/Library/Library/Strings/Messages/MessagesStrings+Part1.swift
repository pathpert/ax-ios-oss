// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension MessagesStrings {
  /// "Chat"
  ///
  /// - **en**: "Chat"
  /// - **de**: "Chat"
  /// - **es**: "Chat"
  /// - **fr**: "Chat"
  /// - **ja**: "チャット"
  public static func Chat() -> String {
    return localizedString(
      key: "Chat",
      defaultValue: "Chat",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Check your inbox to complete this simple step."
  ///
  /// - **en**: "Check your inbox to complete this simple step."
  /// - **de**: "Sieh bitte in deinem Posteingang nach und schließe diesen einfachen Schritt ab."
  /// - **es**: "Revisa tu bandeja de entrada para completar este simple paso."
  /// - **fr**: "Pour terminer cette démarche simple, ouvrez votre boîte de réception."
  /// - **ja**: "メールの受信箱をチェックしてこの簡単手続きを完了してください。"
  public static func Check_your_inbox_to_complete_this_simple_step() -> String {
    return localizedString(
      key: "Check_your_inbox_to_complete_this_simple_step",
      defaultValue: "Check your inbox to complete this simple step.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Comment reply digest"
  ///
  /// - **en**: "Comment reply digest"
  /// - **de**: "Tägliche Zusammenfassung Kommentare"
  /// - **es**: "Resumen de respuestas a comentarios"
  /// - **fr**: "Résumé des réponses aux commentaires"
  /// - **ja**: "コメント返信のダイジェスト"
  public static func Comment_reply_digest() -> String {
    return localizedString(
      key: "Comment_reply_digest",
      defaultValue: "Comment reply digest",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Get notified about new messages?"
  ///
  /// - **en**: "Get notified about new messages?"
  /// - **de**: "Möchtest du benachrichtigt werden bei neuen Nachrichten?"
  /// - **es**: "¿Deseas recibir notificaciones sobre nuevos mensajes?"
  /// - **fr**: "Envie d'être informé des messages entrants ?"
  /// - **ja**: "新規メッセージについて通知の受信を希望しますか？"
  public static func Get_notified_about_new_messages() -> String {
    return localizedString(
      key: "Get_notified_about_new_messages",
      defaultValue: "Get notified about new messages?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Know when creators and backers message you by enabling notifications."
  ///
  /// - **en**: "Know when creators and backers message you by enabling notifications."
  /// - **de**: "Aktiviere Benachrichtigungen, damit du über eingehende Nachrichten von Projektgründern und Unterstützern Bescheid weißt."
  /// - **es**: "Entérate cuando los creadores y patrocinadores te envíen mensajes habilitando las notificaciones."
  /// - **fr**: "Activez vos notifications pour savoir quand un créateur ou un contributeur vous envoie un message."
  /// - **ja**: "クリエイターやバッカ―からメッセージが届いた場合にすぐ分かるように、通知機能を有効にしましょう。"
  public static func Know_when_creators_and_backers_message_you() -> String {
    return localizedString(
      key: "Know_when_creators_and_backers_message_you",
      defaultValue: "Know when creators and backers message you by enabling notifications.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Message backer"
  ///
  /// - **en**: "Message backer"
  /// - **de**: "Nachricht an Unterstützer senden"
  /// - **es**: "Enviar mensaje a patrocinador"
  /// - **fr**: "Envoyer un message au contributeur"
  /// - **ja**: "バッカーにメッセージする"
  public static func Message_backer() -> String {
    return localizedString(
      key: "Message_backer",
      defaultValue: "Message backer",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Message creator"
  ///
  /// - **en**: "Message creator"
  /// - **de**: "Nachricht an Projektgründer senden"
  /// - **es**: "Enviar mensaje al creador"
  /// - **fr**: "Envoyer un message au créateur"
  /// - **ja**: "クリエーターにメッセージする"
  public static func Message_creator() -> String {
    return localizedString(
      key: "Message_creator",
      defaultValue: "Message creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Message %{user_name}…"
  ///
  /// - **en**: "Message %{user_name}…"
  /// - **de**: "Nachricht senden an %{user_name}…"
  /// - **es**: "Mensaje a %{user_name}…"
  /// - **fr**: "Envoyer un message à %{user_name}"
  /// - **ja**: "%{user_name} にメッセージ"
  public static func Message_user_name(user_name: String) -> String {
    return localizedString(
      key: "Message_user_name",
      defaultValue: "Message %{user_name}…",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "Messages"
  ///
  /// - **en**: "Messages"
  /// - **de**: "Nachrichten"
  /// - **es**: "Mensajes"
  /// - **fr**: "Messages"
  /// - **ja**: "メッセージ"
  public static func Messages() -> String {
    return localizedString(
      key: "Messages",
      defaultValue: "Messages",
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
  public static func No_messages() -> String {
    return localizedString(
      key: "No_messages",
      defaultValue: "No messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No unread messages"
  ///
  /// - **en**: "No unread messages"
  /// - **de**: "Keine ungelesenen Nachrichten"
  /// - **es**: "No hay mensajes no leídos"
  /// - **fr**: "Pas de messages non lus"
  /// - **ja**: "未読メッセージはありません"
  public static func No_unread_messages() -> String {
    return localizedString(
      key: "No_unread_messages",
      defaultValue: "No unread messages",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Open inbox"
  ///
  /// - **en**: "Open inbox"
  /// - **de**: "Posteingang öffnen"
  /// - **es**: "Abrir la bandeja de entrada"
  /// - **fr**: "Ouvrir ma boîte de réception"
  /// - **ja**: "受信箱を開く"
  public static func Open_inbox() -> String {
    return localizedString(
      key: "Open_inbox",
      defaultValue: "Open inbox",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Opens message composer."
  ///
  /// - **en**: "Opens message composer."
  /// - **de**: "Öffnet Nachrichten-Vorlage."
  /// - **es**: "Abre plantilla de mensaje."
  /// - **fr**: "Ouvre l'éditeur de messages."
  /// - **ja**: "メールの送受信者をみる"
  public static func Opens_message_composer() -> String {
    return localizedString(
      key: "Opens_message_composer",
      defaultValue: "Opens message composer.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reply to %{user_name}…"
  ///
  /// - **en**: "Reply to %{user_name}…"
  /// - **de**: "%{user_name} antworten …"
  /// - **es**: "Responder a %{user_name}…"
  /// - **fr**: "Répondre à %{user_name}…"
  /// - **ja**: "%{user_nameに返信"
  public static func Reply_to_user_name(user_name: String) -> String {
    return localizedString(
      key: "Reply_to_user_name",
      defaultValue: "Reply to %{user_name}…",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "Send a message"
  ///
  /// - **en**: "Send a message"
  /// - **de**: "Nachricht senden"
  /// - **es**: "Enviar un mensaje"
  /// - **fr**: "Envoyer un message"
  /// - **ja**: "メッセージを送る"
  public static func Send_a_message() -> String {
    return localizedString(
      key: "Send_a_message",
      defaultValue: "Send a message",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The zeitgeist delivered to your inbox, via new projects and buzzworthy stories."
  ///
  /// - **en**: "The zeitgeist delivered to your inbox, via new projects and buzzworthy stories."
  /// - **de**: "Hol dir den Zeitgeist direkt in deine Inbox: neue Projekte und Stories, die in aller Munde sind."
  /// - **es**: "Recibe la actualidad en tu correo electrónico a través de nuevos proyectos e historias interesantes."
  /// - **fr**: "Nouveaux projets et témoignages qui illustrent l'esprit du temps s'invitent dans votre boîte de réception."
  /// - **ja**: "気になる話題や最新プロジェクトなど、この時代を特徴づける思想「ツァイトガイスト」をいち早くお届けします。"
  public static func The_zeitgeist_delivered_to_your_inbox_via_new() -> String {
    return localizedString(
      key: "The_zeitgeist_delivered_to_your_inbox_via_new",
      defaultValue: "The zeitgeist delivered to your inbox, via new projects and buzzworthy stories.",
      count: nil,
      substitutions: [:]
    )
  }
}
