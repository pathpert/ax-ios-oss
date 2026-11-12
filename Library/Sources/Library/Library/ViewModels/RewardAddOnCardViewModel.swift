import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model managing state and user interactions for a reward add-on card.
public final class RewardAddOnCardViewModel: RewardAddOnCardViewModelType, RewardAddOnCardViewModelInputs,
  RewardAddOnCardViewModelOutputs {
  /// Initializes the reward add-on card view model.
  public init() {
    let configData = self.configDataProperty.signal.skipNil()

    let project: Signal<Project, Never> = configData.map(\.project)
    let reward: Signal<Reward, Never> = configData.map(\.reward)
    let selectedQuantities: Signal<SelectedRewardQuantities, Never> = configData.map(\.selectedQuantities)
    let shippingRule: Signal<ShippingRule?, Never> = configData.map(\.shippingRule)

    let projectAndReward = Signal.zip(project, reward)
    let projectRewardShippingRule = configData.map { data in
      (data.project, data.reward, data.shippingRule)
    }

    self.amountConversionLabelHidden = project.map(addOnNeedsConversion(project:) >>> negate)

    self.amountConversionLabelText = projectRewardShippingRule
      .filter(first >>> addOnNeedsConversion(project:))
      .map { project, reward, shippingRule -> (Project, Reward, Double) in
        let convertedAmount = reward.minimum
          .addingCurrency(shippingRule?.cost ?? 0)
          .multiplyingCurrency(
            Double(project.stats.userCurrencyRate ?? project.stats.staticUsdRate)
          )

        return (project, reward, convertedAmount)
      }
      .map { project, _, amount in
        let userCurrency = project.stats.userCurrency ?? Project.Country.us.currencyCode

        return Format.currency(
          amount,
          currencyCode: userCurrency,
          omitCurrencyCode: project.stats.omitUSCurrencyCode,
          roundingMode: .up
        )
      }
      .map(Strings.About_reward_amount(reward_amount:))

    self.amountLabelAttributedText = projectRewardShippingRule.map(addOnAmountStringForReward)
    self.descriptionLabelText = reward.map(\.description)
    self.rewardTitleLabelText = reward.map(\.title).skipNil()

    let rewardItemsIsEmpty = reward.map { reward in
      guard let items = reward.rewardsItems else {
        assertionFailure("Expected reward items to be fetched.")
        return true
      }
      return items.isEmpty
    }

    self.includedItemsStackViewHidden = rewardItemsIsEmpty.skipRepeats()

    self.includedItemsLabelAttributedText = reward.map { reward in
      guard let items = reward.rewardsItems else {
        assertionFailure("Expected reward items to be fetched.")
        return []
      }

      return items
    }
    .map(addOnItemsLabelAttributedText)
    .skipNil()

    self.estimatedShippingLabelText = Signal.combineLatest(reward, project, shippingRule)
      .map { reward, project, shippingRule in
        guard let locationId = shippingRule?.location.id else { return nil }

        return estimatedShippingText(for: [reward], project: project, locationId: locationId)
      }

    self.estimatedShippingStackViewHidden = Signal.combineLatest(reward, self.estimatedShippingLabelText)
      .map { reward, text in
        reward.shipping.enabled == false || text == nil
      }

    self.reloadPills = projectAndReward.map(addOnPillValues(project:reward:))
    self.pillsViewHidden = self.reloadPills.map { $0.isEmpty }

    self.rewardSelected = reward
      .takeWhen(self.rewardAddOnCardTappedProperty.signal)
      .map { $0.id }

    let initialSelectedQuantity = Signal.combineLatest(reward, selectedQuantities)
      .map { reward, selectedQuantities in selectedQuantities[reward.id] ?? 0 }

    let updatedSelectedQuantity = Signal.merge(
      self.addButtonTappedProperty.signal.mapConst(1),
      self.stepperValueChangedProperty.signal.skipNil().map(Int.init)
    )

    let initialOrUpdatedSelectedQuantity = Signal.merge(
      initialSelectedQuantity,
      updatedSelectedQuantity
    )

    self.addButtonHidden = initialOrUpdatedSelectedQuantity.map { $0 > 0 }
    self.quantityLabelText = initialOrUpdatedSelectedQuantity.map(String.init)

    self.notifiyDelegateDidSelectQuantity = updatedSelectedQuantity
      .withLatest(from: reward.map(\.id))

    self.rewardLocationStackViewHidden = reward.map { !isRewardLocalPickup($0) }
    self.rewardLocationPickupLabelText = reward.map { $0.localPickup?.displayableName }.skipNil()

    self.stepperMaxValue = projectAndReward
      .map { project, reward in
        rewardLimitPerBackerRemainingForBacker(project: project, reward: reward) ?? 0
      }
      .map(Double.init)

    self.stepperStackViewHidden = initialOrUpdatedSelectedQuantity.map { $0 == 0 }
    self.stepperValue = initialOrUpdatedSelectedQuantity.map(Double.init)

    let generateFeedbackWithValues = updatedSelectedQuantity.map(Double.init)
      .withLatestFrom(self.stepperMaxValue)

    self.generateSelectionFeedback = generateFeedbackWithValues
      .filter { value, max in value > 0 && value < max }
      .ignoreValues()

    self.generateNotificationWarningFeedback = generateFeedbackWithValues
      .filter { value, max in value == 0 || value >= max }
      .ignoreValues()

    self.rewardImage = reward.map { $0.image }.skipNil()
    self.rewardImageHidden = reward.map { $0.image == nil }
  }

  private let addButtonTappedProperty = MutableProperty(())
  /// Notifies the view model that the Add button was tapped.
  public func addButtonTapped() {
    self.addButtonTappedProperty.value = ()
  }

  private let configDataProperty = MutableProperty<RewardAddOnCardViewData?>(nil)
  /// Configures the view model with reward add-on data.
  public func configure(with data: RewardAddOnCardViewData) {
    self.configDataProperty.value = data
  }

  private let rewardAddOnCardTappedProperty = MutableProperty(())
  /// Notifies the view model that the add-on card was tapped.
  public func rewardAddOnCardTapped() {
    self.rewardAddOnCardTappedProperty.value = ()
  }

  private let stepperValueChangedProperty = MutableProperty<Double?>(nil)
  /// Notifies the view model that the quantity stepper value changed.
  public func stepperValueChanged(_ value: Double) {
    self.stepperValueChangedProperty.value = value
  }

  /// Emits whether the Add button should be hidden.
  public let addButtonHidden: Signal<Bool, Never>
  /// Emits whether the currency conversion label should be hidden.
  public let amountConversionLabelHidden: Signal<Bool, Never>
  /// Emits formatted converted pledge amount copy.
  public let amountConversionLabelText: Signal<String, Never>
  /// Emits attributed pledge amount and shipping cost text.
  public let amountLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits the add-on reward description text.
  public let descriptionLabelText: Signal<String, Never>
  /// Emits when light selection haptic feedback should fire.
  public let generateSelectionFeedback: Signal<Void, Never>
  /// Emits when warning haptic feedback should fire at step bounds.
  public let generateNotificationWarningFeedback: Signal<Void, Never>
  /// Emits attributed bullet list of included reward items.
  public let includedItemsLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits whether the included items stack view should be hidden.
  public let includedItemsStackViewHidden: Signal<Bool, Never>
  /// Emits formatted estimated shipping copy when shipping is enabled.
  public let estimatedShippingLabelText: Signal<String?, Never>
  /// Emits whether the estimated shipping stack view should be hidden.
  public let estimatedShippingStackViewHidden: Signal<Bool, Never>
  /// Emits the updated reward quantity and identifier tuple.
  public let notifiyDelegateDidSelectQuantity: Signal<(SelectedRewardQuantity, SelectedRewardId), Never>
  /// Emits whether the badge pills view should be hidden.
  public let pillsViewHidden: Signal<Bool, Never>
  /// Emits the currently selected quantity string.
  public let quantityLabelText: Signal<String, Never>
  /// Emits metadata pill strings (time left, remaining count, backer limit).
  public let reloadPills: Signal<[String], Never>
  /// Emits the selected reward identifier when the card is tapped.
  public let rewardSelected: Signal<Int, Never>
  /// Emits the add-on reward title text.
  public let rewardTitleLabelText: Signal<String, Never>
  /// Emits the selected pickup location display string.
  public let rewardLocationPickupLabelText: Signal<String, Never>
  /// Emits whether the pickup location stack view should be hidden.
  public let rewardLocationStackViewHidden: Signal<Bool, Never>
  /// Emits the maximum stepper value allowed for this add-on.
  public let stepperMaxValue: Signal<Double, Never>
  /// Emits whether the quantity stepper stack view should be hidden.
  public let stepperStackViewHidden: Signal<Bool, Never>
  /// Emits the current stepper value.
  public let stepperValue: Signal<Double, Never>
  /// Emits the optional reward image model.
  public let rewardImage: Signal<Reward.Image, Never>
  /// Emits whether the reward image view should be hidden.
  public let rewardImageHidden: Signal<Bool, Never>

  /// Input interface for this view model.
  public var inputs: RewardAddOnCardViewModelInputs { return self }
  /// Output interface for this view model.
  public var outputs: RewardAddOnCardViewModelOutputs { return self }
}
