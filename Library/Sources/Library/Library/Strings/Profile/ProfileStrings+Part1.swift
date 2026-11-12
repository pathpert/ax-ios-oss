// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProfileStrings {
  /// "Biography"
  ///
  /// - **en**: "Biography"
  /// - **de**: "Biografie"
  /// - **es**: "Biografía"
  /// - **fr**: "Biographie"
  /// - **ja**: "自己紹介"
  public static func Biography() -> String {
    return localizedString(
      key: "Biography",
      defaultValue: "Biography",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your request did not go through. Try again."
  ///
  /// - **en**: "Your request did not go through. Try again."
  /// - **de**: "Deine Anfrage konnte nicht verarbeitet werden. Bitte versuche es noch einmal."
  /// - **es**: "Tu solicitud no se procesó. Intenta otra vez."
  /// - **fr**: "Votre demande a échoué. Veuillez réessayer."
  /// - **ja**: "リクエストを処理できませんでした。もう一度お試しください。"
  public static func Block_user_fail() -> String {
    return localizedString(
      key: "Block_user_fail",
      defaultValue: "Your request did not go through. Try again.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This user has been successfully blocked"
  ///
  /// - **en**: "This user has been successfully blocked"
  /// - **de**: "Dieser Nutzer wurde erfolgreich blockiert"
  /// - **es**: "Este usuario se bloqueó con éxito."
  /// - **fr**: "Cet utilisateur a bien été bloqué."
  /// - **ja**: "このユーザーをブロックしました"
  public static func Block_user_success() -> String {
    return localizedString(
      key: "Block_user_success",
      defaultValue: "This user has been successfully blocked",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Block %{username}?"
  ///
  /// - **en**: "Block %{username}?"
  /// - **de**: "%{username} blockieren?"
  /// - **es**: "¿Bloquear a %{username}?"
  /// - **fr**: "Bloquer %{username} ?"
  /// - **ja**: "%{username} をブロックしますか？"
  public static func Block_username(username: String) -> String {
    return localizedString(
      key: "Block_username",
      defaultValue: "Block %{username}?",
      count: nil,
      substitutions: ["username": username]
    )
  }
  /// "Blocked User"
  ///
  /// - **en**: "Blocked User"
  /// - **de**: "Blockierter Nutzer"
  /// - **es**: "Usuario bloqueado"
  /// - **fr**: "Utilisateur bloqué"
  /// - **ja**: "ブロックされたユーザー"
  public static func Blocked_user() -> String {
    return localizedString(
      key: "Blocked_user",
      defaultValue: "Blocked User",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Blocking this user means that you won’t see their comments or content anymore. If you have saved or backed projects from this user, you must remove your pledge before blocking. To unblock a user in the future, please go through our Help Center."
  ///
  /// - **en**: "Blocking this user means that you won’t see their comments or content anymore. If you have saved or backed projects from this user, you must remove your pledge before blocking. To unblock a user in the future, please go through our Help Center."
  /// - **de**: "Wenn du diesen Nutzer blockierst, siehst du keine Kommentare oder Inhalte mehr von ihm. Falls du Projekte von diesem Nutzer gespeichert oder unterstützt hast, musst du deinen Beitrag vor dem Blockieren entfernen. Weitere Informationen dazu, wie du die Blockierung eines Nutzers aufheben kannst, findest du im Hilfecenter."
  /// - **es**: "Al bloquear a este usuario, ya no verás sus comentarios ni su contenido. Si guardaste o patrocinaste proyectos del usuario, debes eliminar tu contribución antes de bloquearlo. Puedes desbloquear usuarios desde nuestro Centro de ayuda."
  /// - **fr**: "Si vous bloquez cet utilisateur, vous ne verrez plus ses commentaires ni son contenu. Si vous avez sauvegardé ou soutenu ses projets, veuillez supprimer votre engagement avant de le bloquer. Pour débloquer un utilisateur, veuillez consulter notre Centre d'assistance."
  /// - **ja**: "このユーザーをブロックすると、その後はこのユーザーのコメントやコンテンツを閲覧することができなくなります。このユーザーのプロジェクトを保存またはバックしたことがある場合は、ブロックする前にプレッジを取り消す必要があります。今後ユーザーのブロックを解除するには、ヘルプセンターをご参照ください。"
  public static func Blocked_user_confirmation() -> String {
    return localizedString(
      key: "Blocked_user_confirmation",
      defaultValue: "Blocking this user means that you won’t see their comments or content anymore. If you have saved or backed projects from this user, you must remove your pledge before blocking. To unblock a user in the future, please go through our Help Center.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "By a superbacker"
  ///
  /// - **en**: "By a superbacker"
  /// - **de**: "Von einem Superbacker"
  /// - **es**: "De un superbacker"
  /// - **fr**: "Par un Superbacker"
  /// - **ja**: "スーパーバッカー"
  public static func By_a_superbacker() -> String {
    return localizedString(
      key: "By_a_superbacker",
      defaultValue: "By a superbacker",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Got it! Your survey response has been submitted."
  ///
  /// - **en**: "Got it! Your survey response has been submitted."
  /// - **de**: "Alles klar! Deine Antwort auf die Befragung wurde übermittelt."
  /// - **es**: "¡Listo! Hemos recibido tus respuestas a nuestro cuestionario."
  /// - **fr**: "Merci ! Vos réponses au questionnaire ont bien été envoyées."
  /// - **ja**: "サーベイを送信しました！"
  public static func Got_it_your_survey_response_has_been_submitted() -> String {
    return localizedString(
      key: "Got_it_your_survey_response_has_been_submitted",
      defaultValue: "Got it! Your survey response has been submitted.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "If your profile is private, others can see your name and picture."
  ///
  /// - **en**: "If your profile is private, others can see your name and picture."
  /// - **de**: "Wenn dein Profil privat ist, sind dein Namen und dein Profilbild für Andere sichtbar."
  /// - **es**: "Si tu perfil es privado, otros usuarios podrán ver tu nombre e imagen.
  /// 
  /// - **fr**: "Si votre profil est privé, seuls votre nom et votre photo seront visibles."
  /// - **ja**: "プロフィールがプライベート (非公開) 設定の場合、あなたの名前と写真が表示されます。"
  public static func If_your_profile_is_private() -> String {
    return localizedString(
      key: "If_your_profile_is_private",
      defaultValue: "If your profile is private, others can see your name and picture.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "If your profile is not private, others can also see the projects you've backed, your location, bio and websites."
  ///
  /// - **en**: "If your profile is not private, others can also see the projects you've backed, your location, bio and websites."
  /// - **de**: "Wenn dein Profil nicht privat ist, sind außerdem die Projekte, die du unterstützt hast, dein Standort, deine Biografie und deine Websites für Andere sichtbar."
  /// - **es**: "Si tu perfil no es privado, otros usuarios también podrán ver los proyectos que has patrocinado, tu ubicación, biografía y sitios web."
  /// - **fr**: "Si votre profil n'est pas privé, les projets que vous avez soutenus, votre bio, votre emplacement géographique et vos sites Web seront également visibles."
  /// - **ja**: "プロフィールがプライベート (非公開) 設定でない場合は、過去にあなたがバックしたプロジェクトや、あなたの地域情報、あなたの自己紹介欄とウェブサイトも表示されます。"
  public static func If_your_profile_is_public() -> String {
    return localizedString(
      key: "If_your_profile_is_public",
      defaultValue: "If your profile is not private, others can also see the projects you've backed, your location, bio and websites.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No saved projects"
  ///
  /// - **en**: "No saved projects"
  /// - **de**: "Keine gespeicherten Projekte"
  /// - **es**: "No hay proyectos guardados"
  /// - **fr**: "Pas de projets enregistrés"
  /// - **ja**: "保存済みのプロジェクトはありません"
  public static func No_saved_projects() -> String {
    return localizedString(
      key: "No_saved_projects",
      defaultValue: "No saved projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Private profile more info"
  ///
  /// - **en**: "Private profile more info"
  /// - **de**: "Privates Profil - Mehr Info"
  /// - **es**: "Más información sobre el perfil privado"
  /// - **fr**: "Plus d'informations sur le profil privé"
  /// - **ja**: "プライベート設定のプロフィール詳細"
  public static func Private_profile_more_info() -> String {
    return localizedString(
      key: "Private_profile_more_info",
      defaultValue: "Private profile more info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Kickstarter profiles are private by default. To make your profile public and visible to the world, turn this off."
  ///
  /// - **en**: "Kickstarter profiles are private by default. To make your profile public and visible to the world, turn this off."
  /// - **de**: "Die Standard-Einstellung für Profile sind auf Kickstarter ist privat. Um dein Profil öffentlich zu machen, hebe diese Einstellung bitte auf."
  /// - **es**: "Los perfiles de Kickstarter son privados por defecto. Para hacer que tu perfil sea público y visible para el mundo, desactiva esta opción."
  /// - **fr**: "Par défaut, les profils Kickstarter sont privés. Pour rendre votre profil public et visible par tout le monde, décochez cette case."
  /// - **ja**: "Kickstarter でのプロフィールはデフォルト設定ではプライベート (非公開) となっています。プロフィールを公開したい場合はこの設定をオフにしてください。"
  public static func Private_profile_more_info_content() -> String {
    return localizedString(
      key: "Private_profile_more_info_content",
      defaultValue: "Kickstarter profiles are private by default. To make your profile public and visible to the world, turn this off.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Saved projects"
  ///
  /// - **en**: "Saved projects"
  /// - **de**: "Gespeicherte Projekte"
  /// - **es**: "Proyectos guardados"
  /// - **fr**: "Projets enregistrés"
  /// - **ja**: "保存済みのプロジェクト"
  public static func Saved_projects() -> String {
    return localizedString(
      key: "Saved_projects",
      defaultValue: "Saved projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Saved projects"
  ///
  /// - **en**: "Saved projects"
  /// - **de**: "Gespeicherte Projekte"
  /// - **es**: "Proyectos guardados"
  /// - **fr**: "Projets enregistrés"
  /// - **ja**: "保存済みプロジェクト"
  public static func Show_only_saved_projects() -> String {
    return localizedString(
      key: "Show_only_saved_projects",
      defaultValue: "Saved projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Superbacker"
  ///
  /// - **en**: "Superbacker"
  /// - **de**: "Superbacker"
  /// - **es**: "Superbacker"
  /// - **fr**: "Superbacker"
  /// - **ja**: "Superbacker"
  public static func Superbacker() -> String {
    return localizedString(
      key: "Superbacker",
      defaultValue: "Superbacker",
      count: nil,
      substitutions: [:]
    )
  }
}
