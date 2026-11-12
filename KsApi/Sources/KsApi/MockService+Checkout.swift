#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

  extension MockService {
    /// Simulates adding a credit card payment source via the mock Apollo client in `DEBUG` tests.
    /// - Negative Constraint: Never available in Release builds.
    public func addNewCreditCard(input: CreatePaymentSourceInput)
      -> SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .CreatePaymentSourceMutation(input: GraphAPI.CreatePaymentSourceInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.addNewCreditCardResult)
    }

    /// Simulates adding a Stripe PaymentSheet setup-intent payment source via the mock Apollo client in `DEBUG` tests.
    public func addPaymentSheetPaymentSource(input: CreatePaymentSourceSetupIntentInput)
      -> SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .CreatePaymentSourceMutation(input: GraphAPI.CreatePaymentSourceInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.addPaymentSheetPaymentSourceResult)
    }

    func buildPaymentPlan(
      projectSlug: String,
      pledgeAmount: String
    ) -> SignalProducer<GraphAPI.BuildPaymentPlanQuery.Data, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let query = GraphAPI.BuildPaymentPlanQuery(
        slug: projectSlug,
        amount: pledgeAmount
      )

      return client.fetchWithResult(query: query, result: self.buildPaymentPlanResult)
    }

    internal func completeOnSessionCheckout(input: GraphAPI.CompleteOnSessionCheckoutInput) ->
      SignalProducer<GraphAPI.CompleteOnSessionCheckoutMutation.Data, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI.CompleteOnSessionCheckoutMutation(input: input)
      return client.performWithResult(mutation: mutation, result: self.completeOnSessionCheckoutResult)
    }

    internal func createCheckout(input: CreateCheckoutInput)
      -> SignalProducer<CreateCheckoutEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI.CreateCheckoutMutation(
        input: GraphAPI
          .CreateCheckoutInput(
            projectId: input.projectId,
            amount: GraphQLNullable.someOrNil(input.amount),
            locationId: GraphQLNullable.someOrNil(input.locationId),
            refParam: GraphQLNullable.someOrNil(input.refParam),
            rewardIds: GraphQLNullable.someOrNil(input.rewardIds)
          )
      )

      return client.performWithResult(mutation: mutation, result: self.createCheckoutResult)
    }

    internal func createPaymentIntentInput(input: CreatePaymentIntentInput) -> ReactiveSwift
      .SignalProducer<PaymentIntentEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .CreatePaymentIntentMutation(input: GraphAPI.CreatePaymentIntentInput(
          amount: input.amountDollars,
          digitalMarketingAttributed: GraphQLNullable.someOrNil(input.digitalMarketingAttributed),
          projectId: input.projectId
        ))

      return client.performWithResult(mutation: mutation, result: self.createPaymentIntentResult)
    }

    internal func createStripeSetupIntent(input: CreateSetupIntentInput)
      -> SignalProducer<ClientSecretEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .CreateSetupIntentMutation(input: GraphAPI.CreateSetupIntentInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.createStripeSetupIntentResult)
    }

    func fetchRewardAddOnsSelectionViewRewards(slug: String, shippingEnabled: Bool, locationId: String?)
      -> SignalProducer<Project, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let fetchRewardAddOnsSelectionViewRewardsQuery = GraphAPI.FetchAddOnsQuery(
        projectSlug: slug,
        shippingEnabled: shippingEnabled,
        locationId: GraphQLNullable.someOrNil(locationId)
      )

      return client
        .fetchWithResult(
          query: fetchRewardAddOnsSelectionViewRewardsQuery,
          result: self.fetchRewardAddOnsSelectionViewRewardsResult
        )
    }

    func fastFetchRewardAddOnsSelection(
      baseRewardId _: Int,
      countryCode _: String
    ) -> SignalProducer<[Reward], ErrorEnvelope> {
      return SignalProducer(error: ErrorEnvelope.graphError("Unimplemented mock"))
    }

    internal func fetchRewardShippingRules(projectId _: Int, rewardId _: Int)
      -> SignalProducer<ShippingRulesEnvelope, ErrorEnvelope> {
      if let error = self.fetchShippingRulesResult?.error {
        return SignalProducer(error: error)
      }

      return SignalProducer(value: .init(shippingRules: self.fetchShippingRulesResult?.value ?? [.template]))
    }

    internal func validateCheckout(
      checkoutId _: String,
      paymentSourceId _: String,
      paymentIntentClientSecret _: String
    ) -> SignalProducer<ValidateCheckoutEnvelope, ErrorEnvelope> {
      return producer(for: self.validateCheckoutResult)
    }

    internal func deletePaymentMethod(input: PaymentSourceDeleteInput) -> SignalProducer<
      DeletePaymentMethodEnvelope, ErrorEnvelope
    > {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutation = GraphAPI
        .DeletePaymentSourceMutation(input: GraphAPI.PaymentSourceDeleteInput.from(input))

      return client.performWithResult(mutation: mutation, result: self.deletePaymentMethodResult)
    }
  }
#endif

