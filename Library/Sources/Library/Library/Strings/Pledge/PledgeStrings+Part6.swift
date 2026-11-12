// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Payment methods"
  ///
  /// - **en**: "Payment methods"
  /// - **de**: "Zahlungsmethoden"
  /// - **es**: "Métodos de pago"
  /// - **fr**: "Moyens de paiement "
  /// - **ja**: "お支払い方法"
  public static func Payment_methods() -> String {
    return localizedString(
      key: "Payment_methods",
      defaultValue: "Payment methods",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Payment schedule"
  ///
  /// - **en**: "Payment schedule"
  /// - **de**: "Zahlungsübersicht"
  /// - **es**: "Calendario de pagos"
  /// - **fr**: "Calendrier des règlements"
  /// - **ja**: "お支払いのスケジュール"
  public static func Payment_schedule() -> String {
    return localizedString(
      key: "Payment_schedule",
      defaultValue: "Payment schedule",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Please enter a pledge amount between %{min} and %{max}."
  ///
  /// - **en**: "Please enter a pledge amount between %{min} and %{max}."
  /// - **de**: "Bitte gebe einen Betrag zwischen %{min} und %{max} ein."
  /// - **es**: "Por favor ingresa un monto de contribución entre %{min} y %{max}."
  /// - **fr**: "Veuillez saisir un engagement entre %{min} et %{max}."
  /// - **ja**: "%{min} から %{max} までのプレッジ額を入力してください。"
  public static func Please_enter_a_pledge_amount_between_min_and_max(min: String, max: String) -> String {
    return localizedString(
      key: "Please_enter_a_pledge_amount_between_min_and_max",
      defaultValue: "Please enter a pledge amount between %{min} and %{max}.",
      count: nil,
      substitutions: ["min": min, "max": max]
    )
  }
  /// "Pledge"
  ///
  /// - **en**: "Pledge"
  /// - **de**: "Unterstützen"
  /// - **es**: "Contribuir"
  /// - **fr**: "Je m'engage"
  /// - **ja**: "プレッジする"
  public static func Pledge() -> String {
    return localizedString(
      key: "Pledge",
      defaultValue: "Pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge Over Time"
  ///
  /// - **en**: "Pledge Over Time"
  /// - **de**: "Ratenzahlung"
  /// - **es**: "Contribución en cuotas"
  /// - **fr**: "Contribution étalée dans le temps"
  /// - **ja**: "分割プレッジ"
  public static func Pledge_Over_Time() -> String {
    return localizedString(
      key: "Pledge_Over_Time",
      defaultValue: "Pledge Over Time",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge activity"
  ///
  /// - **en**: "Pledge activity"
  /// - **de**: "Finanzierungsbeiträge"
  /// - **es**: "Actividad de contribución"
  /// - **fr**: "Mes engagements"
  /// - **ja**: "プレッジ"
  public static func Pledge_activity() -> String {
    return localizedString(
      key: "Pledge_activity",
      defaultValue: "Pledge activity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge amount"
  ///
  /// - **en**: "Pledge amount"
  /// - **de**: "Beitragshöhe"
  /// - **es**: "Monto de contribución"
  /// - **fr**: "Montant engagé"
  /// - **ja**: "プレッジする金額"
  public static func Pledge_amount() -> String {
    return localizedString(
      key: "Pledge_amount",
      defaultValue: "Pledge amount",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{pledge_amount} pledged"
  ///
  /// - **en**: "%{pledge_amount} pledged"
  /// - **de**: "%{pledge_amount} beigetragen"
  /// - **es**: "%{pledge_amount} contribuido"
  /// - **fr**: "%{pledge_amount} engagés"
  /// - **ja**: "%{pledge_amount} のプレッジ"
  public static func Pledge_amount_pledged(pledge_amount: String) -> String {
    return localizedString(
      key: "Pledge_amount_pledged",
      defaultValue: "%{pledge_amount} pledged",
      count: nil,
      substitutions: ["pledge_amount": pledge_amount]
    )
  }
  /// "Pledge any amount to help bring this project to life."
  ///
  /// - **en**: "Pledge any amount to help bring this project to life."
  /// - **de**: "Du kannst jeden beliebigen Betrag eingeben, um das Projekt zu unterstützen."
  /// - **es**: "Puedes contribuir un monto de libre selección para apoyar este proyecto."
  /// - **fr**: "Choisissez le montant de votre engagement à soutenir ce projet."
  /// - **ja**: "プレッジでプロジェクトに生命を。"
  public static func Pledge_any_amount_to_help_bring_this_project_to_life() -> String {
    return localizedString(
      key: "Pledge_any_amount_to_help_bring_this_project_to_life",
      defaultValue: "Pledge any amount to help bring this project to life.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge details"
  ///
  /// - **en**: "Pledge details"
  /// - **de**: "Dein Finanzierungsbeitrag"
  /// - **es**: "Detalles de la contribución"
  /// - **fr**: "Détails de mon engagement"
  /// - **ja**: "プレッジ詳細"
  public static func Pledge_details() -> String {
    return localizedString(
      key: "Pledge_details",
      defaultValue: "Pledge details",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Add-ons"
  ///
  /// - **en**: "Add-ons"
  /// - **de**: "Add-ons"
  /// - **es**: "Complementos"
  /// - **fr**: "Compléments"
  /// - **ja**: "アドオン"
  public static func Pledge_flow_navigation_bar_titles_Addons() -> String {
    return localizedString(
      key: "Pledge_flow_navigation_bar_titles.Addons",
      defaultValue: "Add-ons",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Bonus Support"
  ///
  /// - **en**: "Bonus Support"
  /// - **de**: "Bonus-Unterstützung"
  /// - **es**: "Apoyo extra"
  /// - **fr**: "Coup de pouce"
  /// - **ja**: "ボーナスサポート"
  public static func Pledge_flow_navigation_bar_titles_Bonus_support() -> String {
    return localizedString(
      key: "Pledge_flow_navigation_bar_titles.Bonus_support",
      defaultValue: "Bonus Support",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Payment"
  ///
  /// - **en**: "Payment"
  /// - **de**: "Zahlung"
  /// - **es**: "Pago"
  /// - **fr**: "Paiement"
  /// - **ja**: "支払い"
  public static func Pledge_flow_navigation_bar_titles_Payment() -> String {
    return localizedString(
      key: "Pledge_flow_navigation_bar_titles.Payment",
      defaultValue: "Payment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Project"
  ///
  /// - **en**: "Project"
  /// - **de**: "Projekt"
  /// - **es**: "Proyecto"
  /// - **fr**: "Projet"
  /// - **ja**: "プロジェクト"
  public static func Pledge_flow_navigation_bar_titles_Project() -> String {
    return localizedString(
      key: "Pledge_flow_navigation_bar_titles.Project",
      defaultValue: "Project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rewards"
  ///
  /// - **en**: "Rewards"
  /// - **de**: "Belohnungen"
  /// - **es**: "Recompensas"
  /// - **fr**: "Vos récompenses"
  /// - **ja**: "リワード"
  public static func Pledge_flow_navigation_bar_titles_Rewards() -> String {
    return localizedString(
      key: "Pledge_flow_navigation_bar_titles.Rewards",
      defaultValue: "Rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledge in full"
  ///
  /// - **en**: "Pledge in full"
  /// - **de**: "Sofortzahlung"
  /// - **es**: "Contribución total"
  /// - **fr**: "Engagement intégral"
  /// - **ja**: "一括払いのプレッジ"
  public static func Pledge_in_full() -> String {
    return localizedString(
      key: "Pledge_in_full",
      defaultValue: "Pledge in full",
      count: nil,
      substitutions: [:]
    )
  }
}
