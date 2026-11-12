import Foundation
import GraphAPI

/// `PledgeManager` extensions declared in `PledgeManager+PledgeManagerFragment.swift`.
extension PledgeManager {
  init(fromFragment fragment: GraphAPI.PledgeManagerFragment) {
    self.id = decompose(id: fragment.id) ?? 0
    self.acceptsNewBackers = fragment.acceptsNewBackers
  }
}
