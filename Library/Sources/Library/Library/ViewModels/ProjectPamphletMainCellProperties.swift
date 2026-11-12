import Foundation
import KsApi

/// Protocol for models capable of providing `ProjectPamphletMainCellProperties`.
public protocol HasProjectPamphletMainCellProperties {
  /// View properties backing the project pamphlet header cell.
  var projectPamphletMainCellProperties: ProjectPamphletMainCellProperties { get }
}

/// Combined property requirements needed to configure a project pamphlet header cell.
public typealias ProjectPamphletMainCellConfiguration =
  HasProjectAnalyticsProperties &
  HasProjectCreatorProperties &
  HasProjectPamphletMainCellProperties &
  HasProjectWebURL &
  HasVideoViewProperties

/// Render-ready properties for the main project pamphlet cell independent of REST vs GraphQL source.
public struct ProjectPamphletMainCellProperties {
  /// Whole-unit currency tuple carrying numeric amount, currency code, and currency symbol.
  public typealias Money = (amount: Int, currency: String, symbol: String)

  /// Route lookup parameter identifying the project.
  public let param: Param
  /// Project title.
  public let name: String
  /// Short project summary blurb.
  public let blurb: String
  /// Creator display name.
  public let creatorName: String
  /// URL string for the creator's small avatar image.
  public let creatorAvatarURL: String
  /// Numeric identifier of the creator.
  public let creatorId: Int
  /// `true` if the creator has been blocked by the viewer.
  public let isCreatorBlocked: Bool
  /// Current lifecycle state of the project.
  public let state: Project.State
  /// Unix timestamp (UTC seconds) of the most recent state transition.
  public let stateChangedAt: TimeInterval
  /// Full-size hero image URL string.
  public let photo: String
  /// Whether the project is currently displayed in prelaunch mode.
  public let displayPrelaunch: Bool?
  /// `true` when the current user is backing the project.
  public let isBacking: Bool?
  /// Total number of backers.
  public let backersCount: Int
  /// Primary category display name, if set.
  public let categoryName: String?
  /// Displayable project origin location name.
  public let locationName: String
  /// Campaign deadline timestamp (UTC seconds), or `nil` when prelaunch.
  public let deadline: TimeInterval?
  /// Exchange rate from project currency to viewer's display currency.
  public let fxRate: Float
  /// Exchange rate converting project currency into USD.
  public let projectUsdExchangeRate: Float
  /// Funding goal money tuple.
  public let goal: Money
  /// Amount currently pledged money tuple.
  public let pledged: Money
  /// Pre-converted pledged total in viewer's currency, if supplied by API.
  public let convertedPledgedAmount: Float?
  /// Project ISO 4217 currency code.
  public let currency: String
  /// Viewer's preferred ISO 4217 currency code, if configured.
  public let userCurrency: String?
  /// Country configuration associated with the project.
  public let country: Project.Country
  /// Optional creator or moderation notice banner text.
  public let projectNotice: String?
  /// Optional HLS and high-bitrate MP4 stream URLs for the project video.
  public let video: (hls: String?, high: String)?
  /// Canonical web URL string for the project page.
  public let webURL: String

  /// Initializes a `ProjectPamphletMainCellProperties` snapshot.
  public init(
    param: Param,
    name: String,
    blurb: String,
    creatorName: String,
    creatorAvatarURL: String,
    creatorId: Int,
    isCreatorBlocked: Bool,
    state: Project.State,
    stateChangedAt: TimeInterval,
    photo: String,
    displayPrelaunch: Bool?,
    isBacking: Bool?,
    backersCount: Int,
    categoryName: String?,
    locationName: String,
    deadline: TimeInterval?,
    fxRate: Float,
    projectUsdExchangeRate: Float,
    goal: Money,
    pledged: Money,
    convertedPledgedAmount: Float?,
    currency: String,
    userCurrency: String?,
    country: Project.Country,
    projectNotice: String?,
    video: (hls: String?, high: String)?,
    webURL: String
  ) {
    self.param = param
    self.name = name
    self.blurb = blurb
    self.creatorName = creatorName
    self.creatorAvatarURL = creatorAvatarURL
    self.creatorId = creatorId
    self.isCreatorBlocked = isCreatorBlocked
    self.state = state
    self.stateChangedAt = stateChangedAt
    self.photo = photo
    self.displayPrelaunch = displayPrelaunch
    self.isBacking = isBacking
    self.backersCount = backersCount
    self.categoryName = categoryName
    self.locationName = locationName
    self.deadline = deadline
    self.fxRate = fxRate
    self.projectUsdExchangeRate = projectUsdExchangeRate
    self.goal = goal
    self.pledged = pledged
    self.convertedPledgedAmount = convertedPledgedAmount
    self.currency = currency
    self.userCurrency = userCurrency
    self.country = country
    self.projectNotice = projectNotice
    self.video = video
    self.webURL = webURL
  }
}

extension ProjectPamphletMainCellProperties: HasVideoViewProperties {
  /// Maps hero photo and stream URLs to `VideoViewProperties`.
  public var videoViewProperties: VideoViewProperties {
    VideoViewProperties(video: self.video, photoFull: self.photo)
  }
}

extension Project: HasProjectPamphletMainCellProperties {
  /// Builds `ProjectPamphletMainCellProperties` from a REST `Project` model.
  public var projectPamphletMainCellProperties: ProjectPamphletMainCellProperties {
    ProjectPamphletMainCellProperties(
      param: .id(self.id),
      name: self.name,
      blurb: self.blurb,
      creatorName: self.creator.name,
      creatorAvatarURL: self.creator.avatar.small,
      creatorId: self.creator.id,
      isCreatorBlocked: self.creator.isBlocked,
      state: self.state,
      stateChangedAt: self.dates.stateChangedAt,
      photo: self.photo.full,
      displayPrelaunch: self.displayPrelaunch,
      isBacking: self.personalization.isBacking,
      backersCount: self.stats.backersCount,
      categoryName: self.category?.name,
      locationName: self.location?.displayableName ?? "",
      deadline: self.dates.deadline,
      fxRate: self.stats.userCurrencyRate ?? self.stats.staticUsdRate,
      projectUsdExchangeRate: self.stats.usdExchangeRate ?? self.stats.staticUsdRate,
      goal: (amount: self.stats.goal, currency: self.statsCurrency, symbol: self.country.currencySymbol),
      pledged: (
        amount: self.stats.pledged,
        currency: self.statsCurrency,
        symbol: self.country.currencySymbol
      ),
      convertedPledgedAmount: self.stats.convertedPledgedAmount,
      currency: self.stats.projectCurrency,
      userCurrency: self.stats.userCurrency,
      country: self.country,
      projectNotice: self.extendedProjectProperties?.projectNotice,
      video: self.video.map { ($0.hls, $0.high) },
      webURL: self.urls.web.project
    )
  }
}

extension ProjectPamphletMainCellProperties {
  /// Percent funded as measured from `0.0` to `1.0`. See `percentFunded` for a value from `0` to `100`.
  public var fundingProgress: Float {
    return self.goal.amount == 0 ? 0.0 : Float(self.pledged.amount) / Float(self.goal.amount)
  }

  /// Pledged amount converted to USD.
  public var pledgedUsd: Float {
    floor(Float(self.pledged.amount) * self.projectUsdExchangeRate)
  }

  /// Total amount currently pledged to the project, converted to USD, irrespective of the users selected currency
  public var totalAmountPledgedUsdCurrency: Float? {
    Float(self.pledged.amount) * self.projectUsdExchangeRate
  }

  /// Goal amount converted to USD.
  public var goalUsd: Float {
    floor(Float(self.goal.amount) * self.projectUsdExchangeRate)
  }

  /// Goal amount converted to current currency.
  public var goalCurrentCurrency: Float? {
    floor(Float(self.goal.amount) * self.fxRate)
  }

  /// Goal amount, converted to USD, irrespective of the users selected currency
  public var goalUsdCurrency: Float {
    Float(self.goal.amount) * self.projectUsdExchangeRate
  }

  /// Country determined by current currency.
  public var currentCountry: Project.Country? {
    self.userCurrency.flatMap(Project.Country.init(currencyCode:))
  }

  /// Omit US currency code
  public var omitUSCurrencyCode: Bool {
    self.currentCurrency == Project.Country.us.currencyCode
  }

  /// Project pledge & goal values need conversion
  public var needsConversion: Bool {
    self.currency != self.currentCurrency
  }

  /// `true` when pledged amount meets or exceeds the funding goal.
  public var goalMet: Bool {
    self.pledged >= self.goal
  }

  /// Active display ISO 4217 currency code, falling back to current user preference or `"USD"`.
  public var currentCurrency: String {
    self.userCurrency ?? getCurrentCurrency()
  }
}

private func getCurrentCurrency() -> String {
  AppEnvironment.current.currentUser?.chosenCurrency ?? Project.Country.us.currencyCode
}
