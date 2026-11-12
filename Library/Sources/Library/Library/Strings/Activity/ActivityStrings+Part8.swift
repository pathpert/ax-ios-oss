// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "Post"
  ///
  /// - **en**: "Post"
  /// - **de**: "Posten"
  /// - **es**: "Publicar"
  /// - **fr**: "Publier"
  /// - **ja**: "投稿する"
  public static func social_buttons_post() -> String {
    return localizedString(
      key: "social.buttons.post",
      defaultValue: "Post",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Send"
  ///
  /// - **en**: "Send"
  /// - **de**: "Senden"
  /// - **es**: "Enviar"
  /// - **fr**: "Envoyer"
  /// - **ja**: "送信"
  public static func social_buttons_send() -> String {
    return localizedString(
      key: "social.buttons.send",
      defaultValue: "Send",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Couldn't post. Try again later."
  ///
  /// - **en**: "Couldn't post. Try again later."
  /// - **de**: "Post fehlgeschlagen. Versuche es einfach später nochmal."
  /// - **es**: "No se pudo publicar. Inténtalo de nuevo más tarde."
  /// - **fr**: "Publication impossible. Veuillez réessayer plus tard."
  /// - **ja**: "投稿に失敗しました。もう一度お試しください。"
  public static func social_error_could_not_post_try_again() -> String {
    return localizedString(
      key: "social.error_could_not_post_try_again",
      defaultValue: "Couldn't post. Try again later.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No internet connection. Try again later."
  ///
  /// - **en**: "No internet connection. Try again later."
  /// - **de**: "Keine Internetverbindung. Versuche es später noch einmal."
  /// - **es**: "No hay conexión a internet. Inténtalo de nuevo."
  /// - **fr**: "Pas de connexion internet. Veuillez réessayer plus tard."
  /// - **ja**: "接続不可。後ほどお試しください。"
  public static func social_error_no_internet_connection() -> String {
    return localizedString(
      key: "social.error_no_internet_connection",
      defaultValue: "No internet connection. Try again later.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Public comment"
  ///
  /// - **en**: "Public comment"
  /// - **de**: "Öffentlicher Kommentar"
  /// - **es**: "Comentario público"
  /// - **fr**: "Commentaire public"
  /// - **ja**: "公開コメント"
  public static func social_public_comment() -> String {
    return localizedString(
      key: "social.public_comment",
      defaultValue: "Public comment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Update"
  ///
  /// - **en**: "Update"
  /// - **de**: "Update"
  /// - **es**: "Actualización"
  /// - **fr**: "Actu"
  /// - **ja**: "アップデート"
  public static func social_update() -> String {
    return localizedString(
      key: "social.update",
      defaultValue: "Update",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Update #%{update_number}"
  ///
  /// - **en**: "Update #%{update_number}"
  /// - **de**: "Update Nr. %{update_number}"
  /// - **es**: "Actualización %{update_number}"
  /// - **fr**: "Actu no. %{update_number}"
  /// - **ja**: "アップデート #%{update_number}"
  public static func social_update_number(update_number: String) -> String {
    return localizedString(
      key: "social.update_number",
      defaultValue: "Update #%{update_number}",
      count: nil,
      substitutions: ["update_number": update_number]
    )
  }
  /// "Update #%{update_number}: %{update_title}"
  ///
  /// - **en**: "Update #%{update_number}: %{update_title}"
  /// - **de**: "Aktualisierung %{update_number}: %{update_title}"
  /// - **es**: "Actualización %{update_number}: %{update_title}"
  /// - **fr**: "Actu no. %{update_number} : %{update_title}"
  /// - **ja**: "アップデート＃%{update_number}：%{update_title}"
  public static func social_update_sequence_and_title(update_number: String, update_title: String) -> String {
    return localizedString(
      key: "social.update_sequence_and_title",
      defaultValue: "Update #%{update_number}: %{update_title}",
      count: nil,
      substitutions: ["update_number": update_number, "update_title": update_title]
    )
  }
  /// "Check out some projects!"
  ///
  /// - **en**: "Check out some projects!"
  /// - **de**: "Schau dir diese Projekte an!"
  /// - **es**: "¡Checa algunos de los proyectos aquÍ!"
  /// - **fr**: "Découvrez des projets !"
  /// - **ja**: "プロジェクトを探す"
  public static func social_following_button_check_out_some_projects() -> String {
    return localizedString(
      key: "social_following.button.check_out_some_projects",
      defaultValue: "Check out some projects!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow"
  ///
  /// - **en**: "Follow"
  /// - **de**: "Folgen"
  /// - **es**: "Seguir"
  /// - **fr**: "S'abonner"
  /// - **ja**: "フォローする"
  public static func social_following_friend_buttons_follow() -> String {
    return localizedString(
      key: "social_following.friend.buttons.follow",
      defaultValue: "Follow",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Following"
  ///
  /// - **en**: "Following"
  /// - **de**: "Gefolgt"
  /// - **es**: "Siguiendo"
  /// - **fr**: "Abonné"
  /// - **ja**: "フォロー中"
  public static func social_following_friend_buttons_following() -> String {
    return localizedString(
      key: "social_following.friend.buttons.following",
      defaultValue: "Following",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{backed_count} backed"
  ///
  /// - **en**: "%{backed_count} backed"
  /// - **de**: "%{backed_count} unterstützt"
  /// - **es**: "%{backed_count} patrocinados"
  /// - **fr**: "%{backed_count} projets soutenus"
  /// - **ja**: "%{backed_count} バック済"
  public static func social_following_friend_projects_count_backed(backed_count: Int) -> String {
    return localizedString(
      key: "social_following.friend.projects_count_backed",
      defaultValue: "%{backed_count} backed",
      count: backed_count,
      substitutions: ["backed_count": Format.wholeNumber(backed_count)]
    )
  }
  /// "%{backed_count} backed"
  ///
  /// - **en**: "%{backed_count} backed"
  /// - **de**: "%{backed_count} unterstützt"
  /// - **es**: "%{backed_count} proyectos patrocinados"
  /// - **fr**: "%{backed_count} projets soutenus"
  /// - **ja**: "%{backed_count} バック済"
  public static func social_following_friend_projects_count_backed_other(backed_count: String) -> String {
    return localizedString(
      key: "social_following.friend.projects_count_backed.other",
      defaultValue: "%{backed_count} backed",
      count: nil,
      substitutions: ["backed_count": backed_count]
    )
  }
  /// "%{created_count} created"
  ///
  /// - **en**: "%{created_count} created"
  /// - **de**: "%{created_count} erstellt"
  /// - **es**: "%{created_count} creados"
  /// - **fr**: "%{created_count} projets créés"
  /// - **ja**: "%{created_count}プロジェクト"
  public static func social_following_friend_projects_count_created(created_count: Int) -> String {
    return localizedString(
      key: "social_following.friend.projects_count_created",
      defaultValue: "%{created_count} created",
      count: created_count,
      substitutions: ["created_count": Format.wholeNumber(created_count)]
    )
  }
  /// "%{created_count} created"
  ///
  /// - **en**: "%{created_count} created"
  /// - **de**: "%{created_count} erstellt"
  /// - **es**: "%{created_count} proyectos creados"
  /// - **fr**: "%{created_count} projets créés"
  /// - **ja**: "%{created_count}プロジェクト"
  public static func social_following_friend_projects_count_created_other(created_count: String) -> String {
    return localizedString(
      key: "social_following.friend.projects_count_created.other",
      defaultValue: "%{created_count} created",
      count: nil,
      substitutions: ["created_count": created_count]
    )
  }
  /// "Find your friends"
  ///
  /// - **en**: "Find your friends"
  /// - **de**: "Finde deine Freunde"
  /// - **es**: "Encuentra tus amigos"
  /// - **fr**: "Rechercher vos amis"
  /// - **ja**: "友達をさがす"
  public static func social_following_header_button_find_your_friends() -> String {
    return localizedString(
      key: "social_following.header.button.find_your_friends",
      defaultValue: "Find your friends",
      count: nil,
      substitutions: [:]
    )
  }
}
