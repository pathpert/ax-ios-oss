import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Inputs for `ErroredBackingViewViewModel`.
public protocol ErroredBackingViewViewModelInputs {
  /// Configures the view with a project and backing envelope.
  func configure(with value: ProjectAndBackingEnvelope)
  /// Called when the user taps the manage pledge button.
  func manageButtonTapped()
}

/// Outputs for `ErroredBackingViewViewModel`.
public protocol ErroredBackingViewViewModelOutputs {
  /// Emits the formatted final collection date text.
  var finalCollectionDateText: Signal<String, Never> { get }
  /// Emits the project and backing envelope when the manage button is tapped.
  var notifyDelegateManageButtonTapped: Signal<ProjectAndBackingEnvelope, Never> { get }
  /// Emits the project name for display.
  var projectName: Signal<String, Never> { get }
}

/// Type interface for `ErroredBackingViewViewModel`.
public protocol ErroredBackingViewViewModelType {
  /// View model inputs.
  var inputs: ErroredBackingViewViewModelInputs { get }
  /// View model outputs.
  var outputs: ErroredBackingViewViewModelOutputs { get }
}

/// View model for displaying an errored backing banner/card and handling manage actions.
public final class ErroredBackingViewViewModel: ErroredBackingViewViewModelType,
  ErroredBackingViewViewModelInputs, ErroredBackingViewViewModelOutputs {
  /// Initializes the errored backing view model and binds output signals.
  public init() {
    let project = self.configDataSignal.map(\.project)

    self.projectName = project
      .map(\.name)

    let collectionDate = project
      .map(\.dates.finalCollectionDate)
      .skipNil()

    self.finalCollectionDateText = collectionDate
      .map(timeLeftString)

    self.notifyDelegateManageButtonTapped = self.configDataSignal
      .takeWhen(self.manageButtonTappedSignal)
  }

  private let (configDataSignal, configDataObserver) = Signal<ProjectAndBackingEnvelope, Never>.pipe()
  /// Configures the view with a project and backing envelope.
  public func configure(with value: ProjectAndBackingEnvelope) {
    self.configDataObserver.send(value: value)
  }

  private let (manageButtonTappedSignal, manageButtonTappedObserver) = Signal<Void, Never>.pipe()
  /// Called when the user taps the manage pledge button.
  public func manageButtonTapped() {
    self.manageButtonTappedObserver.send(value: ())
  }

  /// Emits the formatted final collection date text.
  public let finalCollectionDateText: Signal<String, Never>
  /// Emits the project and backing envelope when the manage button is tapped.
  public let notifyDelegateManageButtonTapped: Signal<ProjectAndBackingEnvelope, Never>
  /// Emits the project name for display.
  public let projectName: Signal<String, Never>

  /// View model inputs.
  public var inputs: ErroredBackingViewViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ErroredBackingViewViewModelOutputs { return self }
}

private func timeLeftString(finalCollectionDate: TimeInterval) -> String {
  let (time, unit) = timeLeft(
    secondsInUTC: finalCollectionDate
  )
  return Strings.Time_left_left(time_left: time + " " + unit)
}

private func timeLeft(
  secondsInUTC seconds: TimeInterval,
  env: Environment = AppEnvironment.current
)
  -> (time: String, unit: String) {
  let components = env.calendar.dateComponents(
    [.day, .hour],
    from: env.dateType.init().date,
    to: env.dateType.init(timeIntervalSince1970: seconds).date
  )

  let (day, hour) = (
    components.day ?? 0,
    components.hour ?? 0
  )

  let string: String
  if day > 1 {
    string = Strings.dates_time_days(time_count: day)
  } else if day == 1 || hour > 0 {
    let count = day * 24 + hour
    string = Strings.dates_time_hours(time_count: count)
  } else if hour <= 1 {
    let count = 1
    string = Strings.dates_time_hours(time_count: count)
  } else {
    string = ""
  }

  let split = string
    .replacingOccurrences(of: "(\\d+) *", with: "$1 ", options: .regularExpression)
    .components(separatedBy: " ")

  guard split.count >= 1 else { return ("", "") }

  let result = (
    time: split.first ?? "",
    unit: split.suffix(from: 1).joined(separator: " ")
  )

  return result
}
