import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// A utility for handling all of the `.project` deep links.
/// These deep links can make stacks of view controllers - like Project > Comment > Thread.
/// I pulled these out of `AppDelegateViewModel.init` to them easier to reason about.
internal struct ProjectDeepLink {
  /// TODO: This could be cleaned up to be more imperative. It's basically mapping a project deep link and its subpages
  /// into an array of `UIViewController`s.
  static func projectViewControllers(fromDeepLink deepLink: Signal<Navigation, Never>)
    -> Signal<UINavigationController, Never> {
    let projectLinkValues = deepLink
      // swiftlint:disable:next large_tuple
      .map { link -> (Param, Navigation.Project, RefInfo?, secretRewardToken: String?)? in
        guard case let .project(param, subpage, refInfo, secretRewardToken) = link else { return nil }
        return (param, subpage, refInfo, secretRewardToken)
      }
      .skipNil()
      .switchMap { param, subpage, refInfo, secretRewardToken in
        AppEnvironment.current.apiService.fetchProject(param: param)
          .demoteErrors()
          .observeForUI()
          // swiftlint:disable:next large_tuple
          .map { project -> (Project, Navigation.Project, [UIViewController], RefInfo?) in
            let projectParam = Either<Project, any ProjectPageParam>(left: project)
            let vc = ProjectPageViewController.configuredWith(
              projectOrParam: projectParam,
              refInfo: refInfo,
              secretRewardToken: secretRewardToken
            )

            return (project, subpage, [vc], refInfo)
          }
      }

    let projectLink = projectLinkValues.filter { project, _, _, _ in project.displayPrelaunch != true }
    let projectPreviewLink = projectLinkValues.filter { project, _, _, _ in project.displayPrelaunch == true }

    let fixErroredPledgeLink = projectLink
      .filter { _, subpage, _, _ in subpage == .pledge(.manage) }
      .map { project, _, vcs, _ in (project, vcs, AppEnvironment.current.currentUser != nil) }
      .filter(third >>> isTrue)
      .map { project, vcs, _ -> [UIViewController]? in
        guard let backingId = project.personalization.backing?.id else { return nil }
        let vc = ManagePledgeViewController.instantiate()
        let params = ManagePledgeViewParamConfigData(
          projectParam: .id(project.id),
          backingParam: .id(backingId)
        )
        vc.configureWith(params: params)
        return vcs + [vc]
      }
      .skipNil()
      .map { vcs -> RewardPledgeNavigationController in
        let nav = RewardPledgeNavigationController(nibName: nil, bundle: nil)
        nav.viewControllers = vcs
        // See PR #2650 for additional context. This used to be added in the view controller.
        nav.modalPresentationStyle = .pageSheet
        return nav
      }

    let projectRootLink = Signal.merge(projectLink, projectPreviewLink)
      .filter { _, subpage, _, _ in subpage == .root }
      .map { _, _, vcs, _ in vcs }

    let projectCommentsLink = projectLink
      .filter { _, subpage, _, _ in subpage == .comments }
      .map { project, _, vcs, _ in vcs + [commentsViewController(for: project, update: nil)] }

    let projectCommentThreadLink = projectLink
      .observeForUI()
      .switchMap { project, subpage, vcs, _ -> SignalProducer<[UIViewController], Never> in
        guard case let .commentThread(commentId, replyId) = subpage,
              let commentId = commentId else {
          return .empty
        }

        return AppEnvironment.current.apiService
          .fetchCommentReplies(id: commentId, cursor: nil, limit: CommentRepliesEnvelope.paginationLimit)
          .demoteErrors()
          .observeForUI()
          .map { envelope in
            vcs + [
              commentsViewController(for: project, update: nil),
              CommentRepliesViewController.configuredWith(
                comment: envelope.comment,
                project: project,
                update: nil,
                inputAreaBecomeFirstResponder: false,
                replyId: replyId
              )
            ]
          }
      }

    let updatesLink = projectLink
      .filter { _, subpage, _, _ in subpage == .updates }
      .map { project, _, vcs, _ in vcs + [ProjectUpdatesViewController.configuredWith(project: project)] }

    let updateLink = projectLink
      // swiftlint:disable:next large_tuple
      .map { project, subpage, vcs, _ -> (Project, Int, Navigation.Project.Update, [UIViewController])? in
        guard case let .update(id, updateSubpage) = subpage else { return nil }
        return (project, id, updateSubpage, vcs)
      }
      .skipNil()
      .switchMap { project, id, updateSubpage, vcs in
        AppEnvironment.current.apiService.fetchUpdate(updateId: id, projectParam: .id(project.id))
          .demoteErrors()
          .observeForUI()
          // swiftlint:disable:next large_tuple
          .map { update -> (Project, Update, Navigation.Project.Update, [UIViewController]) in
            (
              project,
              update,
              updateSubpage,
              vcs + [
                UpdateViewController.configuredWith(
                  project: project,
                  update: update,
                  context: .deepLink
                )
              ]
            )
          }
      }

    let updateRootLink = updateLink
      .filter { _, _, subpage, _ in subpage == .root }
      .map { _, _, _, vcs in vcs }

    let updateCommentsLink = updateLink
      .observeForUI()
      .map { _, update, subpage, vcs -> [UIViewController]? in
        guard case .comments = subpage else { return nil }
        return vcs + [commentsViewController(update: update)]
      }
      .skipNil()

    let updateCommentThreadLink = updateLink
      .observeForUI()
      .switchMap { project, update, subpage, vcs -> SignalProducer<[UIViewController], Never> in
        guard case let .commentThread(commentId, replyId) = subpage,
              let commentId = commentId else {
          return .empty
        }
        return AppEnvironment.current.apiService
          .fetchCommentReplies(id: commentId, cursor: nil, limit: CommentRepliesEnvelope.paginationLimit)
          .demoteErrors()
          .observeForUI()
          .map { envelope in
            vcs + [
              commentsViewController(for: nil, update: update),
              CommentRepliesViewController.configuredWith(
                comment: envelope.comment,
                project: project,
                update: update,
                inputAreaBecomeFirstResponder: false,
                replyId: replyId
              )
            ]
          }
      }

    return Signal
      .merge(
        projectRootLink,
        projectCommentsLink,
        projectCommentThreadLink,
        updatesLink,
        updateRootLink,
        updateCommentsLink,
        updateCommentThreadLink
      )
      .map { ProjectPageViewController.navigationController(withViewControllers: $0) }
      // This one is already in its own nav controller, `RewardPledgeNavigationController`
      .merge(with: fixErroredPledgeLink.map { $0 as UINavigationController })
  }
}

