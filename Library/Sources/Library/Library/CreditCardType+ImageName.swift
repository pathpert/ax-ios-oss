import KsApi

/// `CreditCardType` extensions declared in `CreditCardType+ImageName.swift`.
extension CreditCardType {
  public var imageName: String {
    switch self {
    case .generic:
      return "icon--generic"
    case let type:
      return "icon--\(type.rawValue.lowercased())"
    }
  }
}
