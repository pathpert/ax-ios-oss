import CoreTelephony
import Foundation

/// Contract defining `CoreTelephonyNetworkInfoType` capabilities and boundaries.
public protocol CoreTelephonyNetworkInfoType {
  var serviceCurrentRadioAccessTechnology: [String: String]? { get }
}

extension CTTelephonyNetworkInfo: CoreTelephonyNetworkInfoType {
  /// Returns the active `CoreTelephonyNetworkInfoType` (`MockCoreTelephonyNetworkInfo` on simulator, `CTTelephonyNetworkInfo` on device).
  public static func current() -> CoreTelephonyNetworkInfoType {
    #if targetEnvironment(simulator)
      return MockCoreTelephonyNetworkInfo()
    #else
      return CTTelephonyNetworkInfo()
    #endif
  }
}
