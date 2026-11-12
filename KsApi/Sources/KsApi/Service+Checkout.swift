import Foundation
import GraphAPI
import ReactiveSwift

extension Service {
  /// Saves a newly tokenized Stripe credit card onto the user's Kickstarter account.
  public func addNewCreditCard(input: CreatePaymentSourceInput)
    -> SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .CreatePaymentSourceMutation(input: GraphAPI.CreatePaymentSourceInput.from(input))
      )
      .flatMap(CreatePaymentSourceEnvelope.producer(from:))
  }

  /// Registers a Stripe PaymentSheet setup intent payment source via GraphQL.
  public func addPaymentSheetPaymentSource(input: CreatePaymentSourceSetupIntentInput)
    -> SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .CreatePaymentSourceMutation(input: GraphAPI.CreatePaymentSourceInput.from(input))
      )
      .flatMap(CreatePaymentSourceEnvelope.producer(from:))
  }

  /// Calculates available Pledge Over Time installment schedules for `projectSlug` and decimal `pledgeAmount`.
  public func buildPaymentPlan(
    projectSlug: String,
    pledgeAmount: String
  ) -> SignalProducer<GraphAPI.BuildPaymentPlanQuery.Data, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.BuildPaymentPlanQuery(
        slug: projectSlug,
        amount: pledgeAmount
      ))
  }

  /// Finalizes an authenticated on-session checkout flow after 3DS / SCA confirmation.
  public func completeOnSessionCheckout(input: GraphAPI.CompleteOnSessionCheckoutInput) ->
    SignalProducer<GraphAPI.CompleteOnSessionCheckoutMutation.Data, ErrorEnvelope> {
    return GraphQL.shared.client.perform(mutation: GraphAPI.CompleteOnSessionCheckoutMutation(input: input))
  }

  /// Creates a GraphQL checkout session for late pledges or pledge manager flows.
  public func createCheckout(input: CreateCheckoutInput) ->
    SignalProducer<CreateCheckoutEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: GraphAPI.CreateCheckoutMutation(
        input: GraphAPI
          .CreateCheckoutInput(
            projectId: input.projectId,
            amount: GraphQLNullable.someOrNil(input.amount),
            locationId: GraphQLNullable.someOrNil(input.locationId),
            refParam: GraphQLNullable.someOrNil(input.refParam),
            rewardIds: GraphQLNullable.someOrNil(input.rewardIds)
          )
      ))
      .flatMap(CreateCheckoutEnvelope.producer(from:))
  }

  /// Creates a Stripe PaymentIntent client secret for checkout payment confirmation.
  public func createPaymentIntentInput(input: CreatePaymentIntentInput) -> ReactiveSwift
    .SignalProducer<PaymentIntentEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .CreatePaymentIntentMutation(input: GraphAPI.CreatePaymentIntentInput(
            amount: input.amountDollars,
            checkoutId: GraphQLNullable.someOrNil(input.checkoutId),
            digitalMarketingAttributed: GraphQLNullable.someOrNil(input.digitalMarketingAttributed),
            paymentIntentContext: GraphQLEnum.caseOrNil(input.paymentIntentContext),
            projectId: input.projectId
          ))
      )
      .flatMap(PaymentIntentEnvelope.envelopeProducer(from:))
  }

  /// Creates a Stripe SetupIntent client secret for saving a reusable payment method.
  public func createStripeSetupIntent(input: CreateSetupIntentInput) ->
    SignalProducer<ClientSecretEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .CreateSetupIntentMutation(input: GraphAPI.CreateSetupIntentInput.from(input))
      )
      .flatMap(ClientSecretEnvelope.envelopeProducer(from:))
  }

  /// Deletes a saved payment method belonging to the authenticated user.
  public func deletePaymentMethod(input: PaymentSourceDeleteInput)
    -> SignalProducer<DeletePaymentMethodEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(
        mutation: GraphAPI
          .DeletePaymentSourceMutation(input: GraphAPI.PaymentSourceDeleteInput.from(input))
      )
      .flatMap(DeletePaymentMethodEnvelope.producer(from:))
  }

  /// Fetches a `Project` populated with add-on reward options tailored for `locationId`.
  public func fetchRewardAddOnsSelectionViewRewards(
    slug: String,
    shippingEnabled: Bool,
    locationId: String?
  ) -> SignalProducer<Project, ErrorEnvelope> {
    let query = GraphAPI.FetchAddOnsQuery(
      projectSlug: slug,
      shippingEnabled: shippingEnabled,
      locationId: GraphQLNullable.someOrNil(locationId)
    )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap(Project.projectProducer(from:))
  }

  /// Fetches add-on `[Reward]` options compatible with `baseRewardId` for `countryCode` (ISO alpha-2).
  /// - Negative Constraint: Pass a valid ISO 3166-1 alpha-2 `GraphAPI.CountryCode` raw value; invalid codes fail immediately with `.graphError`.
  public func fastFetchRewardAddOnsSelection(
    baseRewardId: Int,
    countryCode: String
  ) -> SignalProducer<[Reward], ErrorEnvelope> {
    guard let graphCountryCode = GraphAPI.CountryCode(rawValue: countryCode) else {
      assertionFailure("Unable to map selected code to country")
      return SignalProducer(error: .graphError("Invalid country code"))
    }

    let query = GraphAPI.FastFetchAddOnsQuery(
      baseRewardId: "\(baseRewardId)",
      country: .case(graphCountryCode)
    )

    return GraphQL.shared.client
      .fetch(query: query)
      .flatMap(Reward.addOnsProducer(from:))
  }

  /// Fetches v1 REST shipping fee rules for a given `projectId` and `rewardId`.
  public func fetchRewardShippingRules(projectId: Int, rewardId: Int)
    -> SignalProducer<ShippingRulesEnvelope, ErrorEnvelope> {
    return request(.shippingRules(projectId: projectId, rewardId: rewardId))
  }

  /// Post-campaign pledge validation query.
  /// - parameter checkoutId: The Checkout Id.
  /// - parameter paymentSourceId: The ID of the payment source.
  /// - parameter paymentIntentClientSecret: The client secret returned from `CreatePaymentIntent`.
  public func validateCheckout(
    checkoutId: String,
    paymentSourceId: String,
    paymentIntentClientSecret: String
  ) -> SignalProducer<ValidateCheckoutEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .fetch(query: GraphAPI.ValidateCheckoutQuery(
        checkoutId: checkoutId,
        paymentSourceId: paymentSourceId,
        paymentIntentClientSecret: paymentIntentClientSecret
      ))
      .flatMap(ValidateCheckoutEnvelope.envelopeProducer(from:))
  }
}

