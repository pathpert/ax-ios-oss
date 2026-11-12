// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DiscoveryStrings {
  /// "Connect with Facebook to follow friends and get notified when they back or launch projects."
  ///
  /// - **en**: "Connect with Facebook to follow friends and get notified when they back or launch projects."
  /// - **de**: "Verknüpfe dein Konto mit Facebook - du kannst deinen Freunden folgen und wirst benachrichtigt, wenn sie ein Projekt veröffentlichen oder unterstützen."
  /// - **es**: "Conéctate via Facebook y sigue a tus amigos - ¡te avisaremos cada vez que publican o patrocinan un proyecto!"
  /// - **fr**: "Connectez-vous avec votre compte Facebook pour suivre vos amis et recevoir une notification chaque fois qu'ils soutiennent ou lancent un nouveau projet."
  /// - **ja**: "Facebookと繋げ、友達がプロジェクトを作成したりバックしたりした時に通知する"
  public static func discovery_facebook_connect_hero_if_you_connect_with_facebook() -> String {
    return localizedString(
      key: "discovery.facebook_connect_hero.if_you_connect_with_facebook",
      defaultValue: "Connect with Facebook to follow friends and get notified when they back or launch projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We'll never post anything to Facebook without your permission"
  ///
  /// - **en**: "We'll never post anything to Facebook without your permission"
  /// - **de**: "Wir werden niemals etwas ohne deine Erlaubnis auf Facebook posten"
  /// - **es**: "Nunca publicaremos nada en Facebook sin tu permiso"
  /// - **fr**: "Nous ne publierons pas sur Facebook sans votre autorisation."
  /// - **ja**: "Facebook上に許可なく投稿することはありません。"
  public static func discovery_facebook_connect_hero_we_will_never_post_anything_on_facebook() -> String {
    return localizedString(
      key: "discovery.facebook_connect_hero.we_will_never_post_anything_on_facebook",
      defaultValue: "We'll never post anything to Facebook without your permission",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Got it."
  ///
  /// - **en**: "Got it."
  /// - **de**: "Alles klar!"
  /// - **es**: "¡Listo!"
  /// - **fr**: "Super."
  /// - **ja**: "受取済"
  public static func discovery_favorite_categories_alert_buttons_got_it() -> String {
    return localizedString(
      key: "discovery.favorite_categories.alert.buttons.got_it",
      defaultValue: "Got it.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Yes! You've saved this as one of your favorite categories."
  ///
  /// - **en**: "Yes! You've saved this as one of your favorite categories."
  /// - **de**: "Klasse! Diese Kategorie gehört nun zu deinen Favoriten! Du kannst sie nach oben oder unten ziehen, um die Reihenfolge deiner liebsten Kategorien festzulegen und so schneller auf sie zugreifen zu können."
  /// - **es**: "¡Perfecto - esta categoría se encuentra ahora entre tus favoritas! Muévelas en el orden que más te gusten, así tendrás un acceso más rápido a ellas."
  /// - **fr**: "Super ! Vous avez ajouté cette catégorie à vos favoris. Faites-les défiler pour accéder plus facilement à celles que vous préférez."
  /// - **ja**: "お気に入りのカテゴリーに登録されました。"
  public static func discovery_favorite_categories_alert_message() -> String {
    return localizedString(
      key: "discovery.favorite_categories.alert.message",
      defaultValue: "Yes! You've saved this as one of your favorite categories.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Done"
  ///
  /// - **en**: "Done"
  /// - **de**: "Fertig"
  /// - **es**: "Listo"
  /// - **fr**: "Terminé"
  /// - **ja**: "完了"
  public static func discovery_favorite_categories_buttons_done() -> String {
    return localizedString(
      key: "discovery.favorite_categories.buttons.done",
      defaultValue: "Done",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Edit"
  ///
  /// - **en**: "Edit"
  /// - **de**: "Bearbeiten"
  /// - **es**: "Editar"
  /// - **fr**: "Modifier"
  /// - **ja**: "編集"
  public static func discovery_favorite_categories_buttons_edit() -> String {
    return localizedString(
      key: "discovery.favorite_categories.buttons.edit",
      defaultValue: "Edit",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Add favorite category"
  ///
  /// - **en**: "Add favorite category"
  /// - **de**: "Zu Favoriten hinzufügen"
  /// - **es**: "Añadir a categorías favoritas"
  /// - **fr**: "Ajout d'une catégorie aux favoris"
  /// - **ja**: "お気に入りカテゴリーを追加"
  public static func discovery_favorite_categories_buttons_favorite_a11y_label() -> String {
    return localizedString(
      key: "discovery.favorite_categories.buttons.favorite.a11y_label",
      defaultValue: "Add favorite category",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Remove favorite category"
  ///
  /// - **en**: "Remove favorite category"
  /// - **de**: "Aus Favoriten entfernen"
  /// - **es**: "Eliminar de categorías favoritas"
  /// - **fr**: "Suppression d'une catégorie des favoris"
  /// - **ja**: "お気に入りカテゴリーを削除"
  public static func discovery_favorite_categories_buttons_unfavorite_a11y_label() -> String {
    return localizedString(
      key: "discovery.favorite_categories.buttons.unfavorite.a11y_label",
      defaultValue: "Remove favorite category",
      count: nil,
      substitutions: [:]
    )
  }
  /// "All of %{category_name}"
  ///
  /// - **en**: "All of %{category_name}"
  /// - **de**: "Alle aus %{category_name}"
  /// - **es**: "Todos en %{category_name}"
  /// - **fr**: "Toute la catégorie %{category_name}"
  /// - **ja**: "%{category_name} の全て"
  public static func discovery_filters_all_of_category(category_name: String) -> String {
    return localizedString(
      key: "discovery.filters.all_of_category",
      defaultValue: "All of %{category_name}",
      count: nil,
      substitutions: ["category_name": category_name]
    )
  }
  /// "Categories"
  ///
  /// - **en**: "Categories"
  /// - **de**: "Kategorien"
  /// - **es**: "Categorías"
  /// - **fr**: "Catégories"
  /// - **ja**: "カテゴリー"
  public static func discovery_filters_categories_title() -> String {
    return localizedString(
      key: "discovery.filters.categories_title",
      defaultValue: "Categories",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Favorites"
  ///
  /// - **en**: "Favorites"
  /// - **de**: "Favoriten"
  /// - **es**: "Favoritas"
  /// - **fr**: "Favoris"
  /// - **ja**: "お気に入り"
  public static func discovery_filters_favorites_title() -> String {
    return localizedString(
      key: "discovery.filters.favorites_title",
      defaultValue: "Favorites",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Find your friends"
  ///
  /// - **en**: "Find your friends"
  /// - **de**: "Finde deine Freunde"
  /// - **es**: "Encuentra tus amigos"
  /// - **fr**: "Rechercher vos amis"
  /// - **ja**: "友達をさがす"
  public static func discovery_find_friends_hero_button_find_your_friends() -> String {
    return localizedString(
      key: "discovery.find_friends_hero.button.find_your_friends",
      defaultValue: "Find your friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Follow your Facebook friends and get notified when they back or launch projects."
  ///
  /// - **en**: "Follow your Facebook friends and get notified when they back or launch projects."
  /// - **de**: "Folge deinen Freunden und wir werden dich benachrichtigen, sobald sie ein Projekt unterstützen oder veröffentlichen."
  /// - **es**: "Sigue a tus amigos y te avisaremos cuando publican o patrocinan un proyecto."
  /// - **fr**: "Suivez vos amis Facebook pour recevoir une notification chaque fois qu'ils soutiennent ou lancent un nouveau projet."
  /// - **ja**: "Facebookの友達をフォローしよう！"
  public static func discovery_find_friends_hero_follow_your_friends_and_we_will_notify_you() -> String {
    return localizedString(
      key: "discovery.find_friends_hero.follow_your_friends_and_we_will_notify_you",
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
  /// - **fr**: "Découvrez plus de projets."
  /// - **ja**: "さらにさがす"
  public static func discovery_find_friends_hero_your_friends_are_here() -> String {
    return localizedString(
      key: "discovery.find_friends_hero.your_friends_are_here",
      defaultValue: "Discover more projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Friends"
  ///
  /// - **en**: "Friends"
  /// - **de**: "Freunde"
  /// - **es**: "Amigos"
  /// - **fr**: "Amis"
  /// - **ja**: "友達"
  public static func discovery_friends() -> String {
    return localizedString(
      key: "discovery.friends",
      defaultValue: "Friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Friends Backed"
  ///
  /// - **en**: "Friends Backed"
  /// - **de**: "Von Freunden unterstützt"
  /// - **es**: "Patrocinados por amigos"
  /// - **fr**: "Projets soutenus par mes amis"
  /// - **ja**: "友人がバックしたもの"
  public static func discovery_friends_backed() -> String {
    return localizedString(
      key: "discovery.friends_backed",
      defaultValue: "Friends Backed",
      count: nil,
      substitutions: [:]
    )
  }
}
