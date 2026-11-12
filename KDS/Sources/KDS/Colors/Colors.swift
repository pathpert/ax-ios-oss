import UIKit

/// Canonical KDS semantic color namespace adapting automatically between Light and Dark Mode.
///
/// - Negative constraint: Do not reference raw palette shades (`LegacyColors`) or hardcoded hex literals in new UI code.
public struct Colors {
  /// Semi-transparent backdrop scrim (`black` at 32% light / 50% dark opacity) behind modals and sheets.
  public static let scrim = SemanticColor(
    "scrim",
    lightMode: .black,
    lightModeAlpha: 0.32,
    darkMode: .black,
    darkModeAlpha: 0.5
  )

  /// Semantic typography and label foreground colors.
  public struct Text {
    /// Primary body and headline text color (`gray_1000` light / `gray_100` dark).
    public static let primary = SemanticColor(
      "text/primary",
      lightMode: .gray_1000,
      darkMode: .gray_100
    )

    /// Secondary supporting text and caption color (`gray_700` light / `gray_400` dark).
    public static let secondary = SemanticColor(
      "text/secondary",
      lightMode: .gray_700,
      darkMode: .gray_400
    )

    /// Foreground color for disabled text labels.
    public static let disabled = SemanticColor(
      "text/disabled",
      lightMode: .gray_500,
      darkMode: .gray_600
    )

    /// Input placeholder text color (`gray_600` light / `gray_500` dark).
    public static let placeholder = SemanticColor(
      "text/placeholder",
      lightMode: .gray_600,
      darkMode: .gray_500
    )

    /// High-contrast dark text locked across both Light and Dark Mode for light-background surfaces.
    public static let constantPrimary = SemanticColor(
      "text/primary",
      lightMode: .gray_1000,
      darkMode: .gray_1000
    )

    /// Constant white text color across both Light and Dark Mode for dark/brand-filled surfaces.
    public static let light = SemanticColor(
      "text/light",
      lightMode: .white,
      darkMode: .white
    )

    /// Accent text colors for badges, status pills, and inline highlights.
    public struct Accent {
      /// Neutral accent text color.
      public static let gray = SemanticColor(
        "text/accent/gray",
        lightMode: .gray_1000,
        darkMode: .gray_200
      )

      /// Positive/funded accent text color.
      public static let green = SemanticColor(
        "text/accent/green",
        lightMode: .green_06,
        darkMode: .green_05
      )

      /// Error/destructive accent text color.
      public static let red = SemanticColor(
        "text/accent/red",
        lightMode: .red_600,
        darkMode: .red_500
      )

      /// High-contrast blue accent text variants.
      public struct Blue {
        /// High-contrast blue accent text for informational badges.
        public static let bolder = SemanticColor(
          "text/accent/blue/bolder",
          lightMode: .blue_08,
          darkMode: .blue_02
        )
      }

      /// High-contrast green accent text variants.
      public struct Green {
        /// High-contrast green accent text for funded/success badges.
        public static let bolder = SemanticColor(
          "text/accent/green/bolder",
          lightMode: .green_08,
          darkMode: .green_02
        )
      }

      /// High-contrast purple accent text variants.
      public struct Purple {
        /// High-contrast purple accent text for promotional/pledge-manager badges.
        public static let bolder = SemanticColor(
          "text/accent/purple/bolder",
          lightMode: .purple_08,
          darkMode: .purple_02
        )
      }

      /// High-contrast and inverse red accent text variants.
      public struct Red {
        /// Disabled destructive text color.
        public static let disabled = SemanticColor(
          "text/accent/red/disabled",
          lightMode: .red_400,
          darkMode: .red_700
        )

        /// High-contrast red accent text for error banners.
        public static let bolder = SemanticColor(
          "text/accent/red/bolder",
          lightMode: .red_800,
          darkMode: .red_200
        )

        /// Inverse red text tokens for dark/inverted containers.
        public struct Inverse {
          /// Disabled red text on inverse surfaces.
          public static let disabled = SemanticColor(
            "text/accent/red/disabled/inverse",
            lightMode: .red_200,
            darkMode: .red_800
          )
        }
      }

      /// High-contrast yellow accent text variants.
      public struct Yellow {
        /// High-contrast warning accent text color.
        public static let bolder = SemanticColor(
          "text/accent/yellow/bolder",
          lightMode: .yellow_08,
          darkMode: .yellow_02
        )
      }
    }

    /// Inverted foreground text colors placed on `Background.Surface.inverse`.
    public struct Inverse {
      /// Primary text color on inverse surfaces.
      public static let primary = SemanticColor(
        "text/inverse/primary",
        lightMode: .white,
        darkMode: .gray_1000
      )

      /// Disabled text color on inverse surfaces.
      public static let disabled = SemanticColor(
        "text/inverse/disabled",
        lightMode: .gray_200,
        darkMode: .gray_900
      )
    }

    /// Interactive action text colors.
    public struct Action {
      /// Disabled action button text color.
      public static let disabled = SemanticColor(
        "text/action/disabled",
        lightMode: .gray_500,
        darkMode: .gray_900
      )
    }
  }

  /// Kickstarter brand identity colors.
  public struct Brand {
    /// Kickstarter brand green. Inverts to the same brand color in dark mode.
    public static let logo = SemanticColor(
      "brand/logo",
      lightMode: .green_05,
      darkMode: .green_05
    )
  }

  /// FPO:  temporary semantic colors for the new floating tab bar while we wait for the new Color Palette to be finalized
  public struct Elevation {
    /// Elevated surface token namespace.
    public struct Surface {
      /// Temporary raised elevation surface background.
      public static let raised = SemanticColor(
        "elevation/surface/raised",
        lightMode: .white,
        darkMode: .gray_900
      )
    }
  }

  /// FPO:  temporary semantic color for the new floating tab bar while we wait for the new Color Palette to be finalized
  public struct Surface {
    /// Highlighted surface tint for active tab bar selection.
    public static let highlight = SemanticColor(
      "surface/highlight",
      lightMode: .green_04,
      darkMode: .green_04
    )
  }
}
