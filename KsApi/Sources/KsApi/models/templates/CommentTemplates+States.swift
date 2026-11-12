import Foundation

extension Comment {
  /// Comment fixture whose author is blocked by the current user.
  public static let blockedTemplate = Comment(
    author: Author(
      id: "ADG8hYbp7gsDAZ==",
      imageUrl: "https://ks/img/cordero.jpg",
      isBlocked: true,
      isCreator: false,
      name: "Cordero"
    ),
    authorBadges: [.superbacker],
    body: "Since the author is blocked, this comment text should never be seen.",
    createdAt: Date(timeIntervalSince1970: 1_475_361_115).timeIntervalSince1970,
    id: "BOD5af89jdDA4fG==",
    isDeleted: false,
    replyCount: 0,
    hasFlaggings: false,
    removedPerGuidelines: false,
    sustained: false,
    status: .success
  )

  /// Comment fixture representing a failed submission by the current user.
  public static let failedTemplate = Comment(
    author: Author(
      id: "AKLEhYbp7CDO6E==",
      imageUrl: "https://ks_.img/johnson.jpg",
      isBlocked: false,
      isCreator: false,
      name: "Maribeth Bainbridge"
    ),
    authorBadges: [.you],
    body: "It is true what SafeUniverse is saying Doug. To do business in NY you have to be a registered business in NY even if you are registered in another state. What can Nimble provide to show they are registered in NY SafeUniverse?",
    createdAt: Date(timeIntervalSince1970: 1_475_361_100).timeIntervalSince1970,
    id: "78DJa89jdSDJ89sd8==",
    isDeleted: false,
    replyCount: 15,
    hasFlaggings: false,
    removedPerGuidelines: false,
    sustained: false,
    status: .failed
  )

  /// Comment fixture representing an in-flight retry submission.
  public static let retryingTemplate = Comment(
    author: Author(
      id: "AKLEhYbp7CDO6E==",
      imageUrl: "https://ks_.img/johnson.jpg",
      isBlocked: false,
      isCreator: false,
      name: "Maribeth Bainbridge"
    ),
    authorBadges: [.you],
    body: "It is true what SafeUniverse is saying Doug. To do business in NY you have to be a registered business in NY even if you are registered in another state. What can Nimble provide to show they are registered in NY SafeUniverse?",
    createdAt: Date(timeIntervalSince1970: 1_475_361_100).timeIntervalSince1970,
    id: "78DJa89jdSDJ89sd8==",
    isDeleted: false,
    replyCount: 15,
    hasFlaggings: false,
    removedPerGuidelines: false,
    sustained: false,
    status: .retrying
  )

  /// Comment fixture representing a retry submission that succeeded.
  public static let retrySuccessTemplate = Comment(
    author: Author(
      id: "AKLEhYbp7CDO6E==",
      imageUrl: "https://ks_.img/johnson.jpg",
      isBlocked: false,
      isCreator: false,
      name: "Maribeth Bainbridge"
    ),
    authorBadges: [.you],
    body: "It is true what SafeUniverse is saying Doug. To do business in NY you have to be a registered business in NY even if you are registered in another state. What can Nimble provide to show they are registered in NY SafeUniverse?",
    createdAt: Date(timeIntervalSince1970: 1_475_361_100).timeIntervalSince1970,
    id: "78DJa89jdSDJ89sd8==",
    isDeleted: false,
    replyCount: 4,
    hasFlaggings: false,
    removedPerGuidelines: false,
    sustained: false,
    status: .retrySuccess
  )

  /// Flagged comment fixture currently under moderation review.
  public static let commentUnderReviewTemplate = Comment(
    author: Author(
      id: "ADG8hYbp7gsDAZ==",
      imageUrl: "https://ks/img/cordero.jpg",
      isBlocked: false,
      isCreator: false,
      name: "Cordero"
    ),
    authorBadges: [.superbacker],
    body: "This comment text should never be seen.",
    createdAt: Date(timeIntervalSince1970: 1_475_361_115).timeIntervalSince1970,
    id: "BOD5af89jdDA4fG==",
    isDeleted: false,
    replyCount: 0,
    hasFlaggings: true,
    removedPerGuidelines: false,
    sustained: false,
    status: .success
  )

  /// Comment fixture removed for violating community guidelines.
  public static let commentRemovedPerGuidelinesTemplate = Comment(
    author: Author(
      id: "ADG8hYbp7gsDAZ==",
      imageUrl: "https://ks/img/cordero.jpg",
      isBlocked: false,
      isCreator: false,
      name: "Cordero"
    ),
    authorBadges: [.superbacker],
    body: "This comment text should never be seen.",
    createdAt: Date(timeIntervalSince1970: 1_475_361_115).timeIntervalSince1970,
    id: "BOD5af89jdDA4fG==",
    isDeleted: true,
    replyCount: 0,
    hasFlaggings: true,
    removedPerGuidelines: true,
    sustained: false,
    status: .success
  )

  /// Default collection of comment fixtures covering creator, deleted, superbacker, backer, and failed states.
  public static let templates: [Comment] = [
    .template,
    .deletedTemplate,
    .superbackerTemplate,
    .backerTemplate,
    .failedTemplate
  ]
}

