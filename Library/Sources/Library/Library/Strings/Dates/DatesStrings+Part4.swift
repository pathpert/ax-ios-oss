// swiftlint:disable valid_docs
// swiftlint:disable line_length
extension DatesStrings {
  /// "in "%{time_count} secs""
  ///
  /// - **en**: "in "%{time_count} secs""
  /// - **de**: "in "%{time_count} Sek""
  /// - **es**: "en "%{time_count} segs""
  /// - **fr**: "dans %{time_count} s"
  /// - **ja**: "あと "%{time_count} 秒""
  public static func dates_time_in_seconds_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_in_seconds_abbreviated",
      defaultValue: "in \"%{time_count} secs\"",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "in "%{time_count} secs""
  ///
  /// - **en**: "in "%{time_count} secs""
  /// - **de**: "in "%{time_count} Sek""
  /// - **es**: "en "%{time_count} segs""
  /// - **fr**: "dans %{time_count} s"
  /// - **ja**: "あと "%{time_count} 秒""
  public static func dates_time_in_seconds_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_in_seconds_abbreviated.other",
      defaultValue: "in \"%{time_count} secs\"",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} minutes"
  ///
  /// - **en**: "%{time_count} minutes"
  /// - **de**: "%{time_count} Minuten"
  /// - **es**: "%{time_count} minutos"
  /// - **fr**: "%{time_count} minutes"
  /// - **ja**: "%{time_count} 分"
  public static func dates_time_minutes(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_minutes",
      defaultValue: "%{time_count} minutes",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} minutes"
  ///
  /// - **en**: "%{time_count} minutes"
  /// - **de**: "%{time_count} Minuten"
  /// - **es**: "%{time_count} minutos"
  /// - **fr**: "%{time_count} minutes"
  /// - **ja**: "%{time_count} 分"
  public static func dates_time_minutes_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_minutes.other",
      defaultValue: "%{time_count} minutes",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} mins"
  ///
  /// - **en**: "%{time_count} mins"
  /// - **de**: "%{time_count} Min"
  /// - **es**: "%{time_count} mins"
  /// - **fr**: "%{time_count} min"
  /// - **ja**: "%{time_count} 分"
  public static func dates_time_minutes_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_minutes_abbreviated",
      defaultValue: "%{time_count} mins",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} mins"
  ///
  /// - **en**: "%{time_count} mins"
  /// - **de**: "%{time_count} Min"
  /// - **es**: "%{time_count} mins"
  /// - **fr**: "%{time_count} min"
  /// - **ja**: "%{time_count}"
  public static func dates_time_minutes_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_minutes_abbreviated.other",
      defaultValue: "%{time_count} mins",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} minutes ago"
  ///
  /// - **en**: "%{time_count} minutes ago"
  /// - **de**: "vor %{time_count} Minuten"
  /// - **es**: "hace %{time_count} minutos"
  /// - **fr**: "il y a %{time_count} minutes"
  /// - **ja**: "%{time_count} 分前"
  public static func dates_time_minutes_ago(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_minutes_ago",
      defaultValue: "%{time_count} minutes ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} minutes ago"
  ///
  /// - **en**: "%{time_count} minutes ago"
  /// - **de**: "vor %{time_count} Minuten"
  /// - **es**: "hace %{time_count} minutos"
  /// - **fr**: "il y a %{time_count} minutes"
  /// - **ja**: "%{time_count} 分前"
  public static func dates_time_minutes_ago_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_minutes_ago.other",
      defaultValue: "%{time_count} minutes ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} mins ago"
  ///
  /// - **en**: "%{time_count} mins ago"
  /// - **de**: "vor %{time_count} Min"
  /// - **es**: "hace %{time_count} mins"
  /// - **fr**: "il y a %{time_count} min"
  /// - **ja**: "%{time_count} 分前"
  public static func dates_time_minutes_ago_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_minutes_ago_abbreviated",
      defaultValue: "%{time_count} mins ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} mins ago"
  ///
  /// - **en**: "%{time_count} mins ago"
  /// - **de**: "vor %{time_count} Min"
  /// - **es**: "hace %{time_count} mins"
  /// - **fr**: "il y a %{time_count} min"
  /// - **ja**: "分前"
  public static func dates_time_minutes_ago_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_minutes_ago_abbreviated.other",
      defaultValue: "%{time_count} mins ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} secs"
  ///
  /// - **en**: "%{time_count} secs"
  /// - **de**: "%{time_count} Sek"
  /// - **es**: "%{time_count} segs"
  /// - **fr**: "%{time_count} s"
  /// - **ja**: "%{time_count} 秒"
  public static func dates_time_seconds(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_seconds",
      defaultValue: "%{time_count} secs",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} secs"
  ///
  /// - **en**: "%{time_count} secs"
  /// - **de**: "%{time_count} Sek"
  /// - **es**: "%{time_count} segs"
  /// - **fr**: "%{time_count} s"
  /// - **ja**: "%{time_count} 秒"
  public static func dates_time_seconds_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_seconds.other",
      defaultValue: "%{time_count} secs",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} seconds"
  ///
  /// - **en**: "%{time_count} seconds"
  /// - **de**: "%{time_count} Sekunden"
  /// - **es**: "%{time_count} segundos"
  /// - **fr**: "%{time_count} secondes"
  /// - **ja**: "%{time_count} 秒"
  public static func dates_time_seconds_abbreviated(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_seconds_abbreviated",
      defaultValue: "%{time_count} seconds",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} seconds"
  ///
  /// - **en**: "%{time_count} seconds"
  /// - **de**: "%{time_count} Sekunden"
  /// - **es**: "%{time_count} segundos"
  /// - **fr**: "%{time_count} secondes"
  /// - **ja**: "%{time_count} 秒"
  public static func dates_time_seconds_abbreviated_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_seconds_abbreviated.other",
      defaultValue: "%{time_count} seconds",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
  /// "%{time_count} secs ago"
  ///
  /// - **en**: "%{time_count} secs ago"
  /// - **de**: "vor %{time_count} Sek"
  /// - **es**: "hace %{time_count} segs"
  /// - **fr**: "il y a %{time_count} s"
  /// - **ja**: "%{time_count} 秒前"
  public static func dates_time_seconds_ago(time_count: Int) -> String {
    return localizedString(
      key: "dates.time_seconds_ago",
      defaultValue: "%{time_count} secs ago",
      count: time_count,
      substitutions: ["time_count": Format.wholeNumber(time_count)]
    )
  }
  /// "%{time_count} secs ago"
  ///
  /// - **en**: "%{time_count} secs ago"
  /// - **de**: "vor %{time_count} Sek"
  /// - **es**: "hace %{time_count} segs"
  /// - **fr**: "il y a %{time_count} s"
  /// - **ja**: "%{time_count} 秒前"
  public static func dates_time_seconds_ago_other(time_count: String) -> String {
    return localizedString(
      key: "dates.time_seconds_ago.other",
      defaultValue: "%{time_count} secs ago",
      count: nil,
      substitutions: ["time_count": time_count]
    )
  }
}
