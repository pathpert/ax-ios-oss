// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Bonus support"
  ///
  /// - **en**: "Bonus support"
  /// - **de**: "Bonus-Unterstützung"
  /// - **es**: "Apoyo extra"
  /// - **fr**: "Coup de pouce"
  /// - **ja**: "ボーナスサポート"
  public static func Bonus_support() -> String {
    return localizedString(
      key: "Bonus_support",
      defaultValue: "Bonus support",
      count: nil,
      substitutions: [:]
    )
  }
  /// "By submitting your pledge, you agree that our payment processor, Stripe, may charge your payment method."
  ///
  /// - **en**: "By submitting your pledge, you agree that our payment processor, Stripe, may charge your payment method."
  /// - **de**: "Durch das Einsenden deines Finanzierungsbeitrags erklärst du dich mit einer Abbuchung von deiner Zahlungsweise durch unseren Zahlungsdienstleister Stripe einverstanden."
  /// - **es**: "Si envías tu contribución, aceptas que Stripe, nuestro proveedor de procesamiento de pagos, te cobre a tu método de pago."
  /// - **fr**: "En vous engageant, vous acceptez que Stripe, notre prestataire de traitement des règlements, débite votre moyen de paiement."
  /// - **ja**: "プレッジを送信することで、Kickstarter の決済サービスプロバイダー、Stripe がご利用のお支払い方法へ請求を行うことに同意するものとみなされます。"
  public static func By_submitting_your_pledge_you_agree_that_Stripe_may_charge_your_payment_method() -> String {
    return localizedString(
      key: "By_submitting_your_pledge_you_agree_that_Stripe_may_charge_your_payment_method",
      defaultValue: "By submitting your pledge, you agree that our payment processor, Stripe, may charge your payment method.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cancel pledge"
  ///
  /// - **en**: "Cancel pledge"
  /// - **de**: "Beitrag zurückziehen"
  /// - **es**: "Cancelar contribución"
  /// - **fr**: "Annuler mon engagement"
  /// - **ja**: "プレッジを取り消す"
  public static func Cancel_pledge() -> String {
    return localizedString(
      key: "Cancel_pledge",
      defaultValue: "Cancel pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cancel your pledge"
  ///
  /// - **en**: "Cancel your pledge"
  /// - **de**: "Deinen Beitrag zurückziehen"
  /// - **es**: "Cancela tu contribución"
  /// - **fr**: "Annuler mon engagement"
  /// - **ja**: "プレッジを取り消す"
  public static func Cancel_your_pledge() -> String {
    return localizedString(
      key: "Cancel_your_pledge",
      defaultValue: "Cancel your pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Card ending in %{last_four}"
  ///
  /// - **en**: "Card ending in %{last_four}"
  /// - **de**: "Kartennummer endet auf %{last_four}"
  /// - **es**: "Tarjeta que termina en %{last_four}"
  /// - **fr**: "Numéro de carte se terminant par : %{last_four}"
  /// - **ja**: "下4桁が %{last_four} のカード"
  public static func Card_ending_in_last_four(last_four: String) -> String {
    return localizedString(
      key: "Card_ending_in_last_four",
      defaultValue: "Card ending in %{last_four}",
      count: nil,
      substitutions: ["last_four": last_four]
    )
  }
  /// "Card number"
  ///
  /// - **en**: "Card number"
  /// - **de**: "Kartennummer"
  /// - **es**: "Número de tarjeta"
  /// - **fr**: "N° de carte"
  /// - **ja**: "カード番号"
  public static func Card_number() -> String {
    return localizedString(
      key: "Card_number",
      defaultValue: "Card number",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cardholder name"
  ///
  /// - **en**: "Cardholder name"
  /// - **de**: "Name des Karteninhabers"
  /// - **es**: "Nombre del titular de la tarjeta"
  /// - **fr**: "Nom du titulaire"
  /// - **ja**: "カード名義"
  public static func Cardholder_name() -> String {
    return localizedString(
      key: "Cardholder_name",
      defaultValue: "Cardholder name",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Change payment method"
  ///
  /// - **en**: "Change payment method"
  /// - **de**: "Zahlungsmethode ändern"
  /// - **es**: "Cambiar método de pago"
  /// - **fr**: "Changer de moyen de paiement"
  /// - **ja**: "支払方法の変更"
  public static func Change_payment_method() -> String {
    return localizedString(
      key: "Change_payment_method",
      defaultValue: "Change payment method",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Change your shipping location or skip add-ons to continue."
  ///
  /// - **en**: "Change your shipping location or skip add-ons to continue."
  /// - **de**: "Um fortzufahren, ändere dein Versandziel oder überspringe Add-ons."
  /// - **es**: "Cambia tu ubicación de envío u omite los complementos para continuar."
  /// - **fr**: "Changez de lieu de livraison ou ignorez les compléments pour continuer."
  /// - **ja**: "配送先を変更するか、アドオン (追加リワード) をスキップして続行してください。"
  public static func Change_your_shipping_location_or_skip_add_ons_to_continue() -> String {
    return localizedString(
      key: "Change_your_shipping_location_or_skip_add_ons_to_continue",
      defaultValue: "Change your shipping location or skip add-ons to continue.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "charged as %{number} payments"
  ///
  /// - **en**: "charged as %{number} payments"
  /// - **de**: "zahlbar in %{number} Raten"
  /// - **es**: "cobrado en %{number} pagos"
  /// - **fr**: "prélévé en %{number} fois"
  /// - **ja**: "%{number}回に分けて請求"
  public static func Charged_as_number_of_payments(number: String) -> String {
    return localizedString(
      key: "Charged_as_number_of_payments",
      defaultValue: "charged as %{number} payments",
      count: nil,
      substitutions: ["number": number]
    )
  }
  /// "Check your payment details"
  ///
  /// - **en**: "Check your payment details"
  /// - **de**: "Überprüfe die Daten deiner Zahlungsweise"
  /// - **es**: "Revisa tu información de pago"
  /// - **fr**: "Vérifiez vos coordonnées bancaires"
  /// - **ja**: "お支払い情報をご確認ください"
  public static func Check_your_payment_details() -> String {
    return localizedString(
      key: "Check_your_payment_details",
      defaultValue: "Check your payment details",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Checkout"
  ///
  /// - **en**: "Checkout"
  /// - **de**: "Kasse"
  /// - **es**: "Pago"
  /// - **fr**: "Règlement"
  /// - **ja**: "チェックアウト"
  public static func Checkout() -> String {
    return localizedString(
      key: "Checkout",
      defaultValue: "Checkout",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Choose another reward"
  ///
  /// - **en**: "Choose another reward"
  /// - **de**: "Andere Belohnung auswählen"
  /// - **es**: "Elegir otra recompensa"
  /// - **fr**: "Choisir une autre récompense"
  /// - **ja**: "他のリワードを選択"
  public static func Choose_another_reward() -> String {
    return localizedString(
      key: "Choose_another_reward",
      defaultValue: "Choose another reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Chooses %{location} for shipping."
  ///
  /// - **en**: "Chooses %{location} for shipping."
  /// - **de**: "Legt %{location} als Versandort fest."
  /// - **es**: "Destino determinado: %{location}."
  /// - **fr**: "Sélectionne %{location} pour la livraison."
  /// - **ja**: "配送先%{location} を選択"
  public static func Chooses_location_for_shipping(location: String) -> String {
    return localizedString(
      key: "Chooses_location_for_shipping",
      defaultValue: "Chooses %{location} for shipping.",
      count: nil,
      substitutions: ["location": location]
    )
  }
  /// "Complete payment"
  ///
  /// - **en**: "Complete payment"
  /// - **de**: "Zahlung abschließen"
  /// - **es**: "Completar pago"
  /// - **fr**: "Payer"
  /// - **ja**: "支払いを完了"
  public static func Complete_payment() -> String {
    return localizedString(
      key: "Complete_payment",
      defaultValue: "Complete payment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Confirm your pledge details"
  ///
  /// - **en**: "Confirm your pledge details"
  /// - **de**: "Bestätige die Details zu deinem Finanzierungsbeitrag"
  /// - **es**: "Confirma los datos de tu contribución"
  /// - **fr**: "Confirmons le détail de votre engagement"
  /// - **ja**: "プレッジの詳細を確認"
  public static func Confirm_your_pledge_details() -> String {
    return localizedString(
      key: "Confirm_your_pledge_details",
      defaultValue: "Confirm your pledge details",
      count: nil,
      substitutions: [:]
    )
  }
}
