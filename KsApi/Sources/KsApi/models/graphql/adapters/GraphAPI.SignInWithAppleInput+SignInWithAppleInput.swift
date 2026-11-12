import Foundation
import GraphAPI

/// `GraphAPI.SignInWithAppleInput` extensions declared in `GraphAPI.SignInWithAppleInput+SignInWithAppleInput.swift`.
extension GraphAPI.SignInWithAppleInput {
  static func from(_ input: SignInWithAppleInput) -> GraphAPI.SignInWithAppleInput {
    return GraphAPI.SignInWithAppleInput(
      authCode: input.authCode,
      firstName: GraphQLNullable.someOrNil(input.firstName),
      iosAppId: input.appId,
      lastName: GraphQLNullable.someOrNil(input.lastName)
    )
  }
}
