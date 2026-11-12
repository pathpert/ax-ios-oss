import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Enumeration representing `UpdateDraftSaveAction` cases.
enum UpdateDraftSaveAction {
  case dismiss
  case preview
}

struct UpdateDraftAttachmentSignals {
  let attachments: Signal<[UpdateDraft.Attachment], Never>
  let attachmentAdded: Signal<UpdateDraft.Attachment, Never>
  let attachmentRemoved: Signal<UpdateDraft.Attachment, Never>
  let showAddAttachmentFailure: Signal<(), Never>
  let showRemoveAttachmentConfirmation: Signal<UpdateDraft.Attachment, Never>
  let showRemoveAttachmentFailure: Signal<(), Never>
  let isAttachmentsSectionHidden: Signal<Bool, Never>
}

func makeUpdateDraftAttachmentSignals(
  draft: Signal<UpdateDraft, Never>,
  viewDidLoad: Signal<Void, Never>,
  imagePicked: Signal<(URL, AttachmentSource), Never>,
  attachmentTapped: Signal<Int, Never>,
  removeAttachment: Signal<UpdateDraft.Attachment, Never>
) -> UpdateDraftAttachmentSignals {
  let attachments: Signal<[UpdateDraft.Attachment], Never> = draft
    .map {
      $0.images.map(UpdateDraft.Attachment.image)
        + [$0.video.map(UpdateDraft.Attachment.video)].compact()
    }

  let addAttachmentEvent = draft
    .takePairWhen(imagePicked.map(first))
    .switchMap { draft, url in
      AppEnvironment.current.apiService.addImage(file: url, toDraft: draft)
        .materialize()
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    }

  let showAddAttachmentFailure = addAttachmentEvent.errors().ignoreValues()
  let attachmentAdded = addAttachmentEvent.values().map(UpdateDraft.Attachment.image)

  let addedAttachments: Signal<[UpdateDraft.Attachment], Never> = Signal.merge(
    attachments,
    attachments.switchMap { items in
      attachmentAdded.scan(items) { $0 + [$1] }
    }
  )

  let showRemoveAttachmentConfirmation = addedAttachments
    .takePairWhen(attachmentTapped)
    .map { list, id in list.first { $0.id == id } }
    .skipNil()

  let removeAttachmentEvent: Signal<Signal<UpdateDraft.Image, ErrorEnvelope>.Event, Never> = draft
    .takePairWhen(removeAttachment)
    .switchMap { draft, attachment
      -> SignalProducer<Signal<UpdateDraft.Image, ErrorEnvelope>.Event, Never> in
      guard case let .image(image) = attachment else { fatalError("Video not supported") }
      return AppEnvironment.current.apiService.delete(image: image, fromDraft: draft)
        .materialize()
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    }

  let showRemoveAttachmentFailure = removeAttachmentEvent.errors().ignoreValues()
  let attachmentRemoved = removeAttachmentEvent.values().map(UpdateDraft.Attachment.image)

  let removedAttachments: Signal<[UpdateDraft.Attachment], Never> = addedAttachments
    .switchMap { items in
      attachmentRemoved.scan(items) { current, toRemove in
        current.filter { toRemove != $0 }
      }
    }

  let currentAttachments = Signal.merge(attachments, addedAttachments, removedAttachments)
  let isAttachmentsSectionHidden = Signal.merge(
    viewDidLoad.mapConst(true),
    currentAttachments.map { $0.isEmpty }
  )
  .skipRepeats()

  return UpdateDraftAttachmentSignals(
    attachments: attachments,
    attachmentAdded: attachmentAdded,
    attachmentRemoved: attachmentRemoved,
    showAddAttachmentFailure: showAddAttachmentFailure,
    showRemoveAttachmentConfirmation: showRemoveAttachmentConfirmation,
    showRemoveAttachmentFailure: showRemoveAttachmentFailure,
    isAttachmentsSectionHidden: isAttachmentsSectionHidden
  )
}

func makeUpdateDraftSaveSignals(
  draft: Signal<UpdateDraft, Never>,
  currentTitle: Signal<String, Never>,
  currentBody: Signal<String, Never>,
  isBackersOnly: Signal<Bool, Never>,
  showLoadFailure: Signal<(), Never>,
  closeTapped: Signal<(), Never>,
  previewTapped: Signal<(), Never>
) -> (
  notifyDismissal: Signal<(), Never>,
  showSaveFailure: Signal<(), Never>,
  goToPreview: Signal<UpdateDraft, Never>
) {
  let saveAction = Signal.merge(
    closeTapped.mapConst(UpdateDraftSaveAction.dismiss),
    previewTapped.mapConst(UpdateDraftSaveAction.preview)
  )

  let currentDraftEvent = Signal.combineLatest(draft, currentTitle, currentBody, isBackersOnly)
    .takeWhen(saveAction)
    .flatMap { draft, title, body, isBackersOnly ->
      SignalProducer<Signal<UpdateDraft, ErrorEnvelope>.Event, Never> in
      let unchanged = draft.update.title == title
        && draft.update.body == body
        && draft.update.isPublic == !isBackersOnly

      let producer: SignalProducer<Signal<UpdateDraft, ErrorEnvelope>.Event, Never> = unchanged
        ? SignalProducer(value: .value(draft))
        : AppEnvironment.current.apiService
        .update(draft: draft, title: title, body: body, isPublic: !isBackersOnly)
        .materialize()

      return producer
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    }

  let currentDraft = currentDraftEvent.values()
  let notifyDismissal = Signal.merge(
    showLoadFailure,
    saveAction.takeWhen(currentDraft).filter { $0 == .dismiss }.ignoreValues()
  )
  let showSaveFailure = currentDraftEvent.errors().ignoreValues()
  let goToPreview = saveAction
    .takePairWhen(currentDraft)
    .filter { action, _ in action == .preview }
    .map(second)

  return (notifyDismissal, showSaveFailure, goToPreview)
}

