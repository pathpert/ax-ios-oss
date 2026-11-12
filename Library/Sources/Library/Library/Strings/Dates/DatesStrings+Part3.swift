// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DatesStrings {
  /// "%{time_count} hrs ago"
  ///
  /// - **en**: "%{time_count} hrs ago"
  /// - **de**: "vor %{time_count} Std"
  /// - **es**: "hace %{time_count} hrs"
  /// - **fr**: "il y a %{time_count} h"
  /// - **ja**: "%{time_count} 時間前"
  public static func dates_time_hours_ago_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_hours_ago_abbreviated",
      defaultValue: "%{time_count} hrs ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} hrs ago"
  ///
  /// - **en**: "%{time_count} hrs ago"
  /// - **de**: "vor %{time_count} Std"
  /// - **es**: "hace %{time_count} hrs"
  /// - **fr**: "il y a %{time_count} h"
  /// - **ja**: "%{time_count} 時間前"
  public static func dates_time_hours_ago_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_hours_ago_abbreviated.other",
      defaultValue: "%{time_count} hrs ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in %{time_count} days"
  ///
  /// - **en**: "in %{time_count} days"
  /// - **de**: "in %{time_count} Tagen"
  /// - **es**: "en %{time_count} días"
  /// - **fr**: "dans %{time_count} jours"
  /// - **ja**: "あと%{time_count} 日"
  public static func dates_time_in_days(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_days",
      defaultValue: "in %{time_count} days",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in %{time_count} days"
  ///
  /// - **en**: "in %{time_count} days"
  /// - **de**: "in %{time_count} Tagen"
  /// - **es**: "en %{time_count} días"
  /// - **fr**: "dans %{time_count} jours"
  /// - **ja**: "あと%{time_count} 日"
  public static func dates_time_in_days_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_days.other",
      defaultValue: "in %{time_count} days",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in %{time_count} days"
  ///
  /// - **en**: "in %{time_count} days"
  /// - **de**: "in %{time_count} Tagen"
  /// - **es**: "en %{time_count} días"
  /// - **fr**: "dans %{time_count} jours"
  /// - **ja**: "あと%{time_count} 日"
  public static func dates_time_in_days_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_days_abbreviated",
      defaultValue: "in %{time_count} days",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in %{time_count} days"
  ///
  /// - **en**: "in %{time_count} days"
  /// - **de**: "in %{time_count} Tagen"
  /// - **es**: "en %{time_count} días"
  /// - **fr**: "dans %{time_count} jours"
  /// - **ja**: "あと%{time_count} 日"
  public static func dates_time_in_days_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_days_abbreviated.other",
      defaultValue: "in %{time_count} days",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in %{time_count} hours"
  ///
  /// - **en**: "in %{time_count} hours"
  /// - **de**: "in %{time_count} Stunden"
  /// - **es**: "en %{time_count} horas"
  /// - **fr**: "dans %{time_count} heures"
  /// - **ja**: "あと%{time_count} 時間"
  public static func dates_time_in_hours(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_hours",
      defaultValue: "in %{time_count} hours",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in %{time_count} hours"
  ///
  /// - **en**: "in %{time_count} hours"
  /// - **de**: "in %{time_count} Stunden"
  /// - **es**: "en %{time_count} horas"
  /// - **fr**: "dans %{time_count} heures"
  /// - **ja**: "あと%{time_count} 時間"
  public static func dates_time_in_hours_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_hours.other",
      defaultValue: "in %{time_count} hours",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in %{time_count} hrs"
  ///
  /// - **en**: "in %{time_count} hrs"
  /// - **de**: "in %{time_count} Std"
  /// - **es**: "en %{time_count} hrs"
  /// - **fr**: "dans %{time_count} h"
  /// - **ja**: "あと%{time_count} 時間"
  public static func dates_time_in_hours_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_hours_abbreviated",
      defaultValue: "in %{time_count} hrs",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in %{time_count} hrs"
  ///
  /// - **en**: "in %{time_count} hrs"
  /// - **de**: "in %{time_count} Std"
  /// - **es**: "en %{time_count} hrs"
  /// - **fr**: "dans %{time_count} h"
  /// - **ja**: "あと%{time_count} 時間"
  public static func dates_time_in_hours_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_hours_abbreviated.other",
      defaultValue: "in %{time_count} hrs",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in %{time_count} minutes"
  ///
  /// - **en**: "in %{time_count} minutes"
  /// - **de**: "in %{time_count} Minuten"
  /// - **es**: "en %{time_count} minutos"
  /// - **fr**: "dans %{time_count} minutes"
  /// - **ja**: "あと%{time_count} 分"
  public static func dates_time_in_minutes(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_minutes",
      defaultValue: "in %{time_count} minutes",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in %{time_count} minutes"
  ///
  /// - **en**: "in %{time_count} minutes"
  /// - **de**: "in %{time_count} Minuten"
  /// - **es**: "en %{time_count} minutos"
  /// - **fr**: "dans %{time_count} minutes"
  /// - **ja**: "あと%{time_count} 分"
  public static func dates_time_in_minutes_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_minutes.other",
      defaultValue: "in %{time_count} minutes",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in %{time_count} mins"
  ///
  /// - **en**: "in %{time_count} mins"
  /// - **de**: "in %{time_count} Min"
  /// - **es**: "en %{time_count} mins"
  /// - **fr**: "dans %{time_count} min"
  /// - **ja**: "あと%{time_count} 分"
  public static func dates_time_in_minutes_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_minutes_abbreviated",
      defaultValue: "in %{time_count} mins",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in %{time_count} mins"
  ///
  /// - **en**: "in %{time_count} mins"
  /// - **de**: "in %{time_count} Min"
  /// - **es**: "en %{time_count} mins"
  /// - **fr**: "dans %{time_count} min"
  /// - **ja**: "あと%{time_count} 分"
  public static func dates_time_in_minutes_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_minutes_abbreviated.other",
      defaultValue: "in %{time_count} mins",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "in "%{time_count} seconds""
  ///
  /// - **en**: "in "%{time_count} seconds""
  /// - **de**: "in "%{time_count} Sekunden""
  /// - **es**: "en "%{time_count} segundos""
  /// - **fr**: "dans %{time_count} secondes"
  /// - **ja**: "あと "%{time_count} 秒""
  public static func dates_time_in_seconds(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_seconds",
      defaultValue: "in \"%{time_count} seconds\"",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in "%{time_count} seconds""
  ///
  /// - **en**: "in "%{time_count} seconds""
  /// - **de**: "in "%{time_count} Sekunden""
  /// - **es**: "en "%{time_count} segundos""
  /// - **fr**: "dans %{time_count} secondes"
  /// - **ja**: "あと "%{time_count} 秒""
  public static func dates_time_in_seconds_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_seconds.other",
      defaultValue: "in \"%{time_count} seconds\"",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
}
