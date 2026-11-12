/// `ProjectNotification` extensions declared in `ProjectNotificationTemplates.swift`.
extension ProjectNotification {
  internal static let template = ProjectNotification(
    email: false,
    id: 1,
    mobile: false,
    project: ProjectNotification.Project(
      id: 1_738,
      name: "The Project"
    )
  )
}
