// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "minutes"
  ///
  /// - **en**: "minutes"
  /// - **de**: "Min"
  /// - **es**: "minutos"
  /// - **fr**: "minutes"
  /// - **ja**: "分"
  public static func minutes_other() -> String {
    return localizedString(
      key: "minutes.other",
      defaultValue: "minutes",
      count: nil,
      substitutions: [:]
    )
  }
  /// "minutes"
  ///
  /// - **en**: "minutes"
  /// - **de**: "Min"
  /// - **es**: "minutos"
  /// - **fr**: "minutes"
  /// - **ja**: "分"
  public static func minutes_plural() -> String {
    return localizedString(
      key: "minutes_plural",
      defaultValue: "minutes",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{number_of_items} items"
  ///
  /// - **en**: "%{number_of_items} items"
  /// - **de**: "%{number_of_items} Benachrichtigungen"
  /// - **es**: "%{number_of_items} notificaciones"
  /// - **fr**: "%{number_of_items} éléments"
  /// - **ja**: "%{number_of_items} 件のアイテム"
  public static func number_of_items_items(number_of_items: String) -> String {
    return localizedString(
      key: "number_of_items_items",
      defaultValue: "%{number_of_items} items",
      count: nil,
      substitutions: ["number_of_items": number_of_items]
    )
  }
  /// "Log in or create an account to back projects, save favorites, and follow along as creative ideas come to life."
  ///
  /// - **en**: "Log in or create an account to back projects, save favorites, and follow along as creative ideas come to life."
  /// - **de**: "Melde dich an oder erstelle ein Konto, um Projekte zu unterstützen, Favoriten zu speichern und mitzuverfolgen, wie kreative Ideen verwirklicht werden."
  /// - **es**: "Inicia sesión o crea una cuenta para patrocinar proyectos, guardar tus favoritos y seguir de cerca cómo cobran vida las ideas creativas."
  /// - **fr**: "Connectez-vous ou créez un compte pour soutenir un projet, enregistrer vos favoris et découvrir des idées créatives en plein essor."
  /// - **ja**: "プロジェクトのバック（支援）や、お気に入りの保存、クリエイティブなプロジェクトのフォローを行うには、ログインするかアカウントを作成してください。"
  public static func onboarding_join_the_community_subtitle() -> String {
    return localizedString(
      key: "onboarding.join_the_community.subtitle",
      defaultValue: "Log in or create an account to back projects, save favorites, and follow along as creative ideas come to life.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Join the community"
  ///
  /// - **en**: "Join the community"
  /// - **de**: "Teil der Community werden"
  /// - **es**: "Unirme a la comunidad"
  /// - **fr**: "Soyez des nôtres"
  /// - **ja**: "コミュニティに参加する"
  public static func onboarding_join_the_community_title() -> String {
    return localizedString(
      key: "onboarding.join_the_community.title",
      defaultValue: "Join the community",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Allow tracking to help us improve your in-app experience."
  ///
  /// - **en**: "Allow tracking to help us improve your in-app experience."
  /// - **de**: "Wenn du Tracking zulässt, hilfst du uns dabei, deine In-App-Nutzung zu verbessern."
  /// - **es**: "Permite el seguimiento para que nos ayude a mejorar tu experiencia en la aplicación."
  /// - **fr**: "Aidez-nous à améliorer l'expérience offerte par notre application."
  /// - **ja**: "アプリ内エクスペリエンスを改善できるよう追跡機能を許可してください。"
  public static func onboarding_personalize_your_experience_subtitle() -> String {
    return localizedString(
      key: "onboarding.personalize_your_experience.subtitle",
      defaultValue: "Allow tracking to help us improve your in-app experience.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Personalize your experience"
  ///
  /// - **en**: "Personalize your experience"
  /// - **de**: "Deine Nutzung personalisieren"
  /// - **es**: "Personalizar mi experiencia"
  /// - **fr**: "Une expérience personnalisée"
  /// - **ja**: "自分に合ったエクスペリエンスを作成"
  public static func onboarding_personalize_your_experience_title() -> String {
    return localizedString(
      key: "onboarding.personalize_your_experience.title",
      defaultValue: "Personalize your experience",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Found a project that's caught your eye? Tap the heart to save it and you can come back to it later on your Saved tab."
  ///
  /// - **en**: "Found a project that's caught your eye? Tap the heart to save it and you can come back to it later on your Saved tab."
  /// - **de**: "Hast du ein Projekt gefunden, das dir gefällt? Tipp einfach auf das Herz, um es zu speichern. So kannst du es später über den Tab „Gespeichert“ wieder aufrufen."
  /// - **es**: "¿Encontraste un proyecto que te interesó? Toca el corazón para guardarlo y podrás visitarlo más tarde desde la pestaña de proyectos guardados."
  /// - **fr**: "Vous avez déniché un projet intéressant ? Cliquez sur le cœur pour y revenir plus tard. Il vous attendra dans l'onglet des projets enregistrés."
  /// - **ja**: "気になるプロジェクトが見つかったら、ハートをタップすれば保存でき、［保存済み］タブからいつでもそのプロジェクトに戻ることができます。"
  public static func onboarding_save_projects_for_later_subtitle() -> String {
    return localizedString(
      key: "onboarding.save_projects_for_later.subtitle",
      defaultValue: "Found a project that's caught your eye? Tap the heart to save it and you can come back to it later on your Saved tab.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Save projects for later"
  ///
  /// - **en**: "Save projects for later"
  /// - **de**: "Projekte für später speichern"
  /// - **es**: "Guardar proyectos para más tarde"
  /// - **fr**: "Projets enregistrés pour plus tard"
  /// - **ja**: "プロジェクトを保存して後でチェック"
  public static func onboarding_save_projects_for_later_title() -> String {
    return localizedString(
      key: "onboarding.save_projects_for_later.title",
      defaultValue: "Save projects for later",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Turn on notifications to keep track of your backed projects and discover more you'll love. You can customize these anytime in your settings."
  ///
  /// - **en**: "Turn on notifications to keep track of your backed projects and discover more you'll love. You can customize these anytime in your settings."
  /// - **de**: "Aktiviere die Benachrichtigungen, um deine unterstützten Projekte im Auge zu behalten und weitere zu entdecken, die dir gefallen könnten. Du kannst diese jederzeit in deinen Einstellungen anpassen."
  /// - **es**: "Activa las notificaciones para hacer un seguimiento de tus proyectos patrocinados y descubrir otros que te interesen. Puedes personalizarlas cuando quieras en tu configuración."
  /// - **fr**: "Activez vos notifications pour tout savoir sur les projets que vous avez soutenus et pour découvrir d'autres perles rares. Paramètres configurables à souhait."
  /// - **ja**: "バックしたプロジェクトの進捗状況をチェックしたり他にももっとたくさん気に入ったプロジェクトを見つけられるように、通知をオンにしましょう。通知は設定内でいつでもカスタマイズできます。"
  public static func onboarding_stay_in_the_know_subtitle() -> String {
    return localizedString(
      key: "onboarding.stay_in_the_know.subtitle",
      defaultValue: "Turn on notifications to keep track of your backed projects and discover more you'll love. You can customize these anytime in your settings.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Stay in the know"
  ///
  /// - **en**: "Stay in the know"
  /// - **de**: "Auf dem Laufenden bleiben"
  /// - **es**: "No perderme nada"
  /// - **fr**: "Tout savoir sur tout"
  /// - **ja**: "通知を受け取る"
  public static func onboarding_stay_in_the_know_title() -> String {
    return localizedString(
      key: "onboarding.stay_in_the_know.title",
      defaultValue: "Stay in the know",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Use our app to discover and support creative projects. Browse by category, find projects near you, or explore our "Projects We Love" picks."
  ///
  /// - **en**: "Use our app to discover and support creative projects. Browse by category, find projects near you, or explore our "Projects We Love" picks."
  /// - **de**: "Entdecke und unterstütze mit unserer App kreative Projekte. Stöbere nach Kategorien, finde Projekte in deiner Nähe oder sieh dir unsere Team-Favoriten an."
  /// - **es**: "Usa nuestra aplicación para descubrir y apoyar proyectos creativos. Busca por categoría, encuentra proyectos cercanos o explora Nuestros favoritos."
  /// - **fr**: "Des projets créatifs à découvrir et à soutenir vous attendent sur notre application. Navigation par catégorie, projets près de chez vous ou encore Coups de cœur de Kickstarter sont au rendez-vous."
  /// - **ja**: "Kickstarter アプリを使ってクリエイティブなプロジェクトを発見しサポートしましょう。カテゴリー別にさまざまなプロジェクトを閲覧したり、近場のプロジェクトを見つけたり、「Projects We Love」で Kickstarter チーム厳選のプロジェクトをチェックしたりできます。"
  public static func onboarding_welcome_to_kickstarter_subtitle() -> String {
    return localizedString(
      key: "onboarding.welcome_to_kickstarter.subtitle",
      defaultValue: "Use our app to discover and support creative projects. Browse by category, find projects near you, or explore our \"Projects We Love\" picks.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Welcome to Kickstarter"
  ///
  /// - **en**: "Welcome to Kickstarter"
  /// - **de**: "Willkommen bei Kickstarter"
  /// - **es**: "¡Bienvenido a Kickstarter!"
  /// - **fr**: "Bienvenue sur Kickstarter"
  /// - **ja**: "Kickstarter へようこそ"
  public static func onboarding_welcome_to_kickstarter_title() -> String {
    return localizedString(
      key: "onboarding.welcome_to_kickstarter.title",
      defaultValue: "Welcome to Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{percentage} funded"
  ///
  /// - **en**: "%{percentage} funded"
  /// - **de**: "%{percentage} finanziert"
  /// - **es**: "%{percentage} financiado"
  /// - **fr**: "Financé à %{percentage}"
  /// - **ja**: "%{percentage} 達成"
  public static func percentage_funded(percentage: String) -> String {
    return localizedString(
      key: "percentage_funded",
      defaultValue: "%{percentage} funded",
      count: nil,
      substitutions: ["percentage": percentage]
    )
  }
  /// "%{projects_count}
  /// cked"
  ///
  /// - **en**: "%{projects_count}
  /// cked"
  /// - **de**: "%{projects_count}
  /// terstützt"
  /// - **es**: "%{projects_count}
  /// trocinados"
  /// - **fr**: "%{projects_count}
  /// ojets soutenus"
  /// - **ja**: "%{projects_count}\n件バック済み"
  public static func projects_count_newline_backed(projects_count: Int) -> String {
    return localizedString(
      key: "projects_count_newline_backed",
      defaultValue: "%{projects_count}\nbacked",
      count: projects_count,
      substitutions: ["projects_count": Format.wholeNumber(projects_count)]
    )
  }
}
