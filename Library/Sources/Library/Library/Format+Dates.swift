import Foundation
import KsApi

/// Default day cutoff beyond which `Format.relative` switches to an absolute medium date string.
public let defaultThresholdInDays = 30 // days

extension Format {
  /// Parses a formatted date string using the supplied `dateFormat`, `timeZone`, and environment locale.
  public static func date(
    from dateString: String,
    dateFormat: String,
    timeZone: TimeZone? = nil,
    env: Environment = AppEnvironment.current
  ) -> Foundation.Date? {
    let formatter = DateFormatterConfig.cachedFormatter(
      forConfig: .init(
        dateFormat: dateFormat,
        dateStyle: nil,
        locale: env.locale,
        template: nil,
        timeStyle: nil,
        timeZone: timeZone ?? env.calendar.timeZone
      )
    )

    return formatter.date(from: dateString)
  }

  /// Formats a UNIX timestamp using explicit `DateFormatter.Style` date and time styles.
  public static func date(
    secondsInUTC seconds: TimeInterval,
    dateStyle: DateFormatter.Style = .medium,
    timeStyle: DateFormatter.Style = .medium,
    timeZone: TimeZone? = nil,
    env: Environment = AppEnvironment.current
  ) -> String {
    let formatter = DateFormatterConfig.cachedFormatter(
      forConfig: .init(
        dateFormat: nil,
        dateStyle: dateStyle,
        locale: env.locale,
        template: nil,
        timeStyle: timeStyle,
        timeZone: timeZone ?? env.calendar.timeZone
      )
    )

    return formatter.string(from: env.dateType.init(timeIntervalSince1970: seconds).date)
  }

  /// Formats a UNIX timestamp using a localized `DateFormatter` template string.
  public static func date(
    secondsInUTC seconds: TimeInterval,
    template: String,
    timeZone: TimeZone? = nil
  ) -> String {
    let formatter = DateFormatterConfig.cachedFormatter(
      forConfig: .init(
        dateFormat: nil,
        dateStyle: nil,
        locale: AppEnvironment.current.locale,
        template: template,
        timeStyle: nil,
        timeZone: timeZone ?? AppEnvironment.current.calendar.timeZone
      )
    )

    return formatter.string(from: AppEnvironment.current.dateType.init(timeIntervalSince1970: seconds).date)
  }

  /// Formats a countdown duration into separate numeric `time` and localized `unit` display components.
  public static func duration(
    secondsInUTC seconds: TimeInterval,
    abbreviate: Bool = false,
    useToGo: Bool = false,
    env: Environment = AppEnvironment.current
  ) -> (time: String, unit: String) {
    let components = env.calendar.dateComponents(
      [.day, .hour, .minute, .second],
      from: env.dateType.init().date,
      to: env.dateType.init(timeIntervalSince1970: seconds).date
    )

    let (day, hour, minute, second) = (
      components.day ?? 0,
      components.hour ?? 0,
      components.minute ?? 0,
      components.second ?? 0
    )

    let string: String
    if day > 1 {
      string = abbreviate
        ? Strings.dates_time_days_abbreviated(time_count: day)
        : Strings.dates_time_days(time_count: day)
    } else if day == 1 || hour > 0 {
      let count = day * 24 + hour
      string = abbreviate
        ? Strings.dates_time_hours_abbreviated(time_count: count)
        : Strings.dates_time_hours(time_count: count)
    } else if minute > 0, second >= 0 {
      string = abbreviate
        ? Strings.dates_time_minutes_abbreviated(time_count: minute)
        : Strings.dates_time_minutes(time_count: minute)
    } else if second <= 0 {
      string = "0 " + Strings.discovery_baseball_card_deadline_units_secs()
    } else {
      string = ""
    }

    let split = string
      .replacingOccurrences(of: "(\\d+) *", with: "$1 ", options: .regularExpression)
      .components(separatedBy: " ")

    guard split.count >= 1 else { return ("", "") }

    let result = (
      time: split.first ?? "",
      unit: split.suffix(from: 1).joined(separator: " ")
    )

    if useToGo {
      return (
        time: result.time,
        unit: Strings.discovery_baseball_card_time_left_to_go(time_left: result.unit)
      )
    }
    return result
  }

  /// Formats a UNIX timestamp relative to the current date (e.g. `"2 days ago"`, `"yesterday"`).
  public static func relative(
    secondsInUTC seconds: TimeInterval,
    abbreviate: Bool = false,
    threshold thresholdInDays: Int = defaultThresholdInDays,
    timeZone: TimeZone? = nil,
    env: Environment = AppEnvironment.current
  ) -> String {
    let components = env.calendar.dateComponents(
      [.day, .hour, .minute, .second],
      from: env.dateType.init(timeIntervalSince1970: seconds).date,
      to: env.dateType.init().date
    )

    let (day, hour, minute, second) = (
      components.day ?? 0,
      components.hour ?? 0,
      components.minute ?? 0,
      components.second ?? 0
    )

    if abs(day) > thresholdInDays {
      return Format.date(
        secondsInUTC: seconds, dateStyle: .medium, timeStyle: .none, timeZone: timeZone ??
          env.calendar.timeZone, env: env
      )
    } else if day > 1 {
      return abbreviate
        ? Strings.dates_time_days_ago_abbreviated(time_count: day)
        : Strings.dates_time_days_ago(time_count: day)
    } else if day == 1 {
      return Strings.dates_yesterday()
    } else if hour > 0 {
      return abbreviate
        ? Strings.dates_time_hours_ago_abbreviated(time_count: hour)
        : Strings.dates_time_hours_ago(time_count: hour)
    } else if minute > 0 {
      return abbreviate
        ? Strings.dates_time_minutes_ago_abbreviated(time_count: minute)
        : Strings.dates_time_minutes_ago(time_count: minute)
    } else if second > 0 {
      return Strings.dates_just_now()
    } else if day < 0 {
      return abbreviate
        ? Strings.dates_time_in_days_abbreviated(time_count: -day)
        : Strings.dates_time_in_days(time_count: -day)
    } else if hour < 0 {
      return abbreviate
        ? Strings.dates_time_in_hours_abbreviated(time_count: -hour)
        : Strings.dates_time_in_hours(time_count: -hour)
    } else if minute < 0 {
      return abbreviate
        ? Strings.dates_time_in_minutes_abbreviated(time_count: -minute)
        : Strings.dates_time_in_minutes(time_count: -minute)
    } else {
      return Strings.dates_right_now()
    }
  }
}

internal struct DateFormatterConfig: Hashable {
  let dateFormat: String?
  fileprivate let dateStyle: DateFormatter.Style?
  fileprivate let locale: Locale
  fileprivate let template: String?
  fileprivate let timeStyle: DateFormatter.Style?
  fileprivate let timeZone: TimeZone

  init(
    dateFormat: String?,
    dateStyle: DateFormatter.Style?,
    locale: Locale,
    template: String?,
    timeStyle: DateFormatter.Style?,
    timeZone: TimeZone
  ) {
    self.dateFormat = dateFormat
    self.dateStyle = dateStyle
    self.locale = locale
    self.template = template
    self.timeStyle = timeStyle
    self.timeZone = timeZone
  }

  private func formatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = self.locale
    formatter.timeZone = self.timeZone
    if let template = self.template {
      formatter.setLocalizedDateFormatFromTemplate(template)
    }
    if let dateFormat = self.dateFormat {
      formatter.dateFormat = dateFormat
    }
    if let dateStyle = self.dateStyle {
      formatter.dateStyle = dateStyle
    }
    if let timeStyle = self.timeStyle {
      formatter.timeStyle = timeStyle
    }
    return formatter
  }

  private static var formatters: [DateFormatterConfig: DateFormatter] = [:]

  internal static func cachedFormatter(forConfig config: DateFormatterConfig) -> DateFormatter {
    let formatter = self.formatters[config] ?? config.formatter()
    self.formatters[config] = formatter
    return formatter
  }
}

