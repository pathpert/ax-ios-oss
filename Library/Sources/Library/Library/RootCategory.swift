import KsApi

/// Canonical Kickstarter top-level discovery category IDs mapped to localized "All ... Projects" titles.
/// - Negative Constraint: Unknown IDs decode to `.unrecognized` (`-1`) rather than failing; handle `.unrecognized` gracefully.
public enum RootCategory: Int {
  case art = 1
  case comics = 3
  case crafts = 26
  case dance = 6
  case design = 7
  case fashion = 9
  case food = 10
  case film = 11
  case games = 12
  case journalism = 13
  case music = 14
  case photography = 15
  case publishing = 18
  case tech = 16
  case theater = 17
  case unrecognized = -1

  /// Decodes a Base64 GraphQL or string category ID into a `RootCategory` (defaults to `.unrecognized`).
  public init(categoryId: String) {
    self = RootCategory(rawValue: decompose(id: categoryId) ?? -1) ?? .unrecognized
  }

  /// Resolves a numeric category ID into a `RootCategory` (defaults to `.unrecognized`).
  public init(categoryId: Int) {
    self = RootCategory(rawValue: categoryId) ?? .unrecognized
  }
}

public extension RootCategory {
  /// Localized summary label for all projects within this root category (empty string for `.unrecognized`).
  func allProjectsString() -> String {
    switch self {
    case .art: return Strings.All_Art_Projects()
    case .comics: return Strings.All_Comics_Projects()
    case .dance: return Strings.All_Dance_Projects()
    case .design: return Strings.All_Design_Projects()
    case .fashion: return Strings.All_Fashion_Projects()
    case .food: return Strings.All_Food_Projects()
    case .film: return Strings.All_Film_Projects()
    case .games: return Strings.All_Games_Projects()
    case .journalism: return Strings.All_Journalism_Projects()
    case .music: return Strings.All_Music_Projects()
    case .photography: return Strings.All_Photography_Projects()
    case .tech: return Strings.All_Tech_Projects()
    case .theater: return Strings.All_Theater_Projects()
    case .publishing: return Strings.All_Publishing_Projects()
    case .crafts: return Strings.All_Crafts_Projects()
    case .unrecognized: return ""
    }
  }
}
