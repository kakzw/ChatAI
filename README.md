# ChatAI Application

This is an iOS app that allows users to interact with OpenAI's GPT-3.5 model to generate multiple-choice questions based on a given topic. The app utilizes SwiftUI for the user interface and integrates with Alamofire for making network requests to the OpenAI API.

## Features

- User can enter a topic to generate multiple-choice questions.
- Questions are generated based on the input topic using OpenAI's GPT-3.5 model.
- Users can interact with the generated questions and view the corresponding choices.
- The app provides a user-friendly interface for seamless interaction.

## Screenshots

<img src="https://github.com/kakzw/PasswordManager/assets/167830553/7079dc18-89a0-40c6-872c-71cf22208650" width="300">
<img src="https://github.com/kakzw/PasswordManager/assets/167830553/e658cecb-2489-4dd0-bc66-2a65b2d90a02" width="300">
<img src="https://github.com/kakzw/PasswordManager/assets/167830553/0e023b71-d0a7-45b2-8b5b-349cbd6aea82" width="300">
<img src="https://github.com/kakzw/PasswordManager/assets/167830553/0755ccd2-f406-45e3-852b-19da6a31d8ca" width="300">
<img src="https://github.com/kakzw/PasswordManager/assets/167830553/43edafb6-0544-426a-b50e-3fb9346f3d94" width="300">

## Installation

- To run this app, make sure you have `XCode` installed.
- Clone this repository.
- Open `ChatAI.xcodeproj` in `XCode`.
- Open `constants.swift` and enter your API key for `OpenAI`. Please visit <a href="https://openai.com/blog/openai-api">here</a> to obtain API key.
  <img width="700" alt="constants" src="https://github.com/kakzw/PasswordManager/assets/167830553/71881f4b-a8d1-4e88-8514-ca1a4fbaed2c">
- Build and run the app on your iOS device or simulator.

## Usage

1. Launch the ChatAI app on your iOS device.
2. Enter a topic in the text field.
3. Tap the send button to submit the topic and generate multiple-choice questions.
4. Interact with the generated questions and view the choices.
5. Tap on the choices to view the correct answer.
6. Tap on new chat button to create new multiple choices for view previous questions.
7. To try previous qustions again, simply tap on the response.

## Dependencies

- **OpenAI**: For providing the GPT-3.5 model used in this project.
- **Alamofire**: Used for making HTTP requests to the OpenAI API.
