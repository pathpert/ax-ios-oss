// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "Kickstarter's Trust & Safety team has investigated user reports associated with this project and/or its creator."
  ///
  /// - **en**: "Kickstarter's Trust & Safety team has investigated user reports associated with this project and/or its creator."
  /// - **de**: "Das Kickstarter-Team für Vertrauen und Sicherheit hat Meldungen von Nutzern zu diesem Projekt und/oder dem Projektgründer untersucht."
  /// - **es**: "El equipo de confianza y seguridad de Kickstarter analizó los informes recibidos de los usuarios en relación con este proyecto o su creador."
  /// - **fr**: "Le service Confiance et sécurité de Kickstarter a enquêté sur les signalements reçus à propos de ce projet ou de son créateur."
  /// - **ja**: "Kickstarter の「トラスト＆セーフティ」チームが、このプロジェクトおよび/またはそのクリエイターに関するユーザーからの報告を調査しました。"
  public static func project_project_notices_notice_intro() -> String {
    return localizedString(
      key: "project.project_notices.notice_intro",
      defaultValue: "Kickstarter's Trust & Safety team has investigated user reports associated with this project and/or its creator.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Learn more about creator accountability"
  ///
  /// - **en**: "Learn more about creator accountability"
  /// - **de**: "Weitere Informationen zur Rechenschaftspflicht von Projektgründern"
  /// - **es**: "Más información sobre las responsabilidades del creador"
  /// - **fr**: "En savoir plus sur les responsabilités du créateur"
  /// - **ja**: "クリエイターのアカウンタビリティ（説明責任）について詳しく見る"
  public static func project_project_notices_notice_sheet_cta() -> String {
    return localizedString(
      key: "project.project_notices.notice_sheet_cta",
      defaultValue: "Learn more about creator accountability",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We'll remind you 48 hours before this project ends!"
  ///
  /// - **en**: "We'll remind you 48 hours before this project ends!"
  /// - **de**: "Wir werden dich 48 Stunden vor Ende dieses Projekts daran erinnern!"
  /// - **es**: "¡Te avisaremos 48 horas antes de que finalice este proyecto !"
  /// - **fr**: "Nous vous enverrons un rappel 48 heures avant la fin de la campagne de ce projet !"
  /// - **ja**: "プロジェクト終了48時間前に通知します！"
  public static func project_star_confirmation() -> String {
    return localizedString(
      key: "project.star.confirmation",
      defaultValue: "We'll remind you 48 hours before this project ends!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "OK"
  ///
  /// - **en**: "OK"
  /// - **de**: "OK"
  /// - **es**: "Ok"
  /// - **fr**: "OK"
  /// - **ja**: "OK"
  public static func project_star_ok() -> String {
    return localizedString(
      key: "project.star.ok",
      defaultValue: "OK",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funded!"
  ///
  /// - **en**: "Funded!"
  /// - **de**: "Finanziert!"
  /// - **es**: "¡Financiado!"
  /// - **fr**: "Financé !"
  /// - **ja**: "達成"
  public static func project_status_funded() -> String {
    return localizedString(
      key: "project.status.funded",
      defaultValue: "Funded!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding Canceled"
  ///
  /// - **en**: "Funding Canceled"
  /// - **de**: "Finanzierung abgebrochen"
  /// - **es**: "Financiamiento cancelado"
  /// - **fr**: "Financement annulé"
  /// - **ja**: "ファンディングキャンセル済"
  public static func project_status_funding_canceled() -> String {
    return localizedString(
      key: "project.status.funding_canceled",
      defaultValue: "Funding Canceled",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding for this project was canceled by the project creator."
  ///
  /// - **en**: "Funding for this project was canceled by the project creator."
  /// - **de**: "Der Projektgründer hat die Finanzierung für dieses Projekt abgebrochen."
  /// - **es**: "El financiamiento para este proyecto ha sido cancelado por el creador."
  /// - **fr**: "Le financement de ce projet a été annulé par son créateur."
  /// - **ja**: "このファンドはキャンセルされました"
  public static func project_status_funding_project_canceled_by_creator() -> String {
    return localizedString(
      key: "project.status.funding_project_canceled_by_creator",
      defaultValue: "Funding for this project was canceled by the project creator.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding for this project was suspended."
  ///
  /// - **en**: "Funding for this project was suspended."
  /// - **de**: "Die Finanzierung für dieses Projekt wurde ausgesetzt."
  /// - **es**: "El financiamiento para este proyecto ha sido suspendido."
  /// - **fr**: "Le financement de ce projet a été suspendu."
  /// - **ja**: "このプロジェクトは停止されました。"
  public static func project_status_funding_project_suspended() -> String {
    return localizedString(
      key: "project.status.funding_project_suspended",
      defaultValue: "Funding for this project was suspended.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding Suspended"
  ///
  /// - **en**: "Funding Suspended"
  /// - **de**: "Finanzierung ausgesetzt"
  /// - **es**: "Financiamiento suspendido"
  /// - **fr**: "Financement suspendu"
  /// - **ja**: "ファンディング停止済み"
  public static func project_status_funding_suspended() -> String {
    return localizedString(
      key: "project.status.funding_suspended",
      defaultValue: "Funding Suspended",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Funding Unsuccessful"
  ///
  /// - **en**: "Funding Unsuccessful"
  /// - **de**: "Finanzierung fehlgeschlagen"
  /// - **es**: "Financiamiento sin éxito"
  /// - **fr**: "Financement non réussi"
  /// - **ja**: "ファンディング失敗"
  public static func project_status_funding_unsuccessful() -> String {
    return localizedString(
      key: "project.status.funding_unsuccessful",
      defaultValue: "Funding Unsuccessful",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This project’s funding goal was not reached %{deadline}."
  ///
  /// - **en**: "This project’s funding goal was not reached %{deadline}."
  /// - **de**: "Das Finanzierungsziel für dieses Projekt wurde nicht erreicht %{deadline}."
  /// - **es**: "La meta de financiamiento de este proyecto no fue alcanzada el %{deadline}."
  /// - **fr**: "L'objectif de financement de ce projet n'a pas été atteint avant le %{deadline}."
  /// - **ja**: "%{deadline} までにプロジェクトのファンド目標に達しませんでした。"
  public static func project_status_project_funding_goal_not_reached(deadline: String) -> String {
    return localizedString(
      key: "project.status.project_funding_goal_not_reached",
      defaultValue: "This project’s funding goal was not reached %{deadline}.",
      count: nil,
      substitutions: ["deadline": deadline]
    )
  }
  /// "This project is purged and only visible to staff."
  ///
  /// - **en**: "This project is purged and only visible to staff."
  /// - **de**: "Dieses Projekt wurde gelöscht und ist nur für das Kickstarter-Team sichtbar."
  /// - **es**: "Este proyecto fue eliminado y es únicamente visible para el equipo de Kickstarter."
  /// - **fr**: "Ce projet a été supprimé et n'est visible que pour l'équipe."
  /// - **ja**: "このプロジェクトは削除され、非公開になりました"
  public static func project_status_project_purged_only_visible_to_staff() -> String {
    return localizedString(
      key: "project.status.project_purged_only_visible_to_staff",
      defaultValue: "This project is purged and only visible to staff.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This project was successfully funded on %{deadline}."
  ///
  /// - **en**: "This project was successfully funded on %{deadline}."
  /// - **de**: "Dieses Projekt wurde am %{deadline} erfolgreich finanziert."
  /// - **es**: "Este proyecto fue financiado con éxito el %{deadline}."
  /// - **fr**: "Ce projet a été financé avec succès le %{deadline}."
  /// - **ja**: "%{deadline} にファンドに成功"
  public static func project_status_project_was_successfully_funded_on_deadline(deadline: String) -> String {
    return localizedString(
      key: "project.status.project_was_successfully_funded_on_deadline",
      defaultValue: "This project was successfully funded on %{deadline}.",
      count: nil,
      substitutions: ["deadline": deadline]
    )
  }
  /// "Campaign"
  ///
  /// - **en**: "Campaign"
  /// - **de**: "Kampagne"
  /// - **es**: "Campaña"
  /// - **fr**: "Campagne"
  /// - **ja**: "キャンペーン"
  public static func project_subpages_menu_buttons_campaign() -> String {
    return localizedString(
      key: "project.subpages.menu.buttons.campaign",
      defaultValue: "Campaign",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Comments"
  ///
  /// - **en**: "Comments"
  /// - **de**: "Kommentare"
  /// - **es**: "Comentarios"
  /// - **fr**: "Commentaires"
  /// - **ja**: "コメント"
  public static func project_subpages_menu_buttons_comments() -> String {
    return localizedString(
      key: "project.subpages.menu.buttons.comments",
      defaultValue: "Comments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Creator"
  ///
  /// - **en**: "Creator"
  /// - **de**: "Projektgründer"
  /// - **es**: "Creador"
  /// - **fr**: "Créateur"
  /// - **ja**: "クリエイター"
  public static func project_subpages_menu_buttons_creator() -> String {
    return localizedString(
      key: "project.subpages.menu.buttons.creator",
      defaultValue: "Creator",
      count: nil,
      substitutions: [:]
    )
  }
}
