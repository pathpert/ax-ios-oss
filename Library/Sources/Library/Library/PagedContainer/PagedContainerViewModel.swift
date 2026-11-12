import Combine
import Foundation
import SwiftUI
import UIKit

/// Badge display state rendered inside a `TabBarPage` segment tab.
public enum TabBarBadge {
  case none
  case dot
  case count(Int)

  /// Numeric count associated with `.count`, or `nil` for `.none`/`.dot`.
  public var count: Int? {
    switch self {
    case let .count(count):
      count
    case .none, .dot:
      nil
    }
  }

  /// Creates a badge from an optional integer count, optionally collapsing `0` to `.none`.
  public init(count: Int?, convertZeroToNone: Bool = true) {
    switch (count, convertZeroToNone) {
    case (.none, _):
      self = .none
    case (.some(0), true):
      self = .none
    case (.some(0), false):
      self = .count(0)
    case let (.some(count), _):
      self = .count(count)
    }
  }
}

/// Descriptor for a single tab and badge rendered by `PagedContainerViewController`.
public protocol TabBarPage: Identifiable {
  var name: String { get }
  var badge: TabBarBadge { get }
}

/// Input contract for `PagedContainerViewModel`.
public protocol PagedContainerViewModelInputs {
  associatedtype Page: TabBarPage

  func viewWillAppear()
  func configure(with children: [(Page, UIViewController)])
  func didSelect(page: Page)
}

/// Output contract for `PagedContainerViewModel`.
public protocol PagedContainerViewModelOutputs: ObservableObject {
  associatedtype Page: TabBarPage

  var displayPage: (page: Page, viewController: UIViewController)? { get }
  var pages: [(page: Page, viewController: UIViewController)] { get }
}

/// Observable ViewModel coordinating paged child view controllers and active tab selection.
public class PagedContainerViewModel<Page: TabBarPage>: PagedContainerViewModelInputs,
  PagedContainerViewModelOutputs, ObservableObject {
  init() {
    Publishers.CombineLatest(
      self.configureWithChildrenSubject,
      self.selectedPageSubject
    )
    .compactMap { combined -> (Page, UIViewController)? in
      let (pages, selectedPage) = combined
      return pages.first(where: { result in
        let (page, _) = result
        return page.id == selectedPage?.id
      })
    }
    .sink(receiveValue: { page in
      self.displayPage = page
    })
    .store(in: &self.subscriptions)

    self.configureWithChildrenSubject
      .sink { pages in
        self.pages = pages
      }
      .store(in: &self.subscriptions)

    self.viewWillAppearSubject
      .combineLatest(self.selectedPageSubject) { _, selectedPage in selectedPage }
      .filter { $0 == nil }
      .combineLatest(self.$pages) { _, pages in pages }
      .compactMap { pages in
        if let (firstPage, _) = pages.first {
          return firstPage
        } else {
          return nil
        }
      }
      .first()
      .sink { [weak self] page in
        self?.selectedPageSubject.send(page)
      }
      .store(in: &self.subscriptions)
  }

  // Inputs
  /// Notifies the container that its view is about to appear so an initial page is selected.
  public func viewWillAppear() {
    self.viewWillAppearSubject.send(())
  }

  /// Registers the ordered child view controllers corresponding to each `Page`.
  public func configure(with children: [(Page, UIViewController)]) {
    self.configureWithChildrenSubject.send(children)
  }

  /// Updates the active selected page when the user taps a tab or swipes.
  public func didSelect(page: Page) {
    if self.selectedPageSubject.value?.id != page.id {
      self.selectedPageSubject.send(page)
    }
  }

  // Outputs
  /// Currently visible `(Page, UIViewController)` pair.
  @Published public private(set) var displayPage: (page: Page, viewController: UIViewController)?
  /// All registered `(Page, UIViewController)` pairs in tab order.
  @Published public private(set) var pages: [(page: Page, viewController: UIViewController)] = []

  // Internal
  private var subscriptions = Set<AnyCancellable>()

  private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
  private let configureWithChildrenSubject = CurrentValueSubject<[(Page, UIViewController)], Never>([])
  private let selectedPageSubject = CurrentValueSubject<Page?, Never>(nil)
}
