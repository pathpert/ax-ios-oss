import Foundation

extension VideoFeedViewModel {
  /// Clears the pending login intent after presenting login.
  public func clearLoginIntent() {
    self.setLoginIntent(nil)
  }

  /// Clears the save error ID after the failure toast has displayed.
  public func clearSaveFailedItemId() {
    self.setSaveFailedItemId(nil)
  }

  /// Toggles global feed mute state and updates persisted mute preference.
  public func toggleMute() {
    self.togglePersistedMute()
  }

  /// Tracks a swipe transition and fires an impression event for the incoming video page.
  public func trackPageViewed(atIndex index: Int, totalWatchTimeMs: Int, totalVideoDurationMs: Int) {
    guard index < self.items.count else { return }

    let incoming = self.items[index]
    let outgoing = self.items[self.lastPageIndex]

    AppEnvironment.current.ksrAnalytics.trackVideoFeedSwipe(
      videoId: incoming.id,
      projectId: incoming.projectId,
      positionInSession: index,
      fromVideoId: outgoing.id,
      totalWatchTimeMs: totalWatchTimeMs,
      totalVideoDurationMs: totalVideoDurationMs
    )

    AppEnvironment.current.ksrAnalytics.trackVideoFeedImpression(
      videoId: incoming.id,
      projectId: incoming.projectId,
      positionInSession: index
    )

    self.lastPageIndex = index
  }

  /// Tracks a user CTA interaction (play, pause, save, or share) on a video item.
  public func trackCTAClicked(ctaContext: KSRAnalytics.CTAContext, item: VideoFeedItem) {
    AppEnvironment.current.ksrAnalytics.trackVideoFeedCTAClicked(
      ctaContext: ctaContext,
      videoId: item.id,
      projectId: item.projectId
    )
  }

  /// Tracks a video scrubber progress bar tap interaction.
  public func trackProgressBarTapped(item: VideoFeedItem, positionInSession: Int, percentageWatched: Float) {
    AppEnvironment.current.ksrAnalytics.trackVideoFeedProgressBarTapped(
      videoId: item.id,
      projectId: item.projectId,
      positionInSession: positionInSession,
      percentageWatched: percentageWatched
    )
  }
}

