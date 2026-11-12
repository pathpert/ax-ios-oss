import KDS
import UIKit

/// Badge pill model displayed on a discovery project card (e.g., Projects We Love, category).
public struct DiscoveryPillData: Equatable {
  /// Asset catalog icon name rendered beside the pill title.
  public let imageName: String
  /// Localized pill text.
  public let text: String
  /// Color theme style applied to the pill.
  public let type: DiscoveryProjectTagPillCellType
}

/// Visual color styles supported by `DiscoveryProjectTagPillCell`.
public enum DiscoveryProjectTagPillCellType: Equatable {
  /// Highlighted green badge style (e.g., Projects We Love).
  case green
  /// Neutral grey badge style (e.g., category tags).
  case grey

  /// Pill background color for the visual style.
  public var backgroundColor: UIColor {
    switch self {
    case .green: return LegacyColors.ksr_create_700.uiColor(opacity: 0.07)
    case .grey: return LegacyColors.ksr_support_300.uiColor()
    }
  }

  /// Foreground text color for the visual style.
  public var textColor: UIColor {
    switch self {
    case .green: return LegacyColors.ksr_create_700.uiColor()
    case .grey: return LegacyColors.ksr_support_400.uiColor()
    }
  }
}

/// Attributed label styling contract specifying which substring should be bolded within a full string.
public struct BoldedAttributedLabelData: Equatable {
  /// Substring rendered in bold weight inside `inString`.
  public let boldedString: String
  /// Complete localized string containing `boldedString`.
  public let inString: String

  /// Creates a `BoldedAttributedLabelData` payload.
  public init(boldedString: String, inString: String) {
    self.boldedString = boldedString
    self.inString = inString
  }
}

/// Social friend facepile summary rendered on a discovery project card.
public struct FacepileViewData: Equatable {
  /// Avatar image URLs for up to three backing friends.
  public let avatars: [URL]
  /// Localized summary describing how many friends back the project.
  public let description: String

  /// Creates a `FacepileViewData` payload.
  public init(avatars: [URL], description: String) {
    self.avatars = avatars
    self.description = description
  }
}

