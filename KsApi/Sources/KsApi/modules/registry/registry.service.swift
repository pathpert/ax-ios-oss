import Foundation

// MARK: - Rule 2: AX Registry Module Service (Introspection of All Modernized Modules)

/// Read-only registry service exposing machine-readable descriptors for all modernized AX modules.
///
/// Negative Constraint: Exhausting `rateLimitMax` returns HTTP 429; cache `AXCatalogContract` rather than polling per turn.
public final class RegistryModuleService {
  private let allEntries: [AXModuleCapabilityEntry]
  private let rateLimitMax: Int
  private var remainingQuota: Int

  /// Creates a `RegistryModuleService` with configurable rate-limit budget.
  public init(rateLimitMax: Int = 120, initialRemainingQuota: Int? = nil) {
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.allEntries = Self.buildDefaultEntries()
  }

  /// Queries available module capabilities, field descriptors, and optional deprecation notices.
  public func queryCatalog(
    schema: AXCatalogQuerySchema
  ) -> Result<AXServiceResponse<AXCatalogContract>, AXProblemDetails> {
    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) catalog queries exceeded.",
        suggestedAction: "Cache the AXCatalogContract locally and wait 15 seconds before re-querying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      ))
    }
    self.remainingQuota -= 1

    let known = Set(self.allEntries.map(\.moduleName))
    return schema.validate(knownModules: known).map { validated in
      let filtered = self.allEntries
        .filter { entry in
          guard let target = validated.moduleFilter else { return true }
          return entry.moduleName == target
        }
        .map { entry in
          AXModuleCapabilityEntry(
            moduleName: entry.moduleName,
            endpoints: entry.endpoints,
            fieldDescriptors: entry.fieldDescriptors,
            deprecatedPrimitives: validated.includeDeprecated ? entry.deprecatedPrimitives : []
          )
        }

      return AXServiceResponse(
        value: AXCatalogContract(modules: filtered),
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      )
    }
  }

  private static func buildDefaultEntries() -> [AXModuleCapabilityEntry] {
    [
      AXModuleCapabilityEntry(
        moduleName: "checkout",
        endpoints: [CheckoutController.createCheckoutEndpoint, CheckoutController.cancelBackingEndpoint],
        fieldDescriptors: CreateCheckoutRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [
          CreateCheckoutInput.axDeprecationDescriptor,
          CancelBackingInput.axDeprecationDescriptor
        ]
      ),
      AXModuleCapabilityEntry(
        moduleName: "backing",
        endpoints: [BackingController.createBackingEndpoint, BackingController.updateBackingEndpoint],
        fieldDescriptors: CreateBackingRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [
          CreateBackingInput.axDeprecationDescriptor,
          UpdateBackingInput.axDeprecationDescriptor
        ]
      ),
      AXModuleCapabilityEntry(
        moduleName: "payments",
        endpoints: [PaymentsController.createPaymentIntentEndpoint, PaymentsController.deletePaymentSourceEndpoint],
        fieldDescriptors: CreatePaymentIntentRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [
          CreatePaymentIntentInput.axDeprecationDescriptor,
          PaymentSourceDeleteInput.axDeprecationDescriptor
        ]
      ),
      AXModuleCapabilityEntry(
        moduleName: "comments",
        endpoints: [CommentsController.postCommentEndpoint, CommentsController.blockUserEndpoint],
        fieldDescriptors: PostCommentRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [
          PostCommentInput.axDeprecationDescriptor,
          BlockUserInput.axDeprecationDescriptor
        ]
      ),
      AXModuleCapabilityEntry(
        moduleName: "account",
        endpoints: [
          AccountController.changeEmailEndpoint,
          AccountController.changePasswordEndpoint,
          AccountController.changeCurrencyEndpoint
        ],
        fieldDescriptors: ChangeEmailRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [
          ChangeEmailInput.axDeprecationDescriptor,
          ChangePasswordInput.axDeprecationDescriptor,
          ChangeCurrencyInput.axDeprecationDescriptor
        ]
      ),
      AXModuleCapabilityEntry(
        moduleName: "engagement",
        endpoints: [
          EngagementController.watchProjectEndpoint,
          EngagementController.unwatchProjectEndpoint,
          EngagementController.createFlaggingEndpoint
        ],
        fieldDescriptors: WatchProjectRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [
          WatchProjectInput.axDeprecationDescriptor,
          CreateFlaggingInput.axDeprecationDescriptor
        ]
      ),
      AXModuleCapabilityEntry(
        moduleName: "auth",
        endpoints: [AuthController.signInWithAppleEndpoint, AuthController.verifyEmailEndpoint],
        fieldDescriptors: SignInWithAppleRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [SignInWithAppleInput.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "attribution",
        endpoints: [AttributionController.triggerEventEndpoint, AttributionController.registerPushTokenEndpoint],
        fieldDescriptors: TriggerThirdPartyEventRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [TriggerThirdPartyEventInput.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "messaging",
        endpoints: [MessagingController.sendMessageEndpoint],
        fieldDescriptors: SendMessageRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [MessageSubject.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "discovery",
        endpoints: [DiscoveryController.queryDiscoveryEndpoint],
        fieldDescriptors: DiscoveryQueryRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [DiscoveryParams.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "creator_updates",
        endpoints: [CreatorUpdatesController.updateDraftEndpoint, CreatorUpdatesController.publishDraftEndpoint],
        fieldDescriptors: UpdateCreatorDraftRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [UpdateDraft.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "pledge_management",
        endpoints: [PledgeManagementController.validateCheckoutEndpoint],
        fieldDescriptors: ValidateCheckoutRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [ValidateCheckoutEnvelope.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "social",
        endpoints: [SocialController.followFriendEndpoint, SocialController.unfollowFriendEndpoint],
        fieldDescriptors: FollowFriendRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [FriendStatsEnvelope.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "notifications",
        endpoints: [
          NotificationsController.updateProjectNotificationEndpoint,
          NotificationsController.clearUnseenActivityEndpoint
        ],
        fieldDescriptors: UpdateProjectNotificationRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [ProjectNotification.axDeprecationDescriptor]
      ),
      AXModuleCapabilityEntry(
        moduleName: "shipping",
        endpoints: [
          ShippingController.fetchShippingRulesEndpoint,
          ShippingController.fetchSurveyResponseEndpoint
        ],
        fieldDescriptors: FetchShippingRulesRequestSchema.fieldDescriptors,
        deprecatedPrimitives: [ShippingRule.axDeprecationDescriptor]
      )
    ]
  }
}

