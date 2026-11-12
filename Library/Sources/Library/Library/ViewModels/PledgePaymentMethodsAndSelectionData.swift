import Foundation

/// Snapshot of payment method cell sections and current selection state for pledge checkout.
/// - Negative Constraint: Do not mutate selection outside the pledge payment methods view model.
public struct PledgePaymentMethodsAndSelectionData {
  /// Cell configurations for previously saved credit cards on file.
  public var existingPaymentMethods: [PledgePaymentMethodCellData]
  /// Cell configurations for adding a new credit card or payment instrument.
  public var newPaymentMethods: [PledgePaymentMethodCellData]
  /// Currently selected saved payment method, or `nil` if none is selected.
  public var selectedPaymentMethod: PaymentSourceSelected?
  /// `true` while stored payment methods are being fetched from the API.
  public var isLoading: Bool
  /// `true` when the list view should reload its payment method rows.
  public var shouldReload: Bool
}
