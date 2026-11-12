import Foundation

/// Strongly-typed value union permitted in internal analytics property bags.
///
/// - Negative constraint: Do not pass unvalidated `[String: Any]` dictionaries or arbitrary reference objects into analytics builders.
public enum AnalyticsPropertyValue: Equatable, Sendable {
  /// UTF-8 string property value.
  case string(String)
  /// Integer counter or identifier value.
  case int(Int)
  /// Double-precision floating point metric.
  case double(Double)
  /// Single-precision floating point metric.
  case float(Float)
  /// Fixed-point decimal monetary value.
  case decimal(Decimal)
  /// Boolean flag value.
  case bool(Bool)
  /// Homogeneous array of string tags or keywords.
  case stringArray([String])

  fileprivate var rawValue: Any {
    switch self {
    case let .string(value): return value
    case let .int(value): return value
    case let .double(value): return value
    case let .float(value): return value
    case let .decimal(value): return value
    case let .bool(value): return value
    case let .stringArray(value): return value
    }
  }
}

/// Protocol enabling concrete primitive types to be stored inside `AnalyticsPropertyBag`.
public protocol AnalyticsPropertyConvertible {
  /// Converts `self` into an `AnalyticsPropertyValue`.
  var analyticsPropertyValue: AnalyticsPropertyValue { get }
}

extension String: AnalyticsPropertyConvertible {
  /// Wraps this string in `.string`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .string(self) }
}

extension Int: AnalyticsPropertyConvertible {
  /// Wraps this integer in `.int`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .int(self) }
}

extension Double: AnalyticsPropertyConvertible {
  /// Wraps this double in `.double`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .double(self) }
}

extension Float: AnalyticsPropertyConvertible {
  /// Wraps this float in `.float`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .float(self) }
}

extension Decimal: AnalyticsPropertyConvertible {
  /// Wraps this decimal in `.decimal`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .decimal(self) }
}

extension Bool: AnalyticsPropertyConvertible {
  /// Wraps this boolean in `.bool`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .bool(self) }
}

extension Array: AnalyticsPropertyConvertible where Element == String {
  /// Wraps this `[String]` array in `.stringArray`.
  public var analyticsPropertyValue: AnalyticsPropertyValue { .stringArray(self) }
}

/// Strongly-typed property bag replacing raw `[String: Any]` dictionaries across `KSRAnalytics`.
public struct AnalyticsPropertyBag: Equatable, Sendable {
  private var storage: [String: AnalyticsPropertyValue] = [:]

  /// Creates an empty typed analytics property bag.
  public init() {}

  /// Creates an analytics property bag from a string-only dictionary.
  public init(_ strings: [String: String]) {
    self.storage = strings.mapValues { .string($0) }
  }

  /// Creates an analytics property bag from typed `AnalyticsPropertyValue` entries.
  public init(_ values: [String: AnalyticsPropertyValue]) {
    self.storage = values
  }

  /// `true` when no properties have been recorded.
  public var isEmpty: Bool {
    self.storage.isEmpty
  }

  /// All typed analytics property values keyed by property name.
  public var values: [String: AnalyticsPropertyValue] {
    self.storage
  }

  /// Bridges typed properties to the Segment SDK / callback boundary dictionary.
  public var rawDictionary: [String: Any] {
    self.storage.mapValues(\.rawValue)
  }

  /// Reads the typed property value union stored for `key`, if present.
  public subscript(valueFor key: String) -> AnalyticsPropertyValue? {
    self.storage[key]
  }

  /// Assigns or removes a typed property value for `key`. Assigning `nil` omits the key.
  public subscript<T: AnalyticsPropertyConvertible>(key: String) -> T? {
    get { nil }
    set {
      if let value = newValue?.analyticsPropertyValue {
        self.storage[key] = value
      } else {
        self.storage.removeValue(forKey: key)
      }
    }
  }

  /// Returns a new property bag with `prefix` prepended to every key.
  public func prefixedKeys(_ prefix: String) -> AnalyticsPropertyBag {
    var result = AnalyticsPropertyBag()
    result.storage = Dictionary(
      uniqueKeysWithValues: self.storage.map { key, value in ("\(prefix)\(key)", value) }
    )
    return result
  }

  /// Returns a merged bag where values from `other` overwrite existing keys.
  public func withAllValuesFrom(_ other: AnalyticsPropertyBag) -> AnalyticsPropertyBag {
    var result = self
    result.storage.merge(other.storage) { _, rhs in rhs }
    return result
  }

  /// Returns a merged bag where string entries from `other` overwrite existing keys.
  public func withAllValuesFrom(_ other: [String: String]) -> AnalyticsPropertyBag {
    var result = self
    for (key, value) in other {
      result.storage[key] = .string(value)
    }
    return result
  }
}

