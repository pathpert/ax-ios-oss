import KsApi

extension DiscoveryParams.State {
  /// Localized filter sheet label describing this project state filter.
  public var title: String {
    switch self {
    case .all:
      Strings.Project_status_all()
    case .live:
      Strings.Project_status_live()
    case .successful:
      Strings.Project_status_successful()
    case .late_pledge:
      Strings.Project_status_late_pledge()
    case .upcoming:
      Strings.Project_status_upcoming()
    }
  }
}

extension DiscoveryParams.PercentRaisedBucket {
  /// Full localized filter option label for this percent-raised bucket.
  public var title: String {
    switch self {
    case .bucket_0:
      return Strings.Percentage_raised_bucket_0()
    case .bucket_1:
      return Strings.Percentage_raised_bucket_1()
    case .bucket_2:
      return Strings.Percentage_raised_bucket_2()
    }
  }

  /// Compact localized pill label for active percent-raised filter chips.
  public var pillTitle: String {
    switch self {
    case .bucket_0:
      return Strings.Percentage_raised_pill_bucket_0()
    case .bucket_1:
      return Strings.Percentage_raised_pill_bucket_1()
    case .bucket_2:
      return Strings.Percentage_raised_pill_bucket_2()
    }
  }
}

extension DiscoveryParams.AmountRaisedBucket {
  /// Full localized filter option label for this amount-raised bucket.
  public var title: String {
    switch self {
    case .bucket_0:
      return Strings.Amount_raised_bucket_0()
    case .bucket_1:
      return Strings.Amount_raised_bucket_1()
    case .bucket_2:
      return Strings.Amount_raised_bucket_2()
    case .bucket_3:
      return Strings.Amount_raised_bucket_3()
    case .bucket_4:
      return Strings.Amount_raised_bucket_4()
    }
  }

  /// Compact localized pill label for active amount-raised filter chips.
  public var pillTitle: String {
    switch self {
    case .bucket_0:
      return Strings.Amount_raised_pill_bucket_0()
    case .bucket_1:
      return Strings.Amount_raised_pill_bucket_1()
    case .bucket_2:
      return Strings.Amount_raised_pill_bucket_2()
    case .bucket_3:
      return Strings.Amount_raised_pill_bucket_3()
    case .bucket_4:
      return Strings.Amount_raised_pill_bucket_4()
    }
  }
}

extension DiscoveryParams.GoalBucket {
  /// Full localized filter option label for this funding-goal bucket.
  public var title: String {
    switch self {
    case .bucket_0:
      return Strings.Goal_bucket_0()
    case .bucket_1:
      return Strings.Goal_bucket_1()
    case .bucket_2:
      return Strings.Goal_bucket_2()
    case .bucket_3:
      return Strings.Goal_bucket_3()
    case .bucket_4:
      return Strings.Goal_bucket_4()
    }
  }

  /// Compact localized pill label for active funding-goal filter chips.
  public var pillTitle: String {
    switch self {
    case .bucket_0:
      return Strings.Goal_pill_bucket_0()
    case .bucket_1:
      return Strings.Goal_pill_bucket_1()
    case .bucket_2:
      return Strings.Goal_pill_bucket_2()
    case .bucket_3:
      return Strings.Goal_pill_bucket_3()
    case .bucket_4:
      return Strings.Goal_pill_bucket_4()
    }
  }
}
