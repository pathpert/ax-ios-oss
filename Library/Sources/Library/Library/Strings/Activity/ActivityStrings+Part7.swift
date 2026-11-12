// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "Successfully funded!"
  ///
  /// - **en**: "Successfully funded!"
  /// - **de**: "Erfolgreich finanziert!"
  /// - **es**: "¡Financiado con éxito!"
  /// - **fr**: "Intégralement financé !"
  /// - **ja**: "資金調達に成功"
  public static func activity_successfully_funded() -> String {
    return localizedString(
      key: "activity.successfully_funded",
      defaultValue: "Successfully funded!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{user_name} is now following you!"
  ///
  /// - **en**: "%{user_name} is now following you!"
  /// - **de**: "%{user_name} folgt dir!"
  /// - **es**: "¡%{user_name} te sigue!"
  /// - **fr**: "%{user_name} vous suit !"
  /// - **ja**: "%{user_name} はあなたをフォロー中！"
  public static func activity_user_name_is_now_following_you(user_name: String) -> String {
    return localizedString(
      key: "activity.user_name_is_now_following_you",
      defaultValue: "%{user_name} is now following you!",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "%{user_name} launched a project."
  ///
  /// - **en**: "%{user_name} launched a project."
  /// - **de**: "%{user_name} hat ein Projekt veröffentlicht."
  /// - **es**: "%{user_name} publicó un proyecto."
  /// - **fr**: "%{user_name} a lancé un projet."
  /// - **ja**: "%{user_name} がプロジェクトをローンチ！"
  public static func activity_user_name_launched_project(user_name: String) -> String {
    return localizedString(
      key: "activity.user_name_launched_project",
      defaultValue: "%{user_name} launched a project.",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "Connect with Twitter"
  ///
  /// - **en**: "Connect with Twitter"
  /// - **de**: "MIt Twitter verknüpfen"
  /// - **es**: "Conectar con Twitter"
  /// - **fr**: "Connexion Twitter"
  /// - **ja**: "Twitterと繋げる"
  public static func general_social_buttons_connect_with_twitter() -> String {
    return localizedString(
      key: "general.social.buttons.connect_with_twitter",
      defaultValue: "Connect with Twitter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Find Facebook friends"
  ///
  /// - **en**: "Find Facebook friends"
  /// - **de**: "Freunde finden"
  /// - **es**: "Encontrar amigos"
  /// - **fr**: "Rechercher mes amis Facebook"
  /// - **ja**: "Facebook の友達をさがす"
  public static func profile_settings_social_find_friends() -> String {
    return localizedString(
      key: "profile.settings.social.find_friends",
      defaultValue: "Find Facebook friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "New followers"
  ///
  /// - **en**: "New followers"
  /// - **de**: "Neue Follower"
  /// - **es**: "Nuevos seguidores"
  /// - **fr**: "Nouveaux abonnés"
  /// - **ja**: "Newフォロワー"
  public static func profile_settings_social_followers() -> String {
    return localizedString(
      key: "profile.settings.social.followers",
      defaultValue: "New followers",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Friend backs a project"
  ///
  /// - **en**: "Friend backs a project"
  /// - **de**: "Ein Freund unterstützt ein Projekt"
  /// - **es**: "Un amigo patrocina un proyecto"
  /// - **fr**: "Un ami soutient un projet"
  /// - **ja**: "友人がバックしています"
  public static func profile_settings_social_friend_backs() -> String {
    return localizedString(
      key: "profile.settings.social.friend_backs",
      defaultValue: "Friend backs a project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Social notifications"
  ///
  /// - **en**: "Social notifications"
  /// - **de**: "Neues aus deinem Netzwerk"
  /// - **es**: "Notificaciones de redes sociales"
  /// - **fr**: "Notifications sociales"
  /// - **ja**: "ソーシャル通知"
  public static func profile_settings_social_title() -> String {
    return localizedString(
      key: "profile.settings.social.title",
      defaultValue: "Social notifications",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{friend_name} and %{second_friend_name} are backers."
  ///
  /// - **en**: "%{friend_name} and %{second_friend_name} are backers."
  /// - **de**: "%{friend_name} und %{second_friend_name} unterstützen dieses Projekt."
  /// - **es**: "%{friend_name} y %{second_friend_name} patrocinan este proyecto."
  /// - **fr**: "%{friend_name} et %{second_friend_name} sont contributeurs."
  /// - **ja**: "%{friend_name} と%{second_friend_name} がバッカー"
  public static func project_social_friend_and_friend_are_backers(friend_name: String, second_friend_name: String) -> String {
    return localizedString(
      key: "project.social.friend_and_friend_are_backers",
      defaultValue: "%{friend_name} and %{second_friend_name} are backers.",
      count: nil,
      substitutions: ["friend_name": friend_name, "second_friend_name": second_friend_name]
    )
  }
  /// "%{friend_name} is a backer."
  ///
  /// - **en**: "%{friend_name} is a backer."
  /// - **de**: "%{friend_name} unterstützt dieses Projekt."
  /// - **es**: "%{friend_name} patrocina este proyecto."
  /// - **fr**: "%{friend_name} est contributeur."
  /// - **ja**: "%{friend_name} がバッカー"
  public static func project_social_friend_is_backer(friend_name: String) -> String {
    return localizedString(
      key: "project.social.friend_is_backer",
      defaultValue: "%{friend_name} is a backer.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "%{backer_count} more"
  ///
  /// - **en**: "%{backer_count} more"
  /// - **de**: "%{backer_count} weitere"
  /// - **es**: "%{backer_count} más"
  /// - **fr**: "%{backer_count} autres personnes"
  /// - **ja**: "%{backer_count} 人以上"
  public static func project_social_friends_are_backers_and_more_bold(backer_count: Int) -> String {
    return localizedString(
      key: "project.social.friends_are_backers_and_more_bold",
      defaultValue: "%{backer_count} more",
      count: backer_count,
      substitutions: ["backer_count": Format.wholeNumber(backer_count)]
    )
  }
  /// "%{backer_count} more"
  ///
  /// - **en**: "%{backer_count} more"
  /// - **de**: "%{backer_count} weitere"
  /// - **es**: "%{backer_count} más"
  /// - **fr**: "%{backer_count} autres personnes"
  /// - **ja**: "%{backer_count} 人以上"
  public static func project_social_friends_are_backers_and_more_bold_other(backer_count: String) -> String {
    return localizedString(
      key: "project.social.friends_are_backers_and_more_bold.other",
      defaultValue: "%{backer_count} more",
      count: nil,
      substitutions: ["backer_count": backer_count]
    )
  }
  /// "%{friends} and %{backer_count} more are backers."
  ///
  /// - **en**: "%{friends} and %{backer_count} more are backers."
  /// - **de**: "%{friends} und %{backer_count} weitere Personen unterstützen dieses Projekt."
  /// - **es**: "%{friends} y %{backer_count} personas más patrocinan este proyecto."
  /// - **fr**: "%{friends} et %{backer_count} autres personnes sont contributeurs."
  /// - **ja**: "%{friends} と他%{backer_count} 人がバッカー"
  public static func project_social_friends_are_backers_and_more_count(friends: String, backer_count: Int) -> String {
    return localizedString(
      key: "project.social.friends_are_backers_and_more_count",
      defaultValue: "%{friends} and %{backer_count} more are backers.",
      count: backer_count,
      substitutions: ["friends": friends, "backer_count": Format.wholeNumber(backer_count)]
    )
  }
  /// "%{friends} and %{backer_count} more are backers."
  ///
  /// - **en**: "%{friends} and %{backer_count} more are backers."
  /// - **de**: "%{friends} und %{backer_count} weitere Personen unterstützen dieses Projekt."
  /// - **es**: "%{friends} y %{backer_count} personas más patrocinan este proyecto."
  /// - **fr**: "%{friends} et %{backer_count} autres personnes sont contributeurs."
  /// - **ja**: "%{friends} と他%{backer_count} 人がバッカー"
  public static func project_social_friends_are_backers_and_more_count_other(friends: String, backer_count: String) -> String {
    return localizedString(
      key: "project.social.friends_are_backers_and_more_count.other",
      defaultValue: "%{friends} and %{backer_count} more are backers.",
      count: nil,
      substitutions: ["friends": friends, "backer_count": backer_count]
    )
  }
  /// ", "
  ///
  /// - **en**: ", "
  /// - **de**: ", "
  /// - **es**: ", "
  /// - **fr**: ", "
  /// - **ja**: "、 "
  public static func project_social_friends_separator() -> String {
    return localizedString(
      key: "project.social.friends_separator",
      defaultValue: ", ",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cancel"
  ///
  /// - **en**: "Cancel"
  /// - **de**: "Abbrechen"
  /// - **es**: "Cancelar"
  /// - **fr**: "Annuler"
  /// - **ja**: "キャンセル"
  public static func social_buttons_cancel() -> String {
    return localizedString(
      key: "social.buttons.cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
}
