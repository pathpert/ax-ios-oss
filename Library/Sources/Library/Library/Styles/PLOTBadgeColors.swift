import KDS
import UIKit

// This extension contains custom semantic colors for PLOT that are not part of the official Figma design set.
// These colors are all related to KDS badges, but use slightly different colors than the web version.
// Eventually these should be folded into the design system itself, but we need to verify
// the web versus the mobile versions of the badges.

extension Colors {
  /// Pledge Over Time (PLOT) installment badge color tokens.
  public struct PLOT {
    /// Semantic badge background and foreground color pairs for installment states.
    public struct Badge {
      /// Background fill colors for PLOT status badges.
      public struct Background {
        /// Green badge background representing settled or on-track installments.
        public static let green = SemanticColor(
          "plot/badge/background/green",
          lightMode: .green_02,
          darkMode: .green_02
        )

        /// Neutral grey badge background for scheduled installments.
        public static let gray = SemanticColor(
          "plot/badge/background/gray",
          lightMode: .gray_300,
          darkMode: .gray_500
        )

        /// Red danger badge background for failed or overdue installments.
        public static let danger = SemanticColor(
          "plot/badge/background/danger",
          lightMode: .red_200,
          darkMode: .red_300
        )

        /// Yellow warning badge background for pending action installments.
        public static let yellow = SemanticColor(
          "increment/badge/background/yellow",
          lightMode: .yellow_02,
          darkMode: .yellow_03
        )

        /// Blue informational badge background.
        public static let blue = SemanticColor(
          "plot/badge/background/blue",
          lightMode: .blue_03,
          darkMode: .blue_03
        )

        /// Purple accent badge background for refunded/adjusted installments.
        public static let purple = SemanticColor(
          "increment/badge/background/purple",
          lightMode: .purple_03,
          darkMode: .purple_03
        )
      }

      /// Foreground text colors paired with `PLOT.Badge.Background`.
      public struct Text {
        /// Green foreground ink for paid/settled PLOT badges.
        public static let green = SemanticColor(
          "plot/badge/text/green",
          lightMode: .green_06,
          darkMode: .green_07
        )

        /// Dark neutral foreground ink for scheduled PLOT badges.
        public static let gray = SemanticColor(
          "plot/badge/text/gray",
          lightMode: .gray_1000,
          darkMode: .gray_1000
        )

        /// Red foreground ink for failed/overdue PLOT badges.
        public static let danger = SemanticColor(
          "plot/badge/text/danger",
          lightMode: .red_800,
          darkMode: .red_700
        )

        /// Amber/yellow foreground ink for warning PLOT badges.
        public static let yellow = SemanticColor(
          "increment/badge/text/yellow",
          lightMode: .yellow_08,
          darkMode: .yellow_08
        )

        /// Blue foreground ink for informational PLOT badges.
        public static let blue = SemanticColor(
          "increment/badge/text/blue",
          lightMode: .blue_09,
          darkMode: .blue_09
        )

        /// Purple foreground ink for refunded/adjusted PLOT badges.
        public static let purple = SemanticColor(
          "increment/badge/text/purple",
          lightMode: .purple_08,
          darkMode: .purple_08
        )
      }
    }
  }
}
