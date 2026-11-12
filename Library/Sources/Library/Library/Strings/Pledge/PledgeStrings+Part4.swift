// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Finalize Pledge"
  ///
  /// - **en**: "Finalize Pledge"
  /// - **de**: "Beitrag finalisieren"
  /// - **es**: "Finalizar contribución"
  /// - **fr**: "Finaliser mon engagement"
  /// - **ja**: "プレッジの最終確定"
  public static func Finalize_pledge() -> String {
    return localizedString(
      key: "Finalize_pledge",
      defaultValue: "Finalize Pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Fix Payment"
  ///
  /// - **en**: "Fix Payment"
  /// - **de**: "Zahlung korrigieren"
  /// - **es**: "Arreglar pago"
  /// - **fr**: "Corriger mon paiement"
  /// - **ja**: "お支払い方法の修正"
  public static func Fix_payment() -> String {
    return localizedString(
      key: "Fix_payment",
      defaultValue: "Fix Payment",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Fix payment method"
  ///
  /// - **en**: "Fix payment method"
  /// - **de**: "Zahlungsmethode ändern"
  /// - **es**: "Corregir el método de pago"
  /// - **fr**: "Correction du moyen de paiement"
  /// - **ja**: "お支払い方法を修正"
  public static func Fix_payment_method() -> String {
    return localizedString(
      key: "Fix_payment_method",
      defaultValue: "Fix payment method",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Fix your payment method"
  ///
  /// - **en**: "Fix your payment method"
  /// - **de**: "Zahlungsmethode ändern"
  /// - **es**: "Corrige tu método de pago"
  /// - **fr**: "Corriger votre moyen de paiement"
  /// - **ja**: "お支払い方法を修正"
  public static func Fix_your_payment_method() -> String {
    return localizedString(
      key: "Fix_your_payment_method",
      defaultValue: "Fix your payment method",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Go to Pledge Manager"
  ///
  /// - **en**: "Go to Pledge Manager"
  /// - **de**: "Zur Beitragsverwaltung"
  /// - **es**: "Ir al gestor de contribuciones"
  /// - **fr**: "Ouvrir le gestionnaire d'engagements"
  /// - **ja**: "プレッジマネージャーに移動する"
  public static func Go_to_pledge_manager() -> String {
    return localizedString(
      key: "Go_to_pledge_manager",
      defaultValue: "Go to Pledge Manager",
      count: nil,
      substitutions: [:]
    )
  }
  /// "If the project reaches its funding goal, you will be charged %{total} on %{project_deadline}. You will receive a proof of pledge that will be redeemable if the project is funded and the creator is successful at completing the creative venture."
  ///
  /// - **en**: "If the project reaches its funding goal, you will be charged %{total} on %{project_deadline}. You will receive a proof of pledge that will be redeemable if the project is funded and the creator is successful at completing the creative venture."
  /// - **de**: "Wenn das Projekt sein Finanzierungsziel erreicht, wird am %{project_deadline} deine Zahlung in Höhe von %{total} eingezogen. Du erhältst einen Nachweis über den Finanzierungsbeitrag, der einlösbar ist, wenn das Projekt finanziert ist und der Projektgründer seine kreative Idee erfolgreich umgesetzt hat."
  /// - **es**: "Si el proyecto alcanza la meta de financiamiento, te cobraremos %{total} el %{project_deadline}. Recibirás un comprobante por la contribución que podrás canjear si el proyecto se financia con éxito y el creador logra completar su iniciativa."
  /// - **fr**: "Si l'objectif de financement du projet est atteint, vous serez débité de %{total} le %{project_deadline}. Vous recevrez une preuve d'engagement qui sera échangeable si le projet est intégralement financé et si le créateur mène son projet à bien."
  /// - **ja**: "プロジェクトがファンディングゴールに到達すると、%{project_deadline}に%{total}が請求されます。プロジェクトの資金が集まりクリエイターがその取り組み全体に成功した場合に引き換え可能となるプレッジ証明が届きます。"
  public static func If_the_project_reaches_its_funding_goal_you_will_be_charged_total_on_project_deadline_and_receive_proof_of_pledge(total: String, project_deadline: String) -> String {
    return localizedString(
      key: "If_the_project_reaches_its_funding_goal_you_will_be_charged_total_on_project_deadline_and_receive_proof_of_pledge",
      defaultValue: "If the project reaches its funding goal, you will be charged %{total} on %{project_deadline}. You will receive a proof of pledge that will be redeemable if the project is funded and the creator is successful at completing the creative venture.",
      count: nil,
      substitutions: ["total": total, "project_deadline": project_deadline]
    )
  }
  /// "Increase pledge"
  ///
  /// - **en**: "Increase pledge"
  /// - **de**: "Finanzierungsbeitrag erhöhen"
  /// - **es**: "Incrementar contribución"
  /// - **fr**: "Augmenter mon engagement"
  /// - **ja**: "プレッジ額を上げる"
  public static func Increase_pledge() -> String {
    return localizedString(
      key: "Increase_pledge",
      defaultValue: "Increase pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Introducing the Backings tab"
  ///
  /// - **en**: "Introducing the Backings tab"
  /// - **de**: "Jetzt neu: Der Tab „Meine Beiträge“"
  /// - **es**: "Presentamos la pestaña Contribuciones"
  /// - **fr**: "Bienvenue dans l'onglet Engagements"
  /// - **ja**: "「支援」タブのご紹介"
  public static func Introducing_the_backings_tab() -> String {
    return localizedString(
      key: "Introducing_the_backings_tab",
      defaultValue: "Introducing the Backings tab",
      count: nil,
      substitutions: [:]
    )
  }
  /// "It may not offer some or all of your add-ons."
  ///
  /// - **en**: "It may not offer some or all of your add-ons."
  /// - **de**: "Einige oder alle deiner Add-Ons werden dafür eventuell nicht angeboten."
  /// - **es**: "Es posible que no ofrezca algunos o todos tus complementos."
  /// - **fr**: "Une partie ou la totalité des compléments pourraient être indisponibles."
  /// - **ja**: "このリワードでは、アドオン (追加リワード）の一部または全てが提供されない場合があります。"
  public static func It_may_not_offer_some_or_all_of_your_add_ons() -> String {
    return localizedString(
      key: "It_may_not_offer_some_or_all_of_your_add_ons",
      defaultValue: "It may not offer some or all of your add-ons.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Kickstarter"
  ///
  /// - **en**: "Kickstarter"
  /// - **de**: "Kickstarter"
  /// - **es**: "Kickstarter"
  /// - **fr**: "Kickstarter"
  /// - **ja**: "Kickstarter"
  public static func Kickstarter_payment_summary() -> String {
    return localizedString(
      key: "Kickstarter_payment_summary",
      defaultValue: "Kickstarter",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Late pledges active"
  ///
  /// - **en**: "Late pledges active"
  /// - **de**: "Nachträgliche Beiträge sind aktiv"
  /// - **es**: "Contribuciones tardías activas"
  /// - **fr**: "Contributions tardives activées"
  /// - **ja**: "遅延プレッジが有効"
  public static func Late_pledges_active() -> String {
    return localizedString(
      key: "Late_pledges_active",
      defaultValue: "Late pledges active",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Limited shipping"
  ///
  /// - **en**: "Limited shipping"
  /// - **de**: "Nur bestimmte Versandziele"
  /// - **es**: "Envíos limitados"
  /// - **fr**: "Livraison limitée"
  /// - **ja**: "限定配送"
  public static func Limited_shipping() -> String {
    return localizedString(
      key: "Limited_shipping",
      defaultValue: "Limited shipping",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live and unsuccessful backings can currently be viewed in the Profile tab."
  ///
  /// - **en**: "Live and unsuccessful backings can currently be viewed in the Profile tab."
  /// - **de**: "Derzeit findest du aktuelle und nicht erfolgreiche Beiträge auf dem Tab „Profil“."
  /// - **es**: "Las contribuciones a proyectos activos y no financiados aparecen actualmente en la pestaña Perfil."
  /// - **fr**: "Les engagements en cours et non financés sont visibles actuellement visibles dans l'onglet Profil."
  /// - **ja**: "進行中の支援とファンディングに成功しなかった支援については［プロフィール］タブから確認できます。"
  public static func Live_and_unsuccessful_backings_can_currently_be_viewed_in_the_profile_tab() -> String {
    return localizedString(
      key: "Live_and_unsuccessful_backings_can_currently_be_viewed_in_the_profile_tab",
      defaultValue: "Live and unsuccessful backings can currently be viewed in the Profile tab.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live backings"
  ///
  /// - **en**: "Live backings"
  /// - **de**: "Beiträge für laufende Projekte"
  /// - **es**: "Contribuciones a proyectos activos"
  /// - **fr**: "Engagements en cours"
  /// - **ja**: "進行中の支援"
  public static func Live_backings() -> String {
    return localizedString(
      key: "Live_backings",
      defaultValue: "Live backings",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Make a pledge without a reward"
  ///
  /// - **en**: "Make a pledge without a reward"
  /// - **de**: "Ohne Belohnung unterstützen"
  /// - **es**: "Contribuir sin recompensa"
  /// - **fr**: "S'engager sans recevoir de récompense"
  /// - **ja**: "リワードなしでプレッジ"
  public static func Make_a_pledge_without_a_reward() -> String {
    return localizedString(
      key: "Make_a_pledge_without_a_reward",
      defaultValue: "Make a pledge without a reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Manage your pledge"
  ///
  /// - **en**: "Manage your pledge"
  /// - **de**: "Meinen Beitrag verwalten"
  /// - **es**: "Administra tu contribución"
  /// - **fr**: "Gérer mon engagement"
  /// - **ja**: "プレッジを変更"
  public static func Manage_your_pledge() -> String {
    return localizedString(
      key: "Manage_your_pledge",
      defaultValue: "Manage your pledge",
      count: nil,
      substitutions: [:]
    )
  }
}
