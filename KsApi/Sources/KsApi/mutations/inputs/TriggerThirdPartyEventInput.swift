import Foundation
import GraphAPI

/// @deprecated Legacy third-party attribution input primitive using floating-point `Double?` currency
/// (`pledgeAmount`, `shipping`).
/// Prefer `TriggerThirdPartyEventRequestSchema` and `AttributionController` in `KsApi/modules/attribution`.
public struct TriggerThirdPartyEventInput: GraphMutationInput {
  let deviceId: String
  let eventName: String
  let projectId: String
  let pledgeAmount: Double?
  let shipping: Double?
  let transactionId: String?
  let userId: String?
  let appData: GraphAPI.AppDataInput?
  let clientMutationId: String

  private struct EncodableAppData: Encodable {
    let advertiserTrackingEnabled: Bool
    let applicationTrackingEnabled: Bool
    let extinfo: [String]
  }

  private enum CodingKeys: String, CodingKey {
    case deviceId
    case eventName
    case projectId
    case pledgeAmount
    case shipping
    case transactionId
    case userId
    case appData
    case clientMutationId
  }

  /// Creates a legacy third-party attribution mutation input.
  public init(
    deviceId: String,
    eventName: String,
    projectId: String,
    pledgeAmount: Double?,
    shipping: Double?,
    transactionId: String?,
    userId: String?,
    appData: GraphAPI.AppDataInput?,
    clientMutationId: String
  ) {
    self.deviceId = deviceId
    self.eventName = eventName
    self.projectId = projectId
    self.pledgeAmount = pledgeAmount
    self.shipping = shipping
    self.transactionId = transactionId
    self.userId = userId
    self.appData = appData
    self.clientMutationId = clientMutationId
  }

  /// Encodes event fields and Conversions API `appData` cleanly via `Encoder`.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.deviceId, forKey: .deviceId)
    try container.encode(self.eventName, forKey: .eventName)
    try container.encode(self.projectId, forKey: .projectId)
    try container.encodeIfPresent(self.pledgeAmount, forKey: .pledgeAmount)
    try container.encodeIfPresent(self.shipping, forKey: .shipping)
    try container.encodeIfPresent(self.transactionId, forKey: .transactionId)
    try container.encodeIfPresent(self.userId, forKey: .userId)
    if let appData = self.appData {
      let wrapped = EncodableAppData(
        advertiserTrackingEnabled: appData.advertiserTrackingEnabled,
        applicationTrackingEnabled: appData.applicationTrackingEnabled,
        extinfo: appData.extinfo
      )
      try container.encode(wrapped, forKey: .appData)
    }
    try container.encode(self.clientMutationId, forKey: .clientMutationId)
  }
}
