/// Supported application localization languages.
/// - Negative Constraint: Do not pass arbitrary BCP-47 region tags without normalizing to two-letter base language codes.
public enum Language: String {
  case de
  case en
  case es
  case fr
  case ja

  /// Ordered list of all supported app languages.
  public static let allLanguages: [Language] = [.de, .en, .es, .fr, .ja]

  /// Initializes a supported `Language` from a raw code string, or `nil` if unsupported.
  public init?(languageString language: String) {
    switch language.lowercased() {
    case "de": self = .de
    case "en": self = .en
    case "es": self = .es
    case "fr": self = .fr
    case "ja": self = .ja
    default: return nil
    }
  }

  /// Selects the first supported `Language` matching any two-letter prefix in `languages`.
  public init?(languageStrings languages: [String]) {
    guard let language = languages
      .lazy
      .map({ String($0.prefix(2)) })
      .compactMap(Language.init(languageString:))
      .first else {
      return nil
    }

    self = language
  }

  /// English display name for the language.
  public var displayString: String {
    switch self {
    case .de: return "German"
    case .en: return "English"
    case .es: return "Spanish"
    case .fr: return "French"
    case .ja: return "Japanese"
    }
  }
}

extension Language: Equatable {}
/// Compares two `Language` cases for equality.
public func == (lhs: Language, rhs: Language) -> Bool {
  switch (lhs, rhs) {
  case (.en, .en), (.es, .es), (.fr, .fr), (.de, .de), (.ja, .ja):
    return true
  default:
    return false
  }
}
