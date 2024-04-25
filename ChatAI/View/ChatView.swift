//
//  ContentView.swift
//  ChatAI
//
//  Created by Kento Akazawa on 4/25/24.
//

import SwiftUI

// MARK: - ChatView

struct ChatView: View {
  @ObservedObject var viewModel = ChatViewModel()
  @ObservedObject var multipleChoiceModel = MultipleChoiceViewModel.shared
  
  var body: some View {
    ZStack {
      VStack {
        if multipleChoiceModel.done {
          MultipleChoiceView()
        } else {
          TitleTextView()
          // display all the messages from user and response
          ScrollViewReader { proxy in
            ScrollView {
              ForEach(viewModel.messages.filter({ $0.role != .system } ), id: \.id) { message in
                messageView(message: message)
              }
            }
            .onAppear {
              // display latest message
              proxy.scrollTo(viewModel.lastMessageId)
            }
            .onChange(of: viewModel.lastMessageId) { oldId, newId in
              // display latest message
              proxy.scrollTo(newId, anchor: .bottom)
            }
          }
          .padding(.horizontal)
          
          // text field where topic can be entered
          TextView(viewModel: viewModel)
            .padding()
        }
      }
      .font(.title3)
      
      // display loading view
      // while getting response from API
      if viewModel.isLoading {
        LoadingView()
      }
    }
  }
  
  // message that user typed and
  // response from ChatGPT
  func messageView(message: Message) -> some View {
    // display on right for user message
    // display on left for response message
    ChatBubble(direction: message.role == .user ? .right : .left, content: {
      Text(message.displayingContent)
        .padding(12)
        .onTapGesture {
          // if response is tapped
          // redo those multiple those questions
          if message.role == .assistant {
            // set the questions to questions in that response
            multipleChoiceModel.questions = message.questions
            // MultipleChoiceView will be displayed
            // when @multipleChoiceModel.done is true
            multipleChoiceModel.done = true
          }
        }
    })
  }
}

// MARK: - TextView

struct TextView: View {
  @ObservedObject var viewModel: ChatViewModel
  
  var body: some View {
    HStack {
      // where user can enter topic to make multiple questions on
      TextField("Topic", text: $viewModel.currentInput)
        .textInputAutocapitalization(.never)
        .onSubmit {
          // when the user hit enter
          // send currently entered message
          if viewModel.currentInput != "" {
            viewModel.sendMessage()
          }
        }
      
      // if the user typed something
      // display a button to delete all text
      // that has been entered
      if viewModel.currentInput != ""{
        Button(action: {
          // delete the text
          viewModel.currentInput = ""
        }, label: {
          Image(systemName: "delete.left")
            .foregroundColor(.secondary)
        })
      }
      
      // button to send message
      Button(action: {
        // sends currently entered message
        viewModel.sendMessage()
      }, label: {
        Image(systemName: "paperplane.fill")
      })
      // cannot tap if nothing is entered
      .disabled(viewModel.currentInput == "")
    }
    .padding(8)
    .padding(.horizontal, 4)
    .overlay {
      // rounded rectable around text
      RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1)
    }
  }
}

// MARK: - LoadingView

struct LoadingView: View {
  var body: some View {
    ZStack {
      // make the background blury
      Color(.secondarySystemBackground)
        .ignoresSafeArea()
        .opacity(0.9)
      
      VStack {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
          .scaleEffect(5)
        
        Spacer()
          .frame(height: 50)
        
        Text("Generating Questions...")
          .font(.title2)
          .bold()
          .foregroundColor(.black)
      }
    }
  }
}

// MARK: - TitleTextView

struct TitleTextView: View {
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.orange)
        .edgesIgnoringSafeArea(.top)
      
      Text("ChatAI")
        .font(.largeTitle)
        .bold()
        .foregroundStyle(Color.white)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    .frame(maxHeight: 60)
  }
}

#Preview {
  ChatView()
}
