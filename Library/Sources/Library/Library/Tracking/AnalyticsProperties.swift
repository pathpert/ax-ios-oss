import Foundation

/// Strongly-typed value union permitted in internal analytics property bags.
///
/// - Negative constraint: Do not pass unvalidated untyped property dictionaries or arbitrary reference objects into analytics builders.
public enum AnalyticsPropertyValue: Codable, Equatable, Sendable {
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

  /// Decodes a primitive analytics property value from JSON.
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let value = try? container.decode(Bool.self) {
      self = .bool(value)
    } else if let value = try? container.decode(Int.self) {
      self = .int(value)
    } else if let value = try? container.decode(Double.self) {
      self = .double(value)
    } else if let value = try? container.decode(String.self) {
      self = .string(value)
    } else if let value = try? container.decode([String].self) {
      self = .stringArray(value)
    } else {
      throw DecodingError.typeMismatch(
        AnalyticsPropertyValue.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Unsupported analytics property value."
        )
      )
    }
  }

  /// Encodes the underlying typed analytics value cleanly via `Encoder`.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case let .string(value): try container.encode(value)
    case let .int(value): try container.encode(value)
    case let .double(value): try container.encode(value)
    case let .float(value): try container.encode(value)
    case let .decimal(value): try container.encode(value)
    case let .bool(value): try container.encode(value)
    case let .stringArray(value): try container.encode(value)
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

/// Strongly-typed property bag replacing raw untyped dictionaries across `KSRAnalytics`.
public struct AnalyticsPropertyBag: Codable, Equatable, Sendable {
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

  /// Decodes a keyed analytics property bag from JSON.
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: _AnalyticsCodingKey.self)
    var decoded: [String: AnalyticsPropertyValue] = [:]
    for key in container.allKeys {
      decoded[key.stringValue] = try container.decode(AnalyticsPropertyValue.self, forKey: key)
    }
    self.storage = decoded
  }

  /// Encodes all typed property values into a flat JSON object.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: _AnalyticsCodingKey.self)
    for (key, value) in self.storage {
      if let codingKey = _AnalyticsCodingKey(stringValue: key) {
        try container.encode(value, forKey: codingKey)
      }
    }
  }

  /// `true` when no properties have been recorded.
  public var isEmpty: Bool {
    self.storage.isEmpty
  }

  /// All typed analytics property values keyed by property name.
  public var values: [String: AnalyticsPropertyValue] {
    self.storage
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

private struct _AnalyticsCodingKey: CodingKey {
  var stringValue: String
  var intValue: Int? { nil }
  init?(stringValue: String) { self.stringValue = stringValue }
  init?(intValue _: Int) { nil }
}

