import Foundation
import UIKit

extension ValueCellDataSource {
  // MARK: - UICollectionViewDataSource methods

  /// Returns the number of sections in the collection view data source.
  public final func numberOfSections(in _: UICollectionView) -> Int {
    return self.values.count
  }

  /// Returns the number of items in the specified collection view section.
  public final func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.values[section].count
  }

  /// Dequeues and configures a collection view cell at `indexPath`.
  public final func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let (value, reusableId) = self.values[indexPath.section][indexPath.item]

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath)

    self.configureCell(collectionCell: cell, withValue: value)

    return cell
  }

  // MARK: - UITableViewDataSource methods

  /// Returns the number of sections in the table view data source.
  public final func numberOfSections(in _: UITableView) -> Int {
    return self.values.count
  }

  /// Returns the number of rows in the specified table view section.
  public final func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.values[section].count
  }

  /// Dequeues and configures a table view cell at `indexPath`.
  public final func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let (value, reusableId) = self.values[indexPath.section][indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath)

    self.configureCell(tableCell: cell, withValue: value)

    return cell
  }

  /**
   - parameter item:    An item index.
   - parameter section: A section index.

   - returns: The reusableId associated with an (item, section) pair. Marked as internal as it's
              only useful for testing.
   */
  internal final func reusableId(item: Int, section: Int) -> String? {
    if !self.values.isEmpty, self.values.count >= section,
       !self.values[section].isEmpty, self.values[section].count >= item {
      return self.values[section][item].reusableId
    }
    return nil
  }

  /**
   Only useful for testing.

   - parameter itemSection: A pair containing an item index and a section index.

   - returns: The value of Any? type that is contained within the section at the item index.
   */
  internal final subscript(testItemSection itemSection: (item: Int, section: Int)) -> Any? {
    let (item, section) = itemSection

    if !self.values.isEmpty, self.values.count >= section,
       !self.values[section].isEmpty, self.values[section].count >= item {
      return self.values[itemSection.section][itemSection.item].value
    }
    return nil
  }

  /// Ensures empty section arrays exist up through `section`.
  public func padValuesForSection(_ section: Int) {
    guard self.values.count <= section else { return }

    (self.values.count...section).forEach { _ in
      self.values.append([])
    }
  }

  /// Returns all `(value, reusableId)` items stored in the specified section.
  public func items(in section: Int) -> [(value: Any, reusableId: String)] {
    return self.values[section]
  }
}

