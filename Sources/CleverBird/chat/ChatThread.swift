import Foundation

public typealias Logger = (String) -> Void

public class ChatThread {

    private static let DEFAULT_LOGGER: Logger = { message in
        print(message)
    }

    let connection: OpenAIAPIConnection
    let model: Model
    let temperature: Percentage
    let topP: Percentage?
    let stop: [String]?
    let presencePenalty: Penalty?
    let frequencyPenalty: Penalty?
    let user: String?
    let logger: Logger

    var messages: [ChatMessage] = []

    public init(connection: OpenAIAPIConnection,
                model: Model = .gpt4,
                temperature: Percentage = 0.7,
                topP: Percentage? = nil,
                numberOfCompletionsToCreate: Int? = nil,
                stop: [String]? = nil,
                presencePenalty: Penalty? = nil,
                frequencyPenalty: Penalty? = nil,
                user: String? = nil,
                logger: Logger? = nil) {
        self.connection = connection
        self.model = model
        self.temperature = temperature
        self.topP = topP
        self.stop = stop
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.user = user
        self.logger = logger ?? Self.DEFAULT_LOGGER
    }

    public func addSystemMessage(_ content: String) -> Self {
        addMessage(ChatMessage(role: .system, content: content))
    }

    public func addUserMessage(_ content: String) -> Self {
        addMessage(ChatMessage(role: .user, content: content))
    }

    public func addAssistantMessage(_ content: String) -> Self {
        addMessage(ChatMessage(role: .assistant, content: content))
    }

    public func addMessage(_ message: ChatMessage) -> Self {
        messages.append(message)
        return self
    }

    public func getMessages() -> [ChatMessage] {
        messages
    }

    public func getNonSystemMessages() -> [ChatMessage] {
        messages.filter { $0.role != .system }
    }
}