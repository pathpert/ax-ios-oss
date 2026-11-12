import KDS
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// View model backing the internal Beta Tools menu, environment switcher, and debug screen routing.
public final class BetaToolsViewModel: BetaToolsViewModelType,
  BetaToolsViewModelInputs, BetaToolsViewModelOutputs {
  /// Inputs receiver (`self`).
  public var inputs: BetaToolsViewModelInputs {
    return self
  }

  /// Outputs provider (`self`).
  public var outputs: BetaToolsViewModelOutputs {
    return self
  }

  /// Creates a new `BetaToolsViewModel`.
  public init() {
    let languageFromAppEnvironment = self.viewDidLoadProperty.signal
      .map { _ in AppEnvironment.current.language }
    let serverConfigEnvironmentFromAppEnvironment = self.viewDidLoadProperty.signal
      .map { _ in AppEnvironment.current.apiService.serverConfig.environment }

    self.updateLanguage = languageFromAppEnvironment
      .takePairWhen(self.currentLanguageProperty.signal.skipRepeats())
      .filter(!=)
      .map(second)

    let currentLanguageString = Signal.merge(languageFromAppEnvironment, self.updateLanguage)
      .map { $0.displayString }

    self.updateEnvironment = serverConfigEnvironmentFromAppEnvironment
      .takePairWhen(self.environmentProperty.signal.skipRepeats())
      .filter(!=)
      .map(second)
      .skipNil()

    let currentEnvironmentString = Signal.merge(
      serverConfigEnvironmentFromAppEnvironment,
      self.updateEnvironment
    )
    .map { $0.description }

    self.reloadWithData = Signal.combineLatest(
      currentLanguageString,
      currentEnvironmentString
    )
    .map { BetaToolsData(
      currentLanguage: $0.0,
      currentEnvironment: $0.1
    ) }

    self.goToBetaFeedback = self.canSendMailProperty.signal.filter(isTrue).ignoreValues()

    let betaFeedbackMailDisabled = self.canSendMailProperty.signal.filter(isFalse)

    self.showMailDisabledAlert = betaFeedbackMailDisabled.ignoreValues()

    self.goToPushNotificationTools = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.debugPushNotifications }
      .ignoreValues()

    self.goToConfigFeatureFlagTools = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.debugConfigFeatureFlags }
      .ignoreValues()

    self.goToRemoteConfigFeatureFlagTools = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.debugRemoteConfigFeatureFlags }
      .ignoreValues()

    self.showStatsigDebugger = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.statsig }
      .ignoreValues()

    self.goToPaginatedScrollView = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.paginatedScrollView }
      .ignoreValues()

    self.goToRichTextExample = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.richTextExample }
      .ignoreValues()

    self.goToDesignSystem = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.designSystem }
      .ignoreValues()

    self.showChangeEnvironmentSheetWithSourceViewIndex = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.changeEnvironment }
      .map { $0.rawValue }

    self.showChangeLanguageSheetWithSourceViewIndex = self.didSelectBetaToolsRowProperty.signal
      .skipNil()
      .filter { $0 == BetaToolsRow.changeLanguage }
      .map { $0.rawValue }

    self.goToColors =
      self.didSelectBetaToolsRowProperty.signal
        .skipNil()
        .filter { $0 == BetaToolsRow.colors }
        .ignoreValues()

    self.logoutWithParams = self.didUpdateEnvironmentProperty.signal
      .map {
        .defaults
          |> DiscoveryParams.lens.includePOTD .~ true
          |> DiscoveryParams.lens.sort .~ .magic
      }
  }

  fileprivate let canSendMailProperty = MutableProperty(true)
  /// Sends beta feedback composer event or disabled-mail alert based on `canSendMail`.
  public func betaFeedbackButtonTapped(canSendMail: Bool) {
    self.canSendMailProperty.value = canSendMail
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the beta tools view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let didSelectBetaToolsRowProperty = MutableProperty<BetaToolsRow?>(nil)
  /// Handles selection of a row in the beta tools table.
  public func didSelectBetaToolsRow(_ row: BetaToolsRow) {
    self.didSelectBetaToolsRowProperty.value = row
  }

  private let didUpdateEnvironmentProperty = MutableProperty(())
  /// Emits post-switch discovery reset parameters after changing environment.
  public func didUpdateEnvironment() {
    self.didUpdateEnvironmentProperty.value = ()
  }

  private let environmentProperty = MutableProperty<EnvironmentType?>(nil)
  /// Requests switching to `environment`.
  public func setEnvironment(_ environment: EnvironmentType) {
    self.environmentProperty.value = environment
  }

  private let currentLanguageProperty = MutableProperty(AppEnvironment.current.language)
  /// Requests overriding the active app `language`.
  public func setCurrentLanguage(_ language: Language) {
    self.currentLanguageProperty.value = language
  }

  /// Emits when beta feedback email composer should open.
  public let goToBetaFeedback: Signal<(), Never>
  /// Emits when config feature flags debugger should open.
  public let goToConfigFeatureFlagTools: Signal<(), Never>
  /// Emits when remote config / Statsig flags screen should open.
  public let goToRemoteConfigFeatureFlagTools: Signal<(), Never>
  /// Emits when push notification payload tester should open.
  public let goToPushNotificationTools: Signal<(), Never>
  /// Emits when paginated scroll view playground should open.
  public let goToPaginatedScrollView: Signal<(), Never>
  /// Emits when rich text playground should open.
  public let goToRichTextExample: Signal<(), Never>
  /// Emits when design system showcase should open.
  public let goToDesignSystem: Signal<(), Never>
  /// Emits when Statsig debugger sheet should appear.
  public let showStatsigDebugger: Signal<(), Never>
  /// Emits when semantic color palette screen should open.
  public let goToColors: Signal<(), Never>
  /// Emits newly selected debug `Language`.
  public let updateLanguage: Signal<Language, Never>
  /// Emits newly selected API `EnvironmentType`.
  public let updateEnvironment: Signal<EnvironmentType, Never>
  /// Emits default discovery parameters after logging out across environments.
  public let logoutWithParams: Signal<DiscoveryParams, Never>
  /// Emits refreshed `BetaToolsData` whenever environment or language changes.
  public let reloadWithData: Signal<BetaToolsData, Never>
  /// Emits when Mail is unavailable for sending beta feedback.
  public let showMailDisabledAlert: Signal<(), Never>
  /// Emits table row index for anchoring the environment action sheet.
  public let showChangeEnvironmentSheetWithSourceViewIndex: Signal<Int, Never>
  /// Emits table row index for anchoring the language action sheet.
  public let showChangeLanguageSheetWithSourceViewIndex: Signal<Int, Never>
}
