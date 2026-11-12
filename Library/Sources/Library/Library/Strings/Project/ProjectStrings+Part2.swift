// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "Creator"
  ///
  /// - **en**: "Creator"
  /// - **de**: "Projektgründer"
  /// - **es**: "Creador"
  /// - **fr**: "Créateur"
  /// - **ja**: "クリエイター"
  public static func Creator() -> String {
    return localizedString(
      key: "Creator",
      defaultValue: "Creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "<b>%{creator_name}</b> is live now"
  ///
  /// - **en**: "<b>%{creator_name}</b> is live now"
  /// - **de**: "<b>%{creator_name}</b> ist jetzt live"
  /// - **es**: "<b>%{creator_name}</b> está transmitiendo en vivo"
  /// - **fr**: "<b>%{creator_name}</b> est en direct en ce moment"
  /// - **ja**: "<b>%{creator_name}</b>が進行中"
  public static func Creator_name_is_live_now(creator_name: String) -> String {
    return localizedString(
      key: "Creator_name_is_live_now",
      defaultValue: "<b>%{creator_name}</b> is live now",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "%{creator_name} is streaming live on Kickstarter"
  ///
  /// - **en**: "%{creator_name} is streaming live on Kickstarter"
  /// - **de**: "%{creator_name} streamt gerade live auf Kickstarter"
  /// - **es**: "%{creator_name} está transmitiendo en vivo en Kickstarter"
  /// - **fr**: "%{creator_name} est en direct sur Kickstarter"
  /// - **ja**: "%{creator_name} がKickstarterでライブ配信中"
  public static func Creator_name_is_streaming_live_on_Kickstarter(creator_name: String) -> String {
    return localizedString(
      key: "Creator_name_is_streaming_live_on_Kickstarter",
      defaultValue: "%{creator_name} is streaming live on Kickstarter",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "<b>%{creator_name}</b> live streamed %{time_ago}"
  ///
  /// - **en**: "<b>%{creator_name}</b> live streamed %{time_ago}"
  /// - **de**: "<b>%{creator_name}</b> war vor %{time_ago} im Live-Stream"
  /// - **es**: "<b>%{creator_name}</b> transmitió en vivo hace %{time_ago}"
  /// - **fr**: "<b>%{creator_name}</b> a fait une diffusion en direct %{time_ago}"
  /// - **ja**: "<b>%{creator_name}</b>は%{time_ago} 前にライブ配信を行いました"
  public static func Creator_name_live_streamed_time_ago(creator_name: String, time_ago: String) -> String {
    return localizedString(
      key: "Creator_name_live_streamed_time_ago",
      defaultValue: "<b>%{creator_name}</b> live streamed %{time_ago}",
      count: nil,
      substitutions: ["creator_name": creator_name, "time_ago": time_ago]
    )
  }
  /// "<b>%{creator_name}</b> was live %{time_ago}"
  ///
  /// - **en**: "<b>%{creator_name}</b> was live %{time_ago}"
  /// - **de**: "<b>%{creator_name}</b> war vor %{time_ago} live"
  /// - **es**: "<b>%{creator_name}</b> transmitió en vivo hace %{time_ago}"
  /// - **fr**: "<b>%{creator_name}</b> était en direct %{time_ago}"
  /// - **ja**: "<b>%{creator_name}</b>は%{time_ago} まで進行中でした"
  public static func Creator_name_was_live_time_ago(creator_name: String, time_ago: String) -> String {
    return localizedString(
      key: "Creator_name_was_live_time_ago",
      defaultValue: "<b>%{creator_name}</b> was live %{time_ago}",
      count: nil,
      substitutions: ["creator_name": creator_name, "time_ago": time_ago]
    )
  }
  /// "%{creator_name} was streaming live on Kickstarter"
  ///
  /// - **en**: "%{creator_name} was streaming live on Kickstarter"
  /// - **de**: "Der Stream von %{creator_name} war gerade live auf Kickstarter"
  /// - **es**: "%{creator_name} estuvo transmitiendo en vivo en Kickstarter"
  /// - **fr**: "%{creator_name} était en direct sur Kickstarter"
  /// - **ja**: "%{creator_name} はライブ配信を行いました"
  public static func Creator_name_was_streaming_live_on_Kickstarter(creator_name: String) -> String {
    return localizedString(
      key: "Creator_name_was_streaming_live_on_Kickstarter",
      defaultValue: "%{creator_name} was streaming live on Kickstarter",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "%{creator_name} will be streaming live on Kickstarter %{in_duration}"
  ///
  /// - **en**: "%{creator_name} will be streaming live on Kickstarter %{in_duration}"
  /// - **de**: "%{creator_name} wird in %{in_duration} live auf Kickstarter streamen"
  /// - **es**: "%{creator_name} estará trasnmitiendo en vivo en Kickstarter %{in_duration}"
  /// - **fr**: "%{creator_name} sera en direct sur Kickstarter %{in_duration}"
  /// - **ja**: "%{creator_name} は%{in_duration} にライブ配信を行います"
  public static func Creator_name_will_be_streaming_live_on_Kickstarter_in_duration(creator_name: String, in_duration: String) -> String {
    return localizedString(
      key: "Creator_name_will_be_streaming_live_on_Kickstarter_in_duration",
      defaultValue: "%{creator_name} will be streaming live on Kickstarter %{in_duration}",
      count: nil,
      substitutions: ["creator_name": creator_name, "in_duration": in_duration]
    )
  }
  /// "Creator tips"
  ///
  /// - **en**: "Creator tips"
  /// - **de**: "Tpps für Projektgründer"
  /// - **es**: "Consejos para el creador"
  /// - **fr**: "Astuces pour créateurs"
  /// - **ja**: "アドバイス"
  public static func Creator_tips() -> String {
    return localizedString(
      key: "Creator_tips",
      defaultValue: "Creator tips",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Creators must be transparent and honest in documenting their prototype. Photorealistic renderings are not permitted."
  ///
  /// - **en**: "Creators must be transparent and honest in documenting their prototype. Photorealistic renderings are not permitted."
  /// - **de**: "Bei der Dokumentation eines Prototypen wird Transparenz und Ehrlichkeit vom Projektgründer erwartet. Fotorealistische Darstellungen sind nicht gestattet."
  /// - **es**: "Los creadores deben ser transparentes y honestos al documentar el prototipo. Las representaciones fotorrealistas no están permitidas."
  /// - **fr**: "On demande aux créateurs de faire preuve de transparence et d'honnêteté dans la description de leur prototype. Les rendus photoréalistes sont donc interdits."
  /// - **ja**: "クリエイターはプロトタイプについて透明性の高い正直な説明を行う必要があります。フォトリアリスティックレンダリング (写実的レンダリング：実写と区別がつかないような写実的な画像の生成) は禁止されています。"
  public static func Creators_must_be_transparent() -> String {
    return localizedString(
      key: "Creators_must_be_transparent",
      defaultValue: "Creators must be transparent and honest in documenting their prototype. Photorealistic renderings are not permitted.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Failed to update subscription"
  ///
  /// - **en**: "Failed to update subscription"
  /// - **de**: "Abo konnte nicht aktualisiert werden"
  /// - **es**: "No se pudo actualizar la suscripción"
  /// - **fr**: "Mise à jour de l'abonnement impossible"
  /// - **ja**: "定期購読の更新に失敗しました"
  public static func Failed_to_update_subscription() -> String {
    return localizedString(
      key: "Failed_to_update_subscription",
      defaultValue: "Failed to update subscription",
      count: nil,
      substitutions: [:]
    )
  }
  /// "FAQ"
  ///
  /// - **en**: "FAQ"
  /// - **de**: "FAQ"
  /// - **es**: "Preguntas frecuentes"
  /// - **fr**: "FAQ"
  /// - **ja**: "FAQ"
  public static func Faq() -> String {
    return localizedString(
      key: "Faq",
      defaultValue: "FAQ",
      count: nil,
      substitutions: [:]
    )
  }
  /// "First-time creator"
  ///
  /// - **en**: "First-time creator"
  /// - **de**: "Erstmaliger Projektgründer"
  /// - **es**: "Creador novato"
  /// - **fr**: "Nouveau créateur"
  /// - **ja**: "初めてのクリエイター"
  public static func First_time_creator() -> String {
    return localizedString(
      key: "First_time_creator",
      defaultValue: "First-time creator",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Get notified about this creator’s live streams"
  ///
  /// - **en**: "Get notified about this creator’s live streams"
  /// - **de**: "Benachrichtigungen zu den Live-Streams dieses Projektgründers erhalten."
  /// - **es**: "Recibe notificaciones sobre los Live Streams de este creador"
  /// - **fr**: "Envoyez-moi des notifications au sujet des diffusions en direct de ce créateur."
  /// - **ja**: "このクリエイターのライブ配信通知を受け取る"
  public static func Get_notified_about_this_creators_live_streams() -> String {
    return localizedString(
      key: "Get_notified_about_this_creators_live_streams",
      defaultValue: "Get notified about this creator’s live streams",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Go to project page"
  ///
  /// - **en**: "Go to project page"
  /// - **de**: "Zu Projektseite"
  /// - **es**: "Ir a la página de proyecto"
  /// - **fr**: "Accéder à la page de projet"
  /// - **ja**: "プロジェクトページを見る"
  public static func Go_to_project_page() -> String {
    return localizedString(
      key: "Go_to_project_page",
      defaultValue: "Go to project page",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Guide creators to success"
  ///
  /// - **en**: "Guide creators to success"
  /// - **de**: "Verhelfe Projekgründern zum Erfolg"
  /// - **es**: "Conduce a los creadores al éxito"
  /// - **fr**: "Accompagnez un créateur vers le succès"
  /// - **ja**: "クリエイターを成功に導こう"
  public static func Guide_creators_to_success() -> String {
    return localizedString(
      key: "Guide_creators_to_success",
      defaultValue: "Guide creators to success",
      count: nil,
      substitutions: [:]
    )
  }
  /// "If the project reaches its funding goal, the first charge of %{amount} will be collected on %{project_deadline}."
  ///
  /// - **en**: "If the project reaches its funding goal, the first charge of %{amount} will be collected on %{project_deadline}."
  /// - **de**: "Wenn das Projekt sein Finanzierungsziel erreicht, wird die erste Rate in Höhe von %{amount} am %{project_deadline} eingezogen."
  /// - **es**: "Si el proyecto alcanza la meta, el primer cargo de %{amount} se cobrará el %{project_deadline}."
  /// - **fr**: "Si l'objectif de financement du projet est atteint, le premier prélèvement de %{amount} sera effectué le %{project_deadline}."
  /// - **ja**: "プロジェクトがファンディングゴールに到達すると、バッカーへの最初の請求（%{amount}）が%{project_deadline}に行われます。"
  public static func If_the_project_reaches_its_funding_goal_the_first_charge_will_be_collected_on_project_deadline(amount: String, project_deadline: String) -> String {
    return localizedString(
      key: "If_the_project_reaches_its_funding_goal_the_first_charge_will_be_collected_on_project_deadline",
      defaultValue: "If the project reaches its funding goal, the first charge of %{amount} will be collected on %{project_deadline}.",
      count: nil,
      substitutions: ["amount": amount, "project_deadline": project_deadline]
    )
  }
}
