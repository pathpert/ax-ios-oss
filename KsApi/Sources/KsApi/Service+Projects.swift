import Combine
import Foundation
import GraphAPI
import Prelude
import ReactiveSwift

extension Service {
  /// Uploads an image file attachment into an existing creator `UpdateDraft`.
  public func addImage(file fileURL: URL, toDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope> {
    return request(Route.addImage(fileUrl: fileURL, toDraft: draft))
  }

  /// Deletes an uploaded image attachment from a creator `UpdateDraft`.
  public func delete(image: UpdateDraft.Image, fromDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope> {
    return request(.deleteImage(image, fromDraft: draft))
  }

  /// Builds the web preview URL for a creator's current update draft.
  public func previewUrl(forDraft draft: UpdateDraft) -> URL? {
    return self.serverConfig.apiBaseUrl
      .appendingPathComponent("/v1/projects/\(draft.update.projectId)/updates/draft/preview")
  }

  /// Submits a Trust & Safety content flagging mutation via ReactiveSwift.
  public func createFlaggingInput(input: CreateFlaggingInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.CreateFlaggingMutation(input: GraphAPI.CreateFlaggingInput.from(input))
    )
  }

  /// Submits a Trust & Safety content flagging mutation via Combine.
  public func createFlaggingInputCombine(input: CreateFlaggingInput)
    -> AnyPublisher<EmptyResponseEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .CreateFlaggingMutation(input: GraphAPI.CreateFlaggingInput.from(input))
      )
      .map { _ in EmptyResponseEnvelope() }
      .eraseToAnyPublisher()
  }

  /// Fetches hierarchical Trust & Safety project-reporting taxonomy options asynchronously.
  public func fetchProjectFlaggingOptions() async throws -> [ReportProjectInfoListItem] {
    let data: GraphAPI.FlaggingOptionsQuery.Data? = try await self.fetch(
      query: GraphAPI.FlaggingOptionsQuery(contentType: GraphQLEnum(.project))
    )

    guard let data else { return [] }

    return ReportProjectInfoListItem.items(from: data)
  }

  /// Fetches core `Project` header/funding fields without extended campaign story/FAQ data.
  public func fastFetchProjectPageBase(projectParam: Param)
    -> SignalProducer<Project, ErrorEnvelope> {
    let query = GraphAPI.FastFetchProjectPageBaseQuery(
      projectId: .someOrNil(projectParam.id),
      slug: .someOrNil(projectParam.slug)
    )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap { Project.projectProducer(from: $0) }
  }

  /// Fetches extended project tab properties (`faqs`, `risks`, `aiDisclosure`, `story`) separately from base project data.
  public func fastFetchProjectPageExtendedProperties(projectParam: Param, includeStoryRichText: Bool)
    -> SignalProducer<ProjectPageExtraProperties, ErrorEnvelope> {
    let query = GraphAPI.FastFetchProjectPageExtendedPropertiesQuery(
      projectId: .someOrNil(projectParam.id),
      slug: .someOrNil(projectParam.slug),
      storyRichText: includeStoryRichText
    )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap { ProjectPageExtraProperties.extraPropertiesProducer(from: $0) }
  }

  /// Fetches project pamphlet data by `Param` for `ProjectPageViewModel`.
  /// - Negative Constraint: Only for `ProjectPageViewController`; prefer `fetchProject(param:)` for legacy v1 callers.
  public func fetchProject(projectParam: Param, includeStoryRichText: Bool)
    -> SignalProducer<Project.ProjectPamphletData, ErrorEnvelope> {
    let query = GraphAPI.FetchProjectByParamQuery(
      projectId: .someOrNil(projectParam.id),
      slug: .someOrNil(projectParam.slug),
      storyRichText: includeStoryRichText
    )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap { Project.projectProducer(from: $0) }
  }

  /// Fetches legacy v1 `Project` payload for `ManagePledgeViewModel`, `CommentsViewModel`, `UpdateViewModel`, `UpdatePreviewViewModel`, and `AppDelegateViewModel`.
  /// - Negative Constraint: Do not use for `ProjectPageViewController` (use `fetchProject(projectParam:includeStoryRichText:)`).
  public func fetchProject(param: Param) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.project(param))
  }

  /// Fetches reward tiers for `projectId` including shipping rules via GraphQL.
  public func fetchProjectRewards(projectId: Int)
    -> SignalProducer<[Reward], ErrorEnvelope> {
    let query = GraphAPI
      .FetchProjectRewardsByIdQuery(
        projectId: projectId,
        includeShippingRules: true,
        includePledgeOverTime: false
      )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap(Project.projectRewardsProducer(from:))
  }

  /// Fetches project rewards pre-sorted for `code` (ISO country) with configurable no-reward insertion.
  public func fetchProjectRewards(
    projectId: Int,
    sortedForShippingCountryCode code: String?,
    withNoReward inserter: NoRewardInserter
  ) -> SignalProducer<[Reward], ErrorEnvelope> {
    let graphCountryCode: GraphAPI.CountryCode?
    if let code {
      graphCountryCode = GraphAPI.CountryCode(rawValue: code)
    } else {
      graphCountryCode = nil
    }

    let query = GraphAPI.FetchSortedProjectRewardsByIdQuery(
      projectId: projectId,
      location: GraphQLEnum.caseOrNil(graphCountryCode)
    )

    return GraphQL.shared.client
      .fetch(query: query)
      .map { results in
        Project.projectRewards(from: results, withNoReward: inserter)
      }
  }

  /// Fetches project rewards together with Pledge Over Time installment plan metadata.
  public func fetchProjectRewardsAndPledgeOverTimeData(projectId: Int)
    -> SignalProducer<RewardsAndPledgeOverTimeEnvelope, ErrorEnvelope> {
    let query = GraphAPI
      .FetchProjectRewardsByIdQuery(
        projectId: projectId,
        includeShippingRules: true,
        includePledgeOverTime: true
      )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap(Project.projectRewardsAndPledgeOverTimeDataProducer(from:))
  }

  /// Fetches a single-item discovery envelope matching `params` (`perPage` forced to `1`).
  public func fetchProject(_ params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    return request(.discover(params |> DiscoveryParams.lens.perPage .~ 1))
  }

  /// Fetches a project by numeric ID using Combine.
  public func fetchProject_combine(project: Project) -> AnyPublisher<Project, ErrorEnvelope> {
    return request(.project(.id(project.id)))
  }

  /// Fetches the creator/project activity feed for `project`.
  public func fetchProjectActivities(forProject project: Project) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {
    return request(.projectActivities(project))
  }

  /// Fetches the next page of project activities from an absolute pagination URL.
  public func fetchProjectActivities(paginationUrl: String)
    -> SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(paginationUrl)
  }

  /// Fetches projects where the user is a creator/member (`member: true`) or other project list.
  public func fetchProjects(member: Bool) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
    return request(.projects(member: member))
  }

  /// Fetches the next page of creator projects from an absolute pagination URL.
  public func fetchProjects(paginationUrl url: String) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
    return requestPaginationDecodable(url)
  }

  /// Fetches funding, video, and referral analytics stats for a creator's `projectId`.
  public func fetchProjectStats(projectId: Int) ->
    SignalProducer<ProjectStatsEnvelope, ErrorEnvelope> {
    return request(.projectStats(projectId: projectId))
  }

  /// Fetches a specific published creator `Update` by `updateId` and `projectParam`.
  public func fetchUpdate(updateId: Int, projectParam: Param)
    -> SignalProducer<Update, ErrorEnvelope> {
    return request(.update(updateId: updateId, projectParam: projectParam))
  }

  /// Fetches the creator's current unpublished `UpdateDraft` for `project`.
  public func fetchUpdateDraft(forProject project: Project) -> SignalProducer<UpdateDraft, ErrorEnvelope> {
    return request(.fetchUpdateDraft(forProject: project))
  }

  /// Increments the server-side video completion counter for `project` (swallows JSON parse noise on empty 200).
  public func incrementVideoCompletion(for project: any HasProjectWebURL) ->
    SignalProducer<VoidEnvelope, ErrorEnvelope> {
    let producer = request(.incrementVideoCompletion(project: project))
      as SignalProducer<VoidEnvelope, ErrorEnvelope>

    return producer
      .flatMapError { env -> SignalProducer<VoidEnvelope, ErrorEnvelope> in
        if env.ksrCode == .ErrorEnvelopeJSONParsingFailed {
          return .init(value: VoidEnvelope())
        }
        return .init(error: env)
      }
  }

  /// Increments the server-side video play counter for `project` (swallows JSON parse noise on empty 200).
  public func incrementVideoStart(forProject project: any HasProjectWebURL) ->
    SignalProducer<VoidEnvelope, ErrorEnvelope> {
    let producer = request(.incrementVideoStart(project: project))
      as SignalProducer<VoidEnvelope, ErrorEnvelope>

    return producer
      .flatMapError { env -> SignalProducer<VoidEnvelope, ErrorEnvelope> in
        if env.ksrCode == .ErrorEnvelopeJSONParsingFailed {
          return .init(value: VoidEnvelope())
        }
        return .init(error: env)
      }
  }

  /// Publishes a creator's `UpdateDraft` so it becomes visible to backers/public.
  public func publish(draft: UpdateDraft) -> SignalProducer<Update, ErrorEnvelope> {
    return request(.publishUpdateDraft(draft))
  }

  /// Updates title, body copy, and public visibility on a creator's `UpdateDraft`.
  public func update(draft: UpdateDraft, title: String, body: String, isPublic: Bool)
    -> SignalProducer<UpdateDraft, ErrorEnvelope> {
    return request(.updateUpdateDraft(draft, title: title, body: body, isPublic: isPublic))
  }

  /// Unwatches/unsaves a project via GraphQL mutation.
  public func unwatchProject(input: WatchProjectInput) ->
    SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: GraphAPI.UnwatchProjectMutation(input: GraphAPI.UnwatchProjectInput.from(input)))
      .flatMap(WatchProjectResponseEnvelope.producer(from:))
  }

  /// Watches/saves a project via GraphQL mutation.
  public func watchProject(input: WatchProjectInput) ->
    SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: GraphAPI.WatchProjectMutation(input: GraphAPI.WatchProjectInput.from(input)))
      .flatMap(WatchProjectResponseEnvelope.producer(from:))
  }
}

