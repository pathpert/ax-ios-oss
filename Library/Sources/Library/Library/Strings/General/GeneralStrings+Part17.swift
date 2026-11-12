// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Under 75% raised"
  ///
  /// - **en**: "Under 75% raised"
  /// - **de**: "Unter 75 % gesammelt"
  /// - **es**: "Menos del 75  % recaudado"
  /// - **fr**: "Financé à moins de 75 %"
  /// - **ja**: "資金調達達成率：75% 未満"
  public static func Percentage_raised_pill_bucket_0() -> String {
    return localizedString(
      key: "Percentage_raised_pill_bucket_0",
      defaultValue: "Under 75% raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "75% to 100% raised"
  ///
  /// - **en**: "75% to 100% raised"
  /// - **de**: "75–100 % gesammelt"
  /// - **es**: "Entre el 75  % y el 100  % recaudado"
  /// - **fr**: "Financé entre 75 % et 100 %"
  /// - **ja**: "資金調達達成率：75% ～ 100%"
  public static func Percentage_raised_pill_bucket_1() -> String {
    return localizedString(
      key: "Percentage_raised_pill_bucket_1",
      defaultValue: "75% to 100% raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More than 100% raised"
  ///
  /// - **en**: "More than 100% raised"
  /// - **de**: "Über 100 % gesammelt"
  /// - **es**: "Más del 100  % recaudado"
  /// - **fr**: "Financé à plus de 100 %"
  /// - **ja**: "資金調達達成率：100%"
  public static func Percentage_raised_pill_bucket_2() -> String {
    return localizedString(
      key: "Percentage_raised_pill_bucket_2",
      defaultValue: "More than 100% raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Play"
  ///
  /// - **en**: "Play"
  /// - **de**: "Abspielen"
  /// - **es**: "Reproducir"
  /// - **fr**: "Lecture"
  /// - **ja**: "動画を再生"
  public static func Play() -> String {
    return localizedString(
      key: "Play",
      defaultValue: "Play",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Please enter an amount of %{amount} or less."
  ///
  /// - **en**: "Please enter an amount of %{amount} or less."
  /// - **de**: "Bitte gib einen Finanzierungsbeitrag von %{amount} oder weniger ein."
  /// - **es**: "Ingresa un monto de contribución de %{amount} o menor."
  /// - **fr**: "Veuillez saisir un montant de %{amount} ou moins."
  /// - **ja**: "%{amount} 以下の金額を入力してくだささい。"
  public static func Please_enter_an_amount_of_amount_or_less(amount: String) -> String {
    return localizedString(
      key: "Please_enter_an_amount_of_amount_or_less",
      defaultValue: "Please enter an amount of %{amount} or less.",
      count: nil,
      substitutions: ["amount": amount]
    )
  }
  /// "Please enter an amount of %{amount} or more."
  ///
  /// - **en**: "Please enter an amount of %{amount} or more."
  /// - **de**: "Bitte gib einen Finanzierungsbeitrag von mindestens %{amount} ein."
  /// - **es**: "Ingresa un monto de contribución de %{amount} o más."
  /// - **fr**: "Veuillez saisir un montant de %{amount} ou plus."
  /// - **ja**: "%{amount} 以上の金額を入力してください。"
  public static func Please_enter_an_amount_of_amount_or_more(amount: String) -> String {
    return localizedString(
      key: "Please_enter_an_amount_of_amount_or_more",
      defaultValue: "Please enter an amount of %{amount} or more.",
      count: nil,
      substitutions: ["amount": amount]
    )
  }
  /// "Popular"
  ///
  /// - **en**: "Popular"
  /// - **de**: "Beliebt"
  /// - **es**: "Popular"
  /// - **fr**: "Tendances"
  /// - **ja**: "人気"
  public static func Popular() -> String {
    return localizedString(
      key: "Popular",
      defaultValue: "Popular",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Popular Projects"
  ///
  /// - **en**: "Popular Projects"
  /// - **de**: "Beliebte Projekte"
  /// - **es**: "Proyectos populares"
  /// - **fr**: "Les tendances"
  /// - **ja**: "人気のプロジェクト"
  public static func Popular_Projects() -> String {
    return localizedString(
      key: "Popular_Projects",
      defaultValue: "Popular Projects",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Popularity"
  ///
  /// - **en**: "Popularity"
  /// - **de**: "Nach Beliebtheit"
  /// - **es**: "Popularidad"
  /// - **fr**: "Tendances"
  /// - **ja**: "人気"
  public static func Popularity() -> String {
    return localizedString(
      key: "Popularity",
      defaultValue: "Popularity",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Post"
  ///
  /// - **en**: "Post"
  /// - **de**: "Posten"
  /// - **es**: "Publicar"
  /// - **fr**: "Publier"
  /// - **ja**: "投稿する"
  public static func Post() -> String {
    return localizedString(
      key: "Post",
      defaultValue: "Post",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Postal code"
  ///
  /// - **en**: "Postal code"
  /// - **de**: "Postleitzahl"
  /// - **es**: "Código postal"
  /// - **fr**: "Code postal"
  /// - **ja**: "郵便番号"
  public static func Postal_code() -> String {
    return localizedString(
      key: "Postal_code",
      defaultValue: "Postal code",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Postcode"
  ///
  /// - **en**: "Postcode"
  /// - **de**: "Postleitzahl"
  /// - **es**: "Código postal"
  /// - **fr**: "Code postal"
  /// - **ja**: "郵便番号"
  public static func Postcode() -> String {
    return localizedString(
      key: "Postcode",
      defaultValue: "Postcode",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Posted"
  ///
  /// - **en**: "Posted"
  /// - **de**: "Veröffentlicht"
  /// - **es**: "Publicado"
  /// - **fr**: "Publié"
  /// - **ja**: "投稿しました"
  public static func Posted() -> String {
    return localizedString(
      key: "Posted",
      defaultValue: "Posted",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Posting..."
  ///
  /// - **en**: "Posting..."
  /// - **de**: "Veröffentlichung läuft..."
  /// - **es**: "Publicación en proceso..."
  /// - **fr**: "Publication en cours..."
  /// - **ja**: "投稿中…"
  public static func Posting() -> String {
    return localizedString(
      key: "Posting",
      defaultValue: "Posting...",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Preparing your personal data..."
  ///
  /// - **en**: "Preparing your personal data..."
  /// - **de**: "Persönlichen Daten werden vorbereitet ..."
  /// - **es**: "Preparando tus datos personales..."
  /// - **fr**: "La préparation de vos données personnelles est en cours..."
  /// - **ja**: "あなたの個人データを準備中…"
  public static func Preparing_your_personal_data() -> String {
    return localizedString(
      key: "Preparing_your_personal_data",
      defaultValue: "Preparing your personal data...",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Private profile"
  ///
  /// - **en**: "Private profile"
  /// - **de**: "Privates Profil"
  /// - **es**: "Perfil privado"
  /// - **fr**: "Profil privé"
  /// - **ja**: "プライベート設定のプロフィール"
  public static func Private_profile() -> String {
    return localizedString(
      key: "Private_profile",
      defaultValue: "Private profile",
      count: nil,
      substitutions: [:]
    )
  }
}
