/// A type that understands basic HTTP authentication: username and password.
///
/// Negative Constraint: Only used for non-production staging/dev HTTP Basic gateways; never send over unencrypted HTTP.
public protocol BasicHTTPAuthType {
  var username: String { get }
  var password: String { get }
}

/// Compares two `BasicHTTPAuthType` values by concrete dynamic type, `username`, and `password`.
public func == (lhs: BasicHTTPAuthType, rhs: BasicHTTPAuthType) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs.username == rhs.username &&
    lhs.password == rhs.password
}

/// Compares two optional `BasicHTTPAuthType` values by concrete dynamic type, `username`, and `password`.
public func == (lhs: BasicHTTPAuthType?, rhs: BasicHTTPAuthType?) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs?.username == rhs?.username &&
    lhs?.password == rhs?.password
}

extension BasicHTTPAuthType {
  /// Contents of the `Authorization` header needed to perform basic HTTP auth.
  var authorizationHeader: String? {
    let string = "\(username):\(password)"
    if let data = string.data(using: .utf8) {
      let base64 = data.base64EncodedString(options: .lineLength64Characters)
      return "Basic \(base64)"
    }
    return nil
  }
}

/// Concrete HTTP Basic Authentication credentials container.
public struct BasicHTTPAuth: BasicHTTPAuthType {
  /// HTTP Basic username.
  public let username: String
  /// HTTP Basic password.
  public let password: String

  /// Default development/staging HTTP Basic credentials from `Secrets`.
  public static let development: BasicHTTPAuthType = BasicHTTPAuth(
    username: Secrets.BasicHTTPAuth.username,
    password: Secrets.BasicHTTPAuth.password
  )

  /// Creates HTTP Basic credentials with explicit `username` and `password`.
  public init(username: String, password: String) {
    self.username = username
    self.password = password
  }
}
