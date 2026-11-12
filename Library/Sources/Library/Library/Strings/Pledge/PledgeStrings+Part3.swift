// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Continue to payment"
  ///
  /// - **en**: "Continue to payment"
  /// - **de**: "Weiter zur Zahlung"
  /// - **es**: "Continuar a pago"
  /// - **fr**: "Continuer vers le paiement"
  /// - **ja**: "支払いを続ける"
  public static func Continue_to_payment() -> String {
    return localizedString(
      key: "Continue_to_payment",
      defaultValue: "Continue to payment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Continue to update pledge"
  ///
  /// - **en**: "Continue to update pledge"
  /// - **de**: "Weiter zu Beitrag aktualisieren"
  /// - **es**: "Continuar a Actualizar contribución"
  /// - **fr**: "Continuer la modification de mon engagement"
  /// - **ja**: "プレッジの更新へ"
  public static func Continue_to_update_pledge() -> String {
    return localizedString(
      key: "Continue_to_update_pledge",
      defaultValue: "Continue to update pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Continue with %{quantity_count} add-on"
  ///
  /// - **en**: "Continue with %{quantity_count} add-on"
  /// - **de**: "Weiter mit %{quantity_count} Add-on"
  /// - **es**: "Continuar con %{quantity_count} complemento"
  /// - **fr**: "Continuer avec %{quantity_count} complément"
  /// - **ja**: "%{quantity_count} 個のアドオンで続行する"
  public static func Continue_with_quantity_count_add_ons(quantity_count: Int) -> String {
    return localizedString(
      key: "Continue_with_quantity_count_add_ons",
      defaultValue: "Continue with %{quantity_count} add-on",
      count: quantity_count,
      substitutions: ["quantity_count": Format.wholeNumber(quantity_count)]
    )
  }
  /// "Continue with %{quantity_count} add-ons"
  ///
  /// - **en**: "Continue with %{quantity_count} add-ons"
  /// - **de**: "Weiter mit %{quantity_count} Add-ons"
  /// - **es**: "Continuar con %{quantity_count} complementos"
  /// - **fr**: "Continuer avec %{quantity_count} compléments"
  /// - **ja**: "%{quantity_count} 個のアドオンで続行する"
  public static func Continue_with_quantity_count_add_ons_other(quantity_count: String) -> String {
    return localizedString(
      key: "Continue_with_quantity_count_add_ons.other",
      defaultValue: "Continue with %{quantity_count} add-ons",
      count: nil,
      substitutions: ["quantity_count": quantity_count]
    )
  }
  /// "Continue with this reward?"
  ///
  /// - **en**: "Continue with this reward?"
  /// - **de**: "Weiter mit dieser Belohnung?"
  /// - **es**: "¿Continuar con esta recompensa?"
  /// - **fr**: "Continuer avec cette récompense ?"
  /// - **ja**: "このリワードで続けますか？"
  public static func Continue_with_this_reward() -> String {
    return localizedString(
      key: "Continue_with_this_reward",
      defaultValue: "Continue with this reward?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>%{creator_name}</b> needs some information to deliver your reward for <b>%{project_name}</b>."
  ///
  /// - **en**: "<b>%{creator_name}</b> needs some information to deliver your reward for <b>%{project_name}</b>."
  /// - **de**: "<b>%{creator_name}</b> benötigt einige Angaben, um dir deine Belohnung für <b>%{project_name}</b> zustellen zu können."
  /// - **es**: "<b>%{creator_name}</b> necesita un par de datos para entregarte tu recompensa de <b>%{project_name}</b>."
  /// - **fr**: "<b>%{creator_name}</b> a besoin de quelques informations pour vous envoyer votre récompense pour le projet <b>%{project_name}</b>."
  /// - **ja**: "<b>%{project_name}</b>のリワード発送のため、<b>%{creator_name}</b>が情報を求めています。"
  public static func Creator_name_needs_some_information_to_deliver_your_reward_for_project_name(creator_name: String, project_name: String) -> String {
    return localizedString(
      key: "Creator_name_needs_some_information_to_deliver_your_reward_for_project_name",
      defaultValue: "<b>%{creator_name}</b> needs some information to deliver your reward for <b>%{project_name}</b>.",
      count: nil,
      substitutions: ["creator_name": creator_name, "project_name": project_name]
    )
  }
  /// "Expires %{expiration_date}"
  ///
  /// - **en**: "Expires %{expiration_date}"
  /// - **de**: "Ablaufdatum: %{expiration_date}"
  /// - **es**: "Caduca %{expiration_date}"
  /// - **fr**: "Expiration : %{expiration_date}"
  /// - **ja**: "有効期限 %{expiration_date}"
  public static func Credit_card_expiration(expiration_date: String) -> String {
    return localizedString(
      key: "Credit_card_expiration",
      defaultValue: "Expires %{expiration_date}",
      count: nil,
      substitutions: ["expiration_date": expiration_date]
    )
  }
  /// "Customize your reward"
  ///
  /// - **en**: "Customize your reward"
  /// - **de**: "Belohnung anpassen"
  /// - **es**: "Personaliza tu recompensa"
  /// - **fr**: "Personnalisons votre récompense"
  /// - **ja**: "リワードをカスタマイズ"
  public static func Customize_your_reward() -> String {
    return localizedString(
      key: "Customize_your_reward",
      defaultValue: "Customize your reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Customize your reward with optional add-ons."
  ///
  /// - **en**: "Customize your reward with optional add-ons."
  /// - **de**: "Personalisiere deine Belohnung mit optionalen Add-ons."
  /// - **es**: "Personaliza tu recompensa con complementos opcionales."
  /// - **fr**: "Personnalisez votre récompense avec des compléments."
  /// - **ja**: "オプションとしてアドオン (追加リワード) を追加しリワードをカスタマイズしましょう。"
  public static func Customize_your_reward_with_optional_addons() -> String {
    return localizedString(
      key: "Customize_your_reward_with_optional_addons",
      defaultValue: "Customize your reward with optional add-ons.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Decrease pledge"
  ///
  /// - **en**: "Decrease pledge"
  /// - **de**: "Finanzierungsbeitrag reduzieren"
  /// - **es**: "Reducir contribución"
  /// - **fr**: "Diminuer mon engagement"
  /// - **ja**: "プレッジ額を下げる"
  public static func Decrease_pledge() -> String {
    return localizedString(
      key: "Decrease_pledge",
      defaultValue: "Decrease pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Edit pledge"
  ///
  /// - **en**: "Edit pledge"
  /// - **de**: "Beitrag bearbeiten"
  /// - **es**: "Editar contribución"
  /// - **fr**: "Modifier mon engagement"
  /// - **ja**: "プレッジを編集する"
  public static func Edit_pledge() -> String {
    return localizedString(
      key: "Edit_pledge",
      defaultValue: "Edit pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Edit reward"
  ///
  /// - **en**: "Edit reward"
  /// - **de**: "Belohnung bearbeiten"
  /// - **es**: "Editar recompensa"
  /// - **fr**: "Modifier la récompense"
  /// - **ja**: "リワードを編集する"
  public static func Edit_reward() -> String {
    return localizedString(
      key: "Edit_reward",
      defaultValue: "Edit reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Either the pledge or the project was canceled before the deadline."
  ///
  /// - **en**: "Either the pledge or the project was canceled before the deadline."
  /// - **de**: "Entweder der Finanzierungsbeitrag wurde zurückgezogen oder das Projekt wurde abgebrochen, bevor die Frist abgelaufen war."
  /// - **es**: "Se canceló la contribución o el proyecto antes de que el plazo terminara."
  /// - **fr**: "Soit l'engagement soit le projet a été annulé avant la date limite."
  /// - **ja**: "プレッジもプロジェクトも期限前にキャンセル済"
  public static func Either_the_pledge_or_the_project_was_canceled() -> String {
    return localizedString(
      key: "Either_the_pledge_or_the_project_was_canceled",
      defaultValue: "Either the pledge or the project was canceled before the deadline.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Enter an amount less than %{max_pledge}."
  ///
  /// - **en**: "Enter an amount less than %{max_pledge}."
  /// - **de**: "Gib einen Betrag unter %{max_pledge} ein."
  /// - **es**: "Ingresa una cantidad inferior a %{max_pledge}."
  /// - **fr**: "Veuillez saisir un montant inférieur à %{max_pledge}."
  /// - **ja**: "%{max_pledge} 以下の額を入力してください。"
  public static func Enter_an_amount_less_than_max_pledge(max_pledge: String) -> String {
    return localizedString(
      key: "Enter_an_amount_less_than_max_pledge",
      defaultValue: "Enter an amount less than %{max_pledge}.",
      count: nil,
      substitutions: ["max_pledge": max_pledge]
    )
  }
  /// "Errored payment"
  ///
  /// - **en**: "Errored payment"
  /// - **de**: "Fehlerhafte Zahlung"
  /// - **es**: "Pago fallido"
  /// - **fr**: "Échec de règlement"
  /// - **ja**: "エラーが発生したお支払い"
  public static func Errored_payment() -> String {
    return localizedString(
      key: "Errored_payment",
      defaultValue: "Errored payment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Estimated Shipping"
  ///
  /// - **en**: "Estimated Shipping"
  /// - **de**: "Geschätzte Versandkosten"
  /// - **es**: "Costo de envío estimado"
  /// - **fr**: "Frais de port estimés"
  /// - **ja**: "推定送料"
  public static func Estimated_Shipping() -> String {
    return localizedString(
      key: "Estimated_Shipping",
      defaultValue: "Estimated Shipping",
      count: nil,
      substitutions: [:]
    )
  }
}
