import Foundation
import KsApi

/// Snapshot of authenticated user identity and notification preferences sent to analytics identify calls.
///
/// Format: Equatable `Codable` value storing numeric `userId` alongside typed `AnalyticsPropertyBag` traits.
/// Negative Constraint: Do not mutate traits outside `KSRAnalytics` identify synchronization.
public struct KSRAnalyticsIdentityData: Equatable {
  /// Numeric Kickstarter user identifier (`User.id`).
  public let userId: Int
  private let name: String
  private let notifications: User.Notifications

  init(_ user: User) {
    self.userId = user.id
    self.name = user.name
    self.notifications = user.notifications
  }

  /// Compares two analytics identity snapshots by `userId` and differential trait values.
  public static func == (lhs: KSRAnalyticsIdentityData, rhs: KSRAnalyticsIdentityData) -> Bool {
    guard lhs.userId == rhs.userId else { return false }

    return lhs.uniqueTraits(comparedTo: rhs).isEmpty
  }

  func uniqueTraits(comparedTo otherData: KSRAnalyticsIdentityData?) -> AnalyticsPropertyBag {
    var newTraits = AnalyticsPropertyBag()
    let otherTraits = otherData?.traits ?? [:]

    for (key, value) in self.traits where otherTraits[key] != value {
      switch value {
      case let .string(stringValue):
        newTraits[key] = stringValue
      case let .bool(boolValue):
        newTraits[key] = boolValue
      case let .int(intValue):
        newTraits[key] = intValue
      case let .double(doubleValue):
        newTraits[key] = doubleValue
      case let .float(floatValue):
        newTraits[key] = floatValue
      case let .decimal(decimalValue):
        newTraits[key] = decimalValue
      case let .stringArray(arrayValue):
        newTraits[key] = arrayValue
      }
    }

    return newTraits
  }

  var allTraits: AnalyticsPropertyBag {
    return AnalyticsPropertyBag(self.traits)
  }

  fileprivate var traits: [String: AnalyticsPropertyValue] {
    let decodedNotifications: [String: Bool] = (try? JSONEncoder().encode(self.notifications))
      .flatMap { try? JSONDecoder().decode([String: Bool].self, from: $0) } ?? [:]
    let notifications = decodedNotifications.mapValues(AnalyticsPropertyValue.bool)

    return [
      "name": .string(self.name)
    ]
    .withAllValuesFrom(notifications)
  }
}

extension KSRAnalyticsIdentityData: Codable {
  private enum CodingKeys: String, CodingKey {
    case userId
    case name
    case notifications
  }

  /// Encodes user ID, name, and serialized notification preferences into `encoder`.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.userId, forKey: .userId)
    try container.encode(self.name, forKey: .name)

    let data = try JSONEncoder().encode(self.notifications)
    try container.encode(data, forKey: .notifications)
  }

  /// Decodes an analytics identity snapshot from `decoder`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    self.userId = try values.decode(Int.self, forKey: .userId)
    self.name = try values.decode(String.self, forKey: .name)

    let data = try values.decode(Data.self, forKey: .notifications)
    self.notifications = try JSONDecoder().decode(User.Notifications.self, from: data)
  }
}
