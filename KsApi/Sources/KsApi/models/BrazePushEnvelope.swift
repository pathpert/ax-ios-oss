

/// Minimal Braze push notification payload wrapper carrying an Appboy deep-link URI.
public struct BrazePushEnvelope {
  /// Optional Braze deep-link URI extracted from `ab_uri`.
  public let abURI: String?
}

extension BrazePushEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case abURI = "ab_uri"
  }

  /// Decodes an optional Braze deep-link URI from the `ab_uri` push key.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.abURI = try values.decodeIfPresent(String.self, forKey: .abURI)
  }
}
