import Foundation

/// Represents a way to paramterize a model by either an `id` integer or `slug` string.
public enum Param {
  /// Numeric backend identifier.
  case id(Int)
  /// URL-friendly string slug identifier.
  case slug(String)

  /// Returns the `id` of the param if it is of type `.id`.
  public var id: Int? {
    if case let .id(id) = self {
      return id
    }
    return nil
  }

  /// Returns the `slug` of the param if it is of type `.slug`.
  public var slug: String? {
    if case let .slug(slug) = self {
      return slug
    }
    return nil
  }

  /// Returns a value suitable for interpolating into a URL.
  public var urlComponent: String {
    switch self {
    case let .id(id):
      return String(id)
    case let .slug(slug):
      return slug
    }
  }

  /// Returns a percent-encoded RFC 3986 path component when parameterized by `.slug`, or the decimal ID string for `.id`.
  public var escapedUrlComponent: String {
    switch self {
    case let .id(id):
      return String(id)
    case let .slug(slug):
      return encodeForRFC3986(slug) ?? ""
    }
  }
}

extension Param: Equatable {}
/// Compares two `Param` route identifiers by underlying numeric ID or stringified slug.
public func == (lhs: Param, rhs: Param) -> Bool {
  switch (lhs, rhs) {
  case let (.id(lhs), .id(rhs)):
    return lhs == rhs
  case let (.slug(lhs), .slug(rhs)):
    return lhs == rhs
  case let (.id(lhs), .slug(rhs)):
    return String(lhs) == rhs
  case let (.slug(lhs), .id(rhs)):
    return lhs == String(rhs)
  }
}

private let allowableRFC3986: CharacterSet = {
  var set = CharacterSet.alphanumerics
  set.insert(charactersIn: "-._~/?")
  return set
}()

private func encodeForRFC3986(_ str: String) -> String? {
  return str.addingPercentEncoding(withAllowedCharacters: allowableRFC3986)
}
