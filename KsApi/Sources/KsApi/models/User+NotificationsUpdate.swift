import Foundation

extension User.Notifications {
  /// Updates the notification setting identified by its backend API key name.
  ///
  /// - Parameters:
  ///   - apiKey: The snake_case API key defined in `User.Notifications.CodingKeys` (for example, `"notify_of_updates"`).
  ///   - enabled: The new boolean preference value to assign.
  /// - Returns: `true` if `apiKey` matched a known notification setting and was updated; `false` otherwise.
  ///
  /// - Important: Exhaustively maps `User.Notifications.CodingKeys` so callers never construct
  ///   untyped key-value dictionaries to toggle individual notification flags.
  @discardableResult
  public mutating func setNotification(apiKey: String, enabled: Bool) -> Bool {
    guard let key = CodingKeys(rawValue: apiKey) else {
      return false
    }

    switch key {
    case .backings:
      self.backings = enabled
    case .commentReplies:
      self.commentReplies = enabled
    case .comments:
      self.comments = enabled
    case .creatorDigest:
      self.creatorDigest = enabled
    case .creatorTips:
      self.creatorTips = enabled
    case .follower:
      self.follower = enabled
    case .friendActivity:
      self.friendActivity = enabled
    case .messages:
      self.messages = enabled
    case .mobileBackings:
      self.mobileBackings = enabled
    case .mobileComments:
      self.mobileComments = enabled
    case .mobileFriendActivity:
      self.mobileFriendActivity = enabled
    case .mobileMarketingUpdate:
      self.mobileMarketingUpdate = enabled
    case .mobileMessages:
      self.mobileMessages = enabled
    case .mobileFollower:
      self.mobileFollower = enabled
    case .mobilePostLikes:
      self.mobilePostLikes = enabled
    case .mobileUpdates:
      self.mobileUpdates = enabled
    case .postLikes:
      self.postLikes = enabled
    case .updates:
      self.updates = enabled
    }

    return true
  }
}

