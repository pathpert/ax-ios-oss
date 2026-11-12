// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DashboardStrings {
  /// "Couldn't save update."
  ///
  /// - **en**: "Couldn't save update."
  /// - **de**: "Update konnte nicht gspeichert werden."
  /// - **es**: "No se pudo guardar la actualización."
  /// - **fr**: "Impossible d'enregistrer l'actu."
  /// - **ja**: "更新失敗"
  public static func dashboard_post_update_compose_error_could_not_save_update() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.error.could_not_save_update",
      defaultValue: "Couldn't save update.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Loading..."
  ///
  /// - **en**: "Loading..."
  /// - **de**: "Ladevorgang läuft..."
  /// - **es**: "Cargando..."
  /// - **fr**: "Chargement en cours..."
  /// - **ja**: "読み込み中..."
  public static func dashboard_post_update_compose_loading() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.loading",
      defaultValue: "Loading...",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Take a new photo/video"
  ///
  /// - **en**: "Take a new photo/video"
  /// - **de**: "Neues Foto/Video hinzufügen"
  /// - **es**: "Tomar una nueva foto/un nuevo vídeo"
  /// - **fr**: "Nouvelle photo/vidéo"
  /// - **ja**: "写真/ビデオを撮る"
  public static func dashboard_post_update_compose_new_media_button() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.new_media_button",
      defaultValue: "Take a new photo/video",
      count: nil,
      substitutions: [:]
    )
  }
  /// "No attachments"
  ///
  /// - **en**: "No attachments"
  /// - **de**: "Keine Anhänge"
  /// - **es**: "Sin anexos"
  /// - **fr**: "Pas de pièces jointes"
  /// - **ja**: "添付なし"
  public static func dashboard_post_update_compose_no_attachments_placeholder() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.no_attachments_placeholder",
      defaultValue: "No attachments",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Title"
  ///
  /// - **en**: "Title"
  /// - **de**: "Titel"
  /// - **es**: "Título"
  /// - **fr**: "Titre"
  /// - **ja**: "タイトル"
  public static func dashboard_post_update_compose_placeholder_title() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.placeholder_title",
      defaultValue: "Title",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backers only"
  ///
  /// - **en**: "Backers only"
  /// - **de**: "Nur für Unterstützer"
  /// - **es**: "Sólo para patrocinadores"
  /// - **fr**: "Contributeurs seulement"
  /// - **ja**: "バッカーのみ"
  public static func dashboard_post_update_compose_private_label() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.private_label",
      defaultValue: "Backers only",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Public"
  ///
  /// - **en**: "Public"
  /// - **de**: "Öffentlich"
  /// - **es**: "Público"
  /// - **fr**: "Public"
  /// - **ja**: "公開"
  public static func dashboard_post_update_compose_public_label() -> String {
    return localizedString(
      key: "dashboard.post_update.compose.public_label",
      defaultValue: "Public",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Update #%{update_number}"
  ///
  /// - **en**: "Update #%{update_number}"
  /// - **de**: "Update Nr. %{update_number}"
  /// - **es**: "Actualización n° %{update_number}"
  /// - **fr**: "Actu no. %{update_number}"
  /// - **ja**: "%{update_count} アップデート"
  public static func dashboard_post_update_compose_update_number(update_number: String) -> String {
    return localizedString(
      key: "dashboard.post_update.compose.update_number",
      defaultValue: "Update #%{update_number}",
      count: nil,
      substitutions: ["update_number": update_number]
    )
  }
  /// "Cancel"
  ///
  /// - **en**: "Cancel"
  /// - **de**: "Abbrechen"
  /// - **es**: "Cancelar"
  /// - **fr**: "Annuler"
  /// - **ja**: "キャンセル"
  public static func dashboard_post_update_preview_confirmation_alert_cancel_button() -> String {
    return localizedString(
      key: "dashboard.post_update.preview.confirmation_alert.cancel_button",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Let’s do it!"
  ///
  /// - **en**: "Let’s do it!"
  /// - **de**: "Los gehts!"
  /// - **es**: "¡Manos a la obra!"
  /// - **fr**: "Allons-y !"
  /// - **ja**: "挑戦！"
  public static func dashboard_post_update_preview_confirmation_alert_confirm_button() -> String {
    return localizedString(
      key: "dashboard.post_update.preview.confirmation_alert.confirm_button",
      defaultValue: "Let’s do it!",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Something went wrong."
  ///
  /// - **en**: "Something went wrong."
  /// - **de**: "Da hat etwas nicht geklappt."
  /// - **es**: "Algo pasó aquí."
  /// - **fr**: "Un erreur s'est produite."
  /// - **ja**: "問題が発生しました。"
  public static func dashboard_post_update_preview_confirmation_alert_error_something_wrong() -> String {
    return localizedString(
      key: "dashboard.post_update.preview.confirmation_alert.error.something_wrong",
      defaultValue: "Something went wrong.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This will notify %{backer_count} backers that a new update is available. Are you sure you want to post?"
  ///
  /// - **en**: "This will notify %{backer_count} backers that a new update is available. Are you sure you want to post?"
  /// - **de**: "%{backer_count} Unterstützer werden über das neue Update benachrichtigt. Bist du sicher, dass du es veröffentlichen willst?"
  /// - **es**: "Esto notificará a %{backer_count} patrocinadores que existe una nueva actualización. ¿Seguro de que quieres publicarla?"
  /// - **fr**: "%{backer_count} contributeurs seront prévenus qu'une nouvelle actu est disponible. Publier quand-même ?"
  /// - **ja**: "最新情報を%{backer_count} 人のバッカーに通知します。投稿しますか？"
  public static func dashboard_post_update_preview_confirmation_alert_this_will_notify_backers_that_a_new_update_is_available(backer_count: Int) -> String {
    return localizedString(
      key: "dashboard.post_update.preview.confirmation_alert.this_will_notify_backers_that_a_new_update_is_available",
      defaultValue: "This will notify %{backer_count} backers that a new update is available. Are you sure you want to post?",
      count: backer_count,
      substitutions: ["backer_count": Format.wholeNumber(backer_count)]
    )
  }
  /// "This will notify %{backer_count} backers that a new update is available. Are you sure you want to post?"
  ///
  /// - **en**: "This will notify %{backer_count} backers that a new update is available. Are you sure you want to post?"
  /// - **de**: "%{backer_count} Unterstützer werden über das neue Update benachrichtigt. Bist du sicher, dass du es veröffentlichen willst?"
  /// - **es**: "Esto notificará a %{backer_count} patrocinadores que existe una nueva actualización. ¿Seguro de que quieres publicarla?"
  /// - **fr**: "%{backer_count} contributeurs seront prévenus qu'une nouvelle actu est disponible. Publier quand-même ?"
  /// - **ja**: "最新情報を%{backer_count} 人のバッカーに通知します。投稿しますか？"
  public static func dashboard_post_update_preview_confirmation_alert_this_will_notify_backers_that_a_new_update_is_available_other(backer_count: String) -> String {
    return localizedString(
      key: "dashboard.post_update.preview.confirmation_alert.this_will_notify_backers_that_a_new_update_is_available.other",
      defaultValue: "This will notify %{backer_count} backers that a new update is available. Are you sure you want to post?",
      count: nil,
      substitutions: ["backer_count": backer_count]
    )
  }
  /// "Ready?"
  ///
  /// - **en**: "Ready?"
  /// - **de**: "Bereit?"
  /// - **es**: "¿Listo?"
  /// - **fr**: "Prêt ?"
  /// - **ja**: "準備OK?"
  public static func dashboard_post_update_preview_confirmation_alert_title() -> String {
    return localizedString(
      key: "dashboard.post_update.preview.confirmation_alert.title",
      defaultValue: "Ready?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Backers only"
  ///
  /// - **en**: "Backers only"
  /// - **de**: "Nur für Unterstützer"
  /// - **es**: "Sólo para patrocinadores"
  /// - **fr**: "Contributeurs seulement"
  /// - **ja**: "バッカーのみ"
  public static func dashboard_post_update_privacy_backers_only() -> String {
    return localizedString(
      key: "dashboard.post_update.privacy.backers_only",
      defaultValue: "Backers only",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Public"
  ///
  /// - **en**: "Public"
  /// - **de**: "Öffentlich"
  /// - **es**: "Público"
  /// - **fr**: "Public"
  /// - **ja**: "公開"
  public static func dashboard_post_update_privacy_public() -> String {
    return localizedString(
      key: "dashboard.post_update.privacy.public",
      defaultValue: "Public",
      count: nil,
      substitutions: [:]
    )
  }
}
