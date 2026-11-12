// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "Backed by Friends"
  ///
  /// - **en**: "Backed by Friends"
  /// - **de**: "Von Freunden unterstützt"
  /// - **es**: "Patrocinados por amigos"
  /// - **fr**: "Soutenu par mes amis"
  /// - **ja**: "友達がバックしたプロジェクト"
  public static func Backed_by_Friends() -> String {
    return localizedString(
      key: "Backed_by_Friends",
      defaultValue: "Backed by Friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backed by people you follow"
  ///
  /// - **en**: "Backed by people you follow"
  /// - **de**: "Unterstützt von Personen, denen du folgst"
  /// - **es**: "Patrocinados por gente que sigues"
  /// - **fr**: "Soutenus par ceux que vous suivez"
  /// - **ja**: "フォロー中の友達がバック"
  public static func Backed_by_people_you_follow() -> String {
    return localizedString(
      key: "Backed_by_people_you_follow",
      defaultValue: "Backed by people you follow",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Environmentally friendly factories"
  ///
  /// - **en**: "Environmentally friendly factories"
  /// - **de**: "Umweltfreundliche Fertigungsanlagen"
  /// - **es**: "Fábricas ecológicas"
  /// - **fr**: "Usines respectueuses de l'environnement"
  /// - **ja**: "環境に優しい工場"
  public static func Environmentally_friendly_factories() -> String {
    return localizedString(
      key: "Environmentally_friendly_factories",
      defaultValue: "Environmentally friendly factories",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Find and follow friends"
  ///
  /// - **en**: "Find and follow friends"
  /// - **de**: "Freunde finden und folgen"
  /// - **es**: "Encontrar y seguir a amigos"
  /// - **fr**: "Retrouver et suivre mes amis"
  /// - **ja**: "友達を見つけてフォロー"
  public static func Find_and_follow_friends() -> String {
    return localizedString(
      key: "Find_and_follow_friends",
      defaultValue: "Find and follow friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow %{friend_name}"
  ///
  /// - **en**: "Follow %{friend_name}"
  /// - **de**: "%{friend_name} folgen."
  /// - **es**: "Seguir a %{friend_name}."
  /// - **fr**: "Suivre %{friend_name}"
  /// - **ja**: "%{friend_name} をフォロー"
  public static func Follow_friend_name(friend_name: String) -> String {
    return localizedString(
      key: "Follow_friend_name",
      defaultValue: "Follow %{friend_name}",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "Follow friends"
  ///
  /// - **en**: "Follow friends"
  /// - **de**: "Freunden folgen"
  /// - **es**: "Seguir amigos"
  /// - **fr**: "Suivre vos amis"
  /// - **ja**: "友達をフォロー"
  public static func Follow_friends() -> String {
    return localizedString(
      key: "Follow_friends",
      defaultValue: "Follow friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow more friends"
  ///
  /// - **en**: "Follow more friends"
  /// - **de**: "Folge noch mehr Freunden"
  /// - **es**: "Seguir a más amigos"
  /// - **fr**: "Suivre plus d'amis"
  /// - **ja**: "もっと友達をフォローする"
  public static func Follow_more_friends() -> String {
    return localizedString(
      key: "Follow_more_friends",
      defaultValue: "Follow more friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Followed"
  ///
  /// - **en**: "Followed"
  /// - **de**: "Gefolgt"
  /// - **es**: "Siguiendo"
  /// - **fr**: "Abonné"
  /// - **ja**: "フォロー中"
  public static func Followed() -> String {
    return localizedString(
      key: "Followed",
      defaultValue: "Followed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Following"
  ///
  /// - **en**: "Following"
  /// - **de**: "Gefolgt"
  /// - **es**: "Siguiendo"
  /// - **fr**: "Projets soutenus par mes amis"
  /// - **ja**: "フォロー中の友達"
  public static func Following() -> String {
    return localizedString(
      key: "Following",
      defaultValue: "Following",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Following must be on to find Facebook friends. Change your account privacy settings to enable this feature."
  ///
  /// - **en**: "Following must be on to find Facebook friends. Change your account privacy settings to enable this feature."
  /// - **de**: "Die Funktion „Folgen“ muss aktiviert sein, um Freunde auf Facebook zu finden. Gehe dazu zu Einstellungen > Datenschutz."
  /// - **es**: "El seguimiento debe estar activado para encontrar amigos de Facebook. El seguimiento se puede cambiar en Configuración > Privacidad."
  /// - **fr**: "Pour retrouver vos amis Facebook, activez la fonction Abonnements sous Paramètres > Vie privée."
  /// - **ja**: "Facebook の友達を見つけるには、フォローをオンにする必要があります。フォローの設定は、「設定 > プライバシー」から変更することができます。"
  public static func Following_Disabled_Info() -> String {
    return localizedString(
      key: "Following_Disabled_Info",
      defaultValue: "Following must be on to find Facebook friends. Change your account privacy settings to enable this feature.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Following More Info"
  ///
  /// - **en**: "Following More Info"
  /// - **de**: "Mehr Info zu Folgen"
  /// - **es**: "Más información sobre el seguimiento"
  /// - **fr**: "Plus d'informations sur le suivi et l'abonnement"
  /// - **ja**: "フォロー 詳細"
  public static func Following_More_Info() -> String {
    return localizedString(
      key: "Following_More_Info",
      defaultValue: "Following More Info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follows %{friend_name}."
  ///
  /// - **en**: "Follows %{friend_name}."
  /// - **de**: "%{friend_name} folgen."
  /// - **es**: "Sigue a %{friend_name}."
  /// - **fr**: "Abonnement aux actus de %{friend_name}."
  /// - **ja**: "%{friend_name} をフォロー"
  public static func Follows_friend_name(friend_name: String) -> String {
    return localizedString(
      key: "Follows_friend_name",
      defaultValue: "Follows %{friend_name}.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "<b>%{friend_name}</b> backed an <i>Art</i> project."
  ///
  /// - **en**: "<b>%{friend_name}</b> backed an <i>Art</i> project."
  /// - **de**: "<b>%{friend_name}</b> hat ein <i>Kunst-Projekt</i> unterstützt."
  /// - **es**: "<b>%{friend_name}</b> patrocinó un proyecto de <i>Arte</i>."
  /// - **fr**: "<b>%{friend_name}</b> a soutenu un projet <i>artistique</i>."
  /// - **ja**: "<b>%{friend_name}</b> は<i>アート</i> プロジェクトをバックしています。"
  public static func Friend_backed_art_project(friend_name: String) -> String {
    return localizedString(
      key: "Friend_backed_art_project",
      defaultValue: "<b>%{friend_name}</b> backed an <i>Art</i> project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "<b>%{friend_name}</b> backed a <i>Comics</i> project."
  ///
  /// - **en**: "<b>%{friend_name}</b> backed a <i>Comics</i> project."
  /// - **de**: "<b>%{friend_name}</b> hat ein <i>Comics-Projekt</i> unterstützt."
  /// - **es**: "<b>%{friend_name}</b> patrocinó un proyecto de <i>Comics</i>."
  /// - **fr**: "<b>%{friend_name}</b> a soutenu un projet de <i>BD</i>."
  /// - **ja**: "<b>%{friend_name}</b> は<i>コミック</i> プロジェクトをバックしています。"
  public static func Friend_backed_comics_project(friend_name: String) -> String {
    return localizedString(
      key: "Friend_backed_comics_project",
      defaultValue: "<b>%{friend_name}</b> backed a <i>Comics</i> project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "<b>%{friend_name}</b> backed a <i>Crafts</i> project."
  ///
  /// - **en**: "<b>%{friend_name}</b> backed a <i>Crafts</i> project."
  /// - **de**: "<b>%{friend_name}</b> hat ein <i>Kunsthandwerk-Projekt</i> unterstützt."
  /// - **es**: "<b>%{friend_name}</b> patrocinó un proyecto de <i>Artesanías</i>."
  /// - **fr**: "<b>%{friend_name}</b> a soutenu un projet <i>d'artisanat</i>."
  /// - **ja**: "<b>%{friend_name}</b>は<i>クラフト</i>のプロジェクトのバッカーです"
  public static func Friend_backed_crafts_project(friend_name: String) -> String {
    return localizedString(
      key: "Friend_backed_crafts_project",
      defaultValue: "<b>%{friend_name}</b> backed a <i>Crafts</i> project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "<b>%{friend_name}</b> backed a <i>Dance</i> project."
  ///
  /// - **en**: "<b>%{friend_name}</b> backed a <i>Dance</i> project."
  /// - **de**: "<b>%{friend_name}</b> hat ein <i>Tanz-Projekt</i> unterstützt."
  /// - **es**: "<b>%{friend_name}</b> patrocinó un proyecto de <i>Danza</i>."
  /// - **fr**: "<b>%{friend_name}</b> a soutenu un projet de <i>danse</i>."
  /// - **ja**: "<b>%{friend_name}</b>は<i>ダンス</i>のプロジェクトのバッカーです"
  public static func Friend_backed_dance_project(friend_name: String) -> String {
    return localizedString(
      key: "Friend_backed_dance_project",
      defaultValue: "<b>%{friend_name}</b> backed a <i>Dance</i> project.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
}
