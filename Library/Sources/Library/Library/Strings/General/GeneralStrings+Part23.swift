// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Step %{current_step} of %{total_steps}"
  ///
  /// - **en**: "Step %{current_step} of %{total_steps}"
  /// - **de**: "Schritt %{current_step} von %{total_steps}"
  /// - **es**: "Paso %{current_step} de %{total_steps}"
  /// - **fr**: "Étape %{current_step} de%{total_steps}"
  /// - **ja**: "ステップ%{current_step} (合計%{total_steps}ステップ中)"
  public static func Step_number(current_step: String, total_steps: String) -> String {
    return localizedString(
      key: "Step_number",
      defaultValue: "Step %{current_step} of %{total_steps}",
      count: nil,
      substitutions: ["current_step": current_step, "total_steps": total_steps]
    )
  }
  /// "Stories"
  ///
  /// - **en**: "Stories"
  /// - **de**: "Geschichten"
  /// - **es**: "Historias"
  /// - **fr**: "Stories"
  /// - **ja**: "ストーリー"
  public static func Stories() -> String {
    return localizedString(
      key: "Stories",
      defaultValue: "Stories",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Subscribe"
  ///
  /// - **en**: "Subscribe"
  /// - **de**: "Abonnieren"
  /// - **es**: "Suscribir"
  /// - **fr**: "S'abonner"
  /// - **ja**: "購読する"
  public static func Subscribe() -> String {
    return localizedString(
      key: "Subscribe",
      defaultValue: "Subscribe",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Subscribed"
  ///
  /// - **en**: "Subscribed"
  /// - **de**: "Abo aktiviert"
  /// - **es**: "Suscripción activa"
  /// - **fr**: "Abonné "
  /// - **ja**: "購読済"
  public static func Subscribed() -> String {
    return localizedString(
      key: "Subscribed",
      defaultValue: "Subscribed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Subscribes to upcoming live streams."
  ///
  /// - **en**: "Subscribes to upcoming live streams."
  /// - **de**: "Zukünftige Live-Streams abonnieren."
  /// - **es**: "Activa subscripción a futuros Live-Streams."
  /// - **fr**: "Abonnement aux diffusions en direct à venir."
  /// - **ja**: "ライブ配信を購読"
  public static func Subscribes_to_upcoming_lives_streams() -> String {
    return localizedString(
      key: "Subscribes_to_upcoming_lives_streams",
      defaultValue: "Subscribes to upcoming live streams.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Successful projects have been created on Kickstarter."
  ///
  /// - **en**: "Successful projects have been created on Kickstarter."
  /// - **de**: "Projekte wurden erfolgreich auf Kickstarter finanziert."
  /// - **es**: "Proyectos exitosos se han creado en Kickstarter."
  /// - **fr**: "Le nombre total de projets intégralement financés sur Kickstarter."
  /// - **ja**: "のプロジェクトが Kickstarter で作成されました。"
  public static func Successful_projects_have_been_created_on_kickstarter() -> String {
    return localizedString(
      key: "Successful_projects_have_been_created_on_kickstarter",
      defaultValue: "Successful projects have been created on Kickstarter.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Support creative independence"
  ///
  /// - **en**: "Support creative independence"
  /// - **de**: "Unterstütze kreative Unabhängigkeit"
  /// - **es**: "Apoya la independencia creativa"
  /// - **fr**: "Soutenez l'indépendance créative"
  /// - **ja**: "クリエイティブな独立プロジェクトをサポートしよう"
  public static func Support_creative_independence() -> String {
    return localizedString(
      key: "Support_creative_independence",
      defaultValue: "Support creative independence",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Support creative spaces and businesses affected by COVID-19."
  ///
  /// - **en**: "Support creative spaces and businesses affected by COVID-19."
  /// - **de**: "Unterstütze kreative Lokale und Geschäfte, ddie von COVID-19 betroffen sind."
  /// - **es**: "Apoya espacios creativos y negocios afectados por el COVID-19."
  /// - **fr**: "Les entreprises et les espaces créatifs touchés par le COVID-19 ont besoin de vous."
  /// - **ja**: "新型コロナウイルス危機によって影響を受けた文化スペースやクリエイティブなビジネスをサポートしましょう。"
  public static func Support_creative_spaces_and_businesses_affected_by() -> String {
    return localizedString(
      key: "Support_creative_spaces_and_businesses_affected_by",
      defaultValue: "Support creative spaces and businesses affected by COVID-19.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sustainable distribution"
  ///
  /// - **en**: "Sustainable distribution"
  /// - **de**: "Nachhaltiger Versand"
  /// - **es**: "Distribución sustentable"
  /// - **fr**: "Distribution durable"
  /// - **ja**: "持続可能な流通"
  public static func Sustainable_distribution() -> String {
    return localizedString(
      key: "Sustainable_distribution",
      defaultValue: "Sustainable distribution",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sustainable materials"
  ///
  /// - **en**: "Sustainable materials"
  /// - **de**: "Nachhaltige Materialien"
  /// - **es**: "Materiales sustentables"
  /// - **fr**: "Des matières durables"
  /// - **ja**: "持続可能な材料"
  public static func Sustainable_materials() -> String {
    return localizedString(
      key: "Sustainable_materials",
      defaultValue: "Sustainable materials",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tell us more details"
  ///
  /// - **en**: "Tell us more details"
  /// - **de**: "Gib uns weitere Details"
  /// - **es**: "Cuéntanos más"
  /// - **fr**: "Dites-nous-en plus."
  /// - **ja**: "詳しい説明を記入してください"
  public static func Tell_us_more_details() -> String {
    return localizedString(
      key: "Tell_us_more_details",
      defaultValue: "Tell us more details",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tell us why (optional)"
  ///
  /// - **en**: "Tell us why (optional)"
  /// - **de**: "Möchtest du uns den Grund verraten? (Optional)"
  /// - **es**: "Cuéntanos por qué (opcional)"
  /// - **fr**: "Dites-nous pourquoi (facultatif)"
  /// - **ja**: "理由を教えてください (任意)"
  public static func Tell_us_why_optional() -> String {
    return localizedString(
      key: "Tell_us_why_optional",
      defaultValue: "Tell us why (optional)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Ten is just the beginning."
  ///
  /// - **en**: "Ten is just the beginning."
  /// - **de**: "Zehn Jahre - das ist nur der Anfang."
  /// - **es**: "Diez es sólo el comienzo."
  /// - **fr**: "Dix, ce n'est que le début."
  /// - **ja**: "「10年」とはいえ、まだ始まったばかり。"
  public static func Ten_is_just_the_beginning() -> String {
    return localizedString(
      key: "Ten_is_just_the_beginning",
      defaultValue: "Ten is just the beginning.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Thank you!"
  ///
  /// - **en**: "Thank you!"
  /// - **de**: "Vielen Dank!"
  /// - **es**: "¡Gracias!"
  /// - **fr**: "Merci !"
  /// - **ja**: "ありがとうございます！"
  public static func Thank_you_exclamation() -> String {
    return localizedString(
      key: "Thank_you_exclamation",
      defaultValue: "Thank you!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Thank you for supporting this project."
  ///
  /// - **en**: "Thank you for supporting this project."
  /// - **de**: "Vielen Dank für deine Unterstützung dieses Projekts."
  /// - **es**: "Gracias por apoyar este proyecto."
  /// - **fr**: "Merci pour votre soutien."
  /// - **ja**: "サポートいただきありがとうございます。"
  public static func Thank_you_for_supporting_this_project() -> String {
    return localizedString(
      key: "Thank_you_for_supporting_this_project",
      defaultValue: "Thank you for supporting this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Thanks for being part of all the joy, hard work, and hope that’s gone into it—and cheers to what’s ahead."
  ///
  /// - **en**: "Thanks for being part of all the joy, hard work, and hope that’s gone into it—and cheers to what’s ahead."
  /// - **de**: "Vielen Dank, dass du die Freuden, harte Arbeit und Hoffnungen mit uns geteilt hast - wir freuen uns schon darauf, was wir in Zukunft erreichen können."
  /// - **es**: "Gracias por ser parte de toda la alegría, el arduo trabajo y las expectativas que esto ha generado. Brindemos por lo que está por venir."
  /// - **fr**: "Vous avez partagé nos joies, nos espoirs et l'ardeur de notre travail. Sans vous, nous ne serions pas là."
  /// - **ja**: "これらプロジェクトに注がれた努力、希望、喜びにご貢献いただきありがとうございます。ぜひ今後もさらなるプロジェクトを共に成功へと導きましょう。"
  public static func Thanks_for_being_part_of_all_the_joy() -> String {
    return localizedString(
      key: "Thanks_for_being_part_of_all_the_joy",
      defaultValue: "Thanks for being part of all the joy, hard work, and hope that’s gone into it—and cheers to what’s ahead.",
      count: nil,
      substitutions: [:]
    )
  }
}
