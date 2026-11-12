import KsApi
import SwiftUI

/// View model for `ReportProjectInfoView`.
/// Fetches flagging options on `viewDidLoad` and publishes the result for SwiftUI.
@MainActor
public final class ReportProjectInfoViewModel: ObservableObject {
  /// Flagging option items fetched from the API and rendered in the report sheet.
  @Published public var listItems: [ReportProjectInfoListItem] = []
  /// Whether the initial project flagging options fetch is currently in flight.
  @Published public var isLoading = false

  /// Creates a `ReportProjectInfoViewModel` with empty initial flagging items.
  public init() {}

  /// Triggers loading of project flagging options from `apiService` when the view appears.
  public func viewDidLoad() {
    Task {
      self.isLoading = true

      defer { isLoading = false }

      do {
        self.listItems = try await AppEnvironment.current.apiService
          .fetchProjectFlaggingOptions()
      } catch {
        /// listItems stays empty on error
      }
    }
  }
}
