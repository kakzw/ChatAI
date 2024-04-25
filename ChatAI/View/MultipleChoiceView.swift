//
//  MultipleChoiceView.swift
//  ChatAI
//
//  Created by Kento Akazawa on 4/25/24.
//

import SwiftUI

// MARK: - MultipleChoiceView

struct MultipleChoiceView: View {
  @ObservedObject var viewModel = MultipleChoiceViewModel.shared
  @State var questionNumber = 0
  @State var showAnswer = false
  
  var body: some View {
    VStack {
      TitleBar()
      
      // Questions and choices
      QuestionTextView(questionNumber: $questionNumber, showAnswer: $showAnswer)
        .padding(.horizontal)
      
      Spacer()
      
      HStack {
        // if there is previous question
        // display back button
        if questionNumber > 0 {
          BackButton {
            showAnswer = false
            questionNumber -= 1
          }
        }
        Spacer()
        // if there is more questions
        // dispaly next button
        if questionNumber + 1 < viewModel.questions.count {
          NextButton {
            showAnswer = false
            questionNumber += 1
          }
        }
      }
      .padding(.horizontal)
    }
    .font(.title3)
  }
}

// MARK: - QuestionTextView

struct QuestionTextView: View {
  @ObservedObject var viewModel = MultipleChoiceViewModel.shared
  @Binding var questionNumber: Int
  @Binding var showAnswer: Bool
  
  var body: some View {
    if questionNumber < viewModel.questions.count {
      let question = viewModel.questions[questionNumber]
      
      HStack {
        Text(question.question)
        Spacer()
      }
      
      Spacer()
      
      ForEach(question.choices, id: \.self) { choice in
        ChoiceView(choice: choice,
                   correct: doesFirstCharMatch(choice, and: question.answer),
                   questionNumber: questionNumber,
                   showAnswer: $showAnswer)
      }
    } else {
      VStack {
        Text("No questions")
        Spacer()
      }
    }
  }
  
  // returns true if first character match
  private func doesFirstCharMatch(_ s1: String, and s2: String) -> Bool {
    let tmp1 = s1.trimmingCharacters(in: .whitespaces)
    let tmp2 = s2.trimmingCharacters(in: .whitespaces)
    guard let c1 = tmp1.first, let c2 = tmp2.first else {
      return false
    }
    return c1 == c2
  }
}

// MARK: - ChoiceView

struct ChoiceView: View {
  @ObservedObject var viewModel = MultipleChoiceViewModel.shared
  var choice: String
  var correct: Bool
  var questionNumber: Int
  @Binding var showAnswer: Bool
  
  @State var wrong = false
  
  var body: some View {
    HStack {
      Text(choice)
        .padding()
      // if showAnswer and correct, display the text in green bold
      // if showAnswer and red, display in red bold
      // otherwise black text
        .foregroundColor(showAnswer ? (correct ? .green : (wrong ? .red : .black)) : .black)
        .fontWeight((correct && showAnswer) ? .bold : .regular)
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .overlay {
      RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1)
    }
    .onTapGesture {
      // only allowed to tap one option
      if !showAnswer {
        showAnswer = true
        if !correct { wrong = true }
      }
    }
  }
}

// MARK: - TitleText

struct TitleBar: View {
  @ObservedObject var viewModel = MultipleChoiceViewModel.shared
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.orange)
        .edgesIgnoringSafeArea(.top)
      
      HStack {
        Button { } label: {
          Image(systemName: "plus.message")
            .font(.title)
            .opacity(0)
        }
        
        Spacer()
        
        Text("ChatAI")
          .font(.largeTitle)
          .bold()
          .foregroundStyle(Color.white)
        
        Spacer()
        
        // button to go back to ChatView
        Button {
          // displays ChatView when @viewModel.done is false
          viewModel.done = false
        } label: {
          Image(systemName: "plus.message")
            .font(.title)
            .foregroundStyle(Color.white)
        }
      }
      .padding(.top, 20)
      .padding(.bottom, 10)
      .padding(.horizontal)
    }
    .frame(maxHeight: 60)
  }
}

// MARK: - BackButton

struct BackButton: View {
  var action: () -> Void
  
  var body: some View {
    HStack {
      Image(systemName: "chevron.left")
      Text("Back")
    }
    .bold()
    .foregroundColor(.blue)
    .onTapGesture {
      action()
    }
  }
}

// MARK: - NextButton

struct NextButton: View {
  var action: () -> Void
  
  var body: some View {
    HStack {
      Text("Next")
      Image(systemName: "chevron.right")
    }
    .bold()
    .foregroundColor(.blue)
    .onTapGesture {
      action()
    }
  }
}

#Preview {
  MultipleChoiceView()
}
