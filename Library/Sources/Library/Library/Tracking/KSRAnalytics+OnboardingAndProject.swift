import KsApi
import UserNotifications

extension KSRAnalytics {
  // MARK: - Onboarding Events

  /// Tracks viewing an onboarding step item.
  public func trackOnboardingPageViewed(at item: OnboardingItemType) {
    let section: SectionContext

    switch item {
    case .welcome:
      section = .onboardingWelcome
    case .saveProjects:
      section = .onboardingSaveProjects
    case .enableNotifications:
      section = .onboardingEnableNotifications
    case .allowTracking:
      section = .onboardingAllowTracking
    case .loginSignUp:
      section = .onboardingLoginSignup
    }

    let props = contextProperties(page: .onboarding, sectionContext: section)
    self.track(event: SegmentEvent.pageViewed.rawValue, properties: props)
  }

  /// Tracks tapping one of the onboarding flow CTAs.
  public func trackOnboardingPageButtonTapped(context: CTAContext, item: OnboardingItemType? = nil) {
    let section: SectionContext?

    switch item {
    case .welcome:
      section = .onboardingWelcome
    case .saveProjects:
      section = .onboardingSaveProjects
    case .enableNotifications:
      section = .onboardingEnableNotifications
    case .allowTracking:
      section = .onboardingAllowTracking
    case .loginSignUp:
      section = .onboardingLoginSignup
    case .none:
      section = nil
    }

    let props = contextProperties(ctaContext: context, page: .onboarding, sectionContext: section)
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks presenting a system permissions dialog during onboarding.
  public func trackSystemPermissionsDialogViewed(on sectionContext: SectionContext) {
    let props = contextProperties(page: .onboarding, sectionContext: sectionContext)
    self.track(event: SegmentEvent.pageViewed.rawValue, properties: props)
  }

  /// Tracks completion of the Push Notification permission prompt during onboarding.
  public func trackPushNotificationPermissionsDialogInteraction(
    _ sectionContext: SectionContext,
    authStatus: UNAuthorizationStatus
  ) {
    let ctaContext: CTAContext = authStatus == .authorized ? .onboardingSystemPermissionsAllowed :
      .onboardingSystemPermissionsDenied

    let props = contextProperties(ctaContext: ctaContext, page: .onboarding, sectionContext: sectionContext)

    self.track(event: SegmentEvent.ctaClicked.rawValue, properties: props)
  }

  /// Tracks granting the App Tracking Transparency prompt during onboarding.
  public func trackAppTrackingTransparencyPermissionsDialogInteraction(
    _ sectionContext: SectionContext
  ) {
    let props = contextProperties(
      ctaContext: .onboardingSystemPermissionsAllowed,
      page: .onboarding,
      sectionContext: sectionContext
    )
    self.track(event: SegmentEvent.ctaClicked.rawValue, properties: props)
  }

  // MARK: - Search Events

  /// Tracks viewing the Search tab or project search results.
  public func trackProjectSearchView(
    params: DiscoveryParams,
    results: Int? = nil
  ) {
    let props = discoveryProperties(from: params, results: results)
      .withAllValuesFrom(contextProperties(page: .search))

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props
    )
  }

  // MARK: - Project Page Events

  /// Tracks viewing a project page or one of its detail tabs (`sectionContext`).
  public func trackProjectViewed(
    _ project: any ProjectAnalyticsProperties,
    refTag: RefTag? = nil,
    sectionContext: KSRAnalytics.SectionContext
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(page: .project, sectionContext: sectionContext))

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks toggling watch/save state on a project.
  public func trackWatchProjectButtonClicked(
    project: any ProjectAnalyticsProperties,
    page: PageContext,
    params: DiscoveryParams? = nil,
    typeContext: TypeContext
  ) {
    var props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(
        ctaContext: .watchProject,
        page: page,
        typeContext: typeContext
      ))

    if let discoveryParams = params {
      props = props.withAllValuesFrom(discoveryProperties(from: discoveryParams))
    }

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks tapping the creator's name on a project page to open creator details.
  public func trackGotoCreatorDetailsClicked(project: any HasProjectAnalyticsProperties) {
    let props = projectProperties(from: project.projectAnalyticsProperties, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(ctaContext: .creatorDetails, page: .project))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks toggling the reward-received switch for a backed project.
  public func trackRewardReceivedToggled(
    toggleOn: Bool,
    project: any HasProjectAnalyticsProperties,
    context: PageContext
  ) {
    let props = projectProperties(
      from: project.projectAnalyticsProperties,
      loggedInUser: self.loggedInUser
    )
    .withAllValuesFrom(contextProperties(
      ctaContext: .toggleRewardReceived,
      page: context,
      typeContext: toggleOn ? .on : .off
    ))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }
}

