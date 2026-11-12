// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension SettingsStrings {
  /// "Account"
  ///
  /// - **en**: "Account"
  /// - **de**: "Konto"
  /// - **es**: "Cuenta"
  /// - **fr**: "Votre compte"
  /// - **ja**: "アカウント"
  public static func Account() -> String {
    return localizedString(
      key: "Account",
      defaultValue: "Account",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Beta"
  ///
  /// - **en**: "Beta"
  /// - **de**: "Beta"
  /// - **es**: "Beta"
  /// - **fr**: "Bêta"
  /// - **ja**: "ベータ"
  public static func Beta() -> String {
    return localizedString(
      key: "Beta",
      defaultValue: "Beta",
      count: nil,
      substitutions: [:]
    )
  }
  /// "By creating an account, you agree to Kickstarter’s <a href="%{terms_of_use_link}">Terms of Use</a> and <a href="%{privacy_policy_link}">Privacy Policy</a>."
  ///
  /// - **en**: "By creating an account, you agree to Kickstarter’s <a href="%{terms_of_use_link}">Terms of Use</a> and <a href="%{privacy_policy_link}">Privacy Policy</a>."
  /// - **de**: "Mit Erstellung eines Kontos erklärst du dich mit Kickstarters <a href="%{terms_of_use_link}">Nutzungsbedingungen</a> und <a href="%{privacy_policy_link}">Datenschutzrichtlinien</a> einverstanden."
  /// - **es**: "Si creas una cuenta, aceptas los <a href="%{terms_of_use_link}">Términos de uso</a> y la <a href="%{privacy_policy_link}">Política de privacidad</a> de Kickstarter."
  /// - **fr**: "Lorsque vous créez un compte, vous acceptez les <a href="%{terms_of_use_link}">Conditions d'utilisation</a> et la <a href="%{privacy_policy_link}">Politique de confidentialité</a> de Kickstarter."
  /// - **ja**: "アカウントを作成することで、Kickstarter の <a href="%{terms_of_use_link}">利用規約</a> と<a href="%{privacy_policy_link}">プライバシーポリシー</a>に同意したことになります。"
  public static func By_creating_an_account_you_agree_to_Kickstarters_Terms_of_Use_and_Privacy_Policy(terms_of_use_link: String, privacy_policy_link: String) -> String {
    return localizedString(
      key: "By_creating_an_account_you_agree_to_Kickstarters_Terms_of_Use_and_Privacy_Policy",
      defaultValue: "By creating an account, you agree to Kickstarter’s <a href=\"%{terms_of_use_link}\">Terms of Use</a> and <a href=\"%{privacy_policy_link}\">Privacy Policy</a>.",
      count: nil,
      substitutions: ["terms_of_use_link": terms_of_use_link, "privacy_policy_link": privacy_policy_link]
    )
  }
  /// "By pledging you agree to Kickstarter's <a href="%{terms_of_use_link}">Terms of Use</a>, <a href="%{privacy_policy_link}">Privacy Policy</a> and <a href="%{cookie_policy_link}">Cookie Policy</a>."
  ///
  /// - **en**: "By pledging you agree to Kickstarter's <a href="%{terms_of_use_link}">Terms of Use</a>, <a href="%{privacy_policy_link}">Privacy Policy</a> and <a href="%{cookie_policy_link}">Cookie Policy</a>."
  /// - **de**: "Bei Leistung eines Finanzierungsbeitrags erkennst du Kickstarters <a href="%{terms_of_use_link}">Nutzungsbedingungen</a>, <a href="%{privacy_policy_link}">Datenschutzrichtlinien</a> und <a href="%{cookie_policy_link}">Cookie-Richtlinien</a> an."
  /// - **es**: "Al contribuir, aceptas las <a href="%{terms_of_use_link}">Condiciones de uso</a>, <a href="%{privacy_policy_link}">Política de privacidad</a> y <a href="%{cookie_policy_link}">Política de cookies</a> de Kickstarter."
  /// - **fr**: "Lorsque vous vous engagez, vous acceptez les <a href="%{terms_of_use_link}">Conditions d'utilisation</a> de Kickstarter, notre <a href="%{privacy_policy_link}">Politique de confidentialité</a> et notre <a href="%{cookie_policy_link}">Politique en matière de cookies</a>."
  /// - **ja**: "プレッジをすることにより、Kickstarter の <a href="%{terms_of_use_link}">利用規約</a>、<a href="%{privacy_policy_link}">プライバシーポリシー</a>、<a href="%{cookie_policy_link}">Cookie ポリシー</a>に同意したとみなされます。"
  public static func By_pledging_you_agree_to_Kickstarters_Terms_of_Use_Privacy_Policy_and_Cookie_Policy(terms_of_use_link: String, privacy_policy_link: String, cookie_policy_link: String) -> String {
    return localizedString(
      key: "By_pledging_you_agree_to_Kickstarters_Terms_of_Use_Privacy_Policy_and_Cookie_Policy",
      defaultValue: "By pledging you agree to Kickstarter's <a href=\"%{terms_of_use_link}\">Terms of Use</a>, <a href=\"%{privacy_policy_link}\">Privacy Policy</a> and <a href=\"%{cookie_policy_link}\">Cookie Policy</a>.",
      count: nil,
      substitutions: ["terms_of_use_link": terms_of_use_link, "privacy_policy_link": privacy_policy_link, "cookie_policy_link": cookie_policy_link]
    )
  }
  /// "By signing up, you agree to our Terms of Use, Privacy Policy, and Cookie Policy. Our policies explain how we use your data to deliver, improve, and promote our service and our site, and how you can exercise your rights to control that use."
  ///
  /// - **en**: "By signing up, you agree to our Terms of Use, Privacy Policy, and Cookie Policy. Our policies explain how we use your data to deliver, improve, and promote our service and our site, and how you can exercise your rights to control that use."
  /// - **de**: "Bei Registrierung stimmst du unseren Nutzungsbedingungen, Datenschutzrichtlinien und Cookie-Richtlinien zu. Unsere Richtlinien erläutern, wie wir deine Daten zur Bereitstellung, Verbesserung und Promotion unserer Services und unserer Webseite nutzen."
  /// - **es**: "Al registrarte, aceptas nuestros Términos de uso, Política de privacidad y Política de cookies. Nuestras políticas explican cómo utilizamos tus datos para entregar, mejorar y promocionar nuestro servicio y nuestro sitio, y cómo puedes ejercer tus derechos para controlar dicho uso."
  /// - **fr**: "En vous inscrivant, vous acceptez nos conditions d'utilisation, notre politique de confidentialité et notre politique en matière de cookies. Ces deux dernières politiques décrivent comment nous utilisons vos données pour proposer, améliorer et faire la promotion de nos services et de notre site, ainsi que les droits dont vous disposez pour contrôler cette utilisation et comment les exercer."
  /// - **ja**: "サインアップすることで、Kickstarter の利用規約、プライバシーポリシー、Cookie ポリシーに同意するものとみなされます。当社のポリシーでは、Kickstarter のサービスとサイトを配信、改善、促進するために、同社がお客様のデータをどのように使用しているか、そしてそのようなデータ使用を管理するためのお客様の権利について説明しています。"
  public static func By_signing_up_you_agree_to_our_Terms_of_Use_Privacy_Policy_and_Cookie_Policy() -> String {
    return localizedString(
      key: "By_signing_up_you_agree_to_our_Terms_of_Use_Privacy_Policy_and_Cookie_Policy",
      defaultValue: "By signing up, you agree to our Terms of Use, Privacy Policy, and Cookie Policy. Our policies explain how we use your data to deliver, improve, and promote our service and our site, and how you can exercise your rights to control that use.",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Change currency?"
  ///
  /// - **en**: "Change currency?"
  /// - **de**: "Währung ändern"
  /// - **es**: "Cambiar la moneda"
  /// - **fr**: "Changer de devise"
  /// - **ja**: "通貨の変更"
  public static func Change_currency() -> String {
    return localizedString(
      key: "Change_currency",
      defaultValue: "Change currency?",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Currency"
  ///
  /// - **en**: "Currency"
  /// - **de**: "Währung"
  /// - **es**: "Moneda"
  /// - **fr**: "Devise"
  /// - **ja**: "通貨"
  public static func Currency() -> String {
    return localizedString(
      key: "Currency",
      defaultValue: "Currency",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$ Australian Dollar (AUD)"
  ///
  /// - **en**: "$ Australian Dollar (AUD)"
  /// - **de**: "$ Australischer Dollar (AUD)"
  /// - **es**: "$ Dólar australiano (AUD)"
  /// - **fr**: "Dollar australien – $ (AUD)"
  /// - **ja**: "$ オーストラリアドル (AUD)"
  public static func Currency_AUD() -> String {
    return localizedString(
      key: "Currency_AUD",
      defaultValue: "$ Australian Dollar (AUD)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$ Canadian Dollar (CAD)"
  ///
  /// - **en**: "$ Canadian Dollar (CAD)"
  /// - **de**: "$ Kanadischer Dollar (CAD)"
  /// - **es**: "$ Dólar canadiense (CAD)"
  /// - **fr**: "Dollar Canadien – $ (CAD)"
  /// - **ja**: "$ カナダドル (CAD)"
  public static func Currency_CAD() -> String {
    return localizedString(
      key: "Currency_CAD",
      defaultValue: "$ Canadian Dollar (CAD)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "Fr Swiss Franc (CHF)"
  ///
  /// - **en**: "Fr Swiss Franc (CHF)"
  /// - **de**: "Fr Schweizer Franken (CHF)"
  /// - **es**: "Fr Franco suizo (CHF)"
  /// - **fr**: "Franc suisse – Fr (CHF)"
  /// - **ja**: "Fr スイスフラン (CHF)"
  public static func Currency_CHF() -> String {
    return localizedString(
      key: "Currency_CHF",
      defaultValue: "Fr Swiss Franc (CHF)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "kr Danish Krone (DKK)"
  ///
  /// - **en**: "kr Danish Krone (DKK)"
  /// - **de**: "kr Dänische Krone (DKK)"
  /// - **es**: "kr Corona danesa (DKK)"
  /// - **fr**: "Couronne danoise – kr (DKK)"
  /// - **ja**: "kr デンマーククローネ (DKK)"
  public static func Currency_DKK() -> String {
    return localizedString(
      key: "Currency_DKK",
      defaultValue: "kr Danish Krone (DKK)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "€ Euro (EUR)"
  ///
  /// - **en**: "€ Euro (EUR)"
  /// - **de**: "€ Euro (EUR)"
  /// - **es**: "€ Euro (EUR)"
  /// - **fr**: "Euro – € (EUR)"
  /// - **ja**: "€ ユーロ (EUR)"
  public static func Currency_EUR() -> String {
    return localizedString(
      key: "Currency_EUR",
      defaultValue: "€ Euro (EUR)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "£ Pound Sterling (GBP)"
  ///
  /// - **en**: "£ Pound Sterling (GBP)"
  /// - **de**: "£ Pfund Sterling (GBP)"
  /// - **es**: "£ Libra esterlina (GBP)"
  /// - **fr**: "Livre sterling – £ (GBP)"
  /// - **ja**: "£ ポンド (GBP)"
  public static func Currency_GBP() -> String {
    return localizedString(
      key: "Currency_GBP",
      defaultValue: "£ Pound Sterling (GBP)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$ Hong Kong Dollar (HKD)"
  ///
  /// - **en**: "$ Hong Kong Dollar (HKD)"
  /// - **de**: "$ Hongkong-Dollar (HKD)"
  /// - **es**: "$ Dólar de Hong Kong (HKD)"
  /// - **fr**: "Dollar de Hong Kong – $ (HKD)"
  /// - **ja**: "$ 香港ドル (HKD)"
  public static func Currency_HKD() -> String {
    return localizedString(
      key: "Currency_HKD",
      defaultValue: "$ Hong Kong Dollar (HKD)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "¥ Japanese Yen (JPY)"
  ///
  /// - **en**: "¥ Japanese Yen (JPY)"
  /// - **de**: "¥ Yen (JPY)"
  /// - **es**: "¥ Yen (JPY)"
  /// - **fr**: "Yen japonais – ¥ (JPY)"
  /// - **ja**: "¥ 円 (JPY)"
  public static func Currency_JPY() -> String {
    return localizedString(
      key: "Currency_JPY",
      defaultValue: "¥ Japanese Yen (JPY)",
      count: nil,
      substitutions: [:]
    )
  }
  /// "$ Mexican Peso (MXN)"
  ///
  /// - **en**: "$ Mexican Peso (MXN)"
  /// - **de**: "$ Mexikanischer Peso (MXN)"
  /// - **es**: "$ Peso mexicano (MXN)"
  /// - **fr**: "Pesos mexicain – $ (MXN)"
  /// - **ja**: "$ メキシコペソ (MXN)"
  public static func Currency_MXN() -> String {
    return localizedString(
      key: "Currency_MXN",
      defaultValue: "$ Mexican Peso (MXN)",
      count: nil,
      substitutions: [:]
    )
  }
}
