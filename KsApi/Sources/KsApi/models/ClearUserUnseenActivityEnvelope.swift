import Foundation

/// GraphQL mutation response envelope containing the updated unseen-activity badge count.
public struct ClearUserUnseenActivityEnvelope {
  /// Updated unseen activity indicator count after clearing notifications.
  public var activityIndicatorCount: Int
}

extension ClearUserUnseenActivityEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case clearUserUnseenActivity
    case activityIndicatorCount
  }

  /// Decodes the updated activity indicator count from `clearUserUnseenActivity`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.activityIndicatorCount = try values
      .nestedContainer(keyedBy: CodingKeys.self, forKey: .clearUserUnseenActivity)
      .decode(Int.self, forKey: .activityIndicatorCount)
  }
}
