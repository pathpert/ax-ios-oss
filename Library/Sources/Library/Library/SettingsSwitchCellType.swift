import Foundation

/// Non-interactive explanatory privacy cell variants in Account Settings.
public enum SettingsStaticCellType {
  case following
  case recommendations

  /// Localized informational copy explaining the corresponding privacy setting.
  public var description: String {
    switch self {
    case .following:
      return Strings.When_following_is_on_you_can_follow_the_acticity_of_others()
    case .recommendations:
      return Strings.We_use_your_activity_internally_to_make_recommendations_for_you()
    }
  }
}

/// Interactive switch-backed settings cell variants.
/// - Negative Constraint: Do not store toggle state in this enum; bind state via view model outputs.
public enum SettingsSwitchCellType {
  case privacy

  /// Localized primary label for the switch row.
  public var title: String {
    return Strings.Private_profile()
  }

  /// Localized explanation shown when the toggle is turned on.
  public var primaryDescription: String {
    return Strings.If_your_profile_is_private()
  }

  /// Localized explanation shown when the toggle is turned off.
  public var secondaryDescription: String {
    return Strings.If_your_profile_is_public()
  }
}
