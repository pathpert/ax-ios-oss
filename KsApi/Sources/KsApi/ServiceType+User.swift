import Combine
import Foundation
import GraphAPI
import ReactiveSwift

/// Domain-scoped protocol for user profile, account settings, social/friends, notifications, activities, and surveys.
public protocol ServiceUserType {
  /// Changes the email on a user account.
  func changeEmail(input: ChangeEmailInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Changes the password on a user account.
  func changePassword(input: ChangePasswordInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Changes the currency code on a user profile.
  func changeCurrency(input: ChangeCurrencyInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Clears the user's unseen activity count.
  func clearUserUnseenActivity(input: EmptyInput)
    -> SignalProducer<ClearUserUnseenActivityEnvelope, ErrorEnvelope>

  /// Creates the password on a user account.
  func createPassword(input: CreatePasswordInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Fetch a page of activities.
  func fetchActivities(count: Int?) -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetch activities from a pagination URL.
  func fetchActivities(paginationUrl: String) -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetch friends for a user.
  func fetchFriends() -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope>

  /// Fetch friends from a pagination url.
  func fetchFriends(paginationUrl: String) -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope>

  /// Fetch friend stats.
  func fetchFriendStats() -> SignalProducer<FriendStatsEnvelope, ErrorEnvelope>

  /// Fetches various fields of a given User using GraphQL.
  func fetchGraphUser(withStoredCards: Bool)
    -> SignalProducer<UserEnvelope<GraphUser>, ErrorEnvelope>

  /// Fetches the email of the currently logged in User.
  func fetchGraphUserEmail()
    -> SignalProducer<UserEnvelope<GraphUserEmail>, ErrorEnvelope>

  /// Fetches the email of the currently logged in User using Combine.
  func fetchGraphUserEmailCombine()
    -> AnyPublisher<UserEnvelope<GraphUserEmail>, ErrorEnvelope>

  /// Fetches the account setup state of the currently logged in User.
  func fetchGraphUserSetup()
    -> SignalProducer<UserEnvelope<GraphUserSetup>, ErrorEnvelope>

  /// Fetches the account setup state of the currently logged in User using Combine.
  func fetchGraphUserSetupCombine()
    -> AnyPublisher<UserEnvelope<GraphUserSetup>, ErrorEnvelope>

  /// Fetches GraphQL user fragment and returns User instance.
  func fetchGraphUserSelf()
    -> SignalProducer<UserEnvelope<User>, ErrorEnvelope>

  /// Fetch the user's project notifications.
  func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope>

  /// Fetches a survey response belonging to the current user.
  func fetchSurveyResponse(surveyResponseId: Int)
    -> SignalProducer<SurveyResponse, ErrorEnvelope>

  /// Fetches all of the user's unanswered surveys.
  func fetchUnansweredSurveyResponses() -> SignalProducer<[SurveyResponse], ErrorEnvelope>

  /// Fetch the newest data for a particular user.
  func fetchUser(_ user: User) -> SignalProducer<User, ErrorEnvelope>

  /// Fetch a user by ID.
  func fetchUser(userId: Int) -> SignalProducer<User, ErrorEnvelope>

  /// Fetch the logged-in user's data.
  func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope>

  /// Fetch the logged-in user's data using Combine.
  func fetchUserSelf_combine(withOAuthToken: String) -> AnyPublisher<User, ErrorEnvelope>

  /// Follow all friends of current user.
  func followAllFriends() -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Follow a user with their id.
  func followFriend(userId id: Int) -> SignalProducer<User, ErrorEnvelope>

  /// Unfollow a user with their id.
  func unfollowFriend(userId id: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Registers a push token.
  func register(pushToken: String) -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Update the project notification setting.
  func updateProjectNotification(_ notification: ProjectNotification)
    -> SignalProducer<ProjectNotification, ErrorEnvelope>

  /// Update the current user with settings attributes.
  func updateUserSelf(_ user: User) -> SignalProducer<User, ErrorEnvelope>

  /// Blocks a user by ID.
  func blockUser(input: BlockUserInput) -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>
}

/// Domain-scoped protocol for project/update comments and direct message threads.
public protocol ServiceMessagingAndCommentsType {
  /// Fetch comments for a project with a slug, cursor and limit.
  func fetchProjectComments(
    slug: String,
    cursor: String?,
    limit: Int?
  ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch comments for an update with an id, cursor, limit and comments' users' stored cards.
  func fetchUpdateComments(
    id: String,
    cursor: String?,
    limit: Int?
  ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch comment replies for a comment with an id, limit, cursor and user information with stored cards.
  func fetchCommentReplies(
    id: String,
    cursor: String?,
    limit: Int
  ) -> SignalProducer<CommentRepliesEnvelope, ErrorEnvelope>

  /// Posts a comment to a project or replies in a thread.
  func postComment(input: PostCommentInput)
    -> SignalProducer<Comment, ErrorEnvelope>

  /// Fetches all of the messages in a particular message thread.
  func fetchMessageThread(messageThreadId: Int)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope>

  /// Fetches all of the messages related to a particular backing.
  func fetchMessageThread(backing: Backing) -> SignalProducer<MessageThreadEnvelope?, ErrorEnvelope>

  /// Fetches all of the messages in a particular mailbox and specific to a particular project.
  func fetchMessageThreads(mailbox: Mailbox, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Fetches more messages threads from a pagination URL.
  func fetchMessageThreads(paginationUrl: String)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Marks all the messages in a particular thread as read.
  func markAsRead(messageThread: MessageThread) -> SignalProducer<MessageThread, ErrorEnvelope>

  /// Searches all of the messages, (optionally) bucketed to a specific project.
  func searchMessages(query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Sends a message to a subject, i.e. creator project, message thread, backer of backing.
  func sendMessage(body: String, toSubject subject: MessageSubject)
    -> SignalProducer<Message, ErrorEnvelope>
}

