import Foundation

// MARK: - Rule 2, Rule 3 & Rule 6: AX Capability Registry & Schema Introspection Contracts

/// Capability catalog entry describing a single AX domain module's endpoints, field constraints, and deprecated primitives.
public struct AXModuleCapabilityEntry: Codable, Equatable, Sendable {
  /// Canonical lowercase module identifier (e.g. `"checkout"`, `"backing"`).
  public let moduleName: String
  /// Typed REST/GraphQL/AX endpoint descriptors registered for this module.
  public let endpoints: [AXEndpointDescriptor]
  /// Field-level constraints and negative constraints indexed by property name.
  public let fieldDescriptors: [String: AXFieldDescriptor]
  /// Legacy primitives deprecated in favor of hardened AX contracts.
  public let deprecatedPrimitives: [AXFieldDescriptor]

  /// Creates an `AXModuleCapabilityEntry`.
  public init(
    moduleName: String,
    endpoints: [AXEndpointDescriptor],
    fieldDescriptors: [String: AXFieldDescriptor],
    deprecatedPrimitives: [AXFieldDescriptor]
  ) {
    self.moduleName = moduleName
    self.endpoints = endpoints
    self.fieldDescriptors = fieldDescriptors
    self.deprecatedPrimitives = deprecatedPrimitives
  }
}

/// Poka-Yoke query schema for filtering the AX capability registry catalog.
///
/// - Negative constraint: Pass canonical lowercase module names (`"checkout"`), never class names or file paths.
public struct AXCatalogQuerySchema: Codable, Equatable, Sendable {
  /// Optional lowercase module identifier filter (`nil` returns all modules).
  public let moduleFilter: String?
  /// Whether deprecated legacy primitive descriptors are included in the catalog response.
  public let includeDeprecated: Bool

  /// Field-level descriptors and negative constraints for `AXCatalogQuerySchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "moduleFilter": .describe(
      field: "moduleFilter",
      meaning: "Optional lowercase module name to filter the AX capability catalog.",
      format: "Lowercase snake_case module identifier (e.g. 'checkout', 'backing', 'payments') or nil",
      negativeConstraints: [
        "Do not pass file paths or class names; pass the canonical module name.",
        "Do not pass empty whitespace-only strings."
      ]
    ),
    "includeDeprecated": .describe(
      field: "includeDeprecated",
      meaning: "Whether to include deprecated legacy primitives and their replacement mappings.",
      format: "Boolean (true or false)",
      negativeConstraints: ["Do not route new calls to entries where deprecated == true."]
    )
  ]

  /// Creates an `AXCatalogQuerySchema` filter payload.
  public init(moduleFilter: String? = nil, includeDeprecated: Bool = true) {
    self.moduleFilter = moduleFilter
    self.includeDeprecated = includeDeprecated
  }

  /// Validates and normalizes `moduleFilter` against the set of `knownModules`.
  public func validate(knownModules: Set<String>) -> Result<AXCatalogQuerySchema, AXProblemDetails> {
    guard let filter = self.moduleFilter else {
      return .success(self)
    }
    let normalized = filter.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !normalized.isEmpty, knownModules.contains(normalized) else {
      let sorted = knownModules.sorted().joined(separator: ", ")
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "Unknown AX module '\(filter)'.",
        suggestedAction: "Pass nil to list all modules, or choose one of the registered AX modules: \(sorted).",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "moduleFilter", reason: "Must be one of: \(sorted).")]
      ))
    }
    return .success(AXCatalogQuerySchema(moduleFilter: normalized, includeDeprecated: self.includeDeprecated))
  }
}

/// Machine-readable runtime AX capability catalog returned to agents for self-discovery.
public struct AXCatalogContract: Codable, Equatable, Sendable {
  /// Version tag of the AX capability catalog schema.
  public let schemaVersion: String
  /// Total number of matching domain modules in `modules`.
  public let totalModulesCount: Int
  /// Total number of registered endpoints across `modules`.
  public let totalEndpointsCount: Int
  /// Per-module capability descriptors.
  public let modules: [AXModuleCapabilityEntry]

  /// Creates an `AXCatalogContract`, computing aggregate module and endpoint counts.
  public init(
    schemaVersion: String = "2026.11.ax.v1",
    modules: [AXModuleCapabilityEntry]
  ) {
    self.schemaVersion = schemaVersion
    self.modules = modules
    self.totalModulesCount = modules.count
    self.totalEndpointsCount = modules.reduce(0) { $0 + $1.endpoints.count }
  }
}

