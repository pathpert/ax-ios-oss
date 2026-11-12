// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Refunded"
  ///
  /// - **en**: "Refunded"
  /// - **de**: "Beitrag rückerstattet"
  /// - **es**: "Reembolso emitido"
  /// - **fr**: "Remboursé"
  /// - **ja**: "払い戻し"
  public static func Refunded() -> String {
    return localizedString(
      key: "Refunded",
      defaultValue: "Refunded",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Replay"
  ///
  /// - **en**: "Replay"
  /// - **de**: "Wiedergabe"
  /// - **es**: "Repetición"
  /// - **fr**: "Rediffuser"
  /// - **ja**: "リプレイ"
  public static func Replay() -> String {
    return localizedString(
      key: "Replay",
      defaultValue: "Replay",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Replay available for %{time} more %{units}"
  ///
  /// - **en**: "Replay available for %{time} more %{units}"
  /// - **de**: "Wiedergabe verfügbar für weitere %{time} %{units}"
  /// - **es**: "Repetición disponible por %{time} %{units} más"
  /// - **fr**: "Rediffusion encore disponible pendant %{time} %{units}"
  /// - **ja**: "あと%{time}%{units} リプレイ可能"
  public static func Replay_available_for_time_more_units(time: String, units: String) -> String {
    return localizedString(
      key: "Replay_available_for_time_more_units",
      defaultValue: "Replay available for %{time} more %{units}",
      count: nil,
      substitutions: ["time": time, "units": units]
    )
  }
  /// "Replay past live stream"
  ///
  /// - **en**: "Replay past live stream"
  /// - **de**: "Wiedergabe des vorigen Live-Streams"
  /// - **es**: "Repetir live stream pasado"
  /// - **fr**: "Rediffusion"
  /// - **ja**: "過去のライブ配信をリプレイ"
  public static func Replay_past_live_stream() -> String {
    return localizedString(
      key: "Replay_past_live_stream",
      defaultValue: "Replay past live stream",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Replay past live streams"
  ///
  /// - **en**: "Replay past live streams"
  /// - **de**: "Wiedergabe vergangener Live-Streams"
  /// - **es**: "Repetir live streams pasados"
  /// - **fr**: "Revoir des diffusions en direct passées"
  /// - **ja**: "過去のライブ配信をリプレイ"
  public static func Replay_past_live_streams() -> String {
    return localizedString(
      key: "Replay_past_live_streams",
      defaultValue: "Replay past live streams",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Replies"
  ///
  /// - **en**: "Replies"
  /// - **de**: "Antworten"
  /// - **es**: "Respuestas"
  /// - **fr**: "Réponses"
  /// - **ja**: "返信"
  public static func Replies() -> String {
    return localizedString(
      key: "Replies",
      defaultValue: "Replies",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Report spam or abusive behavior"
  ///
  /// - **en**: "Report spam or abusive behavior"
  /// - **de**: "Spam oder missbräuchliches Verhalten melden"
  /// - **es**: "Denunciar correo no deseado o comportamiento abusivo"
  /// - **fr**: "Spam ou comportement abusif"
  /// - **ja**: "スパムまたは不正行為を報告する"
  public static func Report_spam() -> String {
    return localizedString(
      key: "Report_spam",
      defaultValue: "Report spam or abusive behavior",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Report this project"
  ///
  /// - **en**: "Report this project"
  /// - **de**: "Dieses Projekt melden"
  /// - **es**: "Denunciar este proyecto"
  /// - **fr**: "Signaler ce projet"
  /// - **ja**: "このプロジェクトを報告する"
  public static func Report_this_project() -> String {
    return localizedString(
      key: "Report_this_project",
      defaultValue: "Report this project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Request my data"
  ///
  /// - **en**: "Request my data"
  /// - **de**: "Meine Daten anfordern"
  /// - **es**: "Solicitar mis datos"
  /// - **fr**: "Demander mes données"
  /// - **ja**: "自分のデータをリクエストする"
  public static func Request_my_data() -> String {
    return localizedString(
      key: "Request_my_data",
      defaultValue: "Request my data",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Request my personal data"
  ///
  /// - **en**: "Request my personal data"
  /// - **de**: "Meine persönlichen Daten anfordern"
  /// - **es**: "Solicitar mis datos personales"
  /// - **fr**: "Demander mes données personnelles"
  /// - **ja**: "自分の個人データをリクエストする"
  public static func Request_my_personal_data() -> String {
    return localizedString(
      key: "Request_my_personal_data",
      defaultValue: "Request my personal data",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Resend email"
  ///
  /// - **en**: "Resend email"
  /// - **de**: "Erneut senden"
  /// - **es**: "Reenviar correo"
  /// - **fr**: "Renvoyer"
  /// - **ja**: "メールを再送"
  public static func Resend_email() -> String {
    return localizedString(
      key: "Resend_email",
      defaultValue: "Resend email",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Re-send verification email"
  ///
  /// - **en**: "Re-send verification email"
  /// - **de**: "Verifizierungs-E-Mail erneut senden"
  /// - **es**: "Volver a enviar correo electrónico de verificación"
  /// - **fr**: "Renvoyer l'e-mail de vérification"
  /// - **ja**: "認証メールをもう一度送信"
  public static func Resend_verification_email() -> String {
    return localizedString(
      key: "Resend_verification_email",
      defaultValue: "Re-send verification email",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Retry"
  ///
  /// - **en**: "Retry"
  /// - **de**: "Erneut versuchen"
  /// - **es**: "Volver a intentar"
  /// - **fr**: "Réessayer"
  /// - **ja**: "もう一度試す"
  public static func Retry() -> String {
    return localizedString(
      key: "Retry",
      defaultValue: "Retry",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Retry or select another method."
  ///
  /// - **en**: "Retry or select another method."
  /// - **de**: "Versuche es erneut oder wähle eine andere Karte."
  /// - **es**: "Vuelve a intentarlo o selecciona otro método."
  /// - **fr**: "Veuillez réessayer ou choisir un autre moyen de paiement."
  /// - **ja**: "再試行するか別のお支払い方法を選択してください。"
  public static func Retry_or_select_another_method() -> String {
    return localizedString(
      key: "Retry_or_select_another_method",
      defaultValue: "Retry or select another method.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reusability and recyclability"
  ///
  /// - **en**: "Reusability and recyclability"
  /// - **de**: "Wiederverwertung und Recyclingfähigkeit"
  /// - **es**: "Reutilización y reciclabilidad"
  /// - **fr**: "Recyclage et valorisation des déchets"
  /// - **ja**: "再利用可能性とリサイクル可能性"
  public static func Reusability_and_recyclability() -> String {
    return localizedString(
      key: "Reusability_and_recyclability",
      defaultValue: "Reusability and recyclability",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Review edits made to your order"
  ///
  /// - **en**: "Review edits made to your order"
  /// - **de**: "Änderungen an deiner Bestellung prüfen"
  /// - **es**: "Revisa las modificaciones realizadas en tu pedido"
  /// - **fr**: "Vérifions les modifications apportées à votre commande"
  /// - **ja**: "ご注文への編集内容を確認してください"
  public static func Review_edits_made_to_your_order() -> String {
    return localizedString(
      key: "Review_edits_made_to_your_order",
      defaultValue: "Review edits made to your order",
      count: nil,
      substitutions: [:]
    )
  }
}
