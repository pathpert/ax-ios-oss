// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "You just backed <b>%{project_name}</b>. Share this project with friends to help it along!"
  ///
  /// - **en**: "You just backed <b>%{project_name}</b>. Share this project with friends to help it along!"
  /// - **de**: "Du gehörst nun zu den Unterstützern des Projekts <b>%{project_name}</b>. Teile es mit deinen Freunden - je mehr Unterstützer, desto besser!"
  /// - **es**: "Acabas de patrocinar el proyecto <b>%{project_name}</b>. ¡Compártelo con tus amigos, para que se unan más a la causa!"
  /// - **fr**: "Vous venez de soutenir le projet <b>%{project_name}</b>. Partagez-le avec vos amis pour l'aider à avancer !"
  /// - **ja**: "<b>%{project_name}</b>にバックしました。プロジェクトをシェアして友達に伝えよう！"
  public static func project_checkout_share_you_just_backed_project_share_this_project_html(project_name: String) -> String {
    return localizedString(
      key: "project.checkout.share.you_just_backed_project_share_this_project_html",
      defaultValue: "You just backed <b>%{project_name}</b>. Share this project with friends to help it along!",
      count: nil,
      substitutions: ["project_name": project_name]
    )
  }
  /// "Friends"
  ///
  /// - **en**: "Friends"
  /// - **de**: "Freunde"
  /// - **es**: "Amigos"
  /// - **fr**: "Amis"
  /// - **ja**: "友達"
  public static func project_friends_backing_title_friends() -> String {
    return localizedString(
      key: "project.friends_backing.title.friends",
      defaultValue: "Friends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rewards"
  ///
  /// - **en**: "Rewards"
  /// - **de**: "Belohnungen"
  /// - **es**: "Recompensas"
  /// - **fr**: "Récompenses"
  /// - **ja**: "リワード設定"
  public static func project_subpages_menu_buttons_rewards() -> String {
    return localizedString(
      key: "project.subpages.menu.buttons.rewards",
      defaultValue: "Rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Includes"
  ///
  /// - **en**: "Includes"
  /// - **de**: "Enthält:"
  /// - **es**: "Incluye"
  /// - **fr**: "Comprend"
  /// - **ja**: "リワード内容"
  public static func project_view_pledge_includes() -> String {
    return localizedString(
      key: "project.view_pledge.includes",
      defaultValue: "Includes",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Canceled"
  ///
  /// - **en**: "Canceled"
  /// - **de**: "Zurückgezogen"
  /// - **es**: "Cancelada"
  /// - **fr**: "Annulé"
  /// - **ja**: "キャンセル済"
  public static func project_view_pledge_status_canceled() -> String {
    return localizedString(
      key: "project.view_pledge.status.canceled",
      defaultValue: "Canceled",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Collected"
  ///
  /// - **en**: "Collected"
  /// - **de**: "Abgebucht"
  /// - **es**: "Recaudada"
  /// - **fr**: "Fonds collectés"
  /// - **ja**: "に目標額に達成しました"
  public static func project_view_pledge_status_collected() -> String {
    return localizedString(
      key: "project.view_pledge.status.collected",
      defaultValue: "Collected",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Dropped"
  ///
  /// - **en**: "Dropped"
  /// - **de**: "Nicht übernommen"
  /// - **es**: "Descartada"
  /// - **fr**: "Abandonné"
  /// - **ja**: "取消"
  public static func project_view_pledge_status_dropped() -> String {
    return localizedString(
      key: "project.view_pledge.status.dropped",
      defaultValue: "Dropped",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Errored"
  ///
  /// - **en**: "Errored"
  /// - **de**: "Fehlerhaft"
  /// - **es**: "Error"
  /// - **fr**: "Erreur"
  /// - **ja**: "エラー"
  public static func project_view_pledge_status_errored() -> String {
    return localizedString(
      key: "project.view_pledge.status.errored",
      defaultValue: "Errored",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Pledged"
  ///
  /// - **en**: "Pledged"
  /// - **de**: "Finanzierungsbeitrag:"
  /// - **es**: "Contribuyó"
  /// - **fr**: "Engagement"
  /// - **ja**: "プレッジ済"
  public static func project_view_pledge_status_pledged() -> String {
    return localizedString(
      key: "project.view_pledge.status.pledged",
      defaultValue: "Pledged",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{reward_amount} + %{shipping_cost} shipping each"
  ///
  /// - **en**: "%{reward_amount} + %{shipping_cost} shipping each"
  /// - **de**: "Jeweils %{reward_amount} + %{shipping_cost} Versandkosten"
  /// - **es**: "%{reward_amount} + %{shipping_cost} de envío cada una"
  /// - **fr**: "%{reward_amount} + %{shipping_cost} de frais de port par unité"
  /// - **ja**: "%{reward_amount} + 送料各 %{shipping_cost} "
  public static func reward_amount_plus_shipping_cost_each(reward_amount: String, shipping_cost: String) -> String {
    return localizedString(
      key: "reward_amount_plus_shipping_cost_each",
      defaultValue: "%{reward_amount} + %{shipping_cost} shipping each",
      count: nil,
      substitutions: ["reward_amount": reward_amount, "shipping_cost": shipping_cost]
    )
  }
  /// "All gone"
  ///
  /// - **en**: "All gone"
  /// - **de**: "Alle weg"
  /// - **es**: "¡Recompensas agotadas!"
  /// - **fr**: "Épuisé"
  /// - **ja**: "終了"
  public static func rewards_info_all_gone() -> String {
    return localizedString(
      key: "rewards.info.all_gone",
      defaultValue: "All gone",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{backer_count} backers"
  ///
  /// - **en**: "%{backer_count} backers"
  /// - **de**: "%{backer_count} Unterstützer"
  /// - **es**: "%{backer_count} patrocinadores"
  /// - **fr**: "%{backer_count} contributeurs"
  /// - **ja**: "%{backer_count} バッカー"
  public static func rewards_info_backer_count_backers(backer_count: Int) -> String {
    return localizedString(
      key: "rewards.info.backer_count_backers",
      defaultValue: "%{backer_count} backers",
      count: backer_count,
      substitutions: ["backer_count": Format.wholeNumber(backer_count)]
    )
  }
  /// "%{backer_count} backers"
  ///
  /// - **en**: "%{backer_count} backers"
  /// - **de**: "%{backer_count} Unterstützer"
  /// - **es**: "%{backer_count} patrocinadores"
  /// - **fr**: "%{backer_count} contributeurs"
  /// - **ja**: "%{backer_count} バッカー"
  public static func rewards_info_backer_count_backers_other(backer_count: String) -> String {
    return localizedString(
      key: "rewards.info.backer_count_backers.other",
      defaultValue: "%{backer_count} backers",
      count: nil,
      substitutions: ["backer_count": backer_count]
    )
  }
  /// "Estimated delivery"
  ///
  /// - **en**: "Estimated delivery"
  /// - **de**: "Voraussichtliche Lieferung"
  /// - **es**: "Entrega aproximada"
  /// - **fr**: "Livraison prévue"
  /// - **ja**: "配達予定"
  public static func rewards_info_estimated_delivery() -> String {
    return localizedString(
      key: "rewards.info.estimated_delivery",
      defaultValue: "Estimated delivery",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Includes"
  ///
  /// - **en**: "Includes"
  /// - **de**: "Enthält:"
  /// - **es**: "Incluye"
  /// - **fr**: "Comprend"
  /// - **ja**: "リワード内容"
  public static func rewards_info_includes() -> String {
    return localizedString(
      key: "rewards.info.includes",
      defaultValue: "Includes",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{title} (x%{quantity})"
  ///
  /// - **en**: "%{title} (x%{quantity})"
  /// - **de**: "(%{quantity}) %{title}"
  /// - **es**: "(%{quantity}) %{title}"
  /// - **fr**: "(%{quantity}) %{title}"
  /// - **ja**: "%{title} (x%{quantity})"
  public static func rewards_info_item_quantity_title_other(title: String, quantity: String) -> String {
    return localizedString(
      key: "rewards.info.item_quantity_title.other",
      defaultValue: "%{title} (x%{quantity})",
      count: nil,
      substitutions: ["title": title, "quantity": quantity]
    )
  }
}
