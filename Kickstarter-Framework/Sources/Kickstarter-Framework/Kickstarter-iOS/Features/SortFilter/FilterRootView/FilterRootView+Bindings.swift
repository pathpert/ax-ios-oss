import KDS
import KsApi
import Library
import SwiftUI

extension View {
  func modalHeader(withTitle title: String, onClose: (() -> Void)?) -> some View {
    self
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            if let action = onClose {
              action()
            }
          } label: {
            if let icon = Library.image(named: "icon--cross") {
              Image(uiImage: icon.withRenderingMode(.alwaysTemplate))
                .tint(Colors.Text.primary.swiftUIColor())
            }
          }
        }
      }
  }
}

// MARK: - Bindings

extension FilterRootView {
  var selectedCategory: Binding<SearchFiltersCategory> {
    Binding {
      self.searchFilters.category.selectedCategory
    } set: { newValue in
      if let action = self.onFilter {
        action(.category(newValue))
      }
    }
  }

  var selectedPercentRaisedBucket: Binding<DiscoveryParams.PercentRaisedBucket?> {
    Binding {
      self.searchFilters.percentRaised.selectedBucket
    } set: { newValue in
      if let action = self.onFilter,
         let bucket = newValue {
        action(.percentRaised(bucket))
      }
    }
  }

  var selectedLocation: Binding<Location?> {
    Binding {
      self.searchFilters.location.selectedLocation
    } set: { newValue in
      if let action = self.onFilter {
        action(.location(newValue))
      }
    }
  }

  var selectedAmountRaisedBucket: Binding<DiscoveryParams.AmountRaisedBucket?> {
    Binding {
      self.searchFilters.amountRaised.selectedBucket
    } set: { newValue in
      if let action = self.onFilter,
         let bucket = newValue {
        action(.amountRaised(bucket))
      }
    }
  }

  var selectedGoalBucket: Binding<DiscoveryParams.GoalBucket?> {
    Binding {
      self.searchFilters.goal.selectedBucket
    } set: { newValue in
      if let action = self.onFilter,
         let bucket = newValue {
        action(.goal(bucket))
      }
    }
  }

  var showRecommended: Binding<Bool> {
    Binding {
      self.searchFilters.showOnly.recommended
    } set: { newValue in
      if let action = self.onFilter {
        action(.recommended(newValue))
      }
    }
  }

  var showSavedProjects: Binding<Bool> {
    Binding {
      self.searchFilters.showOnly.savedProjects
    } set: { newValue in
      if let action = self.onFilter {
        action(.savedProjects(newValue))
      }
    }
  }

  var showProjectsWeLove: Binding<Bool> {
    Binding {
      self.searchFilters.showOnly.projectsWeLove
    } set: { newValue in
      if let action = self.onFilter {
        action(.projectsWeLove(newValue))
      }
    }
  }

  var showFollowing: Binding<Bool> {
    Binding {
      self.searchFilters.showOnly.following
    } set: { newValue in
      if let action = self.onFilter {
        action(.following(newValue))
      }
    }
  }
}

// MARK: - Identifiable extension

extension DiscoveryParams.State: @retroactive Identifiable {
  /// Stable string identifier backed by the state raw value.
  public var id: String {
    return self.rawValue
  }
}

