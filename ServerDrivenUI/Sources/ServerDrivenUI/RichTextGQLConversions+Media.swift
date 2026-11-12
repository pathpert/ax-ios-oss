import Foundation
import GraphAPI

extension RichTextComponentFragment.Item.AsRichTextAudio {
  /// Converts an inline rich-text audio item into a `RichTextElement.audio` block.
  var asRichTextElement: RichTextElement {
    .audio(RichTextElement.Audio(altText: altText, assetID: asset?.id, caption: caption, url: url))
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextAudio {
  var asRichTextElement: RichTextElement {
    .audio(RichTextElement.Audio(altText: altText, assetID: asset?.id, caption: caption, url: url))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextAudio {
  var asRichTextElement: RichTextElement {
    .audio(RichTextElement.Audio(altText: altText, assetID: asset?.id, caption: caption, url: url))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextAudio {
  var asRichTextElement: RichTextElement {
    .audio(RichTextElement.Audio(altText: altText, assetID: asset?.id, caption: caption, url: url))
  }
}

extension RichTextComponentFragment.Item.AsRichTextPhoto {
  var asRichTextElement: RichTextElement {
    .photo(RichTextElement.Photo(
      altText: altText, assetID: asset?.id, caption: caption, url: asset?.url, link: nil
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextPhoto {
  var asRichTextElement: RichTextElement {
    .photo(RichTextElement.Photo(
      altText: altText, assetID: asset?.id, caption: caption, url: asset?.url, link: nil
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextPhoto {
  var asRichTextElement: RichTextElement {
    .photo(RichTextElement.Photo(
      altText: altText, assetID: asset?.id, caption: caption, url: asset?.url, link: nil
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextPhoto {
  var asRichTextElement: RichTextElement {
    .photo(RichTextElement.Photo(
      altText: altText, assetID: asset?.id, caption: caption, url: asset?.url, link: nil
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextVideo {
  var asRichTextElement: RichTextElement {
    .video(RichTextElement.Video(
      altText: altText, assetID: asset?.id, caption: caption, url: url,
      posterURL: asset?.poster, formats: makeVideoFormats(asset?.formats)
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextVideo {
  var asRichTextElement: RichTextElement {
    .video(RichTextElement.Video(
      altText: altText, assetID: asset?.id, caption: caption, url: url,
      posterURL: asset?.poster, formats: makeVideoFormats(asset?.formats)
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextVideo {
  var asRichTextElement: RichTextElement {
    .video(RichTextElement.Video(
      altText: altText, assetID: asset?.id, caption: caption, url: url,
      posterURL: asset?.poster, formats: makeVideoFormats(asset?.formats)
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextVideo {
  var asRichTextElement: RichTextElement {
    .video(RichTextElement.Video(
      altText: altText, assetID: asset?.id, caption: caption, url: url,
      posterURL: asset?.poster, formats: makeVideoFormats(asset?.formats)
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextOembed {
  var asRichTextElement: RichTextElement {
    .oembed(RichTextElement.OEmbed(
      width: width, height: height, version: version, title: title,
      type: type, iframeUrl: iframeUrl, originalUrl: originalUrl
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichText.Child.AsRichTextOembed {
  var asRichTextElement: RichTextElement {
    .oembed(RichTextElement.OEmbed(
      width: width, height: height, version: version, title: title,
      type: type, iframeUrl: iframeUrl, originalUrl: originalUrl
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextHeader.Child.AsRichTextOembed {
  var asRichTextElement: RichTextElement {
    .oembed(RichTextElement.OEmbed(
      width: width, height: height, version: version, title: title,
      type: type, iframeUrl: iframeUrl, originalUrl: originalUrl
    ))
  }
}

extension RichTextComponentFragment.Item.AsRichTextListItem.Child.AsRichTextOembed {
  var asRichTextElement: RichTextElement {
    .oembed(RichTextElement.OEmbed(
      width: width, height: height, version: version, title: title,
      type: type, iframeUrl: iframeUrl, originalUrl: originalUrl
    ))
  }
}

internal func makeVideoFormats(
  _ formats: [RichTextItemFragment.AsRichTextVideo.Asset.Format?]?
) -> [RichTextElement.VideoFormat] {
  (formats ?? []).compactMap { format in
    guard let format else { return nil }
    return RichTextElement.VideoFormat(
      encoding: format.encoding, height: format.height, width: format.width,
      profile: format.profile, url: format.url
    )
  }
}

internal func makeTextElement(
  text: String?,
  link: String?,
  styles: [RichTextElement.Text.Style]?,
  children: [RichTextElement]
) -> RichTextElement.Text {
  RichTextElement.Text(
    text: text ?? "", link: link.flatMap { URL(string: $0) },
    styles: styles ?? [], children: children
  )
}

internal func makeText(
  text: String?,
  link: String?,
  styles: [String]?,
  children: [RichTextElement]
) -> RichTextElement.Text {
  makeTextElement(
    text: text,
    link: link,
    styles: styles?.compactMap(RichTextElement.Text.Style.init(rawValue:)),
    children: children
  )
}

