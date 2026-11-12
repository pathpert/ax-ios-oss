import Foundation

/// Backer survey response state and web survey destination for a backed project.
public struct SurveyResponse {
  /// Unix timestamp (seconds since epoch) when the survey was completed, or `nil` if unanswered.
  public let answeredAt: TimeInterval?
  /// Numeric identifier of the survey response.
  public let id: Int
  /// Associated project metadata, when included by the endpoint.
  public let project: Project?
  /// Web links for opening the survey form.
  public let urls: UrlsEnvelope

  /// Container for survey web links.
  public struct UrlsEnvelope {
    /// Web URLs associated with the survey.
    public let web: WebEnvelope

    /// Direct web survey form URL container.
    public struct WebEnvelope {
      /// URL to display the interactive web survey to the backer.
      public let survey: String
    }
  }
}

extension SurveyResponse: Equatable {}
/// Compares two survey responses by `id`.
public func == (lhs: SurveyResponse, rhs: SurveyResponse) -> Bool {
  return lhs.id == rhs.id
}

extension SurveyResponse: Decodable {
  enum CodingKeys: String, CodingKey {
    case answeredAt = "answered_at"
    case id
    case project
    case urls
  }
}

extension SurveyResponse.UrlsEnvelope: Decodable {}
extension SurveyResponse.UrlsEnvelope.WebEnvelope: Decodable {}
