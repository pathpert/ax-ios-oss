#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

/// `MockService` extensions declared in `MockService+Projects.swift`.
  extension MockService {
    internal func createFlaggingInput(input: CreateFlaggingInput) -> ReactiveSwift
      .SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let mutation = GraphAPI
        .CreateFlaggingMutation(input: GraphAPI.CreateFlaggingInput.from(input))
      return client.performWithResult(mutation: mutation, result: self.createFlaggingResult)
    }

    internal func createFlaggingInputCombine(input: CreateFlaggingInput)
      -> AnyPublisher<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
      }
      let mutation = GraphAPI
        .CreateFlaggingMutation(input: GraphAPI.CreateFlaggingInput.from(input))
      return client.performWithResult(mutation: mutation, result: self.createFlaggingResult)
    }

    func fetchProjectFlaggingOptions() async throws -> [ReportProjectInfoListItem] {
      switch self.fetchFlaggingOptionsResult {
      case let .success(data):
        return ReportProjectInfoListItem.items(from: data)
      case let .failure(error):
        throw error
      case .none:
        return []
      }
    }

    internal func fetchProject(param _: Param) -> SignalProducer<Project, ErrorEnvelope> {
      guard let result = self.fetchProjectEnvelopeResult else { return .empty }
      switch result {
      case let .success(project): return SignalProducer(value: project)
      case let .failure(error): return SignalProducer(error: error)
      }
    }

    internal func fastFetchProjectPageBase(projectParam: Param)
      -> SignalProducer<Project, ErrorEnvelope> {
      if let result = self.fastFetchProjectPageResult {
        switch result.0 {
        case let .success(project): return SignalProducer(value: project)
        case let .failure(error): return SignalProducer(error: error)
        }
      }
      let query = GraphAPI.FastFetchProjectPageBaseQuery(
        projectId: .someOrNil(projectParam.id),
        slug: .someOrNil(projectParam.slug)
      )
      return self.fetch(query: query).flatMap { Project.projectProducer(from: $0) }
    }

    internal func fastFetchProjectPageExtendedProperties(
      projectParam: Param,
      includeStoryRichText: Bool
    ) -> SignalProducer<ProjectPageExtraProperties, ErrorEnvelope> {
      if let result = self.fastFetchProjectPageResult {
        switch result.1 {
        case let .success(project): return SignalProducer(value: project)
        case let .failure(error): return SignalProducer(error: error)
        }
      }
      let query = GraphAPI.FastFetchProjectPageExtendedPropertiesQuery(
        projectId: .someOrNil(projectParam.id),
        slug: .someOrNil(projectParam.slug),
        storyRichText: includeStoryRichText
      )
      return self.fetch(query: query)
        .flatMap { ProjectPageExtraProperties.extraPropertiesProducer(from: $0) }
    }

    internal func fetchProject(projectParam: Param, includeStoryRichText: Bool)
      -> SignalProducer<Project.ProjectPamphletData, ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let query = GraphAPI.FetchProjectByParamQuery(
        projectId: .someOrNil(projectParam.id),
        slug: .someOrNil(projectParam.slug),
        storyRichText: includeStoryRichText
      )
      return client.fetchWithResult(query: query, result: self.fetchProjectPamphletEnvelopeResult)
    }

    func fetchProjectRewardsAndPledgeOverTimeData(projectId: Int)
      -> SignalProducer<RewardsAndPledgeOverTimeEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let query = GraphAPI.FetchProjectRewardsByIdQuery(
        projectId: projectId,
        includeShippingRules: false,
        includePledgeOverTime: true
      )
      return client.fetchWithResult(
        query: query,
        result: self.fetchProjectRewardsAndPledgeOverTimeDataResult
      )
    }

    internal func fetchProjectRewards(projectId: Int) -> SignalProducer<[Reward], ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let query = GraphAPI.FetchProjectRewardsByIdQuery(
        projectId: projectId,
        includeShippingRules: false,
        includePledgeOverTime: false
      )
      return client.fetchWithResult(query: query, result: self.fetchProjectRewardsEnvelopeResult)
    }

    func fetchProjectRewards(
      projectId: Int,
      sortedForShippingCountryCode _: String?,
      withNoReward _: NoRewardInserter
    ) -> SignalProducer<[Reward], ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let query = GraphAPI.FetchSortedProjectRewardsByIdQuery(projectId: projectId, location: nil)
      return client.fetchWithResult(query: query, result: self.fetchProjectRewardsEnvelopeResult)
    }

    internal func fetchProject(_ params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
      if let envelope = self.fetchDiscoveryResponse {
        return SignalProducer(value: envelope)
      }
      let envelope = .template
        |> DiscoveryEnvelope.lens.projects .~ [.template |> Project.lens.id .~ params.hashValue]
      return SignalProducer(value: envelope)
    }

    internal func fetchProject_combine(project _: Project) -> AnyPublisher<Project, ErrorEnvelope> {
      fatalError("Sorry, this is unimplemented!")
    }

    internal func fetchProjectActivities(forProject _: Project) ->
      SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {
      if let error = fetchProjectActivitiesError {
        return SignalProducer(error: error)
      } else if let activities = fetchProjectActivitiesResponse {
        return SignalProducer(
          value: ProjectActivityEnvelope(
            activities: activities,
            urls: ProjectActivityEnvelope.UrlsEnvelope(
              api: ProjectActivityEnvelope.UrlsEnvelope.ApiEnvelope(
                moreActivities: "http://\(Secrets.Api.Endpoint.production)/gimme/more"
              )
            )
          )
        )
      }
      return .empty
    }

    internal func fetchProjectActivities(paginationUrl _: String)
      -> SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {
      if let error = fetchProjectActivitiesError {
        return SignalProducer(error: error)
      } else if let activities = fetchProjectActivitiesResponse {
        return SignalProducer(
          value: ProjectActivityEnvelope(
            activities: activities,
            urls: ProjectActivityEnvelope.UrlsEnvelope(
              api: ProjectActivityEnvelope.UrlsEnvelope.ApiEnvelope(moreActivities: "")
            )
          )
        )
      }
      return .empty
    }

    internal func fetchProjects(member _: Bool) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
      if let error = fetchProjectsError {
        return SignalProducer(error: error)
      } else if let projects = fetchProjectsResponse {
        return SignalProducer(
          value: ProjectsEnvelope(
            projects: projects,
            urls: ProjectsEnvelope.UrlsEnvelope(
              api: ProjectsEnvelope.UrlsEnvelope.ApiEnvelope(moreProjects: "")
            )
          )
        )
      }
      return .empty
    }

    internal func fetchProjects(paginationUrl _: String) ->
      SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
      return self.fetchProjects(member: true)
    }

    internal func fetchProjectStats(projectId _: Int) ->
      SignalProducer<ProjectStatsEnvelope, ErrorEnvelope> {
      if let error = fetchProjectStatsError {
        return SignalProducer(error: error)
      } else if let response = fetchProjectStatsResponse {
        return SignalProducer(value: response)
      }
      return SignalProducer(value: .template)
    }

    internal func incrementVideoCompletion(for _: any HasProjectWebURL) ->
      SignalProducer<VoidEnvelope, ErrorEnvelope> {
      if let error = incrementVideoCompletionError { return .init(error: error) }
      return .init(value: VoidEnvelope())
    }

    internal func incrementVideoStart(forProject _: any HasProjectWebURL) ->
      SignalProducer<VoidEnvelope, ErrorEnvelope> {
      if let error = incrementVideoStartError { return .init(error: error) }
      return .init(value: VoidEnvelope())
    }

    internal func fetchUpdate(updateId: Int, projectParam _: Param)
      -> SignalProducer<Update, ErrorEnvelope> {
      return SignalProducer(value: self.fetchUpdateResponse |> Update.lens.id .~ updateId)
    }

    internal func fetchUpdateDraft(forProject _: Project) -> SignalProducer<UpdateDraft, ErrorEnvelope> {
      if let error = self.fetchDraftError { return SignalProducer(error: error) }
      return SignalProducer(value: self.fetchDraftResponse ?? .template)
    }

    internal func update(draft: UpdateDraft, title: String, body: String, isPublic: Bool)
      -> SignalProducer<UpdateDraft, ErrorEnvelope> {
      if let error = self.updateDraftError { return SignalProducer(error: error) }
      let updatedDraft = draft
        |> UpdateDraft.lens.update.title .~ title
        |> UpdateDraft.lens.update.body .~ body
        |> UpdateDraft.lens.update.isPublic .~ isPublic
      return SignalProducer(value: updatedDraft)
    }

    internal func unwatchProject(input: WatchProjectInput)
      -> SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let mutation = GraphAPI.UnwatchProjectMutation(input: GraphAPI.UnwatchProjectInput.from(input))
      return client.performWithResult(mutation: mutation, result: self.unwatchProjectMutationResult)
    }

    internal func watchProject(input: WatchProjectInput)
      -> SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else { return .empty }
      let mutation = GraphAPI.WatchProjectMutation(input: GraphAPI.WatchProjectInput.from(input))
      return client.performWithResult(mutation: mutation, result: self.watchProjectMutationResult)
    }

    internal func addImage(file _: URL, toDraft _: UpdateDraft)
      -> SignalProducer<UpdateDraft.Image, ErrorEnvelope> {
      if let error = addAttachmentError { return SignalProducer(error: error) }
      return SignalProducer(value: self.addAttachmentResponse ?? .template)
    }

    internal func delete(image _: UpdateDraft.Image, fromDraft _: UpdateDraft)
      -> SignalProducer<UpdateDraft.Image, ErrorEnvelope> {
      if let error = removeAttachmentError { return SignalProducer(error: error) }
      return SignalProducer(value: self.removeAttachmentResponse ?? .template)
    }

    internal func publish(draft _: UpdateDraft) -> SignalProducer<Update, ErrorEnvelope> {
      if let error = publishUpdateError { return SignalProducer(error: error) }
      return SignalProducer(value: self.fetchUpdateResponse)
    }

    internal func previewUrl(forDraft draft: UpdateDraft) -> URL? {
      return URL(
        string: "https://\(Secrets.Api.Endpoint.production)/projects/\(draft.update.projectId)/updates/"
          + "\(draft.update.id)/preview"
      )
    }
  }
#endif

