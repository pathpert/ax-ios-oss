import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input events handled by `ActivitySurveyResponseCellViewModel`.
public protocol ActivitySurveyResponseCellViewModelInputs {
  /// Call to configure with survey response, number of surveys, and the cell's position in the survey stack.
  func configureWith(surveyResponse: SurveyResponse, count: Int, position: Int)

  /// Call when respond now button is tapped.
  func respondNowButtonTapped()
}

/// Output signals exposed by `ActivitySurveyResponseCellViewModel`.
public protocol ActivitySurveyResponseCellViewModelOutputs {
  /// Emits image url to creator's avatar.
  var creatorImageURL: Signal<URL?, Never> { get }

  /// Emits text for the creator name label.
  var creatorNameText: Signal<String, Never> { get }

  /// Emits the survey response for the delegate to respond to the survey.
  var notifyDelegateToRespondToSurvey: Signal<SurveyResponse, Never> { get }

  /// Emits whether reward surveys count label is hidden.
  var rewardSurveysCountIsHidden: Signal<Bool, Never> { get }

  /// Emits text for reward surveys count label.
  var rewardSurveysCountText: Signal<String, Never> { get }

  /// Emits text for the survey label.
  var surveyLabelText: Signal<NSAttributedString, Never> { get }
}

/// Interface combining inputs and outputs for `ActivitySurveyResponseCellViewModel`.
public protocol ActivitySurveyResponseCellViewModelType {
  /// Input receiver for reward survey configuration and button taps.
  var inputs: ActivitySurveyResponseCellViewModelInputs { get }
  /// Output signals formatting creator survey prompts and responses.
  var outputs: ActivitySurveyResponseCellViewModelOutputs { get }
}

/// View model formatting reward survey response banners in the activity feed.
public final class ActivitySurveyResponseCellViewModel: ActivitySurveyResponseCellViewModelType,
  ActivitySurveyResponseCellViewModelInputs, ActivitySurveyResponseCellViewModelOutputs {
  /// Initializes the activity survey response cell view model.
  public init() {
    let surveyResponseAndCountAndPosition = self.surveyResponseCountPositionProperty.signal.skipNil()
    let project = surveyResponseAndCountAndPosition
      .map { surveyResponse, _, _ in surveyResponse.project }
      .skipNil()

    self.creatorImageURL = project.map { URL.init(string: $0.creator.avatar.small) }

    self.creatorNameText = project.map { $0.creator.name }

    self.surveyLabelText = project.map {
      let text = Strings.Creator_name_needs_some_information_to_deliver_your_reward_for_project_name(
        creator_name: $0.creator.name, project_name: $0.name
      )

      return text.simpleHtmlAttributedString(
        base: [
          NSAttributedString.Key.font: UIFont.ksr_subhead(size: 14),
          NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_700.uiColor()
        ],
        bold: [
          NSAttributedString.Key.font: UIFont.ksr_headline(size: 14),
          NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_700.uiColor()
        ]
      )
        ?? NSAttributedString(string: "")
    }

    self.notifyDelegateToRespondToSurvey = surveyResponseAndCountAndPosition
      .map(first)
      .takeWhen(self.respondNowButtonTappedProperty.signal)

    self.rewardSurveysCountIsHidden = surveyResponseAndCountAndPosition.map { _, count, position in
      count > 1 && position != 0
    }

    self.rewardSurveysCountText = surveyResponseAndCountAndPosition
      .map { _, count, _ in Strings.Reward_Surveys(reward_survey_count: count) }
  }

  fileprivate let surveyResponseCountPositionProperty = MutableProperty<(SurveyResponse, Int, Int)?>(nil)
  /// Configures the banner with a `SurveyResponse`, total count, and position in the stack.
  public func configureWith(surveyResponse: SurveyResponse, count: Int, position: Int) {
    self.surveyResponseCountPositionProperty.value = (surveyResponse, count, position)
  }

  fileprivate let respondNowButtonTappedProperty = MutableProperty(())
  /// Signals that the user tapped the Respond Now CTA button.
  public func respondNowButtonTapped() {
    self.respondNowButtonTappedProperty.value = ()
  }

  /// Emits the project creator's small avatar URL.
  public let creatorImageURL: Signal<URL?, Never>
  /// Emits the project creator's display name.
  public let creatorNameText: Signal<String, Never>
  /// Emits the active `SurveyResponse` when navigating to respond.
  public let notifyDelegateToRespondToSurvey: Signal<SurveyResponse, Never>
  /// Emits whether the pending surveys count label is hidden.
  public let rewardSurveysCountIsHidden: Signal<Bool, Never>
  /// Emits formatted pending reward survey count text.
  public var rewardSurveysCountText: Signal<String, Never>
  /// Emits an attributed prompt asking the backer to complete the creator's survey.
  public let surveyLabelText: Signal<NSAttributedString, Never>

  /// Returns `self` as `ActivitySurveyResponseCellViewModelInputs`.
  public var inputs: ActivitySurveyResponseCellViewModelInputs { return self }
  /// Returns `self` as `ActivitySurveyResponseCellViewModelOutputs`.
  public var outputs: ActivitySurveyResponseCellViewModelOutputs { return self }
}
