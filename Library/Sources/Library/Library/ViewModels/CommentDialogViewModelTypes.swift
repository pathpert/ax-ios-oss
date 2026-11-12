import KsApi
import ReactiveSwift

/// Data required to configure `CommentDialogViewModel`.
public struct CommentDialogData {
  /// Project associated with the comment dialog.
  public let project: Project
  /// Optional update being commented on, or `nil` for a project-level comment.
  public let update: Update?
  /// Optional recipient display name when replying to a user.
  public let recipientName: String?
  /// Analytics context describing where the comment dialog was presented.
  public let context: KSRAnalytics.CommentDialogContext
}

/// Inputs accepted by `CommentDialogViewModel`.
public protocol CommentDialogViewModelInputs {
  /// Call when the view appears.
  func viewWillAppear()

  /// Call when the view disappears.
  func viewWillDisappear()

  /// Call with the project, update (optional), recipient name (optional) and context given to the view.
  func configureWith(
    project: Project,
    update: Update?,
    recipientName: String?,
    context: KSRAnalytics.CommentDialogContext
  )

  /// Call when the comment body text changes.
  func commentBodyChanged(_ text: String)

  /// Call when the post comment button is pressed.
  func postButtonPressed()

  /// Call when the cancel button is pressed.
  func cancelButtonPressed()
}

/// Outputs exposed by `CommentDialogViewModel`.
public protocol CommentDialogViewModelOutputs {
  /// Emits a string that should be put into the body text view.
  var bodyTextViewText: Signal<String, Never> { get }

  /// Emits a boolean that determines if the post button is enabled.
  var postButtonEnabled: Signal<Bool, Never> { get }

  /// Emits a boolean that determines if the comment is currently posting.
  var loadingViewIsHidden: Signal<Bool, Never> { get }

  /// Emits the newly posted comment when the present of this dialog should be notified that posting
  /// was successful.
  var notifyPresenterCommentWasPostedSuccesfully: Signal<Comment, Never> { get }

  /// Emits when the dialog should notify its presenter that it wants to be dismissed.
  var notifyPresenterDialogWantsDismissal: Signal<(), Never> { get }

  /// Emits the string to be used as the subtitle of the comment dialog.
  var subtitle: Signal<String, Never> { get }

  /// Emits a boolean that determines if the keyboard should be shown or not.
  var showKeyboard: Signal<Bool, Never> { get }
}

/// Error outputs exposed by `CommentDialogViewModel`.
public protocol CommentDialogViewModelErrors {
  /// Emits a string error description when there has been an error posting a comment.
  var presentError: Signal<String, Never> { get }
}

/// Combined inputs, outputs, and errors interface for `CommentDialogViewModel`.
public protocol CommentDialogViewModelType {
  /// The view model's inputs.
  var inputs: CommentDialogViewModelInputs { get }
  /// The view model's outputs.
  var outputs: CommentDialogViewModelOutputs { get }
  /// The view model's error outputs.
  var errors: CommentDialogViewModelErrors { get }
}

