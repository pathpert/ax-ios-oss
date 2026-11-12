// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "First created"
  ///
  /// - **en**: "First created"
  /// - **de**: "Erstes Projekt"
  /// - **es**: "Primer proyecto creado"
  /// - **fr**: "Premier projet créé"
  /// - **ja**: "1つめのプロジェクト"
  public static func First_created() -> String {
    return localizedString(
      key: "First_created",
      defaultValue: "First created",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Fix"
  ///
  /// - **en**: "Fix"
  /// - **de**: "Korrigieren"
  /// - **es**: "Corregir"
  /// - **fr**: "Corriger"
  /// - **ja**: "修正する"
  public static func Fix() -> String {
    return localizedString(
      key: "Fix",
      defaultValue: "Fix",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Fix within %{time_remaining}"
  ///
  /// - **en**: "Fix within %{time_remaining}"
  /// - **de**: "Innerhalb von %{time_remaining} korrigieren"
  /// - **es**: "Corregir en %{time_remaining}"
  /// - **fr**: "Il vous reste %{time_remaining} pour corriger un problème."
  /// - **ja**: "%{time_remaining} 以内に修正してください"
  public static func Fix_within_time_remaining(time_remaining: String) -> String {
    return localizedString(
      key: "Fix_within_time_remaining",
      defaultValue: "Fix within %{time_remaining}",
      count: nil,
      substitutions: ["time_remaining": time_remaining]
    )
  }
  /// "For the database or source that I will use or will create, the consent of the persons whose works or information are incorporated has been or will be obtained."
  ///
  /// - **en**: "For the database or source that I will use or will create, the consent of the persons whose works or information are incorporated has been or will be obtained."
  /// - **de**: "Für die Datenbank oder die Quelle, die ich verwenden oder entwickeln werde, wurde oder wird die Einwilligung der Personen eingeholt, deren Werke oder Informationen miteinbezogen wurden."
  /// - **es**: "Recibí o recibiré el consentimiento de las personas cuyos trabajos o contenido incorporé a la base de datos o fuente de información que utilizaré o crearé."
  /// - **fr**: "J'ai obtenu ou j'obtiendrai le consentement des personnes dont les œuvres ou les informations sont incorporées à la base de données ou à la source que je compte utiliser ou créer."
  /// - **ja**: "私が使用する（または作成する）データベースやソースについては、採用される作品や情報の所有者からすでに同意を得ている、または同意を得る予定です。"
  public static func For_the_database_or_source_I_will_use() -> String {
    return localizedString(
      key: "For_the_database_or_source_I_will_use",
      defaultValue: "For the database or source that I will use or will create, the consent of the persons whose works or information are incorporated has been or will be obtained.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Frequently asked questions"
  ///
  /// - **en**: "Frequently asked questions"
  /// - **de**: "Häufige Fragen"
  /// - **es**: "Preguntas frecuentes"
  /// - **fr**: "Questions fréquentes"
  /// - **ja**: "よくある質問"
  public static func Frequently_asked_questions() -> String {
    return localizedString(
      key: "Frequently_asked_questions",
      defaultValue: "Frequently asked questions",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funded percentage"
  ///
  /// - **en**: "Funded percentage"
  /// - **de**: "Prozent finanziert"
  /// - **es**: "Porcentaje de financiamiento"
  /// - **fr**: "Pourcentage de financement"
  /// - **ja**: "ファンディング達成率"
  public static func Funded_percentage() -> String {
    return localizedString(
      key: "Funded_percentage",
      defaultValue: "Funded percentage",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding successful"
  ///
  /// - **en**: "Funding successful"
  /// - **de**: "Finanzierung erfolgreich"
  /// - **es**: "Financiado con éxito"
  /// - **fr**: "Intégralement financé"
  /// - **ja**: "ファンディング成功"
  public static func Funding_successful() -> String {
    return localizedString(
      key: "Funding_successful",
      defaultValue: "Funding successful",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Get notified"
  ///
  /// - **en**: "Get notified"
  /// - **de**: "Benachrichtigungen aktivieren"
  /// - **es**: "Notificarme"
  /// - **fr**: "Notifiez-moi"
  /// - **ja**: "通知を希望する"
  public static func Get_notified() -> String {
    return localizedString(
      key: "Get_notified",
      defaultValue: "Get notified",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Get reminded about this project?"
  ///
  /// - **en**: "Get reminded about this project?"
  /// - **de**: "Möchtest du an dieses Projekt erinnert werden?"
  /// - **es**: "¿Deseas recibir recordatorios sobre este proyecto?"
  /// - **fr**: "Envie de recevoir un rappel à propos de ce projet ?"
  /// - **ja**: "このプロジェクトについてリマインダーを希望しますか？"
  public static func Get_reminded_about_this_project() -> String {
    return localizedString(
      key: "Get_reminded_about_this_project",
      defaultValue: "Get reminded about this project?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Get started"
  ///
  /// - **en**: "Get started"
  /// - **de**: "Jetzt loslegen"
  /// - **es**: "¡Manos a la obra!"
  /// - **fr**: "Démarrer"
  /// - **ja**: "はじめよう"
  public static func Get_started() -> String {
    return localizedString(
      key: "Get_started",
      defaultValue: "Get started",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Goal"
  ///
  /// - **en**: "Goal"
  /// - **de**: "Ziel"
  /// - **es**: "Meta"
  /// - **fr**: "Objectif"
  /// - **ja**: "ファンディングゴール"
  public static func Goal() -> String {
    return localizedString(
      key: "Goal",
      defaultValue: "Goal",
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
  public static func Goal_bucket_0() -> String {
    return localizedString(
      key: "Goal_bucket_0",
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
  public static func Goal_bucket_1() -> String {
    return localizedString(
      key: "Goal_bucket_1",
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
  public static func Goal_bucket_2() -> String {
    return localizedString(
      key: "Goal_bucket_2",
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
  public static func Goal_bucket_3() -> String {
    return localizedString(
      key: "Goal_bucket_3",
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
  public static func Goal_bucket_4() -> String {
    return localizedString(
      key: "Goal_bucket_4",
      defaultValue: "More than $1,000,000",
      count: nil,
      substitutions: [:]
    )
  }
}
