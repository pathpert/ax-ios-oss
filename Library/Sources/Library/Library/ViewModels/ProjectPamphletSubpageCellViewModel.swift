import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `ProjectPamphletSubpageCellViewModel`.
public protocol ProjectPamphletSubpageCellViewModelInputs {
  /// Call with the ProjectPamphletSubpage
  func configureWith(subpage: ProjectPamphletSubpage)
}

/// Outputs exposed by `ProjectPamphletSubpageCellViewModel`.
public protocol ProjectPamphletSubpageCellViewModelOutputs {
  /// Emits the background color for the count label
  var countLabelBackgroundColor: Signal<UIColor, Never> { get }

  /// Emits the border color for the count label
  var countLabelBorderColor: Signal<UIColor, Never> { get }

  /// Emits the count label's text
  var countLabelText: Signal<String, Never> { get }

  /// Emits the count label's text color
  var countLabelTextColor: Signal<UIColor, Never> { get }

  /// Emits the cell's primary label text
  var labelText: Signal<String, Never> { get }

  /// Emits the cell's primary label text color
  var labelTextColor: Signal<UIColor, Never> { get }

  /// Emits when the top gradient view should be hidden
  var topSeparatorViewHidden: Signal<Bool, Never> { get }

  /// Emits when the separator view should be hidden
  var separatorViewHidden: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs interface for `ProjectPamphletSubpageCellViewModel`.
public protocol ProjectPamphletSubpageCellViewModelType {
  /// The view model's inputs.
  var inputs: ProjectPamphletSubpageCellViewModelInputs { get }
  /// The view model's outputs.
  var outputs: ProjectPamphletSubpageCellViewModelOutputs { get }
}

/// View model for a project pamphlet subpage navigation row (comments, updates, or report project).
public final class ProjectPamphletSubpageCellViewModel: ProjectPamphletSubpageCellViewModelType,
  ProjectPamphletSubpageCellViewModelInputs, ProjectPamphletSubpageCellViewModelOutputs {
  /// Creates a new subpage cell view model.
  public init() {
    let commentsSubpage = self.subpageProperty.signal.skipNil().filter { $0.isComments }
    let updatesSubpage = self.subpageProperty.signal.skipNil().filter { $0.isUpdates }

    self.labelText = Signal.merge(
      commentsSubpage.mapConst(Strings.project_menu_buttons_comments()),
      updatesSubpage.mapConst(Strings.project_menu_buttons_updates())
    )

    self.labelTextColor = Signal.merge(
      commentsSubpage.mapConst(LegacyColors.ksr_support_700.uiColor()),
      updatesSubpage.mapConst(LegacyColors.ksr_support_700.uiColor())
    )

    self.topSeparatorViewHidden = self.subpageProperty.signal.skipNil()
      .map { $0.position != .first }

    self.separatorViewHidden = self.subpageProperty.signal.skipNil()
      .map { $0.position == .last }

    self.countLabelText = Signal.merge(commentsSubpage, updatesSubpage)
      .map { Format.wholeNumber($0.count ?? 0) }

    self.countLabelTextColor = Signal.merge(commentsSubpage, updatesSubpage)
      .mapConst(LegacyColors.ksr_support_700.uiColor())
    self.countLabelBorderColor = Signal.merge(commentsSubpage, updatesSubpage)
      .mapConst(.clear)
    self.countLabelBackgroundColor = Signal.merge(commentsSubpage, updatesSubpage)
      .mapConst(LegacyColors.ksr_support_100.uiColor())
  }

  private let subpageProperty = MutableProperty<ProjectPamphletSubpage?>(nil)
  /// Configures the cell with the given subpage metadata.
  public func configureWith(subpage: ProjectPamphletSubpage) {
    self.subpageProperty.value = subpage
  }

  /// Emits the formatted count badge text.
  public let countLabelText: Signal<String, Never>
  /// Emits the count badge text color.
  public let countLabelTextColor: Signal<UIColor, Never>
  /// Emits the count badge border color.
  public let countLabelBorderColor: Signal<UIColor, Never>
  /// Emits the count badge background color.
  public let countLabelBackgroundColor: Signal<UIColor, Never>
  /// Emits the primary subpage title text.
  public let labelText: Signal<String, Never>
  /// Emits the primary label text color.
  public let labelTextColor: Signal<UIColor, Never>
  /// Emits whether the top divider line should be hidden.
  public let topSeparatorViewHidden: Signal<Bool, Never>
  /// Emits whether the bottom divider line should be hidden.
  public let separatorViewHidden: Signal<Bool, Never>

  /// The inputs interface for this view model.
  public var inputs: ProjectPamphletSubpageCellViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: ProjectPamphletSubpageCellViewModelOutputs { return self }
}

/// Position of a subpage row within its grouped table section.
public enum ProjectPamphletSubpageCellPosition {
  /// The first row in the subpage section.
  case first
  /// An interior row in the subpage section.
  case middle
  /// The final row in the subpage section.
  case last
}

extension ProjectPamphletSubpageCellPosition: Equatable {}
/// Compares two `ProjectPamphletSubpageCellPosition` values for equality.
public func == (lhs: ProjectPamphletSubpageCellPosition, rhs: ProjectPamphletSubpageCellPosition) -> Bool {
  switch (lhs, rhs) {
  case (.first, .first), (.middle, .middle), (.last, .last):
    return true
  default:
    return false
  }
}

/// Represents a navigable project pamphlet subpage entry and its layout position.
public enum ProjectPamphletSubpage {
  /// Project comments subpage with optional count and row position.
  case comments(Int?, ProjectPamphletSubpageCellPosition)
  /// Project updates subpage with optional count and row position.
  case updates(Int?, ProjectPamphletSubpageCellPosition)
  /// Report project subpage with row position.
  case reportProject(ProjectPamphletSubpageCellPosition)

  /// Optional item count associated with the subpage, or `nil` when not applicable.
  public var count: Int? {
    switch self {
    case let .comments(count, _): return count
    case let .updates(count, _): return count
    case .reportProject: return nil
    }
  }

  /// Section position of this subpage row.
  public var position: ProjectPamphletSubpageCellPosition {
    switch self {
    case let .comments(_, position): return position
    case let .updates(_, position): return position
    case let .reportProject(position): return position
    }
  }

  /// `true` when this case represents the comments subpage.
  public var isComments: Bool {
    switch self {
    case .comments: return true
    default: return false
    }
  }

  /// `true` when this case represents the updates subpage.
  public var isUpdates: Bool {
    switch self {
    case .updates: return true
    default: return false
    }
  }

  /// `true` when this case represents the report-project subpage.
  public var isReportProject: Bool {
    switch self {
    case .reportProject: return true
    default: return false
    }
  }
}

extension ProjectPamphletSubpage: Equatable {}
/// Compares two `ProjectPamphletSubpage` values for equality.
public func == (lhs: ProjectPamphletSubpage, rhs: ProjectPamphletSubpage) -> Bool {
  switch (lhs, rhs) {
  case let (.comments(lhsCount, lhsPos), .comments(rhsCount, rhsPos)):
    return lhsCount == rhsCount && lhsPos == rhsPos
  case let (.updates(lhsCount, lhsPos), .updates(rhsCount, rhsPos)):
    return lhsCount == rhsCount && lhsPos == rhsPos
  case let (.reportProject(lhsPos), .reportProject(rhsPos)):
    return lhsPos == rhsPos
  default:
    return false
  }
}
