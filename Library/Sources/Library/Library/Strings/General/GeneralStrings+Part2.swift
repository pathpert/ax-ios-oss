// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Amount raised"
  ///
  /// - **en**: "Amount raised"
  /// - **de**: "Gesammelter Betrag"
  /// - **es**: "Monto recaudado"
  /// - **fr**: "Montant recueilli"
  /// - **ja**: "達成額"
  public static func Amount_raised() -> String {
    return localizedString(
      key: "Amount_raised",
      defaultValue: "Amount raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Under $1,000"
  ///
  /// - **en**: "Under $1,000"
  /// - **de**: "Unter 1.000 $"
  /// - **es**: "Menos de USD 1000"
  /// - **fr**: "Moins de 1 000 $"
  /// - **ja**: "$1,000 未満"
  public static func Amount_raised_bucket_0() -> String {
    return localizedString(
      key: "Amount_raised_bucket_0",
      defaultValue: "Under $1,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$1,000 to $10,000"
  ///
  /// - **en**: "$1,000 to $10,000"
  /// - **de**: "1.000 $ bis 10.000 $"
  /// - **es**: "Entre USD 1000 y USD 10 000"
  /// - **fr**: "Entre 1 000 $ et 10 000 $"
  /// - **ja**: "$1,000 ～ $10,000"
  public static func Amount_raised_bucket_1() -> String {
    return localizedString(
      key: "Amount_raised_bucket_1",
      defaultValue: "$1,000 to $10,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$10,000 to $100,000"
  ///
  /// - **en**: "$10,000 to $100,000"
  /// - **de**: "10.000 $ bis 100.000 $"
  /// - **es**: "Entre USD 10 000 y USD 100 000"
  /// - **fr**: "Entre 10 000 $ et 100 000 $"
  /// - **ja**: "$10,000 ～ $100,000"
  public static func Amount_raised_bucket_2() -> String {
    return localizedString(
      key: "Amount_raised_bucket_2",
      defaultValue: "$10,000 to $100,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$100,000 to $1,000,000"
  ///
  /// - **en**: "$100,000 to $1,000,000"
  /// - **de**: "100.000 $ bis 1.000.000 $"
  /// - **es**: "Entre USD 100 000 y USD 1 000 000"
  /// - **fr**: "Entre 100 000 $ et 1 000 000 $"
  /// - **ja**: "$100,000 ～ $1,000,000"
  public static func Amount_raised_bucket_3() -> String {
    return localizedString(
      key: "Amount_raised_bucket_3",
      defaultValue: "$100,000 to $1,000,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More than $1,000,000"
  ///
  /// - **en**: "More than $1,000,000"
  /// - **de**: "Über 1.000.000 $"
  /// - **es**: "Más de USD 1 000 000"
  /// - **fr**: "Plus de 1 000 000 $"
  /// - **ja**: "$1,000,000 以上"
  public static func Amount_raised_bucket_4() -> String {
    return localizedString(
      key: "Amount_raised_bucket_4",
      defaultValue: "More than $1,000,000",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Under $1,000 raised"
  ///
  /// - **en**: "Under $1,000 raised"
  /// - **de**: "Unter 1.000 $ gesammelt"
  /// - **es**: "Menos de USD 1000 recaudados"
  /// - **fr**: "Moins de 1 000 $ levés"
  /// - **ja**: "資金調達額：$1,000 未満"
  public static func Amount_raised_pill_bucket_0() -> String {
    return localizedString(
      key: "Amount_raised_pill_bucket_0",
      defaultValue: "Under $1,000 raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$1,000 to $10,000 raised"
  ///
  /// - **en**: "$1,000 to $10,000 raised"
  /// - **de**: "1.000 $ bis 10.000 $ gesammelt"
  /// - **es**: "Entre USD 1000 y USD 10 000 recaudados"
  /// - **fr**: "Entre 1 000 $ et 10 000 $ levés"
  /// - **ja**: "資金調達額：$1,000 ～ $10,000"
  public static func Amount_raised_pill_bucket_1() -> String {
    return localizedString(
      key: "Amount_raised_pill_bucket_1",
      defaultValue: "$1,000 to $10,000 raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$10,000 to $100,000 raised"
  ///
  /// - **en**: "$10,000 to $100,000 raised"
  /// - **de**: "10.000 $ bis 100.000 $ gesammelt"
  /// - **es**: "Entre USD 10 000 y USD 100 000 recaudados"
  /// - **fr**: "Entre 10 000 $ et 100 000 $ levés"
  /// - **ja**: "資金調達額：$10,000 ～ $100,000"
  public static func Amount_raised_pill_bucket_2() -> String {
    return localizedString(
      key: "Amount_raised_pill_bucket_2",
      defaultValue: "$10,000 to $100,000 raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$100,000 to $1,000,000 raised"
  ///
  /// - **en**: "$100,000 to $1,000,000 raised"
  /// - **de**: "100.000 $ bis 1.000.000 $ gesammelt"
  /// - **es**: "Entre USD 100 000 y USD 1 000 000 recaudados"
  /// - **fr**: "Entre 100 000 $ et 1 000 000 $ levés"
  /// - **ja**: "資金調達額：$100,000 ～ $1,000,000"
  public static func Amount_raised_pill_bucket_3() -> String {
    return localizedString(
      key: "Amount_raised_pill_bucket_3",
      defaultValue: "$100,000 to $1,000,000 raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "More than $1,000,000 raised"
  ///
  /// - **en**: "More than $1,000,000 raised"
  /// - **de**: "Über 1.000.000 $ gesammelt"
  /// - **es**: "Más de USD 1 000 000 recaudados"
  /// - **fr**: "Plus d'1 000 000 $ levés"
  /// - **ja**: "資金調達額：$1,000,000 以上"
  public static func Amount_raised_pill_bucket_4() -> String {
    return localizedString(
      key: "Amount_raised_pill_bucket_4",
      defaultValue: "More than $1,000,000 raised",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The amounts shown are an approximate conversion. If the project is successful, your pledge will be collected in the native currency of the project, which is also displayed."
  ///
  /// - **en**: "The amounts shown are an approximate conversion. If the project is successful, your pledge will be collected in the native currency of the project, which is also displayed."
  /// - **de**: "Die angezeigten Beträge stellen nur eine ungefähre Umrechnung dar. Nach erfolgreicher Finanzierung des Projekts wird dein Finanzierungsbeitrag in der Währung des Erstellungslandes abgebucht. Dieser Betrag wird ebenso angezeigt."
  /// - **es**: "Los montos mostrados son una conversión aproximada. Si el proyecto tiene éxito, tu contribución se recaudará en la moneda nativa del proyecto, que también se mostrará."
  /// - **fr**: "Les montants qui s'affichent représentent une conversion approximative. Si le projet est intégralement financé, votre contribution sera débitée dans la devise d'origine du projet, également affichée."
  /// - **ja**: "表示されている金額は、おおよその換算金額ですのでご注意ください。プロジェクトが成功した場合、プレッジはプロジェクトをローンチした国の通貨で集められ、その換算額も表示されます。"
  public static func Amounts_shown() -> String {
    return localizedString(
      key: "Amounts_shown",
      defaultValue: "The amounts shown are an approximate conversion. If the project is successful, your pledge will be collected in the native currency of the project, which is also displayed.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Announcements"
  ///
  /// - **en**: "Announcements"
  /// - **de**: "Ankündigungen"
  /// - **es**: "Anuncios"
  /// - **fr**: "Annonces"
  /// - **ja**: "お知らせ"
  public static func Announcements() -> String {
    return localizedString(
      key: "Announcements",
      defaultValue: "Announcements",
      count: nil,
      substitutions: [:]
    )
  }
  /// "App version"
  ///
  /// - **en**: "App version"
  /// - **de**: "App-Version"
  /// - **es**: "Versión de la aplicación"
  /// - **fr**: "Version de l'application"
  /// - **ja**: "アプリ版"
  public static func App_version() -> String {
    return localizedString(
      key: "App_version",
      defaultValue: "App version",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Are you sure?"
  ///
  /// - **en**: "Are you sure?"
  /// - **de**: "Bist du sicher?"
  /// - **es**: "¿Estás seguro?"
  /// - **fr**: "Êtes-vous certain ?"
  /// - **ja**: "オフにしてもよろしいですか？"
  public static func Are_you_sure() -> String {
    return localizedString(
      key: "Are_you_sure",
      defaultValue: "Are you sure?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Ask a question"
  ///
  /// - **en**: "Ask a question"
  /// - **de**: "Eine Frage stellen"
  /// - **es**: "Haz una pregunta"
  /// - **fr**: "Poser une question"
  /// - **ja**: "質問する"
  public static func Ask_a_question() -> String {
    return localizedString(
      key: "Ask_a_question",
      defaultValue: "Ask a question",
      count: nil,
      substitutions: [:]
    )
  }
}
