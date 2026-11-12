import Foundation

/// Parsed HTML block text element containing inline `TextComponent` runs.
///
/// Negative Constraint: Do not flatten into plain unstyled text when links or inline bold/italic attributes must remain interactive.
public struct TextViewElement: HTMLViewElement {
  /// Ordered inline styled text spans comprising this paragraph or heading block.
  public let components: [TextComponent]
}
