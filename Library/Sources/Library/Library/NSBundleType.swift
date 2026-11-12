import Foundation
import KsApi

/// Known bundle identifiers for Kickstarter build configurations.
public enum KickstarterBundleIdentifier: String {
  /// Debug build bundle identifier.
  case debug = "com.kickstarter.kickstarter.debug"
  /// Alpha build bundle identifier.
  case alpha = "com.kickstarter.kickstarter.kickalpha"
  /// Beta build bundle identifier.
  case beta = "com.kickstarter.kickstarter.beta"
  /// App Store release bundle identifier.
  case release = "com.kickstarter.kickstarter"
}

/// Abstraction over `Bundle` for accessing bundle metadata, resources, and localized strings.
public protocol NSBundleType {
  /// The bundle's unique identifier.
  var bundleIdentifier: String? { get }
  /// Creates a bundle instance at the specified path, or `nil` if not found.
  static func create(path: String) -> NSBundleType?
  /// Returns the full pathname for the resource identified by `name` and file extension `ext`.
  func path(forResource name: String?, ofType ext: String?) -> String?
  /// Returns a localized version of the string designated by `key` in `tableName`.
  func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
  /// Returns the Info.plist string value associated with `key`, if present.
  func infoString(forKey key: String) -> String?
}

extension NSBundleType {
  /// The bundle identifier from Info.plist, or `"Unknown"` if missing.
  public var identifier: String {
    return self.infoString(forKey: "CFBundleIdentifier") ?? "Unknown"
  }

  /// The release version string (`CFBundleShortVersionString`), or `"Unknown"` if missing.
  public var shortVersionString: String {
    return self.infoString(forKey: "CFBundleShortVersionString") ?? "Unknown"
  }

  /// The bundle build number (`CFBundleVersion`), or `"0"` if missing.
  public var version: String {
    return self.infoString(forKey: "CFBundleVersion") ?? "0"
  }

  /// Combined display version string, including build number for non-release builds.
  public var appVersionString: String {
    let versionString = self.shortVersionString
    let build = self.isRelease ? "" : " #\(self.version)"
    return "\(versionString)\(build)"
  }

  /// The platform version (`DTPlatformVersion`), or `"Unknown"` if missing.
  public var platformVersion: String {
    return self.infoString(forKey: "DTPlatformVersion") ?? "Unknown"
  }

  /// `true` when running the debug bundle identifier.
  public var isDebug: Bool {
    return self.identifier == KickstarterBundleIdentifier.debug.rawValue
  }

  /// `true` when running the alpha bundle identifier.
  public var isAlpha: Bool {
    return self.identifier == KickstarterBundleIdentifier.alpha.rawValue
  }

  /// `true` when running the beta bundle identifier.
  public var isBeta: Bool {
    return self.identifier == KickstarterBundleIdentifier.beta.rawValue
  }

  /// `true` when running the release bundle identifier.
  public var isRelease: Bool {
    return self.identifier == KickstarterBundleIdentifier.release.rawValue
  }

  /// Typed Kickstarter bundle identifier enum value matching `identifier`, if recognized.
  public var kickstarterBundleId: KickstarterBundleIdentifier? {
    return KickstarterBundleIdentifier(rawValue: self.identifier)
  }
}

extension Bundle: NSBundleType {
  /// Creates a `Bundle` at the specified file path.
  public static func create(path: String) -> NSBundleType? {
    return Bundle(path: path)
  }

  /// Reads a string value from `infoDictionary` for `key`.
  public func infoString(forKey key: String) -> String? {
    return self.infoDictionary?[key] as? String
  }
}

/// Test/debug `NSBundleType` implementation that doubles localized strings.
public struct LanguageDoubler: NSBundleType {
  fileprivate static let mainBundle = Bundle.main

  /// Creates a `LanguageDoubler` bundle wrapper.
  public init() {}

  /// Fixed bundle identifier for the language doubler.
  public let bundleIdentifier: String? = "com.language.doubler"

  /// Creates a `DoublerBundle` at the given path.
  public static func create(path: String) -> NSBundleType? {
    return DoublerBundle(path: path)
  }

  /// Returns a localized string forwarded from the main bundle.
  public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
    return LanguageDoubler.mainBundle.localizedString(forKey: key, value: value, table: tableName)
  }

  /// Returns a resource path forwarded from the main bundle.
  public func path(forResource name: String?, ofType ext: String?) -> String? {
    return LanguageDoubler.mainBundle.path(forResource: name, ofType: ext)
  }

  /// Returns an empty Info.plist lookup result.
  public func infoString(forKey _: String) -> String? {
    return nil
  }
}

/// `Bundle` subclass that duplicates localized strings for pseudo-localization testing.
public final class DoublerBundle: Bundle {
  /// Returns the localized string repeated twice separated by a space.
  public override func localizedString(
    forKey key: String,
    value: String?,
    table tableName: String?
  ) -> String {
    let s = super.localizedString(forKey: key, value: value, table: tableName)
    return "\(s) \(s)"
  }
}
