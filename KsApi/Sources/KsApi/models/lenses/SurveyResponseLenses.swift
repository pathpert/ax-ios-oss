import Foundation
import Prelude

extension SurveyResponse {
  /// Functional optics namespace for `SurveyResponse`.
  public enum lens {
    /// Lens focusing on `answeredAt` timestamp.
    public static let answeredAt = Lens<SurveyResponse, TimeInterval?>(
      view: { $0.answeredAt },
      set: { .init(answeredAt: $0, id: $1.id, project: $1.project, urls: $1.urls) }
    )

    /// Lens focusing on survey `id`.
    public static let id = Lens<SurveyResponse, Int>(
      view: { $0.id },
      set: { .init(answeredAt: $1.answeredAt, id: $0, project: $1.project, urls: $1.urls) }
    )

    /// Lens focusing on associated `project`.
    public static let project = Lens<SurveyResponse, Project?>(
      view: { $0.project },
      set: { .init(answeredAt: $1.answeredAt, id: $1.id, project: $0, urls: $1.urls) }
    )
  }
}
