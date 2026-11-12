import KDS
import SwiftUI

/// SwiftUI container view that renders an array of `RichTextElement` blocks.
public struct RichTextView: View {
  /// Ordered list of rich text block elements to render.
  public var element: [RichTextElement]
  @Environment(\.richTextStyle) var style

  /// Creates a rich text view with the given block elements.
  public init(element: [RichTextElement]) {
    self.element = element
  }

  @ViewBuilder private func unimplemented(_ text: String) -> some View {
    Text("Unimplemented! \(text)")
      .font(.footnote)
      .foregroundStyle(Color.red)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding()
      .backgroundStyle(Color.gray)
  }

  /// SwiftUI body rendering each block element in a `LazyVStack`.
  public var body: some View {
    LazyVStack(spacing: self.style.blockSpacing) {
      ForEach(Array(self.element.enumerated()), id: \.offset) { _, element in
        switch element {
        case let .text(text, header):
          TextBlock(text: text, header: header)
        case let .listItem(text):
          ListItemBlock(text: text)
        case let .audio(audio):
          AudioVideoBlock(content: .audio(audio))
        case let .photo(photo):
          ImageBlock(photo: photo)
        case let .video(video):
          AudioVideoBlock(content: .video(video))
        case let .oembed(oembed):
          OEmbedBlock(oembed: oembed)
        case .listItemOpen, .listItemClose:
          Group {}
        case .unknown:
          EmptyView()
        }
      }
    }
    .padding(.horizontal, self.style.contentHorizontalPadding)
    .padding(.vertical)
  }
}
