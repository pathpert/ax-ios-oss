// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Goal met"
  ///
  /// - **en**: "Goal met"
  /// - **de**: "Ziel erreicht"
  /// - **es**: "Meta cumplida"
  /// - **fr**: "Objectif atteint"
  /// - **ja**: "目標達成"
  public static func Goal_met() -> String {
    return localizedString(
      key: "Goal_met",
      defaultValue: "Goal met",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal: Under $1,000"
  ///
  /// - **en**: "Goal: Under $1,000"
  /// - **de**: "Ziel: Unter 1.000 $"
  /// - **es**: "Meta: menos de USD 1000"
  /// - **fr**: "Objectif : inférieur à 1 000 $"
  /// - **ja**: "ゴール：$1,000 未満"
  public static func Goal_pill_bucket_0() -> String {
    return localizedString(
      key: "Goal_pill_bucket_0",
      defaultValue: "Goal: Under $1,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal: $1,000 to $10,000"
  ///
  /// - **en**: "Goal: $1,000 to $10,000"
  /// - **de**: "Ziel: 1.000 $ bis 10.000 $"
  /// - **es**: "Meta: entre USD 1000 y USD 10 000"
  /// - **fr**: "Objectif : entre 1 000 $ et 10 000 $"
  /// - **ja**: "ゴール：$1,000 ～ $10,000"
  public static func Goal_pill_bucket_1() -> String {
    return localizedString(
      key: "Goal_pill_bucket_1",
      defaultValue: "Goal: $1,000 to $10,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal: $10,000 to $100,000"
  ///
  /// - **en**: "Goal: $10,000 to $100,000"
  /// - **de**: "Ziel: 10.000 $ bis 100.000 $"
  /// - **es**: "Meta: entre USD 10 000 y USD 100 000"
  /// - **fr**: "Objectif : entre 10 000 $ et 100 000 $"
  /// - **ja**: "ゴール：$10,000 ～ $100,000"
  public static func Goal_pill_bucket_2() -> String {
    return localizedString(
      key: "Goal_pill_bucket_2",
      defaultValue: "Goal: $10,000 to $100,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal: $100,000 to $1,000,000"
  ///
  /// - **en**: "Goal: $100,000 to $1,000,000"
  /// - **de**: "Ziel: 100.000 $ bis 1.000.000 $"
  /// - **es**: "Meta: entre USD 100 000 y USD 1 000 000"
  /// - **fr**: "Objectif : entre 100 000 $ et 1 000 000 $"
  /// - **ja**: "ゴール：$100,000 ～ $1,000,000"
  public static func Goal_pill_bucket_3() -> String {
    return localizedString(
      key: "Goal_pill_bucket_3",
      defaultValue: "Goal: $100,000 to $1,000,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal: More than $1,000,000"
  ///
  /// - **en**: "Goal: More than $1,000,000"
  /// - **de**: "Ziel: Über 1.000.000 $"
  /// - **es**: "Meta: más de USD 1 000 000"
  /// - **fr**: "Objectif : supérieur à 1 000 000 $"
  /// - **ja**: "ゴール：$1,000,000 以上"
  public static func Goal_pill_bucket_4() -> String {
    return localizedString(
      key: "Goal_pill_bucket_4",
      defaultValue: "Goal: More than $1,000,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Got it"
  ///
  /// - **en**: "Got it"
  /// - **de**: "Alles klar!"
  /// - **es**: "¡Listo!"
  /// - **fr**: "Super."
  /// - **ja**: "完了"
  public static func Got_it() -> String {
    return localizedString(
      key: "Got_it",
      defaultValue: "Got it",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Got it! Your changes have been saved."
  ///
  /// - **en**: "Got it! Your changes have been saved."
  /// - **de**: "Alles klar! Deine Änderungen wurden gespeichert."
  /// - **es**: "Listo. Se han guardado tus cambios."
  /// - **fr**: "C'est bon, vos modifications ont été enregistrées."
  /// - **ja**: "変更が保存されました。"
  public static func Got_it_your_changes_have_been_saved() -> String {
    return localizedString(
      key: "Got_it_your_changes_have_been_saved",
      defaultValue: "Got it! Your changes have been saved.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Help"
  ///
  /// - **en**: "Help"
  /// - **de**: "Hilfe"
  /// - **es**: "Ayuda"
  /// - **fr**: "Aide"
  /// - **ja**: "ヘルプ"
  public static func Help() -> String {
    return localizedString(
      key: "Help",
      defaultValue: "Help",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Help Center"
  ///
  /// - **en**: "Help Center"
  /// - **de**: "Hilfe-Center"
  /// - **es**: "Centro de ayuda"
  /// - **fr**: "Centre d'aide"
  /// - **ja**: "ヘルプセンター"
  public static func Help_center() -> String {
    return localizedString(
      key: "Help_center",
      defaultValue: "Help Center",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Help local businesses keep the lights on during COVID-19 closures."
  ///
  /// - **en**: "Help local businesses keep the lights on during COVID-19 closures."
  /// - **de**: "Mit deiner Hilfe gehen bei lokalen Geschäften während COVID-19 nicht die Lichter aus."
  /// - **es**: "Ayuda a que los negocios locales sigan activos durante los cierres producidos por el COVID-19."
  /// - **fr**: "À l'ère du COVID-19, les entreprises de votre région ont besoin de vous pour survire."
  /// - **ja**: "新型コロナウイルス感染症(COVID- 19)の影響により休業を強いられた地元のビジネスを支援しましょう。"
  public static func Help_local_businesses_keep_the_lights() -> String {
    return localizedString(
      key: "Help_local_businesses_keep_the_lights",
      defaultValue: "Help local businesses keep the lights on during COVID-19 closures.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Home"
  ///
  /// - **en**: "Home"
  /// - **de**: "Home"
  /// - **es**: "Inicio"
  /// - **fr**: "Accueil"
  /// - **ja**: "ホーム"
  public static func Home() -> String {
    return localizedString(
      key: "Home",
      defaultValue: "Home",
      count: nil,
      substitutions: [:]
    )
  }
  /// "How backers found your project"
  ///
  /// - **en**: "How backers found your project"
  /// - **de**: "Wie Unterstützer dein Projekt gefunden haben"
  /// - **es**: "Cómo encontraron tu proyecto los patrocinadores"
  /// - **fr**: "Comment les contributeurs ont découvert votre projet"
  /// - **ja**: "バッカ―があなたのプロジェクトを見つけた経緯"
  public static func How_backers_found_your_project() -> String {
    return localizedString(
      key: "How_backers_found_your_project",
      defaultValue: "How backers found your project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "I am incorporating AI in my project in another way."
  ///
  /// - **en**: "I am incorporating AI in my project in another way."
  /// - **de**: "Ich werde KI auf andere Weise in mein Projekt integrieren."
  /// - **es**: "Voy a incorporar la IA en mi proyecto de otra manera."
  /// - **fr**: "Je prévois d'incorporer une IA dans mon projet d'une autre façon."
  /// - **ja**: "他の形で自分のプロジェクトに AI を取り入れる予定です。"
  public static func I_am_incorporating_AI_in_my_project() -> String {
    return localizedString(
      key: "I_am_incorporating_AI_in_my_project",
      defaultValue: "I am incorporating AI in my project in another way.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "I plan to use AI-generated content in my project."
  ///
  /// - **en**: "I plan to use AI-generated content in my project."
  /// - **de**: "Ich plane, bei meinem Projekt KI-generierte Inhalte zu nutzen."
  /// - **es**: "Tengo pensado usar contenido generado por IA en mi proyecto."
  /// - **fr**: "Je prévois d'utiliser du contenu généré par une IA dans mon projet."
  /// - **ja**: "自分のプロジェクトで AI で生成されたコンテンツを使用する予定です。"
  public static func I_plan_to_use_AI_generated_content() -> String {
    return localizedString(
      key: "I_plan_to_use_AI_generated_content",
      defaultValue: "I plan to use AI-generated content in my project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "I understand"
  ///
  /// - **en**: "I understand"
  /// - **de**: "Verstanden"
  /// - **es**: "Entiendo"
  /// - **fr**: "Je comprends"
  /// - **ja**: "理解しました"
  public static func I_understand() -> String {
    return localizedString(
      key: "I_understand",
      defaultValue: "I understand",
      count: nil,
      substitutions: [:]
    )
  }
}
