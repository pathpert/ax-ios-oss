import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model formatting a reward card's pricing, items, shipping/delivery info, pills, badges, and tap events.
public final class RewardCardViewModel: RewardCardViewModelType, RewardCardViewModelInputs,
  RewardCardViewModelOutputs {
  /// Initializes the reward card view model and binds display signals.
  public init() {
    let configData = self.configDataProperty.signal.skipNil()
    let context = configData.map(\.context)
    let project: Signal<Project, Never> = configData.map(\.project)
    let reward: Signal<Reward, Never> = configData.map(\.reward)
    let currentShippingLocation: Signal<Location?, Never> = configData.map(\.currentShippingLocation)
    let projectAndReward = Signal.zip(project, reward)

    self.conversionLabelHidden = project.map(rewardCardNeedsConversion(project:) >>> negate)
    self.conversionLabelText = projectAndReward
      .filter(first >>> rewardCardNeedsConversion(project:))
      .map { project, reward in
        let userCurrencyCode = project.stats.userCurrency ?? Project.Country.us.currencyCode
        return Format.currency(
          reward.convertedMinimum,
          currencyCode: userCurrencyCode,
          omitCurrencyCode: project.stats.omitUSCurrencyCode,
          roundingMode: .up
        )
      }
      .map(Strings.About_reward_amount(reward_amount:))

    self.rewardMinimumLabelText = projectAndReward
      .map { ($0.0, Either<Reward, Backing>.left($0.1)) }
      .map(formattedAmountForRewardOrBacking(project:rewardOrBacking:))

    self.descriptionLabelText = projectAndReward.map(rewardCardLocalizedDescription(project:reward:))
    self.rewardTitleLabelHidden = reward.map { $0.title == nil && !$0.isNoReward }
    self.rewardTitleLabelAttributedText = projectAndReward.map(rewardCardTitle(project:reward:))

    let rewardItemsIsEmpty = reward.map { reward in
      guard let items = reward.rewardsItems else {
        assertionFailure("Expected reward items to be fetched.")
        return true
      }
      return items.isEmpty
    }
    self.includedItemsStackViewHidden = rewardItemsIsEmpty.skipRepeats()

    self.items = reward.map { reward in
      guard let items = reward.rewardsItems else {
        assertionFailure("Expected reward items to be fetched.")
        return []
      }
      return items.map { rewardsItem in
        rewardsItem.quantity > 1
          ? "(\(Format.wholeNumber(rewardsItem.quantity))) \(rewardsItem.item.name)"
          : rewardsItem.item.name
      }
    }

    self.reloadPills = projectAndReward.map(rewardCardPillValues(project:reward:))
    self.pillCollectionViewHidden = self.reloadPills.map { $0.isEmpty }
    self.rewardSelected = reward.takeWhen(self.rewardCardTappedProperty.signal).map { $0.id }

    self.cardUserInteractionIsEnabled = configData.map { data in
      rewardsCarouselCanNavigateToReward(
        data.reward,
        in: data.project,
        selectedShippingLocation: data.currentShippingLocation
      )
    }

    self.estimatedDeliveryStackViewHidden = context.combineLatest(with: reward)
      .map { context, reward in context == .manage || reward.estimatedDeliveryOn == nil }

    self.rewardLocationStackViewHidden = reward.map { !isRewardLocalPickup($0) }

    self.estimatedShippingLabelText = Signal.combineLatest(reward, project, currentShippingLocation)
      .map { reward, project, location in
        guard let locationId = location?.id else { return nil }
        return estimatedShippingText(for: [reward], project: project, locationId: locationId)
      }

    self.estimatedDeliveryDateLabelText = reward.map(rewardCardEstimatedDeliveryDateText(with:)).skipNil()
    self.rewardLocationPickupLabelText = reward.map { $0.localPickup?.displayableName }.skipNil()

    self.estimatedShippingStackViewHidden = Signal.combineLatest(reward, self.estimatedShippingLabelText.signal)
      .map { reward, text in reward.shipping.enabled == false || text == nil }

    self.rewardImage = reward.map { $0.image }.skipNil()
    self.rewardImageHidden = reward.map { $0.image == nil }
    self.rewardBadge = reward.map { RewardCardBadgeData.forReward($0) }
  }

  private let configDataProperty = MutableProperty<RewardCardViewData?>(nil)
  /// Configures the view model with project, reward, context, and selected shipping location.
  public func configure(with data: RewardCardViewData) { self.configDataProperty.value = data }

  private let rewardCardTappedProperty = MutableProperty(())
  /// Signals that the user tapped the reward card.
  public func rewardCardTapped() { self.rewardCardTappedProperty.value = () }

  /// Emits whether the reward card should accept touch interaction.
  public let cardUserInteractionIsEnabled: Signal<Bool, Never>
  /// Emits whether the converted pledge amount label is hidden.
  public let conversionLabelHidden: Signal<Bool, Never>
  /// Emits the formatted converted pledge amount text.
  public let conversionLabelText: Signal<String, Never>
  /// Emits the localized reward description text.
  public let descriptionLabelText: Signal<String, Never>
  /// Emits whether the estimated shipping row is hidden.
  public let estimatedShippingStackViewHidden: Signal<Bool, Never>
  /// Emits whether the estimated delivery row is hidden.
  public let estimatedDeliveryStackViewHidden: Signal<Bool, Never>
  /// Emits the formatted estimated delivery month and year.
  public let estimatedDeliveryDateLabelText: Signal<String, Never>
  /// Emits the localized estimated shipping string when available.
  public let estimatedShippingLabelText: Signal<String?, Never>
  /// Emits formatted strings for each included item in the reward.
  public let items: Signal<[String], Never>
  /// Emits whether the included items section is hidden.
  public let includedItemsStackViewHidden: Signal<Bool, Never>
  /// Emits whether the pills container is hidden.
  public let pillCollectionViewHidden: Signal<Bool, Never>
  /// Emits configured pill data displayed at the bottom of the card.
  public let reloadPills: Signal<[RewardCardPillData], Never>
  /// Emits the local pickup venue display name.
  public let rewardLocationPickupLabelText: Signal<String, Never>
  /// Emits whether the local pickup location row is hidden.
  public let rewardLocationStackViewHidden: Signal<Bool, Never>
  /// Emits the formatted minimum pledge amount string.
  public let rewardMinimumLabelText: Signal<String, Never>
  /// Emits the selected reward ID when the card is tapped.
  public let rewardSelected: Signal<Int, Never>
  /// Emits whether the reward title label is hidden.
  public let rewardTitleLabelHidden: Signal<Bool, Never>
  /// Emits attributed reward title text including quantity prefix when applicable.
  public let rewardTitleLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits hero image metadata for the reward.
  public let rewardImage: Signal<Reward.Image, Never>
  /// Emits whether the reward image view is hidden.
  public let rewardImageHidden: Signal<Bool, Never>
  /// Emits badge data when the reward is secret or featured.
  public let rewardBadge: Signal<RewardCardBadgeData?, Never>

  /// View model inputs.
  public var inputs: RewardCardViewModelInputs { return self }
  /// View model outputs.
  public var outputs: RewardCardViewModelOutputs { return self }
}
