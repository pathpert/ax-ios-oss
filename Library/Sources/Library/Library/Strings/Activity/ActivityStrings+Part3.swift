// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ActivityStrings {
  /// "Following"
  ///
  /// - **en**: "Following"
  /// - **de**: "Gefolgt"
  /// - **es**: "Siguiendo"
  /// - **fr**: "Abonnements"
  /// - **ja**: "フォロー"
  public static func Show_only_following() -> String {
    return localizedString(
      key: "Show_only_following",
      defaultValue: "Following",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{friend_name} and %{remaining_count} other"
  ///
  /// - **en**: "%{friend_name} and %{remaining_count} other"
  /// - **de**: "%{friend_name} und %{remaining_count} weitere Person"
  /// - **es**: "%{friend_name} y %{remaining_count} persona más"
  /// - **fr**: "%{friend_name} et %{remaining_count} autre"
  /// - **ja**: "%{friend_name} さんと他%{remaining_count} 人"
  public static func Social_friend_is_backer(friend_name: String, remaining_count: Int) -> String {
    return localizedString(
      key: "Social_friend_is_backer",
      defaultValue: "%{friend_name} and %{remaining_count} other",
      count: remaining_count,
      substitutions: ["friend_name": friend_name, "remaining_count": Format.wholeNumber(remaining_count)]
    )
  }
  /// "%{friend_name} and %{remaining_count} others"
  ///
  /// - **en**: "%{friend_name} and %{remaining_count} others"
  /// - **de**: "%{friend_name} und %{remaining_count} weitere"
  /// - **es**: "%{friend_name} y %{remaining_count} otros"
  /// - **fr**: "%{friend_name} et %{remaining_count} autre(s)"
  /// - **ja**: "%{friend_name} さんと他%{remaining_count} 人"
  public static func Social_friend_is_backer_other(friend_name: String, remaining_count: String) -> String {
    return localizedString(
      key: "Social_friend_is_backer.other",
      defaultValue: "%{friend_name} and %{remaining_count} others",
      count: nil,
      substitutions: ["friend_name": friend_name, "remaining_count": remaining_count]
    )
  }
  /// "Unfollow %{friend_name}"
  ///
  /// - **en**: "Unfollow %{friend_name}"
  /// - **de**: "%{friend_name} nicht mehr folgen"
  /// - **es**: "Dejar de seguir a %{friend_name}"
  /// - **fr**: "Ne plus suivre %{friend_name}"
  /// - **ja**: "%{friend_name} のフォロー解除"
  public static func Unfollow_friend_name(friend_name: String) -> String {
    return localizedString(
      key: "Unfollow_friend_name",
      defaultValue: "Unfollow %{friend_name}",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "Unfollows %{friend_name}."
  ///
  /// - **en**: "Unfollows %{friend_name}."
  /// - **de**: "%{friend_name} nicht mehr folgen."
  /// - **es**: "Dejar de seguir a %{friend_name}."
  /// - **fr**: "Désabonnement des actus de %{friend_name}."
  /// - **ja**: "%{friend_name} のフォロー解除"
  public static func Unfollows_friend_name(friend_name: String) -> String {
    return localizedString(
      key: "Unfollows_friend_name",
      defaultValue: "Unfollows %{friend_name}.",
      count: nil,
      substitutions: ["friend_name": friend_name]
    )
  }
  /// "We use your activity internally to make recommendations for you. Turn recommendations off to opt out of this."
  ///
  /// - **en**: "We use your activity internally to make recommendations for you. Turn recommendations off to opt out of this."
  /// - **de**: "Deine Aktivitäten werden intern genutzt, um dir Empfehlungen zu unterbreiten. Um dies zu deaktivieren, wähle "Empfehlungen" einfach ab."
  /// - **es**: "Utilizamos tu actividad internamente para hacerte recomendaciones. Desactiva las recomendaciones si no quieres recibirlas."
  /// - **fr**: "À l'interne, nous nous servons de vos activités pour vous faire des recommandations. Si vous ne souhaitez pas participer, nous vous invitons à désactiver vos recommandations."
  /// - **ja**: "あなたのアクティビティをもとにおすすめの提供を行っています。オプトアウトするにはおすすめ機能をオフにしてください。"
  public static func We_use_your_activity_internally_to_make_recommendations_for_you() -> String {
    return localizedString(
      key: "We_use_your_activity_internally_to_make_recommendations_for_you",
      defaultValue: "We use your activity internally to make recommendations for you. Turn recommendations off to opt out of this.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We'll import your name and profile photo, and access your friend list. We'll never post anything without your permission."
  ///
  /// - **en**: "We'll import your name and profile photo, and access your friend list. We'll never post anything without your permission."
  /// - **de**: "Wir importieren deinen Namen und dein Profilfoto und können auf die Liste deiner Freunde zugreifen. Wir werden jedoch niemals etwas ohne deine Zustimmung posten."
  /// - **es**: "Importaremos tu nombre y tu foto de perfil, y tendremos acceso a tu lista de amigos. Nunca publicaremos nada sin tu permiso."
  /// - **fr**: "Votre nom et votre photo de profil seront importés. Nous aurons accès à votre liste d'amis, mais nous ne publierons rien sans votre autorisation."
  /// - **ja**: "Kickstarter はあなたの名前とプロフィール写真をインポートし、友達リストにアクセスできるようになります。Kickstarter があなたの許可なしに Facebook に投稿することは決してありません。"
  public static func Well_import_your_name_and_profile_photo_and_access_your_friend_list() -> String {
    return localizedString(
      key: "Well_import_your_name_and_profile_photo_and_access_your_friend_list",
      defaultValue: "We'll import your name and profile photo, and access your friend list. We'll never post anything without your permission.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When following is on, you can follow the activity of others and others can follow your activity. Turn following off to permanently delete this data."
  ///
  /// - **en**: "When following is on, you can follow the activity of others and others can follow your activity. Turn following off to permanently delete this data."
  /// - **de**: "Wenn die Funktion Folgen aktiviert wurde, kannst du die Aktivitäten von anderen einsehen und diese sehen deine Aktivitäten. Wenn die Funktion deaktiviert wurde, werden diese Daten endgültig gelöscht."
  /// - **es**: "Cuando el seguimiento está activado, puedes seguir la actividad de los demás y otros pueden seguir tu actividad. Desactiva el seguimiento para eliminar esta información definitivamente."
  /// - **fr**: "Lorsque les fonctionnalités de suivi sont activées, vous pouvez vous abonner aux activités des autres, qui pourront à leur tour s'abonner aux vôtres. Pour supprimer définitivement ces données, il vous suffit de désactiver les fonctionnalités de suivi."
  /// - **ja**: "フォローがオンになっていると、他の人のアクティビティをフォローすることができ、また、他の人もあなたのアクティビティをフォローすることができます。このようなデータを永久に削除するためにはフォローをオフにしてください。"
  public static func When_following_is_on_you_can_follow_the_acticity_of_others() -> String {
    return localizedString(
      key: "When_following_is_on_you_can_follow_the_acticity_of_others",
      defaultValue: "When following is on, you can follow the activity of others and others can follow your activity. Turn following off to permanently delete this data.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your friends haven’t backed any projects yet, but once they do, you’ll see them listed here."
  ///
  /// - **en**: "Your friends haven’t backed any projects yet, but once they do, you’ll see them listed here."
  /// - **de**: "Deine Freunde haben bisher noch kein Projekt unterstützt. Aber sobald sie das tun, wird es hier angezeigt."
  /// - **es**: "Tus amigos todavía no han hecho contribuciones, pero en cuanto lo hagan, se verán reflejadas aquí."
  /// - **fr**: "Vos amis n'ont encore rien soutenu, mais dès qu'ils s'y seront mis, leurs engagements s'afficheront ici."
  /// - **ja**: "バックした友達はまだいませんが、今後こちらに表示されます。"
  public static func Your_friends_havent_backed_any_projects_yet() -> String {
    return localizedString(
      key: "Your_friends_havent_backed_any_projects_yet",
      defaultValue: "Your friends haven’t backed any projects yet, but once they do, you’ll see them listed here.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "by %{creator_name}"
  ///
  /// - **en**: "by %{creator_name}"
  /// - **de**: "von %{creator_name}"
  /// - **es**: "por %{creator_name}"
  /// - **fr**: "par %{creator_name}"
  /// - **ja**: "by %{creator_name}"
  public static func activity_by_creator(creator_name: String) -> String {
    return localizedString(
      key: "activity.by_creator",
      defaultValue: "by %{creator_name}",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "%{user_name} commented on Update #%{update_number}:"
  ///
  /// - **en**: "%{user_name} commented on Update #%{update_number}:"
  /// - **de**: "%{user_name} hat die Aktualisierung Nr. %{update_number} kommentiert:"
  /// - **es**: "%{user_name} comentó actualización n° %{update_number}:"
  /// - **fr**: "%{user_name} a laissé un commentaire sur l'actu no. %{update_number}."
  /// - **ja**: "%{user_name} がアップデート＃%{update_number} にコメントしました："
  public static func activity_creator_actions_user_name_commented_on_update_number(user_name: String, update_number: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_commented_on_update_number",
      defaultValue: "%{user_name} commented on Update #%{update_number}:",
      count: nil,
      substitutions: ["user_name": user_name, "update_number": update_number]
    )
  }
  /// "%{user_name} commented on your project:"
  ///
  /// - **en**: "%{user_name} commented on your project:"
  /// - **de**: "%{user_name} hat dein Projekt kommentiert:"
  /// - **es**: "Comentario de %{user_name} en tu proyecto:"
  /// - **fr**: "%{user_name} a laissé un commentaire sur votre projet"
  /// - **ja**: "%{user_name} があなたのプロジェクトにコメントしました："
  public static func activity_creator_actions_user_name_commented_on_your_project(user_name: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_commented_on_your_project",
      defaultValue: "%{user_name} commented on your project:",
      count: nil,
      substitutions: ["user_name": user_name]
    )
  }
  /// "%{user_name} posted Update #%{update_number}:"
  ///
  /// - **en**: "%{user_name} posted Update #%{update_number}:"
  /// - **de**: "%{user_name} hat die Aktualisierung Nr. %{update_number} gepostet:"
  /// - **es**: "%{user_name} publicó actualización n° %{update_number}:"
  /// - **fr**: "%{user_name} a publié l'actu no. %{update_number} :"
  /// - **ja**: "%{user_name} がアップデート＃%{update_number} を投稿しました："
  public static func activity_creator_actions_user_name_posted_update_number(user_name: String, update_number: String) -> String {
    return localizedString(
      key: "activity.creator.actions.user_name_posted_update_number",
      defaultValue: "%{user_name} posted Update #%{update_number}:",
      count: nil,
      substitutions: ["user_name": user_name, "update_number": update_number]
    )
  }
  /// "You commented on Update #%{update_number}:"
  ///
  /// - **en**: "You commented on Update #%{update_number}:"
  /// - **de**: "Du hast Aktualisierung Nr. %{update_number} kommentiert:"
  /// - **es**: "Tu comentario sobre actualización n° %{update_number}:"
  /// - **fr**: "Vous avez commenté l'actu no. %{update_number}"
  /// - **ja**: "＃%{update_number} にコメント済み："
  public static func activity_creator_actions_you_commented_on_update_number(update_number: String) -> String {
    return localizedString(
      key: "activity.creator.actions.you_commented_on_update_number",
      defaultValue: "You commented on Update #%{update_number}:",
      count: nil,
      substitutions: ["update_number": update_number]
    )
  }
  /// "You"
  ///
  /// - **en**: "You"
  /// - **de**: "Du"
  /// - **es**: "Tú"
  /// - **fr**: "Vous"
  /// - **ja**: "あなた"
  public static func activity_creator_actions_you_commented_on_update_number_pronoun() -> String {
    return localizedString(
      key: "activity.creator.actions.you_commented_on_update_number_pronoun",
      defaultValue: "You",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You commented on your project:"
  ///
  /// - **en**: "You commented on your project:"
  /// - **de**: "Du hast dein Projekt kommentiert:"
  /// - **es**: "Tu comentario en tu proyecto:"
  /// - **fr**: "Vous avez laissé un commentaire sur votre projet."
  /// - **ja**: "プロジェクトにコメントしました："
  public static func activity_creator_actions_you_commented_on_your_project() -> String {
    return localizedString(
      key: "activity.creator.actions.you_commented_on_your_project",
      defaultValue: "You commented on your project:",
      count: nil,
      substitutions: [:]
    )
  }
}
