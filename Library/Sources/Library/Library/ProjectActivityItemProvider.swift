import KsApi
import UIKit

/// Controller/component implementing `ProjectActivityItemProvider`.
public final class ProjectActivityItemProvider: UIActivityItemProvider {
  private var project: Project?

  /// Creates a share sheet item provider configured for `project`.
  public convenience init(project: Project) {
    self.init(placeholderItem: project.name)

    self.project = project
  }

  /// Returns the share payload tailored for `activityType` (URL-only for copy/Facebook, formatted title + URL otherwise).
  public override func activityViewController(
    _ activityViewController: UIActivityViewController,
    itemForActivityType activityType: UIActivity.ActivityType?
  ) -> Any? {
    if let project = self.project {
      if activityType == .mail || activityType == .message {
        return self.formattedString(for: project)
      } else if activityType == .postToTwitter {
        return Strings.project_checkout_share_twitter_via_kickstarter(
          project_or_update_title: self.formattedString(for: project)
        )
      } else if activityType == .copyToPasteboard || activityType == .postToFacebook {
        return project.urls.web.project
      } else {
        return self.formattedString(for: project)
      }
    }
    return self.activityViewControllerPlaceholderItem(activityViewController)
  }

  private func formattedString(for project: Project) -> String {
    return [project.name, project.urls.web.project].joined(separator: "\n")
  }
}
