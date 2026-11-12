import UIKit

extension Colors {
  /// Semantic background fills for containers, buttons, badges, and surfaces.
  public struct Background {
    /// Default dark/inverse fill for standard action controls.
    public static let action = SemanticColor(
      "background/action",
      lightMode: .gray_1000,
      darkMode: .gray_100
    )

    /// Standard fill for disabled controls and inactive containers.
    public static let disabled = SemanticColor(
      "background/disabled",
      lightMode: .gray_400,
      darkMode: .gray_700
    )

    /// Selected control fill color.
    public static let selected = SemanticColor(
      "background/selected",
      lightMode: .gray_900,
      darkMode: .gray_200
    )

    /// Accent background fills for status banners, tags, and informational cards.
    public struct Accent {
      /// Blue informational accent background tokens.
      public struct Blue {
        /// Disabled state fill for blue accent elements.
        public static let disabled = SemanticColor(
          "background/accent/blue/disabled",
          lightMode: .blue_01,
          darkMode: .blue_10
        )

        /// Subtle blue background tint for info callouts.
        public static let subtle = SemanticColor(
          "background/accent/blue/subtle",
          lightMode: .blue_02,
          darkMode: .blue_09
        )
      }

      /// Neutral gray accent background tokens.
      public struct Gray {
        /// High-emphasis gray accent fill.
        public static let bold = SemanticColor(
          "background/accent/gray/bold",
          lightMode: .gray_600,
          darkMode: .gray_500
        )

        /// Disabled gray accent fill.
        public static let disabled = SemanticColor(
          "background/accent/gray/disabled",
          lightMode: .gray_100,
          darkMode: .gray_850
        )

        /// Subtle neutral background for chips and callout boxes.
        public static let subtle = SemanticColor(
          "background/accent/gray/subtle",
          lightMode: .gray_200,
          darkMode: .gray_800
        )

        /// Translucent frosted gray background (25% opacity).
        public static let frosted = SemanticColor(
          "background/accent/gray/frosted",
          lightMode: .gray_550,
          lightModeAlpha: 0.25,
          darkMode: .gray_550,
          darkModeAlpha: 0.25
        )
      }

      /// Green success/funded accent background tokens.
      public struct Green {
        /// Bold Kickstarter green accent fill.
        public static let bold = SemanticColor(
          "background/accent/green/bold",
          lightMode: .green_06,
          darkMode: .green_05
        )

        /// Disabled green accent fill.
        public static let disabled = SemanticColor(
          "background/accent/green/disabled",
          lightMode: .green_01,
          darkMode: .green_09
        )

        /// Subtle green fill for funded badges and banners.
        public static let subtle = SemanticColor(
          "background/accent/green/subtle",
          lightMode: .green_02,
          darkMode: .green_08
        )

        /// Interactive states for bold green backgrounds.
        public struct Bold {
          /// Pressed state fill for bold green controls.
          public static let pressed = SemanticColor(
            "background/accent/green/bold/pressed",
            lightMode: .green_08,
            darkMode: .green_03
          )
        }
      }

      /// Purple accent background tokens.
      public struct Purple {
        /// Disabled purple accent fill.
        public static let disabled = SemanticColor(
          "background/accent/purple/disabled",
          lightMode: .purple_01,
          darkMode: .purple_09
        )

        /// Subtle purple fill for feature highlights.
        public static let subtle = SemanticColor(
          "background/accent/purple/subtle",
          lightMode: .purple_02,
          darkMode: .purple_08
        )

        /// Constant purple banner fill for late-pledge / pledge-manager messaging.
        public static let banner = SemanticColor(
          "background/accent/purple/banner",
          lightMode: .purple_03,
          darkMode: .purple_03
        )
      }

      /// Red alert/destructive accent background tokens.
      public struct Red {
        /// Disabled red accent fill.
        public static let disabled = SemanticColor(
          "background/accent/red/disabled",
          lightMode: .red_100,
          darkMode: .red_1000
        )

        /// Subtle red background tint for inline validation errors.
        public static let subtle = SemanticColor(
          "background/accent/red/subtle",
          lightMode: .red_200,
          darkMode: .red_900
        )
      }
    }

    /// Background fills for primary and secondary interactive buttons.
    public struct Action {
      /// Disabled button fill color.
      public static let disabled = SemanticColor(
        "background/action/disabled",
        lightMode: .gray_500,
        darkMode: .gray_600
      )

      /// Translucent (90% opacity) background for buttons floating over media.
      public static let overlaidButton = SemanticColor(
        "background/action/overlaidButton",
        lightMode: .white,
        lightModeAlpha: 0.9,
        darkMode: .gray_900,
        darkModeAlpha: 0.9
      )

      /// Pressed state background for standard action buttons.
      public static let pressed = SemanticColor(
        "background/action/pressed",
        lightMode: .gray_800,
        darkMode: .gray_300
      )

      /// Primary CTA background fill (`green_06` light / `white` dark).
      public static let primary = SemanticColor(
        "background/action/primary",
        lightMode: .green_06,
        darkMode: .white
      )

      /// Interactive states for overlaid media buttons.
      public struct OverlaidButton {
        /// Pressed fill for floating media buttons.
        public static let pressed = SemanticColor(
          "background/action/overlaidButton/pressed",
          lightMode: .gray_300,
          lightModeAlpha: 0.9,
          darkMode: .gray_800,
          darkModeAlpha: 0.9
        )
      }

      /// Interactive states for primary CTA buttons.
      public struct Primary {
        /// Pressed fill for primary CTA buttons.
        public static let pressed = SemanticColor(
          "background/action/primary/pressed",
          lightMode: .green_08,
          darkMode: .gray_300
        )

        /// Disabled fill for primary CTA buttons.
        public static let disabled = SemanticColor(
          "background/action/primary/disabled",
          lightMode: .green_01,
          darkMode: .gray_600
        )
      }
    }
  }
}

