import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// View model managing recommendations, rating/newsletter prompts, notifications, and analytics after backing a project.
public final class ThanksViewModel: ThanksViewModelType, ThanksViewModelInputs, ThanksViewModelOutputs {
  /// Initializes the thank-you view model and binds recommendation fetches, alerts, and tracking.
  public init() {
    let configData = self.configureWithDataProperty.signal.skipNil()
    let project = configData.map { $0.project }
    let rewardAndCheckoutData = configData.map { ($0.reward, $0.checkoutData) }

    self.backedProjectText = configData
      .map { data in
        let project = data.project
        let totalString = Format.currency(data.pledgeTotal, currencyCode: project.statsCurrency)
        let string = project.isInPostCampaignPledgingPhase
          ? Strings.You_have_successfully_pledged_to_project_post_campaign_html_short(pledge_total: totalString)
          : Strings.You_have_successfully_backed_project_html(project_name: project.name)

        return string
          .simpleHtmlAttributedString(font: UIFont.ksr_subhead(), bold: UIFont.ksr_subhead().bolded)
          ?? NSAttributedString(string: "")
      }
      .takeWhen(self.viewDidLoadProperty.signal)

    let shouldShowGamesAlert = project.map { project in
      project.category?.rootId == KsApi.Category.gamesId &&
        !(AppEnvironment.current.currentUser?.newsletters.games ?? false) &&
        !AppEnvironment.current.userDefaults.hasSeenGamesNewsletterPrompt
    }

    self.showGamesNewsletterAlert = shouldShowGamesAlert
      .filter(isTrue)
      .takeWhen(self.viewDidLoadProperty.signal)
      .ignoreValues()

    self.showGamesNewsletterOptInAlert = self.gamesNewsletterSignupButtonTappedProperty.signal
      .filter { AppEnvironment.current.countryCode == "DE" }
      .map(Strings.profile_settings_newsletter_games)

    self.showRatingAlert = shouldShowGamesAlert
      .filter {
        $0 == false &&
          !AppEnvironment.current.userDefaults.hasSeenAppRating &&
          AppEnvironment.current.config?.iTunesLink != nil && shouldShowThanksPledgeDialog() == false
      }
      .takeWhen(self.viewDidLoadProperty.signal)
      .ignoreValues()
      .on(value: { AppEnvironment.current.userDefaults.hasSeenAppRating = true })

    self.postProjectBackedNotification = self.closeButtonTappedProperty.signal
      .mapConst(Notification(name: .ksr_projectBacked))

    self.goToDiscovery = self.categoryCellTappedProperty.signal.skipNil()
      .map { DiscoveryParams.defaults |> DiscoveryParams.lens.category .~ $0 }

    let rootCategory: Signal<KsApi.Category, Never> = project
      .map { $0.category }
      .skipNil()
      .map(thanksCategoryBase64Id)
      .flatMap {
        AppEnvironment.current.apiService.fetchGraphCategory(id: $0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .map { (categoryEnvelope: KsApi.CategoryEnvelope) -> KsApi.Category in
            categoryEnvelope.node.parent ?? categoryEnvelope.node
          }
          .demoteErrors()
      }

    let projects = Signal.combineLatest(project, rootCategory)
      .flatMap { thanksRelatedProjects(toProject: $0.0, inCategory: $0.1) }
      .filter { !$0.isEmpty }

    self.showRecommendations = Signal.zip(projects, rootCategory).map { ($0, $1) }
    self.goToProject = self.showRecommendations
      .map(first)
      .takePairWhen(self.projectTappedProperty.signal.skipNil())
      .map { projects, project in (project, projects, RefTag.thanks) }

    self.updateUserInEnvironment = self.gamesNewsletterSignupButtonTappedProperty.signal
      .map { AppEnvironment.current.currentUser ?? nil }
      .skipNil()
      .switchMap { user in
        AppEnvironment.current.apiService.updateUserSelf(user |> \.newsletters.games .~ true)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .demoteErrors()
      }

    self.postContextualNotification = self.viewDidLoadProperty.signal.filter { shouldShowThanksPledgeDialog() }
    self.postUserUpdatedNotification = self.userUpdatedProperty.signal
      .mapConst(Notification(name: .ksr_userUpdated))

    self.showGamesNewsletterAlert
      .observeValues { AppEnvironment.current.userDefaults.hasSeenGamesNewsletterPrompt = true }

    wireThanksThirdPartyAndAnalytics(
      project: project,
      configData: configData,
      viewDidLoad: self.viewDidLoadProperty.signal,
      projectTapped: self.projectTappedProperty.signal.skipNil(),
      rewardAndCheckoutData: rewardAndCheckoutData
    )
  }

  /// View model inputs.
  public var inputs: ThanksViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ThanksViewModelOutputs { return self }

  fileprivate let configureWithDataProperty = MutableProperty<ThanksPageData?>(nil)
  /// Configures the view model with the backed project payload.
  public func configure(with data: ThanksPageData) { self.configureWithDataProperty.value = data }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the thank-you view finished loading.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  fileprivate let closeButtonTappedProperty = MutableProperty(())
  /// Signals that the close button was tapped to dismiss the thank-you screen.
  public func closeButtonTapped() { self.closeButtonTappedProperty.value = () }

  fileprivate let categoryCellTappedProperty = MutableProperty<KsApi.Category?>(nil)
  /// Signals that a recommended category CTA was tapped.
  public func categoryCellTapped(_ category: KsApi.Category) { self.categoryCellTappedProperty.value = category }

  fileprivate let projectTappedProperty = MutableProperty<Project?>(nil)
  /// Signals that a recommended project card was tapped.
  public func projectTapped(_ project: Project) { self.projectTappedProperty.value = project }

  fileprivate let gamesNewsletterSignupButtonTappedProperty = MutableProperty(())
  /// Signals that the user opted in to the games newsletter prompt.
  public func gamesNewsletterSignupButtonTapped() {
    self.gamesNewsletterSignupButtonTappedProperty.value = ()
  }

  fileprivate let userUpdatedProperty = MutableProperty(())
  /// Signals that the current user profile finished refreshing.
  public func userUpdated() { self.userUpdatedProperty.value = () }

  /// Signals dismissal and refreshes home/backed state after a project is backed.
  public let postProjectBackedNotification: Signal<Notification, Never>
  /// Emits discovery parameters to browse a tapped category.
  public let goToDiscovery: Signal<DiscoveryParams, Never>
  /// Emits formatted congratulatory headline text describing the completed pledge.
  public let backedProjectText: Signal<NSAttributedString, Never>
  /// Emits the tapped project, recommendation list, and referral tag for project navigation.
  public let goToProject: Signal<(Project, [Project], RefTag), Never>
  /// Triggers contextual first-time backer notifications after loading.
  public let postContextualNotification: Signal<(), Never>
  /// Emits a user-updated notification after refreshing user settings.
  public let postUserUpdatedNotification: Signal<Notification, Never>
  /// Triggers an App Store rating prompt when eligible.
  public let showRatingAlert: Signal<(), Never>
  /// Triggers the games newsletter opt-in alert when eligible.
  public let showGamesNewsletterAlert: Signal<(), Never>
  /// Emits localized confirmation text for Germany double opt-in newsletter consent.
  public let showGamesNewsletterOptInAlert: Signal<String, Never>
  /// Emits related recommended projects paired with the project's root category.
  public let showRecommendations: Signal<([Project], KsApi.Category), Never>
  /// Emits the updated user model after subscribing to the games newsletter.
  public let updateUserInEnvironment: Signal<User, Never>
}
