

/// APNs push notification payload decoded by the client router.
///
/// - Negative constraint: Do not mutate notification payloads client-side or treat missing optional sub-envelopes as errors.
public struct PushEnvelope {
  /// Activity update payload when the push originates from feed/social activity.
  public let activity: Activity?
  /// Standard Apple Push Notification `aps` envelope containing the display alert text.
  public let aps: ApsEnvelope
  /// Errored-pledge payload when a backing charge fails.
  public let erroredPledge: ErroredPledge?
  /// Indicates whether the notification targets the creator role (`nil` when unspecified).
  public let forCreator: Bool?
  /// Direct message thread payload when the push relates to inbox messages.
  public let message: Message?
  /// Pledge-manager order payload when an order action is available.
  public let order: Order?
  /// Associated project summary payload.
  public let project: Project?
  /// Backer survey payload prompting survey completion.
  public let survey: Survey?
  /// Project update post payload (`update` or legacy `post` key).
  public let update: Update?

  /// Activity push sub-envelope identifying the activity item and optional media/targets.
  public struct Activity {
    /// Activity category distinguishing updates, comments, backings, or social events.
    public let category: KsApi.Activity.Category
    /// Optional comment identifier associated with a comment activity.
    public let commentId: String?
    /// Numeric Kickstarter activity identifier.
    public let id: Int
    /// Associated project identifier, if scoped to a project.
    public let projectId: Int?
    /// URL string for the project's thumbnail photo.
    public let projectPhoto: String?
    /// Optional reply comment identifier when the notification is for a comment reply.
    public let replyId: String?
    /// Associated project update identifier, if applicable.
    public let updateId: Int?
    /// URL string for the acting user's avatar photo.
    public let userPhoto: String?
  }

  /// Standard APNs `aps` dictionary wrapper.
  public struct ApsEnvelope {
    /// Localized alert banner copy displayed by iOS.
    public let alert: String
  }

  /// Payload identifying a project with an errored pledge requiring payment action.
  public struct ErroredPledge {
    /// Numeric project identifier for the errored pledge.
    public let projectId: Int
  }

  /// Payload routing to a creator/backer message thread.
  public struct Message {
    /// Numeric identifier of the message thread to open.
    public let messageThreadId: Int
    /// Numeric identifier of the project associated with the thread.
    public let projectId: Int
  }

  /// Payload routing to a pledge manager order.
  public struct Order {
    /// Numeric pledge-manager order identifier.
    public let id: Int
    /// Numeric identifier of the associated project.
    public let projectId: Int
    /// Relative web path to the pledge manager experience.
    public let pledgeManagerPath: String
  }

  /// Minimal project reference embedded in a push notification.
  public struct Project {
    /// Numeric Kickstarter project identifier.
    public let id: Int
    /// Optional project photo URL string.
    public let photo: String?
  }

  /// Backer survey notification payload.
  public struct Survey {
    /// Numeric survey identifier.
    public let id: Int
    /// Numeric project identifier owning the survey.
    public let projectId: Int

    /// Nested web URLs container providing the survey path (`urls.web.survey`).
    public struct Urls: Decodable {
      /// Web URL leaf container for survey deep linking.
      public struct Web: Decodable {
        /// Relative or absolute survey path on Kickstarter web.
        public let survey: String
      }

      /// Web routing URLs for the survey.
      public let web: Web
    }

    /// URL container describing where to open the survey.
    public let urls: Urls
  }

  /// Project update notification payload.
  public struct Update {
    /// Numeric project update identifier.
    public let id: Int
    /// Numeric project identifier owning the update.
    public let projectId: Int
  }
}

extension PushEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case activity
    case aps
    case erroredPledge = "errored_pledge"
    case forCreator = "for_creator"
    case message
    case order
    case project
    case survey
    case update
    case post
  }

  /// Decodes an incoming push notification payload into strongly typed deep-link targets.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.activity = try values.decodeIfPresent(Activity.self, forKey: .activity)
    self.aps = try values.decode(ApsEnvelope.self, forKey: .aps)
    self.erroredPledge = try values.decodeIfPresent(ErroredPledge.self, forKey: .erroredPledge)
    self.forCreator = try values.decodeIfPresent(Bool.self, forKey: .forCreator)
    self.message = try values.decodeIfPresent(Message.self, forKey: .message)
    self.project = try values.decodeIfPresent(Project.self, forKey: .project)
    self.order = try values.decodeIfPresent(Order.self, forKey: .order)
    self.survey = try values.decodeIfPresent(Survey.self, forKey: .survey)
    if values.contains(.update) {
      self.update = try values.decodeIfPresent(Update.self, forKey: .update)
    } else {
      self.update = try values.decodeIfPresent(Update.self, forKey: .post)
    }
  }
}

extension PushEnvelope.Activity: Decodable {
  enum CodingKeys: String, CodingKey {
    case category
    case commentId = "comment"
    case id
    case projectId = "project_id"
    case projectPhoto = "project_photo"
    case replyId = "reply"
    case updateId = "update_id"
    case userPhoto = "user_photo"
  }
}

extension PushEnvelope.ApsEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case alert
  }
}

extension PushEnvelope.ErroredPledge: Decodable {
  enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
  }
}

extension PushEnvelope.Message: Decodable {
  enum CodingKeys: String, CodingKey {
    case messageThreadId = "message_thread_id"
    case projectId = "project_id"
  }
}

extension PushEnvelope.Order: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case projectId = "project_id"
    case pledgeManagerPath = "pledge_manager_path"
  }
}

extension PushEnvelope.Project: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case photo
  }
}

extension PushEnvelope.Survey: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case projectId = "project_id"
    case urls
  }
}

extension PushEnvelope.Update: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case projectId = "project_id"
  }
}
