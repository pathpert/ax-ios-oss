import GraphAPI

/// `GraphAPI.CreateFlaggingInput` extensions declared in `GraphAPI.CreateFlaggingInput+CreateFlaggingInput.swift`.
extension GraphAPI.CreateFlaggingInput {
  static func from(_ input: CreateFlaggingInput) -> GraphAPI.CreateFlaggingInput {
    return GraphAPI.CreateFlaggingInput(
      clientMutationId: GraphQLNullable.someOrNil(input.clientMutationId),
      contentId: input.contentId,
      details: GraphQLNullable.someOrNil(input.details),
      kind: GraphQLEnum.case(input.kind)
    )
  }
}
