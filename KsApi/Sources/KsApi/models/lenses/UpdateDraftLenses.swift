import Prelude

extension UpdateDraft {
  /// Functional lenses for `UpdateDraft`.
  public enum lens {
    /// Lens focusing on the underlying `Update` model of a draft.
    public static let update = Lens<UpdateDraft, Update>(
      view: { $0.update },
      set: { UpdateDraft(update: $0, images: $1.images, video: $1.video) }
    )

    /// Lens focusing on the uploaded images attached to an update draft.
    public static let images = Lens<UpdateDraft, [UpdateDraft.Image]>(
      view: { $0.images },
      set: { UpdateDraft(update: $1.update, images: $0, video: $1.video) }
    )

    /// Lens focusing on the optional video attachment of an update draft.
    public static let video = Lens<UpdateDraft, UpdateDraft.Video?>(
      view: { $0.video },
      set: { UpdateDraft(update: $1.update, images: $1.images, video: $0) }
    )
  }
}

extension UpdateDraft.Image {
  /// Functional lenses for `UpdateDraft.Image`.
  public enum lens {
    /// Lens focusing on the draft image identifier.
    public static let id = Lens<UpdateDraft.Image, Int>(
      view: { $0.id },
      set: { UpdateDraft.Image(id: $0, thumb: $1.thumb, full: $1.full) }
    )

    /// Lens focusing on the thumbnail image URL string.
    public static let thumb = Lens<UpdateDraft.Image, String>(
      view: { $0.thumb },
      set: { UpdateDraft.Image(id: $1.id, thumb: $0, full: $1.full) }
    )

    /// Lens focusing on the full-resolution image URL string.
    public static let full = Lens<UpdateDraft.Image, String>(
      view: { $0.thumb },
      set: { UpdateDraft.Image(id: $1.id, thumb: $1.thumb, full: $0) }
    )
  }
}

extension UpdateDraft.Video {
  /// Functional lenses for `UpdateDraft.Video`.
  public enum lens {
    /// Lens focusing on the uploaded video identifier.
    public static let id = Lens<UpdateDraft.Video, Int>(
      view: { $0.id },
      set: { UpdateDraft.Video(id: $0, status: $1.status, frame: $1.frame) }
    )

    /// Lens focusing on the server-side transcoding `Status`.
    public static let status = Lens<UpdateDraft.Video, Status>(
      view: { $0.status },
      set: { UpdateDraft.Video(id: $1.id, status: $0, frame: $1.frame) }
    )

    /// Lens focusing on the poster frame image URL string.
    public static let frame = Lens<UpdateDraft.Video, String>(
      view: { $0.frame },
      set: { UpdateDraft.Video(id: $1.id, status: $1.status, frame: $0) }
    )
  }
}

extension Lens where Whole == UpdateDraft, Part == Update {
  /// Composed lens focusing on the draft's `Update.id`.
  public var id: Lens<UpdateDraft, Int> {
    return UpdateDraft.lens.update .. Update.lens.id
  }

  /// Composed lens focusing on the draft's `Update.projectId`.
  public var projectId: Lens<UpdateDraft, Int> {
    return UpdateDraft.lens.update .. Update.lens.projectId
  }

  /// Composed lens focusing on the draft's `Update.title`.
  public var title: Lens<UpdateDraft, String> {
    return UpdateDraft.lens.update .. Update.lens.title
  }

  /// Composed lens focusing on the draft's `Update.body`.
  public var body: Lens<UpdateDraft, String?> {
    return UpdateDraft.lens.update .. Update.lens.body
  }

  /// Composed lens focusing on the draft's `Update.isPublic` visibility flag.
  public var isPublic: Lens<UpdateDraft, Bool> {
    return UpdateDraft.lens.update .. Update.lens.isPublic
  }

  /// Composed lens focusing on the draft's `Update.sequence` number.
  public var sequence: Lens<UpdateDraft, Int> {
    return UpdateDraft.lens.update .. Update.lens.sequence
  }
}
