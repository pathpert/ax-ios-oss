import KsApi
import ReactiveSwift

/// Interface exposing UI and category data streams for `FetchCategoriesUseCase`.
public protocol FetchCategoriesUseCaseType {
  /// Loading-state UI signal outputs.
  var uiOutputs: FetchCategoriesUseCaseUIOutputs { get }
  /// Fetched root categories data stream.
  var dataOutputs: FetchCategoriesUseCaseDataOutputs { get }
}

/// Loading indicator output signals for `FetchCategoriesUseCase`.
public protocol FetchCategoriesUseCaseUIOutputs {
  /// Emits whether the categories are loading for the activity indicator view.
  var loadingIndicatorIsVisible: Signal<Bool, Never> { get }
}

/// Fetched category output signals for `FetchCategoriesUseCase`.
public protocol FetchCategoriesUseCaseDataOutputs {
  /// Emits the list of categories, either from cache or from the network
  var categories: Signal<[Category], Never> { get }
}

/// Fetches root Kickstarter discovery categories from cache or GraphQL upon initialization.
public final class FetchCategoriesUseCase: FetchCategoriesUseCaseType, FetchCategoriesUseCaseUIOutputs,
  FetchCategoriesUseCaseDataOutputs {
  /// Concrete UI output interface.
  public var uiOutputs: FetchCategoriesUseCaseUIOutputs { return self }
  /// Concrete category data output interface.
  public var dataOutputs: FetchCategoriesUseCaseDataOutputs { return self }

  /// Initializes the use case, loading cached categories or querying GraphQL on `initialSignal`.
  public init(initialSignal: Signal<Void, Never>) {
    let loaderIsVisible = MutableProperty(false)

    let cachedCats = initialSignal
      .map(cachedCategories)

    let categoriesEvent = cachedCats
      .filter { $0?.isEmpty != .some(false) }
      .switchMap { _ in
        AppEnvironment.current.apiService.fetchGraphCategories()
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .on(starting: {
            loaderIsVisible.value = true
          })
          .map { (envelope: RootCategoriesEnvelope) in envelope.rootCategories }
          .materialize()
      }

    self.loadingIndicatorIsVisible = Signal.merge(
      loaderIsVisible.signal,
      categoriesEvent.values().mapConst(false),
      categoriesEvent.errors().mapConst(false)
    )

    self.categories = Signal.merge(
      cachedCats.skipNil(),
      categoriesEvent.values()
    ).on(value: { cache(categories:) }())
  }

  /// Emits `true` while network category fetch is in flight and `false` upon completion.
  public let loadingIndicatorIsVisible: Signal<Bool, Never>
  /// Emits cached or freshly fetched root `Category` values.
  public let categories: Signal<[Category], Never>
}

private func cachedCategories() -> [KsApi.Category]? {
  return AppEnvironment.current
    .cache[KSCache.ksr_discoveryFiltersCategories] as? [KsApi.Category]
}

private func cache(categories: [KsApi.Category]) {
  AppEnvironment.current.cache[KSCache.ksr_discoveryFiltersCategories] = categories
}
