// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "A successfully funded project will collect your pledge in its native currency. The amounts shown are approximate."
  ///
  /// - **en**: "A successfully funded project will collect your pledge in its native currency. The amounts shown are approximate."
  /// - **de**: "Nach erfolgreicher Finanzierung des Projekts wird dein Finanzierungsbeitrag in der Währung des Erstellungslandes abgebucht. Bis dahin können nur ungefähre Beträge angezeigt werden."
  /// - **es**: "Un proyecto financiado con éxito cobrará tu contribución en su moneda nativa. Los importes mostrados son aproximados."
  /// - **fr**: "Si ce projet est intégralement financé, votre engagement sera débité dans la devise du projet. Les montants affichés ici sont approximatifs."
  /// - **ja**: "プロジェクトのファンディングが成功した際には、プレッジ額はプロジェクトをローンチした国の通貨で集められます。表示されている金額はおおよその換算額ですのでご注意ください。"
  public static func A_successfully_funded_project_will_collect_your_pledge_in_its_native_currency() -> String {
    return localizedString(
      key: "A_successfully_funded_project_will_collect_your_pledge_in_its_native_currency",
      defaultValue: "A successfully funded project will collect your pledge in its native currency. The amounts shown are approximate.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "About %{reward_amount}"
  ///
  /// - **en**: "About %{reward_amount}"
  /// - **de**: "Ungefähr %{reward_amount}"
  /// - **es**: "Aprox. %{reward_amount}"
  /// - **fr**: "Environ %{reward_amount}"
  /// - **ja**: "約 %{reward_amount}　"
  public static func About_reward_amount(reward_amount: String) -> String {
    return localizedString(
      key: "About_reward_amount",
      defaultValue: "About %{reward_amount}",
      count: nil,
      substitutions: ["reward_amount": reward_amount]
    )
  }
  /// "Add new card"
  ///
  /// - **en**: "Add new card"
  /// - **de**: "Kreditkarte hinzufügen"
  /// - **es**: "Añadir una nueva tarjeta"
  /// - **fr**: "Ajouter une autre carte"
  /// - **ja**: "新しいカードを追加"
  public static func Add_new_card() -> String {
    return localizedString(
      key: "Add_new_card",
      defaultValue: "Add new card",
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
  /// - **ja**: "アドオン (追加リワード)"
  public static func Add_ons() -> String {
    return localizedString(
      key: "Add_ons",
      defaultValue: "Add-ons",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Add-ons unavailable"
  ///
  /// - **en**: "Add-ons unavailable"
  /// - **de**: "Add-ons nicht verfügbar"
  /// - **es**: "Complementos no disponibles"
  /// - **fr**: "Compléments non disponibles"
  /// - **ja**: "アドオン (追加リワード) は利用できません"
  public static func Add_ons_unavailable() -> String {
    return localizedString(
      key: "Add_ons_unavailable",
      defaultValue: "Add-ons unavailable",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Amount: %{amount}, %{reward}"
  ///
  /// - **en**: "Amount: %{amount}, %{reward}"
  /// - **de**: "Betrag: %{amount}, %{reward}"
  /// - **es**: "Monto: %{amount}, %{reward}"
  /// - **fr**: "Montant : %{amount}, %{reward}"
  /// - **ja**: "金額：%{amount}、%{reward}"
  public static func Amount_reward(amount: String, reward: String) -> String {
    return localizedString(
      key: "Amount_reward",
      defaultValue: "Amount: %{amount}, %{reward}",
      count: nil,
      substitutions: ["amount": amount, "reward": reward]
    )
  }
  /// "Any payment methods you've saved to Kickstarter are listed here (securely) for your convenience."
  ///
  /// - **en**: "Any payment methods you've saved to Kickstarter are listed here (securely) for your convenience."
  /// - **de**: "Sämtliche auf Kickstarter gespeicherten Zahlungsmethoden sind hier (sicher) hinterlegt."
  /// - **es**: "Para tu comodidad, aquí se enumeran (de manera absolutamente segura) los métodos de pago que guardaste en Kickstarter."
  /// - **fr**: "Voici une liste (sécurisée) de tous les moyens de paiement que vous avez ajoutés à votre compte Kickstarter."
  /// - **ja**: "Kickstarter に保存されたお支払い方法は、こちらに (安全に) リストアップされます。"
  public static func Any_payment_methods_you_saved_to_Kickstarter() -> String {
    return localizedString(
      key: "Any_payment_methods_you_saved_to_Kickstarter",
      defaultValue: "Any payment methods you've saved to Kickstarter are listed here (securely) for your convenience.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Are you sure you wish to cancel your %{amount} pledge to %{project_name}?"
  ///
  /// - **en**: "Are you sure you wish to cancel your %{amount} pledge to %{project_name}?"
  /// - **de**: "Bist du sicher, dass du deinen Beitrag von %{amount} für %{project_name} zurückziehen möchtest?"
  /// - **es**: "¿Estás seguro de que quieres cancelar tu %{amount} contribución para %{project_name}?"
  /// - **fr**: "Étes-vous certain de vouloir annuler votre engagement de %{amount} pour le projet %{project_name} ?"
  /// - **ja**: "本当に%{project_name}への%{amount}のプレッジを取り消しますか？"
  public static func Are_you_sure_you_wish_to_cancel_your_amount_pledge_to_project_name(amount: String, project_name: String) -> String {
    return localizedString(
      key: "Are_you_sure_you_wish_to_cancel_your_amount_pledge_to_project_name",
      defaultValue: "Are you sure you wish to cancel your %{amount} pledge to %{project_name}?",
      count: nil,
      substitutions: ["amount": amount, "project_name": project_name]
    )
  }
  /// "Are you sure you wish to remove this card from your payment method options?"
  ///
  /// - **en**: "Are you sure you wish to remove this card from your payment method options?"
  /// - **de**: "Bist du sicher, dass du diese Karte aus deinen Zahlungsmethoden entfernen möchtest?"
  /// - **es**: "¿Estás seguro de que deseas eliminar esta tarjeta de tus opciones de métodos de pago?"
  /// - **fr**: "Êtes-vous certain de vouloir supprimer cette carte de vos moyens de paiement ?"
  /// - **ja**: "このカードをお支払い方法から削除してもよろしいですか？"
  public static func Are_you_sure_you_wish_to_remove_this_card() -> String {
    return localizedString(
      key: "Are_you_sure_you_wish_to_remove_this_card",
      defaultValue: "Are you sure you wish to remove this card from your payment method options?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "As of %{pledge_date}"
  ///
  /// - **en**: "As of %{pledge_date}"
  /// - **de**: "Stand: %{pledge_date}"
  /// - **es**: "A partir del %{pledge_date}"
  /// - **fr**: "Depuis le %{pledge_date}"
  /// - **ja**: "%{pledge_date} 日現在"
  public static func As_of_pledge_date(pledge_date: String) -> String {
    return localizedString(
      key: "As_of_pledge_date",
      defaultValue: "As of %{pledge_date}",
      count: nil,
      substitutions: ["pledge_date": pledge_date]
    )
  }
  /// "Authenticate Card"
  ///
  /// - **en**: "Authenticate Card"
  /// - **de**: "Karte authentifizieren"
  /// - **es**: "Autenticar tarjeta"
  /// - **fr**: "Authentifier la carte"
  /// - **ja**: "カードの認証手続き"
  public static func Authenticate_card() -> String {
    return localizedString(
      key: "Authenticate_card",
      defaultValue: "Authenticate Card",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Available for pledges over %{amount}"
  ///
  /// - **en**: "Available for pledges over %{amount}"
  /// - **de**: "Für Beiträge über %{amount}"
  /// - **es**: "Disponible para contribuciones superiores a %{amount}"
  /// - **fr**: "Engagements supérieurs à %{amount}"
  /// - **ja**: "%{amount} 以上のプレッジで利用可能"
  public static func Available_for_pledges_over(amount: String) -> String {
    return localizedString(
      key: "Available_for_pledges_over",
      defaultValue: "Available for pledges over %{amount}",
      count: nil,
      substitutions: ["amount": amount]
    )
  }
  /// "Backer has pledged to this project."
  ///
  /// - **en**: "Backer has pledged to this project."
  /// - **de**: "Hat dieses Projekt unterstützt."
  /// - **es**: "Patrocinó este proyecto."
  /// - **fr**: "Ce contributeur s'est engagé à soutenir ce projet."
  /// - **ja**: "バッカーはこのプロジェクトにプレッジしました"
  public static func Backer_has_pledged_to_this_project() -> String {
    return localizedString(
      key: "Backer_has_pledged_to_this_project",
      defaultValue: "Backer has pledged to this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backing details"
  ///
  /// - **en**: "Backing details"
  /// - **de**: "Details zum Finanzierungsbeitrag"
  /// - **es**: "Detalles de la contribución"
  /// - **fr**: "Détails de la contribution"
  /// - **ja**: "バック (支援) 詳細"
  public static func Backing_details() -> String {
    return localizedString(
      key: "Backing_details",
      defaultValue: "Backing details",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backing means supporting a creative project, regardless of the outcome."
  ///
  /// - **en**: "Backing means supporting a creative project, regardless of the outcome."
  /// - **de**: "Die Unterstützung eines Projekts bedeutet, eine kreative Idee zu unterstützen, unabhängig vom Ergebnis."
  /// - **es**: "Patrocinar un proyecto significa apoyar una idea creativa, independientemente del resultado."
  /// - **fr**: "S'engager, c'est soutenir le créateur d'un projet créatif, quel que soit le résultat."
  /// - **ja**: "「バッキング」、つまりバックすることとは、クリエイティブなプロジェクトを、その結果に関係なく支援することを意味します。"
  public static func Backing_means_supporting() -> String {
    return localizedString(
      key: "Backing_means_supporting",
      defaultValue: "Backing means supporting a creative project, regardless of the outcome.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backings"
  ///
  /// - **en**: "Backings"
  /// - **de**: "Unterstützte Projekte"
  /// - **es**: "Contribuciones"
  /// - **fr**: "Engagements"
  /// - **ja**: "支援"
  public static func Backings() -> String {
    return localizedString(
      key: "Backings",
      defaultValue: "Backings",
      count: nil,
      substitutions: [:]
    )
  }
}
