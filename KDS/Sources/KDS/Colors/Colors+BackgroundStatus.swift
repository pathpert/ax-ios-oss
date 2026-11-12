import UIKit

extension Colors.Background {
  /// Destructive / danger background fill tokens.
  public struct Danger {
    /// Solid red fill for destructive CTA buttons.
    public static let bold = SemanticColor(
      "background/danger/bold",
      lightMode: .red_600,
      darkMode: .red_500
    )

    /// Disabled destructive button background fill.
    public static let disabled = SemanticColor(
      "background/danger/disabled",
      lightMode: .red_400,
      darkMode: .red_1000
    )

    /// Subtle red fill for destructive warning banners.
    public static let subtle = SemanticColor(
      "background/danger/subtle",
      lightMode: .red_200,
      darkMode: .red_1000
    )

    /// Interactive states for bold danger buttons.
    public struct Bold {
      /// Pressed fill for bold destructive buttons.
      public static let pressed = SemanticColor(
        "background/danger/bold/pressed",
        lightMode: .red_800,
        darkMode: .red_300
      )
    }
  }

  /// Caution / warning background fill tokens.
  public struct Warning {
    /// Disabled warning banner background fill.
    public static let disabled = SemanticColor(
      "background/warning/disabled",
      lightMode: .yellow_01,
      darkMode: .yellow_09
    )

    /// Subtle yellow fill for non-blocking warning callouts.
    public static let subtle = SemanticColor(
      "background/warning/subtle",
      lightMode: .yellow_02,
      darkMode: .yellow_08
    )
  }

  /// Inverse surface control fill tokens.
  public struct Inverse {
    /// Pressed fill for inverse action controls.
    public static let pressed = SemanticColor(
      "background/inverse/pressed",
      lightMode: .gray_300,
      darkMode: .gray_800
    )

    /// Disabled fill for inverse action controls.
    public static let disabled = SemanticColor(
      "background/inverse/disabled",
      lightMode: .gray_200,
      darkMode: .gray_850
    )
  }

  /// Elevation and canvas surface background tokens.
  public struct Surface {
    /// Base canvas background fill (`white` light / `gray_1000` dark).
    public static let primary = SemanticColor(
      "background/surface/primary",
      lightMode: .white,
      darkMode: .gray_1000
    )

    /// Grouped / inset secondary canvas fill (`gray_100` light / `black` dark).
    public static let secondary = SemanticColor(
      "background/surface/secondary",
      lightMode: .gray_100,
      darkMode: .black
    )

    /// High-contrast inverted surface fill (`gray_1000` light / `white` dark).
    public static let inverse = SemanticColor(
      "background/surface/inverse",
      lightMode: .gray_1000,
      darkMode: .white
    )

    /// First-level elevated card surface fill.
    public static let raised = SemanticColor(
      "background/surface/raised",
      lightMode: .white,
      darkMode: .gray_950
    )

    /// Second-level elevated sheet/card surface fill.
    public static let raisedHigher = SemanticColor(
      "background/surface/raisedHigher",
      lightMode: .white,
      darkMode: .gray_900
    )

    /// Modal/popover overlay surface fill.
    public static let overlay = SemanticColor(
      "background/surface/overlay",
      lightMode: .white,
      darkMode: .gray_900
    )
  }
}

