import KsApi

extension KSRAnalytics {
  /// Tracks viewing the Pledged Projects Overview (`Project Alerts`) dashboard.
  public func trackPPODashboardOpens(properties: PledgedProjectOverviewProperties) {
    let properties = contextProperties(page: .projectAlerts)
      .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))
    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: properties
    )
  }

  /// Tracks tapping the message-creator CTA from a Pledged Projects Overview card.
  public func trackPPOMessagingCreator(
    from project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let properties = contextProperties(ctaContext: .messageCreatorInitiate, page: .projectAlerts)
      .withAllValuesFrom(projectProperties(from: project))
      .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))
      .withAllValuesFrom(["interaction_target_uid": project.creatorId ?? ""])
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: properties
    )
  }

  /// Tracks tapping the fix-payment CTA on an errored pledge card in PPO.
  public func trackPPOFixingPaymentFailure(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(ctaContext: .fixPledgeInitiate, page: .projectAlerts)
      .withAllValuesFrom(projectProperties(from: project))
      .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks opening a backer survey from a Pledged Projects Overview card.
  public func trackPPOOpeningSurvey(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .surveyResponseInitiate,
      page: .projectAlerts
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks opening the external Pledge Manager from a Pledged Projects Overview card.
  public func trackPPOOpenPledgeManager(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .finalizePledgeInitiate,
      page: .projectAlerts
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks initiating address confirmation from a Pledged Projects Overview card.
  public func trackPPOInitiateConfirmingAddress(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .confirmInitiate,
      page: .projectAlerts,
      typeContext: .address
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks submitting an address confirmation in Pledged Projects Overview.
  public func trackPPOSubmitAddressConfirmation(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .confirmSubmit,
      page: .projectAlerts,
      typeContext: .address
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks initiating shipping address editing from a Pledged Projects Overview card.
  public func trackPPOEditAddress(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .edit,
      page: .projectAlerts,
      typeContext: .address
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks tapping card authentication (3DS) from a Pledged Projects Overview card.
  public func trackPPOAuthenticateCard(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .authenticateCardInitiate,
      page: .projectAlerts
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks navigating to native pledge management from a Pledged Projects Overview card.
  public func trackPPOManageLivePledge(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .nativeManagePledge,
      page: .projectAlerts
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks opening project details from a Pledged Projects Overview card.
  public func trackPPOViewProjectDetails(
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .project,
      page: .projectAlerts
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }

  /// Tracks toggling the reward-received checkbox on a Pledged Projects Overview card.
  public func trackPPOUpdateRewardReceived(
    toggleOn: Bool,
    project: any ProjectAnalyticsProperties,
    properties: PledgedProjectOverviewProperties
  ) {
    let props = contextProperties(
      ctaContext: .toggleRewardReceived,
      page: .projectAlerts,
      typeContext: toggleOn ? .on : .off
    )
    .withAllValuesFrom(projectProperties(from: project))
    .withAllValuesFrom(pledgedProjectOverviewProperties(from: properties))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props
    )
  }
}

private func pledgedProjectOverviewProperties(
  from properties: KSRAnalytics.PledgedProjectOverviewProperties
) -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  result["notification_count_address_locks_soon"] = properties.addressLocksSoonCount
  result["notification_count_survey_available"] = properties.surveyAvailableCount
  result["notification_count_pledge_management"] = properties.pledgeManagementCount
  result["notification_count_payment_failed"] = properties.paymentFailedCount
  result["notification_count_card_auth_required"] = properties.cardAuthRequiredCount

  result["notification_count_alert_card"] = properties.alertCardCount
  result["notification_count_funded_project"] = properties.fundedProjectCount
  result["notification_count_live_project"] = properties.liveProjectCount
  result["notification_count_unsuccessful_pledge"] = properties.unsuccessfulPledgeCount

  result["notification_count_total"] = properties.total
  if let page = properties.page {
    result["context_page_number"] = page
  }

  return result
}

