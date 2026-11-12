import Foundation
import UIKit

/// Type-safe two-dimensional backing store for `UICollectionViewDataSource` and `UITableViewDataSource`.
/// - Negative Constraint: Never mutate `values` directly outside subclass configuration or helper APIs.
open class ValueCellDataSource: NSObject, UICollectionViewDataSource, UITableViewDataSource {
  internal var values: [[(value: Any, reusableId: String)]] = []

  /// Override to bind `value` onto `collectionCell` via `configureWith(value:)`.
  open func configureCell(collectionCell _: UICollectionViewCell, withValue _: Any) {}

  /// Override to bind `value` onto `tableCell` via `configureWith(value:)`.
  open func configureCell(tableCell _: UITableViewCell, withValue _: Any) {}

  /// Override to register cells and nibs before attaching this data source to a collection view.
  open func registerClasses(collectionView _: UICollectionView?) {}

  /// Override to register cells and nibs before attaching this data source to a table view.
  open func registerClasses(tableView _: UITableView?) {}

  /// Removes all values from every section in the data source.
  public final func clearValues() {
    self.values = [[]]
  }

  /// Clears all values stored in `section`, padding intermediate sections if needed.
  public final func clearValues(section: Int) {
    self.padValuesForSection(section)
    self.values[section] = []
  }

  /// Inserts a single typed value at the beginning of `section` and returns its index path.
  @discardableResult
  public final func prependRow<
    Cell: ValueCell,
    Value: Any
  >
  (value: Value, cellClass _: Cell.Type, toSection section: Int) -> IndexPath
    where
    Cell.Value == Value {
    self.padValuesForSection(section)
    self.values[section].insert((value, Cell.defaultReusableId), at: 0)
    return IndexPath(row: 0, section: section)
  }

  /// Appends a single typed value to the end of `section` and returns its index path.
  @discardableResult
  public final func appendRow<
    Cell: ValueCell,
    Value: Any
  >
  (value: Value, cellClass _: Cell.Type, toSection section: Int) -> IndexPath
    where
    Cell.Value == Value {
    self.padValuesForSection(section)
    self.values[section].append((value, Cell.defaultReusableId))
    return IndexPath(row: self.values[section].count - 1, section: section)
  }

  /// Inserts a single typed value at `index` in `section` and returns its index path.
  @discardableResult
  public final func insertRow<Cell: ValueCell, Value: Any>(
    value: Value,
    cellClass _: Cell.Type,
    atIndex index: Int,
    inSection section: Int
  ) -> IndexPath
    where Cell.Value == Value {
    self.padValuesForSection(section)

    self.values[section].insert((value, Cell.defaultReusableId), at: index)

    return IndexPath(row: index, section: section)
  }

  /// Removes the row at `index` in `section` and returns the deleted index path.
  public final func deleteRow<Cell: ValueCell, Value: Any>(
    value _: Value,
    cellClass _: Cell.Type,
    atIndex index: Int,
    inSection section: Int
  ) -> IndexPath
    where Cell.Value == Value {
    self.padValuesForSection(section)

    self.values[section].remove(at: index)

    return IndexPath(row: index, section: section)
  }

  /// Appends a static row identified by `cellIdentifier` to `section` without an associated value.
  public final func appendStaticRow(cellIdentifier: String, toSection section: Int) {
    self.padValuesForSection(section)
    self.values[section].append(((), cellIdentifier))
  }

  /// Replaces an entire section with static cell identifiers.
  public final func set(cellIdentifiers: [String], inSection section: Int) {
    self.padValuesForSection(section)
    self.values[section] = cellIdentifiers.map { ((), $0) }
  }

  /// Appends a new section populated with typed `values` mapped to `cellClass`.
  public final func appendSection<
    Cell: ValueCell,
    Value: Any
  >
  (values: [Value], cellClass _: Cell.Type)
    where
    Cell.Value == Value {
    self.values.append(values.map { ($0, Cell.defaultReusableId) })
  }

  /// Replaces the contents of `section` with `values` bound to `cellClass`.
  public final func set<
    Cell: ValueCell,
    Value: Any
  >
  (values: [Value], cellClass _: Cell.Type, inSection section: Int)
    where
    Cell.Value == Value {
    self.padValuesForSection(section)
    self.values[section] = values.map { ($0, Cell.defaultReusableId) }
  }

  /// Replaces the single row at `(row, section)` with `value` bound to `cellClass`.
  public final func set<
    Cell: ValueCell,
    Value: Any
  >
  (value: Value, cellClass _: Cell.Type, inSection section: Int, row: Int)
    where
    Cell.Value == Value {
    self.values[section][row] = (value, Cell.defaultReusableId)
  }

  /// Returns the stored model value at `indexPath`.
  public final subscript(indexPath: IndexPath) -> Any {
    return self.values[indexPath.section][indexPath.item].value
  }

  /// Returns the stored model value at `(item, section)`.
  public final subscript(itemSection itemSection: (item: Int, section: Int)) -> Any {
    return self.values[itemSection.section][itemSection.item].value
  }

  /// Returns all stored model values in `section`.
  public final subscript(section section: Int) -> [Any] {
    return self.values[section].map { $0.value }
  }

  /// Returns the total number of items across all sections in the data source.
  public final func numberOfItems() -> Int {
    return self.values.reduce(0) { accum, section in accum + section.count }
  }

  /// Returns the number of items stored in `section`.
  public final func numberOfItems(in section: Int) -> Int {
    return self.values[section].count
  }

  /// Converts a two-dimensional `indexPath` into a flattened linear item offset.
  public final func itemIndexAt(_ indexPath: IndexPath) -> Int {
    return self.values[0..<indexPath.section]
      .reduce(indexPath.item) { accum, section in accum + section.count }
  }
}
