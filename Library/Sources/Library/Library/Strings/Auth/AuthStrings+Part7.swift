// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension AuthStrings {
  /// "It seems that you have denied Kickstarter access to your Facebook account. Please go to Settings > Facebook and toggle access."
  ///
  /// - **en**: "It seems that you have denied Kickstarter access to your Facebook account. Please go to Settings > Facebook and toggle access."
  /// - **de**: "Es scheint, als hättest du Kickstarter den Zugriff auf dein Facebook-Konto verweigert. Bitte gehe zu Einstellungen > Facebook und erlaube den Zugriff."
  /// - **es**: "Parece que le has denegado a Kickstarter acceso a tu cuenta de Facebook. Para cambiarlo, por favor ve a Configuración > Facebook."
  /// - **fr**: "On dirait que vous avez refusé à Kickstarter l'accès à votre compte Facebook. Veuillez accéder à Paramètres > Facebook pour autoriser l'accès."
  /// - **ja**: "Facebookアカウントへのアクセスを拒否されました。Facebookの設定をご確認ください。"
  public static func login_tout_errors_facebook_settings_disabled_message() -> String {
    return localizedString(
      key: "login_tout.errors.facebook.settings_disabled.message",
      defaultValue: "It seems that you have denied Kickstarter access to your Facebook account. Please go to Settings > Facebook and toggle access.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Permission denied"
  ///
  /// - **en**: "Permission denied"
  /// - **de**: "Zugriff verweigert"
  /// - **es**: "Permiso denegado"
  /// - **fr**: "Autorisation refusée"
  /// - **ja**: "アクセス拒否"
  public static func login_tout_errors_facebook_settings_disabled_title() -> String {
    return localizedString(
      key: "login_tout.errors.facebook.settings_disabled.title",
      defaultValue: "Permission denied",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Please log in to add this category to your list of favorites."
  ///
  /// - **en**: "Please log in to add this category to your list of favorites."
  /// - **de**: "Bitte anmelden, um diese Kategorie in deine Favoriten aufzunehmen. Du kannst dann von dort aus jederzeit schnell auf sie zugreifen."
  /// - **es**: "Por favor, inicia sesión para añadir esta categoría a tus favoritas. Te permitirá fácil acceso a ella a través de la lista de favoritas."
  /// - **fr**: "Veuillez vous connecter pour ajouter cette catégorie à vos favoris et y accéder à tout moment depuis votre liste."
  /// - **ja**: "ログインして、このカテゴリーをお気に入り登録しましょう"
  public static func login_tout_favorite_category_intent_title() -> String {
    return localizedString(
      key: "login_tout.favorite_category_intent.title",
      defaultValue: "Please log in to add this category to your list of favorites.",
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
  public static func login_tout_favorite_category_intent_traditional_login_button() -> String {
    return localizedString(
      key: "login_tout.favorite_category_intent.traditional_login_button",
      defaultValue: "Log in",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sign up"
  ///
  /// - **en**: "Sign up"
  /// - **de**: "Registrieren"
  /// - **es**: "Registrarse"
  /// - **fr**: "Inscription"
  /// - **ja**: "サインアップ"
  public static func login_tout_favorite_category_intent_traditional_signup_button() -> String {
    return localizedString(
      key: "login_tout.favorite_category_intent.traditional_signup_button",
      defaultValue: "Sign up",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Use your email address:"
  ///
  /// - **en**: "Use your email address:"
  /// - **de**: "Mit E-Mail-Adresse anmelden:"
  /// - **es**: "Iniciar sesión con dirección de correo electrónico:"
  /// - **fr**: "Vous pouvez utiliser votre adresse e-mail :"
  /// - **ja**: "メールアドレスを使用："
  public static func login_tout_favorite_category_intent_traditional_title() -> String {
    return localizedString(
      key: "login_tout.favorite_category_intent.traditional_title",
      defaultValue: "Use your email address:",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Whoa there! You must log in to your Kickstarter account to continue. Sign up or log in with your email address or Facebook account below."
  ///
  /// - **en**: "Whoa there! You must log in to your Kickstarter account to continue. Sign up or log in with your email address or Facebook account below."
  /// - **de**: "Hoppla! Um fortzufahren, musst du dich auf Kickstarter einloggen. Du kannst dich unten mit deinem Facebook-Konto oder deiner E-Mail-Adresse anmelden oder dich neu registrieren."
  /// - **es**: "¡Un momentito! Primero tienes que iniciar sesión con tu cuenta de Kickstarter para continuar. Regístrate o inicia sesión con tu dirección de correo electrónico o con tu cuenta de Facebook."
  /// - **fr**: "Oh là ! Vous devez vous connecter à votre compte Kickstarter pour continuer. Vous pouvez vous connecter ou vous inscrire ci-dessous avec votre adresse e-mail ou votre compte Facebook."
  /// - **ja**: "続行するにはアカウントにログインが必要です。 メールアドレス、Facebookアカウントで登録するか、ログインしてください。"
  public static func login_tout_generic_intent_title() -> String {
    return localizedString(
      key: "login_tout.generic_intent.title",
      defaultValue: "Whoa there! You must log in to your Kickstarter account to continue. Sign up or log in with your email address or Facebook account below.",
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
  public static func login_tout_generic_intent_traditional_login_button() -> String {
    return localizedString(
      key: "login_tout.generic_intent.traditional_login_button",
      defaultValue: "Log in",
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
  public static func login_tout_generic_intent_traditional_signup_button() -> String {
    return localizedString(
      key: "login_tout.generic_intent.traditional_signup_button",
      defaultValue: "Sign up",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Sign up or Log in"
  ///
  /// - **en**: "Sign up or Log in"
  /// - **de**: "Registrieren oder Anmelden"
  /// - **es**: "Registrarme o iniciar sesión"
  /// - **fr**: "Inscription ou connexion"
  /// - **ja**: "サインアップまたはログイン"
  public static func login_tout_generic_intent_traditional_signup_or_login_button() -> String {
    return localizedString(
      key: "login_tout.generic_intent.traditional_signup_or_login_button",
      defaultValue: "Sign up or Log in",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Use your email address:"
  ///
  /// - **en**: "Use your email address:"
  /// - **de**: "Benutze deine E-Mail-Adresse:"
  /// - **es**: "Utiliza tu dirección de correo electrónico:"
  /// - **fr**: "Utilisez votre adresse e-mail :"
  /// - **ja**: "メールアドレスを使用："
  public static func login_tout_generic_intent_traditional_title() -> String {
    return localizedString(
      key: "login_tout.generic_intent.traditional_title",
      defaultValue: "Use your email address:",
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
  public static func login_tout_help_sheet_cancel() -> String {
    return localizedString(
      key: "login_tout.help_sheet.cancel",
      defaultValue: "Cancel",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Contact"
  ///
  /// - **en**: "Contact"
  /// - **de**: "Kontakt"
  /// - **es**: "Contacto"
  /// - **fr**: "Contact"
  /// - **ja**: "お問い合わせ"
  public static func login_tout_help_sheet_contact() -> String {
    return localizedString(
      key: "login_tout.help_sheet.contact",
      defaultValue: "Contact",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Cookie Policy"
  ///
  /// - **en**: "Cookie Policy"
  /// - **de**: "Cookie-Richtlinien"
  /// - **es**: "Política de Cookies"
  /// - **fr**: "Politique en matière de cookies"
  /// - **ja**: "Cookieポリシー"
  public static func login_tout_help_sheet_cookie() -> String {
    return localizedString(
      key: "login_tout.help_sheet.cookie",
      defaultValue: "Cookie Policy",
      count: nil,
      substitutions: [:]
    )
  }
  /// "How Kickstarter Works"
  ///
  /// - **en**: "How Kickstarter Works"
  /// - **de**: "Wie Kickstarter funktioniert"
  /// - **es**: "Cómo funciona Kickstarter"
  /// - **fr**: "Comment fonctionne Kickstarter"
  /// - **ja**: "Kickstarterの仕組み"
  public static func login_tout_help_sheet_how_it_works() -> String {
    return localizedString(
      key: "login_tout.help_sheet.how_it_works",
      defaultValue: "How Kickstarter Works",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Privacy Policy"
  ///
  /// - **en**: "Privacy Policy"
  /// - **de**: "Datenschutzrichtlinien"
  /// - **es**: "Política de privacidad"
  /// - **fr**: "Politique de confidentialité"
  /// - **ja**: "プライバシーポリシー"
  public static func login_tout_help_sheet_privacy() -> String {
    return localizedString(
      key: "login_tout.help_sheet.privacy",
      defaultValue: "Privacy Policy",
      count: nil,
      substitutions: [:]
    )
  }
}
