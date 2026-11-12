import UIKit

/// Deprecated legacy color tokens retained only for pre-KDS screens.
///
/// - Negative constraint: Do not use `LegacyColors` in new UI code; prefer semantic tokens in `Colors`.
@available(
  *,
  deprecated,
  message: "If you are using a legacy color, you should replace it with an appropriate semantic color from the new design system."
)
/// Legacy color token namespace bridged from pre-KDS assets.
public struct LegacyColors {
  /// Legacy black ink token inverting to white in dark mode.
  public static let ksr_black = LegacyColor(
    "legacy/ksr_black",
    lightMode: UIColor(coreColor: .black),
    darkMode: UIColor(coreColor: .white)
  )

  /// `ksr_white` functions mostly like surface/primary
  public static let ksr_white = LegacyColor(
    "legacy/ksr_white",
    lightMode: UIColor(coreColor: .white),
    darkMode: UIColor(coreColor: .gray_1000)
  )

  /// Legacy alert red token.
  public static let ksr_alert = LegacyColor(
    "legacy/ksr_alert",
    lightMode: UIColor.hex(0xA12027),
    darkMode: UIColor(coreColor: .red_500)
  )

  /// Legacy celebratory orange (`500` step).
  public static let ksr_celebrate_500 = LegacyColor(
    "legacy/ksr_celebrate_500",
    lightMode: UIColor.hex(0xF97B62),
    darkMode: UIColor(coreColor: .orange_06)
  )

  /// Legacy celebratory orange (`700` step).
  public static let ksr_celebrate_700 = LegacyColor(
    "legacy/ksr_celebrate_700",
    lightMode: UIColor.hex(0xD8503D),
    darkMode: UIColor(coreColor: .orange_03)
  )

  /// Legacy Kickstarter create green (`100` tint).
  public static let ksr_create_100 = LegacyColor(
    "legacy/ksr_create_100",
    lightMode: UIColor.hex(0xE6FAF1),
    darkMode: UIColor(coreColor: .green_09)
  )

  /// Legacy Kickstarter create green (`300` tint).
  public static let ksr_create_300 = LegacyColor(
    "legacy/ksr_create_300",
    lightMode: UIColor.hex(0x9BEBC9),
    darkMode: UIColor(coreColor: .green_07)
  )

  /// Legacy Kickstarter create green (`500` base).
  public static let ksr_create_500 = LegacyColor(
    "legacy/ksr_create_500",
    lightMode: UIColor(coreColor: .green_05),
    darkMode: UIColor(coreColor: .green_06)
  )

  /// Legacy Kickstarter create green (`700` shade).
  public static let ksr_create_700 = LegacyColor(
    "legacy/ksr_create_700",
    lightMode: UIColor.hex(0x028858),
    darkMode: UIColor(coreColor: .green_05)
  )

  /// Legacy background tokens.
  public struct Background {
    /// Legacy primary CTA background tokens.
    public struct Action {
      /// Most of the buttons in our app used `create_700` as their background color. This has a light mode color equal to `create_700` but the inverted dark mode color of `background/action/primary`. Eventually this can be replaced with `background/action/primary`.
      public static let primary = LegacyColor(
        "legacy/background/action/primary",
        lightMode: UIColor.hex(0x028858),
        darkMode: UIColor(coreColor: .white)
      )

      /// Legacy interactive states for `Background.Action.primary`.
      public struct Primary {
        /// Pressed fill for legacy primary action button.
        public static let pressed = LegacyColor(
          "legacy/background/action/primary/pressed",
          lightMode: UIColor.hex(0x015738),
          darkMode: UIColor(coreColor: .gray_300)
        )

        /// Disabled fill for legacy primary action button.
        public static let disabled = LegacyColor(
          "legacy/background/action/primary/disabled",
          lightMode: UIColor.hex(0x5DB294),
          darkMode: UIColor(coreColor: .gray_600)
        )
      }
    }

    /// Legacy search bar background color.
    public static let search = LegacyColor(
      "legacy/background/search",
      lightMode: UIColor.hex(0xF3F3F3),
      darkMode: UIColor.hex(0x2C2C2C)
    )
  }

  /// Legacy badge color tokens.
  public struct Badge {
    /// Legacy notification badge color tokens.
    public struct Notification {
      /// Unread notification badge background fill.
      public static let background = LegacyColor(
        "legacy/badge/notification/background",
        lightMode: UIColor.hex(0xFF3B30),
        darkMode: UIColor.hex(0xFF3B30)
      )
    }
  }

  /// Legacy Facebook-branded button color tokens.
  public struct Facebook {
    /// Primary Facebook blue button fill.
    public static let primary = LegacyColor(
      "legacy/facebook/primary",
      lightMode: UIColor.hex(0x1877F2),
      darkMode: UIColor(coreColor: .white)
    )

    /// Pressed Facebook button fill.
    public static let pressed = LegacyColor(
      "legacy/facebook/pressed",
      lightMode: UIColor.hex(0x1877F2).mixDarker(0.36),
      darkMode: UIColor(coreColor: .gray_300)
    )

    /// Disabled Facebook button fill.
    public static let disabled = LegacyColor(
      "legacy/facebook/disabled",
      lightMode: UIColor.hex(0x1877F2).mixLighter(0.36),
      darkMode: UIColor(coreColor: .gray_600)
    )
  }

  /// `support_100` functions mostly like surface/secondary
  public static let ksr_support_100 = LegacyColor(
    "legacy/ksr_support_100",
    lightMode: UIColor.hex(0xF3F3F3),
    darkMode: UIColor(coreColor: .black)
  )

  /// Legacy neutral gray (`200` step).
  public static let ksr_support_200 = LegacyColor(
    "legacy/ksr_support_200",
    lightMode: UIColor.hex(0xE6E6E6),
    darkMode: UIColor(coreColor: .gray_800)
  )

  /// Legacy neutral gray (`300` step).
  public static let ksr_support_300 = LegacyColor(
    "legacy/ksr_support_300",
    lightMode: UIColor.hex(0xD1D1D1),
    darkMode: UIColor(coreColor: .gray_700)
  )

  /// Legacy neutral gray (`400` step).
  public static let ksr_support_400 = LegacyColor(
    "legacy/ksr_support_400",
    lightMode: UIColor.hex(0x696969),
    darkMode: UIColor.hex(0xA1A1A1)
  )

  /// Legacy neutral gray (`500` step).
  public static let ksr_support_500 = LegacyColor(
    "legacy/ksr_support_500",
    lightMode: UIColor.hex(0x464646),
    darkMode: UIColor(coreColor: .gray_550)
  )

  /// Legacy neutral gray (`700` step).
  public static let ksr_support_700 = LegacyColor(
    "legacy/ksr_support_700",
    lightMode: UIColor.hex(0x222222),
    darkMode: UIColor(coreColor: .gray_300)
  )

  /// Legacy trust-blue (`100` tint).
  public static let ksr_trust_100 = LegacyColor(
    "legacy/ksr_trust_100",
    lightMode: UIColor.hex(0xDBE7FF),
    darkMode: UIColor(coreColor: .blue_09)
  )

  /// Legacy trust-blue (`500` base).
  public static let ksr_trust_500 = LegacyColor(
    "legacy/ksr_trust_500",
    lightMode: UIColor.hex(0x5555FF),
    darkMode: UIColor.hex(0x7271FF)
  )

  /// Legacy trust-blue (`700` shade).
  public static let ksr_trust_700 = LegacyColor(
    "legacy/ksr_trust_700",
    lightMode: UIColor.hex(0x0A007D),
    darkMode: UIColor(coreColor: .blue_03)
  )

  /// Legacy table/list separator line color.
  public static let ksr_cell_separator = LegacyColor(
    "legacy/ksr_cell_separator",
    lightMode: UIColor.hex(0xDCDEDD),
    darkMode: UIColor(coreColor: .gray_800)
  )

  /// Legacy status tag tokens.
  public struct Tags {
    /// Legacy success tag tokens.
    public struct Success {
      /// Legacy success tag background fill.
      public static let background = LegacyColor(
        "legacy/tags/success/background",
        lightMode: UIColor.hex(0xEFF8F5),
        darkMode: UIColor(coreColor: .green_02)
      )

      /// Legacy success tag foreground text color.
      public static let foreground = LegacyColor(
        "legacy/tags/success/foreground",
        lightMode: UIColor.hex(0x028858),
        darkMode: UIColor(coreColor: .black)
      )
    }

    /// Legacy warning tag tokens.
    public struct Warn {
      /// Legacy warning tag background fill.
      public static let background = LegacyColor(
        "legacy/tags/warn/background",
        lightMode: UIColor.hex(0xFFF2EC),
        darkMode: UIColor.hex(0xFFF2EC)
      )

      /// Legacy warning tag foreground text color.
      public static let foreground = LegacyColor(
        "legacy/tags/warn/foreground",
        lightMode: UIColor.hex(0x696969),
        darkMode: UIColor(coreColor: .black)
      )
    }
  }

  /// Legacy project screen navigation tokens.
  public struct Project {
    /// Legacy project tab navigation tokens.
    public struct Navigation {
      /// Selected navigation segment tint color.
      public static let selected = LegacyColor(
        "legacy/project/navigation/selected",
        lightMode: UIColor.hex(0x5555FF),
        darkMode: UIColor(coreColor: .white)
      )
    }
  }

  /// Legacy standalone button fill tokens.
  public struct Buttons {
    /// Legacy blue standalone button fill.
    public static let blue = LegacyColor(
      "legacy/buttons/blue",
      lightMode: UIColor.hex(0x5555FF),
      darkMode: UIColor(coreColor: .white)
    )
  }
}
