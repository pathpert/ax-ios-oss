import KsApi

extension KSRAnalytics {
  /// Tracks tapping the Continue CTA after selecting add-ons in the pledge flow.
  public func trackAddOnsContinueButtonClicked(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    checkoutData: CheckoutPropertiesData,
    refTag: RefTag?
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(ctaContext: .addOnsContinue, page: .addOnsSelection))
      .withAllValuesFrom(checkoutProperties(from: checkoutData, and: reward))
    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks viewing the add-ons selection page during checkout.
  public func trackAddOnsPageViewed(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    checkoutData: CheckoutPropertiesData,
    refTag: RefTag?
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(checkoutProperties(from: checkoutData, and: reward))
      .withAllValuesFrom(contextProperties(page: .addOnsSelection))

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks tapping the primary pledge CTA button from a project page.
  public func trackPledgeCTAButtonClicked(
    stateType: PledgeStateCTAType,
    project: any ProjectAnalyticsProperties
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(page: .project))

    switch stateType {
    case .pledge:
      let allProps = props
        .withAllValuesFrom([:])
        .withAllValuesFrom(contextProperties(ctaContext: .pledgeInitiate))
        .withAllValuesFrom(props)

      self.track(
        event: SegmentEvent.ctaClicked.rawValue,
        properties: allProps
      )
    default:
      return
    }
  }

  /// Tracks viewing the Manage Pledge screen for an existing backing.
  public func trackManagePledgePageViewed(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    checkoutData: CheckoutPropertiesData
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(checkoutProperties(from: checkoutData, and: reward))
      .withAllValuesFrom(contextProperties(page: .managePledgeScreen))

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props
    )
  }

  /// Tracks selecting a reward tier from the rewards selection screen.
  public func trackRewardClicked(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    checkoutPropertiesData: KSRAnalytics.CheckoutPropertiesData,
    refTag: RefTag?
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(contextProperties(ctaContext: .rewardContinue, page: .rewards))
      .withAllValuesFrom(checkoutProperties(from: checkoutPropertiesData, and: reward))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks viewing the rewards carousel for `project`.
  public func trackRewardsViewed(
    project: any ProjectAnalyticsProperties,
    checkoutPropertiesData: KSRAnalytics.CheckoutPropertiesData,
    refTag: RefTag?
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(checkoutProperties(from: checkoutPropertiesData))
      .withAllValuesFrom(contextProperties(page: .rewards))

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks viewing the checkout payment or pledge-update screen.
  public func trackCheckoutPaymentPageViewed(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    pledgeViewContext: PledgeViewContext,
    checkoutData: CheckoutPropertiesData,
    refTag: RefTag?
  ) {
    var props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(checkoutProperties(from: checkoutData, and: reward))

    switch pledgeViewContext {
    case .pledge, .latePledge:
      props = props.withAllValuesFrom(contextProperties(page: .checkout))
    case .changePaymentMethod:
      props = props.withAllValuesFrom(contextProperties(page: .changePayment))
    case .update, .updateReward:
      props = props.withAllValuesFrom(contextProperties(page: .updatePledge))
    default:
      return
    }

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks tapping the Pledge or Apple Pay submission button during checkout.
  public func trackPledgeSubmitButtonClicked(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    typeContext: TypeContext,
    checkoutData: CheckoutPropertiesData,
    refTag: RefTag?
  ) {
    let props = projectProperties(from: project, loggedInUser: self.loggedInUser)
      .withAllValuesFrom(checkoutProperties(from: checkoutData, and: reward))
      // the context is always "newPledge" for this event
      .withAllValuesFrom(contextProperties(
        ctaContext: .pledgeSubmit,
        page: .checkout,
        typeContext: typeContext
      ))

    self.track(
      event: SegmentEvent.ctaClicked.rawValue,
      properties: props,
      refTag: refTag?.stringTag
    )
  }

  /// Tracks viewing the confirmation (`Thanks`) page after completing a pledge.
  public func trackThanksPageViewed(
    project: any ProjectAnalyticsProperties,
    reward: Reward,
    checkoutData: CheckoutPropertiesData?
  ) {
    var props = projectProperties(from: project, isBacker: true)
      .withAllValuesFrom(pledgeProperties(from: reward))
      // the context is always "newPledge" for this event
      .withAllValuesFrom(contextProperties(page: .thanks, typeContext: TypeContext.pledge(.newPledge)))

    if let checkoutData = checkoutData {
      props = props.withAllValuesFrom(checkoutProperties(from: checkoutData, and: reward))
    }

    self.track(
      event: SegmentEvent.pageViewed.rawValue,
      properties: props
    )
  }
}

