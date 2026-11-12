import Foundation
import GraphAPI

/// @deprecated Legacy third-party attribution input primitive using floating-point `Double?` currency
/// (`pledgeAmount`, `shipping`) and untyped `[String: Any]` dictionary serialization.
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

  /// Serializes fields into an untyped GraphQL variable dictionary.
  ///
  /// Negative Constraint: Deprecated; migrate to `TriggerThirdPartyEventRequestSchema`.
  public func toInputDictionary() -> [String: Any] {
    return [
      "deviceId": self.deviceId,
      "eventName": self.eventName,
      "projectId": self.projectId,
      "pledgeAmount": self.pledgeAmount,
      "shipping": self.shipping,
      "transactionId": self.transactionId,
      "userId": self.userId,
      "appData": self.appData,
      "clientMutationId": self.clientMutationId
    ]
  }
}
