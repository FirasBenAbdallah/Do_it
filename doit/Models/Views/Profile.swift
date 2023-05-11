//
//  Profile.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI

var savedPhone: String?
struct Profile: View {
    @State private var isDarkModeEnabled = false
    @State private var isShareSheetShowing = false
    
    @State private var selectedLanguage = "en"
    private let languages = ["en", "fr", "ar"]

    func showShareSheet() {
        isShareSheetShowing = true
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Informations personnelles")) {
                    ProfileRow(title: "Photo de profil", imageName: "profile")
                    ProfileRow(title: "Photo de couverture", imageName: "cover")
                    Button(action: {
                        showShareSheet()
                    })
                    {
                        HStack {
                            Text("Setting")
                                .foregroundColor(Color.black)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.black)
                        }
                    }.sheet(isPresented: $isShareSheetShowing) {
                        ShareSheet(activityItems: ["I just achieved my goal!"], applicationActivities: nil)
                    }
                }
                Section(header: Text("Autres")) {
                    ProfileRow(title: "Aide", imageName: "questionmark.circle")
                 //   ProfileRow(title: "Déconnexion", imageName: "arrow.right.square")
                    Toggle("Mode sombre", isOn: $isDarkModeEnabled)
                        .onChange(of: isDarkModeEnabled) { newValue in
                            if newValue {
                                UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .flatMap { $0.windows }
                                    .first?
                                    .overrideUserInterfaceStyle = .dark
                            } else {
                                UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .flatMap { $0.windows }
                                    .first?
                                    .overrideUserInterfaceStyle = .light
                            }
                        }
                    NavigationLink(destination: LanguageView()) {
                        ProfileRow(title: "Langues", imageName: "globe")
                        
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        ProfileRow(title: "Rate us", imageName: "star")
                        
                    }
                    
                }
                /*Button("Change Language") {
                    let currentLang = Locale.current.language.languageCode?.identifier
                            print("current Lang: \(currentLang ?? "")")
                            let newLanguage = currentLang == "en" ? "fr" : "en"
                            UserDefaults.standard.setValue([newLanguage], forKey: "AppleLanguages")
                            exit(0)
                        }*/
                /*Button("Change Language") {
                    var newLanguage = "en"
                    switch Locale.current.language.languageCode?.identifier {
                    case "en":
                        newLanguage = "fr"
                    case "fr":
                        newLanguage = "ar"
                    case "ar":
                        newLanguage = "en"
                    default:
                        break
                    }
                    
                    UserDefaults.standard.setValue([newLanguage], forKey: "AppleLanguages")
                    exit(0)
                }*/
                VStack {
                            //Text("")
                            Picker(selection: $selectedLanguage, label: Text("Select a language:")) {
                                ForEach(languages, id: \.self) { language in
                                    Text(language)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            Button("Apply") {
                                UserDefaults.standard.setValue([selectedLanguage], forKey: "AppleLanguages")
                                exit(0)
                            }.foregroundColor(.black)
                        }
                
                Button(action: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    //logout()

                    
                }, label: {
                    Label("LogOut", systemImage: "power")
                        .font(.headline)
                        .foregroundColor(.black)
                })
            }.navigationTitle("Profil")
        }
    }
    static func processPassword(_ password: String) {
            // Do something with the password here
            savedPhone = password
            print("Received password: \(password)")
        }
}
/*func logout() {
        // Set the URL of your Node.js server
        guard let url = URL(string: "http://172.17.6.45:3000/logout") else { return }

    
        // Set the parameters of your request
    let params = ["phone":savedPhone]
        guard let body = try? JSONSerialization.data(withJSONObject: params) else { return }

        // Create the request and set the HTTP method to POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body

        // Set the content type of the request to JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Send the request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check the status code of the response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if (200...201).contains(httpResponse.statusCode) {
                // Success: handle the response data here
                print("Logout")
                DispatchQueue.main.async {
                    // update the user interface here
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    //.present(viewController, animated: true, completion: nil)
                }
                
            } else {
                // Error: handle the response error here
                print("Error: \(httpResponse.statusCode)")
            }
        }.resume()
    }
*/
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
