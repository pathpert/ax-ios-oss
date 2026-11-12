// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Processing..."
  ///
  /// - **en**: "Processing..."
  /// - **de**: "Verarbeitung läuft..."
  /// - **es**: "Procesando..."
  /// - **fr**: "Traitement en cours..."
  /// - **ja**: "アップロード中"
  public static func Processing() -> String {
    return localizedString(
      key: "Processing",
      defaultValue: "Processing...",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Prohibited items"
  ///
  /// - **en**: "Prohibited items"
  /// - **de**: "Unzulässige Artikel"
  /// - **es**: "Artículos prohibidos"
  /// - **fr**: "Articles interdits"
  /// - **ja**: "禁止事項"
  public static func Prohibited_items() -> String {
    return localizedString(
      key: "Prohibited_items",
      defaultValue: "Prohibited items",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Projects We Love"
  ///
  /// - **en**: "Projects We Love"
  /// - **de**: "Team-Favoriten"
  /// - **es**: "Nuestros Favoritos"
  /// - **fr**: "Nos coups de cœur"
  /// - **ja**: "Projects We Love"
  public static func Projects_We_Love() -> String {
    return localizedString(
      key: "Projects_We_Love",
      defaultValue: "Projects We Love",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Projects cannot plagiarize, offer items that aren't produced by the creator, or repackage a previously-created product without adding anything new."
  ///
  /// - **en**: "Projects cannot plagiarize, offer items that aren't produced by the creator, or repackage a previously-created product without adding anything new."
  /// - **de**: "Plagiate von Projekten sind verboten. Es ist verboten, Produkte anzubieten, die nicht vom Projektgründer erstellt wurden oder bereits bestehende Produkte in neuer Verpackung weiterzuleiten, ohne dabei etwas Neues hinzuzufügen."
  /// - **es**: "Los proyectos no pueden plagiar, ofrecer productos que no sean fabricados por el creador ni utilizar un producto previamente fabricado con un nuevo embalaje pero sin agregar algo nuevo."
  /// - **fr**: "Le plagiat, la revente d'articles que le créateur n'a pas fabriqués lui-même et le reconditionnement d'un produit créé précédemment, sans y avoir ajouté quoi que ce soit de nouveau, sont interdits."
  /// - **ja**: "プロジェクトでは盗作行為は禁止されています。また、クリエイターによるプロデュースではないアイテムを提供したり、新しいものを追加することなく過去の製品を再梱包したりすることはできません。"
  public static func Projects_cannot_plagiarize() -> String {
    return localizedString(
      key: "Projects_cannot_plagiarize",
      defaultValue: "Projects cannot plagiarize, offer items that aren't produced by the creator, or repackage a previously-created product without adding anything new.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Projects may not offer items mentioned in our <a href="%{prohibited_items}">prohibited items</a> list."
  ///
  /// - **en**: "Projects may not offer items mentioned in our <a href="%{prohibited_items}">prohibited items</a> list."
  /// - **de**: "Im Rahmen von Projekten dürfen keine Artikel angeboten werden, die auf unserer Liste mit <a href="%{prohibited_items}">unzulässigen Artikeln</a> aufgeführt sind."
  /// - **es**: "Los proyectos no pueden ofrecer ninguno de los artículos mencionados en nuestra lista de <a href="%{prohibited_items}">artículos prohibidos</a>."
  /// - **fr**: "Les créateurs doivent s'abstenir de proposer des <a href="%{prohibited_items}">articles interdits</a>."
  /// - **ja**: "プロジェクトでは、Kickstarter の<a href="%{prohibited_items}">禁止項目</a>一覧に載っているものを提供してはいけません。"
  public static func Projects_may_not_offer(prohibited_items: String) -> String {
    return localizedString(
      key: "Projects_may_not_offer",
      defaultValue: "Projects may not offer items mentioned in our <a href=\"%{prohibited_items}\">prohibited items</a> list.",
      count: nil,
      substitutions: ["prohibited_items": prohibited_items]
    )
  }
  /// "Projects on Kickstarter must create something to share with others."
  ///
  /// - **en**: "Projects on Kickstarter must create something to share with others."
  /// - **de**: "Bei Projekten auf Kickstarter muss etwas erschaffen werden, das mit anderen geteilt werden kann."
  /// - **es**: "Los proyectos de Kickstarter deben crear algo para compartir con los demás."
  /// - **fr**: "Les projets Kickstarter ont pour but la création d'un produit ou d'une œuvre à portée collective."
  /// - **ja**: "Kickstarter のプロジェクトでは「人と共有できるもの」を創り上げる必要があります。"
  public static func Projects_on() -> String {
    return localizedString(
      key: "Projects_on",
      defaultValue: "Projects on Kickstarter must create something to share with others.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Projects you've backed"
  ///
  /// - **en**: "Projects you've backed"
  /// - **de**: "Projekte, die du unterstützt hast"
  /// - **es**: "Proyectos que has patrocinado"
  /// - **fr**: "Les projets que j'ai soutenus"
  /// - **ja**: "バック（支援）したプロジェクト"
  public static func Projects_youve_backed() -> String {
    return localizedString(
      key: "Projects_youve_backed",
      defaultValue: "Projects you've backed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Projects you've launched"
  ///
  /// - **en**: "Projects you've launched"
  /// - **de**: "Deine veröffentlichten Projekte"
  /// - **es**: "Proyectos que has publicado"
  /// - **fr**: "Les projets que vous avez lancés"
  /// - **ja**: "ローンチしたプロジェクト"
  public static func Projects_youve_launched() -> String {
    return localizedString(
      key: "Projects_youve_launched",
      defaultValue: "Projects you've launched",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Prototype misrepresentation"
  ///
  /// - **en**: "Prototype misrepresentation"
  /// - **de**: "Falschdarstellung eines Prototypen"
  /// - **es**: "Presentación falsa de prototipo"
  /// - **fr**: "Fausse représentation du prototype"
  /// - **ja**: "プロトタイプの不実表示・虚偽表示"
  public static func Prototype_misrepresentation() -> String {
    return localizedString(
      key: "Prototype_misrepresentation",
      defaultValue: "Prototype misrepresentation",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pursue
  /// ring ideas."
  ///
  /// - **en**: "Pursue
  /// ring ideas."
  /// - **de**: "Zündende Ideen."
  /// - **es**: "Un universo de geniales ideas."
  /// - **fr**: "Des idées audacieuses."
  /// - **ja**: "大胆な
  /// ディアを。"
  public static func Pursue_daring_ideas() -> String {
    return localizedString(
      key: "Pursue_daring_ideas",
      defaultValue: "Pursue\ndaring ideas.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rate us in the App Store"
  ///
  /// - **en**: "Rate us in the App Store"
  /// - **de**: "Bewerte uns im App Store!"
  /// - **es**: "¡Califícanos en la App Store!"
  /// - **fr**: "Évaluez-nous dans l'App Store"
  /// - **ja**: "Appストアで評価する"
  public static func Rate_us_in_the_App_Store() -> String {
    return localizedString(
      key: "Rate_us_in_the_App_Store",
      defaultValue: "Rate us in the App Store",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Receive a weekly mix of handpicked projects, plus occasional Kickstarter news."
  ///
  /// - **en**: "Receive a weekly mix of handpicked projects, plus occasional Kickstarter news."
  /// - **de**: "Du erhältst unseren wöchentlichen Mix handverlesener Projekte plus gelegentliche Nachrichten von Kickstarter."
  /// - **es**: "Recibe una combinación semanal de proyectos seleccionados exclusivamente para ti, además de noticias ocasionales de Kickstarter."
  /// - **fr**: "Recevoir une sélection hebdomadaire, et de temps en temps des actualités de Kickstarter."
  /// - **ja**: "毎週送られる Kickstarter イチオシのプロジェクトを紹介するニュースレターを受信する (随時送られる Kickstarter ニュースも)。"
  public static func Receive_a_weekly_mix_of_handpicked_projects_plus_occasional_Kickstarter_news() -> String {
    return localizedString(
      key: "Receive_a_weekly_mix_of_handpicked_projects_plus_occasional_Kickstarter_news",
      defaultValue: "Receive a weekly mix of handpicked projects, plus occasional Kickstarter news.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recent live stream"
  ///
  /// - **en**: "Recent live stream"
  /// - **de**: "Kürzlich gesendeter Live-Stream"
  /// - **es**: "Live-Stream reciente"
  /// - **fr**: "Diffusion en direct récente"
  /// - **ja**: "最近のライブ配信"
  public static func Recent_live_stream() -> String {
    return localizedString(
      key: "Recent_live_stream",
      defaultValue: "Recent live stream",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recommendations"
  ///
  /// - **en**: "Recommendations"
  /// - **de**: "Empfehlungen"
  /// - **es**: "Recomendaciones"
  /// - **fr**: "Recommandations"
  /// - **ja**: "おすすめ"
  public static func Recommendations() -> String {
    return localizedString(
      key: "Recommendations",
      defaultValue: "Recommendations",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recommendations More Info"
  ///
  /// - **en**: "Recommendations More Info"
  /// - **de**: "Mehr Info zu Empfehlungen"
  /// - **es**: "Más información sobre las recomendaciones"
  /// - **fr**: "Plus d'infos sur les recommandations"
  /// - **ja**: "おすすめ 詳細"
  public static func Recommendations_More_Info() -> String {
    return localizedString(
      key: "Recommendations_More_Info",
      defaultValue: "Recommendations More Info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Recorded Live"
  ///
  /// - **en**: "Recorded Live"
  /// - **de**: "Live aufgenommen"
  /// - **es**: "Grabado en vivo"
  /// - **fr**: "Enregistré en direct"
  /// - **ja**: "配信済ライブ"
  public static func Recorded_Live() -> String {
    return localizedString(
      key: "Recorded_Live",
      defaultValue: "Recorded Live",
      count: nil,
      substitutions: [:]
    )
  }
}
