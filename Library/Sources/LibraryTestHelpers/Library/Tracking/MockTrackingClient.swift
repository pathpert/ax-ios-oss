import Foundation
import Library

/// Controller/component implementing `MockTrackingClient`.
internal final class MockTrackingClient: TrackingClientType {
  internal var tracks: [(event: String, properties: [String: Any])] = []
  internal var screens: [(title: String, properties: [String: Any])] = []
  internal var userId: String?
  internal var anonymousId: String = "fake-anon-id"
  internal var traits: [String: Any]?

  func track<P: Codable>(name: String, properties: P?) {
    if let bag = properties as? AnalyticsPropertyBag {
      let dict: [String: Any] = bag.values.mapValues { value in
        switch value {
        case let .string(v): return v
        case let .int(v): return v
        case let .double(v): return v
        case let .float(v): return v
        case let .decimal(v): return v
        case let .bool(v): return v
        case let .stringArray(v): return v
        }
      }
      self.tracks.append((event: name, properties: dict))
    } else if let properties,
              let data = try? JSONEncoder().encode(properties),
              let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
      self.tracks.append((event: name, properties: dict))
    } else {
      self.tracks.append((event: name, properties: [:]))
    }
  }

  internal var events: [String] {
    return self.tracks.map { $0.event }
  }

  internal var properties: [[String: Any]] {
    return self.tracks.map { $0.properties }
  }

  internal func properties(forKey key: String) -> [String?] {
    return self.properties(forKey: key, as: String.self)
  }

  internal func properties<A>(forKey key: String, as _: A.Type) -> [A?] {
    return self.tracks.map { $0.properties[key] as? A }
  }

  internal func containsKeyPrefix(_ prefix: String) -> Bool {
    for key in self.properties.map(\.keys).flatMap({ $0 }) where key.hasPrefix(prefix) { return true }

    return false
  }
}

extension MockTrackingClient: IdentifyingTrackingClient {
  func identify<T: Codable>(userId: String, traits: T?) {
    self.userId = userId
    if let bag = traits as? AnalyticsPropertyBag {
      self.traits = bag.values.mapValues { value in
        switch value {
        case let .string(v): return v
        case let .int(v): return v
        case let .double(v): return v
        case let .float(v): return v
        case let .decimal(v): return v
        case let .bool(v): return v
        case let .stringArray(v): return v
        }
      }
    } else if let traits,
              let data = try? JSONEncoder().encode(traits) {
      self.traits = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    } else {
      self.traits = nil
    }
  }

  func reset() {
    self.userId = nil
    self.traits = nil
  }
}
