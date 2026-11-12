// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "Follow your Facebook friends and get notified when they back or launch projects."
  ///
  /// - **en**: "Follow your Facebook friends and get notified when they back or launch projects."
  /// - **de**: "Folge deinen Freunden und wir werden dich benachrichtigen, sobald sie ein Projekt unterstützen oder veröffentlichen."
  /// - **es**: "Sigue a tus amigos y te avisaremos cuando publican o patrocinan un proyecto."
  /// - **fr**: "Suivez vos amis Facebook pour recevoir une notification chaque fois qu'ils soutiennent ou lancent un nouveau projet."
  /// - **ja**: "Facebookの友達をフォローしよう！"
  public static func social_following_header_connect_with_your_friends_to_find_projects() -> String {
    return localizedString(
      key: "social_following.header.connect_with_your_friends_to_find_projects",
      defaultValue: "Follow your Facebook friends and get notified when they back or launch projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Discover more projects."
  ///
  /// - **en**: "Discover more projects."
  /// - **de**: "Noch mehr Projekte erkunden."
  /// - **es**: "Descubre más proyectos."
  /// - **fr**: "Découvrir plus de projets"
  /// - **ja**: "さらにプロジェクトをさがす"
  public static func social_following_header_friends_recommend_the_best_projects() -> String {
    return localizedString(
      key: "social_following.header.friends_recommend_the_best_projects",
      defaultValue: "Discover more projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow friends"
  ///
  /// - **en**: "Follow friends"
  /// - **de**: "Folge deinen Freunden!"
  /// - **es**: "¡Sigue a tus amigos!"
  /// - **fr**: "Suivre vos amis"
  /// - **ja**: "友達をフォロー"
  public static func social_following_navigation_title_follow_your_friends() -> String {
    return localizedString(
      key: "social_following.navigation.title.follow_your_friends",
      defaultValue: "Follow friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Nice! You're about to follow all of your friends."
  ///
  /// - **en**: "Nice! You're about to follow all of your friends."
  /// - **de**: "Super! Du folgst jetzt allen deinen Freunden!"
  /// - **es**: "¡Estupendo - ahora sigues a todos tus amigos!"
  /// - **fr**: "Super ! Vous êtes sur le point de suivre tous vos amis."
  /// - **ja**: "友達をフォローしましょう！"
  public static func social_following_nice_youre_about_to_follow_all_friends() -> String {
    return localizedString(
      key: "social_following.nice_youre_about_to_follow_all_friends",
      defaultValue: "Nice! You're about to follow all of your friends.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backed projects"
  ///
  /// - **en**: "Backed projects"
  /// - **de**: "Unterstützte Projekte"
  /// - **es**: "Proyectos patrocinados"
  /// - **fr**: "projets soutenus"
  /// - **ja**: "バック済"
  public static func social_following_stats_backed_projects() -> String {
    return localizedString(
      key: "social_following.stats.backed_projects",
      defaultValue: "Backed projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow all %{remote_friends_count} friends"
  ///
  /// - **en**: "Follow all %{remote_friends_count} friends"
  /// - **de**: "Allen %{remote_friends_count} Freunden folgen"
  /// - **es**: "Seguir a %{remote_friends_count} amigos"
  /// - **fr**: "Suivre ces %{remote_friends_count} amis"
  /// - **ja**: "%{remote_friends_count} 人を全員フォロー"
  public static func social_following_stats_button_follow_all_friends(remote_friends_count: Int) -> String {
    return localizedString(
      key: "social_following.stats.button.follow_all_friends",
      defaultValue: "Follow all %{remote_friends_count} friends",
      count: remote_friends_count,
      substitutions: ["remote_friends_count": Format.wholeNumber(remote_friends_count)]
    )
  }
  /// "Follow all %{remote_friends_count} friends"
  ///
  /// - **en**: "Follow all %{remote_friends_count} friends"
  /// - **de**: "Allen %{remote_friends_count} Freunden folgen"
  /// - **es**: "Seguir a %{remote_friends_count} amigos"
  /// - **fr**: "Suivre ces %{remote_friends_count} amis"
  /// - **ja**: "%{remote_friends_count} 人を全員フォロー"
  public static func social_following_stats_button_follow_all_friends_other(remote_friends_count: String) -> String {
    return localizedString(
      key: "social_following.stats.button.follow_all_friends.other",
      defaultValue: "Follow all %{remote_friends_count} friends",
      count: nil,
      substitutions: ["remote_friends_count": remote_friends_count]
    )
  }
  /// "Friends"
  ///
  /// - **en**: "Friends"
  /// - **de**: "Freunde"
  /// - **es**: "Amigos"
  /// - **fr**: "amis"
  /// - **ja**: "友達"
  public static func social_following_stats_friends() -> String {
    return localizedString(
      key: "social_following.stats.friends",
      defaultValue: "Friends",
      count: nil,
      substitutions: [:]
    )
  }
}
