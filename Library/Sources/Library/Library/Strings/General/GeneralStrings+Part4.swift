// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Bonus"
  ///
  /// - **en**: "Bonus"
  /// - **de**: "Bonus"
  /// - **es**: "Extra"
  /// - **fr**: "Bonus"
  /// - **ja**: "ボーナス"
  public static func Bonus() -> String {
    return localizedString(
      key: "Bonus",
      defaultValue: "Bonus",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Bring creative projects to life."
  ///
  /// - **en**: "Bring creative projects to life."
  /// - **de**: "Kreative Projekte werden Wirklichkeit!"
  /// - **es**: "Dale vida a proyectos creativos."
  /// - **fr**: "Réalisez vos projets créatifs."
  /// - **ja**: "クリエイティブなプロジェクトに生命を。"
  public static func Bring_creative_projects_to_life() -> String {
    return localizedString(
      key: "Bring_creative_projects_to_life",
      defaultValue: "Bring creative projects to life.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "By pledging, you acknowledge that rewards or reimbursements aren’t guaranteed by either Kickstarter or the creator."
  ///
  /// - **en**: "By pledging, you acknowledge that rewards or reimbursements aren’t guaranteed by either Kickstarter or the creator."
  /// - **de**: "Durch deinen Finanzierungsbeitrag erkennst du an, dass weder der Projektgründer noch Kickstarter Belohnungen oder Rückerstattungen garantieren."
  /// - **es**: "Al hacer la contribución, reconoces que las recompensas o los reembolsos no están garantizados por Kickstarter o el creador."
  /// - **fr**: "En vous engageant, vous reconnaissez que ni Kickstarter ni le créateur ne garantit une récompense ou un remboursement."
  /// - **ja**: "プレッジすると、リワードや払い戻しが Kickstarter またはクリエイターによって保証されていないことを理解したものとみなされます。"
  public static func By_pledging_you_acknowledge() -> String {
    return localizedString(
      key: "By_pledging_you_acknowledge",
      defaultValue: "By pledging, you acknowledge that rewards or reimbursements aren’t guaranteed by either Kickstarter or the creator.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "CVC"
  ///
  /// - **en**: "CVC"
  /// - **de**: "CVC"
  /// - **es**: "CVC"
  /// - **fr**: "Cryptogramme"
  /// - **ja**: "CVC"
  public static func CVC() -> String {
    return localizedString(
      key: "CVC",
      defaultValue: "CVC",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cancel"
  ///
  /// - **en**: "Cancel"
  /// - **de**: "Abbrechen"
  /// - **es**: "Cancelar"
  /// - **fr**: "Annuler"
  /// - **ja**: "キャンセル"
  public static func Cancel() -> String {
    return localizedString(
      key: "Cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cancellation reason"
  ///
  /// - **en**: "Cancellation reason"
  /// - **de**: "Grund der Annullierung"
  /// - **es**: "Motivo de cancelación"
  /// - **fr**: "Motif d'annulation"
  /// - **ja**: "キャンセルの理由"
  public static func Cancellation_reason() -> String {
    return localizedString(
      key: "Cancellation_reason",
      defaultValue: "Cancellation reason",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Can't find it?"
  ///
  /// - **en**: "Can't find it?"
  /// - **de**: "E-Mail unauffindbar?"
  /// - **es**: "¿No encuentras el correo?"
  /// - **fr**: "Introuvable ?"
  /// - **ja**: "メールが見つからない？"
  public static func Cant_find_it() -> String {
    return localizedString(
      key: "Cant_find_it",
      defaultValue: "Can't find it?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Change email"
  ///
  /// - **en**: "Change email"
  /// - **de**: "E-Mail-Adresse ändern"
  /// - **es**: "Cambiar correo electrónico"
  /// - **fr**: "Changer d'adresse e-mail"
  /// - **ja**: "メールアドレスを変更"
  public static func Change_email() -> String {
    return localizedString(
      key: "Change_email",
      defaultValue: "Change email",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Charge %{number}"
  ///
  /// - **en**: "Charge %{number}"
  /// - **de**: "Transaktion %{number}"
  /// - **es**: "Cargo %{number}"
  /// - **fr**: "Transaction %{number}"
  /// - **ja**: "請求 %{number}"
  public static func Charge_number(number: String) -> String {
    return localizedString(
      key: "Charge_number",
      defaultValue: "Charge %{number}",
      count: nil,
      substitutions: ["number": number]
    )
  }
  /// "Check out these handpicked projects just for you."
  ///
  /// - **en**: "Check out these handpicked projects just for you."
  /// - **de**: "Sieh dir dieses speziell für dich ausgesuchten Projekte an."
  /// - **es**: "Echa un vistazo a estos proyectos seleccionados exclusivamente para ti."
  /// - **fr**: "Voici quelques projets sélectionnés rien que pour vous."
  /// - **ja**: "あなたにピッタリの Kickstarter イチオシのプロジェクトをご覧ください。"
  public static func Check_out_these_handpicked_projects() -> String {
    return localizedString(
      key: "Check_out_these_handpicked_projects",
      defaultValue: "Check out these handpicked projects just for you.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Chosen just for you"
  ///
  /// - **en**: "Chosen just for you"
  /// - **de**: "Speziell für dich ausgewählt"
  /// - **es**: "Elegidos especialmente para ti"
  /// - **fr**: "Rien que pour vous"
  /// - **ja**: "あなたのために選びました"
  public static func Chosen_just_for_you() -> String {
    return localizedString(
      key: "Chosen_just_for_you",
      defaultValue: "Chosen just for you",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Close live stream"
  ///
  /// - **en**: "Close live stream"
  /// - **de**: "Live-Stream schließen"
  /// - **es**: "Cerrar Live Stream"
  /// - **fr**: "Fermer la diffusion en direct"
  /// - **ja**: "ライブ配信を閉じる"
  public static func Close_live_stream() -> String {
    return localizedString(
      key: "Close_live_stream",
      defaultValue: "Close live stream",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Close project"
  ///
  /// - **en**: "Close project"
  /// - **de**: "Projekt schließen"
  /// - **es**: "Cerrar proyecto"
  /// - **fr**: "Fermer le projet"
  /// - **ja**: "プロジェクトを閉じる"
  public static func Close_project() -> String {
    return localizedString(
      key: "Close_project",
      defaultValue: "Close project",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Closes live stream."
  ///
  /// - **en**: "Closes live stream."
  /// - **de**: "Schließt Live-Stream."
  /// - **es**: "Cierra Live-Stream."
  /// - **fr**: "Ferme la diffusion en direct."
  /// - **ja**: "ライブ配信を閉じる"
  public static func Closes_live_stream() -> String {
    return localizedString(
      key: "Closes_live_stream",
      defaultValue: "Closes live stream.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Closes project."
  ///
  /// - **en**: "Closes project."
  /// - **de**: "Schließt das Projekt."
  /// - **es**: "Cierra el proyecto."
  /// - **fr**: "Ferme le projet."
  /// - **ja**: "プロジェクトを閉じる"
  public static func Closes_project() -> String {
    return localizedString(
      key: "Closes_project",
      defaultValue: "Closes project.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Collapses subcategories."
  ///
  /// - **en**: "Collapses subcategories."
  /// - **de**: "Reduziert die Anzeige der Unterkategorien."
  /// - **es**: "Muestra menos subcategorías."
  /// - **fr**: "Masque les sous-catégories."
  /// - **ja**: "サブカテゴリーを閉じる"
  public static func Collapses_subcategories() -> String {
    return localizedString(
      key: "Collapses_subcategories",
      defaultValue: "Collapses subcategories.",
      count: nil,
      substitutions: [:]
    )
  }
}
