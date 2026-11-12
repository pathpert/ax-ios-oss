import Foundation
import KsApi
import PassKit

/// Protocol querying device and project-level Apple Pay payment network support.
public protocol ApplePayCapabilitiesType {
  /// Returns an array of all KSR supported `PKPaymentNetwork` values.
  func allSupportedNetworks() -> [PKPaymentNetwork]
  /// Returns whether the current device can make Apple Pay payments using `allSupportedNetworks()`.
  func applePayCapable() -> Bool
  /// Returns whether the current device supports Apple Pay hardware/software for any network.
  func applePayDevice() -> Bool

  /// Returns whether the device can make Apple Pay payments for `project`'s supported card networks.
  func applePayCapable(for project: Project) -> Bool

  /// Returns supported `PKPaymentNetwork`s derived from `project.availableCardTypes` or country defaults.
  func supportedNetworks(for project: Project) -> [PKPaymentNetwork]
}

/// Live `ApplePayCapabilitiesType` implementation delegating to PassKit.
public struct ApplePayCapabilities: ApplePayCapabilitiesType {
  /// Creates an `ApplePayCapabilities` helper instance.
  public init() {}

  /// Returns all card networks supported by Kickstarter iOS.
  public func allSupportedNetworks() -> [PKPaymentNetwork] {
    return [
      .amex,
      .masterCard,
      .visa,
      .discover,
      .JCB,
      .chinaUnionPay
    ]
  }

  /// Returns `true` if PassKit reports Apple Pay capability across any supported Kickstarter network.
  public func applePayCapable() -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.allSupportedNetworks())
  }

  /// Returns `true` if the device supports Apple Pay regardless of provisioned cards.
  public func applePayDevice() -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments()
  }

  /// Returns `true` if the user has a provisioned card matching `project`'s allowed networks.
  public func applePayCapable(for project: Project) -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments(
      usingNetworks: self.supportedNetworks(for: project)
    )
  }

  /// Resolves PassKit networks from `project.availableCardTypes` or falls back to project country defaults.
  public func supportedNetworks(for project: Project) -> [PKPaymentNetwork] {
    guard let availableCardTypes = project.availableCardTypes else {
      let projectCountryCurrency = projectCountry(forCurrency: project.stats.projectCurrency) ?? project
        .country
      return self.supportedNetworks(projectCountry: projectCountryCurrency)
    }

    return availableCardTypes
      .compactMap(CreditCardType.init(rawValue:))
      .compactMap(ApplePayCapabilities.pkPaymentNetwork(for:))
  }

  internal func supportedNetworks(projectCountry: Project.Country) -> [PKPaymentNetwork] {
    let allSupportedNetworks = self.allSupportedNetworks()

    if projectCountry == Project.Country.us {
      return allSupportedNetworks
    } else {
      let unsupportedNetworks: Set<PKPaymentNetwork> = [.chinaUnionPay, .discover]
      let supportedNetworks: Set<PKPaymentNetwork> = Set.init(allSupportedNetworks)

      return Array(supportedNetworks.subtracting(unsupportedNetworks))
    }
  }

  private static func pkPaymentNetwork(for graphCreditCardType: CreditCardType)
    -> PKPaymentNetwork? {
    switch graphCreditCardType {
    case .amex:
      return PKPaymentNetwork.amex
    case .discover:
      return PKPaymentNetwork.discover
    case .jcb:
      return PKPaymentNetwork.JCB
    case .mastercard:
      return PKPaymentNetwork.masterCard
    case .unionPay:
      return PKPaymentNetwork.chinaUnionPay
    case .visa:
      return PKPaymentNetwork.visa
    case .diners, .generic:
      return nil
    }
  }
}
