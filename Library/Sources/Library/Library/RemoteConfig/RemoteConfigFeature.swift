import Foundation

/// Firebase Remote Config feature keys controlled from the server.
public enum RemoteConfigFeature: String, CaseIterable {
  /// Bypasses Pledge Manager decision gating.
  case bypassPledgeManagerDecisionPolicy = "bypass_pledge_manager_decision_policy"
  /// Enables storing OAuth tokens in Keychain instead of user defaults.
  case useKeychainForOAuthToken = "use_keychain_for_oauth_token"
  /// Enables the floating tab bar UI.
  case floatingTabBar = "floating_tab_bar"
  /// Enables Pledged Projects Overview V2 experience.
  case pledgedProjectsOverviewV2Enabled = "pledged_projects_overview_v2"
  /// Enables Pledged Projects Overview V3/V4 experience.
  case pledgedProjectsOverviewV4Enabled = "pledged_projects_overview_v4"
}

extension RemoteConfigFeature: CustomStringConvertible {
  /// Human-readable display label for Remote Config debug tools.
  public var description: String {
    switch self {
    case .bypassPledgeManagerDecisionPolicy: return "Bypass Pledge Manager Decision Policy"
    case .useKeychainForOAuthToken: return "Use Keychain for OAuth token"
    case .floatingTabBar: return "Floating Tab Bar"
    case .pledgedProjectsOverviewV2Enabled: return "Pledged Projects Overview V2"
    case .pledgedProjectsOverviewV4Enabled: return "Pledged Projects Overview V3, V4"
    }
  }
}
