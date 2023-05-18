import SwiftUI


struct TaskEntry1: Codable {
    var name_user: String
    var comment: String
}

struct CommentListView: View {
    
    @State private var comments: [TaskEntry1] = []
    @State private var newCommentName: String = ""
    @State private var newCommentContent: String = ""
    @State var commentsStatic: [(name: String, content: String)] = []
    
    var body: some View {
        VStack {
            TextField("Your comment", text: $newCommentContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                sendComment()
                commentsStatic.append((name: newCommentName, content: newCommentContent))
                newCommentName = "Safwen"
                newCommentContent = ""
            }) {
                Text("Send")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(newCommentContent.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(30)
                    .padding(.horizontal)
            }
            List(comments, id: \.comment) { comment in
                VStack(alignment: .leading) {
                    Text(comment.name_user)
                        .font(.headline)
                    Text(comment.comment)
                        .font(.body)
                }
            }
            List(commentsStatic, id: \.content) { comment in
                VStack(alignment: .leading) {
                    Text(comment.name)
                        .font(.headline)
                    Text(comment.content)
                        .font(.body)
                }
            }
        }
        .onAppear(perform: getComments)
    }
    func getComments() {
        guard let url = URL(string: "http://172.17.3.120:3000/comment") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let fetchedComments = try JSONDecoder().decode([TaskEntry1].self, from: data)
                DispatchQueue.main.async {
                    self.comments = fetchedComments
                }
            } catch {
                print("Error decoding comments: \(error)")
            }
        }.resume()
    }
    func sendComment() {
        let payload: [String: Any] = [
            "name_user": newCommentName,
            "comment": newCommentContent
        ]
        guard let url = URL(string: "http://172.17.3.120:3000/comment") else {
            return
        }
        guard let payloadData = try? JSONSerialization.data(withJSONObject: payload) else {
            return
            
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payloadData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, error == nil else {
                return
            }
            if response.statusCode == 200 {
                
                // Comment sent successfully
            } else {
                // Error sending comment
            }
        }.resume()
    }
}
struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView()
    }
}
