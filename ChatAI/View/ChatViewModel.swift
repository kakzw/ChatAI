//
//  ChatViewModel.swift
//  ChatAI
//
//  Created by Kento Akazawa on 4/25/24.
//

import SwiftUI

// View model for ChatView
class ChatViewModel: ObservableObject {
  @Published var messages: [Message] = []
  @Published var currentInput: String = ""
  @Published var isLoading = false
  @Published var multipleChoiceModel = MultipleChoiceViewModel.shared
  @Published private(set) var lastMessageId = UUID()
  
  private let openAIService = OpenAIService()
  
  func sendMessage() {
    isLoading = true
    // text to display for user input
    currentInput = "Create multiple choice questions on \(currentInput)"
    let displayingContent = currentInput
    // add more specific prompt to get response in specific format
    currentInput = "\(currentInput) and its answers with questions header 'Questions', questions and choices, answers header 'Answers', and answers. Nothing else. Each question should start with a question number and each option should start with a), b), and so on. Each answer should start with answer character. "
    let newMessage = Message(id: UUID(), role: .user, displayingContent: displayingContent, content: currentInput, createAt: Date(), questions: [])
    lastMessageId = newMessage.id
    // add new message to @messages so that all messages can be displayed
    messages.append(newMessage)
    // reset the text field text to empty string
    currentInput = ""
    
    Task {
      let response = await openAIService.sendMessage(messages: messages)
      guard let receivedOpenAIMessage = response?.choices.first?.message else {
        print("Had no received message")
        isLoading = false
        return
      }
      await MainActor.run {
        let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, displayingContent: receivedOpenAIMessage.content, content: receivedOpenAIMessage.content, createAt: Date(), questions: multipleChoiceModel.createQuestions(from: receivedOpenAIMessage.content))
        lastMessageId = receivedMessage.id
        messages.append(receivedMessage)
        for m in receivedMessage.content.components(separatedBy: "\n") {
          print(m)
        }
        isLoading = false
      }
    }
  }
}

// Message structure for both user input and response
struct Message: Decodable {
  let id: UUID
  let role: SenderRole
  // displaying content for user input is different from content
  // since content includes more specific instruction to ChatGPT
  // to get response in certain format
  let displayingContent: String
  let content: String
  let createAt: Date
  let questions: [Question]
}
