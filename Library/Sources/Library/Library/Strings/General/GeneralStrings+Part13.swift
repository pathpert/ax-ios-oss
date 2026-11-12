// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Learn more about accountability"
  ///
  /// - **en**: "Learn more about accountability"
  /// - **de**: "Weitere Informationen zur Rechenschaftspflicht"
  /// - **es**: "Más información sobre las responsabilidades"
  /// - **fr**: "En savoir plus sur la responsabilité"
  /// - **ja**: "報告義務に関してさらに詳しく"
  public static func Learn_more_about_accountability() -> String {
    return localizedString(
      key: "Learn_more_about_accountability",
      defaultValue: "Learn more about accountability",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Leave page"
  ///
  /// - **en**: "Leave page"
  /// - **de**: "Seite verlassen"
  /// - **es**: "Salir de la página"
  /// - **fr**: "Quitter la page"
  /// - **ja**: "ページから移動"
  public static func Leave_page() -> String {
    return localizedString(
      key: "Leave_page",
      defaultValue: "Leave page",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{left_count} left"
  ///
  /// - **en**: "%{left_count} left"
  /// - **de**: "%{left_count} übrig"
  /// - **es**: "%{left_count} restante"
  /// - **fr**: "%{left_count} restante"
  /// - **ja**: "残り%{left_count}"
  public static func Left_count_left(left_count: Int) -> String {
    return localizedString(
      key: "Left_count_left",
      defaultValue: "%{left_count} left",
      count: left_count,
      substitutions: ["left_count": Format.wholeNumber(left_count)]
    )
  }
  /// "%{left_count} left"
  ///
  /// - **en**: "%{left_count} left"
  /// - **de**: "%{left_count} verbleibend"
  /// - **es**: "%{left_count} restantes"
  /// - **fr**: "%{left_count} restantes"
  /// - **ja**: "残り%{left_count}"
  public static func Left_count_left_other(left_count: String) -> String {
    return localizedString(
      key: "Left_count_left.other",
      defaultValue: "%{left_count} left",
      count: nil,
      substitutions: ["left_count": left_count]
    )
  }
  /// "Link copied. Spread the word!"
  ///
  /// - **en**: "Link copied. Spread the word!"
  /// - **de**: "Link copied. Spread the word!"
  /// - **es**: "Enlace copiado. ¡Corre la voz!"
  /// - **fr**: "Lien copié, faites passer le mot !"
  /// - **ja**: "リンクをコピーしました。ぜひシェアしてください！"
  public static func Link_copied_spread_the_word() -> String {
    return localizedString(
      key: "Link_copied_spread_the_word",
      defaultValue: "Link copied. Spread the word!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live"
  ///
  /// - **en**: "Live"
  /// - **de**: "Live"
  /// - **es**: "En vivo"
  /// - **fr**: "En direct"
  /// - **ja**: "ライブ"
  public static func Live() -> String {
    return localizedString(
      key: "Live",
      defaultValue: "Live",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live Stream"
  ///
  /// - **en**: "Live Stream"
  /// - **de**: "Live-Stream"
  /// - **es**: "Live Streaming"
  /// - **fr**: "Diffusion en direct"
  /// - **ja**: "ライブ配信"
  public static func Live_Stream() -> String {
    return localizedString(
      key: "Live_Stream",
      defaultValue: "Live Stream",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live now"
  ///
  /// - **en**: "Live now"
  /// - **de**: "Jetzt live"
  /// - **es**: "En vivo"
  /// - **fr**: "En direct en ce moment"
  /// - **ja**: "ライブ配信中"
  public static func Live_now() -> String {
    return localizedString(
      key: "Live_now",
      defaultValue: "Live now",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live stream countdown"
  ///
  /// - **en**: "Live stream countdown"
  /// - **de**: "Live-Stream Countdown"
  /// - **es**: "Live Stream - Cuenta atrás"
  /// - **fr**: "Compte à rebours de la diffusion en direct"
  /// - **ja**: "ライブ配信のカウントダウン"
  public static func Live_stream_countdown() -> String {
    return localizedString(
      key: "Live_stream_countdown",
      defaultValue: "Live stream countdown",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Live stream – %{date}"
  ///
  /// - **en**: "Live stream – %{date}"
  /// - **de**: "Live-Stream – %{date}"
  /// - **es**: "Live-Stream – %{date}"
  /// - **fr**: "Diffusion en direct – %{date}"
  /// - **ja**: "%{date} 日にライブ配信"
  public static func Live_stream_date(date: String) -> String {
    return localizedString(
      key: "Live_stream_date",
      defaultValue: "Live stream – %{date}",
      count: nil,
      substitutions: ["date": date]
    )
  }
  /// "Live streaming now"
  ///
  /// - **en**: "Live streaming now"
  /// - **de**: "Wird gerade live gestreamt"
  /// - **es**: "En vivo ahora"
  /// - **fr**: "Diffusion en direct en cours"
  /// - **ja**: "ライブ配信中"
  public static func Live_streaming_now() -> String {
    return localizedString(
      key: "Live_streaming_now",
      defaultValue: "Live streaming now",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Loading"
  ///
  /// - **en**: "Loading"
  /// - **de**: "Ladevorgang läuft"
  /// - **es**: "Cargando"
  /// - **fr**: "Chargement"
  /// - **ja**: "読み込み中"
  public static func Loading() -> String {
    return localizedString(
      key: "Loading",
      defaultValue: "Loading",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Location"
  ///
  /// - **en**: "Location"
  /// - **de**: "Standort"
  /// - **es**: "Ubicación"
  /// - **fr**: "Lieu"
  /// - **ja**: "地域"
  public static func Location() -> String {
    return localizedString(
      key: "Location",
      defaultValue: "Location",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Anywhere"
  ///
  /// - **en**: "Anywhere"
  /// - **de**: "Weltweit"
  /// - **es**: "Cualquier lugar"
  /// - **fr**: "N'importe où"
  /// - **ja**: "すべての場所"
  public static func Location_anywhere() -> String {
    return localizedString(
      key: "Location_anywhere",
      defaultValue: "Anywhere",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Search by city, state, country..."
  ///
  /// - **en**: "Search by city, state, country..."
  /// - **de**: "Suche nach Stadt, Region, Land…"
  /// - **es**: "Búsqueda por ciudad, estado, país..."
  /// - **fr**: "Rechercher par ville, état, pays..."
  /// - **ja**: "都市、州、国で検索…"
  public static func Location_searchbox_placeholder() -> String {
    return localizedString(
      key: "Location_searchbox_placeholder",
      defaultValue: "Search by city, state, country...",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Long-lasting design"
  ///
  /// - **en**: "Long-lasting design"
  /// - **de**: "Beständiges Design"
  /// - **es**: "Diseño de larga duración"
  /// - **fr**: "Des produits qui durent"
  /// - **ja**: "長持ちするデザイン"
  public static func Long_lasting_design() -> String {
    return localizedString(
      key: "Long_lasting_design",
      defaultValue: "Long-lasting design",
      count: nil,
      substitutions: [:]
    )
  }
}
