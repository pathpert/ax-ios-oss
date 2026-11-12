// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Limited (%{rewards_remaining} left of %{reward_limit})"
  ///
  /// - **en**: "Limited (%{rewards_remaining} left of %{reward_limit})"
  /// - **de**: "Limitiert (%{rewards_remaining} von %{reward_limit} übrig)"
  /// - **es**: "Limitado (quedan %{rewards_remaining} de %{reward_limit})"
  /// - **fr**: "Stock limité (il en reste %{rewards_remaining} sur %{reward_limit})"
  /// - **ja**: "数量限定 (%{reward_limit} 中残り%{rewards_remaining}）"
  public static func rewards_info_limited_rewards_remaining_left_of_reward_limit(rewards_remaining: String, reward_limit: String) -> String {
    return localizedString(
      key: "rewards.info.limited_rewards_remaining_left_of_reward_limit",
      defaultValue: "Limited (%{rewards_remaining} left of %{reward_limit})",
      count: nil,
      substitutions: ["rewards_remaining": rewards_remaining, "reward_limit": reward_limit]
    )
  }
  /// "Shipping"
  ///
  /// - **en**: "Shipping"
  /// - **de**: "Versand"
  /// - **es**: "Envío"
  /// - **fr**: "Expédition"
  /// - **ja**: "配送"
  public static func rewards_info_shipping() -> String {
    return localizedString(
      key: "rewards.info.shipping",
      defaultValue: "Shipping",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping destinations"
  ///
  /// - **en**: "Shipping destinations"
  /// - **de**: "Versandziele"
  /// - **es**: "Destinos de envío"
  /// - **fr**: "Expédition"
  /// - **ja**: "配送地域"
  public static func rewards_info_shipping_destinations() -> String {
    return localizedString(
      key: "rewards.info.shipping_destinations",
      defaultValue: "Shipping destinations",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Ships to"
  ///
  /// - **en**: "Ships to"
  /// - **de**: "Versandziel"
  /// - **es**: "Envío a"
  /// - **fr**: "Livraison"
  /// - **ja**: "配送先："
  public static func rewards_info_ships_to() -> String {
    return localizedString(
      key: "rewards.info.ships_to",
      defaultValue: "Ships to",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{time} left"
  ///
  /// - **en**: "%{time} left"
  /// - **de**: "{{time}} verbleibend"
  /// - **es**: "Tiempo restante: {{time}}"
  /// - **fr**: "Plus que %{time}"
  /// - **ja**: "あと%{time}"
  public static func rewards_info_time_left(time: String) -> String {
    return localizedString(
      key: "rewards.info.time_left",
      defaultValue: "%{time} left",
      count: nil,
      substitutions: ["time": time]
    )
  }
  /// "You selected"
  ///
  /// - **en**: "You selected"
  /// - **de**: "Deine Auswahl"
  /// - **es**: "Seleccionaste"
  /// - **fr**: "Votre sélection"
  /// - **ja**: "選択した"
  public static func rewards_selected_label_you_selected() -> String {
    return localizedString(
      key: "rewards.selected_label.you_selected",
      defaultValue: "You selected",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Shipping anywhere in the world"
  ///
  /// - **en**: "Shipping anywhere in the world"
  /// - **de**: "Weltweiter Versand"
  /// - **es**: "Envíos a cualquier lugar del mundo"
  /// - **fr**: "Livraison dans le monde entier"
  /// - **ja**: "世界各国に配送"
  public static func rewards_shipping_preferences_location_unrestricted() -> String {
    return localizedString(
      key: "rewards.shipping_preferences.location.unrestricted",
      defaultValue: "Shipping anywhere in the world",
      count: nil,
      substitutions: [:]
    )
  }
  /// "About %{reward_amount} USD"
  ///
  /// - **en**: "About %{reward_amount} USD"
  /// - **de**: "Ungefähr %{reward_amount} USD"
  /// - **es**: "Aprox. %{reward_amount} USD"
  /// - **fr**: "Environ %{reward_amount} USD"
  /// - **ja**: "約%{reward_amount} 米ドル"
  public static func rewards_title_about_amount_usd(reward_amount: String) -> String {
    return localizedString(
      key: "rewards.title.about_amount_usd",
      defaultValue: "About %{reward_amount} USD",
      count: nil,
      substitutions: ["reward_amount": reward_amount]
    )
  }
  /// "Pledge %{reward_currency} or more"
  ///
  /// - **en**: "Pledge %{reward_currency} or more"
  /// - **de**: "Trage %{reward_currency} oder mehr bei"
  /// - **es**: "Contribuye %{reward_currency} o más"
  /// - **fr**: "Contribution de %{reward_currency} ou plus"
  /// - **ja**: "%{reward_currency} 以上のプレッジ"
  public static func rewards_title_pledge_reward_currency_or_more(reward_currency: String) -> String {
    return localizedString(
      key: "rewards.title.pledge_reward_currency_or_more",
      defaultValue: "Pledge %{reward_currency} or more",
      count: nil,
      substitutions: ["reward_currency": reward_currency]
    )
  }
  /// "Backings"
  ///
  /// - **en**: "Backings"
  /// - **de**: "Unterstützte Projekte"
  /// - **es**: "Contribuciones"
  /// - **fr**: "Engagements"
  /// - **ja**: "支援"
  public static func tabbar_backings() -> String {
    return localizedString(
      key: "tabbar.backings",
      defaultValue: "Backings",
      count: nil,
      substitutions: [:]
    )
  }
}
