import Foundation
import GraphAPI
import Kingfisher
import KsApi
import Library

/// Toggle state representing whether a backer marked a reward as received.
public enum PPORewardToggleState: Equatable {
  /// Toggle is not shown for this pledge card tier.
  case hidden
  /// Backer confirmed the reward was received.
  case rewardReceived
  /// Backer has not yet marked the reward as received.
  case notReceived
}

/// Strongly-typed view model data backing a card in Pledged Projects Overview (PPO).
public struct PPOProjectCardModel: Identifiable, Equatable, Hashable {
  /// Whether this card has an unread alert badge.
  public let isUnread: Bool
  /// Status banners or deadline alerts displayed on the card.
  public let alerts: [Alert]
  /// Remote project cover image source.
  public let image: Kingfisher.Source
  /// Localized project title.
  public let projectName: String
  /// Legacy numeric project identifier.
  public let projectId: Int
  /// Formatted pledge amount string.
  public let pledge: String
  /// Display name of the project creator.
  public let creatorName: String
  /// Formatted shipping address and editability state.
  public let address: DisplayAddress
  /// Current state of the reward-received toggle control.
  public let rewardReceivedToggleState: PPORewardToggleState
  /// Primary CTA button action available on this card, if any.
  public let action: ButtonAction?
  /// Classification tier grouping this card in PPO.
  public let tierType: PPOTierType
  /// Numeric backing identifier.
  public let backingId: Int
  /// GraphQL global node identifier for the backing.
  public let backingGraphId: String
  /// Analytics fragment attached to the project card.
  public let projectAnalytics: GraphAPI.ProjectAnalyticsFragment
  /// Navigation parameters used to open the native project page.
  public let projectPageParam: ProjectPageParam?

  /// Combines stable card identity fields into `hasher`.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.isUnread)
    hasher.combine(self.alerts)
    hasher.combine(self.image)
    hasher.combine(self.projectName)
    hasher.combine(self.projectId)
    hasher.combine(self.pledge)
    hasher.combine(self.creatorName)
    hasher.combine(self.address)
    hasher.combine(self.action)
    hasher.combine(self.tierType)
  }

  // MARK: - Identifiable

  /// Stable card identity derived from `projectId`, `tierType`, and active `action`.
  public var id: String {
    "\(self.projectId)-\(self.tierType)-\(self.action?.id ?? "")"
  }

  // MARK: - Equatable

  /// Returns whether all rendered card fields match between two card models.
  public static func == (lhs: PPOProjectCardModel, rhs: PPOProjectCardModel) -> Bool {
    lhs.isUnread == rhs.isUnread &&
      lhs.alerts == rhs.alerts &&
      lhs.image == rhs.image &&
      lhs.projectName == rhs.projectName &&
      lhs.projectId == rhs.projectId &&
      lhs.pledge == rhs.pledge &&
      lhs.creatorName == rhs.creatorName &&
      lhs.address == rhs.address &&
      lhs.rewardReceivedToggleState == rhs.rewardReceivedToggleState &&
      lhs.action == rhs.action &&
      lhs.tierType == rhs.tierType &&
      lhs.backingId == rhs.backingId
  }

  /// Formatted shipping address visibility and edit state for a PPO card.
  public enum DisplayAddress: Equatable, Hashable {
    /// No address section should be displayed.
    case hidden
    /// Shipping address is locked by the creator or survey.
    case locked(address: String)
    /// Shipping address can be edited via `editUrl`.
    case editable(address: String, editUrl: String)

    /// Raw formatted address string when visible; `nil` when hidden.
    public var rawAddress: String? {
      switch self {
      case .hidden: return nil
      case let .locked(address): return address
      case let .editable(address, _): return address
      }
    }
  }

  /// Primary CTA action types triggered from a PPO card.
  public enum ButtonAction: Identifiable, Equatable, Hashable {
    /// Confirm the shipping address with the backing system.
    case confirmAddress(address: String, addressId: String)
    /// Launch the backer survey web flow at `url`.
    case completeSurvey(url: String)
    /// Open Pledge Manager at `url`.
    case openPledgeManager(url: String)
    /// Repair a failed payment method for the backing.
    case fixPayment
    /// Complete 3DS / Strong Customer Authentication with `clientSecret`.
    case authenticateCard(clientSecret: String)
    /// Open native Manage Pledge screen for a live project.
    case manageLivePledge

    /// Localized CTA button title for this action.
    public var label: String {
      switch self {
      case .confirmAddress:
        Strings.Confirm()
      case .completeSurvey:
        Strings.Take_survey()
      case .openPledgeManager:
        Strings.Finalize_pledge()
      case .fixPayment:
        Strings.Fix_payment()
      case .authenticateCard:
        Strings.Authenticate_card()
      case .manageLivePledge:
        Strings.project_manage_button()
      }
    }

    /// Semantic button color style for this CTA action.
    public var style: Style {
      switch self {
      case .confirmAddress:
        .green
      case .completeSurvey:
        .green
      case .openPledgeManager:
        .green
      case .fixPayment:
        .red
      case .authenticateCard:
        .red
      case .manageLivePledge:
        .blue
      }
    }

    /// Color style palette supported by PPO CTA buttons.
    public enum Style: Identifiable, Equatable {
      /// Primary green button style.
      case green
      /// Destructive/urgent red button style.
      case red
      /// Informational blue button style.
      case blue

      /// Stable identifier string for the style case.
      public var id: String {
        switch self {
        case .green: "green"
        case .red: "red"
        case .blue: "blue"
        }
      }
    }

    /// Stable identifier combining localized label and visual style.
    public var id: String {
      "\(self.label) \(self.style.id)"
    }
  }

  /// Status or warning alert banner rendered inside a PPO card.
  public struct Alert: Identifiable, Equatable, Hashable {
    /// Visual severity classification for the alert banner.
    public let type: AlertType
    /// Optional leading icon displayed beside the alert message.
    public let icon: AlertIcon?
    /// Localized alert copy displayed to the backer.
    public let message: String

    /// Creates a typed PPO card `Alert`.
    public init(type: AlertType, icon: AlertIcon?, message: String) {
      self.type = type
      self.icon = icon
      self.message = message
    }

    /// Stable identifier combining alert type, icon, and message text.
    public var id: String {
      "\(self.type)-\(self.icon?.id ?? "noIcon")-\(self.message)"
    }

    /// Icon glyph displayed beside a PPO card alert.
    public enum AlertIcon: Identifiable, Equatable {
      /// Clock icon indicating an approaching deadline.
      case time
      /// Warning exclamation icon.
      case alert

      /// Stable string identifier for the icon variant.
      public var id: String {
        switch self {
        case .time:
          "time"
        case .alert:
          "alert"
        }
      }
    }

    /// Severity tone of a PPO card alert banner.
    public enum AlertType: Identifiable, Equatable {
      /// Amber warning notice.
      case warning
      /// Critical error or payment failure alert.
      case alert
      /// Neutral informational notice.
      case info

      /// Stable string identifier for the alert severity.
      public var id: String {
        switch self {
        case .warning:
          "warning"
        case .alert:
          "alert"
        case .info:
          "info"
        }
      }
    }
  }
}
