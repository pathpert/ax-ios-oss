import KsApi

extension KSRAnalytics {
  // MARK: - Activity

  /// Tracks tapping the `Explore Projects` CTA from the logged-out Activity empty state.
  public func trackExploreButtonClicked() {
    let properties = contextProperties(ctaContext: .discover, page: .activities)
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: properties
    )
  }

  // MARK: - Application Lifecycle

  /// Tracks tapping a root tab bar destination from `previousTabBarItemLabel`.
  public func trackTabBarClicked(
    tabBarItemLabel: TabBarItemLabel,
    previousTabBarItemLabel: TabBarItemLabel
  ) {
    let page = pageContext(from: previousTabBarItemLabel)
    switch tabBarItemLabel {
    case .discovery:
      let properties = contextProperties(
        ctaContext: .discover,
        page: page,
        locationContext: .globalNav
      )
      self.track(
        event: SegmentEvent.ctaClicked.rawValue,
        properties: properties
      )
    default:
      return
    }
  }

  /// Tracks tapping the Search tab bar item from `prevTabBarItemLabel`.
  public func trackSearchTabBarClicked(prevTabBarItemLabel: TabBarItemLabel) {
    let page = pageContext(from: prevTabBarItemLabel)
    let properties = contextProperties(
      ctaContext: .search,
      page: page,
      locationContext: .globalNav
    )
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: properties
    )
  }

  // MARK: - Block User Events

  /// Tracks initiating or completing a user-block action from a project or creator surface.
  public func trackBlockedUser(
    _ project: any ProjectAnalyticsProperties,
    page: KSRAnalytics.PageContext,
    sectionContext: KSRAnalytics.SectionContext? = nil,
    locationContext: KSRAnalytics.LocationContext? = nil,
    typeContext: KSRAnalytics.TypeContext,
    targetUserId: String
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(
        ctaContext: .blockUser,
        page: page,
        sectionContext: sectionContext,
        typeContext: typeContext,
        locationContext: locationContext
      ))
      .withAllValuesFrom(interactionProperties(targetUserId: targetUserId))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  // MARK: - Discovery Events

  /// Tracks viewing a Discovery page after its first page of results loads.
  public func trackDiscovery(params: DiscoveryParams) {
    let properties = contextProperties(page: .discovery)
      .withAllValuesFrom(discoveryProperties(from: params))

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: properties
    )
  }

  /// Tracks selecting a filter option inside the Discovery Explore modal.
  public func trackDiscoveryModalSelectedFilter(
    params: DiscoveryParams,
    typeContext: TypeContext,
    locationContext: LocationContext
  ) {
    let props = discoveryProperties(from: params)
      .withAllValuesFrom(
        contextProperties(
          ctaContext: .discoverFilter,
          page: .discovery,
          typeContext: typeContext,
          locationContext: locationContext
        )
      )
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks opening Saved projects from the user profile menu.
  public func trackProfilePageFilterSelected(
    params: DiscoveryParams
  ) {
    let props = discoveryProperties(from: params)
      .withAllValuesFrom(
        contextProperties(
          ctaContext: .discoverFilter,
          page: .discovery,
          typeContext: .watched,
          locationContext: .accountMenu
        )
      )
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks changing the Discovery sort order from `prevSort`.
  public func trackDiscoverySelectedSort(
    prevSort: DiscoveryParams.Sort,
    params: DiscoveryParams,
    discoverySortContext: TypeContext.DiscoverySortContext
  ) {
    let props = discoveryProperties(from: params)
      .withAllValuesFrom([
        "discover_sort": prevSort.trackingString
      ])
      .withAllValuesFrom(
        contextProperties(
          ctaContext: .discoverSort,
          page: .discovery,
          typeContext: .discovery(discoverySortContext),
          locationContext: .discoverAdvanced
        )
      )

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks tapping a project card from Discovery, search, or recommendations.
  public func trackProjectCardClicked(
    page: PageContext,
    project: any ProjectAnalyticsProperties,
    checkoutData: CheckoutPropertiesData? = nil,
    typeContext: TypeContext? = nil,
    location: LocationContext? = nil,
    params: DiscoveryParams? = nil,
    reward: Reward? = nil,
    section: SectionContext? = nil
  ) {
    var props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(
        ctaContext: .project,
        page: page,
        sectionContext: section,
        typeContext: typeContext,
        locationContext: location
      ))

    if let checkoutProps = checkoutData {
      props = props.withAllValuesFrom(checkoutProperties(from: checkoutProps, and: reward))
    }

    if let discoveryParams = params {
      props = props.withAllValuesFrom(discoveryProperties(from: discoveryParams))
    }

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks starting playback on a project campaign video.
  public func trackProjectVideoPlaybackStarted(
    project: any HasProjectAnalyticsProperties,
    videoLength: Int,
    videoPosition: Int
  ) {
    let props = projectProperties(from: project.projectAnalyticsProperties, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(videoProperties(videoLength: videoLength, videoPosition: videoPosition))
      .withAllValuesFrom(contextProperties(page: .project))

    self.track(
      event: SegmentEvent.videoPlaybackStarted.rawValue,
      properties: props
    )
  }
}

