import Foundation
import GraphAPI
import KsApi
import Library

#if targetEnvironment(simulator)
  extension PPOProjectCardModel {
    private static let longProjectName =
      "Sugardew Island - Your cozy farm shop let’s pretend this is a way way way longer title"
    private static let truncatedCreatorName = "rokaplay truncate if longer than this extra long string"
    private static let sampleAddressText = """
    Firsty Lasty
    123 First Street, Apt #5678
    Los Angeles, CA 90025-1234
    United States
    """

    /// Minimal set of representative templates to keep previews lightweight.
    public static let previewTemplates: [PPOProjectCardModel] = [
      noRewardPledgeCollected,
      awaitingShippableRewardTemplate,
      digitalRewardReceivedTemplate,
      openPledgeManagerTemplate,
      confirmAddressTemplate,
      fixPaymentTemplate,
      campaignFundedTemplate,
      pledgeDroppedTemplate
    ]

    /// Minimal set of funded project templates representing each tier and reward type at least once.
    public static let fundedProjectTemplates: [PPOProjectCardModel] = [
      noRewardPledgeCollected,
      surveySubmittedTemplate,
      addressConfirmedTemplate,
      digitalRewardReceivedTemplate,
      awaitingShippableRewardTemplate
    ]

    /// Sample live-project templates covering live, funded, and ended campaign states.
    public static let liveProjectTemplates: [PPOProjectCardModel] = [
      campaignLiveTemplate,
      campaignFundedTemplate,
      campaignEndedTemplate
    ]

    /// Sample failed or canceled pledge templates.
    public static let failedPledgeTemplates: [PPOProjectCardModel] = [
      campaignFailedTemplate,
      pledgeDroppedTemplate,
      pledgeCanceledTemplate
    ]

    private static func makeTemplate(
      alerts: [Alert],
      projectName: String = longProjectName,
      creatorName: String = "rokaplay",
      address: DisplayAddress = .hidden,
      rewardReceivedToggleState: PPORewardToggleState = .hidden,
      action: ButtonAction? = nil,
      tierType: PPOTierType,
      projectPageParam: ProjectPageParam? = nil
    ) -> PPOProjectCardModel {
      PPOProjectCardModel(
        isUnread: true,
        alerts: alerts,
        image: .network(URL(string: "https:///")!),
        projectName: projectName,
        projectId: 12_345,
        pledge: "$50.00",
        creatorName: creatorName,
        address: address,
        rewardReceivedToggleState: rewardReceivedToggleState,
        action: action,
        tierType: tierType,
        backingId: 47,
        backingGraphId: "backing-fake-id",
        projectAnalytics: Self.projectAnalyticsFragmentTemplate,
        projectPageParam: projectPageParam
      )
    }

    // MARK: Funded projects

    internal static let noRewardPledgeCollected = makeTemplate(
      alerts: [.init(type: .info, icon: nil, message: "Pledge collected")],
      tierType: .pledgeCollected,
      projectPageParam: ProjectPageParamBox(param: Param.id(12_345), initialProject: nil)
    )

    internal static let surveySubmittedTemplate = makeTemplate(
      alerts: [.init(type: .info, icon: nil, message: "Survey submitted")],
      creatorName: truncatedCreatorName,
      address: .editable(address: sampleAddressText, editUrl: "fakeEditUrl"),
      tierType: .surveySubmitted
    )

    internal static let addressConfirmedTemplate = makeTemplate(
      alerts: [.init(type: .warning, icon: .time, message: "Address locks in 8 hours")],
      creatorName: truncatedCreatorName,
      address: .editable(address: sampleAddressText, editUrl: "fakeEditUrl"),
      tierType: .addressConfirmed
    )

    internal static let digitalRewardReceivedTemplate = makeTemplate(
      alerts: [.init(type: .info, icon: nil, message: "Reward received")],
      projectName: "Sugardew Island",
      rewardReceivedToggleState: .rewardReceived,
      tierType: .rewardReceived
    )

    internal static let awaitingShippableRewardTemplate = makeTemplate(
      alerts: [.init(type: .info, icon: nil, message: "In fulfillment")],
      creatorName: truncatedCreatorName,
      address: .locked(address: sampleAddressText),
      rewardReceivedToggleState: .notReceived,
      tierType: .awaitingReward
    )

    // MARK: Live projects

    internal static let campaignLiveTemplate = makeTemplate(
      alerts: [
        .init(type: .info, icon: .time, message: "13 days to go"),
        .init(type: .warning, icon: nil, message: "43.12% funded")
      ],
      action: .manageLivePledge,
      tierType: .campaignLive
    )

    internal static let campaignFundedTemplate = makeTemplate(
      alerts: [
        .init(type: .info, icon: .time, message: "2 days to go"),
        .init(type: .info, icon: nil, message: "2278.37% funded")
      ],
      action: .manageLivePledge,
      tierType: .campaignFunded
    )

    internal static let campaignEndedTemplate = makeTemplate(
      alerts: [.init(type: .info, icon: nil, message: "2278.37% funded")],
      tierType: .campaignEnded
    )

    // MARK: Failed/canceled pledges

    internal static let campaignFailedTemplate = makeTemplate(
      alerts: [.init(type: .warning, icon: nil, message: "Campaign unsuccessful")],
      tierType: .campaignFailed
    )

    internal static let pledgeDroppedTemplate = makeTemplate(
      alerts: [.init(type: .alert, icon: .alert, message: "Pledge dropped")],
      tierType: .pledgeDropped
    )

    internal static let pledgeCanceledTemplate = makeTemplate(
      alerts: [.init(type: .warning, icon: nil, message: "Pledge canceled")],
      tierType: .pledgeCanceled
    )

    // MARK: Project alerts

    internal static let confirmAddressTemplate = makeTemplate(
      alerts: [.init(type: .warning, icon: .time, message: "Address locks in 8 hours")],
      creatorName: truncatedCreatorName,
      address: .editable(address: sampleAddressText, editUrl: "fakeEditUrl"),
      action: .confirmAddress(
        address: """
          123 First Street, Apt #5678
          Los Angeles, CA 90025-1234
          United States
        """,
        addressId: "fake-address-id"
      ),
      tierType: .confirmAddress
    )

    internal static let addressLockTemplate = makeTemplate(
      alerts: [
        .init(type: .warning, icon: .alert, message: "Survey available"),
        .init(type: .warning, icon: .time, message: "Address locks in 48 hours")
      ],
      creatorName: truncatedCreatorName,
      action: .completeSurvey(url: "fakeSurveyUrl"),
      tierType: .openSurvey
    )

    internal static let fixPaymentTemplate = makeTemplate(
      alerts: [
        .init(type: .alert, icon: .alert, message: "Payment failed"),
        .init(type: .alert, icon: .time, message: "Pledge will be dropped in 6 days")
      ],
      creatorName: truncatedCreatorName,
      action: .fixPayment,
      tierType: .fixPayment
    )

    internal static let authenticateCardTemplate = makeTemplate(
      alerts: [
        .init(type: .alert, icon: .alert, message: "Card needs authentication"),
        .init(type: .alert, icon: .time, message: "Pledge will be dropped in 6 days")
      ],
      creatorName: truncatedCreatorName,
      action: .authenticateCard(clientSecret: "seti_asdqwe_secret_x"),
      tierType: .authenticateCard
    )

    internal static let completeSurveyTemplate = makeTemplate(
      alerts: [.init(type: .warning, icon: .alert, message: "Survey available")],
      creatorName: truncatedCreatorName,
      action: .completeSurvey(url: "fakeSurveyUrl"),
      tierType: .openSurvey
    )

    internal static let openPledgeManagerTemplate = makeTemplate(
      alerts: [.init(type: .warning, icon: .alert, message: "Finalize your pledge")],
      creatorName: truncatedCreatorName,
      action: .openPledgeManager(url: "fakePledgeManagerUrl"),
      tierType: .pledgeManagement
    )

    internal static let projectAnalyticsFragmentTemplate = GraphAPI.ProjectAnalyticsFragment(
      addOns: nil,
      backersCount: 42,
      backing: nil,
      category: nil,
      commentsCount: 42,
      country: .init(code: GraphQLEnum.case(.us)),
      creator: nil,
      currency: GraphQLEnum.case(.usd),
      deadlineAt: nil,
      launchedAt: nil,
      pid: 42,
      name: "Test",
      isInPostCampaignPledgingPhase: true,
      isWatched: true,
      percentFunded: 100,
      isPrelaunchActivated: false,
      projectTags: [],
      postCampaignPledgingEnabled: false,
      rewards: nil,
      state: GraphQLEnum.case(.successful),
      video: nil,
      pledged: .init(amount: nil),
      fxRate: 4,
      usdExchangeRate: nil,
      posts: ProjectAnalyticsFragment.Posts(totalCount: 0),
      goal: nil
    )

    // MARK: UI edge cases

    internal static let shortTextTemplate = makeTemplate(
      alerts: [
        .init(type: .warning, icon: .time, message: "Wait"),
        .init(type: .alert, icon: .alert, message: "Bad")
      ],
      projectName: "Project",
      creatorName: "Bob",
      action: .completeSurvey(url: "fakeSurveyUrl"),
      tierType: .openSurvey
    )

    internal static let lotsOfFlagsTemplate = makeTemplate(
      alerts: [
        .init(
          type: .warning,
          icon: .time,
          message: "This is a very very very very very very very very very very long flag"
        ),
        .init(type: .alert, icon: .alert, message: "Also long"),
        .init(type: .alert, icon: .alert, message: "And still very long")
      ],
      projectName: "Project",
      creatorName: "Bob",
      action: .completeSurvey(url: "fakeSurveyUrl"),
      tierType: .openSurvey
    )
  }
#endif
