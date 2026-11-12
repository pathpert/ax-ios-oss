import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Completion metadata returned from presenting a system `UIActivityViewController`.
public struct ShareActivityCompletionData {
  internal let activityType: UIActivity.ActivityType?
  internal let completed: Bool
  internal let returnedItems: [Any]?
  internal let activityError: Error?

  /// Creates share completion data from UIKit's activity completion handler values.
  public init(
    activityType: UIActivity.ActivityType?,
    completed: Bool,
    returnedItems: [Any]?,
    activityError: Error?
  ) {
    self.activityType = activityType
    self.completed = completed
    self.returnedItems = returnedItems
    self.activityError = activityError
  }
}

/// Inputs for `ShareViewModel`.
public protocol ShareViewModelInputs {
  /// Call with the context that this sharing is taking place in.
  func configureWith(shareContext: ShareContext, shareContextView: UIView?)

  /// Call when the general share button is pressed.
  func shareButtonTapped()
}

/// Outputs for `ShareViewModel`.
public protocol ShareViewModelOutputs {
  /// Emits when the share sheet should be presented.
  var showShareSheet: Signal<(UIActivityViewController, UIView?), Never> { get }
}

/// Type interface for `ShareViewModel`.
public protocol ShareViewModelType {
  /// View model inputs.
  var inputs: ShareViewModelInputs { get }
  /// View model outputs.
  var outputs: ShareViewModelOutputs { get }
}

/// View model responsible for building and presenting the system share sheet for a share context.
public final class ShareViewModel: ShareViewModelType, ShareViewModelInputs, ShareViewModelOutputs {
  /// Initializes the share view model and binds share sheet presentation signals.
  public init() {
    let shareContextAndView = self.shareContextProperty.signal.skipNil()

    self.showShareSheet = shareContextAndView
      .takeWhen(self.shareButtonTappedProperty.signal)
      .map { context, view -> (UIActivityViewController, UIView?)? in
        guard let controller = activityController(forShareContext: context) else { return nil }
        return (controller, view)
      }
      .skipNil()
  }

  fileprivate let shareContextProperty = MutableProperty<(ShareContext, UIView?)?>(nil)
  /// Configures the view model with the sharing context and optional source view.
  public func configureWith(shareContext: ShareContext, shareContextView: UIView?) {
    self.shareContextProperty.value = (shareContext, shareContextView)
  }

  fileprivate let shareButtonTappedProperty = MutableProperty(())
  /// Called when the share button is tapped.
  public func shareButtonTapped() {
    self.shareButtonTappedProperty.value = ()
  }

  /// Emits the configured activity view controller and source view for presentation.
  public let showShareSheet: Signal<(UIActivityViewController, UIView?), Never>

  /// View model inputs.
  public var inputs: ShareViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ShareViewModelOutputs { return self }
}

private func activityItemProvider(forShareContext shareContext: ShareContext) -> UIActivityItemProvider {
  switch shareContext {
  case let .discovery(project):
    return ProjectActivityItemProvider(project: project)
  case let .project(project):
    return ProjectActivityItemProvider(project: project)
  case let .thanks(project):
    return ProjectActivityItemProvider(project: project)
  case let .update(_, update):
    return UpdateActivityItemProvider(update: update)
  }
}

private func shareUrl(forShareContext shareContext: ShareContext) -> URL? {
  switch shareContext {
  case let .discovery(project):
    return URL(string: project.urls.web.project)
  case let .project(project):
    return URL(string: project.urls.web.project)
  case let .thanks(project):
    return URL(string: project.urls.web.project)
  case let .update(_, update):
    return URL(string: update.urls.web.update)
  }
}

private func excludedActivityTypes(forShareContext shareContext: ShareContext) -> [UIActivity.ActivityType] {
  switch shareContext {
  case let .update(_, update) where !update.isPublic:
    return [.mail, .message, .postToFacebook, .postToTwitter, .postToWeibo]
  default:
    return []
  }
}

private func activityController(forShareContext shareContext: ShareContext) -> UIActivityViewController? {
  guard let url = shareUrl(forShareContext: shareContext) else { return nil }

  let provider = activityItemProvider(forShareContext: shareContext)
  let safariUrl = SafariURL(url: url)

  let controller = UIActivityViewController(
    activityItems: [provider, safariUrl],
    applicationActivities: [SafariActivity(url: safariUrl)]
  )

  controller.excludedActivityTypes = excludedActivityTypes(forShareContext: shareContext)

  return controller
}
