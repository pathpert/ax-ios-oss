import Foundation

extension DiscoveryParams: Decodable {
  /// Decodes discovery query filter parameters from stringified API values.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backed = try stringIntToBool(values.decodeIfPresent(String.self, forKey: .backed))
    self.category = try values.decodeIfPresent(Category.self, forKey: .category)
    self.collaborated = try stringToBool(values.decodeIfPresent(String.self, forKey: .collaborated))
    self.created = try stringToBool(values.decodeIfPresent(String.self, forKey: .created))
    self.hasVideo = try stringToBool(values.decodeIfPresent(String.self, forKey: .hasVideo))
    self.includePOTD = try stringToBool(values.decodeIfPresent(String.self, forKey: .includePOTD))
    self.page = try values.decodeIfPresent(String.self, forKey: .page).flatMap { Int($0) }
    self.perPage = try values.decodeIfPresent(String.self, forKey: .perPage).flatMap { Int($0) }
    self.query = try values.decodeIfPresent(String.self, forKey: .query)
    self.recommended = try stringToBool(values.decodeIfPresent(String.self, forKey: .recommended))
    self.seed = try values.decodeIfPresent(String.self, forKey: .seed).flatMap { Int($0) }
    self.similarTo = try values.decodeIfPresent(Project.self, forKey: .similarTo)
    self.social = try stringIntToBool(values.decodeIfPresent(String.self, forKey: .social))
    self.sort = try values.decodeIfPresent(Sort.self, forKey: .sort)
    self.staffPicks = try stringToBool(values.decodeIfPresent(String.self, forKey: .staffPicks))
    self.starred = try stringIntToBool(values.decodeIfPresent(String.self, forKey: .starred))
    self.state = try values.decodeIfPresent(State.self, forKey: .state)
  }

  enum CodingKeys: String, CodingKey {
    case backed
    case category
    case collaborated
    case created
    case hasVideo = "has_video"
    case includePOTD = "include_potd"
    case page
    case perPage = "per_page"
    case query = "term"
    case recommended
    case seed
    case similarTo = "similar_to"
    case social
    case sort
    case staffPicks = "staff_picks"
    case starred
    case state
  }
}

private func stringToBool(_ string: String?) -> Bool? {
  guard let string = string else { return nil }
  switch string {
  // taken from server's `value_to_boolean` function
  case "true", "1", "t", "T", "TRUE", "on", "ON":
    return true
  case "false", "0", "f", "F", "FALSE", "off", "OFF":
    return false
  default:
    return nil
  }
}

private func stringIntToBool(_ string: String?) -> Bool? {
  guard let string = string else { return nil }
  return Int(string)
    .filter { $0 <= 1 && $0 >= -1 }
    .flatMap { ($0 == 0) ? nil : ($0 == 1) }
}

extension DiscoveryParams {
  /// Validates whether these parameters only use filters supported by v1 REST discovery endpoints.
  ///
  /// - Negative Constraint: Returns `false` when GraphQL-only filters (`percentRaised`, `location`, `amountRaised`, `goal`, `.most_funded`, `.most_backed`, `.late_pledge`, `.upcoming`) are set.
  func validForAPIV1() -> Bool {
    if let sort = self.sort {
      switch sort {
      case .endingSoon, .magic, .newest, .popular:
        break
      case .most_funded, .most_backed:
        return false
      }
    }

    if let state = self.state {
      switch state {
      case .all, .live, .successful:
        break
      case .late_pledge, .upcoming:
        return false
      }
    }

    if self.percentRaised != nil || self.location != nil || self.amountRaised != nil || self.goal != nil {
      return false
    }

    return true
  }
}

