import Foundation
import GraphAPI

extension RichTextComponentFragment {
  /// Converts a GraphQL rich-text component fragment into normalized `RichTextElement` nodes.
  /// - Negative Constraint: Do not render GraphQL fragments directly in SwiftUI; normalize via this converter first.
  public func asRichTextElements() -> [RichTextElement] {
    (self.items ?? []).map { $0.asRichTextElement }.withNormalizedNestedElements()
  }
}

extension RichTextComponentFragment.Item {
  var asRichTextElement: RichTextElement {
    if let x = asRichText { return x.asRichTextElement }
    if let x = asRichTextHeader { return x.asRichTextElement }
    if let x = asRichTextListItem { return x.asRichTextElement }
    if let x = asRichTextListOpen { return x.asRichTextElement }
    if let x = asRichTextListClose { return x.asRichTextElement }
    if let x = asRichTextPhoto { return x.asRichTextElement }
    if let x = asRichTextAudio { return x.asRichTextElement }
    if let x = asRichTextVideo { return x.asRichTextElement }
    if let x = asRichTextOembed { return x.asRichTextElement }
    assertionFailure("Could not detect a usable rich text element")
    return RichTextElement.unknown
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child {
  var asRichTextElement: RichTextElement {
    if let x = asRichText { return x.asRichTextElement }
    if let x = asRichTextHeader { return x.asRichTextElement }
    if let x = asRichTextListItem { return x.asRichTextElement }
    if let x = asRichTextListOpen { return x.asRichTextElement }
    if let x = asRichTextListClose { return x.asRichTextElement }
    if let x = asRichTextPhoto { return x.asRichTextElement }
    if let x = asRichTextAudio { return x.asRichTextElement }
    if let x = asRichTextVideo { return x.asRichTextElement }
    if let x = asRichTextOembed { return x.asRichTextElement }
    assertionFailure("Could not detect a usable rich text element")
    return RichTextElement.unknown
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child {
  var asRichTextElement: RichTextElement {
    if let x = asRichText { return x.asRichTextElement }
    if let x = asRichTextHeader { return x.asRichTextElement }
    if let x = asRichTextListItem { return x.asRichTextElement }
    if let x = asRichTextListOpen { return x.asRichTextElement }
    if let x = asRichTextListClose { return x.asRichTextElement }
    if let x = asRichTextPhoto { return x.asRichTextElement }
    if let x = asRichTextAudio { return x.asRichTextElement }
    if let x = asRichTextVideo { return x.asRichTextElement }
    if let x = asRichTextOembed { return x.asRichTextElement }
    assertionFailure("Could not detect a usable rich text element")
    return RichTextElement.unknown
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child {
  var asRichTextElement: RichTextElement {
    if let x = asRichText { return x.asRichTextElement }
    if let x = asRichTextHeader { return x.asRichTextElement }
    if let x = asRichTextListItem { return x.asRichTextElement }
    if let x = asRichTextListOpen { return x.asRichTextElement }
    if let x = asRichTextListClose { return x.asRichTextElement }
    if let x = asRichTextPhoto { return x.asRichTextElement }
    if let x = asRichTextAudio { return x.asRichTextElement }
    if let x = asRichTextVideo { return x.asRichTextElement }
    if let x = asRichTextOembed { return x.asRichTextElement }
    assertionFailure("Could not detect a usable rich text element")
    return RichTextElement.unknown
  }
}

extension RichTextComponentFragment.Item.AsRichText {
  var asRichTextElement: RichTextElement {
    let children = (children ?? []).map { $0.asRichTextElement }
    return .text(makeText(text: text, link: link, styles: styles, children: children), nil)
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichText {
  var asRichTextElement: RichTextElement {
    .text(makeText(text: text, link: link, styles: styles, children: []), nil)
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextHeader {
  var asRichTextElement: RichTextElement {
    .text(makeText(text: text, link: link, styles: styles, children: []), .init(styles: styles))
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextListItem {
  var asRichTextElement: RichTextElement {
    .listItem(makeText(text: text, link: link, styles: styles, children: []))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader {
  var asRichTextElement: RichTextElement {
    let children = (children ?? []).map { $0.asRichTextElement }
    return .text(makeText(text: text, link: link, styles: styles, children: children), .init(styles: styles))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichText {
  var asRichTextElement: RichTextElement {
    .text(makeText(text: text, link: link, styles: styles, children: []), nil)
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextHeader {
  var asRichTextElement: RichTextElement {
    .text(makeText(text: text, link: link, styles: styles, children: []), .init(styles: styles))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextListItem {
  var asRichTextElement: RichTextElement {
    .listItem(makeText(text: text, link: link, styles: styles, children: []))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem {
  var asRichTextElement: RichTextElement {
    let children = (children ?? []).map { $0.asRichTextElement }
    return .listItem(makeText(text: text, link: link, styles: styles, children: children))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichText {
  var asRichTextElement: RichTextElement {
    .text(makeText(text: text, link: link, styles: styles, children: []), nil)
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextHeader {
  var asRichTextElement: RichTextElement {
    .text(makeText(text: text, link: link, styles: styles, children: []), .init(styles: styles))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextListItem {
  var asRichTextElement: RichTextElement {
    .listItem(makeText(text: text, link: link, styles: styles, children: []))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListOpen {
  var asRichTextElement: RichTextElement { .listItemOpen }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextListOpen {
  var asRichTextElement: RichTextElement { .listItemOpen }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextListOpen {
  var asRichTextElement: RichTextElement { .listItemOpen }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextListOpen {
  var asRichTextElement: RichTextElement { .listItemOpen }
}

extension RichTextComponentFragment.Item.AsRichTextListClose {
  var asRichTextElement: RichTextElement { .listItemClose }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextListClose {
  var asRichTextElement: RichTextElement { .listItemClose }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextListClose {
  var asRichTextElement: RichTextElement { .listItemClose }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextListClose {
  var asRichTextElement: RichTextElement { .listItemClose }
}
