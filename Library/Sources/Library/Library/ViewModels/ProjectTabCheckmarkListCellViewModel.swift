import KsApi
import Prelude
import ReactiveSwift

/// Input contract for `ProjectTabCheckmarkListCellViewModel`.
public protocol ProjectTabCheckmarkListCellViewModelInputs {
  /// Call to configure with a `ProjectTabFundingOptions`.
  func configureWith(value: ProjectTabFundingOptions)
}

/// Output contract for `ProjectTabCheckmarkListCellViewModel`.
public protocol ProjectTabCheckmarkListCellViewModelOutputs {
  /// Emits a `String` of the category
  var categoryLabelText: Signal<String, Never> { get }

  /// Emits an array of `String` descriptions of the funding options
  var descriptionOptionsText: Signal<[String], Never> { get }
}

/// Composite ViewModel protocol for AI funding disclosure checkmark cells.
public protocol ProjectTabCheckmarkListCellViewModelType {
  /// Input receiver.
  var inputs: ProjectTabCheckmarkListCellViewModelInputs { get }
  /// Output signal provider.
  var outputs: ProjectTabCheckmarkListCellViewModelOutputs { get }
}

/// ViewModel converting boolean AI funding disclosures into localized bulleted option labels.
public final class ProjectTabCheckmarkListCellViewModel:
  ProjectTabCheckmarkListCellViewModelType, ProjectTabCheckmarkListCellViewModelInputs,
  ProjectTabCheckmarkListCellViewModelOutputs {
  /// Initializes localized disclosure header and checked option list signals.
  public init() {
    let fundingOptions = self.configureWithProperty.signal
      .skipNil()

    self.categoryLabelText = fundingOptions
      .map { _ in Strings.My_project_seeks_funding_for_AI_technology() }

    self.descriptionOptionsText = fundingOptions
      .map { options in
        var optionsTextValues = [String]()

        if options.fundingForAiConsent {
          let consentText = internationalizedString(for: .consent)
          optionsTextValues.append(consentText)
        }

        if options.fundingForAiAttribution {
          let attributionText = internationalizedString(for: .attribution)
          optionsTextValues.append(attributionText)
        }

        if options.fundingForAiOption {
          let ownerText = internationalizedString(for: .option)
          optionsTextValues.append(ownerText)
        }

        return optionsTextValues
      }
  }

  fileprivate let configureWithProperty = MutableProperty<ProjectTabFundingOptions?>(nil)
  /// Binds `ProjectTabFundingOptions` to render enabled disclosure statements.
  public func configureWith(value: ProjectTabFundingOptions) {
    self.configureWithProperty.value = value
  }

  /// Section title stream.
  public let categoryLabelText: Signal<String, Never>
  /// Ordered list of enabled localized funding disclosure descriptions.
  public let descriptionOptionsText: Signal<[String], Never>

  /// Self-conformance to `ProjectTabCheckmarkListCellViewModelInputs`.
  public var inputs: ProjectTabCheckmarkListCellViewModelInputs { self }
  /// Self-conformance to `ProjectTabCheckmarkListCellViewModelOutputs`.
  public var outputs: ProjectTabCheckmarkListCellViewModelOutputs { self }
}

private func internationalizedString(for category: ProjectTabAIFundingCategory) -> String {
  switch category {
  case .attribution:
    return Strings.The_owners_of_those_works()
  case .consent:
    return Strings.For_the_database_or_source_I_will_use()
  case .option:
    return Strings.There_is_or_will_be_an_opt()
  }
}
