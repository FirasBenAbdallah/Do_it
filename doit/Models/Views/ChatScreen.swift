//
//  ChatScreen.swift
//  doit
//
//  Created by FirasBenAbdallah on 19/4/2023.
//

import SwiftUI

struct ChatScreen: View {
    
    @State private var message = ""
    @State private var messages = ["Hi", "Hello", "How are you?"]
    
    var body: some View {
        VStack {
            /*ScrollView {
                ForEach(messages, id: \.self) { message in
                    /ChatBubble(text: message)
                }
            }*/
            
            HStack {
                TextField("Type a message...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
    }
    
    private func sendMessage() {
        if !message.isEmpty {
            messages.append(message)
            message = ""
        }
    }
}


