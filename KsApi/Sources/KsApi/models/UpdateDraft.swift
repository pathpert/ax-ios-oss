

/// Unpublished creator project update draft containing staged image and video attachments.
///
/// Negative Constraint: `update.publishedAt` is typically `nil` while editing; do not treat drafts as published updates.
public struct UpdateDraft {
  /// Underlying `Update` metadata (`id`, `title`, `body`, `isPublic`).
  public let update: Update
  /// Image attachments currently attached to the draft.
  public let images: [Image]
  /// Optional uploaded video attachment on the draft.
  public let video: Video?

  /// Union representing either a draft image or video attachment.
  public enum Attachment {
    /// Image media attachment.
    case image(Image)
    /// Video media attachment.
    case video(Video)
  }

  /// Uploaded image attachment metadata for a draft update.
  public struct Image {
    /// Server-assigned attachment identifier.
    public let id: Int
    /// Thumbnail image URL string.
    public let thumb: String
    /// Full-resolution image URL string.
    public let full: String
  }

  /// Uploaded video attachment metadata for a draft update.
  public struct Video {
    /// Server-assigned video attachment identifier.
    public let id: Int
    /// Server transcoding status.
    public let status: Status
    /// Poster frame image URL string.
    public let frame: String

    /// Server transcoding lifecycle state for an update draft video.
    public enum Status: String {
      /// Video is still being transcoded.
      case processing
      /// Video transcoding failed.
      case failed
      /// Video finished transcoding and is playable.
      case successful
    }
  }
}

extension UpdateDraft: Equatable {}
/// Compares two `UpdateDraft` values by underlying `update.id`.
public func == (lhs: UpdateDraft, rhs: UpdateDraft) -> Bool {
  return lhs.update.id == rhs.update.id
}

extension UpdateDraft.Attachment {
  /// Identifier of the wrapped `Image` or `Video`.
  public var id: Int {
    switch self {
    case let .image(image):
      return image.id
    case let .video(video):
      return video.id
    }
  }

  /// Preview image URL string (`full` for images, `frame` for videos).
  public var thumbUrl: String {
    switch self {
    case let .image(image):
      return image.full
    case let .video(video):
      return video.frame
    }
  }
}

extension UpdateDraft.Attachment: Equatable {}
/// Compares two `UpdateDraft.Attachment` values by attachment `id`.
public func == (lhs: UpdateDraft.Attachment, rhs: UpdateDraft.Attachment) -> Bool {
  return lhs.id == rhs.id
}

extension UpdateDraft: Decodable {
  enum CodingKeys: String, CodingKey {
    case images
    case video
  }

  /// Decodes a creator update draft along with its embedded `Update`, images, and optional video metadata.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.update = try Update(from: decoder)
    self.images = try values.decode([Image].self, forKey: .images)
    self.video = try values.decodeIfPresent(Video.self, forKey: .video)
  }
}

extension UpdateDraft.Image: Decodable {}
extension UpdateDraft.Video: Decodable {}
extension UpdateDraft.Video.Status: Decodable {}
