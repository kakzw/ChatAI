//
//  MultipleChoiceModel.swift
//  ChatAI
//
//  Created by Kento Akazawa on 4/25/24.
//

import SwiftUI

class MultipleChoiceViewModel: ObservableObject {
  // Singleton instance
  static let shared = MultipleChoiceViewModel()
  
  @Published var questions = [Question]()
  @Published var done = false
  
  // create questions from @input
  // @param input - response from API
  func createQuestions(from input: String) -> [Question] {
    questions = []
    done = false
    let response: [String] = input.components(separatedBy: "\n")
    var isAnswer = false
    var isQuestion = false
    var question = ""
    var choices = [String]()
    
    var answerIndex = 0
    
    // iterate through each line of response
    // and divide into questions, choices, and answers
    for t in response {
      if t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
          || t.containsRegex(pattern: "Questions") {
        // question header or empty line
      } else if t.containsRegex(pattern: "Answers") && !isAnswer {
        // answer header
        isAnswer = true
        questions.append(Question(question: question, choices: choices))
      } else if isAnswer {
        // answer
        var tmp = filterText(#"^\d+\."#, from: t)
        tmp = filterText("^Answer:", from: tmp)
        questions[answerIndex].answer = tmp
        answerIndex += 1
      } else if t.containsRegex(pattern: #"^\d+\."#) {
        // first line of question
        if !choices.isEmpty {
          questions.append(Question(question: question, choices: choices))
          choices = []
        }
        question = t
        isQuestion = true
      } else if isQuestion && !t.containsRegex(pattern: #"^a\)"#) {
        // part of question
        // Note: all choices start with 'a)'
        question += "\n  " + t
      } else {
        // choices
        choices.append(t)
        isQuestion = false
      }
    }
    done = true
    return questions
  }
  
  // filters out @pattern from @text
  private func filterText(_ pattern: String, from text: String) -> String {
    var res = ""
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      res = regex.stringByReplacingMatches(in: text,
                                           range: NSRange(location: 0,length: text.utf16.count),
                                           withTemplate: "")
    } catch {
      res = text
    }
    // remove all starting and ending white spaces
    return res.trimmingCharacters(in: .whitespaces)
  }
}

struct Question: Decodable {
  let question: String
  let choices: [String]
  var answer: String = ""
}

extension String {
  // check if certain string contains @pattern using regular expression
  func containsRegex(pattern: String) -> Bool {
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let range = NSRange(location: 0, length: self.utf16.count)
      return regex.firstMatch(in: self, options: [], range: range) != nil
    } catch {
      print("Error creating regular expression: \(error.localizedDescription)")
      return false
    }
  }
}
