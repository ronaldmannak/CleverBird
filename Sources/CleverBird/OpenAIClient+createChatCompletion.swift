//  Created by B.T. Franklin on 3/20/23

import Foundation

extension OpenAIClient {

    public func createChatCompletion(model: Model = .gpt4,
                                     messages: [[String:Any]],
                                     temperature: Percentage = 0.7,
                                     top_p: Percentage? = nil,
                                     numberOfCompletionsToCreate: Int? = nil,
                                     stop: [String]? = nil,
                                     presence_penalty: Penalty? = nil,
                                     frequency_penalty: Penalty? = nil,
                                     user: String? = nil
    ) async -> ChatCompletionResponse? {

        let openAIChatCompletionURL = URL(string: "https://api.openai.com/v1/chat/completions")
        var request = URLRequest(url: openAIChatCompletionURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
        if let organization = organization {
            request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
        }

        let httpBody: [String: Any?] = [
            "model": model.rawValue,
            "messages": messages,
            "temperature": temperature.value,
            "top_p": top_p?.value,
            "n": numberOfCompletionsToCreate,
            "stop": stop,
            "presence_penalty": presence_penalty?.value,
            "frequency_penalty": frequency_penalty?.value,
            "user": user
        ]

        let nonNilHttpBody = httpBody.compactMapValues { $0 }

        var httpBodyJson: Data

        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: nonNilHttpBody, options: .prettyPrinted)
        } catch {
            print("Unable to convert to JSON \(error)")
            return nil
        }

        request.httpBody = httpBodyJson
        do {
            let requestData = try await executeRequest(request: request, withSessionConfig: nil)
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let responseHandler = OpenAIResponseHandler()
            return responseHandler.decodeChatCompletionJson(jsonString: jsonStr)
        } catch {
            logger?("Error executing request: \(error.localizedDescription)")
            return nil
        }
    }

}

public struct ChatCompletionResponse: Codable {
    public let model: String
    public let choices: [ChatChoice]
}

public struct ChatChoice: Codable {
    public let message: ChatMessage
    public let index: Int

    private enum CodingKeys: String, CodingKey {
        case message
        case index
    }
}

public struct ChatMessage: Codable {
    public let role: String
    public let content: String
}
