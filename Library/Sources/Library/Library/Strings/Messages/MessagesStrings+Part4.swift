// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension MessagesStrings {
  /// "%{project_title}, via @Kickstarter"
  ///
  /// - **en**: "%{project_title}, via @Kickstarter"
  /// - **de**: "%{project_title}, via @Kickstarter"
  /// - **es**: "%{project_title}, via @Kickstarter"
  /// - **fr**: "%{project_title}, via @Kickstarter"
  /// - **ja**: "%{project_title} (@Kickstarter_JP より)"
  public static func project_share_twitter_message(project_title: String) -> String {
    return localizedString(
      key: "project.share.twitter.message",
      defaultValue: "%{project_title}, via @Kickstarter",
      count: nil,
      substitutions: ["project_title": project_title]
    )
  }
  /// "Couldn't send message. Try again."
  ///
  /// - **en**: "Couldn't send message. Try again."
  /// - **de**: "Nachricht nicht versandt. Versuche es erneut."
  /// - **es**: "No se pudo enviar el mensaje. Inténtalo de nuevo."
  /// - **fr**: "Impossible d'envoyer votre message. Veuillez réessayer plus tard."
  /// - **ja**: "メッセージ送信失敗。もう一度お試しください。"
  public static func social_error_could_not_send_message_backer() -> String {
    return localizedString(
      key: "social.error_could_not_send_message_backer",
      defaultValue: "Couldn't send message. Try again.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Couldn't send message. Try again."
  ///
  /// - **en**: "Couldn't send message. Try again."
  /// - **de**: "Nachricht nicht versandt. Versuche es erneut."
  /// - **es**: "No se pudo enviar el mensaje. Inténtalo de nuevo."
  /// - **fr**: "Impossible d'envoyer votre message. Veuillez réessayer plus tard."
  /// - **ja**: "メッセージ送信失敗。もう一度お試しください。"
  public static func social_error_could_not_send_message_creator() -> String {
    return localizedString(
      key: "social.error_could_not_send_message_creator",
      defaultValue: "Couldn't send message. Try again.",
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
  public static func social_message_creator() -> String {
    return localizedString(
      key: "social.message_creator",
      defaultValue: "Message creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Private message"
  ///
  /// - **en**: "Private message"
  /// - **de**: "Private Nachricht"
  /// - **es**: "Mensaje privado"
  /// - **fr**: "Message privé"
  /// - **ja**: "プライベートメッセージ"
  public static func social_private_message() -> String {
    return localizedString(
      key: "social.private_message",
      defaultValue: "Private message",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Looks like you don’t have an e-mail account on your device. Please contact us at app@kickstarter.com."
  ///
  /// - **en**: "Looks like you don’t have an e-mail account on your device. Please contact us at app@kickstarter.com."
  /// - **de**: "Es sieht so aus, als hättest du keinen E-Mail-Account auf deinem Gerät. Bitte kontaktiere uns unter app@kickstarter.com."
  /// - **es**: "Parece que no tienes una cuenta de correo electrónico en tu dispositivo. Por favor ponte en contacto con nosotros a través de app@kickstarter.com."
  /// - **fr**: "On dirait que vous n'avez pas de compte e-mail sur votre appareil. Veuillez nous contacter à l'adresse app@kickstarter.com."
  /// - **ja**: "メールアカウントをお持ちですか？ app@kickstarter.comまでご連絡ください。"
  public static func support_email_noemail_message() -> String {
    return localizedString(
      key: "support_email.noemail.message",
      defaultValue: "Looks like you don’t have an e-mail account on your device. Please contact us at app@kickstarter.com.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Looks like you don’t have an e-mail account on your device. Please contact us at android@kickstarter.com."
  ///
  /// - **en**: "Looks like you don’t have an e-mail account on your device. Please contact us at android@kickstarter.com."
  /// - **de**: "Es sieht so aus, als hättest du keinen E-Mail-Account auf deinem Gerät. Bitte kontaktiere uns unter app@kickstarter.com."
  /// - **es**: "Parece que no tienes una cuenta de correo electrónico en tu dispositivo. Contáctanos en app@kickstarter.com."
  /// - **fr**: "On dirait que vous n'avez pas de compte e-mail sur votre appareil. Veuillez nous contacter à l'adresse android@kickstarter.com."
  /// - **ja**: "メールアカウントをお持ちですか？ app@kickstarter.comまでご連絡ください。"
  public static func support_email_noemail_message_android() -> String {
    return localizedString(
      key: "support_email.noemail.message_android",
      defaultValue: "Looks like you don’t have an e-mail account on your device. Please contact us at android@kickstarter.com.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Aw, how sad. Be the first backer to leave a comment on this update."
  ///
  /// - **en**: "Aw, how sad. Be the first backer to leave a comment on this update."
  /// - **de**: "Oh wie schade! Sei der erste Unterstützer, der dieses Update kommentiert."
  /// - **es**: "Ay, qué pena. Sé el primer patrocinador en dejar un comentario en este proyecto."
  /// - **fr**: "Oh, quel dommage.  Soyez le premier contributeur à laisser un commentaire sur cette actu."
  /// - **ja**: "初めてのコメントを残しましょう。"
  public static func update_comments_empty_state_backer_message() -> String {
    return localizedString(
      key: "update.comments.empty_state.backer.message",
      defaultValue: "Aw, how sad. Be the first backer to leave a comment on this update.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Aw, how sad. Become a backer to leave a comment."
  ///
  /// - **en**: "Aw, how sad. Become a backer to leave a comment."
  /// - **de**: "Oh wie Schade. Werde Unterstützer um einen Kommentar zu hinterlassen."
  /// - **es**: "Ay, qué pena. Hazte patrocinador para dejar un comentario."
  /// - **fr**: "Oh, quel dommage. Soutenez ce projet afin de pouvoir laisser un commentaire."
  /// - **ja**: "バッカーになってコメントする"
  public static func update_comments_empty_state_logged_out_message() -> String {
    return localizedString(
      key: "update.comments.empty_state.logged_out.message",
      defaultValue: "Aw, how sad. Become a backer to leave a comment.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Aw, how sad. Become a backer to leave a comment."
  ///
  /// - **en**: "Aw, how sad. Become a backer to leave a comment."
  /// - **de**: "Oh wie Schade. Werde Unterstützer um einen Kommentar zu hinterlassen."
  /// - **es**: "Ay, qué pena. Hazte patrocinador para dejar un comentario."
  /// - **fr**: "Oh, quel dommage. Soutenez ce projet afin de pouvoir laisser un commentaire."
  /// - **ja**: "バッカーになってコメントする"
  public static func update_comments_empty_state_non_backer_message() -> String {
    return localizedString(
      key: "update.comments.empty_state.non_backer.message",
      defaultValue: "Aw, how sad. Become a backer to leave a comment.",
      count: nil,
      substitutions: [:]
    )
  }
}
