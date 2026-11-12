import Foundation
import GraphAPI

/// GraphQL mutation input for creating a Stripe SetupIntent for card tokenization.
///
/// Negative Constraint: Provide `context` matching the checkout or settings entry point.
public struct CreateSetupIntentInput: GraphMutationInput, Encodable {
  let projectId: String?
  let setupIntentContext: GraphAPI.StripeIntentContextTypes?

  /// An input object for the `CreateSetupIntentMutation`.
  /// - parameter projectId: A project id that is needed by GraphQL to generate a client secret.
  public init(projectId: String?, context: GraphAPI.StripeIntentContextTypes?) {
    self.projectId = projectId
    self.setupIntentContext = context
  }
}

extension GraphAPI.StripeIntentContextTypes: Encodable {}
