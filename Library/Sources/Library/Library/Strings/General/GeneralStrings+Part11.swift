// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "I’d just like to support the project."
  ///
  /// - **en**: "I’d just like to support the project."
  /// - **de**: "Ich möchte das Projekt einfach nur unterstützen."
  /// - **es**: "Sólo quiero apoyar este proyecto."
  /// - **fr**: "Je souhaite simplement soutenir le projet."
  /// - **ja**: "プロジェクトをサポートしたい"
  public static func Id_just_like_to_support_the_project() -> String {
    return localizedString(
      key: "Id_just_like_to_support_the_project",
      defaultValue: "I’d just like to support the project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "I'll do this later"
  ///
  /// - **en**: "I'll do this later"
  /// - **de**: "Ich kümmere mich später darum"
  /// - **es**: "Lo haré más tarde"
  /// - **fr**: "Plus tard"
  /// - **ja**: "後でする"
  public static func Ill_do_this_later() -> String {
    return localizedString(
      key: "Ill_do_this_later",
      defaultValue: "I'll do this later",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Include ended projects"
  ///
  /// - **en**: "Include ended projects"
  /// - **de**: "Beendete Projekte anzeigen"
  /// - **es**: "Incluir proyectos finalizados"
  /// - **fr**: "Inclure les projets terminés"
  /// - **ja**: "終了済みのプロジェクトを含む"
  public static func Include_ended_projects() -> String {
    return localizedString(
      key: "Include_ended_projects",
      defaultValue: "Include ended projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Individual emails"
  ///
  /// - **en**: "Individual emails"
  /// - **de**: "Individuelle E-Mails"
  /// - **es**: "Notificaciones por correo electrónico individuales"
  /// - **fr**: "E-mails individuels"
  /// - **ja**: "個人メール"
  public static func Individual_Emails() -> String {
    return localizedString(
      key: "Individual_Emails",
      defaultValue: "Individual emails",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Info"
  ///
  /// - **en**: "Info"
  /// - **de**: "Info"
  /// - **es**: "Información"
  /// - **fr**: "Info"
  /// - **ja**: "インフォメーション"
  public static func Info() -> String {
    return localizedString(
      key: "Info",
      defaultValue: "Info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Intellectual property violation"
  ///
  /// - **en**: "Intellectual property violation"
  /// - **de**: "Urheberrechtsverletzung"
  /// - **es**: "Violación a la propiedad intelectual"
  /// - **fr**: "Atteinte à la propriété intellectuelle"
  /// - **ja**: "知的財産権の侵害"
  public static func Intellectual_property_violation() -> String {
    return localizedString(
      key: "Intellectual_property_violation",
      defaultValue: "Intellectual property violation",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Introduce yourself"
  ///
  /// - **en**: "Introduce yourself"
  /// - **de**: "Stelle dich vor"
  /// - **es**: "Preséntate"
  /// - **fr**: "Présentez-vous ici."
  /// - **ja**: "自己紹介"
  public static func Introduce_yourself() -> String {
    return localizedString(
      key: "Introduce_yourself",
      defaultValue: "Introduce yourself",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Introducing Lights On"
  ///
  /// - **en**: "Introducing Lights On"
  /// - **de**: "Wir stellen vor: Lights On"
  /// - **es**: "Presentamos "Seguimos activos""
  /// - **fr**: "Voici Lueurs d'espoir"
  /// - **ja**: "新企画「Lights On」"
  public static func Introducing_Lights_On() -> String {
    return localizedString(
      key: "Introducing_Lights_On",
      defaultValue: "Introducing Lights On",
      count: nil,
      substitutions: [:]
    )
  }
  /// "It looks like you've already reported this project to us. Our Trust and Safety team will screen your report against <a href="%{our_rules}">Our Rules</a> and <a href="%{community_guidelines}">Community Guidelines</a>. Thanks for your feedback."
  ///
  /// - **en**: "It looks like you've already reported this project to us. Our Trust and Safety team will screen your report against <a href="%{our_rules}">Our Rules</a> and <a href="%{community_guidelines}">Community Guidelines</a>. Thanks for your feedback."
  /// - **de**: "Es sieht so aus, als hättest du uns dieses Projekt bereits gemeldet. Unser Team für Vertrauen und Sicherheit wird das gemeldete Projekt hinsichtlich der Einhaltung <a href="%{our_rules}">Unserer Regeln</a> und der <a href="%{community_guidelines}">Community-Richtlinien</a> überprüfen. Danke für dein Feedback."
  /// - **es**: "Aparentemente, ya habías denunciado este proyecto. Nuestro equipo de confianza y seguridad revisará tu denuncia con base en <a href="%{our_rules}">Nuestras reglas</a> y <a href="%{community_guidelines}">Reglas de la comunidad</a>. Gracias por tus comentarios."
  /// - **fr**: "On dirait que vous nous ayez déjà signalé ce projet. Notre service Confiance et sécurité analysera votre signalement en fonction de <a href="%{our_rules}">nos règles</a> et <a href="%{community_guidelines}">nos règles de bonne conduite</a>."
  /// - **ja**: "このプロジェクトは既に報告済みです。 Kickstarter の「トラスト＆セーフティ」チームが<a href="%{our_rules}"> Kickstarter のルール</a>と<a href="%{community_guidelines}">コミュニティガイドライン</a>に基づいてご報告内容を確認いたします。貴重なご意見をいただきありがとうございます。"
  public static func It_looks(our_rules: String, community_guidelines: String) -> String {
    return localizedString(
      key: "It_looks",
      defaultValue: "It looks like you've already reported this project to us. Our Trust and Safety team will screen your report against <a href=\"%{our_rules}\">Our Rules</a> and <a href=\"%{community_guidelines}\">Community Guidelines</a>. Thanks for your feedback.",
      count: nil,
      substitutions: ["our_rules": our_rules, "community_guidelines": community_guidelines]
    )
  }
  /// "It's a way to bring creative projects to life."
  ///
  /// - **en**: "It's a way to bring creative projects to life."
  /// - **de**: "Es ist eine Plattform, um kreative Projekte ins Leben zu rufen."
  /// - **es**: "Es una plataforma para dar vida a proyectos creativos."
  /// - **fr**: "C'est un outil qui permet de donner vie à des projets créatifs."
  /// - **ja**: "クリエイティブなプロジェクトを実現するためのプラットフォームです。"
  public static func Its_a_way_to_bring_creative_projects_to_life() -> String {
    return localizedString(
      key: "Its_a_way_to_bring_creative_projects_to_life",
      defaultValue: "It's a way to bring creative projects to life.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "It's a way to bring creative projects to life. <a href="%{trust_link}">Learn more about accountability</a>"
  ///
  /// - **en**: "It's a way to bring creative projects to life. <a href="%{trust_link}">Learn more about accountability</a>"
  /// - **de**: "Es ist eine Plattform, um kreative Projekte zu verwirklichen. <a href="%{trust_link}">Hier findest du mehr Info zur Rechenschaftspflicht</a>"
  /// - **es**: "Es una forma de dar vida a proyectos creativos.<a href="%{trust_link}">Más información sobre las responsabilidades</a>"
  /// - **fr**: "Notre plateforme est un moyen de faire vivre des projets créatifs. <a href="%{trust_link}">En savoir plus sur la notion de responsabilité</a>"
  /// - **ja**: "クリエイティブなプロジェクトに生命を吹き込む場です。<a href="%{trust_link}">アカウンタビリティについて詳しくみる。</a>"
  public static func Its_a_way_to_bring_creative_projects_to_life_Learn_more_about_accountability(trust_link: String) -> String {
    return localizedString(
      key: "Its_a_way_to_bring_creative_projects_to_life_Learn_more_about_accountability",
      defaultValue: "It's a way to bring creative projects to life. <a href=\"%{trust_link}\">Learn more about accountability</a>",
      count: nil,
      substitutions: ["trust_link": trust_link]
    )
  }
  /// "It's our birthday! More than 160,000 creative projects have come to life on Kickstarter over the past decade, with support from over 16,000,000 backers."
  ///
  /// - **en**: "It's our birthday! More than 160,000 creative projects have come to life on Kickstarter over the past decade, with support from over 16,000,000 backers."
  /// - **de**: "Mithilfe von über 16.000.000 Unterstützern wurden in den letzten zehn Jahren über 160.000 kreative Projekte auf Kickstarter verwirklicht."
  /// - **es**: "¡Cumplimos años! Más de 160.000 proyectos creativos se han hecho realidad en Kickstarter durante la última década, gracias al apoyo de más de 16.000.000 de patrocinadores."
  /// - **fr**: "C'est notre anniversaire ! Au cours des dix dernières années, plus de 160 000 projets créatifs ont vu le jour sur Kickstarter grâce au soutien de plus de 16 000 000 contributeurs."
  /// - **ja**: "Kickstarter の誕生日です！過去10年の間に、16万以上のクリエイティブなプロジェクトが、1600万人以上のバッカーの支援のもと、Kickstarter で実現化しました。"
  public static func Its_our_birthday() -> String {
    return localizedString(
      key: "Its_our_birthday",
      defaultValue: "It's our birthday! More than 160,000 creative projects have come to life on Kickstarter over the past decade, with support from over 16,000,000 backers.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Join a fruitful community"
  ///
  /// - **en**: "Join a fruitful community"
  /// - **de**: "Schließe dich einer erfolgreichen Community an"
  /// - **es**: "Únete a una comunidad fructífera"
  /// - **fr**: "Rejoignez une communauté vivante"
  /// - **ja**: "活気あるコミュニティに参加しましょう"
  public static func Join_a_fruitful_community() -> String {
    return localizedString(
      key: "Join_a_fruitful_community",
      defaultValue: "Join a fruitful community",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Join our secret society."
  ///
  /// - **en**: "Join our secret society."
  /// - **de**: "Sei dabei bei unserem Geheimbund."
  /// - **es**: "Únete a nuestra sociedad secreta."
  /// - **fr**: "Notre société secrète n'attend que vous."
  /// - **ja**: "この秘密の世界にあなたも浸ってみませんか。"
  public static func Join_our_secret_society() -> String {
    return localizedString(
      key: "Join_our_secret_society",
      defaultValue: "Join our secret society.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Joining the live stream"
  ///
  /// - **en**: "Joining the live stream"
  /// - **de**: "Verbindung zum Live-Stream wird aufgebaut"
  /// - **es**: "Abriendo conexión a Live Stream"
  /// - **fr**: "Connexion à la diffusion en direct en cours"
  /// - **ja**: "ライブ配信に参加"
  public static func Joining_the_live_stream() -> String {
    return localizedString(
      key: "Joining_the_live_stream",
      defaultValue: "Joining the live stream",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Just for you."
  ///
  /// - **en**: "Just for you."
  /// - **de**: "Nur für dich."
  /// - **es**: "Sólo para ti."
  /// - **fr**: "Rien que pour vous."
  /// - **ja**: "あなたのために。"
  public static func Just_for_you() -> String {
    return localizedString(
      key: "Just_for_you",
      defaultValue: "Just for you.",
      count: nil,
      substitutions: [:]
    )
  }
}
