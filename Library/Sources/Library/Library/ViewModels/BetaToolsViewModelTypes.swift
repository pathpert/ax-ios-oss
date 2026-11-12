import KsApi
import ReactiveSwift
import UIKit

/// Developer debug menu row items displayed in `BetaToolsViewController`.
public enum BetaToolsRow: Int, CaseIterable {
  /// Opens local compiled feature flags configuration screen.
  case debugConfigFeatureFlags
  /// Opens remote config and Statsig feature flags debugger.
  case debugRemoteConfigFeatureFlags
  /// Opens push notification payload debugger.
  case debugPushNotifications
  /// Opens Statsig experiment/gate debugger.
  case statsig
  /// Opens design system component gallery.
  case designSystem
  /// Opens semantic colors palette inspector.
  case colors
  /// Opens paginated scroll view demo screen.
  case paginatedScrollView
  /// Opens rich text rendering sample screen.
  case richTextExample
  /// Triggers environment switcher sheet.
  case changeEnvironment
  /// Triggers app language override switcher.
  case changeLanguage

  /// Table cell visual style suited to the row item.
  public var cellStyle: UITableViewCell.CellStyle {
    switch self {
    case .debugConfigFeatureFlags, .debugRemoteConfigFeatureFlags, .debugPushNotifications,
         .statsig: return .default
    default: return .value1
    }
  }

  /// Table row highlight behavior when selected.
  public var selectionStyle: UITableViewCell.SelectionStyle {
    switch self {
    case .changeEnvironment, .changeLanguage: return .none
    default: return .default
    }
  }

  /// Static English title rendered in the beta tools table row.
  public var titleText: String {
    switch self {
    case .debugConfigFeatureFlags: return "Config Feature Flags"
    case .debugRemoteConfigFeatureFlags: return "Remote Config and Statsig Feature Flags"
    case .debugPushNotifications: return "Debug Push Notifications"
    case .statsig: return "Statsig Debugger"
    case .designSystem: return "Design System"
    case .colors: return "Semantic Colors"
    case .paginatedScrollView: return "Paginated Scroll View"
    case .richTextExample: return "Rich Text Example"
    case .changeEnvironment: return "Change Environment"
    case .changeLanguage: return "Change Language"
    }
  }

  /// Trailing disclosure icon asset name, or `nil` for action rows.
  public var rightIconImageName: String? {
    switch self {
    case .debugConfigFeatureFlags, .debugRemoteConfigFeatureFlags,
         .debugPushNotifications, .statsig, .paginatedScrollView, .richTextExample, .designSystem,
         .colors: return "chevron-right"
    default: return nil
    }
  }

  /// Returns detail value text from `data` for environment/language rows, or `nil`.
  public func detailText(from data: BetaToolsData) -> String? {
    switch self {
    case .changeEnvironment: return data.currentEnvironment
    case .changeLanguage: return data.currentLanguage
    default: return nil
    }
  }
}

/// Inputs accepted by `BetaToolsViewModel`.
public protocol BetaToolsViewModelInputs {
  /// Triggers beta feedback composer or mail-disabled alert based on `canSendMail`.
  func betaFeedbackButtonTapped(canSendMail: Bool)
  /// Routes navigation or picker sheets for the selected `BetaToolsRow`.
  func didSelectBetaToolsRow(_ row: BetaToolsRow)
  /// Emits discovery logout reset parameters after an environment switch.
  func didUpdateEnvironment()
  /// Selects a target API `EnvironmentType`.
  func setEnvironment(_ environment: EnvironmentType)
  /// Updates the debug override `Language`.
  func setCurrentLanguage(_ language: Language)
  /// Notifies the view model that the view finished loading.
  func viewDidLoad()
}

/// Strongly-typed snapshot of active beta configuration shown in developer tools.
///
/// Negative Constraint: Display-only diagnostic strings; do not persist as environment keys.
public struct BetaToolsData: Equatable, Sendable {
  /// Localized display name of the active app language.
  public let currentLanguage: String
  /// Active API server environment label (e.g., `"Production"`, `"Staging"`).
  public let currentEnvironment: String

  /// Creates a typed `BetaToolsData` contract.
  public init(currentLanguage: String, currentEnvironment: String) {
    self.currentLanguage = currentLanguage
    self.currentEnvironment = currentEnvironment
  }
}

/// Reactive outputs emitted by `BetaToolsViewModel`.
public protocol BetaToolsViewModelOutputs {
  /// Emits when beta feedback email composer should open.
  var goToBetaFeedback: Signal<(), Never> { get }
  /// Emits when config feature flags debugger should open.
  var goToConfigFeatureFlagTools: Signal<(), Never> { get }
  /// Emits when remote config / Statsig flags screen should open.
  var goToRemoteConfigFeatureFlagTools: Signal<(), Never> { get }
  /// Emits when push notification payload tester should open.
  var goToPushNotificationTools: Signal<(), Never> { get }
  /// Emits when Statsig debugger sheet should appear.
  var showStatsigDebugger: Signal<(), Never> { get }
  /// Emits when paginated scroll view playground should open.
  var goToPaginatedScrollView: Signal<(), Never> { get }
  /// Emits when rich text playground should open.
  var goToRichTextExample: Signal<(), Never> { get }
  /// Emits when design system showcase should open.
  var goToDesignSystem: Signal<(), Never> { get }
  /// Emits when semantic color palette screen should open.
  var goToColors: Signal<(), Never> { get }
  /// Emits default discovery parameters after logging out across environments.
  var logoutWithParams: Signal<DiscoveryParams, Never> { get }
  /// Emits refreshed `BetaToolsData` whenever environment or language changes.
  var reloadWithData: Signal<BetaToolsData, Never> { get }
  /// Emits table row index for anchoring the environment action sheet.
  var showChangeEnvironmentSheetWithSourceViewIndex: Signal<Int, Never> { get }
  /// Emits table row index for anchoring the language action sheet.
  var showChangeLanguageSheetWithSourceViewIndex: Signal<Int, Never> { get }
  /// Emits when Mail is unavailable for sending beta feedback.
  var showMailDisabledAlert: Signal<(), Never> { get }
  /// Emits newly selected debug `Language`.
  var updateLanguage: Signal<Language, Never> { get }
  /// Emits newly selected API `EnvironmentType`.
  var updateEnvironment: Signal<EnvironmentType, Never> { get }
}

/// Combined inputs/outputs contract for developer beta tools.
public protocol BetaToolsViewModelType {
  /// Input receiver.
  var inputs: BetaToolsViewModelInputs { get }
  /// Output signal provider.
  var outputs: BetaToolsViewModelOutputs { get }
}

