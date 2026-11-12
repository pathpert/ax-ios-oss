// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Your payment method will be <b>charged immediately</b> upon pledge. Your pledge <b>cannot be canceled or modified</b>."
  ///
  /// - **en**: "Your payment method will be <b>charged immediately</b> upon pledge. Your pledge <b>cannot be canceled or modified</b>."
  /// - **de**: "Deine Zahlungsmethode für den Finanzierungsbeitrag wird <b>umgehend belastet<b>. Dein Beitrag <b>kann nicht storniert oder geändert</b> werden."
  /// - **es**: "Al hacer la contribución, <b>se hará el cargo inmediatamente</b> a tu método de pago. Tu contribución <b>no puede cancelarse ni modificarse</b>."
  /// - **fr**: "Votre moyen de paiement sera <b>débité immédiatement</b>. Vous <b>ne pourrez pas modifier ni annuler</b> votre contribution."
  /// - **ja**: "お支払い方法にはプレッジ後<b>すぐに請求が行われます</b>。プレッジを<b>キャンセルまたは変更することはできません</b>。"
  public static func Your_payment_method_will_be_charged() -> String {
    return localizedString(
      key: "Your_payment_method_will_be_charged",
      defaultValue: "Your payment method will be <b>charged immediately</b> upon pledge. Your pledge <b>cannot be canceled or modified</b>.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your payment method will be charged immediately upon pledge and you’ll receive a confirmation email at %{user_email}. Your pledge cannot be canceled or modified."
  ///
  /// - **en**: "Your payment method will be charged immediately upon pledge and you’ll receive a confirmation email at %{user_email}. Your pledge cannot be canceled or modified."
  /// - **de**: "Deine Zahlungsmethode wird umgehend belastet und du erhältst eine Bestätigungs-E-Mail an %{user_email}. Dein Beitrag kann nicht storniert oder geändert werden."
  /// - **es**: "Al hacer la contribución, se hará el cargo inmediatamente a tu método de pago y recibirás un correo electrónico de confirmación en %{user_email}. Tu contribución no puede cancelarse ni modificarse."
  /// - **fr**: "La somme sera immédiatement prélevée sur votre moyen de paiement et vous recevrez une confirmation à l'adresse %{user_email}. Cet engagement ne pourra être ni annulé, ni modifié."
  /// - **ja**: "お支払い方法にはプレッジ時にただちに請求が行われ、その確認メールが %{user_email} 宛てに送られます。プレッジをキャンセルまたは変更することはできません。"
  public static func Your_payment_method_will_be_charged_immediately(user_email: String) -> String {
    return localizedString(
      key: "Your_payment_method_will_be_charged_immediately",
      defaultValue: "Your payment method will be charged immediately upon pledge and you’ll receive a confirmation email at %{user_email}. Your pledge cannot be canceled or modified.",
      count: nil,
      substitutions: ["user_email": user_email]
    )
  }
  /// "Your pledge"
  ///
  /// - **en**: "Your pledge"
  /// - **de**: "Dein Beitrag"
  /// - **es**: "Tu contribución"
  /// - **fr**: "Mon engagement"
  /// - **ja**: "プレッジ"
  public static func Your_pledge() -> String {
    return localizedString(
      key: "Your_pledge",
      defaultValue: "Your pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your pledge amount"
  ///
  /// - **en**: "Your pledge amount"
  /// - **de**: "Dein Beitrag:"
  /// - **es**: "Monto de tu contribución:"
  /// - **fr**: "Montant engagé :"
  /// - **ja**: "プレッジ額："
  public static func Your_pledge_amount() -> String {
    return localizedString(
      key: "Your_pledge_amount",
      defaultValue: "Your pledge amount",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your pledge details"
  ///
  /// - **en**: "Your pledge details"
  /// - **de**: "Einzelheiten deines Beitrags"
  /// - **es**: "Los detalles de tu contribución"
  /// - **fr**: "Votre engagement"
  /// - **ja**: "プレッジの詳細"
  public static func Your_pledge_details() -> String {
    return localizedString(
      key: "Your_pledge_details",
      defaultValue: "Your pledge details",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your pledge was canceled or the creator canceled the project before its deadline."
  ///
  /// - **en**: "Your pledge was canceled or the creator canceled the project before its deadline."
  /// - **de**: "Entweder dein Finanzierungsbeitrag wurde zurückgezogen oder das Projekt abgebrochen, bevor die Frist erreicht wurde."
  /// - **es**: "El patrocinador canceló la contribución o el creador canceló el proyecto antes de que éste llegara al plazo estipulado."
  /// - **fr**: "Votre engagement a été annulé ou le créateur a annulé son projet avant la date limite."
  /// - **ja**: "プレッジが取消されたか、クリエイターが締切前にプロジェクトを取消しました。"
  public static func Your_pledge_was_canceled_or_the_creator_canceled() -> String {
    return localizedString(
      key: "Your_pledge_was_canceled_or_the_creator_canceled",
      defaultValue: "Your pledge was canceled or the creator canceled the project before its deadline.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your pledge was dropped."
  ///
  /// - **en**: "Your pledge was dropped."
  /// - **de**: "Dein Finanzierungsbeitrag wurde nicht übernommen."
  /// - **es**: "Tu Contribución fue descartada."
  /// - **fr**: "Votre engagement a été abandonné."
  /// - **ja**: "プレッジの取消済。"
  public static func Your_pledge_was_dropped() -> String {
    return localizedString(
      key: "Your_pledge_was_dropped",
      defaultValue: "Your pledge was dropped.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your pledge was dropped because of payment errors."
  ///
  /// - **en**: "Your pledge was dropped because of payment errors."
  /// - **de**: "Dein Finanzierungsbeitrag wurde aufgrund von Fehlern, die bei der Zahlung auftraten, nicht übernommen."
  /// - **es**: "Tu contribución no pudo ser cobrada por un error en el método de pago."
  /// - **fr**: "Votre engagement a été annulé en raison d'un échec de règlement."
  /// - **ja**: "支払関連のエラーにより、あなたのプレッジは取り消されました。"
  public static func Your_pledge_was_dropped_because_of_payment_errors() -> String {
    return localizedString(
      key: "Your_pledge_was_dropped_because_of_payment_errors",
      defaultValue: "Your pledge was dropped because of payment errors.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your project didn’t reach its funding goal, so the backer’s payment method was never charged."
  ///
  /// - **en**: "Your project didn’t reach its funding goal, so the backer’s payment method was never charged."
  /// - **de**: "Dein Projekt hat das Finanzierungsziel leider nicht erreicht. Daher wurde die Zahlungsmethode des Unterstützers nicht belastet."
  /// - **es**: "Tu proyecto no alcanzó su meta de financiamiento, así que no se realizó ningún cargo al método de pago del patrocinador."
  /// - **fr**: "L'objectif de financement de votre projet n'a pas été atteint, donc le moyen de paiement du contributeur n'a pas été débité."
  /// - **ja**: "あなたのプロジェクトはファンディングゴールに到達しなかったため、お支払い方法への請求は行われませんでした。"
  public static func Your_project_didnt_reach_its_funding_goal_so_the_backers_payment_method_was_never_charged() -> String {
    return localizedString(
      key: "Your_project_didnt_reach_its_funding_goal_so_the_backers_payment_method_was_never_charged",
      defaultValue: "Your project didn’t reach its funding goal, so the backer’s payment method was never charged.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your reward"
  ///
  /// - **en**: "Your reward"
  /// - **de**: "Deine Belohnung"
  /// - **es**: "Tu recompensa"
  /// - **fr**: "Votre récompense"
  /// - **ja**: "リワード"
  public static func Your_reward() -> String {
    return localizedString(
      key: "Your_reward",
      defaultValue: "Your reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>Your reward</b> estimated for delivery in %{delivery_date}"
  ///
  /// - **en**: "<b>Your reward</b> estimated for delivery in %{delivery_date}"
  /// - **de**: "<b>Deine Belohnung</b> wird voraussichtlich im %{delivery_date} geliefert"
  /// - **es**: "<b>Tu recompensa</b> estimada para entregarse en %{delivery_date}"
  /// - **fr**: "<b>Votre récompense</b> prévue pour %{delivery_date}"
  /// - **ja**: "<b>リワード</b>の配送予定日は%{delivery_date}"
  public static func Your_reward_estimated_for_delivery_in_date(delivery_date: String) -> String {
    return localizedString(
      key: "Your_reward_estimated_for_delivery_in_date",
      defaultValue: "<b>Your reward</b> estimated for delivery in %{delivery_date}",
      count: nil,
      substitutions: ["delivery_date": delivery_date]
    )
  }
  /// "Your reward has shipped!"
  ///
  /// - **en**: "Your reward has shipped!"
  /// - **de**: "Deine Belohnung wurde versendet!"
  /// - **es**: "¡Recompensa enviada!"
  /// - **fr**: "Votre récompense a été expédiée !"
  /// - **ja**: "リワードが発送されました！"
  public static func Your_reward_has_shipped() -> String {
    return localizedString(
      key: "Your_reward_has_shipped",
      defaultValue: "Your reward has shipped!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your shipping destination"
  ///
  /// - **en**: "Your shipping destination"
  /// - **de**: "Dein Versandziel"
  /// - **es**: "Tu destino de envío"
  /// - **fr**: "Destination d'expédition"
  /// - **ja**: "配送地域"
  public static func Your_shipping_destination() -> String {
    return localizedString(
      key: "Your_shipping_destination",
      defaultValue: "Your shipping destination",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your shipping location"
  ///
  /// - **en**: "Your shipping location"
  /// - **de**: "Dein Versand-Standort"
  /// - **es**: "Tu ubicación de envío"
  /// - **fr**: "Votre destination de livraison"
  /// - **ja**: "配送地域"
  public static func Your_shipping_location() -> String {
    return localizedString(
      key: "Your_shipping_location",
      defaultValue: "Your shipping location",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You've canceled your pledge."
  ///
  /// - **en**: "You've canceled your pledge."
  /// - **de**: "Dein Finanzierungsbeitrag wurde abgebrochen."
  /// - **es**: "Has cancelado tu contribución."
  /// - **fr**: "Vous avez annulé votre engagement."
  /// - **ja**: "プレッジをキャンセルしました。"
  public static func Youve_canceled_your_pledge() -> String {
    return localizedString(
      key: "Youve_canceled_your_pledge",
      defaultValue: "You've canceled your pledge.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You’ve canceled your pledge of <b>%{pledge_amount}</b> for <b>%{project_name}</b>."
  ///
  /// - **en**: "You’ve canceled your pledge of <b>%{pledge_amount}</b> for <b>%{project_name}</b>."
  /// - **de**: "Du hast den Finanzierungsbeitrag in Höhe von <b>%{pledge_amount}</b> für das Projekt <b>%{project_name}</b> zurückgezogen."
  /// - **es**: "Has cancelado tu contribución de <b>%{pledge_amount}</b> para el proyecto <b>%{project_name}</b>."
  /// - **fr**: "Vous avez annulé votre engagement de <b>%{pledge_amount}</b> pour le projet <b>%{project_name}</b>."
  /// - **ja**: "<b>%{project_name}</b> への <b>%{pledge_amount}</b> のプレッジを取り消しました。"
  public static func Youve_canceled_your_pledge_of_pledge_amount_for_project_name(pledge_amount: String, project_name: String) -> String {
    return localizedString(
      key: "Youve_canceled_your_pledge_of_pledge_amount_for_project_name",
      defaultValue: "You’ve canceled your pledge of <b>%{pledge_amount}</b> for <b>%{project_name}</b>.",
      count: nil,
      substitutions: ["pledge_amount": pledge_amount, "project_name": project_name]
    )
  }
}
