//
//  ContentView2.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI
import Social
import UIKit


struct ContentView2: View {
    @State private var isShareSheetShowing = false

    func showShareSheet() {
        isShareSheetShowing = true
    }

    @State private var selection = 0
    var body: some View {
        Button(action: {
            showShareSheet()
        }) {
            Text("Share Goal")
        }.sheet(isPresented: $isShareSheetShowing) {
            ShareSheet(activityItems: ["I just achieved my goal!"], applicationActivities: nil)
        }
        TabView(selection: $selection) {
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profil")
                }
                .tag(3)
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(1)
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
                .tag(2)
        }
    }
}




struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Informations personnelles")) {
                    ProfileRow(title: "Photo de profil", imageName: "profile")
                    ProfileRow(title: "Photo de couverture", imageName: "cover")
                    NavigationLink(destination: SettingsView()) {
                        ProfileRow(title: "Paramètres", imageName: "gear")
                    }
                }
                Section(header: Text("Autres")) {
                    ProfileRow(title: "Aide", imageName: "questionmark.circle")
                    ProfileRow(title: "Déconnexion", imageName: "arrow.right.square")
                    Toggle("Mode sombre", isOn: .constant(false))
                    NavigationLink(destination: LanguageView()) {
                        ProfileRow(title: "Langues", imageName: "globe")
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}


struct ChatBubble: View {
    
    let text: String
    
    var body: some View {
        HStack {
            if isMe() {
                Spacer()
                
                Text(text)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(8)
            } else {
                Text(text)
                    .padding(12)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(8)
                
                Spacer()
            }
        }
    }
    
    private func isMe() -> Bool {
        // Return true if message is sent by me
        return text.count % 2 == 0
    }
}


struct ProfileRow: View {
    var title: String
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.headline)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

struct User: Codable {
    let name: String
    let email: String
}

class UserService {
    func getUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3000/getuser")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
                print("hi \(users)")
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

struct SettingsView: View {
    @State var users: [User] = []
    let userService = UserService()
    
    var body: some View {
        Text("Paramètres")
            .navigationTitle("Paramètres")
        List(users, id: \.email) { user in
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
            }
        }
        .onAppear {
            userService.getUsers { users, error in
                if let users = users {
                    self.users = users
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}




struct LanguageView: View {
    @State private var selectedLanguage = "en"
    var body: some View {
        VStack {
            Text("Language")
                .font(.title)
                .padding()
            /*Picker("Select language", selection: $selectedLanguage.onChange(changeLanguage)) {
             Text("English").tag("en")
             Text("Français").tag("fr")
             Text("العربية").tag("ar")
             Text("中文").tag("zh")
             }*/
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            Text("Hello, world!")
                .padding()
        }
        .onAppear {
            if let language = UserDefaults.standard.string(forKey: "selectedLanguage") {
                selectedLanguage = language
            }
        }
    }
    
    private func changeLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            print("Could not find path for language: \(language)")
            return
        }
        
        let selectedBundle = Bundle(path: path)
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
        Bundle.setLanguage(language)
        guard let bundle = selectedBundle else {
            print("Could not create bundle for language: \(language)")
            return
        }
        // Localize the strings
        // example:
        let localizedString = NSLocalizedString("Hello, world!", bundle: bundle, comment: "")
        print(localizedString)
    }
}

extension Bundle {
    static func setLanguage(_ language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

struct NotificationsView: View {
    var body: some View {
        List(notifications) { notification in
            NotificationRow(notification: notification)
        }
    }
}

struct NotificationRow: View {
    var notification: NotificationItem
    var body: some View {
        HStack {
            Image(notification.friend.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            VStack(alignment: .leading) {
                Text(notification.friend.name)
                    .font(.headline)
                Text(notification.title)
                    .font(.subheadline)
                Text(notification.time)
                    .font(.caption)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}



struct NotificationItem: Identifiable {
    var id = UUID()
    var friend: Friend
    var title: String
    var time: String
}



let notifications = [
    NotificationItem(friend: Friend(name: "Sarah", imageName: "sarah"), title: "a aimé votre publication", time: "il y a 3 minutes"),
    NotificationItem(friend: Friend(name: "John", imageName: "john"), title: "a commenté votre publication", time: "il y a 15 minutes"),
    NotificationItem(friend: Friend(name: "Jessica", imageName: "jessica"), title: "a partagé votre publication", time: "il y a 1 heure")
]

struct Friend {
    var name: String
    var imageName: String
}


struct Publication: Identifiable {
    
    let id = UUID()
    
    let friendName: String
    
    let friendImageName: String
    
    let content: String
    
    let imageName: String
    
}



let publications = [    Publication(friendName: "John Doe", friendImageName: "friend1", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet ultricies velit. Phasellus ultricies lacus odio, nec dignissim justo imperdiet vel.", imageName: "post1"),    Publication(friendName: "Jane Smith", friendImageName: "friend2", content: "Mauris interdum ipsum ac massa tincidunt iaculis. Vestibulum sit amet dui vel ex fringilla dictum quis sed felis.", imageName: "post2"),    Publication(friendName: "Bob Johnson", friendImageName: "friend3", content: "Donec nec purus ornare, dapibus elit vel, imperdiet velit. Nullam condimentum est a urna vestibulum, sit amet scelerisque lorem suscipit.", imageName: "post3")]
struct ChatView: View {

    var friends = [        Friend(name: "John", imageName: "person1", lastMessage: "Hello!", lastMessageDate: Date()),        Friend(name: "Jane", imageName: "person2", lastMessage: "How are you?", lastMessageDate: Date()),        Friend(name: "Bob", imageName: "person3", lastMessage: "See you later", lastMessageDate: Date())    ]
    var body: some View {
        NavigationView {
            List(friends) { friend in
                NavigationLink(destination: ChatDetailView(friend: friend)) {
                    FriendRow(friend: friend)
                }
            }
            .navigationBarTitle(Text("Friends"))
        }
    }
 
    struct FriendRow: View {
        
        var friend: Friend
        
        
        
        var body: some View {
            
            HStack(spacing: 12) {
                
                Image(friend.imageName)
                
                    .resizable()
                
                    .aspectRatio(contentMode: .fill)
                
                    .frame(width: 50, height: 50)
                
                    .clipShape(Circle())
                
                
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(friend.name)
                    
                        .font(.headline)
                    
                    
                    
                    Text(friend.lastMessage)
                    
                        .font(.subheadline)
                    
                        .foregroundColor(.gray)
                    
                }
                
                
                
                Spacer()
                
                
                
                VStack(alignment: .trailing, spacing: 4) {
                    
                    Text(friend.lastMessageDate, style: .time)
                    
                        .font(.caption)
                    
                    
                    
                    Text(friend.lastMessageDate, style: .date)
                    
                        .font(.caption)
                    
                }
                
            }
            
            .padding(.vertical, 8)
            
        }
        
    }
    

    struct Friend: Identifiable{
        
        let id = UUID()
        
        var name: String
        
        var imageName: String
        
        var lastMessage: String
        
        var lastMessageDate: Date
        
    }
    
    
    
    /*
     
     struct MessageView: View {
     
     let message: Message
     
     
     
     var body: some View {
     
     HStack {
     
     if message.isSentByCurrentUser {
     
     Spacer()
     
     Text(message.text)
     
     .padding()
     
     .background(Color.blue)
     
     .foregroundColor(.white)
     
     .clipShape(RoundedRectangle(cornerRadius: 8))
     
     } else {
     
     Image(message.senderImageName)
     
     .resizable()
     
     .scaledToFit()
     
     .clipShape(Circle())
     
     .frame(width: 50, height: 50)
     
     Text(message.text)
     
     .padding()
     
     .background(Color.gray)
     
     .foregroundColor(.white)
     
     .clipShape(RoundedRectangle(cornerRadius: 8))
     
     Spacer()
     
     }
     
     }
     
     }
     
     }
     
     
     
     struct Message: Identifiable {
     
     let id = UUID()
     
     let text: String
     
     let date: Date
     
     let senderImageName: String
     
     let isSentByCurrentUser: Bool
     
     
     
     init(text: String, date: Date, senderImageName: String = "user", isSentByCurrentUser: Bool = true) {
     
     self.text = text
     
     self.date = date
     
     self.senderImageName = senderImageName
     
     self.isSentByCurrentUser = isSentByCurrentUser
     
     }
     
     }*/
    struct Message : Identifiable{

            let id = UUID()

            let content: String

            let isMe: Bool

        }

        struct ChatDetailView: View {

            @State private var messageText = ""

            @State private var messages: [Message] = []



            var friend: Friend



            var body: some View {

                VStack {

                    HStack {

                        Image(friend.imageName)

                            .resizable()

                            .aspectRatio(contentMode: .fill)

                            .frame(width: 50, height: 50)

                            .clipShape(Circle())

                        Text(friend.name)

                            .font(.headline)

                        Spacer()

                    }

                    .padding()

                    List {

                        ForEach(messages) { message in

                            Text(message.content)

                                .foregroundColor(message.isMe ? .white : .black)

                                .padding(10)

                                .background(message.isMe ? Color.blue : Color.gray.opacity(0.1))

                                .cornerRadius(10)

                        }

                    }

                    HStack {

                        TextField("Type a message...", text: $messageText)

                            .padding(10)

                            .background(Color.gray.opacity(0.1))

                            .cornerRadius(20)

                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

                            .frame(height: 50)

                        Button(action: sendMessage) {

                            Text("Send")

                                .foregroundColor(.blue)

                        }

                        .padding(.trailing, 20)

                    }

                    .background(Color.white)

                    .frame(height: 60)

                }

                .navigationBarTitle(Text(friend.name), displayMode: .inline)

            }



            func sendMessage() {

                let newMessage = Message(content: messageText, isMe: true)

                messages.append(newMessage)

                messageText = ""

            }

        }
}


struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
