// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension PledgeStrings {
  /// "Reward location"
  ///
  /// - **en**: "Reward location"
  /// - **de**: "Standort der Belohnung"
  /// - **es**: "Lugar de la recompensa"
  /// - **fr**: "Lieu de la récompense"
  /// - **ja**: "リワードの場所"
  public static func Reward_location() -> String {
    return localizedString(
      key: "Reward_location",
      defaultValue: "Reward location",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reward received"
  ///
  /// - **en**: "Reward received"
  /// - **de**: "Belohnung erhalten"
  /// - **es**: "Recompensa recibida"
  /// - **fr**: "Récompense reçue"
  /// - **ja**: "リワードを受け取りました"
  public static func Reward_received() -> String {
    return localizedString(
      key: "Reward_received",
      defaultValue: "Reward received",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reward selected"
  ///
  /// - **en**: "Reward selected"
  /// - **de**: "Ausgewählte Belohnung"
  /// - **es**: "Recompensa seleccionada"
  /// - **fr**: "Récompense sélectionnée"
  /// - **ja**: "選択中のリワード"
  public static func Reward_selected() -> String {
    return localizedString(
      key: "Reward_selected",
      defaultValue: "Reward selected",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Reward surveys"
  ///
  /// - **en**: "Reward surveys"
  /// - **de**: "Befragungen"
  /// - **es**: "Cuestionarios sobre recompensas"
  /// - **fr**: "Questionnaires des récompenses"
  /// - **ja**: "リワードのサーベイ"
  public static func Reward_surveys() -> String {
    return localizedString(
      key: "Reward_surveys",
      defaultValue: "Reward surveys",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Rewards aren't guaranteed."
  ///
  /// - **en**: "Rewards aren't guaranteed."
  /// - **de**: "Es gibt keine Garantie für die Erfüllung der Belohnungen."
  /// - **es**: "Las recompensas no están garantizadas."
  /// - **fr**: "Les récompenses ne font pas l'objet d'une garantie de livraison."
  /// - **ja**: "リワードは保証されていません。"
  public static func Rewards_arent_guaranteed() -> String {
    return localizedString(
      key: "Rewards_arent_guaranteed",
      defaultValue: "Rewards aren't guaranteed.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{rewards_count} reward"
  ///
  /// - **en**: "%{rewards_count} reward"
  /// - **de**: "%{rewards_count} Belohnung"
  /// - **es**: "%{rewards_count} recompensa"
  /// - **fr**: "%{rewards_count} récompense"
  /// - **ja**: "%{rewards_count} 種類のリワード"
  public static func Rewards_count_rewards(rewards_count: Int) -> String {
    return localizedString(
      key: "Rewards_count_rewards",
      defaultValue: "%{rewards_count} reward",
      count: rewards_count,
      substitutions: ["rewards_count": Format.wholeNumber(rewards_count)]
    )
  }
  /// "%{rewards_count} rewards"
  ///
  /// - **en**: "%{rewards_count} rewards"
  /// - **de**: "%{rewards_count} Belohnungen"
  /// - **es**: "%{rewards_count} recompensas"
  /// - **fr**: "%{rewards_count} récompenses"
  /// - **ja**: "%{rewards_count} のリワード"
  public static func Rewards_count_rewards_other(rewards_count: String) -> String {
    return localizedString(
      key: "Rewards_count_rewards.other",
      defaultValue: "%{rewards_count} rewards",
      count: nil,
      substitutions: ["rewards_count": rewards_count]
    )
  }
  /// "%{rewards_count} reward:"
  ///
  /// - **en**: "%{rewards_count} reward:"
  /// - **de**: "%{rewards_count} Belohnung:"
  /// - **es**: "%{rewards_count} recompensa:"
  /// - **fr**: "%{rewards_count} récompense :"
  /// - **ja**: "%{rewards_count} 種類のリワード"
  public static func Rewards_count_rewards_colon(rewards_count: Int) -> String {
    return localizedString(
      key: "Rewards_count_rewards_colon",
      defaultValue: "%{rewards_count} reward:",
      count: rewards_count,
      substitutions: ["rewards_count": Format.wholeNumber(rewards_count)]
    )
  }
  /// "%{rewards_count} rewards:"
  ///
  /// - **en**: "%{rewards_count} rewards:"
  /// - **de**: "%{rewards_count} Belohnungen:"
  /// - **es**: "%{rewards_count} recompensas:"
  /// - **fr**: "%{rewards_count} récompenses :"
  /// - **ja**: "%{rewards_count} のリワード："
  public static func Rewards_count_rewards_colon_other(rewards_count: String) -> String {
    return localizedString(
      key: "Rewards_count_rewards_colon.other",
      defaultValue: "%{rewards_count} rewards:",
      count: nil,
      substitutions: ["rewards_count": rewards_count]
    )
  }
  /// "Secret reward"
  ///
  /// - **en**: "Secret reward"
  /// - **de**: "Geheime Belohnung"
  /// - **es**: "Recompensa secreta"
  /// - **fr**: "Récompense secrète"
  /// - **ja**: "シークレットリワード"
  public static func Secret_reward() -> String {
    return localizedString(
      key: "Secret_reward",
      defaultValue: "Secret reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "See rewards"
  ///
  /// - **en**: "See rewards"
  /// - **de**: "Belohnungen ansehen"
  /// - **es**: "Ver recompensas"
  /// - **fr**: "Afficher les récompenses"
  /// - **ja**: "リワードを見る"
  public static func See_rewards() -> String {
    return localizedString(
      key: "See_rewards",
      defaultValue: "See rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "See the rewards"
  ///
  /// - **en**: "See the rewards"
  /// - **de**: "Belohnungen einblenden"
  /// - **es**: "Ver las recompensas"
  /// - **fr**: "Afficher les récompenses"
  /// - **ja**: "リワードを保存"
  public static func See_the_rewards() -> String {
    return localizedString(
      key: "See_the_rewards",
      defaultValue: "See the rewards",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Select this card"
  ///
  /// - **en**: "Select this card"
  /// - **de**: "Diese Karte auswählen"
  /// - **es**: "Selecciona esta tarjeta"
  /// - **fr**: "Sélectionner cette carte"
  /// - **ja**: "このカードを選択する"
  public static func Select_this_card() -> String {
    return localizedString(
      key: "Select_this_card",
      defaultValue: "Select this card",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Select this reward"
  ///
  /// - **en**: "Select this reward"
  /// - **de**: "Diese Belohnung wählen"
  /// - **es**: "Seleccionar esta recompensa"
  /// - **fr**: "Sélectionner cette récompense"
  /// - **ja**: "このリワードを選ぶ"
  public static func Select_this_reward() -> String {
    return localizedString(
      key: "Select_this_reward",
      defaultValue: "Select this reward",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Select this reward instead"
  ///
  /// - **en**: "Select this reward instead"
  /// - **de**: "Diese Belohnung auswählen"
  /// - **es**: "Selecciona esta recompensa"
  /// - **fr**: "Choisir cette récompense"
  /// - **ja**: "このリワードを選択"
  public static func Select_this_reward_instead() -> String {
    return localizedString(
      key: "Select_this_reward_instead",
      defaultValue: "Select this reward instead",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Select your reward"
  ///
  /// - **en**: "Select your reward"
  /// - **de**: "Belohnung auswählen"
  /// - **es**: "Selecciona tu recompensa"
  /// - **fr**: "Choix de récompense"
  /// - **ja**: "リワードの選択"
  public static func Select_your_reward() -> String {
    return localizedString(
      key: "Select_your_reward",
      defaultValue: "Select your reward",
      count: nil,
      substitutions: [:]
    )
  }
}
