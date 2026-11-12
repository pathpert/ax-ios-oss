import Library
import Prelude
import UIKit

extension ProjectPageViewController: PinchToZoomDelegate, OverlayViewPresenting {
  /// Begins interactive pinch-to-zoom overlay presentation for campaign images.
  public func pinchZoomDidBegin(
    _ gestureRecognizer: UIPinchGestureRecognizer,
    frame: CGRect,
    image: UIImage
  ) {
    guard gestureRecognizer.scale > 1 else { return }

    let imageView = UIImageView(image: image)
      |> \.contentMode .~ .scaleAspectFit
      |> \.clipsToBounds .~ true
      |> \.frame .~ frame

    self.showOverlayView(with: imageView)

    let gestureCenterInContainer = locationInView(gestureRecognizer)
    self.pinchToZoomData = PinchToZoomData(
      referenceFrame: frame,
      referenceCenter: gestureCenterInContainer,
      imageView: imageView
    )
  }

  func pinchZoomDidChange(
    _ gestureRecognizer: UIPinchGestureRecognizer,
    completionHandler: () -> Void
  ) {
    guard let data = self.pinchToZoomData,
          let windowTransform = self.windowTransform else {
      self.hideOverlayView()
      return
    }

    let currentScale = data.imageView.frame.width / data.referenceFrame.size.width
    let newZoomScale = currentScale * gestureRecognizer.scale

    if newZoomScale > 1 {
      completionHandler()
    }

    let currentAlpha = OverlayViewLayout.Alpha.min + (newZoomScale - 1)
    let newAlpha = currentAlpha < OverlayViewLayout.Alpha.max ? currentAlpha : OverlayViewLayout.Alpha.max
    self.updateOverlayView(with: newAlpha)

    let centerXDiff = data.referenceCenter.x - locationInView(gestureRecognizer).x
    let centerYDiff = data.referenceCenter.y - locationInView(gestureRecognizer).y
    let zoomScale = (newZoomScale * data.imageView.frame.width >= data.referenceFrame.width)
      ? newZoomScale
      : currentScale

    let transform = windowTransform
      .scaledBy(x: zoomScale, y: zoomScale)
      .translatedBy(x: -centerXDiff, y: -centerYDiff)

    data.imageView.transform = transform
    self.transformSubviews(with: transform)
    self.pinchToZoomData = data
    gestureRecognizer.scale = 1
  }

  func pinchZoomDidEnd(
    _: UIPinchGestureRecognizer,
    completionHandler: @escaping () -> Void
  ) {
    UIView.animate(withDuration: 0.3, animations: {
      self.pinchToZoomData = nil
      self.transformSubviews(with: .identity)
    }, completion: { [weak self] _ in
      self?.hideOverlayView()
      completionHandler()
    })
  }
}

