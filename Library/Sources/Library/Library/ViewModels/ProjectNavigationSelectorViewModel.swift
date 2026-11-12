import KsApi
import Prelude
import ReactiveSwift

/// Top-level content tabs selectable within the project page navigation bar.
public enum NavigationSection: Int, CaseIterable {
  /// Project overview summary tab.
  case overview
  /// Campaign story tab.
  case campaign
  /// Frequently asked questions tab.
  case faq
  /// Project risks and challenges tab.
  case risks
  /// AI usage disclosure tab.
  case aiDisclosure
  /// Creator environmental commitments tab.
  case environmentalCommitments

  /// Localized tab label displayed in the navigation selector.
  public var displayString: String {
    switch self {
    case .campaign: return Strings.Campaign()
    case .environmentalCommitments: return Strings.Environmental_commitments()
    case .faq: return Strings.Faq()
    case .overview: return Strings.Overview()
    case .aiDisclosure: return Strings.Use_of_ai()
    case .risks: return Strings.Risks()
    }
  }
}

/// Input events handled by `ProjectNavigationSelectorViewModel`.
public protocol ProjectNavigationSelectorViewModelInputs {
  /// Called when the view is moved to the superview, similar to a viewDidAppear input
  func didMoveToSuperview()

  /// Called when a button on the project navigation selector is tapped
  func buttonTapped(index: Int)

  /// Called with a `(Project, RefTag?)` instance when `viewDidLoad` is called on the `ProjectPageViewController`
  func configureNavigationSelector(with: (Project, RefTag?))
}

/// Output signals exposed by `ProjectNavigationSelectorViewModel`.
public protocol ProjectNavigationSelectorViewModelOutputs {
  /// Emits an `Int` of the index that the selectedButtonBottomBorder will animate to
  var animateButtonBottomBorderViewConstraints: Signal<Int, Never> { get }

  /// Emits `[NavigationSection]` when called to configure the selectedButonBottomBorderView
  var configureNavigationSelectorUI: Signal<[NavigationSection], Never> { get }

  /// Emits `Int` of a button index being selected
  var notifyDelegateProjectNavigationSelectorDidSelect: Signal<Int, Never> { get }

  /// Emits an `Int` which is the index of the button being selected
  var updateNavigationSelectorUI: Signal<Int, Never> { get }
}

/// Interface combining inputs and outputs for `ProjectNavigationSelectorViewModel`.
public protocol ProjectNavigationSelectorViewModelType {
  /// Input receiver for tab selection and project configuration events.
  var inputs: ProjectNavigationSelectorViewModelInputs { get }
  /// Output signals configuring visible tabs and animating selection indicators.
  var outputs: ProjectNavigationSelectorViewModelOutputs { get }
}

/// View model determining available project page sections and coordinating tab selection.
public final class ProjectNavigationSelectorViewModel: ProjectNavigationSelectorViewModelType,
  ProjectNavigationSelectorViewModelInputs, ProjectNavigationSelectorViewModelOutputs {
  /// Initializes the project navigation selector view model.
  public init() {
    self.animateButtonBottomBorderViewConstraints = self.buttonTappedProperty.signal

    let displayableTabs: (Project) -> [NavigationSection] = { project in
      let baseTabs: [NavigationSection] = [.overview]

      guard let extendedProjectProperties = project.extendedProjectProperties,
            let displayPrelaunch = project.displayPrelaunch,
            !displayPrelaunch else {
        if featureProjectStoryRichTextEnabled() {
          return baseTabs + [.campaign]
        } else {
          return baseTabs
        }
      }

      let moreTabs: [NavigationSection] = [.campaign, .faq, .risks]

      var includeAIDisclosure = false

      if let aiDisclosure = extendedProjectProperties.aiDisclosure, aiDisclosure.involvesAi {
        includeAIDisclosure = true
      }

      let includeEnvironmentCommitments = !extendedProjectProperties.environmentalCommitments.isEmpty

      let aiDisclosureTab: [NavigationSection] = includeAIDisclosure ? [.aiDisclosure] : []
      let environmentCommitmentTab: [NavigationSection] = includeEnvironmentCommitments ?
        [.environmentalCommitments] : []

      return baseTabs + moreTabs + aiDisclosureTab + environmentCommitmentTab
    }

    let initialTabs = self.didMoveToSuperviewSignal
      .take(first: 1)
      .map { _ in [NavigationSection.overview] }

    let projectDisplayedTabs = self.configureNavigationSelectorProperty.signal
      .skipNil()
      .map(first)
      .map(displayableTabs)

    self.configureNavigationSelectorUI = initialTabs.merge(with: projectDisplayedTabs)

    let configureNavigationSelector = self.configureNavigationSelectorProperty.signal.skipNil()

    // Called when a button is tapped or when the view is configured and we default to the first index
    let setFirstIndexOnConfigurationOrButtonTapped = Signal.merge(
      initialTabs.mapConst(0),
      configureNavigationSelector.mapConst(0),
      self.buttonTappedProperty.signal
    )

    self.notifyDelegateProjectNavigationSelectorDidSelect = setFirstIndexOnConfigurationOrButtonTapped

    self.updateNavigationSelectorUI = setFirstIndexOnConfigurationOrButtonTapped

    let projectTabSelectedAfterFirstLoad = configureNavigationSelector
      .takePairWhen(self.buttonTappedProperty.signal.skip(while: { $0 == 0 }).skipRepeats())

    projectTabSelectedAfterFirstLoad
      .map { projectAndRefTag, index in (projectAndRefTag.0, projectAndRefTag.1, index) }
      .observeValues { [weak self] project, refTag, index in
        self?.trackPageViewedProjectTab(index: index, project: project, refTag: refTag)
      }
  }

  // MARK: Helpers

  private func trackPageViewedProjectTab(index: Int, project: Project, refTag: RefTag?) {
    guard let contextValue = self.navigationTabContext(index: index) else { return }

    AppEnvironment.current.ksrAnalytics.trackProjectViewed(
      project,
      refTag: refTag,
      sectionContext: contextValue
    )
  }

  private func navigationTabContext(index: Int) -> KSRAnalytics.SectionContext? {
    switch index {
    case 0: return .tabSelected(.overview)
    case 1: return .tabSelected(.campaign)
    case 2: return .tabSelected(.faqs)
    case 3: return .tabSelected(.risks)
    case 4: return .tabSelected(.useOfAI)
    case 5: return .tabSelected(.environmentalCommitments)
    default: return nil
    }
  }

  fileprivate let (didMoveToSuperviewSignal, didMoveToSuperviewObserver) = Signal<Void, Never>.pipe()
  /// Signals that the selector view moved into its superview hierarchy.
  public func didMoveToSuperview() {
    self.didMoveToSuperviewObserver.send(value: ())
  }

  fileprivate let buttonTappedProperty = MutableProperty<Int>(0)
  /// Selects the project section tab at `index` and emits selection animations.
  public func buttonTapped(index: Int) {
    self.buttonTappedProperty.value = index
  }

  fileprivate let configureNavigationSelectorProperty = MutableProperty<(Project, RefTag?)?>(nil)
  /// Configures visible tabs based on `Project` properties and optional referral tag.
  public func configureNavigationSelector(with projectProperties: (Project, RefTag?)) {
    self.configureNavigationSelectorProperty.value = projectProperties
  }

  /// Emits the index whose bottom underline constraint should animate into focus.
  public let animateButtonBottomBorderViewConstraints: Signal<Int, Never>
  /// Emits the ordered `NavigationSection` tabs available for the project.
  public let configureNavigationSelectorUI: Signal<[NavigationSection], Never>
  /// Emits the selected tab index to notify the parent coordinator.
  public var notifyDelegateProjectNavigationSelectorDidSelect: Signal<Int, Never>
  /// Emits the currently active tab index to update button highlights.
  public let updateNavigationSelectorUI: Signal<Int, Never>

  /// Returns `self` as `ProjectNavigationSelectorViewModelInputs`.
  public var inputs: ProjectNavigationSelectorViewModelInputs { return self }
  /// Returns `self` as `ProjectNavigationSelectorViewModelOutputs`.
  public var outputs: ProjectNavigationSelectorViewModelOutputs { return self }
}
