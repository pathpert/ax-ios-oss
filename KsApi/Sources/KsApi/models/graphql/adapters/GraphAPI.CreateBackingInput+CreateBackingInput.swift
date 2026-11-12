import Foundation
import GraphAPI

/// `GraphAPI.CreateBackingInput` extensions declared in `GraphAPI.CreateBackingInput+CreateBackingInput.swift`.
extension GraphAPI.CreateBackingInput {
  static func from(_ input: CreateBackingInput) -> GraphAPI.CreateBackingInput {
    return GraphAPI.CreateBackingInput(
      amount: GraphQLNullable.someOrNil(input.amount),
      projectId: input.projectId,
      locationId: GraphQLNullable.someOrNil(input.locationId),
      refParam: GraphQLNullable.someOrNil(input.refParam),
      rewardIds: GraphQLNullable.someOrNil(input.rewardIds),
      applePay: GraphQLNullable.someOrNil(GraphAPI.ApplePayInput.from(input.applePay)),
      incremental: GraphQLNullable.someOrNil(input.incremental),
      paymentSourceId: GraphQLNullable.someOrNil(input.paymentSourceId),
      setupIntentClientSecret: GraphQLNullable.someOrNil(input.setupIntentClientSecret)
    )
  }
}
