// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "We're processing this pledge—pull to refresh."
  ///
  /// - **en**: "We're processing this pledge—pull to refresh."
  /// - **de**: "Der Finanzierungsbeitrag wird derzeit bearbeitet — zur Aktualisierung nach unten ziehen."
  /// - **es**: "Estamos procesando la contribución, desliza para actualizar."
  /// - **fr**: "Cet engagement est en cours de traitement, veuillez tirer sur la page pour actualiser."
  /// - **ja**: "このプレッジを処理中です。リフレッシュするにはプルしてください。"
  public static func We_re_processing_this_pledge_pull_to_refresh() -> String {
    return localizedString(
      key: "We_re_processing_this_pledge_pull_to_refresh",
      defaultValue: "We're processing this pledge—pull to refresh.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We're processing your pledge—pull to refresh."
  ///
  /// - **en**: "We're processing your pledge—pull to refresh."
  /// - **de**: "Dein Finanzierungsbeitrag wird derzeit bearbeitet — zur Aktualisierung nach unten ziehen."
  /// - **es**: "Estamos procesando tu actualización, desliza para actualizar."
  /// - **fr**: "Votre engagement est en cours de traitement, veuillez tirer sur la page pour actualiser."
  /// - **ja**: "プレッジを処理中です。リフレッシュするにはプルしてください。"
  public static func We_re_processing_your_pledge_pull_to_refresh() -> String {
    return localizedString(
      key: "We_re_processing_your_pledge_pull_to_refresh",
      defaultValue: "We're processing your pledge—pull to refresh.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We were unable to load the shipping destinations.
  /// ease try again later."
  ///
  /// - **en**: "We were unable to load the shipping destinations.
  /// ease try again later."
  /// - **de**: "Das Laden der Versandadressen war leider nicht möglich.
  /// tte versuche es später noch einmal."
  /// - **es**: "No se pudieron cargar los destinos de envío.
  /// r favor inténtalo de nuevo más tarde."
  /// - **fr**: "Nous n'avons pas été en mesure de charger les destinations d'expédition.
  /// uillez réessayer ultérieurement."
  /// - **ja**: "配送先の読込に失敗。
  /// お試しください。"
  public static func We_were_unable_to_load_the_shipping_destinations() -> String {
    return localizedString(
      key: "We_were_unable_to_load_the_shipping_destinations",
      defaultValue: "We were unable to load the shipping destinations.\nPlease try again later.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Yes, cancel my pledge"
  ///
  /// - **en**: "Yes, cancel my pledge"
  /// - **de**: "Ja, ich möchte meinen Beitrag zurückziehen"
  /// - **es**: "Sí, cancelar mi contribución"
  /// - **fr**: "Oui, annuler mon engagement"
  /// - **ja**: "はい、プレッジをキャンセルします"
  public static func Yes_cancel_my_pledge() -> String {
    return localizedString(
      key: "Yes_cancel_my_pledge",
      defaultValue: "Yes, cancel my pledge",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You canceled this project, so the backer’s payment method was never charged."
  ///
  /// - **en**: "You canceled this project, so the backer’s payment method was never charged."
  /// - **de**: "Du hast dieses Projekt abgebrochen. Daher wurde die Zahlungsmethode des Unterstützers nicht belastet."
  /// - **es**: "Has cancelado este proyecto, así que no se realizó ningún cargo al método de pago del patrocinador."
  /// - **fr**: "Vous avez annulé ce projet, donc le moyen de paiement du contributeur n'a pas été débité."
  /// - **ja**: "このプロジェクトはあなたによってキャンセルされたため、お支払い方法への請求は行われませんでした。"
  public static func You_canceled_this_project_so_the_backers_payment_method_was_never_charged() -> String {
    return localizedString(
      key: "You_canceled_this_project_so_the_backers_payment_method_was_never_charged",
      defaultValue: "You canceled this project, so the backer’s payment method was never charged.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You canceled your pledge for this project."
  ///
  /// - **en**: "You canceled your pledge for this project."
  /// - **de**: "Du hast den Finanzierungsbeitrag für dieses Projekt zurückgezogen."
  /// - **es**: "Has cancelado tu contribución a este proyecto."
  /// - **fr**: "Vous avez annulé votre engagement."
  /// - **ja**: "このプロジェクトのプレッジはキャンセルされました。"
  public static func You_canceled_your_pledge_for_this_project() -> String {
    return localizedString(
      key: "You_canceled_your_pledge_for_this_project",
      defaultValue: "You canceled your pledge for this project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You can’t use this credit card to back a project from %{project_country}."
  ///
  /// - **en**: "You can’t use this credit card to back a project from %{project_country}."
  /// - **de**: "Diese Karte kann nicht verwendet werden, um ein Projekt aus dem folgenden Land zu unterstützen: %{project_country}."
  /// - **es**: "No puedes usar esta tarjeta de crédito para patrocinar un proyecto de %{project_country}."
  /// - **fr**: "Impossible d'accepter cette carte pour soutenir un projet depuis le pays suivant : %{project_country}."
  /// - **ja**: "%{project_country} のプロジェクトをバックするのにこのクレジットカードを利用することはできません。"
  public static func You_cant_use_this_credit_card_to_back_a_project_from_project_country(project_country: String) -> String {
    return localizedString(
      key: "You_cant_use_this_credit_card_to_back_a_project_from_project_country",
      defaultValue: "You can’t use this credit card to back a project from %{project_country}.",
      count: nil,
      substitutions: ["project_country": project_country]
    )
  }
  /// "You have selected Pledge Over Time. If the project reaches its funding goal, the first charge of %{amount} will be collected on %{date}."
  ///
  /// - **en**: "You have selected Pledge Over Time. If the project reaches its funding goal, the first charge of %{amount} will be collected on %{date}."
  /// - **de**: "Du hast dich für die Ratenzahlung entschieden. Wenn das Projekt sein Finanzierungsziel erreicht, wird die erste Rate in Höhe von %{amount} am %{date} eingezogen."
  /// - **es**: "Seleccionaste Contribución en cuotas. Si el proyecto alcanza la meta, el primer cargo de %{amount} se cobrará el %{date}."
  /// - **fr**: "Vous avez choisi d'étaler votre engagement dans le temps. Si l'objectif de financement du projet est atteint, le premier prélèvement de %{amount} interviendra le %{date}."
  /// - **ja**: "分割プレッジを選択しました。プロジェクトがファンディングゴールに達すると、%{date} に最初のお支払い額 %{amount} が請求されます。"
  public static func You_have_selected_pledge_over_time(amount: String, date: String) -> String {
    return localizedString(
      key: "You_have_selected_pledge_over_time",
      defaultValue: "You have selected Pledge Over Time. If the project reaches its funding goal, the first charge of %{amount} will be collected on %{date}.",
      count: nil,
      substitutions: ["amount": amount, "date": date]
    )
  }
  /// "You need to pledge at least %{reward_minimum} for this reward."
  ///
  /// - **en**: "You need to pledge at least %{reward_minimum} for this reward."
  /// - **de**: "Diese Belohnung hat einen Mindestfinanzierungsbeitrag von %{reward_minimum}."
  /// - **es**: "Debes contribuir, al menos, %{reward_minimum} para obtener esta recompensa."
  /// - **fr**: "Vous devez vous engager à hauteur de %{reward_minimum} ou plus pour sélectionner cette récompense."
  /// - **ja**: "このリワードには、最低%{reward_minimum}のプレッジが必要です。"
  public static func You_need_to_pledge_at_least_reward_minimum_for_this_reward(reward_minimum: String) -> String {
    return localizedString(
      key: "You_need_to_pledge_at_least_reward_minimum_for_this_reward",
      defaultValue: "You need to pledge at least %{reward_minimum} for this reward.",
      count: nil,
      substitutions: ["reward_minimum": reward_minimum]
    )
  }
  /// "<b>You pledged</b> on %{pledge_date}"
  ///
  /// - **en**: "<b>You pledged</b> on %{pledge_date}"
  /// - **de**: "<b>Finanzierungsbeitrag geleistet</b> im %{pledge_date}"
  /// - **es**: "<b>Contribuiste</b> el %{pledge_date}"
  /// - **fr**: "<b>Votre engagement</b> du %{pledge_date}"
  /// - **ja**: "%{pledge_date} に<b>プレッジ</b>"
  public static func You_pledged_on_date(pledge_date: String) -> String {
    return localizedString(
      key: "You_pledged_on_date",
      defaultValue: "<b>You pledged</b> on %{pledge_date}",
      count: nil,
      substitutions: ["pledge_date": pledge_date]
    )
  }
  /// "You pledged without a reward"
  ///
  /// - **en**: "You pledged without a reward"
  /// - **de**: "Unterstützt ohne Belohnung"
  /// - **es**: "Contribuiste sin recompensa"
  /// - **fr**: "Engagement sans récompense"
  /// - **ja**: "リワードなしでプレッジしました"
  public static func You_pledged_without_a_reward() -> String {
    return localizedString(
      key: "You_pledged_without_a_reward",
      defaultValue: "You pledged without a reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You will be charged for your pledge over four payments, at no extra cost."
  ///
  /// - **en**: "You will be charged for your pledge over four payments, at no extra cost."
  /// - **de**: "Dein Finanzierungsbeitrag wird dir in vier Raten belastet. Dir entstehen dadurch keine zusätzlichen Kosten."
  /// - **es**: "Se te cobrará tu contribución en cuatro pagos sin costo adicional."
  /// - **fr**: "Votre contribution sera étalée en quatre prélèvements, sans frais supplémentaires."
  /// - **ja**: "プレッジの請求が4回に分けて行われます。追加の手数料はかかりません。"
  public static func You_will_be_charged_for_your_pledge_over_four_payments_collapsed_description() -> String {
    return localizedString(
      key: "You_will_be_charged_for_your_pledge_over_four_payments_collapsed_description",
      defaultValue: "You will be charged for your pledge over four payments, at no extra cost.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The first charge will be 24 hours after the project ends successfully, then every 2 weeks until fully paid. When this option is selected no further edits can be made to your pledge."
  ///
  /// - **en**: "The first charge will be 24 hours after the project ends successfully, then every 2 weeks until fully paid. When this option is selected no further edits can be made to your pledge."
  /// - **de**: "Die erste Rate wird 24 Stunden nach erfolgreichem Ende des Projekts eingezogen. Die weiteren Raten werden alle 2 Wochen eingezogen, bis der Finanzierungsbeitrag komplett bezahlt wurde. Wenn du dich für diese Option entscheidest, kannst du keine weiteren Änderungen an deinem Beitrag vornehmen."
  /// - **es**: "El primer pago será 24 horas después de que el proyecto finalice con éxito y luego cada 2 semanas hasta el monto total de la contribución. Cuando se selecciona esta opción, no se pueden realizar más modificaciones en tu contribución."
  /// - **fr**: "Le premier prélèvement interviendra 24 heures après la fin de la campagne, si l'objectif de celle-ci est atteint. Les prélèvements suivants auront lieu toutes les deux semaines, jusqu'au règlement intégral du montant dû. Si vous sélectionnez cette option, votre engagement devient non modifiable."
  /// - **ja**: "最初の請求はプロジェクトが成功に終わってから24時間後に行われます。その後は全額が支払われるまで、2週間おきに請求が行われます。このオプションを選択すると、その後はプレッジを編集することはできなくなります。"
  public static func You_will_be_charged_for_your_pledge_over_four_payments_expanded_description() -> String {
    return localizedString(
      key: "You_will_be_charged_for_your_pledge_over_four_payments_expanded_description",
      defaultValue: "The first charge will be 24 hours after the project ends successfully, then every 2 weeks until fully paid. When this option is selected no further edits can be made to your pledge.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "You won't be charged for backing a project unless it reaches its funding goal."
  ///
  /// - **en**: "You won't be charged for backing a project unless it reaches its funding goal."
  /// - **de**: "Dein Finanzierungsbeitrag wird nur abgebucht, wenn das Projekt sein Finanzierungsziel erreichte."
  /// - **es**: "No se te cobrará por patrocinar un proyecto a menos que alcance su meta de financiamiento."
  /// - **fr**: "Vous ne serez débité que si le créateur atteint son objectif de financement."
  /// - **ja**: "プロジェクトをバックした場合、プロジェクトがファンディングゴールに到達しない限り、課金されることはありません。"
  public static func You_wont_be_charged_for_backing_a_project() -> String {
    return localizedString(
      key: "You_wont_be_charged_for_backing_a_project",
      defaultValue: "You won't be charged for backing a project unless it reaches its funding goal.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Your payment method was successfully charged."
  ///
  /// - **en**: "Your payment method was successfully charged."
  /// - **de**: "Deine Zahlungsmethode wurde erfolgreich belastet."
  /// - **es**: "Se efectuó el cargo a tu método de pago."
  /// - **fr**: "Votre moyen de paiement a bien été débité."
  /// - **ja**: "支払方法の登録完了。"
  public static func Your_payment_method_was_successfully_charged() -> String {
    return localizedString(
      key: "Your_payment_method_was_successfully_charged",
      defaultValue: "Your payment method was successfully charged.",
      count: nil,
      substitutions: [:]
    )
  }
}
