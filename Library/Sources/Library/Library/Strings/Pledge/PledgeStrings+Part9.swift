// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Selected card"
  ///
  /// - **en**: "Selected card"
  /// - **de**: "Ausgewählte Karte"
  /// - **es**: "Tarjeta seleccionada"
  /// - **fr**: "Carte sélectionnée"
  /// - **ja**: "選択済みのカード"
  public static func Selected_card() -> String {
    return localizedString(
      key: "Selected_card",
      defaultValue: "Selected card",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Selected reward"
  ///
  /// - **en**: "Selected reward"
  /// - **de**: "Gewählte Belohnung"
  /// - **es**: "Recompensa seleccionada"
  /// - **fr**: "Récompense sélectionnée"
  /// - **ja**: "選択したリワード"
  public static func Selected_reward() -> String {
    return localizedString(
      key: "Selected_reward",
      defaultValue: "Selected reward",
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
  public static func Shipping() -> String {
    return localizedString(
      key: "Shipping",
      defaultValue: "Shipping",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping address"
  ///
  /// - **en**: "Shipping address"
  /// - **de**: "Versandanschrift"
  /// - **es**: "Dirección de envío"
  /// - **fr**: "Adresse de livraison"
  /// - **ja**: "配送先住所"
  public static func Shipping_address() -> String {
    return localizedString(
      key: "Shipping_address",
      defaultValue: "Shipping address",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping addresses"
  ///
  /// - **en**: "Shipping addresses"
  /// - **de**: "Versandanschrift"
  /// - **es**: "Direcciones de envío"
  /// - **fr**: "Adresses de livraison"
  /// - **ja**: "配送先住所"
  public static func Shipping_addresses() -> String {
    return localizedString(
      key: "Shipping_addresses",
      defaultValue: "Shipping addresses",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping destination"
  ///
  /// - **en**: "Shipping destination"
  /// - **de**: "Versandziel"
  /// - **es**: "Destino de envío"
  /// - **fr**: "Destination d'expédition"
  /// - **ja**: "配送地域"
  public static func Shipping_destination() -> String {
    return localizedString(
      key: "Shipping_destination",
      defaultValue: "Shipping destination",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping: %{country}"
  ///
  /// - **en**: "Shipping: %{country}"
  /// - **de**: "Versand: %{country}"
  /// - **es**: "Envío: %{country}"
  /// - **fr**: "Livraison : %{country}"
  /// - **ja**: "送料：%{country}"
  public static func Shipping_to_country(country: String) -> String {
    return localizedString(
      key: "Shipping_to_country",
      defaultValue: "Shipping: %{country}",
      count: nil,
      substitutions: ["country": country]
    )
  }
  /// "Ships to: %{shipping_summary}"
  ///
  /// - **en**: "Ships to: %{shipping_summary}"
  /// - **de**: "Versand nach: %{shipping_summary}"
  /// - **es**: "Países de envío: %{shipping_summary}"
  /// - **fr**: "Pays de livraison : %{shipping_summary}"
  /// - **ja**: "配送先: %{shipping_summary}"
  public static func Ships_to_shipping_summary(shipping_summary: String) -> String {
    return localizedString(
      key: "Ships_to_shipping_summary",
      defaultValue: "Ships to: %{shipping_summary}",
      count: nil,
      substitutions: ["shipping_summary": shipping_summary]
    )
  }
  /// "Skip add-ons"
  ///
  /// - **en**: "Skip add-ons"
  /// - **de**: "Keine Add-ons"
  /// - **es**: "Omitir complementos"
  /// - **fr**: "Passer les compléments"
  /// - **ja**: "アドオンをスキップする"
  public static func Skip_add_ons() -> String {
    return localizedString(
      key: "Skip_add_ons",
      defaultValue: "Skip add-ons",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Something went wrong and we were unable to remove your payment method, please try again."
  ///
  /// - **en**: "Something went wrong and we were unable to remove your payment method, please try again."
  /// - **de**: "Hier ist etwas schiefgelaufen, deine Zahlungsweise konnte leider nicht entfernt werden. Bitte versuche es noch einmal."
  /// - **es**: "Hubo un error y no pudimos eliminar tu método de pago. Inténtalo de nuevo."
  /// - **fr**: "Une erreur s'est produite et la suppression de votre moyen de payement a échoué. Veuillez réessayer."
  /// - **ja**: "何らかのエラーにより、お支払い方法を削除できませんでした。もう一度お試しください。"
  public static func Something_went_wrong_and_we_were_unable_to_remove_your_payment_method_please_try_again() -> String {
    return localizedString(
      key: "Something_went_wrong_and_we_were_unable_to_remove_your_payment_method_please_try_again",
      defaultValue: "Something went wrong and we were unable to remove your payment method, please try again.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Successfully funded backings"
  ///
  /// - **en**: "Successfully funded backings"
  /// - **de**: "Beiträge für erfolgreich finanzierte Projekte"
  /// - **es**: "Contribuciones a proyectos financiados con éxito"
  /// - **fr**: "Projets soutenus et intégralement financés"
  /// - **ja**: "ファンディング成立済みの支援"
  public static func Successfully_funded_backings() -> String {
    return localizedString(
      key: "Successfully_funded_backings",
      defaultValue: "Successfully funded backings",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The backer canceled their pledge for this project."
  ///
  /// - **en**: "The backer canceled their pledge for this project."
  /// - **de**: "Der Unterstützer hat den Finanzierungsbeitrag zurückgezogen."
  /// - **es**: "El patrocinador canceló su contribución a este proyecto."
  /// - **fr**: "Le contributeur a annulé son engagement."
  /// - **ja**: "バッカーがこのプロジェクトのプレッジをキャンセルしました。"
  public static func The_backer_canceled_their_pledge_for_this_project() -> String {
    return localizedString(
      key: "The_backer_canceled_their_pledge_for_this_project",
      defaultValue: "The backer canceled their pledge for this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The creator canceled this project, so your payment method was never charged."
  ///
  /// - **en**: "The creator canceled this project, so your payment method was never charged."
  /// - **de**: "Der Projektgründer hat das Projekt abgebrochen. Daher wurde deine Zahlungsmethode nicht belastet."
  /// - **es**: "El creador canceló el proyecto, así que tu método de pago nunca recibió ningún cargo."
  /// - **fr**: "Ce projet a été annulé par le créateur, donc votre moyen de paiement n'a pas été débité."
  /// - **ja**: "クリエイターがこのプロジェクトをキャンセルしたため、お支払い方法への請求は行われませんでした。"
  public static func The_creator_canceled_this_project_so_your_payment_method_was_never_charged() -> String {
    return localizedString(
      key: "The_creator_canceled_this_project_so_your_payment_method_was_never_charged",
      defaultValue: "The creator canceled this project, so your payment method was never charged.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The maximum pledge is %{max_pledge}."
  ///
  /// - **en**: "The maximum pledge is %{max_pledge}."
  /// - **de**: "Höchstbetrag ist %{max_pledge}."
  /// - **es**: "La contribución máxima es %{max_pledge}."
  /// - **fr**: "L'engagement maximum est de %{max_pledge}."
  /// - **ja**: "最高プレッジ額は %{max_pledge} です。"
  public static func The_maximum_pledge_is_max_pledge(max_pledge: String) -> String {
    return localizedString(
      key: "The_maximum_pledge_is_max_pledge",
      defaultValue: "The maximum pledge is %{max_pledge}.",
      count: nil,
      substitutions: ["max_pledge": max_pledge]
    )
  }
  /// "The minimum pledge is %{min_pledge}."
  ///
  /// - **en**: "The minimum pledge is %{min_pledge}."
  /// - **de**: "Mindestfinanzierungsbeitrag ist %{min_pledge}."
  /// - **es**: "La contribución mínima es %{min_pledge}."
  /// - **fr**: "L'engagement minimum est de %{min_pledge}."
  /// - **ja**: "最低プレッジ額は %{min_pledge} です。"
  public static func The_minimum_pledge_is_min_pledge(min_pledge: String) -> String {
    return localizedString(
      key: "The_minimum_pledge_is_min_pledge",
      defaultValue: "The minimum pledge is %{min_pledge}.",
      count: nil,
      substitutions: ["min_pledge": min_pledge]
    )
  }
  /// "There was a problem with this payment."
  ///
  /// - **en**: "There was a problem with this payment."
  /// - **de**: "Es ist ein Problem bei der Zahlung aufgetreten."
  /// - **es**: "Ocurrió un error con el pago."
  /// - **fr**: "Un problème s'est produit lors de ce règlement."
  /// - **ja**: "支払いに問題があります。"
  public static func There_was_a_problem_with_this_payment() -> String {
    return localizedString(
      key: "There_was_a_problem_with_this_payment",
      defaultValue: "There was a problem with this payment.",
      count: nil,
      substitutions: [:]
    )
  }
}
