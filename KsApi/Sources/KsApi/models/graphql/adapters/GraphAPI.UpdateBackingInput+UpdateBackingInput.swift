import Foundation
import GraphAPI

/// `GraphAPI.UpdateBackingInput` extensions declared in `GraphAPI.UpdateBackingInput+UpdateBackingInput.swift`.
extension GraphAPI.UpdateBackingInput {
  static func from(_ input: UpdateBackingInput) -> GraphAPI.UpdateBackingInput {
    return GraphAPI.UpdateBackingInput(
      amount: GraphQLNullable.someOrNil(input.amount),
      applePay: GraphQLNullable.someOrNil(
        GraphAPI.ApplePayInput.from(input.applePay)
      ),
      id: input.id,
      incremental: GraphQLNullable.someOrNil(input.incremental),
      intentClientSecret: GraphQLNullable.someOrNil(input.setupIntentClientSecret),
      locationId: GraphQLNullable.someOrNil(input.locationId),
      paymentSourceId: GraphQLNullable.someOrNil(input.paymentSourceId),
      rewardIds: GraphQLNullable.someOrNil(input.rewardIds)
    )
  }
}
