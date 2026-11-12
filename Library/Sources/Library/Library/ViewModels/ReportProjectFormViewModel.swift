import Combine
import Foundation
import GraphAPI
import KsApi
import ReactiveSwift

/// Inputs accepted by `ReportProjectFormViewModel`.
public protocol ReportProjectFormViewModelInputs {
  /// Signals that the report-project form has loaded.
  func viewDidLoad()
}

/// Outputs emitted by `ReportProjectFormViewModel`.
public protocol ReportProjectFormViewModelOutputs {}

/// Interface combining inputs and outputs for `ReportProjectFormViewModel`.
public protocol ReportProjectFormViewModelType {
  /// Input receiver for form lifecycle events.
  var inputs: ReportProjectFormViewModelInputs { get }
  /// Output protocol accessor for compatibility with ReactiveSwift conventions.
  var outputs: ReportProjectFormViewModelOutputs { get }
}

/// View model managing Combine bindings and submission for the report-a-project form.
public final class ReportProjectFormViewModel: ReportProjectFormViewModelType,
  ReportProjectFormViewModelInputs, ReportProjectFormViewModelOutputs, ObservableObject {
  /// Email address fetched for the signed-in reporter.
  @Published public var retrievedEmail: String?
  /// Whether the form's Save/Submit button is enabled.
  @Published public var saveButtonEnabled: Bool = false
  /// Whether the submission request is in progress.
  @Published public var saveButtonLoading: Bool = false
  /// User-entered explanation describing the report reason.
  @Published public var detailsText: String = ""
  /// Banner notification view model presenting error or confirmation feedback.
  @Published public var bannerMessage: MessageBannerViewViewModel?

  /// Set to `true` after the report mutation succeeds.
  @Published public var submitSuccess: Bool = false

  private let viewDidLoadSubject = PassthroughSubject<Bool, Never>()
  private let saveTriggeredSubject = PassthroughSubject<(), Never>()

  private var cancellables = Set<AnyCancellable>()

  /// GraphQL ID of the project being reported.
  public var projectID: String?
  /// Category reason selected for the project report.
  public var projectFlaggingKind: GraphAPI.NonDeprecatedFlaggingKind?

  /// Initializes the report project form view model.
  public init() {
    /// Only enable the save button if the user has entered detail text
    self.$detailsText
      .map { !$0.isEmpty }
      .assign(to: &self.$saveButtonEnabled)

    /// Load the current user's e-mail on page load
    self.viewDidLoadSubject
      .flatMap { _ in
        AppEnvironment.current
          .apiService
          .fetchGraphUserEmailCombine()
      }
      .compactMap { envelope in
        envelope.me.email
      }
      .catch { _ in
        CurrentValueSubject("")
      }
      .assign(to: &self.$retrievedEmail)

    /// Submits report on saveTriggered
    self.saveTriggeredSubject
      .compactMap { [weak self] _ in
        self?.createFlaggingInput()
          .handleFailureAndAllowRetry { _ in
            self?.bannerMessage = MessageBannerViewViewModel(MessageBannerConfiguration(
              type: .error,
              message: Strings.Something_went_wrong_please_try_again()
            ))
            self?.saveButtonEnabled = true
            self?.saveButtonLoading = false
          }
      }
      .flatMap { $0 }
      .sink(receiveValue: { [weak self] _ in
        // Submitted successfully

        self?.saveButtonEnabled = false
        self?.saveButtonLoading = false

        self?.bannerMessage = MessageBannerViewViewModel(MessageBannerConfiguration(
          type: .success,
          message: Strings.Your_message_has_been_sent()
        ))
        self?.submitSuccess = true

      })
      .store(in: &self.cancellables)
  }

  private func createFlaggingInput() -> AnyPublisher<EmptyResponseEnvelope, ErrorEnvelope> {
    let input = CreateFlaggingInput(
      contentId: projectID!,
      kind: projectFlaggingKind!,
      details: detailsText,
      clientMutationId: nil
    )

    return AppEnvironment
      .current
      .apiService
      .createFlaggingInputCombine(input: input)
  }

  /// Triggers loading the reporter's account email on appearance.
  public func viewDidLoad() {
    self.viewDidLoadSubject.send(true)
  }

  /// Submits the project report mutation using the current details text.
  public func didTapSave() {
    self.saveTriggeredSubject.send(())
  }

  /// Returns `self` as `ReportProjectFormViewModelInputs`.
  public var inputs: ReportProjectFormViewModelInputs {
    return self
  }

  /// Returns `self` as `ReportProjectFormViewModelOutputs`.
  public var outputs: ReportProjectFormViewModelOutputs {
    return self
  }
}
