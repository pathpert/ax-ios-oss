import Foundation

/// Controller/component implementing `TrackingHelpers`.
final class TrackingHelpers {
  static func pledgeContext(for viewContext: PledgeViewContext) -> KSRAnalytics.TypeContext.PledgeContext {
    switch viewContext {
    case .pledge, .latePledge:
      return .newPledge
    case .update, .updateReward, .changePaymentMethod, .editPledgeOverTime:
      return .managePledge
    case .fixPaymentMethod:
      return .fixErroredPledge
    }
  }
}
