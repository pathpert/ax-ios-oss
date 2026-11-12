import Foundation

/// Strongly typed JSON intermediate representation used to serialize `EncodableQueryParams`
/// into `URLQueryItem` pairs without passing through untyped key-value dictionaries.
internal enum AXQueryValue: Decodable, Equatable {
  case null
  case bool(Bool)
  case integer(Int64)
  case double(Double)
  case string(String)
  case array([AXQueryValue])
  case object([String: AXQueryValue])

  internal init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if container.decodeNil() {
      self = .null
    } else if let boolValue = try? container.decode(Bool.self) {
      self = .bool(boolValue)
    } else if let intValue = try? container.decode(Int64.self) {
      self = .integer(intValue)
    } else if let doubleValue = try? container.decode(Double.self) {
      self = .double(doubleValue)
    } else if let stringValue = try? container.decode(String.self) {
      self = .string(stringValue)
    } else if let arrayValue = try? container.decode([AXQueryValue].self) {
      self = .array(arrayValue)
    } else if let objectValue = try? container.decode([String: AXQueryValue].self) {
      self = .object(objectValue)
    } else {
      throw DecodingError.typeMismatch(
        AXQueryValue.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Unsupported JSON value when encoding query parameters."
        )
      )
    }
  }
}

extension EncodableQueryParams {
  /// Encodes this query parameter struct directly into UTF-8 JSON body data using `JSONEncoder`.
  public func encodedJSONData() -> Data? {
    return try? JSONEncoder().encode(self)
  }

  /// Flattens this query parameter struct into `[URLQueryItem]` pairs using bracketed key syntax
  /// (`key[nested]`, `key[]`) via typed `AXQueryValue` decoding.
  public func encodedQueryItems() -> [URLQueryItem] {
    guard
      let data = self.encodedJSONData(),
      let root = try? JSONDecoder().decode([String: AXQueryValue].self, from: data)
    else {
      return []
    }

    return root
      .sorted { $0.key < $1.key }
      .flatMap { Self.queryItems(forKey: $0.key, value: $0.value) }
  }

  private static func queryItems(forKey key: String, value: AXQueryValue) -> [URLQueryItem] {
    switch value {
    case .null:
      return []
    case let .bool(boolValue):
      return [URLQueryItem(name: key, value: boolValue ? "true" : "false")]
    case let .integer(intValue):
      return [URLQueryItem(name: key, value: String(intValue))]
    case let .double(doubleValue):
      return [URLQueryItem(name: key, value: String(doubleValue))]
    case let .string(stringValue):
      return [URLQueryItem(name: key, value: stringValue)]
    case let .array(items):
      return items.flatMap { self.queryItems(forKey: "\(key)[]", value: $0) }
    case let .object(dictionary):
      return dictionary
        .sorted { $0.key < $1.key }
        .flatMap { self.queryItems(forKey: "\(key)[\($0.key)]", value: $0.value) }
    }
  }
}
