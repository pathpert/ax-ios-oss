// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Reward"
  ///
  /// - **en**: "Reward"
  /// - **de**: "Belohnung"
  /// - **es**: "Recompensa"
  /// - **fr**: "Récompense"
  /// - **ja**: "リワード"
  public static func backer_modal_reward_title() -> String {
    return localizedString(
      key: "backer_modal.reward_title",
      defaultValue: "Reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping"
  ///
  /// - **en**: "Shipping"
  /// - **de**: "Versand"
  /// - **es**: "Envío"
  /// - **fr**: "Expédition"
  /// - **ja**: "配送"
  public static func backer_modal_shipping_title() -> String {
    return localizedString(
      key: "backer_modal.shipping_title",
      defaultValue: "Shipping",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Status: %{backing_status}"
  ///
  /// - **en**: "Status: %{backing_status}"
  /// - **de**: "Status: %{backing_status}"
  /// - **es**: "Estado: %{backing_status}"
  /// - **fr**: "Statut : %{backing_status}"
  /// - **ja**: "ステータス：%{backing_status}"
  public static func backer_modal_status_backing_status(backing_status: String) -> String {
    return localizedString(
      key: "backer_modal.status_backing_status",
      defaultValue: "Status: %{backing_status}",
      count: nil,
      substitutions: ["backing_status": backing_status]
    )
  }
  /// "Estimated delivery %{delivery_date}"
  ///
  /// - **en**: "Estimated delivery %{delivery_date}"
  /// - **de**: "Voraussichtliche Lieferung am %{delivery_date}"
  /// - **es**: "Entrega estimada %{delivery_date}"
  /// - **fr**: "Livraison prévue le %{delivery_date}"
  /// - **ja**: "配達予定日%{delivery_date}"
  public static func backing_info_estimated_delivery_date(delivery_date: String) -> String {
    return localizedString(
      key: "backing_info.estimated_delivery_date",
      defaultValue: "Estimated delivery %{delivery_date}",
      count: nil,
      substitutions: ["delivery_date": delivery_date]
    )
  }
  /// "Backing info"
  ///
  /// - **en**: "Backing info"
  /// - **de**: "Infos zur Unterstützung"
  /// - **es**: "Info sobre patrocinamiento"
  /// - **fr**: "Infos sur la contribution"
  /// - **ja**: "バッカー情報"
  public static func backing_info_info_button() -> String {
    return localizedString(
      key: "backing_info.info_button",
      defaultValue: "Backing info",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledged: %{backing_amount}"
  ///
  /// - **en**: "Pledged: %{backing_amount}"
  /// - **de**: "Beigetragen: %{backing_amount}"
  /// - **es**: "Contribuido: %{backing_amount}"
  /// - **fr**: "Montant engagé : %{backing_amount}"
  /// - **ja**: "プレッジ：%{backing_amount}"
  public static func backing_info_pledged_backing_amount(backing_amount: String) -> String {
    return localizedString(
      key: "backing_info.pledged_backing_amount",
      defaultValue: "Pledged: %{backing_amount}",
      count: nil,
      substitutions: ["backing_amount": backing_amount]
    )
  }
  /// "<b>%{pledge_amount}</b> pledged on %{pledge_date}"
  ///
  /// - **en**: "<b>%{pledge_amount}</b> pledged on %{pledge_date}"
  /// - **de**: "<b>%{pledge_amount}</b> beigetragen am %{pledge_date}"
  /// - **es**: "<b>%{pledge_amount}</b> contribuidos el %{pledge_date}"
  /// - **fr**: "<b>%{pledge_amount}</b> engagés le %{pledge_date}"
  /// - **ja**: "%{pledge_date} に<b>%{pledge_amount}</b>のプレッジをしました"
  public static func pledge_amount_pledged_on_pledge_date(pledge_amount: String, pledge_date: String) -> String {
    return localizedString(
      key: "pledge_amount_pledged_on_pledge_date",
      defaultValue: "<b>%{pledge_amount}</b> pledged on %{pledge_date}",
      count: nil,
      substitutions: ["pledge_amount": pledge_amount, "pledge_date": pledge_date]
    )
  }
  /// "+%{shipping_cost}"
  ///
  /// - **en**: "+%{shipping_cost}"
  /// - **de**: "+%{shipping_cost}"
  /// - **es**: "+%{shipping_cost}"
  /// - **fr**: "+ %{shipping_cost}"
  /// - **ja**: "+%{shipping_cost}"
  public static func plus_shipping_cost(shipping_cost: String) -> String {
    return localizedString(
      key: "plus_shipping_cost",
      defaultValue: "+%{shipping_cost}",
      count: nil,
      substitutions: ["shipping_cost": shipping_cost]
    )
  }
  /// "New pledges"
  ///
  /// - **en**: "New pledges"
  /// - **de**: "Neue Beiträge"
  /// - **es**: "Nuevas contribuciones"
  /// - **fr**: "Nouveaux engagements"
  /// - **ja**: "Newプレッジ"
  public static func profile_settings_creator_pledges() -> String {
    return localizedString(
      key: "profile.settings.creator.pledges",
      defaultValue: "New pledges",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>Questions?</b> Read the <u>backer 101</u>."
  ///
  /// - **en**: "<b>Questions?</b> Read the <u>backer 101</u>."
  /// - **de**: "<b>Fragen?</b> Einfach im <u>Unterstützer-Einmaleins</u> nachlesen!"
  /// - **es**: "<b>¿Preguntas?</b> Encontrarás respuestas en el <u>manual básico del patrocinador</u>."
  /// - **fr**: "<b>Des questions ?</b> Lisez la section <u>Notions de base</u>."
  /// - **ja**: "<b>質問がありますか？</b><u>backer 101</u>をお読みください。"
  public static func project_checkout_android_pay_backer_101() -> String {
    return localizedString(
      key: "project.checkout.android_pay.backer_101",
      defaultValue: "<b>Questions?</b> Read the <u>backer 101</u>.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Change"
  ///
  /// - **en**: "Change"
  /// - **de**: "Ändern"
  /// - **es**: "Cambiar"
  /// - **fr**: "Modifier"
  /// - **ja**: "変更"
  public static func project_checkout_android_pay_change() -> String {
    return localizedString(
      key: "project.checkout.android_pay.change",
      defaultValue: "Change",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Confirm"
  ///
  /// - **en**: "Confirm"
  /// - **de**: "Bestätigen"
  /// - **es**: "Confirmar"
  /// - **fr**: "Confirmer"
  /// - **ja**: "確定する"
  public static func project_checkout_android_pay_confirm() -> String {
    return localizedString(
      key: "project.checkout.android_pay.confirm",
      defaultValue: "Confirm",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We’re sorry but we are unable to process your Android Pay request right now. Please try again."
  ///
  /// - **en**: "We’re sorry but we are unable to process your Android Pay request right now. Please try again."
  /// - **de**: "Der Zahlvorgang mit Android Pay kann im Moment leider nicht bearbeitet werden. Bitte erneut versuchen."
  /// - **es**: "Lamentamos no poder procesar el pago con Android Pay en estos momentos. Por favor inténtalo de nuevo."
  /// - **fr**: "Nous sommes désolés, mais nous ne sommes pas en mesure de traiter votre demande Android Pay pour le moment. Veuillez réessayer ultérieurement."
  /// - **ja**: "申し訳ございませんが、Android Payでの処理ができませんでした。もう一度お試しください。"
  public static func project_checkout_android_pay_error_message() -> String {
    return localizedString(
      key: "project.checkout.android_pay.error.message",
      defaultValue: "We’re sorry but we are unable to process your Android Pay request right now. Please try again.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Android Pay error"
  ///
  /// - **en**: "Android Pay error"
  /// - **de**: "Fehler bei Android Pay aufgetreten"
  /// - **es**: "Error de Android Pay"
  /// - **fr**: "Erreur Android Pay"
  /// - **ja**: "Androidpayエラー"
  public static func project_checkout_android_pay_error_title() -> String {
    return localizedString(
      key: "project.checkout.android_pay.error.title",
      defaultValue: "Android Pay error",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Payment Method"
  ///
  /// - **en**: "Payment Method"
  /// - **de**: "Zahlungmethode"
  /// - **es**: "Método de pago"
  /// - **fr**: "Moyen de paiement"
  /// - **ja**: "支払方法"
  public static func project_checkout_android_pay_payment_method() -> String {
    return localizedString(
      key: "project.checkout.android_pay.payment_method",
      defaultValue: "Payment Method",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your payment method will not be charged at this time. If the project is successfully funded, your card will be charged %{charge_amount} when the project ends."
  ///
  /// - **en**: "Your payment method will not be charged at this time. If the project is successfully funded, your card will be charged %{charge_amount} when the project ends."
  /// - **de**: "Deine Zahlungsmethode wird jetzt noch nicht belastet. Erst nachdem das Projekt erfolgreich finanziert wurde, wird sie nach Ablauf desselben mit %{charge_amount} belastet."
  /// - **es**: "Todavía no se le hará ningún cargo a tu método de pago. Se efectuará un cargo de %{charge_amount} una vez que el proyecto haya sido financiado exitosamente."
  /// - **fr**: "Votre moyen de paiement ne sera pas débité tout de suite. Si le projet est intégralement financé, votre carte sera débitée de %{charge_amount} en fin de campagne."
  /// - **ja**: "現時点で請求が発生することはありません。このプロジェクトが達成した場合のみ、カードに %{charge_amount} が請求されます。"
  public static func project_checkout_android_pay_pledge_disclaimer(charge_amount: String) -> String {
    return localizedString(
      key: "project.checkout.android_pay.pledge_disclaimer",
      defaultValue: "Your payment method will not be charged at this time. If the project is successfully funded, your card will be charged %{charge_amount} when the project ends.",
      count: nil,
      substitutions: ["charge_amount": charge_amount]
    )
  }
}
