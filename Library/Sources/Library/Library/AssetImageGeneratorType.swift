import AVFoundation
import class Foundation.NSValue

/// Contract defining `AssetImageGeneratorType` capabilities and boundaries.
public protocol AssetImageGeneratorType {
  init(asset: AVAsset)

  func generateCGImagesAsynchronously(
    forTimes requestedTimes: [NSValue],
    completionHandler handler: @escaping AVFoundation.AVAssetImageGeneratorCompletionHandler
  )
}

extension AVAssetImageGenerator: AssetImageGeneratorType {}
