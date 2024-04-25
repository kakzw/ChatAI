//
//  OpenAIService.swift
//  ChatAI
//
//  Created by Kento Akazawa on 4/25/24.
//

import SwiftUI
import Alamofire

class OpenAIService {
  private let endpoint = Constants.endpoint
  
  func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
    // sends only necessary information
    let openAIMessages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content) })
    let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(Constants.apikey)"
    ]
    return try? await AF.request(endpoint, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
  }
}

struct OpenAIChatBody: Encodable {
  let model: String
  let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
  let role: SenderRole
  let content: String
}

enum SenderRole: String, Codable {
  case system
  case user
  case assistant
}

struct OpenAIChatResponse: Decodable {
  let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
  let message: OpenAIChatMessage
}
