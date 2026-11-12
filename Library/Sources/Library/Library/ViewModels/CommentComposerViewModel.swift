import Foundation
import KsApi
import ReactiveSwift

/// Strongly-typed configuration contract for rendering `CommentComposerView`.
///
/// Negative Constraint: `hidden` hides the entire composer bar when the viewer is logged out;
/// `canPostComment` only disables/hides the text input when logged in without commenting permission.
public struct CommentComposerViewData: Equatable, Sendable {
  /// Viewer avatar image URL rendered beside the input field, or `nil` for placeholder.
  public let avatarURL: URL?
  /// `true` when the viewer is authorized to post comments (backer or creator/collaborator).
  public let canPostComment: Bool
  /// `true` to hide the composer bar completely.
  public let hidden: Bool
  /// `true` to focus the reply/comment input immediately on appear.
  public let becomeFirstResponder: Bool

  /// Creates a typed `CommentComposerViewData` contract.
  public init(
    avatarURL: URL?,
    canPostComment: Bool,
    hidden: Bool,
    becomeFirstResponder: Bool
  ) {
    self.avatarURL = avatarURL
    self.canPostComment = canPostComment
    self.hidden = hidden
    self.becomeFirstResponder = becomeFirstResponder
  }
}

/// Constants governing comment composition validation.
public enum CommentComposerConstant {
  // The API only supports comments not more than 9000 characters
  /// Maximum allowed character length for a comment body.
  public static let characterLimit: Int = 9_000
}

/// Inputs accepted by `CommentComposerViewModel`.
public protocol CommentComposerViewModelInputs {
  /// Call when the comment text changes.
  func bodyTextDidChange(_ text: String?)

  /// Call to configure composer avatar and input area visibility
  func configure(with data: CommentComposerViewData)

  /// Call when the post button is pressed.
  func postButtonPressed()

  /// Call when the input textview of the composer should be reset.
  func resetInput()

  /// Call in `textView(_:shouldChangeTextIn:replacementText:)` `UITextViewDelegate` method.
  func textViewShouldChange(text: String?, in range: NSRange, replacementText: String) -> Bool
}

/// Outputs exposed by `CommentComposerViewModel`.
public protocol CommentComposerViewModelOutputs {
  /// Emits the URL to be used to load user's avatar
  var avatarURL: Signal<URL?, Never> { get }

  /// Emits a string that should be put into the body text view.
  var bodyText: Signal<String?, Never> { get }

  /// Emits when input text view's text should be cleared
  var clearInputTextView: Signal<(), Never> { get }

  /// Emits a boolean that determines if the comment composer view is hidden.
  var commentComposerHidden: Signal<Bool, Never> { get }

  /// Emits a boolean that determines if the input area is hidden.
  var inputAreaHidden: Signal<Bool, Never> { get }

  /// Emits when the input textview should become first responder.
  var inputTextViewDidBecomeFirstResponder: Signal<Bool, Never> { get }

  /// Emits when composer notifies view controller of comment submitted.
  var notifyDelegateDidSubmitText: Signal<String, Never> { get }

  /// Emits a boolean that determines if the placeholder label is hidden.
  var placeholderHidden: Signal<Bool, Never> { get }

  /// Emits a boolean that determines if the post button is hidden.
  var postButtonHidden: Signal<Bool, Never> { get }

  /// Emits when the input area size should be reset.
  var updateTextViewHeight: Signal<(), Never> { get }
}

/// Combined inputs and outputs interface for `CommentComposerViewModel`.
public protocol CommentComposerViewModelType {
  /// The view model's inputs.
  var inputs: CommentComposerViewModelInputs { get }
  /// The view model's outputs.
  var outputs: CommentComposerViewModelOutputs { get }
}

/// View model backing the inline comment and reply composer bar.
public final class CommentComposerViewModel:
  CommentComposerViewModelType,
  CommentComposerViewModelInputs,
  CommentComposerViewModelOutputs {
  /// Creates a new `CommentComposerViewModel` and binds input/output signals.
  public init() {
    self.avatarURL = self.configDataProperty.signal.skipNil().map(\.avatarURL)
    self.bodyText = Signal.merge(
      self.bodyTextDidChangeProperty.signal,
      self.resetInputProperty.signal.mapConst(nil)
    )
    self.inputAreaHidden = self.configDataProperty.signal.skipNil().map(\.canPostComment).negate()

    self.commentComposerHidden = self.configDataProperty.signal.skipNil().map(\.hidden)

    self.notifyDelegateDidSubmitText = self.bodyText.skipNil()
      .takeWhen(self.postButtonPressedProperty.signal)
      .map { $0.trimmed() }

    self.placeholderHidden = Signal.merge(
      self.configDataProperty.signal.mapConst(false).take(first: 1),
      self.bodyText.map { $0?.isEmpty == false }
    )

    self.postButtonHidden = Signal.merge(
      self.configDataProperty.signal.mapConst(true).take(first: 1),
      self.bodyText.map { $0?.trimmed().isEmpty ?? true }
    )

    self.textViewShouldChangeReturnProperty <~ self.textViewShouldChangeProperty.signal.skipNil()
      .map { text, range, replacementText in
        let currentText = text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementText)
        return updatedText.trimmed().count <= CommentComposerConstant.characterLimit
      }

    self.inputTextViewDidBecomeFirstResponder = Signal.merge(
      self.configDataProperty.signal.skipNil().map(\.becomeFirstResponder),
      self.resetInputProperty.signal.map { false }
    )

    self.updateTextViewHeight = self.bodyText.signal.ignoreValues()
    self.clearInputTextView = self.bodyText.filter { $0 == nil }.ignoreValues()
  }

  private let bodyTextDidChangeProperty = MutableProperty<String?>(nil)
  /// Updates the current comment body text as the user types.
  public func bodyTextDidChange(_ text: String?) {
    self.bodyTextDidChangeProperty.value = text
  }

  private let configDataProperty = MutableProperty<CommentComposerViewData?>(nil)
  /// Configures the composer with user avatar URL and permission/focus state.
  public func configure(with data: CommentComposerViewData) {
    self.configDataProperty.value = data
  }

  private let postButtonPressedProperty = MutableProperty(())
  /// Submits the trimmed comment text to the delegate.
  public func postButtonPressed() {
    self.postButtonPressedProperty.value = ()
  }

  fileprivate let resetInputProperty = MutableProperty(())
  /// Clears the comment input field and relinquishes focus.
  public func resetInput() {
    self.resetInputProperty.value = ()
  }

  private let textViewShouldChangeProperty = MutableProperty<(String?, NSRange, String)?>(nil)
  private let textViewShouldChangeReturnProperty = MutableProperty<Bool>(false)
  /// Validates whether a proposed text edit remains within `CommentComposerConstant.characterLimit`.
  public func textViewShouldChange(text: String?, in range: NSRange, replacementText: String) -> Bool {
    self.textViewShouldChangeProperty.value = (text, range, replacementText)
    return self.textViewShouldChangeReturnProperty.value
  }

  /// Emits the commenter's avatar URL.
  public var avatarURL: Signal<URL?, Never>
  /// Emits the current body text or `nil` when cleared.
  public var bodyText: Signal<String?, Never>
  /// Emits when the text view contents should be cleared.
  public var clearInputTextView: Signal<(), Never>
  /// Emits whether the entire composer view is hidden.
  public var commentComposerHidden: Signal<Bool, Never>
  /// Emits whether the editable input area is hidden.
  public var inputAreaHidden: Signal<Bool, Never>
  /// Emits whether the text view should become first responder.
  public var inputTextViewDidBecomeFirstResponder: Signal<Bool, Never>
  /// Emits the trimmed comment string when the user taps Post.
  public var notifyDelegateDidSubmitText: Signal<String, Never>
  /// Emits whether the placeholder label is hidden.
  public var placeholderHidden: Signal<Bool, Never>
  /// Emits whether the Post button is hidden.
  public var postButtonHidden: Signal<Bool, Never>
  /// Emits when the text view height should be recalculated.
  public var updateTextViewHeight: Signal<(), Never>

  /// The inputs interface for this view model.
  public var inputs: CommentComposerViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: CommentComposerViewModelOutputs { return self }
}
