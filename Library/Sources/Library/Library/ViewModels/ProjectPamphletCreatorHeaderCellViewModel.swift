import Foundation
import KDS
import KsApi
import ReactiveSwift
import UIKit

/// Input contract for `ProjectPamphletCreatorHeaderCellViewModel`.
public protocol ProjectPamphletCreatorHeaderCellViewModelInputs {
  /// Configures the creator header with the displayed `Project`.
  func configure(with project: Project)
}

/// Output contract for `ProjectPamphletCreatorHeaderCellViewModel`.
public protocol ProjectPamphletCreatorHeaderCellViewModelOutputs {
  /// Emits formatted attributed launch-date copy for the creator banner.
  var launchDateLabelAttributedText: Signal<NSAttributedString, Never> { get }
}

/// Combined inputs/outputs contract for `ProjectPamphletCreatorHeaderCellViewModel`.
public protocol ProjectPamphletCreatorHeaderCellViewModelType {
  /// Input receiver.
  var inputs: ProjectPamphletCreatorHeaderCellViewModelInputs { get }
  /// Signal outputs.
  var outputs: ProjectPamphletCreatorHeaderCellViewModelOutputs { get }
}

/// View model formatting launch-date attribution copy in the creator project pamphlet header cell.
public final class ProjectPamphletCreatorHeaderCellViewModel: ProjectPamphletCreatorHeaderCellViewModelType,
  ProjectPamphletCreatorHeaderCellViewModelInputs, ProjectPamphletCreatorHeaderCellViewModelOutputs {
  /// Initializes signals formatting the launch date string when configured.
  public init() {
    self.launchDateLabelAttributedText = self.projectSignal
      .map(attributedLaunchDateString(with:))
      .skipNil()
  }

  private let (projectSignal, projectObserver) = Signal<Project, Never>.pipe()
  /// Supplies the `Project` whose launch date is rendered.
  public func configure(with project: Project) {
    self.projectObserver.send(value: project)
  }

  /// Attributed string announcing when the creator launched the project.
  public let launchDateLabelAttributedText: Signal<NSAttributedString, Never>

  /// Concrete input interface.
  public var inputs: ProjectPamphletCreatorHeaderCellViewModelInputs { return self }
  /// Concrete output interface.
  public var outputs: ProjectPamphletCreatorHeaderCellViewModelOutputs { return self }
}

private func attributedLaunchDateString(with project: Project) -> NSAttributedString? {
  var launchDate = ""

  if let date = project.dates.launchedAt {
    launchDate = Format.date(
      secondsInUTC: date,
      dateStyle: .long,
      timeStyle: .none,
      timeZone: UTCTimeZone
    )
  }

  let fullString = Strings.You_launched_this_project_on_launch_date(launch_date: launchDate)

  let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: fullString)
  let fullRange = (fullString as NSString).localizedStandardRange(of: fullString)
  let rangeDate: NSRange = (fullString as NSString).localizedStandardRange(of: launchDate)

  let paragraphStyle = NSMutableParagraphStyle()
  paragraphStyle.alignment = .left

  let regularFontAttribute = [
    NSAttributedString.Key.paragraphStyle: paragraphStyle,
    NSAttributedString.Key.font: UIFont.ksr_subhead(),
    NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_700.uiColor()
  ]
  let boldFontAttribute = [NSAttributedString.Key.font: UIFont.ksr_subhead().bolded]

  attributedString.addAttributes(regularFontAttribute, range: fullRange)
  attributedString.addAttributes(boldFontAttribute, range: rangeDate)
  return attributedString
}
