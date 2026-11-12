import Foundation
import GraphAPI

/// `GraphAPI.CreateSetupIntentInput` extensions declared in `GraphAPI.CreateSetupIntentInput+CreateSetupIntentInput.swift`.
extension GraphAPI.CreateSetupIntentInput {
  static func from(_ input: CreateSetupIntentInput) -> GraphAPI.CreateSetupIntentInput {
    return GraphAPI.CreateSetupIntentInput(
      projectId: GraphQLNullable.someOrNil(input.projectId),
      setupIntentContext: GraphQLEnum.caseOrNil(input.setupIntentContext)
    )
  }
}
