import KsApi
import SwiftUI

/// `SearchFilters` extensions declared in `SearchFilters+Pills.swift`.
extension SearchFilters {
  func buildFilterPills() -> [SearchFilterPill] {
    var pills: [SearchFilterPill] = []

    if let sortIcon = image(named: "icon-sort")?.withRenderingMode(.alwaysTemplate) {
      pills.append(SearchFilterPill(
        isHighlighted: self.hasSort,
        filterType: .sort,
        buttonType: .image(sortIcon)
      ))
    }

    if let filterIcon = image(named: "icon-filters")?.withRenderingMode(.alwaysTemplate) {
      pills.append(SearchFilterPill(
        isHighlighted: self.hasFilters,
        filterType: .allFilters,
        buttonType: .image(filterIcon),
        count: self.filterCount
      ))
    }

    let selectedCategory = self.category.selectedCategory.category
    let categoryPillTitle = selectedCategory?.name ?? Strings.Category()

    pills.append(SearchFilterPill(
      isHighlighted: self.hasCategory,
      filterType: .category,
      buttonType: .dropdown(categoryPillTitle)
    ))

    let projectStatePillTitle = self.hasProjectState ? self.projectState.selectedProjectState.title : Strings
      .Project_status()

    pills.append(
      SearchFilterPill(
        isHighlighted: self.hasProjectState,
        filterType: .projectState,
        buttonType: .dropdown(projectStatePillTitle)
      )
    )

    let locationTitle = self.location.selectedLocation?.displayableName ?? Strings.Location()
    pills.append(
      SearchFilterPill(
        isHighlighted: self.hasLocation,
        filterType: .location,
        buttonType: .dropdown(locationTitle)
      )
    )

    if AppEnvironment.current.currentUser.isSome {
      pills.append(
        SearchFilterPill(
          isHighlighted: self.showOnly.recommended,
          filterType: .recommended,
          buttonType: .toggle(Strings.Show_only_recommended_for_you())
        )
      )
    }

    let percentRaisedTitle = self.percentRaised.selectedBucket?.pillTitle ?? Strings.Percentage_raised()
    pills.append(
      SearchFilterPill(
        isHighlighted: self.hasPercentRaised,
        filterType: .percentRaised,
        buttonType: .dropdown(percentRaisedTitle)
      )
    )

    let amountRaisedTitle = self.amountRaised.selectedBucket?.pillTitle ?? Strings.Amount_raised()
    pills.append(
      SearchFilterPill(
        isHighlighted: self.hasAmountRaised,
        filterType: .amountRaised,
        buttonType: .dropdown(amountRaisedTitle)
      )
    )

    if let pwlIcon = image(named: "icon-pwl") {
      pills.append(
        SearchFilterPill(
          isHighlighted: self.showOnly.projectsWeLove,
          filterType: .projectsWeLove,
          buttonType: .toggleWithImage(Strings.Show_only_projects_we_love(), pwlIcon)
        )
      )
    }

    let goalTitle = self.goal.selectedBucket?.pillTitle ?? Strings.Goal()
    pills.append(
      SearchFilterPill(
        isHighlighted: self.hasGoal,
        filterType: .goal,
        buttonType: .dropdown(goalTitle)
      )
    )

    if AppEnvironment.current.currentUser.isSome {
      pills.append(
        SearchFilterPill(
          isHighlighted: self.showOnly.savedProjects,
          filterType: .saved,
          buttonType: .toggle(Strings.Show_only_saved_pill_title())
        )
      )
      pills.append(
        SearchFilterPill(
          isHighlighted: self.showOnly.following,
          filterType: .following,
          buttonType: .toggle(Strings.Show_only_following())
        )
      )
    }

    return pills
  }
}

