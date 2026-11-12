import KsApi
import ReactiveSwift
import UIKit

/// Input events handled by `UpdateDraftViewModel`.
public protocol UpdateDraftViewModelInputs {
  /// Call when the creator taps "add attachment".
  func addAttachmentButtonTapped(availableSources: [AttachmentSource])

  /// Call when the creator taps a selection from the attachment actions sheet.
  func addAttachmentSheetButtonTapped(_ action: AttachmentSource)

  /// Call when a creator taps an attachment to be removed.
  func attachmentTapped(id: Int)

  /// Call when the draft body changes.
  func bodyTextChanged(to body: String)

  /// Call when the creator taps "Close".
  func closeButtonTapped()

  /// Call with the project provided to the view.
  func configureWith(project: Project)

  /// Call with the image picked by the image picker.
  func imagePicked(url: URL, fromSource source: AttachmentSource)

  /// Call when the image picker is canceled.
  func imagePickerCanceled()

  /// Call when the creator taps "public"/"backers only".
  func isBackersOnlyOn(_ isBackersOnly: Bool)

  /// Call when the creator taps "preview".
  func previewButtonTapped()

  /// Call when attachment removal confirmed.
  func remove(attachment: UpdateDraft.Attachment)

  /// Call when the draft title changes.
  func titleTextChanged(to title: String)

  /// Call when title text field keyboard returns.
  func titleTextFieldDoneEditing()

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when the view will disappear.
  func viewWillDisappear()
}

/// Output signals emitted by `UpdateDraftViewModel`.
public protocol UpdateDraftViewModelOutputs {
  /// An attachment was added.
  var attachmentAdded: Signal<UpdateDraft.Attachment, Never> { get }

  /// An attachment was removed.
  var attachmentRemoved: Signal<UpdateDraft.Attachment, Never> { get }

  /// An collection of attachments.
  var attachments: Signal<[UpdateDraft.Attachment], Never> { get }

  /// The draft's working body.
  var body: Signal<String, Never> { get }

  /// When the body text view should become first responder.
  var bodyTextViewBecomeFirstResponder: Signal<(), Never> { get }

  /// Emits when the view controller should show a preview.
  var goToPreview: Signal<UpdateDraft, Never> { get }

  /// Whether or not to show the attachments section.
  var isAttachmentsSectionHidden: Signal<Bool, Never> { get }

  /// Whether or not the draft is being fetched from the API.
  var isLoading: Signal<Bool, Never> { get }

  /// Whether or not the draft is limited to backers only.
  var isBackersOnly: Signal<Bool, Never> { get }

  /// Whether or not the body placeholder is visible.
  var isBodyPlaceholderHidden: Signal<Bool, Never> { get }

  /// Whether or no the preview button should be enabled.
  var isPreviewButtonEnabled: Signal<Bool, Never> { get }

  /// Emits the update number, formatted.
  var navigationItemTitle: Signal<String, Never> { get }

  /// Emits when the view controller should be dismissed.
  var notifyPresenterViewControllerWantsDismissal: Signal<(), Never> { get }

  /// Emits when the keyboard should be dismissed.
  var resignFirstResponder: Signal<(), Never> { get }

  /// Emits when adding an attachment fails.
  var showAddAttachmentFailure: Signal<(), Never> { get }

  /// Emits when add attachment is tapped.
  var showAttachmentActions: Signal<[AttachmentSource], Never> { get }

  /// Emits when the creator selects "add photo" or "choose from camera roll".
  var showImagePicker: Signal<AttachmentSource, Never> { get }

  /// Emits when the view controller should show a load error.
  var showLoadFailure: Signal<(), Never> { get }

  /// Emits when an attachment is tapped.
  var showRemoveAttachmentConfirmation: Signal<UpdateDraft.Attachment, Never> { get }

  /// Emits when removing an attachment failed.
  var showRemoveAttachmentFailure: Signal<(), Never> { get }

  /// Emits when a save fails.
  var showSaveFailure: Signal<(), Never> { get }

  /// The draft's working title.
  var title: Signal<String, Never> { get }

  /// When the body text view should become first responder.
  var titleTextFieldBecomeFirstResponder: Signal<(), Never> { get }
}

/// View model interface for composing and previewing creator project update drafts.
public protocol UpdateDraftViewModelType {
  /// Input receiver for user and lifecycle actions.
  var inputs: UpdateDraftViewModelInputs { get }
  /// Output signals bound by the view controller.
  var outputs: UpdateDraftViewModelOutputs { get }
}

/// Supported image attachment sources for creator update drafts.
public enum AttachmentSource: String, Equatable {
  case camera
  case cameraRoll = "camera_roll"

  /// Creates an attachment source from a UIKit image picker source type.
  public init(sourceType: UIImagePickerController.SourceType) {
    switch sourceType {
    case .camera:
      self = .camera
    case .photoLibrary:
      self = .cameraRoll
    default:
      fatalError("unsupported source: \(sourceType)")
    }
  }

  /// Localized action sheet button title for this attachment source.
  public var title: String {
    switch self {
    case .camera:
      return Strings.dashboard_post_update_compose_attachment_buttons_new_photo()
    case .cameraRoll:
      return Strings.dashboard_post_update_compose_attachment_buttons_choose_from_camera_roll()
    }
  }

  /// Corresponding UIKit image picker source type.
  public var sourceType: UIImagePickerController.SourceType {
    switch self {
    case .camera:
      return .camera
    case .cameraRoll:
      return .photoLibrary
    }
  }
}

/// Equality check for `AttachmentSource`.
public func == (lhs: AttachmentSource, rhs: AttachmentSource) -> Bool {
  switch (lhs, rhs) {
  case (.camera, .camera), (.cameraRoll, .cameraRoll):
    return true
  default:
    return false
  }
}

