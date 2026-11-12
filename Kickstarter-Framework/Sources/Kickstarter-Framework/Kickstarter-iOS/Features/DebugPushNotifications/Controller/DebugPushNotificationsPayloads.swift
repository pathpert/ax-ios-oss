import Foundation

/// Immutable value type representing `DebugPushNotificationSample`.
internal struct DebugPushNotificationSample {
  internal enum PayloadSection {
    case activity(category: String, id: Int, projectId: Int? = nil, updateId: Int? = nil)
    case message(threadId: Int, projectId: Int)
    case survey(id: Int, projectId: Int)
    case project(id: Int, photo: String)
    case post(id: Int, projectId: Int)
  }

  internal let alert: String
  internal let section: PayloadSection
  internal let forCreator: Bool

  internal init(alert: String, section: PayloadSection, forCreator: Bool = false) {
    self.alert = alert
    self.section = section
    self.forCreator = forCreator
  }

  internal var userInfo: [AnyHashable: Any] {
    var result: [AnyHashable: Any] = [
      "aps": ["alert": self.alert]
    ]

    switch self.section {
    case let .activity(category, id, projectId, updateId):
      var activity: [String: AnyHashable] = [
        "category": category,
        "id": id
      ]
      if let projectId {
        activity["project_id"] = projectId
      }
      if let updateId {
        activity["update_id"] = updateId
      }
      result["activity"] = activity
    case let .message(threadId, projectId):
      result["message"] = [
        "message_thread_id": threadId,
        "project_id": projectId
      ]
    case let .survey(id, projectId):
      result["survey"] = [
        "id": id,
        "project_id": projectId
      ]
    case let .project(id, photo):
      result["project"] = [
        "photo": photo,
        "id": id
      ]
    case let .post(id, projectId):
      result["post"] = [
        "id": id,
        "project_id": projectId
      ]
    }

    if self.forCreator {
      result["for_creator"] = true
    }

    return result
  }
}

internal let debugPushNotificationSamples: [DebugPushNotificationSample] = [
  DebugPushNotificationSample(
    alert: "Blob McBlobby backed Double Fine Adventure.",
    section: .activity(category: "backing", id: 1, projectId: 1_929_840_910)
  ),
  DebugPushNotificationSample(
    alert: "Update #6 posted by Double Fine Adventure.",
    section: .activity(category: "update", id: 1, projectId: 1_929_840_910, updateId: 190_349)
  ),
  DebugPushNotificationSample(
    alert: "Double Fine Adventure has been successfully funded!",
    section: .activity(category: "success", id: 1, projectId: 1_929_840_910)
  ),
  DebugPushNotificationSample(
    alert: "Double Fine Adventure was not successfully funded.",
    section: .activity(category: "failure", id: 1, projectId: 1_929_840_910)
  ),
  DebugPushNotificationSample(
    alert: "Double Fine Adventure has been canceled.",
    section: .activity(category: "cancellation", id: 1, projectId: 1_929_840_910)
  ),
  DebugPushNotificationSample(
    alert: "Blob McBlobby is following you on Kickstarter!",
    section: .activity(category: "follow", id: 1)
  ),
  DebugPushNotificationSample(
    alert: "Chinati Foundation sent you a message about Robert Irwin Project.",
    section: .message(threadId: 17_848_074, projectId: 820_501_933)
  ),
  DebugPushNotificationSample(
    alert: "Response needed! Get your reward for backing Help Me Transform This Pile of Wood.",
    section: .survey(id: 15_182_605, projectId: 820_501_933)
  ),
  DebugPushNotificationSample(
    alert: "Reminder! This Pile of Wood is ending soon.",
    section: .project(
      id: 820_501_933,
      photo: "https://i.kickstarter.com/assets/012/224/660/847bc4da31e6863e9351bee4e55b8005_original.jpg?fit=pad&height=90&origin=ugc&q=92&width=160&sig=rOHQ6Fif6TxwI%2BL8F9RQY0wUgN%2F4yusD%2FTGXhYW8w%2FQ%3D"
    )
  ),
  DebugPushNotificationSample(
    alert: "New backer! Blob has pledged $50 to Help Me Transform This Pile Of Wood.",
    section: .activity(category: "backing", id: 1, projectId: 820_501_933),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "Blob McBlobby sent you a message about Help Me Transform This Pile Of Wood.",
    section: .message(threadId: 17_848_074, projectId: 820_501_933),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "Help Me Transform This Pile Of Wood was not successfully funded.",
    section: .activity(category: "failure", id: 1, projectId: 820_501_933),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "Help Me Transform This Pile Of Wood has been successfully funded!",
    section: .activity(category: "success", id: 1, projectId: 820_501_933),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "Help Me Transform This Pile Of Wood has been canceled.",
    section: .activity(category: "cancellation", id: 1, projectId: 820_501_933),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "New comment! Blob has commented on Help Me Transform This Pile Of Wood.",
    section: .activity(category: "comment-project", id: 1, projectId: 820_501_933),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "New comment! Blob has commented on update #11.",
    section: .activity(category: "comment-post", id: 1, projectId: 820_501_933, updateId: 1_731_094),
    forCreator: true
  ),
  DebugPushNotificationSample(
    alert: "Blob liked your update: Important message from Tim...",
    section: .post(id: 175_622, projectId: 1_929_840_910),
    forCreator: true
  )
]

