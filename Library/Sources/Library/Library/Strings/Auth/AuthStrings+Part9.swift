// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension AuthStrings {
  /// "Email"
  ///
  /// - **en**: "Email"
  /// - **de**: "E-Mail"
  /// - **es**: "Correo electrónico"
  /// - **fr**: "E-mail"
  /// - **ja**: "Eメール"
  public static func signup_input_fields_email() -> String {
    return localizedString(
      key: "signup.input_fields.email",
      defaultValue: "Email",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Full name"
  ///
  /// - **en**: "Full name"
  /// - **de**: "Vollständiger Name"
  /// - **es**: "Nombre completo"
  /// - **fr**: "Nom complet"
  /// - **ja**: "フルネーム"
  public static func signup_input_fields_full_name() -> String {
    return localizedString(
      key: "signup.input_fields.full_name",
      defaultValue: "Full name",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Password"
  ///
  /// - **en**: "Password"
  /// - **de**: "Passwort"
  /// - **es**: "Contraseña"
  /// - **fr**: "Mot de passe"
  /// - **ja**: "パスワード"
  public static func signup_input_fields_password() -> String {
    return localizedString(
      key: "signup.input_fields.password",
      defaultValue: "Password",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Password (minimum 6 characters)"
  ///
  /// - **en**: "Password (minimum 6 characters)"
  /// - **de**: "Passwort (mindestens 6 Zeichen)"
  /// - **es**: "Clave (mínimo 6 caracteres)"
  /// - **fr**: "Mot de passe (6 caractères minimum)"
  /// - **ja**: "パスワード(６文字以上)"
  public static func signup_input_fields_password_min_characters() -> String {
    return localizedString(
      key: "signup.input_fields.password_min_characters",
      defaultValue: "Password (minimum 6 characters)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sign up"
  ///
  /// - **en**: "Sign up"
  /// - **de**: "Registrieren"
  /// - **es**: "Registrar"
  /// - **fr**: "Inscription"
  /// - **ja**: "サインアップ"
  public static func signup_navbar_title() -> String {
    return localizedString(
      key: "signup.navbar_title",
      defaultValue: "Sign up",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Receive Kickstarter's weekly newsletter and other occasional updates by email. You can opt out of these messages at any time by using the link in the email and as otherwise set out in our Privacy Policy."
  ///
  /// - **en**: "Receive Kickstarter's weekly newsletter and other occasional updates by email. You can opt out of these messages at any time by using the link in the email and as otherwise set out in our Privacy Policy."
  /// - **de**: "Du erhältst den wöchentlichen Kickstarter Newsletter und sporadische Updates per E-Mail. Du kannst diese E-Mails jederzeit über den in der E-Mail enthaltenen Link oder wie in unseren Datenschutzrichtlinien dargelegt abwählen."
  /// - **es**: "Recibe el boletín semanal de Kickstarter y otras actualizaciones ocasionales por correo electrónico. Puedes optar por dejar de recibir estos mensajes en cualquier momento utilizando el enlace incluido en el correo electrónico y según lo establecido en nuestra Política de privacidad."
  /// - **fr**: "Vous recevrez la lettre d'information hebdomadaire de Kickstarter et d'autres actualités, par e-mail. Vous pouvez vous désabonner de ces messages à tout moment en cliquant sur le lien contenu dans chaque e-mail ou en suivant les instructions de notre Politique de confidentialité."
  /// - **ja**: "Kickstarter の週刊ニュースレーターや更新情報をメールでお届けします。このような Kickstarter からのお知らせメールを受け取りたくない場合は、そのメール内に記載されているリンクを使うか、プライバシーポリシーに記載されている方法で、いつでも配信を停止することができます。"
  public static func signup_newsletter_full_opt_out() -> String {
    return localizedString(
      key: "signup.newsletter_full_opt_out",
      defaultValue: "Receive Kickstarter's weekly newsletter and other occasional updates by email. You can opt out of these messages at any time by using the link in the email and as otherwise set out in our Privacy Policy.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Connect with Facebook to follow friends and get notified when they back or launch projects."
  ///
  /// - **en**: "Connect with Facebook to follow friends and get notified when they back or launch projects."
  /// - **de**: "Verknüpfe dein Konto mit Facebook - du kannst deinen Freunden folgen und wirst benachrichtigt, wenn sie ein Projekt veröffentlichen oder unterstützen."
  /// - **es**: "Conéctate via Facebook y sigue a tus amigos - ¡te avisaremos cada vez que publican o patrocinan un proyecto!"
  /// - **fr**: "Connectez-vous avec votre compte Facebook pour suivre vos amis et recevoir une notification chaque fois qu'ils soutiennent ou lancent un nouveau projet."
  /// - **ja**: "Facebookとリンクさせ、Kickstarterでの友達の動向を知りましょう！"
  public static func social_following_header_connect_with_facebook_to_follow() -> String {
    return localizedString(
      key: "social_following.header.connect_with_facebook_to_follow",
      defaultValue: "Connect with Facebook to follow friends and get notified when they back or launch projects.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Log in"
  ///
  /// - **en**: "Log in"
  /// - **de**: "Anmelden"
  /// - **es**: "Iniciar sesión"
  /// - **fr**: "Connexion"
  /// - **ja**: "ログイン"
  public static func tabbar_login() -> String {
    return localizedString(
      key: "tabbar.login",
      defaultValue: "Log in",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Resend"
  ///
  /// - **en**: "Resend"
  /// - **de**: "Erneut senden"
  /// - **es**: "Volver a enviar"
  /// - **fr**: "Renvoyer"
  /// - **ja**: "再送する"
  public static func two_factor_buttons_resend() -> String {
    return localizedString(
      key: "two_factor.buttons.resend",
      defaultValue: "Resend",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Submit"
  ///
  /// - **en**: "Submit"
  /// - **de**: "Absenden"
  /// - **es**: "Enviar"
  /// - **fr**: "Envoyer"
  /// - **ja**: "提出する"
  public static func two_factor_buttons_submit() -> String {
    return localizedString(
      key: "two_factor.buttons.submit",
      defaultValue: "Submit",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Enter code"
  ///
  /// - **en**: "Enter code"
  /// - **de**: "Code eingeben"
  /// - **es**: "Ingresar código"
  /// - **fr**: "Saisir le code"
  /// - **ja**: "認証コードを入力"
  public static func two_factor_code_placeholder() -> String {
    return localizedString(
      key: "two_factor.code_placeholder",
      defaultValue: "Enter code",
      count: nil,
      substitutions: [:]
    )
  }
  /// "The code provided does not match."
  ///
  /// - **en**: "The code provided does not match."
  /// - **de**: "Dieser Code ist ungültig."
  /// - **es**: "Este código no existe."
  /// - **fr**: "Le code fourni ne correspond pas."
  /// - **ja**: "認証高度が一致しません。"
  public static func two_factor_error_message() -> String {
    return localizedString(
      key: "two_factor.error.message",
      defaultValue: "The code provided does not match.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Please enter your verification code to continue."
  ///
  /// - **en**: "Please enter your verification code to continue."
  /// - **de**: "Bitte gebe deinen Verifizierungscode ein, um fortzufahren."
  /// - **es**: "Por favor ingresa tu código de verificación para poder continuar."
  /// - **fr**: "Veuillez saisir votre code de vérification."
  /// - **ja**: "認証コードを入力して続けてください。"
  public static func two_factor_message() -> String {
    return localizedString(
      key: "two_factor.message",
      defaultValue: "Please enter your verification code to continue.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Verify"
  ///
  /// - **en**: "Verify"
  /// - **de**: "Bestätigen"
  /// - **es**: "Verificar"
  /// - **fr**: "Vérifier"
  /// - **ja**: "認証"
  public static func two_factor_title() -> String {
    return localizedString(
      key: "two_factor.title",
      defaultValue: "Verify",
      count: nil,
      substitutions: [:]
    )
  }
}
