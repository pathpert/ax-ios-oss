import KsApi

extension KSRAnalytics {
  // MARK: - Login/Signup Events

  /// Tracks viewing the email/password login screen.
  public func trackLoginPageViewed() {
    let props = contextProperties(page: .login)
    self.track(event: SegmentEvent.pageViewed.rawValue, properties: props)
  }

  /// Tracks viewing the login-or-signup tout screen.
  public func trackLoginTOutPageViewed() {
    let props = contextProperties(page: .loginTout)
    self.track(event: SegmentEvent.pageViewed.rawValue, properties: props)
  }

  /// Tracks submitting the login credentials form.
  public func trackLoginSubmitButtonClicked() {
    let props = contextProperties(ctaContext: .logInSubmit, page: .login)
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks tapping the login initiation button from the login tout screen.
  public func trackLoginInitiateButtonClicked() {
    let props = contextProperties(ctaContext: .logInInitiate, page: .loginTout)
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  private func loginEventProperties(
    for intent: LoginIntent,
    project: (any ProjectAnalyticsProperties)?,
    reward: Reward?
  ) -> AnalyticsPropertyBag {
    var props = AnalyticsPropertyBag()

    if let project = project {
      props = props.withAllValuesFrom(projectProperties(from: project))
    }

    if let reward = reward {
      props = props.withAllValuesFrom(pledgeProperties(from: reward))
    }

    return props.withAllValuesFrom(["login_intent": intent.trackingString])
  }

  // MARK: - VideoFeed Events

  /// Tracks when a video becomes the actively visible item in the video feed, including first load.
  public func trackVideoFeedImpression(
    videoId: String,
    projectId: String,
    positionInSession: Int
  ) {
    var props = contextProperties(page: .videoFeed, locationContext: .videoFeed)

    props["video_feed_video_id"] = videoId
    props["video_feed_project_id"] = projectId
    props["video_feed_position_in_session"] = positionInSession

    self.track(event: SegmentEvent.pageViewed.rawValue, properties: props)
  }

  /// Tracks swiping to a new video item inside the vertical video feed.
  public func trackVideoFeedSwipe(
    videoId: String,
    projectId: String,
    positionInSession: Int,
    fromVideoId: String,
    totalWatchTimeMs: Int,
    totalVideoDurationMs: Int
  ) {
    var props = contextProperties(page: .videoFeed, locationContext: .videoFeed)

    props["video_feed_video_id"] = videoId
    props["video_feed_project_id"] = projectId
    props["video_feed_position_in_session"] = positionInSession
    props["video_feed_from_video_id"] = fromVideoId
    props["video_feed_total_watch_time"] = totalWatchTimeMs
    props["video_feed_total_video_duration"] = totalVideoDurationMs

    self.track(event: SegmentEvent.pageViewed.rawValue, properties: props)
  }

  /// Tracks tapping play, pause, save, or share in the video feed.
  public func trackVideoFeedCTAClicked(
    ctaContext: CTAContext,
    videoId: String,
    projectId: String
  ) {
    var props = contextProperties(ctaContext: ctaContext, page: .videoFeed)

    props["video_feed_video_id"] = videoId
    props["video_feed_project_id"] = projectId

    self.track(event: SegmentEvent.ctaClicked.rawValue, properties: props)
  }

  /// Tracks lifting a finger from the video feed progress bar scrubber.
  public func trackVideoFeedProgressBarTapped(
    videoId: String,
    projectId: String,
    positionInSession: Int,
    percentageWatched: Float
  ) {
    var props = contextProperties(ctaContext: .videoFeedProgressBar, page: .videoFeed)

    props["video_feed_video_id"] = videoId
    props["video_feed_project_id"] = projectId
    props["video_feed_position_in_session"] = positionInSession
    props["video_feed_percentage_watched"] = percentageWatched

    self.track(event: SegmentEvent.ctaClicked.rawValue, properties: props)
  }

  /// Tracks tapping a share destination in the video feed share sheet.
  public func trackVideoFeedShareDestinationClicked(
    destination: TypeContext.VideoFeedShareDestinationContext,
    videoId: String,
    projectId: String
  ) {
    var props = contextProperties(
      ctaContext: .videoFeedShareDestinationClicked,
      page: .videoFeed,
      typeContext: .videoFeedShareDestination(destination)
    )

    props["video_feed_video_id"] = videoId
    props["video_feed_project_id"] = projectId

    self.track(event: SegmentEvent.ctaClicked.rawValue, properties: props)
  }
}

