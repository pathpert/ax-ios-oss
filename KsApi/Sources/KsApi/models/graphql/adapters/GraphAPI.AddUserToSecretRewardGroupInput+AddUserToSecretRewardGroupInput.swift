import Foundation
import GraphAPI

/// `GraphAPI.AddUserToSecretRewardGroupInput` extensions declared in `GraphAPI.AddUserToSecretRewardGroupInput+AddUserToSecretRewardGroupInput.swift`.
extension GraphAPI.AddUserToSecretRewardGroupInput {
  static func from(token: String, forProject param: Param) -> GraphAPI.AddUserToSecretRewardGroupInput {
    switch param {
    case let .slug(slug):
      return GraphAPI.AddUserToSecretRewardGroupInput(secretRewardToken: token, slug: .some(slug))
    case let .id(pid):
      return GraphAPI.AddUserToSecretRewardGroupInput(secretRewardToken: token, pid: .some(pid))
    }
  }
}
