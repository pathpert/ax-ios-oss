import Foundation
import KsApi

/// Helper definitions for `getProjectBackingDetailsURL` in `ProjectURLBuilder.swift`.
public func getProjectBackingDetailsURL(with project: Project) -> URL? {
  let urlString =
    "\(AppEnvironment.current.apiService.serverConfig.webBaseUrl)/projects/\(project.creator.id)/\(project.slug)/backing/details"

  return URL(string: urlString)
}
