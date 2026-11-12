import Combine
import Foundation
import KsApi
import Library

enum PPOPreparedEvent: Equatable {
  case backedProjects
  case exploreProjects
  case fixPaymentMethod(projectId: Int, backingId: Int)
  case fix3DSChallenge(clientSecret: String, onProgress: (PPOActionState) -> Void)
  case survey(url: String)
  case openPledgeManager(url: String)
  case projectDetails(param: ProjectPageParam)
  case editAddress(url: String)
  case confirmAddress(
    backingId: String,
    addressId: String,
    address: String,
    onProgress: (PPOActionState) -> Void
  )
  case contactCreator(messageSubject: MessageSubject)
  case updateRewardReceived(backingId: String, rewardReceived: Bool)
  case manageLivePledge(projectId: Int, backingId: Int)

  // swiftlint:disable:next cyclomatic_complexity
  static func == (lhs: PPOPreparedEvent, rhs: PPOPreparedEvent) -> Bool {
    switch (lhs, rhs) {
    case let (.survey(lhsUrl), .survey(rhsUrl)):
      return lhsUrl == rhsUrl
    case let (.openPledgeManager(lhsUrl), .openPledgeManager(rhsUrl)):
      return lhsUrl == rhsUrl
    case let (.projectDetails(lhsParam), .projectDetails(rhsParam)):
      return lhsParam.param == rhsParam.param
    case let (.editAddress(lhsUrl), .editAddress(rhsUrl)):
      return lhsUrl == rhsUrl
    case let (.contactCreator(lhsSubject), .contactCreator(rhsSubject)):
      return lhsSubject == rhsSubject
    case let (
      .fix3DSChallenge(clientSecret: lhsSecret, onProgress: _),
      .fix3DSChallenge(clientSecret: rhsSecret, onProgress: _)
    ):
      return lhsSecret == rhsSecret
    case let (
      .confirmAddress(lhsBackingId, lhsAddressId, lhsAddress, _),
      .confirmAddress(rhsBackingId, rhsAddressId, rhsAddress, _)
    ):
      return lhsBackingId == rhsBackingId && lhsAddressId == rhsAddressId && lhsAddress == rhsAddress
    case let (
      .fixPaymentMethod(lhsProjectId, lhsBackingId),
      .fixPaymentMethod(rhsProjectId, rhsBackingId)
    ):
      return lhsProjectId == rhsProjectId && lhsBackingId == rhsBackingId
    case (.backedProjects, .backedProjects), (.exploreProjects, .exploreProjects):
      return true
    case let (
      .updateRewardReceived(lhsBackingId, lhsRewardReceived),
      .updateRewardReceived(rhsBackingId, rhsRewardReceived)
    ):
      return lhsBackingId == rhsBackingId && lhsRewardReceived == rhsRewardReceived
    default:
      return false
    }
  }
}

extension PPOViewModel {
  func trackCardEvent(
    _ event: PPOCardEvent,
    cardModel: PPOProjectCardModel,
    overallProperties: KSRAnalytics.PledgedProjectOverviewProperties
  ) {
    switch event {
    case .sendMessage:
      AppEnvironment.current.ksrAnalytics.trackPPOMessagingCreator(
        from: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .editAddress:
      AppEnvironment.current.ksrAnalytics.trackPPOEditAddress(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .fixPayment:
      AppEnvironment.current.ksrAnalytics.trackPPOFixingPaymentFailure(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .completeSurvey:
      AppEnvironment.current.ksrAnalytics.trackPPOOpeningSurvey(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .openPledgeManager:
      AppEnvironment.current.ksrAnalytics.trackPPOOpenPledgeManager(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .confirmAddress:
      AppEnvironment.current.ksrAnalytics.trackPPOInitiateConfirmingAddress(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .authenticateCard:
      AppEnvironment.current.ksrAnalytics.trackPPOAuthenticateCard(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .viewProjectDetails:
      AppEnvironment.current.ksrAnalytics.trackPPOViewProjectDetails(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case let .updateRewardReceived(rewardReceived):
      AppEnvironment.current.ksrAnalytics.trackPPOUpdateRewardReceived(
        toggleOn: rewardReceived,
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    case .manageLivePledge:
      AppEnvironment.current.ksrAnalytics.trackPPOManageLivePledge(
        project: cardModel.projectAnalytics,
        properties: overallProperties
      )
    }
  }

  func preparedEvent(
    for event: PPOCardEvent,
    cardModel: PPOProjectCardModel
  ) -> PPOPreparedEvent {
    switch event {
    case let .editAddress(url):
      return .editAddress(url: url)
    case let .viewProjectDetails(projectPageParam):
      return .projectDetails(param: projectPageParam)
    case .sendMessage:
      let messageSubject = MessageSubject.project(
        id: cardModel.projectId,
        name: cardModel.projectName
      )
      return .contactCreator(messageSubject: messageSubject)
    case let .updateRewardReceived(rewardReceived: rewardReceived):
      return .updateRewardReceived(
        backingId: cardModel.backingGraphId,
        rewardReceived: rewardReceived
      )
    case let .completeSurvey(url):
      return .survey(url: url)
    case .fixPayment:
      return .fixPaymentMethod(projectId: cardModel.projectId, backingId: cardModel.backingId)
    case let .openPledgeManager(url):
      return .openPledgeManager(url: url)
    case let .confirmAddress(address, addressId):
      return .confirmAddress(
        backingId: cardModel.backingGraphId,
        addressId: addressId,
        address: address,
        onProgress: { [weak self] state in
          self?.confirmAddressProgressSubject.send((cardModel, state))
        }
      )
    case let .authenticateCard(clientSecret, onProgress):
      return .fix3DSChallenge(clientSecret: clientSecret, onProgress: onProgress)
    case .manageLivePledge:
      return .manageLivePledge(projectId: cardModel.projectId, backingId: cardModel.backingId)
    }
  }
}

extension Sequence where Element == PPOProjectCardViewModel {
  func ppoAnalyticsProperties(page: Int?) -> KSRAnalytics.PledgedProjectOverviewProperties {
    var paymentFailedCount = 0
    var cardAuthRequiredCount = 0
    var surveyAvailableCount = 0
    var addressLocksSoonCount = 0
    var pledgeManagementCount = 0
    var fundedProjectCount = 0
    var liveProjectCount = 0
    var unsuccessfulPledgeCount = 0

    for viewModel in self {
      switch viewModel.card.tierType {
      case .fixPayment: paymentFailedCount += 1
      case .authenticateCard: cardAuthRequiredCount += 1
      case .openSurvey: surveyAvailableCount += 1
      case .confirmAddress: addressLocksSoonCount += 1
      case .pledgeManagement: pledgeManagementCount += 1
      case .surveySubmitted, .pledgeCollected, .addressConfirmed, .awaitingReward, .rewardReceived:
        fundedProjectCount += 1
      case .campaignLive, .campaignFunded, .campaignEnded:
        liveProjectCount += 1
      case .campaignFailed, .pledgeDropped, .pledgeCanceled:
        unsuccessfulPledgeCount += 1
      }
    }

    return KSRAnalytics.PledgedProjectOverviewProperties(
      addressLocksSoonCount: addressLocksSoonCount,
      surveyAvailableCount: surveyAvailableCount,
      pledgeManagementCount: pledgeManagementCount,
      paymentFailedCount: paymentFailedCount,
      cardAuthRequiredCount: cardAuthRequiredCount,
      fundedProjectCount: fundedProjectCount,
      liveProjectCount: liveProjectCount,
      unsuccessfulPledgeCount: unsuccessfulPledgeCount,
      page: page
    )
  }
}

extension Publisher {
  /// Combines this publisher with the first value emitted by another publisher.
  /// - Warning: This is not a direct replacement for `withLatestFrom` from other ReactiveX libraries.
  /// - Parameter other: The publisher to grab the first value from
  /// - Returns: A publisher that emits tuples of values from this publisher paired with the first value from the other publisher
  func withFirst<B>(from other: B) -> AnyPublisher<(Self.Output, B.Output), Self.Failure> where B: Publisher,
    B.Failure == Self.Failure {
    return self.flatMap { foo in
      other.first().map { (foo, $0) }
    }.eraseToAnyPublisher()
  }
}

