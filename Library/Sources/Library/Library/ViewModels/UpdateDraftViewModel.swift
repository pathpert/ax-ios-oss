import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model managing project update draft loading, form editing, attachments, validation, and saving.
public final class UpdateDraftViewModel: UpdateDraftViewModelType, UpdateDraftViewModelInputs,
  UpdateDraftViewModelOutputs {
  /// Initializes the update draft view model and binds draft API, attachment, focus, and save signals.
  public init() {
    let project: Signal<Project, Never> = self.projectProperty.signal.skipNil()

    let draftEvent = Signal.combineLatest(self.viewDidLoadProperty.signal, project)
      .map(second)
      .flatMap {
        AppEnvironment.current.apiService.fetchUpdateDraft(forProject: $0)
          .materialize()
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      }

    let draft: Signal<UpdateDraft, Never> = draftEvent.values()
    self.showLoadFailure = draftEvent.errors().ignoreValues()
    self.isLoading = Signal.merge(self.viewDidLoadProperty.signal.mapConst(true), draft.mapConst(false))
    self.navigationItemTitle = draft
      .map { $0.update.sequence }
      .map { Strings.dashboard_post_update_compose_update_number(update_number: Format.wholeNumber($0)) }

    self.title = draft.map { $0.update.title }
    self.body = draft.map { $0.update.body ?? "" }
    self.isBackersOnly = Signal.merge(
      draft.map { $0.update.isPublic }.map(negate),
      self.isBackersOnlyOnProperty.signal
    )

    let currentTitle: Signal<String, Never> = Signal.merge(self.title, self.titleTextChangedProperty.signal)
    let currentBody: Signal<String, Never> = Signal.merge(self.body, self.bodyTextChangedProperty.signal)

    self.showAttachmentActions = self.addAttachmentButtonTappedProperty.signal
    self.showImagePicker = self.addAttachmentSheetButtonTappedProperty.signal.skipNil()

    let attachmentSignals = makeUpdateDraftAttachmentSignals(
      draft: draft,
      viewDidLoad: self.viewDidLoadProperty.signal,
      imagePicked: self.imagePickedProperty.signal.skipNil(),
      attachmentTapped: self.attachmentTappedProperty.signal,
      removeAttachment: self.removeAttachmentProperty.signal.skipNil()
    )
    self.attachments = attachmentSignals.attachments
    self.attachmentAdded = attachmentSignals.attachmentAdded
    self.attachmentRemoved = attachmentSignals.attachmentRemoved
    self.showAddAttachmentFailure = attachmentSignals.showAddAttachmentFailure
    self.showRemoveAttachmentConfirmation = attachmentSignals.showRemoveAttachmentConfirmation
    self.showRemoveAttachmentFailure = attachmentSignals.showRemoveAttachmentFailure
    self.isAttachmentsSectionHidden = attachmentSignals.isAttachmentsSectionHidden

    let hasContent: Signal<Bool, Never> = Signal.combineLatest(currentTitle, currentBody, self.attachments)
      .map { title, body, attachments in
        !title.trimmed().isEmpty && (!body.trimmed().isEmpty || !attachments.isEmpty)
      }

    self.isPreviewButtonEnabled = Signal
      .merge(self.viewDidLoadProperty.signal.mapConst(false), hasContent)
      .skipRepeats()

    let draftHasTitle = draft.map { !$0.update.title.isEmpty }
    let draftHasBody = draft.map { !($0.update.body ?? "").isEmpty }

    self.titleTextFieldBecomeFirstResponder = draftHasTitle.filter(isFalse).ignoreValues()
    self.isBodyPlaceholderHidden = currentBody.map { !$0.isEmpty }.skipRepeats()
    self.bodyTextViewBecomeFirstResponder = .merge(
      self.titleTextFieldDoneEditingProperty.signal,
      Signal.combineLatest(draftHasTitle.filter(isTrue), draftHasBody.filter(isFalse)).ignoreValues()
    )

    (
      self.notifyPresenterViewControllerWantsDismissal,
      self.showSaveFailure,
      self.goToPreview
    ) = makeUpdateDraftSaveSignals(
      draft: draft,
      currentTitle: currentTitle,
      currentBody: currentBody,
      isBackersOnly: self.isBackersOnly,
      showLoadFailure: self.showLoadFailure,
      closeTapped: self.closeButtonTappedProperty.signal,
      previewTapped: self.previewButtonTappedProperty.signal
    )

    self.resignFirstResponder = self.viewWillDisappearProperty.signal
  }

  fileprivate let addAttachmentButtonTappedProperty = MutableProperty<[AttachmentSource]>([])
  /// Notifies the view model that the creator tapped add-attachment with available sources.
  public func addAttachmentButtonTapped(availableSources: [AttachmentSource]) {
    self.addAttachmentButtonTappedProperty.value = availableSources
  }

  fileprivate let addAttachmentSheetButtonTappedProperty = MutableProperty<AttachmentSource?>(nil)
  /// Notifies the view model of the attachment source chosen from the action sheet.
  public func addAttachmentSheetButtonTapped(_ action: AttachmentSource) {
    self.addAttachmentSheetButtonTappedProperty.value = action
  }

  fileprivate let attachmentTappedProperty = MutableProperty(0)
  /// Notifies the view model that an existing attachment was tapped.
  public func attachmentTapped(id: Int) { self.attachmentTappedProperty.value = id }

  fileprivate let bodyTextChangedProperty = MutableProperty("")
  /// Updates the working draft body text.
  public func bodyTextChanged(to body: String) { self.bodyTextChangedProperty.value = body }

  fileprivate let closeButtonTappedProperty = MutableProperty(())
  /// Notifies the view model that the creator tapped the close button.
  public func closeButtonTapped() { self.closeButtonTappedProperty.value = () }

  fileprivate let projectProperty = MutableProperty<Project?>(nil)
  /// Configures the view model with the target project.
  public func configureWith(project: Project) { self.projectProperty.value = project }

  fileprivate let imagePickedProperty = MutableProperty<(URL, AttachmentSource)?>(nil)
  /// Delivers a picked image file URL and source to upload to the draft.
  public func imagePicked(url: URL, fromSource source: AttachmentSource) {
    self.imagePickedProperty.value = (url, source)
  }

  fileprivate let imagePickerCanceledProperty = MutableProperty(())
  /// Notifies the view model that image picking was canceled.
  public func imagePickerCanceled() { self.imagePickerCanceledProperty.value = () }

  fileprivate let isBackersOnlyOnProperty = MutableProperty(false)
  /// Toggles whether the update draft is restricted to backers only.
  public func isBackersOnlyOn(_ isBackersOnly: Bool) { self.isBackersOnlyOnProperty.value = isBackersOnly }

  fileprivate let previewButtonTappedProperty = MutableProperty(())
  /// Notifies the view model that the creator tapped preview.
  public func previewButtonTapped() { self.previewButtonTappedProperty.value = () }

  fileprivate let removeAttachmentProperty = MutableProperty<UpdateDraft.Attachment?>(nil)
  /// Requests deletion of the confirmed draft attachment.
  public func remove(attachment: UpdateDraft.Attachment) { self.removeAttachmentProperty.value = attachment }

  fileprivate let titleTextChangedProperty = MutableProperty("")
  /// Updates the working draft title text.
  public func titleTextChanged(to title: String) { self.titleTextChangedProperty.value = title }

  fileprivate let titleTextFieldDoneEditingProperty = MutableProperty(())
  /// Notifies the view model that title field return key was pressed.
  public func titleTextFieldDoneEditing() { self.titleTextFieldDoneEditingProperty.value = () }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the compose view finished loading.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  fileprivate let viewWillDisappearProperty = MutableProperty(())
  /// Signals that the compose view is about to disappear.
  public func viewWillDisappear() { self.viewWillDisappearProperty.value = () }

  /// Emits an attachment added to the draft.
  public let attachmentAdded: Signal<UpdateDraft.Attachment, Never>
  /// Emits an attachment removed from the draft.
  public let attachmentRemoved: Signal<UpdateDraft.Attachment, Never>
  /// Emits initial attachments loaded with the draft.
  public let attachments: Signal<[UpdateDraft.Attachment], Never>
  /// Emits the initial draft body string.
  public let body: Signal<String, Never>
  /// Triggers focus on the body text view.
  public let bodyTextViewBecomeFirstResponder: Signal<(), Never>
  /// Emits the saved update draft to present in preview.
  public let goToPreview: Signal<UpdateDraft, Never>
  /// Emits whether the attachments container should be hidden.
  public let isAttachmentsSectionHidden: Signal<Bool, Never>
  /// Emits whether the draft fetch request is active.
  public let isLoading: Signal<Bool, Never>
  /// Emits whether the body placeholder label should be hidden.
  public let isBodyPlaceholderHidden: Signal<Bool, Never>
  /// Emits whether backers-only visibility is enabled.
  public let isBackersOnly: Signal<Bool, Never>
  /// Emits whether the preview navigation button should be enabled.
  public let isPreviewButtonEnabled: Signal<Bool, Never>
  /// Emits the formatted navigation bar title containing the update sequence number.
  public let navigationItemTitle: Signal<String, Never>
  /// Requests dismissal of the compose view controller.
  public let notifyPresenterViewControllerWantsDismissal: Signal<(), Never>
  /// Dismisses active keyboard focus before disappearance.
  public let resignFirstResponder: Signal<(), Never>
  /// Triggers an alert when uploading an image attachment fails.
  public let showAddAttachmentFailure: Signal<(), Never>
  /// Presents the attachment source chooser with available sources.
  public let showAttachmentActions: Signal<[AttachmentSource], Never>
  /// Presents the system image picker for the chosen source.
  public let showImagePicker: Signal<AttachmentSource, Never>
  /// Triggers an alert when loading the update draft fails.
  public let showLoadFailure: Signal<(), Never>
  /// Requests confirmation before deleting a tapped attachment.
  public let showRemoveAttachmentConfirmation: Signal<UpdateDraft.Attachment, Never>
  /// Triggers an alert when deleting an attachment fails.
  public let showRemoveAttachmentFailure: Signal<(), Never>
  /// Triggers an alert when saving the update draft fails.
  public let showSaveFailure: Signal<(), Never>
  /// Emits the initial draft title string.
  public let title: Signal<String, Never>
  /// Triggers focus on the title field when a new draft starts empty.
  public let titleTextFieldBecomeFirstResponder: Signal<(), Never>

  /// View model inputs.
  public var inputs: UpdateDraftViewModelInputs { return self }
  /// View model outputs.
  public var outputs: UpdateDraftViewModelOutputs { return self }
}
