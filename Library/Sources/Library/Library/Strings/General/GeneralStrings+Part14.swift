// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Looks like there aren't any frequently asked questions yet."
  ///
  /// - **en**: "Looks like there aren't any frequently asked questions yet."
  /// - **de**: "Offenbar gibt es noch keine häufig gestellten Fragen für dieses Projekt."
  /// - **es**: "Parece que todavía no hay preguntas frecuentes."
  /// - **fr**: "Il semble qu'il n'y ait pas encore de questions fréquemment posées."
  /// - **ja**: "よくある質問はまだ追加されていないようです。"
  public static func Looks_like_there_arent_any_frequently_asked_questions() -> String {
    return localizedString(
      key: "Looks_like_there_arent_any_frequently_asked_questions",
      defaultValue: "Looks like there aren't any frequently asked questions yet.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Love film? We do, too."
  ///
  /// - **en**: "Love film? We do, too."
  /// - **de**: "Du bist Kino-Fan? Wir auch."
  /// - **es**: "¿Te encanta el cine? A nosotros también."
  /// - **fr**: "Cinéphile ? Nous aussi."
  /// - **ja**: "映画ファン？そんなあなたに必須のニュースレター。"
  public static func Love_film_We_do_too() -> String {
    return localizedString(
      key: "Love_film_We_do_too",
      defaultValue: "Love film? We do, too.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "MM/YY"
  ///
  /// - **en**: "MM/YY"
  /// - **de**: "MM/JJ"
  /// - **es**: "MM/AA"
  /// - **fr**: "MM/AA"
  /// - **ja**: "月月/年年"
  public static func MMYY() -> String {
    return localizedString(
      key: "MMYY",
      defaultValue: "MM/YY",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Making this change will allow you to see project goal and pledge amounts converted to your chosen currency."
  ///
  /// - **en**: "Making this change will allow you to see project goal and pledge amounts converted to your chosen currency."
  /// - **de**: "Wenn du die Währung wechselst, werden das Finanzierungsziel und die Finanzierungsbeiträge in der von dir gewählten Währung angezeigt."
  /// - **es**: "Hacer este cambio te permitirá ver la meta del proyecto y los montos de las contribuciones convertidos a la moneda elegida."
  /// - **fr**: "Cette fonction vous permettra de voir votre objectif de financement et le montant de chaque engagement dans la devise de votre choix."
  /// - **ja**: "この変更によって、プロジェクトゴールとプレッジ額が選択された通貨で表示されます。"
  public static func Making_this_change() -> String {
    return localizedString(
      key: "Making_this_change",
      defaultValue: "Making this change will allow you to see project goal and pledge amounts converted to your chosen currency.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Manage"
  ///
  /// - **en**: "Manage"
  /// - **de**: "Verwalten"
  /// - **es**: "Administrar"
  /// - **fr**: "Gérer"
  /// - **ja**: "プレッジ管理"
  public static func Manage() -> String {
    return localizedString(
      key: "Manage",
      defaultValue: "Manage",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Manage this account in your Apple ID settings."
  ///
  /// - **en**: "Manage this account in your Apple ID settings."
  /// - **de**: "Verwalte dieses Konto in deinen Apple ID-Einstellungen."
  /// - **es**: "Administra esta cuenta desde la configuración de tu Apple ID."
  /// - **fr**: "Gérez ce compte depuis vos paramètres Apple ID."
  /// - **ja**: "Apple ID の設定からこのアカウントを管理。"
  public static func Manage_this_account() -> String {
    return localizedString(
      key: "Manage_this_account",
      defaultValue: "Manage this account in your Apple ID settings.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Menu"
  ///
  /// - **en**: "Menu"
  /// - **de**: "Menü"
  /// - **es**: "Menú"
  /// - **fr**: "Menu"
  /// - **ja**: "メニュー"
  public static func Menu() -> String {
    return localizedString(
      key: "Menu",
      defaultValue: "Menu",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{total_amount} million+"
  ///
  /// - **en**: "%{total_amount} million+"
  /// - **de**: "Über %{total_amount} Millionen"
  /// - **es**: "Más de %{total_amount} millones"
  /// - **fr**: "Plus de %{total_amount} millions"
  /// - **ja**: "%{total_amount},000,000 以上"
  public static func Million_plus(total_amount: String) -> String {
    return localizedString(
      key: "Million_plus",
      defaultValue: "%{total_amount} million+",
      count: nil,
      substitutions: ["total_amount": total_amount]
    )
  }
  /// "More options"
  ///
  /// - **en**: "More options"
  /// - **de**: "Weitere Optionen"
  /// - **es**: "Más opciones"
  /// - **fr**: "Plus d'options"
  /// - **ja**: "その他のオプション"
  public static func More_options() -> String {
    return localizedString(
      key: "More_options",
      defaultValue: "More options",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More than %{number_of_items} items"
  ///
  /// - **en**: "More than %{number_of_items} items"
  /// - **de**: "Mehr als %{number_of_items} Benachrichtigungen"
  /// - **es**: "Más de %{number_of_items} notificaciones"
  /// - **fr**: "Plus de %{number_of_items} éléments"
  /// - **ja**: "%{number_of_items} 件以上のアイテム"
  public static func More_than_number_of_items_items(number_of_items: String) -> String {
    return localizedString(
      key: "More_than_number_of_items_items",
      defaultValue: "More than %{number_of_items} items",
      count: nil,
      substitutions: ["number_of_items": number_of_items]
    )
  }
  /// "Most backed"
  ///
  /// - **en**: "Most backed"
  /// - **de**: "Meist unterstüzt"
  /// - **es**: "Más patrocinadores"
  /// - **fr**: "Nombre d'engagements"
  /// - **ja**: "バッカー数"
  public static func Most_backed() -> String {
    return localizedString(
      key: "Most_backed",
      defaultValue: "Most backed",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Most funded"
  ///
  /// - **en**: "Most funded"
  /// - **de**: "Meist finanziert"
  /// - **es**: "Más financiados"
  /// - **fr**: "Financement"
  /// - **ja**: "達成額"
  public static func Most_funded() -> String {
    return localizedString(
      key: "Most_funded",
      defaultValue: "Most funded",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Name"
  ///
  /// - **en**: "Name"
  /// - **de**: "Name"
  /// - **es**: "Nombre"
  /// - **fr**: "Nom"
  /// - **ja**: "名前"
  public static func Name() -> String {
    return localizedString(
      key: "Name",
      defaultValue: "Name",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Near me"
  ///
  /// - **en**: "Near me"
  /// - **de**: "In meiner Nähe"
  /// - **es**: "Cerca de mí"
  /// - **fr**: "Près de moi"
  /// - **ja**: "近辺"
  public static func Near_me() -> String {
    return localizedString(
      key: "Near_me",
      defaultValue: "Near me",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Near you"
  ///
  /// - **en**: "Near you"
  /// - **de**: "In deiner Nähe"
  /// - **es**: "Cerca de ti"
  /// - **fr**: "Près de chez moi"
  /// - **ja**: "近辺"
  public static func Near_you() -> String {
    return localizedString(
      key: "Near_you",
      defaultValue: "Near you",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Never"
  ///
  /// - **en**: "Never"
  /// - **de**: "Niemals"
  /// - **es**: "Nunca"
  /// - **fr**: "Jamais"
  /// - **ja**: "通知を受けない"
  public static func Never() -> String {
    return localizedString(
      key: "Never",
      defaultValue: "Never",
      count: nil,
      substitutions: [:]
    )
  }
}
