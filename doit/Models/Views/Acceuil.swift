//
//  Acceuil.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI

struct Acceuil: View {
    @State private var title: [String] = []
    @State private var isMenuOpen = false
    @State var results = [TaskEntry]()

    var body: some View {
            NavigationView {
                ZStack {
                   Color("Background")
                        .edgesIgnoringSafeArea(.all).toolbarBackground(Color.white, for: .navigationBar)
                    if isMenuOpen {
                        // Menu content
                        VStack(alignment: .leading, spacing: 20) {
                            Image("Profile")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            
                            Text("John Doe")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                            
                            Divider()
                                .background(Color.white)
                            
                            NavigationLink(
                                destination: Text("Settings"),
                                label: {
                                    Label("Settings", systemImage: "gear")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            )
                            
                            NavigationLink(
                                destination: AboutView(),
                                label: {
                                    Label("About", systemImage: "info.circle")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            )
                            
                            Spacer()
                            
                            Button(action: {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                                UIApplication.shared.windows.first?.rootViewController = viewController
                            }, label: {
                                Label("LogOut", systemImage: "power")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            })
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("Menu"))
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                    }
                    /*VStack {
                        List {
                            ForEach(title, id: \.self) { title in
                                VStack(alignment: .leading) {
                                    Text(title).foregroundColor(.black)
                                }
                                Spacer()
                            }
                        }
                    }.onAppear(perform: getGuests)*/
                    VStack {
                        List(title, id: \.self) { title in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(title)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding()
                            .background(Color(red: 255/255, green: 244/255, blue: 229/255, opacity: 1.0))
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.gray.opacity(0.1))
                    .onAppear(perform: getGuests)


            
                    /*NavigationView {
                                List {
                                    ForEach(publications) { publication in
                                        VStack(alignment: .leading, spacing: 16) {
                                            HStack(alignment: .top, spacing: 16) {
                                            Image(publication.friendImageName)
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(Circle())
                                                Text(publication.friendName)
                                                    .font(.headline)
                                            }
                                            Text(publication.content)
                                                .font(.body)
                                            Image(publication.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 200)
                                                .clipped()
                                            HStack (alignment: .top, spacing: 16){
                                                Image(systemName: "hand.thumbsup")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 30))
                                                    Spacer()
                                                Image(systemName: "hand.thumbsdown")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 30))
                                                Spacer()
                                                Image(systemName: "text.bubble")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 30))
                                                Spacer()
                                                Image(systemName: "arrowshape.turn.up.right")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 30))
                                                Spacer()

                                            }.padding(.horizontal)
                                        }
                                    }
                                }
                            .navigationBarTitle("Publications")
                            }*/
                }
                .navigationBarTitle("Do it !")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                }, label: {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.primary)
                }))

            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getGuests() {
        title = []
        fetchGuest() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self.results = events
                    print("Events: \(events)")
                    print("Results: \(self.results)")
                case .failure(_):
                    return
                }
            }
        }
    }

    func fetchGuest(completion: @escaping(Result<[TaskEntry],APIError>) -> Void) {
        let url = URL(string : "http://172.17.6.45:3000/getevent")
        fetch2(type: [TaskEntry].self, url: url, completion: completion)
    }
    

    func fetch2<T: Decodable>(type: T.Type, url: URL?, completion: @escaping(Result<T,APIError>) -> Void) {
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                completion(Result.failure(APIError.urlSession(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(response.statusCode)))
            } else if let data = data {
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString?.data(using: .utf8)!

                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData!, options: [])
                    if let dictionary = jsonObject as? [String: Any] {
                        if let eventsArray = dictionary["events"] as? [[String: Any]] {
                            for event in eventsArray {
                                if let eventName = event["name"] as? String, let eventAddress = event["address"] as? String, let eventDescription = event["description"] as? String, let eventStart = event["start"] as? String, let eventEnd = event["end"] as? String {
                                    /*let eventTitle = "\(eventName) - \(eventAddress) - \(eventDescription) \n\(eventStart) - \(eventEnd)"*/
                                    let eventTitle = "\(eventName) \t-\t \(eventAddress)\n\n\(eventDescription)\n\n\(eventStart) \t-\t \(eventEnd)"
                                    title.append(eventTitle)
                                }
                            }
                        }
                    }
                } catch let error {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    completion(Result.success(result))
                } catch {
                    completion(Result.failure(.decoding(error as? DecodingError)))
                }
            }
        }.resume()
    }

    
}


enum APIError: Error, CustomStringConvertible {
    
    case badURL
    case urlSession(URLError?)
    case badResponse(Int)
    case decoding(DecodingError?)
    case unknown
    
    var description: String {
        switch self {
            case .badURL:
                return "badURL"
            case .urlSession(let error):
                return "urlSession error: \(error.debugDescription)"
            case .badResponse(let statusCode):
                return "bad response with status code: \(statusCode)"
            case .decoding(let decodingError):
                return "decoding error: \(decodingError)"
            case .unknown:
                return "unknown error"
        }
    }
    
    var localizedDescription: String {
        switch self {
            case .badURL, .unknown:
               return "something went wrong"
            case .urlSession(let urlError):
                return urlError?.localizedDescription ?? "something went wrong"
            case .badResponse(_):
                return "something went wrong"
            case .decoding(let decodingError):
                return decodingError?.localizedDescription ?? "something went wrong"
        }
    }
}

struct Acceuil_Previews: PreviewProvider {
    static var previews: some View {
        Acceuil()
    }
}





   


