import KsApi
import Prelude
import ReactiveSwift

/// View model managing the legacy comment dialog presentation, validation, and posting.
public final class CommentDialogViewModel: CommentDialogViewModelType,
  CommentDialogViewModelInputs,
  CommentDialogViewModelOutputs, CommentDialogViewModelErrors {
  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the comment dialog will appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  fileprivate let viewWillDisappearProperty = MutableProperty(())
  /// Signals that the comment dialog will disappear.
  public func viewWillDisappear() {
    self.viewWillDisappearProperty.value = ()
  }

  fileprivate let configurationDataProperty = MutableProperty<CommentDialogData?>(nil)
  /// Configures the dialog with the target project, optional update, reply recipient, and context.
  public func configureWith(
    project: Project, update: Update?, recipientName: String?,
    context: KSRAnalytics.CommentDialogContext
  ) {
    self.configurationDataProperty.value = CommentDialogData(
      project: project, update: update,
      recipientName: recipientName, context: context
    )
  }

  fileprivate let commentBodyProperty = MutableProperty("")
  /// Updates the current comment text entered by the user.
  public func commentBodyChanged(_ text: String) {
    self.commentBodyProperty.value = text
  }

  fileprivate let postButtonPressedProperty = MutableProperty(())
  /// Triggers posting the comment.
  public func postButtonPressed() {
    self.postButtonPressedProperty.value = ()
  }

  fileprivate let cancelButtonPressedProperty = MutableProperty(())
  /// Dismisses the comment dialog without posting.
  public func cancelButtonPressed() {
    self.cancelButtonPressedProperty.value = ()
  }

  /// Emits prefilled body text (for replies).
  public let bodyTextViewText: Signal<String, Never>
  /// Emits whether the post button should be enabled.
  public let postButtonEnabled: Signal<Bool, Never>
  /// Emits whether the loading indicator should be hidden.
  public let loadingViewIsHidden: Signal<Bool, Never>
  /// Emits the posted `Comment` upon success.
  public let notifyPresenterCommentWasPostedSuccesfully: Signal<Comment, Never>
  /// Emits when the dialog should be dismissed.
  public let notifyPresenterDialogWantsDismissal: Signal<(), Never>
  /// Emits the dialog subtitle (the project name).
  public let subtitle: Signal<String, Never>
  /// Emits whether the keyboard should be shown or hidden.
  public let showKeyboard: Signal<Bool, Never>

  /// Emits a localized error message when posting fails.
  public let presentError: Signal<String, Never>

  /// The inputs interface for this view model.
  public var inputs: CommentDialogViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: CommentDialogViewModelOutputs { return self }
  /// The error outputs interface for this view model.
  public var errors: CommentDialogViewModelErrors { return self }

  /// Creates a new `CommentDialogViewModel` and binds reactive posting state.
  public init() {
    let isLoading = MutableProperty(false)

    let configurationData = self.configurationDataProperty.signal.skipNil()
      .takeWhen(self.viewWillAppearProperty.signal)

    let project = configurationData
      .map { $0.project }

    let updateOrProject = configurationData
      .map { data in
        data.update.map(Either.left) ?? Either.right(data.project)
      }

    self.postButtonEnabled = Signal.merge([
      self.viewWillAppearProperty.signal.take(first: 1).mapConst(false),
      self.commentBodyProperty.signal.map { !$0.isEmpty },
      isLoading.signal.map(isFalse)
    ])
    .skipRepeats()

    let currentUser = self.viewWillAppearProperty.signal
      .map { _ in AppEnvironment.current.currentUser }

    // get an id needed to post a comment to either a project or a project update
    let commentableId = updateOrProject
      .flatMap { updateOrProject in
        updateOrProject.ifLeft { update in
          SignalProducer.init(value: encodeToBase64("FreeformPost-\(update.id)"))
        } ifRight: { project in
          SignalProducer.init(value: project.graphID)
        }
      }

    let commentPostedEvent = Signal.combineLatest(
      self.commentBodyProperty.signal,
      currentUser.signal.skipNil(),
      project.signal,
      commentableId.signal
    )
    .takeWhen(self.postButtonPressedProperty.signal)
    .switchMap { body, currentUser, project, commentableId in
      postComment(
        body,
        project: project,
        commentableId: commentableId,
        from: currentUser
      )
      .on(
        starting: {
          isLoading.value = true
        },
        terminated: {
          isLoading.value = false
        }
      )
      .materialize()
    }

    self.notifyPresenterCommentWasPostedSuccesfully = commentPostedEvent.values()

    self.loadingViewIsHidden = Signal.merge(
      self.viewWillAppearProperty.signal.mapConst(true),
      isLoading.signal.map(negate)
    )

    self.notifyPresenterDialogWantsDismissal = Signal.merge([
      self.cancelButtonPressedProperty.signal,
      self.notifyPresenterCommentWasPostedSuccesfully.ignoreValues()
    ])

    self.presentError = commentPostedEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.project_comments_error_posting()
      }

    self.subtitle = project
      .takeWhen(self.viewWillAppearProperty.signal)
      .map { $0.name }

    self.showKeyboard = Signal.merge(
      self.viewWillAppearProperty.signal.mapConst(true),
      self.viewWillDisappearProperty.signal.mapConst(false)
    )

    self.bodyTextViewText = configurationData
      .map { data in data.recipientName }
      .skipNil()
      .map { "@\($0): " }
  }
}

/**
 FIXME: Issues related to design that need to be discussed as a product change to the `ProjectActivitiesViewController` and removal of `CommentDialogViewController`.
 - Errors are not displayed to the user as the function uses optimistic posting and the `CommentDialogViewController` is dismissed before the error has a chance to be shown.
 - Replies are posted as comments on main thread with `@User` tagged.
 */

private func postComment(
  _ body: String,
  project: Project,
  commentableId: String,
  from user: User
)
  -> SignalProducer<Comment, ErrorEnvelope> {
  return CommentsViewModel.postCommentProducer(
    project: project,
    commentableId: commentableId,
    parentId: nil,
    user: user,
    body: body
  )
  .promoteError(ErrorEnvelope.self)
  .switchMap { comment, _ -> SignalProducer<Comment, ErrorEnvelope> in
    guard comment.status == .failed else {
      return SignalProducer<Comment, ErrorEnvelope>(value: comment)
    }

    let failureEnvelope = ErrorEnvelope(
      errorMessages: [Strings.Something_went_wrong_please_try_again()],
      ksrCode: nil,
      httpCode: -1,
      exception: nil
    )

    return SignalProducer<Comment, ErrorEnvelope>(error: failureEnvelope)
  }
}
