// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DatesStrings {
  /// "just now"
  ///
  /// - **en**: "just now"
  /// - **de**: "Gerade eben"
  /// - **es**: "En este momento"
  /// - **fr**: "il y a quelques secondes"
  /// - **ja**: "今すぐ"
  public static func dates_just_now() -> String {
    return localizedString(
      key: "dates.just_now",
      defaultValue: "just now",
      count: nil,
      substitutions: [:]
    )
  }
  /// "right now"
  ///
  /// - **en**: "right now"
  /// - **de**: "Gerade eben"
  /// - **es**: "En este momento"
  /// - **fr**: "à l'instant"
  /// - **ja**: "たった今"
  public static func dates_right_now() -> String {
    return localizedString(
      key: "dates.right_now",
      defaultValue: "right now",
      count: nil,
      substitutions: [:]
    )
  }
  /// "%{time_count} days"
  ///
  /// - **en**: "%{time_count} days"
  /// - **de**: "%{time_count} Tage"
  /// - **es**: "%{time_count} días"
  /// - **fr**: "%{time_count} jours"
  /// - **ja**: "%{time_count} 日"
  public static func dates_time_days(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_days",
      defaultValue: "%{time_count} days",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} days"
  ///
  /// - **en**: "%{time_count} days"
  /// - **de**: "%{time_count} Tage"
  /// - **es**: "%{time_count} días"
  /// - **fr**: "%{time_count} jours"
  /// - **ja**: "%{time_count} 日"
  public static func dates_time_days_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_days.other",
      defaultValue: "%{time_count} days",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} days"
  ///
  /// - **en**: "%{time_count} days"
  /// - **de**: "%{time_count} Tage"
  /// - **es**: "%{time_count} días"
  /// - **fr**: "%{time_count} jours"
  /// - **ja**: "%{time_count} 日"
  public static func dates_time_days_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_days_abbreviated",
      defaultValue: "%{time_count} days",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} days"
  ///
  /// - **en**: "%{time_count} days"
  /// - **de**: "%{time_count} Tage"
  /// - **es**: "%{time_count} días"
  /// - **fr**: "%{time_count} jours"
  /// - **ja**: "%{time_count} 日"
  public static func dates_time_days_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_days_abbreviated.other",
      defaultValue: "%{time_count} days",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} days ago"
  ///
  /// - **en**: "%{time_count} days ago"
  /// - **de**: "vor %{time_count} Tagen"
  /// - **es**: "hace %{time_count} días"
  /// - **fr**: "il y a %{time_count} jours"
  /// - **ja**: "%{time_count} 日前"
  public static func dates_time_days_ago(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_days_ago",
      defaultValue: "%{time_count} days ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} days ago"
  ///
  /// - **en**: "%{time_count} days ago"
  /// - **de**: "vor %{time_count} Tagen"
  /// - **es**: "hace %{time_count} días"
  /// - **fr**: "il y a %{time_count} jours"
  /// - **ja**: "%{time_count} 日前"
  public static func dates_time_days_ago_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_days_ago.other",
      defaultValue: "%{time_count} days ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} days ago"
  ///
  /// - **en**: "%{time_count} days ago"
  /// - **de**: "vor %{time_count} Tagen"
  /// - **es**: "hace %{time_count} días"
  /// - **fr**: "il y a %{time_count} jours"
  /// - **ja**: "%{time_count} 日前"
  public static func dates_time_days_ago_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_days_ago_abbreviated",
      defaultValue: "%{time_count} days ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} days ago"
  ///
  /// - **en**: "%{time_count} days ago"
  /// - **de**: "vor %{time_count} Tagen"
  /// - **es**: "hace %{time_count} días"
  /// - **fr**: "il y a %{time_count} jours"
  /// - **ja**: "%{time_count} 日前"
  public static func dates_time_days_ago_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_days_ago_abbreviated.other",
      defaultValue: "%{time_count} days ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} hours"
  ///
  /// - **en**: "%{time_count} hours"
  /// - **de**: "%{time_count} Stunden"
  /// - **es**: "%{time_count} horas"
  /// - **fr**: "%{time_count} heures"
  /// - **ja**: "%{time_count} 時間"
  public static func dates_time_hours(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_hours",
      defaultValue: "%{time_count} hours",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} hours"
  ///
  /// - **en**: "%{time_count} hours"
  /// - **de**: "%{time_count} Stunden"
  /// - **es**: "%{time_count} horas"
  /// - **fr**: "%{time_count} heures"
  /// - **ja**: "%{time_count} 時間"
  public static func dates_time_hours_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_hours.other",
      defaultValue: "%{time_count} hours",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} hrs"
  ///
  /// - **en**: "%{time_count} hrs"
  /// - **de**: "%{time_count} Std"
  /// - **es**: "%{time_count} hrs"
  /// - **fr**: "%{time_count} h"
  /// - **ja**: "%{time_count} 時間"
  public static func dates_time_hours_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_hours_abbreviated",
      defaultValue: "%{time_count} hrs",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} hrs"
  ///
  /// - **en**: "%{time_count} hrs"
  /// - **de**: "%{time_count} Std"
  /// - **es**: "%{time_count} hrs"
  /// - **fr**: "%{time_count} h"
  /// - **ja**: "%{time_count} 時間"
  public static func dates_time_hours_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_hours_abbreviated.other",
      defaultValue: "%{time_count} hrs",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} hours ago"
  ///
  /// - **en**: "%{time_count} hours ago"
  /// - **de**: "vor %{time_count} Stunden"
  /// - **es**: "hace %{time_count} horas"
  /// - **fr**: "il y a %{time_count} heures"
  /// - **ja**: "%{time_count} 時間前"
  public static func dates_time_hours_ago(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_hours_ago",
      defaultValue: "%{time_count} hours ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} hours ago"
  ///
  /// - **en**: "%{time_count} hours ago"
  /// - **de**: "vor %{time_count} Stunden"
  /// - **es**: "hace %{time_count} horas"
  /// - **fr**: "il y a %{time_count} heures"
  /// - **ja**: "%{time_count} 時間前"
  public static func dates_time_hours_ago_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_hours_ago.other",
      defaultValue: "%{time_count} hours ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
}
