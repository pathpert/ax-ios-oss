// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Total"
  ///
  /// - **en**: "Total"
  /// - **de**: "Gesamt"
  /// - **es**: "Total"
  /// - **fr**: "Total"
  /// - **ja**: "合計"
  public static func Total() -> String {
    return localizedString(
      key: "Total",
      defaultValue: "Total",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Total amount"
  ///
  /// - **en**: "Total amount"
  /// - **de**: "Gesamtbetrag"
  /// - **es**: "Monto total"
  /// - **fr**: "Montant total"
  /// - **ja**: "合計金額"
  public static func Total_amount() -> String {
    return localizedString(
      key: "Total_amount",
      defaultValue: "Total amount",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{total_amount} billion+"
  ///
  /// - **en**: "%{total_amount} billion+"
  /// - **de**: "%{total_amount} Milliarden+"
  /// - **es**: "%{total_amount} mil millones+"
  /// - **fr**: "Plus de 4 milliards de dollars"
  /// - **ja**: "%{total_amount},000,000,000 以上"
  public static func Total_amount_billion_plus(total_amount: String) -> String {
    return localizedString(
      key: "Total_amount_billion_plus",
      defaultValue: "%{total_amount} billion+",
      count: nil,
      substitutions: ["total_amount": total_amount]
    )
  }
  /// "%{total}+"
  ///
  /// - **en**: "%{total}+"
  /// - **de**: "Über %{total}"
  /// - **es**: "Más de %{total}"
  /// - **fr**: "Plus de %{total}"
  /// - **ja**: "%{total}以上"
  public static func Total_plus(total: String) -> String {
    return localizedString(
      key: "Total_plus",
      defaultValue: "%{total}+",
      count: nil,
      substitutions: ["total": total]
    )
  }
  /// "Track shipment"
  ///
  /// - **en**: "Track shipment"
  /// - **de**: "Sendung verfolgen"
  /// - **es**: "Seguir envío"
  /// - **fr**: "Suivre le colis"
  /// - **ja**: "配送状況を追跡"
  public static func Track_shipment() -> String {
    return localizedString(
      key: "Track_shipment",
      defaultValue: "Track shipment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Tracking number: %{number}"
  ///
  /// - **en**: "Tracking number: %{number}"
  /// - **de**: "Sendungsnummer: %{number}"
  /// - **es**: "Número de seguimiento: %{number}"
  /// - **fr**: "Numéro de suivi : %{number}"
  /// - **ja**: "追跡番号：%{number}"
  public static func Tracking_number(number: String) -> String {
    return localizedString(
      key: "Tracking_number",
      defaultValue: "Tracking number: %{number}",
      count: nil,
      substitutions: ["number": number]
    )
  }
  /// "Trending"
  ///
  /// - **en**: "Trending"
  /// - **de**: "Im Trend"
  /// - **es**: "Trending"
  /// - **fr**: "Les tendances"
  /// - **ja**: "急上昇"
  public static func Trending() -> String {
    return localizedString(
      key: "Trending",
      defaultValue: "Trending",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Try rephrasing your search"
  ///
  /// - **en**: "Try rephrasing your search"
  /// - **de**: "Versuche, deine Suche anders zu formulieren"
  /// - **es**: "Intenta reformular tu búsqueda"
  /// - **fr**: "Essayez de reformuler votre recherche"
  /// - **ja**: "検索キーワードを変更してみてください"
  public static func Try_rephrasing_your_search() -> String {
    return localizedString(
      key: "Try_rephrasing_your_search",
      defaultValue: "Try rephrasing your search",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Twice a day summary"
  ///
  /// - **en**: "Twice a day summary"
  /// - **de**: "Übersicht (zweimal täglich)"
  /// - **es**: "Resumen dos veces al día"
  /// - **fr**: "Deux fois par jour"
  /// - **ja**: "1日2回の概要"
  public static func Twice_a_day_summary() -> String {
    return localizedString(
      key: "Twice_a_day_summary",
      defaultValue: "Twice a day summary",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unable to request data."
  ///
  /// - **en**: "Unable to request data."
  /// - **de**: "Daten konnten nicht angefordert werden."
  /// - **es**: "No se pueden solicitar datos."
  /// - **fr**: "Demande de données impossible."
  /// - **ja**: "データをリクエストできません。"
  public static func Unable_to_request() -> String {
    return localizedString(
      key: "Unable_to_request",
      defaultValue: "Unable to request data.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsaved"
  ///
  /// - **en**: "Unsaved"
  /// - **de**: "Speichern wurde rückgängig gemacht"
  /// - **es**: "Sin guardar"
  /// - **fr**: "Non enregistré"
  /// - **ja**: "未保存"
  public static func Unsaved() -> String {
    return localizedString(
      key: "Unsaved",
      defaultValue: "Unsaved",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsaves project."
  ///
  /// - **en**: "Unsaves project."
  /// - **de**: "Macht Speichern dieses Projektes rückgängig."
  /// - **es**: "Deshacer "guardar proyecto"."
  /// - **fr**: "Annule l'enregistrement du projet."
  /// - **ja**: "保存されていないプロジェクト。"
  public static func Unsaves_project() -> String {
    return localizedString(
      key: "Unsaves_project",
      defaultValue: "Unsaves project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsubscribe"
  ///
  /// - **en**: "Unsubscribe"
  /// - **de**: "Abo abbestellen"
  /// - **es**: "Anular suscripción"
  /// - **fr**: "Se désabonner"
  /// - **ja**: "購読キャンセル済み"
  public static func Unsubscribe() -> String {
    return localizedString(
      key: "Unsubscribe",
      defaultValue: "Unsubscribe",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsubscribes from upcoming live streams."
  ///
  /// - **en**: "Unsubscribes from upcoming live streams."
  /// - **de**: "Abo für zukünftige Live-Streams abbestellen."
  /// - **es**: "Desactiva subscripción a futuros Live-Streams."
  /// - **fr**: "Désabonnement des diffusions en direct à venir."
  /// - **ja**: "ライブ配信の購読を停止"
  public static func Unsubscribes_from_upcoming_lives_streams() -> String {
    return localizedString(
      key: "Unsubscribes_from_upcoming_lives_streams",
      defaultValue: "Unsubscribes from upcoming live streams.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Unsuccessfully Funded."
  ///
  /// - **en**: "Unsuccessfully Funded."
  /// - **de**: "Finanzierung fehlgeschlagen."
  /// - **es**: "Financiación falló."
  /// - **fr**: "Non financé."
  /// - **ja**: "資金調達失敗"
  public static func Unsuccessfully_Funded() -> String {
    return localizedString(
      key: "Unsuccessfully_Funded",
      defaultValue: "Unsuccessfully Funded.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Upcoming live stream"
  ///
  /// - **en**: "Upcoming live stream"
  /// - **de**: "Nächster Live-Stream"
  /// - **es**: "Futuro Live-Stream"
  /// - **fr**: "Diffusion en direct à venir"
  /// - **ja**: "ライブ配信が開始します"
  public static func Upcoming_live_stream() -> String {
    return localizedString(
      key: "Upcoming_live_stream",
      defaultValue: "Upcoming live stream",
      count: nil,
      substitutions: [:]
    )
  }
}
