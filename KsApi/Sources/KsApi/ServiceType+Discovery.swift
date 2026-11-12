import Combine
import Foundation
import GraphAPI
import ReactiveSwift

/// Domain-scoped protocol for project discovery, categories, and attribution/analytics events.
public protocol ServiceDiscoveryType {
  /// Sends facebook ad data and/or google analytics data relevant to the user.
  /// - Returns: `SignalProducer` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func triggerThirdPartyEventInput(input: TriggerThirdPartyEventInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Let the server know to create/track an attribution event.
  /// - Returns: `SignalProducer` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func createAttributionEvent(input: GraphAPI.CreateAttributionEventInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Fetch the server configuration.
  /// - Returns: `SignalProducer` emitting `Config` or an `ErrorEnvelope`.
  func fetchConfig() -> SignalProducer<Config, ErrorEnvelope>

  /// Fetch discovery envelope with a pagination url.
  /// - Returns: `SignalProducer` emitting `DiscoveryEnvelope` or an `ErrorEnvelope`.
  func fetchDiscovery(paginationUrl: String) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the full discovery envelope with specified discovery params.
  /// - Returns: `SignalProducer` emitting `DiscoveryEnvelope` or an `ErrorEnvelope`.
  func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch discovery envelope with a pagination url using Combine.
  /// - Returns: `AnyPublisher` emitting `DiscoveryEnvelope` or an `ErrorEnvelope`.
  func fetchDiscovery_combine(paginationUrl: String)
    -> AnyPublisher<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch discovery envelope with specified discovery params using Combine.
  /// - Returns: `AnyPublisher` emitting `DiscoveryEnvelope` or an `ErrorEnvelope`.
  func fetchDiscovery_combine(params: DiscoveryParams)
    -> AnyPublisher<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch Categories objects using GraphQL.
  /// - Returns: `SignalProducer` emitting `RootCategoriesEnvelope` or an `ErrorEnvelope`.
  func fetchGraphCategories() -> SignalProducer<RootCategoriesEnvelope, ErrorEnvelope>

  /// Fetch Category objects using GraphQL.
  /// - Returns: `SignalProducer` emitting `CategoryEnvelope` or an `ErrorEnvelope`.
  func fetchGraphCategory(id: String)
    -> SignalProducer<CategoryEnvelope, ErrorEnvelope>
}

/// Domain-scoped protocol for fetching projects, rewards, creator updates, watching/flagging, and video stats.
public protocol ServiceProjectsType {
  /// Uploads and attaches an image to the draft of a project update.
  /// - Returns: `SignalProducer` emitting `UpdateDraft.Image` or an `ErrorEnvelope`.
  func addImage(file fileURL: URL, toDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope>

  /// Removes an image from a project update draft.
  /// - Returns: `SignalProducer` emitting the removed `UpdateDraft.Image` or an `ErrorEnvelope`.
  func delete(image: UpdateDraft.Image, fromDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope>

  /// Sends report project data for a specific project.
  /// - Returns: `SignalProducer` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func createFlaggingInput(input: CreateFlaggingInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Sends report project data for a specific project using Combine.
  /// - Returns: `AnyPublisher` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func createFlaggingInputCombine(input: CreateFlaggingInput)
    -> AnyPublisher<EmptyResponseEnvelope, ErrorEnvelope>

  /// Fetches and maps flagging options for a given content type (e.g. project, comment, backing).
  /// - Returns: Array of `ReportProjectInfoListItem` options.
  func fetchProjectFlaggingOptions() async throws -> [ReportProjectInfoListItem]

  /// Fetch the newest data for a particular project from its id or slug. (v1)
  /// - Returns: `SignalProducer` emitting `Project` or an `ErrorEnvelope`.
  func fetchProject(param: Param) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its id or slug. Includes backings and rewards.
  /// Does not include extended project properties, shipping, or project video.
  /// Used by `ProjectPageFetcher` to run an optimized project page fetch.
  func fastFetchProjectPageBase(projectParam: Param)
    -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its id or slug. Includes extended project properties.
  /// Used by `ProjectPageFetcher` to run an optimized project page fetch.
  func fastFetchProjectPageExtendedProperties(projectParam: Param, includeStoryRichText: Bool)
    -> SignalProducer<ProjectPageExtraProperties, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its id or slug, including an optional backing id if current user is backing project.
  func fetchProject(projectParam: Param, includeStoryRichText: Bool)
    -> SignalProducer<Project.ProjectPamphletData, ErrorEnvelope>

  /// Fetch the project's rewards and pledge over time data.
  func fetchProjectRewardsAndPledgeOverTimeData(projectId: Int)
    -> SignalProducer<RewardsAndPledgeOverTimeEnvelope, ErrorEnvelope>

  /// Fetch the project's rewards only, without shipping rules.
  func fetchProjectRewards(projectId: Int) -> SignalProducer<[Reward], ErrorEnvelope>

  /// Fetch the project's rewards, including 'No Reward'. Includes all shipping rules.
  /// Uses the included `NoRewardInserter` to decide where 'No Reward' should live in the list.
  func fetchProjectRewards(
    projectId: Int,
    sortedForShippingCountryCode: String?,
    withNoReward: NoRewardInserter
  )
    -> SignalProducer<[Reward], ErrorEnvelope>

  /// Fetch a single project with the specified discovery params.
  func fetchProject(_ params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its project value.
  func fetchProject_combine(project: Project) -> AnyPublisher<Project, ErrorEnvelope>

  /// Fetch a page of activities for a project.
  func fetchProjectActivities(forProject project: Project) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope>

  /// Fetch a page of activities for a project from a pagination url.
  func fetchProjectActivities(paginationUrl: String) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope>

  /// Fetches the projects that the current user is a member of.
  func fetchProjects(member: Bool) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope>

  /// Fetches more projects from a pagination URL.
  func fetchProjects(paginationUrl: String) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope>

  /// Fetches the stats for a particular project.
  func fetchProjectStats(projectId: Int) -> SignalProducer<ProjectStatsEnvelope, ErrorEnvelope>

  /// Fetches an update from its id and project.
  func fetchUpdate(updateId: Int, projectParam: Param) -> SignalProducer<Update, ErrorEnvelope>

  /// Fetches a project update draft.
  func fetchUpdateDraft(forProject project: Project) -> SignalProducer<UpdateDraft, ErrorEnvelope>

  /// Increment the video complete stat for a project.
  func incrementVideoCompletion(for project: any HasProjectWebURL)
    -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Increment the video start stat for a project.
  func incrementVideoStart(forProject project: any HasProjectWebURL)
    -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Returns a project update preview URL.
  func previewUrl(forDraft draft: UpdateDraft) -> URL?

  /// Publishes a project update draft.
  func publish(draft: UpdateDraft) -> SignalProducer<Update, ErrorEnvelope>

  /// Updates the draft of a project update.
  func update(draft: UpdateDraft, title: String, body: String, isPublic: Bool)
    -> SignalProducer<UpdateDraft, ErrorEnvelope>

  /// Unwatches a project.
  func unwatchProject(input: WatchProjectInput) ->
    SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope>

  /// Watches (also known as favoriting) a project.
  func watchProject(input: WatchProjectInput) ->
    SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope>
}

