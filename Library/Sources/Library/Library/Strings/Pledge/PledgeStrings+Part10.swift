// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "This allows you to see project goal and pledge amounts in your preferred currency."
  ///
  /// - **en**: "This allows you to see project goal and pledge amounts in your preferred currency."
  /// - **de**: "Hier kannst du das Finanzierungsziel und die Finanzierungsbeiträge in deiner bevorzugten Währung ansehen."
  /// - **es**: "Esto te permite ver la meta del proyecto y los montos de las contribuciones en la moneda de tu preferencia."
  /// - **fr**: "L'objectif du projet et les montants des engagements s'afficheront ainsi dans la devise de votre choix."
  /// - **ja**: "これにより、プロジェクトのファンディングゴールとプレッジ金額をご希望の通貨で表示することができます。"
  public static func This_allows_you_to_see_project_goal_and_pledge_amounts_in_your_preferred_currency() -> String {
    return localizedString(
      key: "This_allows_you_to_see_project_goal_and_pledge_amounts_in_your_preferred_currency",
      defaultValue: "This allows you to see project goal and pledge amounts in your preferred currency.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This holiday season, support a project for no reward, just because it speaks to you."
  ///
  /// - **en**: "This holiday season, support a project for no reward, just because it speaks to you."
  /// - **de**: "Weihnachten steht kurz vor der Tür - unterstütze ein Projekt ohne Belohnung. Einfach, weil es dich anspricht."
  /// - **es**: "Esta temporada de fiestas, apoya un proyecto sin recompensa, simplemente porque te resulta interesante."
  /// - **fr**: "Pour les fêtes, soutenez un projet simplement parce qu'il vous parle, sans choisir de récompense."
  /// - **ja**: "このホリデーシーズンはぜひ、リワード無しでも「支援したい！」と思わせてくれるような、あなたの心に訴えかけるプロジェクトをサポートしてみませんか？"
  public static func This_holiday_season_support_a_project_for_no_reward() -> String {
    return localizedString(
      key: "This_holiday_season_support_a_project_for_no_reward",
      defaultValue: "This holiday season, support a project for no reward, just because it speaks to you.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This person has canceled their pledge."
  ///
  /// - **en**: "This person has canceled their pledge."
  /// - **de**: "Diese Person hat ihren Finanzierungsbeitrag zurückgezogen."
  /// - **es**: "Esta persona canceló su contribución."
  /// - **fr**: "Cette personne a annulé son engagement."
  /// - **ja**: "このユーザーはプレッジをキャンセルしました。"
  public static func This_person_canceled_their_pledge() -> String {
    return localizedString(
      key: "This_person_canceled_their_pledge",
      defaultValue: "This person has canceled their pledge.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This pledge was dropped because of payment errors."
  ///
  /// - **en**: "This pledge was dropped because of payment errors."
  /// - **de**: "Dieser Finanzierungsbeitrag wurde aufgrund von Fehlern, die bei der Zahlung auftraten, nicht übernommen."
  /// - **es**: "Esta contribución no pudo ser cobrada por un error en el método de pago."
  /// - **fr**: "Cet engagement a été annulé en raison d'un échec de règlement."
  /// - **ja**: "支払関連のエラーにより、このプレッジは取り消されました。"
  public static func This_pledge_was_dropped_because_of_payment_errors() -> String {
    return localizedString(
      key: "This_pledge_was_dropped_because_of_payment_errors",
      defaultValue: "This pledge was dropped because of payment errors.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This project didn’t reach its funding goal, so your payment method was never charged."
  ///
  /// - **en**: "This project didn’t reach its funding goal, so your payment method was never charged."
  /// - **de**: "Bei diesem Projekt wurde das Finanzierungsziel nicht erreicht. Daher wurde deine Zahlungsmethode nicht belastet."
  /// - **es**: "Este proyecto no alcanzó su meta de financiamiento, así que no se realizó ningún cargo a tu método de pago."
  /// - **fr**: "L'objectif de financement de ce projet n'a pas été atteint, donc votre moyen de paiement n'a pas été débité."
  /// - **ja**: "このプロジェクトはファンディングゴールに到達しなかったため、お支払い方法への請求は行われませんでした。"
  public static func This_project_didnt_reach_its_funding_goal_so_your_payment_method_was_never_charged() -> String {
    return localizedString(
      key: "This_project_didnt_reach_its_funding_goal_so_your_payment_method_was_never_charged",
      defaultValue: "This project didn’t reach its funding goal, so your payment method was never charged.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This project will only be funded on if at least %{amount} is pledged by %{date}."
  ///
  /// - **en**: "This project will only be funded on if at least %{amount} is pledged by %{date}."
  /// - **de**: "Dieses Projekt wird nur finanziert, wenn bis am %{date} Unterstützungsbeiträge von mindestens %{amount} geleistet werden."
  /// - **es**: "Este proyecto sólo será financiado si se contribuye al menos un monto de %{amount} antes del %{date}."
  /// - **fr**: "Ce projet ne sera financé que si au moins %{amount} sont engagés d'ici le %{date}."
  /// - **ja**: "%{date} までに %{amount} 以上のプレッジが集まれば、このプロジェクトは資金を得ることができます。"
  public static func This_project_will_only_be_funded_on_if_at_least_amount_is_pledged_by_date(amount: String, date: String) -> String {
    return localizedString(
      key: "This_project_will_only_be_funded_on_if_at_least_amount_is_pledged_by_date",
      defaultValue: "This project will only be funded on if at least %{amount} is pledged by %{date}.",
      count: nil,
      substitutions: ["amount": amount, "date": date]
    )
  }
  /// "To see all rewards, view your project."
  ///
  /// - **en**: "To see all rewards, view your project."
  /// - **de**: "Um alle Belohnungen zu sehen, gehe zu deinem Projekt."
  /// - **es**: "Para ver todas las recompensas, revisa tu proyecto."
  /// - **fr**: "Accéder à votre projet pour voir toutes vos récompenses"
  /// - **ja**: "すべてのリワードを確認するには、プロジェクトをご覧ください。"
  public static func To_see_all_rewards_view_your_project() -> String {
    return localizedString(
      key: "To_see_all_rewards_view_your_project",
      defaultValue: "To see all rewards, view your project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Top pledge sources"
  ///
  /// - **en**: "Top pledge sources"
  /// - **de**: "Woher deine Unterstützungen kommen"
  /// - **es**: "Principales fuentes de contribución"
  /// - **fr**: "Vos principales sources de contributions"
  /// - **ja**: "プレッジソースのトップ"
  public static func Top_pledge_sources() -> String {
    return localizedString(
      key: "Top_pledge_sources",
      defaultValue: "Top pledge sources",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Top 10 pledge sources"
  ///
  /// - **en**: "Top 10 pledge sources"
  /// - **de**: "Top 10 Quellen deiner Beiträge"
  /// - **es**: "Las 10 principales fuentes de contribución"
  /// - **fr**: "Vos 10 principales sources de contributions"
  /// - **ja**: "プレッジソースのトップ10"
  public static func Top_ten_pledge_sources() -> String {
    return localizedString(
      key: "Top_ten_pledge_sources",
      defaultValue: "Top 10 pledge sources",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Top 10 rewards"
  ///
  /// - **en**: "Top 10 rewards"
  /// - **de**: "Top 10-Belohnungen"
  /// - **es**: "Las 10 mejores recompensas"
  /// - **fr**: "Les 10 récompenses qui ont le plus de succès"
  /// - **ja**: "リワードのトップ10"
  public static func Top_ten_rewards() -> String {
    return localizedString(
      key: "Top_ten_rewards",
      defaultValue: "Top 10 rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Total amount (USD) backers have pledged to projects."
  ///
  /// - **en**: "Total amount (USD) backers have pledged to projects."
  /// - **de**: "Gesamtsumme (in USD) aller Finanzierungsbeiträge zu Kickstarter-Projekten."
  /// - **es**: "El monto total (USD) que los patrocinadores han contribuido a proyectos."
  /// - **fr**: "Le montant total (en USD) engagé par les contributeurs."
  /// - **ja**: "バッカーの皆さまがプロジェクトにプレッジした合計金額 (米ドル)。"
  public static func Total_amount_backers_have_pledged_to_projects() -> String {
    return localizedString(
      key: "Total_amount_backers_have_pledged_to_projects",
      defaultValue: "Total amount (USD) backers have pledged to projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Total pledged"
  ///
  /// - **en**: "Total pledged"
  /// - **de**: "Anzahl der Beiträge insgesamt"
  /// - **es**: "Contribuciones en total"
  /// - **fr**: "Total engagé"
  /// - **ja**: "プレッジ総計"
  public static func Total_pledged() -> String {
    return localizedString(
      key: "Total_pledged",
      defaultValue: "Total pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Track your backings"
  ///
  /// - **en**: "Track your backings"
  /// - **de**: "Folge deinen unterstützten Projekten"
  /// - **es**: "Sigue los proyectos que has patrocinado"
  /// - **fr**: "Suivi de vos engagements"
  /// - **ja**: "支援したプロジェクトを追跡"
  public static func Track_your_backings() -> String {
    return localizedString(
      key: "Track_your_backings",
      defaultValue: "Track your backings",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsuccessful and canceled backings"
  ///
  /// - **en**: "Unsuccessful and canceled backings"
  /// - **de**: "Beiträge für nicht erfolgreiche und stornierte Projekte"
  /// - **es**: "Contribuciones a proyectos no financiados o cancelados"
  /// - **fr**: "Projets non financés ou annulés"
  /// - **ja**: "資金調達が成功せずキャンセルされた支援"
  public static func Unsuccessful_and_canceled_backings() -> String {
    return localizedString(
      key: "Unsuccessful_and_canceled_backings",
      defaultValue: "Unsuccessful and canceled backings",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We don't accept this card type. Please try again with another one."
  ///
  /// - **en**: "We don't accept this card type. Please try again with another one."
  /// - **de**: "Dieser Kartentyp wird nicht von uns anerkannt. Bitte versuche es mit einer anderen Karte erneut."
  /// - **es**: "No aceptamos este tipo de tarjeta. Intenta de nuevo con otra."
  /// - **fr**: "Ce type n'est pas accepté. Veuillez réessayer avec une autre carte."
  /// - **ja**: "残念ながらこのタイプのカードには対応しておりません。別のカードにてもう一度お試しください。"
  public static func Unsupported_card_type() -> String {
    return localizedString(
      key: "Unsupported_card_type",
      defaultValue: "We don't accept this card type. Please try again with another one.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Update pledge"
  ///
  /// - **en**: "Update pledge"
  /// - **de**: "Beitrag aktualisieren"
  /// - **es**: "Actualizar contribución"
  /// - **fr**: "Modifier mon engagement"
  /// - **ja**: "プレッジを更新する"
  public static func Update_pledge() -> String {
    return localizedString(
      key: "Update_pledge",
      defaultValue: "Update pledge",
      count: nil,
      substitutions: [:]
    )
  }
}
