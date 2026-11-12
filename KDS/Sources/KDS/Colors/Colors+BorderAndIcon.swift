import UIKit

extension Colors {
  /// Semantic hairline and focus border stroke colors.
  public struct Border {
    /// Active input or selected control border color.
    public static let active = SemanticColor(
      "border/active",
      lightMode: .gray_700,
      darkMode: .gray_100
    )

    /// High-emphasis divider and container border color.
    public static let bold = SemanticColor(
      "border/bold",
      lightMode: .gray_400,
      darkMode: .gray_550
    )

    /// Disabled control border color.
    public static let disabled = SemanticColor(
      "border/disabled",
      lightMode: .gray_200,
      darkMode: .gray_800
    )

    /// Keyboard/accessibility focus ring border color.
    public static let focus = SemanticColor(
      "border/focus",
      lightMode: .blue_05,
      darkMode: .blue_05
    )

    /// Inverse surface border color.
    public static let inverse = SemanticColor(
      "border/inverse",
      lightMode: .white,
      darkMode: .gray_1000
    )

    /// Subtle divider and card outline color.
    public static let subtle = SemanticColor(
      "border/subtle",
      lightMode: .gray_300,
      darkMode: .gray_700
    )

    /// Accent border strokes for callouts and badges.
    public struct Accent {
      /// Blue accent border tokens.
      public struct Blue {
        /// High-contrast blue border stroke.
        public static let bold = SemanticColor(
          "border/accent/blue/bold",
          lightMode: .blue_08,
          darkMode: .blue_03
        )

        /// Subtle blue border stroke.
        public static let subtle = SemanticColor(
          "border/accent/blue/subtle",
          lightMode: .blue_04,
          darkMode: .blue_06
        )
      }

      /// Green accent border tokens.
      public struct Green {
        /// High-contrast green border stroke.
        public static let bold = SemanticColor(
          "border/accent/green/bold",
          lightMode: .green_08,
          darkMode: .green_03
        )

        /// Subtle green border stroke.
        public static let subtle = SemanticColor(
          "border/accent/green/subtle",
          lightMode: .green_04,
          darkMode: .green_06
        )
      }
    }

    /// Destructive validation border tokens.
    public struct Danger {
      /// High-contrast red border for invalid inputs or error alerts.
      public static let bold = SemanticColor(
        "border/danger/bold",
        lightMode: .red_800,
        darkMode: .red_300
      )

      /// Subtle red border stroke.
      public static let subtle = SemanticColor(
        "border/danger/subtle",
        lightMode: .red_400,
        darkMode: .red_600
      )
    }

    /// Caution/warning border tokens.
    public struct Warning {
      /// High-contrast yellow border stroke.
      public static let bold = SemanticColor(
        "border/warning/bold",
        lightMode: .yellow_08,
        darkMode: .yellow_03
      )

      /// Subtle yellow border stroke.
      public static let subtle = SemanticColor(
        "border/warning/subtle",
        lightMode: .yellow_04,
        darkMode: .yellow_06
      )
    }
  }

  /// Semantic iconography tint colors.
  public struct Icon {
    /// Destructive/error icon tint color.
    public static let danger = SemanticColor(
      "icon/danger",
      lightMode: .red_700,
      darkMode: .red_400
    )

    /// Disabled icon tint color.
    public static let disabled = SemanticColor(
      "icon/disabled",
      lightMode: .gray_500,
      darkMode: .gray_600
    )

    /// Success/verified green icon tint color.
    public static let green = SemanticColor(
      "icon/green",
      lightMode: .green_07,
      darkMode: .green_03
    )

    /// Informational blue icon tint color.
    public static let info = SemanticColor(
      "icon/info",
      lightMode: .blue_07,
      darkMode: .blue_03
    )

    /// Inverse surface icon tint color.
    public static let inverse = SemanticColor(
      "icon/inverse",
      lightMode: .gray_300,
      darkMode: .gray_800
    )

    /// Pressed state icon tint color.
    public static let pressed = SemanticColor(
      "icon/pressed",
      lightMode: .gray_550,
      darkMode: .gray_500
    )

    /// Primary icon tint color matching body text contrast.
    public static let primary = SemanticColor(
      "icon/primary",
      lightMode: .gray_800,
      darkMode: .gray_200
    )

    /// Subtle/secondary icon tint color.
    public static let subtle = SemanticColor(
      "icon/subtle",
      lightMode: .gray_600,
      darkMode: .gray_500
    )

    /// Warning/caution icon tint color.
    public static let warning = SemanticColor(
      "icon/warning",
      lightMode: .yellow_07,
      darkMode: .yellow_03
    )

    /// Inverted danger icon tokens.
    public struct Danger {
      /// Danger icon tint placed on inverse dark surfaces.
      public static let inverse = SemanticColor(
        "icon/danger/inverse",
        lightMode: .red_200,
        darkMode: .red_800
      )
    }

    /// Inverted green icon tokens.
    public struct Green {
      /// Green icon tint placed on inverse dark surfaces.
      public static let inverse = SemanticColor(
        "icon/green/inverse",
        lightMode: .green_02,
        darkMode: .green_08
      )
    }

    /// FPO:  temporary semantic color for the new floating tab bar while we wait for the new Color Palette to be finalized
    public static let dark = SemanticColor(
      "icon/dark",
      lightMode: .black,
      darkMode: .black
    )

    /// FPO:  temporary semantic color for the new floating tab bar while we wait for the new Color Palette to be finalized
    public static let light = SemanticColor(
      "icon/light",
      lightMode: .white,
      darkMode: .white
    )

    /// FPO:  temporary semantic color for the new floating tab bar while we wait for the new Color Palette to be finalized
    public static let `default` = SemanticColor(
      "icon/default",
      lightMode: .black,
      darkMode: .white
    )

    /// FPO:  temporary semantic colors for the new floating tab bar while we wait for the new Color Palette to be finalized
    public static let highlight = SemanticColor(
      "icon/highlight",
      lightMode: .green_04,
      darkMode: .green_04
    )
  }
}

