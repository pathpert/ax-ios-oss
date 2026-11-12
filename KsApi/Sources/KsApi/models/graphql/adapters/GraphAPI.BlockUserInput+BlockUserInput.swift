import Foundation
import GraphAPI

/// `GraphAPI.BlockUserInput` extensions declared in `GraphAPI.BlockUserInput+BlockUserInput.swift`.
extension GraphAPI.BlockUserInput {
  static func from(_ input: BlockUserInput) -> GraphAPI.BlockUserInput {
    return GraphAPI.BlockUserInput(blockUserId: input.blockUserId)
  }
}
