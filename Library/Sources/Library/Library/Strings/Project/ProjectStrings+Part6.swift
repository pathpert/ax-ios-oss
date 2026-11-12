// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension ProjectStrings {
  /// "Thanks for bringing this project one step closer to becoming a reality."
  ///
  /// - **en**: "Thanks for bringing this project one step closer to becoming a reality."
  /// - **de**: "Dank deiner Unterstützung ist dieses Projekt seiner Verwirklichung einen Schritt näher."
  /// - **es**: "Gracias por llevar este proyecto un paso más cerca de convertirse en realidad."
  /// - **fr**: "Grâce à votre soutien, ce créateur se rapproche un peu plus de son objectif."
  /// - **ja**: "ありがとうございます！プロジェクトの実現に一歩近づきました。"
  public static func Thanks_for_bringing_this_project_one_step_closer_to_becoming_a_reality() -> String {
    return localizedString(
      key: "Thanks_for_bringing_this_project_one_step_closer_to_becoming_a_reality",
      defaultValue: "Thanks for bringing this project one step closer to becoming a reality.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The creator has not collected your address. Please contact them to resolve the issue."
  ///
  /// - **en**: "The creator has not collected your address. Please contact them to resolve the issue."
  /// - **de**: "Der Projektgründer hat deine Adresse nicht erfasst. Bitte kontaktiere ihn, um das Problem zu lösen."
  /// - **es**: "El creador no recopiló tu dirección. Contáctalo para resolver el problema."
  /// - **fr**: "Le créateur n'a pas récupéré votre adresse. Veuillez le contacter pour résoudre ce problème."
  /// - **ja**: "クリエイターがまだあなたの住所を収集していません。クリエイターに連絡して、この問題を解決してください。"
  public static func The_creator_has_not_collected_your_address_please_contact_them_to_resolve_the_issue() -> String {
    return localizedString(
      key: "The_creator_has_not_collected_your_address_please_contact_them_to_resolve_the_issue",
      defaultValue: "The creator has not collected your address. Please contact them to resolve the issue.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The first charge will occur when the project ends successfully, then every 2 weeks until fully paid. When this option is selected no further edits can be made to your pledge."
  ///
  /// - **en**: "The first charge will occur when the project ends successfully, then every 2 weeks until fully paid. When this option is selected no further edits can be made to your pledge."
  /// - **de**: "Die erste Rate wird nach erfolgreichem Ende des Projekts eingezogen. Die weiteren Raten werden alle 2 Wochen eingezogen, bis der Finanzierungsbeitrag komplett bezahlt wurde. Wenn du dich für diese Option entscheidest, kannst du keine weiteren Änderungen an deinem Beitrag vornehmen."
  /// - **es**: "El primer pago se hará cuando el proyecto finalice con éxito, luego cada 2 semanas hasta el monto total de la contribución. Cuando se selecciona esta opción, no se pueden realizar más modificaciones en tu contribución."
  /// - **fr**: "Le premier prélèvement interviendra après la fin de la campagne, si l'objectif de celle-ci est atteint. Les prélèvements suivants auront lieu toutes les deux semaines, jusqu'au règlement intégral du montant dû. Si vous sélectionnez cette option, votre engagement devient non modifiable."
  /// - **ja**: "最初の請求はプロジェクトが成功裏に終わった時点で行われます。その後は全額が支払われるまで、2週間おきに請求が行われます。このオプションを選択すると、その後はプレッジを編集することはできなくなります。"
  public static func The_first_charge_will_occur_when_the_project_ends_successfully() -> String {
    return localizedString(
      key: "The_first_charge_will_occur_when_the_project_ends_successfully",
      defaultValue: "The first charge will occur when the project ends successfully, then every 2 weeks until fully paid. When this option is selected no further edits can be made to your pledge.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This comment has been removed by Kickstarter."
  ///
  /// - **en**: "This comment has been removed by Kickstarter."
  /// - **de**: "Dieser Kommentar wurde von Kickstarter entfernt."
  /// - **es**: "Este comentario ha sido eliminado por Kickstarter."
  /// - **fr**: "Ce commentaire a été supprimé par Kickstarter."
  /// - **ja**: "このコメントは Kickstarter によって削除されました。"
  public static func This_comment_has_been_removed_by_Kickstarter() -> String {
    return localizedString(
      key: "This_comment_has_been_removed_by_Kickstarter",
      defaultValue: "This comment has been removed by Kickstarter.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This comment has been removed for violating <a href="%{community_guidelines}">Kickstarter’s Community Guidelines.</a>"
  ///
  /// - **en**: "This comment has been removed for violating <a href="%{community_guidelines}">Kickstarter’s Community Guidelines.</a>"
  /// - **de**: "Dieser Kommentar wurde entfernt, weil er gegen die <a href="%{community_guidelines}">Community-Richtlinien von Kickstarter</a> verstößt"
  /// - **es**: "Este comentario se ha eliminado por infringir las <a href="%{community_guidelines}">reglas de la comunidad de Kickstarter</a>."
  /// - **fr**: "Ce commentaire a été supprimé pour manquement aux <a href="%{community_guidelines}">Règles de bonne conduite de Kickstarter</a>."
  /// - **ja**: "このコメントは <a href="%{community_guidelines}">Kickstarter のコミュニティガイドライン</a>に違反しているため削除されました。"
  public static func This_comment_has_been_removed_for_violating_kickstarters_community_guidelines(community_guidelines: String) -> String {
    return localizedString(
      key: "This_comment_has_been_removed_for_violating_kickstarters_community_guidelines",
      defaultValue: "This comment has been removed for violating <a href=\"%{community_guidelines}\">Kickstarter’s Community Guidelines.</a>",
      count: nil,
      substitutions: ["community_guidelines": community_guidelines]
    )
  }
  /// "This comment is under review."
  ///
  /// - **en**: "This comment is under review."
  /// - **de**: "Dieser Kommentar wird gerade überprüft."
  /// - **es**: "Este comentario está en revisión."
  /// - **fr**: "Ce commentaire est en cours de vérification."
  /// - **ja**: "このコメントは現在審査中です。"
  public static func This_comment_is_under_review() -> String {
    return localizedString(
      key: "This_comment_is_under_review",
      defaultValue: "This comment is under review.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "This comment is under review for potentially violating <a href="%{community_guidelines}">Kickstarter’s Community Guidelines.</a>"
  ///
  /// - **en**: "This comment is under review for potentially violating <a href="%{community_guidelines}">Kickstarter’s Community Guidelines.</a>"
  /// - **de**: "Dieser Kommentar wird gerade geprüft, weil er möglicherweise gegen die <a href="%{community_guidelines}">Community-Richtlinien von Kickstarter</a> verstößt."
  /// - **es**: "Este comentario está en revisión por una posible infracción de las <a href="%{community_guidelines}">Reglas de la comunidad de Kickstarter.</a>"
  /// - **fr**: "Ce commentaire est en cours d'examen pour manquement possible aux <a href="%{community_guidelines}">Règles de bonne conduite de Kickstarter.</a>"
  /// - **ja**: "このコメントは <a href="%{community_guidelines}">Kickstarter のコミュニティガイドライン</a>に違反している可能性があるとして現在審査中です。"
  public static func This_comment_is_under_review_for_potentially_violating_kickstarters_community_guidelines(community_guidelines: String) -> String {
    return localizedString(
      key: "This_comment_is_under_review_for_potentially_violating_kickstarters_community_guidelines",
      defaultValue: "This comment is under review for potentially violating <a href=\"%{community_guidelines}\">Kickstarter’s Community Guidelines.</a>",
      count: nil,
      substitutions: ["community_guidelines": community_guidelines]
    )
  }
  /// "This project breaks one of Our Rules."
  ///
  /// - **en**: "This project breaks one of Our Rules."
  /// - **de**: "Dieses Projekt verstößt gegen eine unserer Regeln."
  /// - **es**: "Este proyecto incumple una de nuestras reglas."
  /// - **fr**: "Ce projet ne respecte pas nos règles."
  /// - **ja**: "このプロジェクトは Kickstarter のルールの 1 つに違反しています。"
  public static func This_project_breaks() -> String {
    return localizedString(
      key: "This_project_breaks",
      defaultValue: "This project breaks one of Our Rules.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "To read this project update, you must be a backer. Please log in or sign up to continue."
  ///
  /// - **en**: "To read this project update, you must be a backer. Please log in or sign up to continue."
  /// - **de**: "Um diesen Update zum Projekt lesen zu können, musst du ein Unterstützer dieses Projekts sein. Bitte melde dich an oder registriere dich."
  /// - **es**: "Sólo los patrocinadores pueden leer esta actualización, por favor inicia sesión o regístrate para continuar."
  /// - **fr**: "Seuls les contributeurs ont accès à cette actu de projet. Connectez-vous ou inscrivez-vous pour continuer."
  /// - **ja**: "このアップデートはバッカー専用です。 続行するにはログインまたはサインアップしてください。"
  public static func To_read_this_project_update_you_must_be_a_backer() -> String {
    return localizedString(
      key: "To_read_this_project_update_you_must_be_a_backer",
      defaultValue: "To read this project update, you must be a backer. Please log in or sign up to continue.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Upcoming with<br/><b>%{creator_name}</b>"
  ///
  /// - **en**: "Upcoming with<br/><b>%{creator_name}</b>"
  /// - **de**: "Demnächst: Video von <br/><b>%{creator_name}</b>"
  /// - **es**: "Próximamente: Video de <br/><b>%{creator_name}</b>"
  /// - **fr**: "<br/><b>%{creator_name}</b> bientôt en direct"
  /// - **ja**: "<br/><b>%{creator_name}</b>が近日配信"
  public static func Upcoming_with_creator_name(creator_name: String) -> String {
    return localizedString(
      key: "Upcoming_with_creator_name",
      defaultValue: "Upcoming with<br/><b>%{creator_name}</b>",
      count: nil,
      substitutions: ["creator_name": creator_name]
    )
  }
  /// "We won’t share this with the creator."
  ///
  /// - **en**: "We won’t share this with the creator."
  /// - **de**: "Diese Information wird nicht mit dem Projektgründer geteilt."
  /// - **es**: "No lo compartiremos con el creador."
  /// - **fr**: "Le créateur ne verra pas votre réponse."
  /// - **ja**: "これはクリエイターには共有されません。"
  public static func We_wont_share_this_with_the_creator() -> String {
    return localizedString(
      key: "We_wont_share_this_with_the_creator",
      defaultValue: "We won’t share this with the creator.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "We'll help you find a project to back."
  ///
  /// - **en**: "We'll help you find a project to back."
  /// - **de**: "Wir helfen dir dabei, Projekte nach deinem Geschmack zu finden."
  /// - **es**: "Te ayudaremos a encontrar un proyecto para patrocinar."
  /// - **fr**: "Nous sommes là pour vous aider à trouver un projet."
  /// - **ja**: "ぜひあなたがバックしたいと思えるプロジェクトを見つけましょう。"
  public static func Well_help_you_find_a_project_to_back() -> String {
    return localizedString(
      key: "Well_help_you_find_a_project_to_back",
      defaultValue: "We'll help you find a project to back.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "What parts of your project will use AI-generated content? Please be as specific as possible."
  ///
  /// - **en**: "What parts of your project will use AI-generated content? Please be as specific as possible."
  /// - **de**: "Bei welchen Teilen deines Projekts kommen KI-generierte Inhalte zum Einsatz? Bitte beantworte die Frage so konkret wie möglich."
  /// - **es**: "¿Qué partes de tu proyecto utilizarán contenido generado por IA? Responde con la mayor precisión posible."
  /// - **fr**: "Pour quelles parties de votre projet utiliserez-vous ce contenu généré par IA ? Veuillez être aussi précis que possible."
  /// - **ja**: "プロジェクトのどの部分で AI 生成のコンテンツを使用しますか？できるだけ詳しく説明してください。"
  public static func What_parts_of_your_project_will_use_AI_generated_content() -> String {
    return localizedString(
      key: "What_parts_of_your_project_will_use_AI_generated_content",
      defaultValue: "What parts of your project will use AI-generated content? Please be as specific as possible.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When you save a project we’ll send you a reminder 48 hours before it ends"
  ///
  /// - **en**: "When you save a project we’ll send you a reminder 48 hours before it ends"
  /// - **de**: "Wenn du ein Projekt speicherst, senden wir dir 48 Stunden vor Ablauf eine Erinnerungs-E-Mail"
  /// - **es**: "Cuando guardes un proyecto, te enviaremos un recordatorio por correo electrónico 48 horas antes de que finalice"
  /// - **fr**: "Pour chaque projet que vous enregistrez, nous vous enverrons un rappel 48 heures avant la fin de sa campagne."
  /// - **ja**: "プロジェクトを保存し、終了の48時間前にリマインドする。"
  public static func When_you_save_a_project_we_ll_send_you_a_reminder() -> String {
    return localizedString(
      key: "When_you_save_a_project_we_ll_send_you_a_reminder",
      defaultValue: "When you save a project we’ll send you a reminder 48 hours before it ends",
      count: nil,
      substitutions: [:]
    )
  }
  /// "When you’ve backed a project, it’ll show up here."
  ///
  /// - **en**: "When you’ve backed a project, it’ll show up here."
  /// - **de**: "Hier werden Projekte angezeigt, die du unterstützt hast."
  /// - **es**: "Verás aquí los proyectos que hayas patrocinado."
  /// - **fr**: "Vos engagements à venir apparaîtront ici."
  /// - **ja**: "プロジェクトをバック(支援)するとここに表示されます。"
  public static func When_youve_backed_a_project_itll_show_up_here() -> String {
    return localizedString(
      key: "When_youve_backed_a_project_itll_show_up_here",
      defaultValue: "When you’ve backed a project, it’ll show up here.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Write a comment..."
  ///
  /// - **en**: "Write a comment..."
  /// - **de**: "Hinterlasse einen Kommentar ..."
  /// - **es**: "Escribe un comentario..."
  /// - **fr**: "Rédiger un commentaire..."
  /// - **ja**: "コメントを残す..."
  public static func Write_a_comment() -> String {
    return localizedString(
      key: "Write_a_comment",
      defaultValue: "Write a comment...",
      count: nil,
      substitutions: [:]
    )
  }
}
