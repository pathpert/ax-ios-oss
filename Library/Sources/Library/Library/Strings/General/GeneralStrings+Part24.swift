// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension GeneralStrings {
  /// "Thanks—you’ve successfully verified your email address."
  ///
  /// - **en**: "Thanks—you’ve successfully verified your email address."
  /// - **de**: "Vielen Dank. Deine E-Mail-Adresse wurde erfolgreich verifiziert."
  /// - **es**: "Gracias, verificaste correctamente tu dirección de correo electrónico."
  /// - **fr**: "Merci, votre adresse électronique a bien été vérifiée."
  /// - **ja**: "ありがとうございます。メールアドレスの認証が完了しました。"
  public static func Thanks_youve_successfully_verified_your_email_address() -> String {
    return localizedString(
      key: "Thanks_youve_successfully_verified_your_email_address",
      defaultValue: "Thanks—you’ve successfully verified your email address.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The live stream failed to connect"
  ///
  /// - **en**: "The live stream failed to connect"
  /// - **de**: "Keine Verbindungn zu Live-Stream"
  /// - **es**: "No se pudo conectar la transmisión en directo"
  /// - **fr**: "Échec de connexion à la diffusion en direct"
  /// - **ja**: "ライブ配信に接続できませんでした"
  public static func The_live_stream_failed_to_connect() -> String {
    return localizedString(
      key: "The_live_stream_failed_to_connect",
      defaultValue: "The live stream failed to connect",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The live stream was interrupted"
  ///
  /// - **en**: "The live stream was interrupted"
  /// - **de**: "Live-Stream wurde unterbrochen"
  /// - **es**: "Transmisión en vivo fue interrumpida"
  /// - **fr**: "Diffusion en direct interrompue"
  /// - **ja**: "ライブ配信が中断されました"
  public static func The_live_stream_was_interrupted() -> String {
    return localizedString(
      key: "The_live_stream_was_interrupted",
      defaultValue: "The live stream was interrupted",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The live stream will start soon"
  ///
  /// - **en**: "The live stream will start soon"
  /// - **de**: "Live-Stream started in Kürze"
  /// - **es**: "Transmisión en vivo comienza en breve"
  /// - **fr**: "La diffusion en direct va bientôt commencer"
  /// - **ja**: "ライブ配信が開始します"
  public static func The_live_stream_will_start_soon() -> String {
    return localizedString(
      key: "The_live_stream_will_start_soon",
      defaultValue: "The live stream will start soon",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The live stream will start %{time}."
  ///
  /// - **en**: "The live stream will start %{time}."
  /// - **de**: "Dieser Live-Stream started in %{time}."
  /// - **es**: "Live-Stream comienza en %{time}."
  /// - **fr**: "La diffusion en direct commence dans %{time}."
  /// - **ja**: "%{time} にライブ配信が開始されます。"
  public static func The_live_stream_will_start_time(time: String) -> String {
    return localizedString(
      key: "The_live_stream_will_start_time",
      defaultValue: "The live stream will start %{time}.",
      count: nil,
      substitutions: ["time": time]
    )
  }
  /// "The owners of these works are or will be receiving credit for their work."
  ///
  /// - **en**: "The owners of these works are or will be receiving credit for their work."
  /// - **de**: "Die Eigentümer dieser Werke werden oder wurden namentlich genannt."
  /// - **es**: "Los propietarios de estos trabajos han recibido o recibirán el reconocimiento por su trabajo."
  /// - **fr**: "Les propriétaires de ces œuvres sont ou seront crédités pour leur travail."
  /// - **ja**: "これら作品の所有者はクレジット表記されます（またはその予定です）。"
  public static func The_owners_of_those_works() -> String {
    return localizedString(
      key: "The_owners_of_those_works",
      defaultValue: "The owners of these works are or will be receiving credit for their work.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The replay will start soon"
  ///
  /// - **en**: "The replay will start soon"
  /// - **de**: "Wiedergabe started in Kürze"
  /// - **es**: "Repetición comienza en breve"
  /// - **fr**: "La rediffusion sera bientôt disponible"
  /// - **ja**: "リプレイが始まります"
  public static func The_replay_will_start_soon() -> String {
    return localizedString(
      key: "The_replay_will_start_soon",
      defaultValue: "The replay will start soon",
      count: nil,
      substitutions: [:]
    )
  }
  /// "There is or will be an opt-in or opt-out for those owners."
  ///
  /// - **en**: "There is or will be an opt-in or opt-out for those owners."
  /// - **de**: "Diese Eigentümer werden die Möglichkeit haben, sich für oder gegen die Nutzung ihrer Werke oder Informationen auszusprechen."
  /// - **es**: "Esos propietarios tienen o tendrán la opción de aceptar o no."
  /// - **fr**: "Ces propriétaires se verront proposer un mécanisme d'acceptation ou de refus."
  /// - **ja**: "これら所有者はオプトインまたはオプトアウトのいずれかを選べます。"
  public static func There_is_or_will_be_an_opt() -> String {
    return localizedString(
      key: "There_is_or_will_be_an_opt",
      defaultValue: "There is or will be an opt-in or opt-out for those owners.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "These projects could use your support."
  ///
  /// - **en**: "These projects could use your support."
  /// - **de**: "Diese Projekte könnten mit deiner Unterstützung verwirklicht werden."
  /// - **es**: "A estos proyectos les vendría bien tu apoyo."
  /// - **fr**: "Ces créateurs ont besoin de vous."
  /// - **ja**: "こちらのプロジェクト達があなたのサポートを待っています！"
  public static func These_projects_could_use_your_support() -> String {
    return localizedString(
      key: "These_projects_could_use_your_support",
      defaultValue: "These projects could use your support.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This is meant to give you an idea of what shipping might cost. Once the creator is ready to fulfill your reward, you’ll return to pay shipping and applicable taxes."
  ///
  /// - **en**: "This is meant to give you an idea of what shipping might cost. Once the creator is ready to fulfill your reward, you’ll return to pay shipping and applicable taxes."
  /// - **de**: "Das soll dir eine Vorstellung von den Versandkosten geben. Nachdem der Projektgründer bereit ist, deine Belohnung zu erfüllen, kannst du hier die Versandkosten und anfallende Steuern bezahlen."
  /// - **es**: "Te da una idea del costo del envío. Una vez que el creador esté listo para entregar la recompensa, volverás aquí para pagar el envío y los impuestos aplicables."
  /// - **fr**: "Cette donnée vous donne une idée des frais de port. Une fois que le créateur sera prêt à livrer votre récompense, vous reviendrez sur Kickstarter pour vous acquitter des frais de port et des taxes applicables."
  /// - **ja**: "この合計額は送料のおおよその金額を見積もったものです。クリエイター側でリワードの配送準備が整った際に、こちらに戻り送料と適用される税金をお支払いいただきます。"
  public static func This_is_meant_to_give_you() -> String {
    return localizedString(
      key: "This_is_meant_to_give_you",
      defaultValue: "This is meant to give you an idea of what shipping might cost. Once the creator is ready to fulfill your reward, you’ll return to pay shipping and applicable taxes.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This may involve submitting a delivery address, selecting your item preferences, answering survey questions, and/or paying for shipping or taxes."
  ///
  /// - **en**: "This may involve submitting a delivery address, selecting your item preferences, answering survey questions, and/or paying for shipping or taxes."
  /// - **de**: "Dazu musst du möglicherweise eine Versandadresse angeben, eine Auswahl für deinen Artikel treffen, die Befragung ausfüllen und/oder Versandkosten oder Steuern bezahlen."
  /// - **es**: "Podrías tener que indicar la dirección de entrega, seleccionar tus preferencias respecto a los artículos, responder preguntas del cuestionario o pagar los costos de envío o impuestos."
  /// - **fr**: "Il pourra vous être demandé de fournir votre adresse de livraison, de choisir vos composantes, de répondre à des questions ou encore de régler vos frais de port ou vos taxes."
  /// - **ja**: "これには、配送先の入力、アイテムの選択、サーベイへの回答、そして送料や税金の支払いが含まれる場合があります。"
  public static func This_may_involve_submitting_a_delivery_address() -> String {
    return localizedString(
      key: "This_may_involve_submitting_a_delivery_address",
      defaultValue: "This may involve submitting a delivery address, selecting your item preferences, answering survey questions, and/or paying for shipping or taxes.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This post is for backers only"
  ///
  /// - **en**: "This post is for backers only"
  /// - **de**: "Dieser Beitrag ist nur für Unterstützer"
  /// - **es**: "Esta publicación es únicamente para patrocinadores"
  /// - **fr**: "Cette publication est réservée aux contributeurs."
  /// - **ja**: "この投稿はバッカー向けです"
  public static func This_post_is_for_backers_only() -> String {
    return localizedString(
      key: "This_post_is_for_backers_only",
      defaultValue: "This post is for backers only",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This user has been blocked"
  ///
  /// - **en**: "This user has been blocked"
  /// - **de**: "Dieser Nutzer wurde blockiert"
  /// - **es**: "Este usuario se bloqueó."
  /// - **fr**: "Cet utilisateur a été bloqué."
  /// - **ja**: "このユーザーはブロックされました"
  public static func This_user_has_been_blocked() -> String {
    return localizedString(
      key: "This_user_has_been_blocked",
      defaultValue: "This user has been blocked",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{time_left} left"
  ///
  /// - **en**: "%{time_left} left"
  /// - **de**: "%{time_left} übrig"
  /// - **es**: "%{time_left} restantes"
  /// - **fr**: "Plus que %{time_left}"
  /// - **ja**: "あと%{time_left}"
  public static func Time_left_left(time_left: String) -> String {
    return localizedString(
      key: "Time_left_left",
      defaultValue: "%{time_left} left",
      count: nil,
      substitutions: ["time_left": time_left]
    )
  }
  /// "to learn how Kickstarter encourages sustainable practices."
  ///
  /// - **en**: "to learn how Kickstarter encourages sustainable practices."
  /// - **de**: "um mehr über die von Kickstarter empfohlenen Umweltschutzmaßnahmen zu erfahren."
  /// - **es**: "para conocer cómo Kickstarter incentiva las prácticas sustentables."
  /// - **fr**: "pour mieux comprendre en quoi Kickstarter encourage les pratiques durables."
  /// - **ja**: "して、Kickstarter がどのようにして持続可能なプロジェクトを促進しているか、その様子をチェックしてみてください。"
  public static func To_learn_how_Kickstarter_encourages_sustainable_practices() -> String {
    return localizedString(
      key: "To_learn_how_Kickstarter_encourages_sustainable_practices",
      defaultValue: "to learn how Kickstarter encourages sustainable practices.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Toggle saving this project"
  ///
  /// - **en**: "Toggle saving this project"
  /// - **de**: "Umschalten zu Projekt speichern"
  /// - **es**: "Guardar/No guardar este proyecto"
  /// - **fr**: "Enregistrer / ne pas enregistrer ce projet"
  /// - **ja**: "プロジェクトを保存"
  public static func Toggle_saving_this_project() -> String {
    return localizedString(
      key: "Toggle_saving_this_project",
      defaultValue: "Toggle saving this project",
      count: nil,
      substitutions: [:]
    )
  }
}
